/obj/machinery/door/unpowered

/obj/machinery/door/unpowered/Bumped(atom/AM)
	if(src.locked)
		return
	..()
	return


/obj/machinery/door/unpowered/attackby(obj/item/I, mob/user, params)
	if(locked)
		return
	else
		return ..()

/obj/machinery/door/unpowered/emag_act()
	return

/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = 1
	explosion_block = 1

/////////////////////////////////////
/*
Resin Airlock
*/

/obj/machinery/door/resin
	name = "resin door"
	icon = 'icons/obj/doors/resin.dmi'
	icon_state = "closed"
//	overlays_file = null
//	doortype = null
//	hackProof = 1
//	aiControlDisabled = 1
	color = "#800080"
	var/datum/huggerdatum/colony
	autoclose = 600

/obj/machinery/door/resin/allowed(mob/M)
	if(!density)
		return 1
	if(!colony) //human
		return 1
	if(istype(M, /mob/living/carbon/alien))
		var/mob/living/carbon/alien/A = M
		if(A.HD)
			if(compareAlienSuffix(A1 = A, col2 = colony.colony_suffix))
				Open()
				return 1
	return 0

/obj/machinery/door/resin/Bumped(atom/AM)
	if(ismob(AM))
		allowed(AM)
	..()
	return

/obj/machinery/door/resin/proc/Open()
//	isSwitchingStates = 1
	flick("opening",src)
	sleep(10)
	density = 0
	opacity = 0
	//state = 1
	icon_state = "open"
	air_update_turf(1)
	update_icon()
//	isSwitchingStates = 0

	spawn(autoclose)
		close()

/obj/machinery/door/resin/preopen
	icon_state = "open"
	density = 0
	opacity = 0

/obj/machinery/door/resin/attack_alien(mob/living/carbon/alien/M)
	if(M.HD)
		if(M.HD.colony_suffix)
			if(compareAlienSuffix(M, col2 = colony.colony_suffix))
				if(density)
					Open()
				else
					close()
				return
	return ..()

/obj/machinery/door/resin/narsie_act() // biological horror vs magical horror
	return
