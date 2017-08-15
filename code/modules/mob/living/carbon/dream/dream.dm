//Dream datum
/datum/dream
	var/name = "Dream Controller"
	var/dreaming = FALSE
	var/mob/living/carbon/owner
	var/mob/living/carbon/human/dream/DB = /mob/living/carbon/human/dream
	var/dream
	var/canDream = TRUE
	var/initialized = FALSE

/datum/dream/proc/Dream(mob/living/carbon/C)
	if(dreaming || !C || !canDream || !C.client || (ishuman(DB) && DB.ckey))
		return 0
	owner = C
	initialized = TRUE
	var/area/current = get_area(owner)
	if(current && current.dreamtype && prob(50))
		dream = pick(get_dream(current.dreamtype))
	else
		dream = pick(dreamland)
	if(!dream || owner.stat != UNCONSCIOUS)
		return 0
	startDream(C, dream)
	START_PROCESSING(SSobj, src)
	return 1

/datum/dream/proc/startDream(mob/living/carbon/C, obj/effect/dream_eye/dream)
	var/turf/DS = get_turf(dream)
	if(!ishuman(DB))
		DB = new DB(DS)
		DB.body = C
		DB.dream = src
		DB.name = C.real_name
		DB.real_name = "dream [C.real_name]" //So they dont fuck with objectives
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			H.dna.transfer_identity(DB, transfer_SE=0)
			DB.updateappearance(mutcolor_update=1)
		if(isalien(C))
			var/obj/item/clothing/suit/xenos/suit = new()
			var/obj/item/clothing/head/xenos/head = new()
			DB.equip_to_slot_if_possible(head, slot_head)
			DB.equip_to_slot_if_possible(suit, slot_wear_suit)
		else if(ismonkey(C))
			var/obj/item/clothing/suit/monkeysuit/suit = new()
			var/obj/item/clothing/mask/gas/monkeymask/mask = new()
			DB.equip_to_slot_if_possible(suit, slot_wear_suit)
			DB.equip_to_slot_if_possible(mask, slot_wear_mask)
	for(var/mob/living/carbon/human/dream/D in mob_list)
		D.dream.setInvisibility()	//If one new dude comes in, he will be visible, so redo the invisibility for all...
	DB.forceMove(DS)
	DB.ckey = C.ckey
	setInvisibility()
	DB.overlay_fullscreen("dream", /obj/screen/fullscreen/blind)
	DB << dream.dream_message

	spawn(30)
		DB.clear_fullscreens()


/datum/dream/proc/setInvisibility()
	for(var/mob/living/carbon/human/dream/D in mob_list)
		if(D == DB)
			continue
		var/image/invis = D.staticOverlays["invisible"]
		DB.staticOverlays |= invis
		if(DB.client)
			DB.client.images |= invis

/datum/dream/process()
	if(!owner)
		terminateDream()
	if(owner.stat != UNCONSCIOUS)
		STOP_PROCESSING(SSobj, src)
		stopDream()
		return
	owner.reset_perspective(dream)


/datum/dream/proc/stopDream()
	STOP_PROCESSING(SSobj, src)
	if(!initialized)
		return
	else if(!owner)   //This is what happens when the body gets deleted. Never give a deleted body a ckey, the person will respawn instead
		terminateDream()
		return
	dreaming = FALSE
	owner.ckey = DB.ckey

/datum/dream/proc/terminateDream()
	if(DB.client || DB.key) //Only do this if it didnt get caught by other code
		DB << "<span class='combat'>Your body is gone...</span>"
		DB.ghostize()
		qdel(DB)
		qdel(src)

/mob/living/carbon/human/dream
	var/mob/living/carbon/body
	pass_flags = PASSMOB

/mob/living/carbon/human/dream/New()
	..()
	var/datum/species/S = dna.species
	S.specflags |= NOHUNGER
	status_flags |= GODMODE


/mob/living/carbon/human/dream/say()
	src << "<span class='warning'>You cannot talk!</span>"
	return 0

/mob/living/carbon/human/dream/UnarmedAttack(atom/A, proximity)
	A.dreamClick(src)

/mob/living/carbon/human/dream/emote()
	return

/mob/living/carbon/human/dream/start_pulling()
	return

/mob/living/carbon/human/dream/suicide()
	return
