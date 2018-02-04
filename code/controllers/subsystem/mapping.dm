var/datum/subsystem/mapping/SSmapping

/datum/subsystem/mapping
	name = "Mapping"
	init_order = 100000
	flags = SS_NO_FIRE
	var/datum/map_config/previous_map_config
	var/datum/map_config/config
	var/datum/map_config/next_map_config
	
	//List of preloaded templates
	var/list/datum/map_template/map_templates = list()
	
	var/list/datum/map_template/ruins_templates = list()
	var/list/datum/map_template/space_ruins_templates = list()
	var/list/datum/map_template/lava_ruins_templates = list()
	var/list/datum/map_template/maint_room_templates = list()
	
	var/list/datum/map_template/shuttle_templates = list()
	var/list/datum/map_template/shelter_templates = list()

/datum/subsystem/mapping/New()
	NEW_SS_GLOBAL(SSmapping)
	if(!previous_map_config)
		previous_map_config = new("data/previous_map.json", delete_after = TRUE)
		if(previous_map_config.defaulted)
			previous_map_config = null
	if(!config)
		config = new
	return ..()


/datum/subsystem/mapping/Initialize(timeofday)
	if(config.defaulted)
		to_chat(world, "<span class='boldannounce'>Unable to load next map config, defaulting to Box Station</span>")
	preloadTemplates()
	loadWorld()
	SortAreas()
	process_teleport_locs()
	
	// Pick a random away mission.
	createRandomZlevel()
	// Generate mining.

	var/mining_type = config.minetype
	if (mining_type == "lavaland")
		seedRuins(5, global.config.lavaland_budget, /area/lavaland/surface/outdoors, lava_ruins_templates)
		spawn_rivers()
	else
		make_mining_asteroid_secrets()

	// deep space ruins
	seedRuins(7, rand(0,2), /area/space, space_ruins_templates)
	seedRuins(8, rand(0,2), /area/space, space_ruins_templates)
	seedRuins(9, rand(0,2), /area/space, space_ruins_templates)

	// Set up Z-level transistions.
	setup_map_transitions()

	seedMaint()
	previous_map_config = SSmapping.previous_map_config
	config = SSmapping.config
	next_map_config = SSmapping.next_map_config


	..()

/datum/subsystem/mapping/proc/seedMaint()
	to_chat(world, "<span class='boldannounce'>Loading ruins...</span>")
	for(var/V in maintroom_landmarks)
		var/obj/effect/landmark/maintroom/LM = V
		LM.load()

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	ruins_templates = SSmapping.ruins_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	lava_ruins_templates = SSmapping.lava_ruins_templates
	shuttle_templates = SSmapping.shuttle_templates
	shelter_templates = SSmapping.shelter_templates

/datum/subsystem/mapping/proc/TryLoadZ(filename, errorList, forceLevel, last)
	var/static/dmm_suite/loader
	if(!loader)
		loader = new
	if(!loader.load_map(file(filename), 0, 0, forceLevel, no_changeturf = TRUE))
		errorList |= filename
	if(last)
		qdel(loader)
		loader = null

/datum/subsystem/mapping/proc/CreateSpace()
	++world.maxz
	CHECK_TICK
	for(var/T in block(locate(1, 1, world.maxz), locate(world.maxx, world.maxy, world.maxz)))
		CHECK_TICK
		new /turf/open/space(T)

#define INIT_ANNOUNCE(X) to_chat("<span class='boldannounce'>[X]</span>"); world.log << X

/datum/subsystem/mapping/proc/loadWorld()
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()

	INIT_ANNOUNCE("Loading [config.map_name]...")
	TryLoadZ(config.GetFullMapPath(), FailedZs, ZLEVEL_STATION)
	INIT_ANNOUNCE("Loaded station!")

	INIT_ANNOUNCE("Loading mining level...")
	TryLoadZ("_maps/map_files/generic/[config.minetype].dmm", FailedZs, ZLEVEL_MINING, TRUE)
	INIT_ANNOUNCE("Loaded mining level!")

	for(var/I in (ZLEVEL_MINING + 1) to ZLEVEL_SPACEMAX)
		CreateSpace()

	if(LAZYLEN(FailedZs))	//but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(FailedZs.len > 1)
			for(var/I in 2 to FailedZs.len)
				msg += ", [I]"
		msg += ". Yell at the council / headcoders!"
		INIT_ANNOUNCE(msg)
#undef INIT_ANNOUNCE


/datum/subsystem/mapping/proc/maprotate()
	var/players = clients.len
	var/list/mapvotes = list()
	//count votes
	for (var/client/c in clients)
		var/vote = c.prefs.preferred_map
		if (!vote)
			if (global.config.defaultmap)
				mapvotes[global.config.defaultmap.map_name] += 1
			continue
		mapvotes[vote] += 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
		if (!(map in global.config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/map_config/VM = global.config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.config_min_users > 0 && players < VM.config_min_users)
			mapvotes.Remove(map)
			continue
		if (VM.config_max_users > 0 && players > VM.config_max_users)
			mapvotes.Remove(map)
			continue

		mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/map_config/VM = global.config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.map_name]")
	. = changemap(VM)
	if (.)
		to_chat(world, "<span class='boldannounce'>Map rotation has chosen [VM.map_name] for next round!</span>")

/datum/subsystem/mapping/proc/changemap(var/datum/map_config/VM)
	if(!VM.MakeNextMap())
		next_map_config = new(default_to_box = TRUE)
		message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
		return

	next_map_config = VM
	return TRUE

/datum/subsystem/mapping/Destroy()
	if(config)
		config.MakePreviousMap()
	..()

/datum/subsystem/mapping/proc/preloadTemplates(path = "_maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadRuinTemplates()
	preloadShuttleTemplates()
	preloadShelterTemplates()

/datum/subsystem/mapping/proc/preloadRuinTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("config/lavaRuinBlacklist.txt")
	banned += generateMapList("config/spaceRuinBlacklist.txt")

	for(var/item in subtypesof(/datum/map_template/ruin))
		var/datum/map_template/ruin/ruin_type = item
		// screen out the abstract subtypes
		if(!(initial(ruin_type.id)))
			continue

		var/datum/map_template/ruin/R = new ruin_type()

		if(banned.Find(R.mappath))
			continue

		map_templates[R.name] = R
		ruins_templates[R.name] = R

		if(istype(R, /datum/map_template/ruin/lavaland))
			lava_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/space))
			space_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/maint))
			maint_room_templates[R.name] = R

/datum/subsystem/mapping/proc/preloadShuttleTemplates()

	for(var/item in subtypesof(/datum/map_template/shuttle))
		var/datum/map_template/shuttle/shuttle_type = item
		if(!(initial(shuttle_type.suffix)))
			continue

		var/datum/map_template/shuttle/S = new shuttle_type()

		shuttle_templates[S.shuttle_id] = S
		map_templates[S.shuttle_id] = S

/datum/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
		map_templates[S.shelter_id] = S
