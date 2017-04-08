// Note: BYOND is object oriented. There is no reason for this to be copy/pasted blood code.

/obj/effect/decal/cleanable/xenoblood
	name = "xeno blood"
	desc = "It's green and acidic. It looks like... <i>blood?</i>"
	gender = PLURAL
	density = 0
	layer = ABOVE_OPEN_TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")
	var/list/viruses = list()
	blood_DNA = list("UNKNOWN DNA" = "X*")
	bloodiness = MAX_SHOE_BLOODINESS
	blood_state = BLOOD_STATE_XENO

/obj/effect/decal/cleanable/xenoblood/New()
	..()
	if(prob(5))
		var/turf/T = get_turf(src)
		visible_message("<span class='warning'>[src] starts phasing through [T.name]!</span class>")
		new /obj/effect/acid(loc, T)

/obj/effect/decal/cleanable/xenoblood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	viruses = null
	return ..()

/obj/effect/decal/cleanable/xenoblood/xgibs/proc/streak(list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				var/obj/effect/decal/cleanable/xenoblood/b = new /obj/effect/decal/cleanable/xenoblood/xsplatter(src.loc)
				for(var/datum/disease/D in src.viruses)
					var/datum/disease/ND = D.Copy(1)
					b.viruses += ND
					ND.holder = b
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/xenoblood/xsplatter
	random_icon_states = list("xgibbl1", "xgibbl2", "xgibbl3", "xgibbl4", "xgibbl5")

/obj/effect/decal/cleanable/xenoblood/xgibs
	name = "xeno gibs"
	desc = "Gnarly..."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "xgib1"
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6")

/obj/effect/decal/cleanable/xenoblood/xgibs/ex_act()
	return

/obj/effect/decal/cleanable/xenoblood/xgibs/up
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibup1","xgibup1","xgibup1")

/obj/effect/decal/cleanable/xenoblood/xgibs/down
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibdown1","xgibdown1","xgibdown1")

/obj/effect/decal/cleanable/xenoblood/xgibs/body
	random_icon_states = list("xgibhead", "xgibtorso")

/obj/effect/decal/cleanable/xenoblood/xgibs/limb
	random_icon_states = list("xgibleg", "xgibarm")

/obj/effect/decal/cleanable/xenoblood/xgibs/core
	random_icon_states = list("xgibmid1", "xgibmid2", "xgibmid3")

/obj/effect/decal/cleanable/blood/xtracks
	icon_state = "xtracks"
	random_icon_states = null
	blood_DNA = list("UNKNOWN DNA" = "X*")

/obj/effect/decal/cleanable/xenodrool
	name = "xeno drool"
	desc = "A nasty pool of coughed up alien spit and drool. It seems like it's still melting the surface below it... must be fresh."
//	icon = 'icons/effects/drool.dmi'
	icon_state = "drool"

/obj/effect/decal/cleanable/xenodrool/New()
	. = ..()
	addtimer(src, "dry_up", 1000)

/obj/effect/decal/cleanable/xenodrool/Cross(atom/A)
	. = ..()
	//playsound(get_turf(src), 'sound/misc/squish.ogg', 100, 0, sNoiseLevel = 500, sNoiseDesc = "someone stepped over alien drool", sNoiseMult = 2)

/obj/effect/decal/cleanable/xenodrool/proc/dry_up()
	visible_message("[src] settles down.")
	desc = "A nasty pool of coughed up alien spit and drool. It appears to be settling down, so it must have been here for awhile."