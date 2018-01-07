/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	anchored = 1
	unacidable = 1

/obj/effect/landmark/New()
	..()
	tag = text("landmark*[]", name)
	invisibility = INVISIBILITY_ABSTRACT
	landmarks_list += src

	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			qdel(src)
			return
		if("start")
			newplayer_start += loc
			qdel(src)
			return
		if("wizard")
			wizardstart += loc
			qdel(src)
			return
		if("JoinLate")
			latejoin += loc
			qdel(src)
			return
		if("prisonwarp")
			prisonwarp += loc
			qdel(src)
			return
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1	+= loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin	+= loc
		if("tdomeobserve")
			tdomeobserve += loc
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			qdel(src)
			return
		if("blobstart")
			blobstart += loc
			qdel(src)
			return
		if("secequipment")
			secequipment += loc
			qdel(src)
			return
		if("Emergencyresponseteam")
			emergencyresponseteamspawn += loc
			qdel(src)
			return
		if("xeno_spawn")
			xeno_spawn += loc
			qdel(src)
			return
	return 1

/obj/effect/landmark/Destroy()
	landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x"
	anchored = 1

/obj/effect/landmark/start/New()
	..()
	tag = "start*[name]"
	invisibility = INVISIBILITY_ABSTRACT
	start_landmarks_list += src
	return 1

/obj/effect/landmark/start/Destroy()
	start_landmarks_list -= src
	return ..()

//Costume spawner landmarks

/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears

	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK= options[rand(1,options.len)]
	new PICK(loc)
	qdel(src)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
	new /obj/item/clothing/suit/chickensuit(loc)
	new /obj/item/clothing/head/chicken(loc)
	new /obj/item/weapon/reagent_containers/food/snacks/egg(loc)
	qdel(src)

/obj/effect/landmark/costume/gladiator/New()
	new /obj/item/clothing/under/gladiator(loc)
	new /obj/item/clothing/head/helmet/gladiator(loc)
	qdel(src)

/obj/effect/landmark/costume/madscientist/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/suit/toggle/labcoat/mad(loc)
	new /obj/item/clothing/glasses/gglasses(loc)
	qdel(src)

/obj/effect/landmark/costume/elpresidente/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/mask/cigarette/cigar/havana(loc)
	new /obj/item/clothing/shoes/jackboots(loc)
	qdel(src)

/obj/effect/landmark/costume/nyangirl/New()
	new /obj/item/clothing/under/schoolgirl(loc)
	new /obj/item/clothing/head/kitty(loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(loc)
	qdel(src)

/obj/effect/landmark/costume/maid/New()
	new /obj/item/clothing/under/blackskirt(loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(loc)
	qdel(src)

/obj/effect/landmark/costume/butler/New()
	new /obj/item/clothing/tie/waistcoat(loc)
	new /obj/item/clothing/under/suit_jacket(loc)
	new /obj/item/clothing/head/that(loc)
	qdel(src)

/obj/effect/landmark/costume/highlander/New()
	new /obj/item/clothing/under/kilt(loc)
	new /obj/item/clothing/head/beret(loc)
	qdel(src)

/obj/effect/landmark/costume/prig/New()
	new /obj/item/clothing/tie/waistcoat(loc)
	new /obj/item/clothing/glasses/monocle(loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(loc)
	new /obj/item/clothing/shoes/sneakers/black(loc)
	new /obj/item/weapon/cane(loc)
	new /obj/item/clothing/under/sl_suit(loc)
	new /obj/item/clothing/mask/fakemoustache(loc)
	qdel(src)

/obj/effect/landmark/costume/plaguedoctor/New()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(loc)
	new /obj/item/clothing/head/plaguedoctorhat(loc)
	new /obj/item/clothing/mask/gas/plaguedoctor(loc)
	qdel(src)

/obj/effect/landmark/costume/nightowl/New()
	new /obj/item/clothing/suit/toggle/owlwings(loc)
	new /obj/item/clothing/under/owl(loc)
	new /obj/item/clothing/mask/gas/owl_mask(loc)
	qdel(src)

/obj/effect/landmark/costume/thegriffin/New()
	new /obj/item/clothing/suit/toggle/owlwings/griffinwings(loc)
	new /obj/item/clothing/shoes/griffin(loc)
	new /obj/item/clothing/under/griffin(loc)
	new /obj/item/clothing/head/griffin(loc)
	qdel(src)

/obj/effect/landmark/costume/waiter/New()
	new /obj/item/clothing/under/waiter(loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(loc)
	new /obj/item/clothing/suit/apron(loc)
	qdel(src)

/obj/effect/landmark/costume/pirate/New()
	new /obj/item/clothing/under/pirate(loc)
	new /obj/item/clothing/suit/pirate(loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(loc)
	new /obj/item/clothing/glasses/eyepatch(loc)
	qdel(src)

/obj/effect/landmark/costume/commie/New()
	new /obj/item/clothing/under/soviet(loc)
	new /obj/item/clothing/head/ushanka(loc)
	qdel(src)

/obj/effect/landmark/costume/imperium_monk/New()
	new /obj/item/clothing/suit/imperium_monk(loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(loc)
	qdel(src)

/obj/effect/landmark/costume/holiday_priest/New()
	new /obj/item/clothing/suit/holidaypriest(loc)
	qdel(src)

/obj/effect/landmark/costume/marisawizard/fake/New()
	new /obj/item/clothing/shoes/sandal/marisa(loc)
	new /obj/item/clothing/head/wizard/marisa/fake(loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(loc)
	qdel(src)

/obj/effect/landmark/costume/cutewitch/New()
	new /obj/item/clothing/under/sundress(loc)
	new /obj/item/clothing/head/witchwig(loc)
	new /obj/item/weapon/staff/broom(loc)
	qdel(src)

/obj/effect/landmark/costume/fakewizard/New()
	new /obj/item/clothing/shoes/sandal(loc)
	new /obj/item/clothing/suit/wizrobe/fake(loc)
	new /obj/item/clothing/head/wizard/fake(loc)
	new /obj/item/weapon/staff/(loc)
	qdel(src)

/obj/effect/landmark/costume/sexyclown/New()
	new /obj/item/clothing/mask/gas/sexyclown(loc)
	new /obj/item/clothing/under/rank/clown/sexy(loc)
	qdel(src)

/obj/effect/landmark/costume/sexymime/New()
	new /obj/item/clothing/mask/gas/sexymime(loc)
	new /obj/item/clothing/under/sexymime(loc)
	qdel(src)

//Department Security spawns

/obj/effect/landmark/start/depsec
	name = "department_sec"

/obj/effect/landmark/start/depsec/New()
	..()
	department_security_spawns += src

/obj/effect/landmark/start/depsec/Destroy()
	department_security_spawns -= src
	return ..()

/obj/effect/landmark/start/depsec/supply
	name = "supply_sec"

/obj/effect/landmark/start/depsec/medical
	name = "medical_sec"

/obj/effect/landmark/start/depsec/engineering
	name = "engineering_sec"

/obj/effect/landmark/start/depsec/science
	name = "science_sec"

/obj/effect/landmark/latejoin
	name = "JoinLate"

//generic event spawns
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "x4"

/obj/effect/landmark/event_spawn/New()
	..()
	generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	generic_event_spawns -= src
	return ..()

/obj/effect/landmark/maintroom
	var/list/template_names = list()

/obj/effect/landmark/maintroom/New()
	..()
	maintroom_landmarks += src

/obj/effect/landmark/maintroom/Destroy()
	maintroom_landmarks -= src
	return ..()

/obj/effect/landmark/maintroom/proc/load(template_name)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(!template_name)
		for(var/t in template_names)
			if(!maint_room_templates[t])
				world.log << "Maintenance room spawner placed at ([T.x], [T.y], [T.z]) has invalid ruin name of \"[t]\" in its list"
				template_names -= t
		template_name = safepick(template_names)
	if(!template_name)
		return FALSE
	var/datum/map_template/template = maint_room_templates[template_name]
	if(!template)
		return FALSE
	world.log << "Ruin \"[template_name]\" placed at ([T.x], [T.y], [T.z])"
	template.load(T, centered = FALSE)
	template.loaded++
	return TRUE