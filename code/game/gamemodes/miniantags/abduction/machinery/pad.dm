/obj/machinery/abductor/pad
	name = "Alien Telepad"
	desc = "Use this to transport to and from human habitat"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "alien-pad-idle"
	anchored = 1
	var/turf/teleport_target

/obj/machinery/abductor/pad/proc/Warp(mob/living/target)
	target.Move(src.loc)

/obj/machinery/abductor/pad/proc/Send()
	if(teleport_target == null)
		teleport_target = teleportlocs[pick(teleportlocs)]
	flick("alien-pad", src)
	for(var/mob/living/target in loc)
		target.forceMove(teleport_target)
		spawn(0)
			anim(target.loc,target,'icons/mob/mob.dmi',,"uncloak",,target.dir)

/obj/machinery/abductor/pad/proc/Retrieve(mob/living/target)
	flick("alien-pad", src)
	spawn(0)
		anim(target.loc,target,'icons/mob/mob.dmi',,"uncloak",,target.dir)
	Warp(target)

/obj/machinery/abductor/pad/proc/MobToLoc(place,mob/living/target)
	new/obj/effect/overlay/temp/teleport_abductor(place)
	sleep(80)
	flick("alien-pad", src)
	target.forceMove(place)
	anim(target.loc,target,'icons/mob/mob.dmi',,"uncloak",,target.dir)

/obj/machinery/abductor/pad/proc/PadToLoc(place)
	new/obj/effect/overlay/temp/teleport_abductor(place)
	sleep(80)
	flick("alien-pad", src)
	for(var/mob/living/target in src.loc)
		target.forceMove(place)
		spawn(0)
			anim(target.loc,target,'icons/mob/mob.dmi',,"uncloak",,target.dir)


/obj/effect/overlay/temp/teleport_abductor
	name = "Huh"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "teleport"
	duration = 80
	
/obj/machinery/abductor/pad(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "alien-pad-idle", "alien-pad-idle", I))
		return
	if(default_deconstruction_crowbar(I))
		return

/obj/machinery/abductor/pad/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/abductor/pad(null)
	B.apply_default_parts(src)
	
/obj/item/weapon/circuitboard/machine/chem_heater
	name = "Teleport Pad (Abductor)"
	build_path = /obj/machinery/abductor/pad
	origin_tech = "programming=7;engineering=6;bluespace=7;alien=4"
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser/quadultra = 2,
							/obj/item/weapon/stock_parts/manipulator/femto = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/effect/overlay/temp/teleport_abductor/New()
	var/datum/effect_system/spark_spread/S = new
	S.set_up(10,0,loc)
	S.start()
	..()
