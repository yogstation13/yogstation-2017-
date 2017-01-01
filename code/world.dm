/var/yog_round_number = 0

/world
	mob = /mob/new_player
	turf = /turf/open/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 7

var/global/list/map_transition_config = MAP_TRANSITION_CONFIG

/world/New()
	check_for_cleanbot_bug()
	map_ready = 1

#if (PRELOAD_RSC == 0)
	external_rsc_urls = file2list("config/external_rsc_urls.txt","\n")
	var/i=1
	while(i<=external_rsc_urls.len)
		if(external_rsc_urls[i])
			i++
		else
			external_rsc_urls.Cut(i,i+1)
#endif
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	admindiary = file("data/logs/[date_string] Admin.log")
	diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	diary << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	diaryofmeanpeople << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	admindiary << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	var/roundfile = file("data/roundcount.txt")
	yog_round_number = text2num(file2text(roundfile))
	if(yog_round_number == null || yog_round_number == "" || yog_round_number == 0)
		yog_round_number = 1
	else
		yog_round_number++
	fdel(roundfile)
	text2file(num2text(yog_round_number), roundfile)

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)

	load_configuration()
	load_mode()
	load_motd()
	refresh_admin_files()
	load_admins()
	if(config.usewhitelist)
		load_whitelist()
	jobban_loadbanfile()
	appearance_loadbanfile()
	jobban_updatelegacybans()
	LoadBans()
	load_donators()
	investigate_reset()

	setup_pretty_filter()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		config.server_name += " #[(world.port % 1000) / 100]"

	timezoneOffset = text2num(time2text(0,"hh")) * 36000

	if(config.sql_enabled)
		if(!setup_database_connection())
			world.log << "Your server failed to establish a connection with the database."
		else
			world.log << "Database connection established."


	data_core = new /datum/datacore()

	spawn(10)
		Master.Setup()

	process_teleport_locs()			//Sets up the wizard teleport locations
	SortAreas()						//Build the list of all existing areas and sort it alphabetically

	#ifdef MAP_NAME
	map_name = "[MAP_NAME]"
	#else
	map_name = "Unknown"
	#endif

	send_discord_message("public", "A new round is about to begin! Join with this address https://yogstation.net/play.php ! The current round number is **[yog_round_number]** and the chosen map is **[map_name]**")

	config.Tickcomp = 0
	world.fps = 20

	return

#define IRC_STATUS_THROTTLE 50
var/last_irc_status = 0

/world/Topic(T, addr, master, key)
	if(config && config.log_world_topic)
		diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	var/list/input = params2list(T)
	var/key_valid = (global.comms_allowed && input["key"] == global.comms_key)

	if("ping" in input)
		var/x = 1
		for (var/client/C in clients)
			x++
		return x

	else if("players" in input)
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if("status" in input)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["active_players"] = get_active_player_count()
		s["players"] = clients.len
		s["revision"] = revdata.commit
		s["revision_date"] = revdata.date

		var/list/adm = get_admin_counts()
		s["admins"] = adm["present"] + adm["afk"] //equivalent to the info gotten from adminwho
		s["gamestate"] = 1
		if(ticker)
			s["gamestate"] = ticker.current_state

		s["map_name"] = map_name ? map_name : "Unknown"

		if(key_valid && ticker && ticker.mode)
			s["real_mode"] = ticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

		s["security_level"] = get_security_level()
		s["round_duration"] = round(world.time/10)
		// Amount of world's ticks in seconds, useful for calculating round duration

		if(SSshuttle && SSshuttle.emergency)
			s["shuttle_mode"] = SSshuttle.emergency.mode
			// Shuttle status, see /__DEFINES/stat.dm
			s["shuttle_timer"] = SSshuttle.emergency.timeLeft()
			// Shuttle timer, in seconds

		return list2params(s)

	else if("adminwho" in input)
		var/msg = "Current Admins:\n"
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"
			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
		return msg

	else if(copytext(T,1,9) == "announce")
		if(!key_valid)
			return "Bad Key"
		else
#define CHAT_PULLR	64 //defined in preferences.dm, but not available here at compilation time
			for(var/client/C in clients)
				if(C.prefs && (C.prefs.chat_toggles & CHAT_PULLR))
					C << "<span class='announce'>PR: [input["announce"]]</span>"
#undef CHAT_PULLR
	else if (copytext(T,1,5) == "asay")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				var/msg = "<span class='adminobserver'><span class='prefix'>DISCORD ADMIN:</span> <EM>[input["admin"]]</EM>: <span class='message'>[input["asay"]]</span></span>"
				admins << msg
	else if (copytext(T,1,4) == "ooc")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				for(var/client/C in clients)
					//if(C.prefs.chat_toggles & CHAT_OOC) // Discord OOC should bypass preferences.
					C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>DISCORD OOC:</span> <EM>[input["admin"]]:</EM> <span class='message'>[input["ooc"]]</span></span></font>"
	else if (copytext(T,1,7) == "reboot")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				Reboot(null, null, null, null, 1)
	else if (copytext(T,1,7) == "ticket")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				var/action = input["action"]
				var/msg = "Theres [total_unresolved_tickets()] unresolved tickets out of [tickets_list.len] tickets."
				if(action == "list")
					msg += "\nCurrent unresolved tickets:"
					for(var/i = tickets_list.len, i >= 1, i--)
						var/datum/admin_ticket/ticket = tickets_list[i]
						if(!ticket.resolved)
							msg += "\n    #[ticket.ticket_id]. Opened by: [ticket.owner_ckey] Title: \"[ticket.title]\""
				if(action == "log")
					var/datum/admin_ticket/ticket
					for(var/i = tickets_list.len, i >= 1, i--)
						var/datum/admin_ticket/ticket2 = tickets_list[i]
						if(ticket2.ticket_id == text2num(input["id"]))
							ticket = ticket2
					if(!ticket)
						return "Ticket not found"
					msg += "\n Ticket #[ticket.ticket_id] log:"
					if(ticket.ticket_id == text2num(input["id"]))
						for(var/i = 1; i <= ticket.log.len; i++)
							var/datum/ticket_log/item = ticket.log[i]
							msg += "\n    [item.toSanitizedString()]"
				if(action == "reply")
					for(var/i = tickets_list.len, i >= 1, i--)
						var/datum/admin_ticket/ticket = tickets_list[i]
						if(ticket.ticket_id == text2num(input["id"]))
							var/datum/ticket_log/log_item = null
							log_item = new /datum/ticket_log(ticket, input["admin"], input["response"], 0)
							ticket.log += log_item
							ticket.owner << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
							ticket.owner << "<span class='ticket-text-received'>-- [input["admin"]] -> [key_name_params(ticket.owner, 0, 0, null, src)]: [log_item.text]</span>"
				return msg


/world/Reboot(var/reason, var/feedback_c, var/feedback_r, var/time)
	if (reason == 1) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		world << "<span class='boldannounce'>Rebooting World immediately due to host request</span>"
		ticker.server_reboot_in_progress = 1
		return ..(1)
	var/delay
	if(time)
		delay = time
	else
		delay = config.round_end_countdown * 10
	if(ticker.delay_end)
		world << "<span class='boldannounce'>An admin has delayed the round end.</span>"
		return
	world << "<span class='boldannounce'>Rebooting World in [delay/10] [delay > 10 ? "seconds" : "second"]. [reason]</span>"
	ticker.server_reboot_in_progress = 1
	sleep(delay)
	if(blackbox)
		blackbox.save_all_data_to_sql()
	if(ticker.delay_end)
		world << "<span class='boldannounce'>Reboot was cancelled by an admin.</span>"
		ticker.server_reboot_in_progress = 0
		return
	if(mapchanging)
		world << "<span class='boldannounce'>Map change operation detected, delaying reboot.</span>"
		rebootingpendingmapchange = 1
		spawn(1200)
			if(mapchanging)
				mapchanging = 0 //map rotation can in some cases be finished but never exit, this is a failsafe
				Reboot("Map change timed out", time = 10)
		return
	feedback_set_details("[feedback_c]","[feedback_r]")
	log_game("<span class='boldannounce'>Rebooting World. [reason]</span>")
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", 1) //second parameter ensures only afk clients are kicked
	#ifdef dellogging
	var/log = file("data/logs/del.log")
	log << time2text(world.realtime)
	for(var/index in del_counter)
		var/count = del_counter[index]
		if(count > 10)
			log << "#[count]\t[index]"
#endif
	spawn(0)
		if(ticker && ticker.round_end_sound)
			world << sound(ticker.round_end_sound)
		else
			world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg','sound/misc/leavingtg.ogg')) // random end sounds!! - LastyBatsy
	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")
	..(0)

var/inerror = 0
/world/Error(var/exception/e)
	//runtime while processing runtimes
	if (inerror)
		inerror = 0
		return ..(e)
	inerror = 1
	//newline at start is because of the "runtime error" byond prints that can't be timestamped.
	e.name = "\n\[[time2text(world.timeofday,"hh:mm:ss")]\][e.name]"

	//this is done this way rather then replace text to pave the way for processing the runtime reports more thoroughly
	//	(and because runtimes end with a newline, and we don't want to basically print an empty time stamp)
	var/list/split = splittext(e.desc, "\n")
	for (var/i in 1 to split.len)
		if (split[i] != "")
			split[i] = "\[[time2text(world.timeofday,"hh:mm:ss")]\][split[i]]"
	e.desc = jointext(split, "\n")
	inerror = 0
	return ..(e)

/world/proc/manage_fps()
	var/count = player_list.len

	var/oldTC = config.Tickcomp
	var/oldFPS = world.fps

	if(count < 50)
		config.Tickcomp = 0
		world.fps = 22
	else if(count < 60)
		config.Tickcomp = 0
		world.fps = 21
	else if(count < 70)
		config.Tickcomp = 0
		world.fps = 20
	else if(count < 80)
		config.Tickcomp = 0
		world.fps = 19
	else if(count < 90)
		config.Tickcomp = 0
		world.fps = 18
	else
		config.Tickcomp = 1
		world.fps = 16

	if(world.fps != oldFPS || config.Tickcomp != oldTC)
		var/msg = "WORLD has modified world.fps to [world.fps] and config.Tickcomp to [config.Tickcomp] (player count reached [count])"
		log_admin(msg, 0)
		message_admins(msg, 0)

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_configuration()
	protected_config = new /datum/protected_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.load("config/discord.txt","discord")
	config.loadsql("config/dbconfig.txt")
	if (config.maprotation && SERVERTOOLS)
		config.loadmaplist("config/maps.txt")

	// apply some settings from config..
	abandon_allowed = config.respawn

var/list/donators = list()

/world/proc/load_donators()
	var/ckey
	var/datum/preferences/P
	for(var/key in donators)
		ckey = ckey(key)
		P = preferences_datums[ckey]
		if(P)
			P.unlock_content &= 1
	donators = list()
	var/list/donatorskeys = list()
	if(config.donator_legacy_system)
		donatorskeys = file2list("config/donators.txt")
	else
		establish_db_connection()
		if(!dbcon.IsConnected())
			world.log << "Failed to connect to database in load_donators(). Reverting to legacy system."
			diary << "Failed to connect to database in load_donators(). Reverting to legacy system."
			config.donator_legacy_system = 1
			load_donators()
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM [format_table_name("donors")] WHERE (expiration_time > Now()) AND (revoked IS NULL)")
		query.Execute()
		while(query.NextRow())
			ckey = query.item[1]
			if(ckey)
				donatorskeys |= ckey
	for(var/key in donatorskeys)
		ckey = ckey(key)
		donators += ckey
		P = preferences_datums[ckey]
		if(P)
			P.unlock_content |= 2

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"https://www.yogstation.net\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Taco's Yogstation Testing Server..."  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"

	if (!enter_allowed)
		features += "closed"

	features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0

/proc/setup_database_connection()

	if(failed_db_connections >= FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to connect anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		if(config.sql_enabled)
			world.log << "SQL error: " + dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF


/proc/maprotate()
	if (!SERVERTOOLS)
		return
	var/players = clients.len
	var/list/mapvotes = list()
	//count votes
	for (var/client/c in clients)
		var/vote = c.prefs.preferred_map
		if (!vote)
			if (config.defaultmap)
				mapvotes[config.defaultmap.name] += 1
			continue
		mapvotes[vote] += 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
		if (!(map in config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/votablemap/VM = config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.minusers > 0 && players < VM.minusers)
			mapvotes.Remove(map)
			continue
		if (VM.maxusers > 0 && players > VM.maxusers)
			mapvotes.Remove(map)
			continue

		mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/votablemap/VM = config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.name]([VM.friendlyname])")
	. = changemap(VM)
	if (. == 0)
		world << "<span class='boldannounce'>Map rotation has chosen [VM.friendlyname] for next round!</span>"

var/datum/votablemap/nextmap
var/mapchanging = 0
var/rebootingpendingmapchange = 0
/proc/changemap(var/datum/votablemap/VM)
	if (!SERVERTOOLS)
		return
	if (!istype(VM))
		return
	mapchanging = 1
	log_game("Changing map to [VM.name]([VM.friendlyname])")
	var/file = file("setnewmap.bat")
	file << "\nset MAPROTATE=[VM.name]\n"
	. = shell("..\\bin\\maprotate.bat")
	mapchanging = 0
	switch (.)
		if (null)
			message_admins("Failed to change map: Could not run map rotator")
			log_game("Failed to change map: Could not run map rotator")
		if (0)
			log_game("Changed to map [VM.friendlyname]")
			nextmap = VM
		//1x: file errors
		if (11)
			message_admins("Failed to change map: File error: Map rotator script couldn't find file listing new map")
			log_game("Failed to change map: File error: Map rotator script couldn't find file listing new map")
		if (12)
			message_admins("Failed to change map: File error: Map rotator script couldn't find tgstation-server framework")
			log_game("Failed to change map: File error: Map rotator script couldn't find tgstation-server framework")
		//2x: conflicting operation errors
		if (21)
			message_admins("Failed to change map: Conflicting operation error: Current server update operation detected")
			log_game("Failed to change map: Conflicting operation error: Current server update operation detected")
		if (22)
			message_admins("Failed to change map: Conflicting operation error: Current map rotation operation detected")
			log_game("Failed to change map: Conflicting operation error: Current map rotation operation detected")
		//3x: external errors
		if (31)
			message_admins("Failed to change map: External error: Could not compile new map:[VM.name]")
			log_game("Failed to change map: External error: Could not compile new map:[VM.name]")

		else
			message_admins("Failed to change map: Unknown error: Error code #[.]")
			log_game("Failed to change map: Unknown error: Error code #[.]")
	if(rebootingpendingmapchange)
		world.Reboot("Map change finished", time = 10)
