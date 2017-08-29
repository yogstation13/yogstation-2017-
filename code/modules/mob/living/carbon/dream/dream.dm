//Dream datum
/datum/dream
	var/name = "Dream Controller"
	var/dreaming = FALSE
	var/mob/living/carbon/owner
	var/mob/living/carbon/human/dream/DB = /mob/living/carbon/human/dream
	var/dream
	var/canDream = TRUE
	var/key

/datum/dream/proc/Dream(mob/living/carbon/C)
	if(dreaming || !C || !canDream || !C.client)
		return 0
	owner = C
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
		DB.real_name = "-[C.real_name]" //So they dont fuck with objectives
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
	key = "@[C.ckey]"
	world << "1 [key]"
	DB.forceMove(DS)
	DB.ckey = C.ckey
	C.key = key
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
		stopDream()
		return
	owner.reset_perspective(dream)


/datum/dream/proc/stopDream()
	if(owner.client) //Some other code already did this. If we do it anyway, the active ckey gets turned to null
		return                 //Wanna know what that does? It DC's the person and forces them to respawn
	STOP_PROCESSING(SSobj, src)
	if(!owner)   //This is what happens when the body gets deleted. Never give a deleted body a ckey, the person will respawn instead
		terminateDream()
		return
	dreaming = FALSE
	owner.ckey = DB.ckey
	DB.key = key

/datum/dream/proc/terminateDream()
	for(var/mob/M in mob_list)
		if(M.key == "@[DB.ckey]")
			M.ckey = DB.ckey
			return
		qdel(DB)
		qdel(src)

/mob/living/carbon/human/dream
	var/mob/living/carbon/body
	pass_flags = PASSMOB

/mob/living/carbon/human/dream/Life()
	if(z != 10) //There's a bug where the dream body would spawn on the real body. z10 is the dream z-level
		z = 10
		x = 5
		y = 5
	if(client && body.stat == CONSCIOUS)
		stopDream()

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
