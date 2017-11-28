/*
Immovable rod random event.
The rod will spawn at some location outside the station, and travel in a straight line to the opposite side of the station
Everything solid in the way will be ex_act()'d
In my current plan for it, 'solid' will be defined as anything with density == 1

--NEOFite
*/

/datum/round_event_control/immovable_rod
	name = "Immovable Rod"
	typepath = /datum/round_event/immovable_rod
	min_players = 15
	max_occurrences = 5

/datum/round_event/immovable_rod
	announceWhen = 5

/datum/round_event/immovable_rod/announce()
	priority_announce("What the fuck was that?!", "General Alert")

/datum/round_event/immovable_rod/start()
	var/startside = pick(cardinal)
	var/turf/startT = spaceDebrisStartLoc(startside, 1)
	var/turf/endT = spaceDebrisFinishLoc(startside, 1)
	new /obj/effect/immovablerod(startT, endT)

/obj/effect/immovablerod
	name = "immovable rod"
	desc = "What the fuck is that?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 100
	density = 1
	anchored = 1
	var/z_original = 0
	var/destination

/obj/effect/immovablerod/New(atom/start, atom/end)
	loc = start
	z_original = z
	destination = end
	if(end && end.z==z_original)
		walk_towards(src, destination, 1)

/obj/effect/immovablerod/Move()
	if(z != z_original || loc == destination)
		qdel(src)
	return ..()

/obj/effect/immovablerod/ex_act(test)
	return 0

/obj/effect/immovablerod/proc/check_suplex(mob/living/carbon/human/H)
	if(!istype(H) || !H.mind || H.mind.assigned_role != "Research Director" || !H.in_throw_mode)
		return FALSE
	var/obj/structure/flora/kirbyplants/K = locate() in range(1, H)
	if(!K)
		return FALSE

	var/turf/open/floor/T = get_turf(K)
	H.forceMove(T)

	H.visible_message("<span class='userdanger'>[H] suplexes \the [src] into [K]!</span>","<span class='userdanger'>You suplex \the [src] into [K]!</span>")
	var/obj/structure/festivus/P = new(T)
	P.desc = "During this year's Feats of Strength the Research Director was able to suplex this passing immovable rod into a planter."
	if(istype(T))
		T.break_tile()
	playsound(T, "explosion", 100)
	for(var/mob/bystander in urange(10, src))
		shake_camera(bystander, 7, 2)

	qdel(src)
	qdel(K)
	return TRUE

/obj/effect/immovablerod/Bump(atom/clong)
	if(qdeleted(src))
		return

	if(prob(10))
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		audible_message("CLANG")

	if(clong && prob(25))
		x = clong.x
		y = clong.y

	if (istype(clong, /turf) || istype(clong, /obj))
		if(clong.density)
			clong.ex_act(2)

	else if (istype(clong, /mob))
		if(istype(clong, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = clong
			if(!check_suplex(H))
				H.visible_message("<span class='danger'>[H.name] is penetrated by an immovable rod!</span>" , "<span class='userdanger'>The rod penetrates you!</span>" , "<span class ='danger'>You hear a CLANG!</span>")
				H.adjustBruteLoss(160)
		else if(clong.density || prob(10))
			clong.ex_act(2)
	return

