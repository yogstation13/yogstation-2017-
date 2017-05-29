/obj/effect/decal/cleanable/ash/vampiric
	var/mob/living/storedmob

/obj/effect/decal/cleanable/ash/vampiric/New(strong)
	. = ..()
	if(strong) // 200 blood
		START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/ash/vampiric/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/decal/cleanable/ash/vampiric/process()
	if(!storedmob)
		return
	var/turf/T = get_turf(src)
	var/obj/effect/decal/cleanable/blood/B = locate() in T
	if(B)
		if(storedmob.mind || storedmob.key || ghost_check())
			create_vampire()
		else
			new /obj/item/weapon/reagent_containers/glass/bottle/vampire(get_turf(src))
		qdel(src)

/obj/effect/decal/cleanable/ash/vampiric/proc/ghost_check()
	for(var/mob/dead/observer/ghost in mob_list)
		if(ghost.mind.current == storedmob)
			return 1
	return 0

/obj/effect/decal/cleanable/ash/vampiric/proc/create_vampire()
	var/mob/living/carbon/human/H = new(get_turf(src))
	H.real_name = storedmob.real_name
	H.name = storedmob.real_name
	if(storedmob.key)
		H.key = storedmob.key
	else
		storedmob.grab_ghost()
		H.key = storedmob.key
	H.mind.vampire = new(H.mind)
	H.mind.vampire.vampire = H
	H.mind.vampire.Basic()
	H << "<span class='noticevampire'>Your body has regenerated from ashes... However,\
		your powers have reverted. Your thirst <B>INTENSIFIES</b>.</span>"