
/obj/vehicle/atv
	name = "all-terrain vehicle"
	desc = "An all-terrain vehicle built for traversing rough terrain with ease. One of the few old-earth technologies that are still relevant on most planet-bound outposts."
	icon_state = "atv"
	var/static/image/atvcover = null
	var/datum/action/atvlight/vlight

/obj/vehicle/atv/examine(mob/user)
	..()
	if(vlight)
		if(vlight.toggle)
			user << "<span class='notice'>The lights are on.</span>"
		else
			user << "<span class='notice'>The lights are off.</span>"

/obj/vehicle/atv/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 1)
	. = ..()
	riding_datum = new/datum/riding/atv

/obj/vehicle/atv/New()
	..()
	if(!atvcover)
		atvcover = image("icons/obj/vehicles.dmi", "atvcover")
		atvcover.layer = ABOVE_MOB_LAYER
	vlight = new(loc, src)

/datum/action/atvlight
	name = "Toggle ATV Light"
	desc = "Click on. Click off."
	button_icon_state = "mech_lights_off"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_LYING | AB_CHECK_STUNNED | AB_CHECK_RESTRAINED
	var/toggle
	var/obj/vehicle/atv/ATV

/datum/action/atvlight/New(loc, pATV)
	..()
	if(!pATV)
		qdel(src)
	ATV = pATV

/datum/action/atvlight/Trigger()
	if(!..())
		return 0
	if(ATV)
		toggle = !toggle
		if(toggle)
			ATV.AddLuminosity(8)
			ATV.visible_message("<span class='notice'>[ATV]'s lights blink on.</span>")
		else
			ATV.AddLuminosity(-8)
			ATV.visible_message("<span class='notice'>[ATV]'s lights slowly diminish.</span>")
	return 1

/obj/vehicle/atv/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		add_overlay(atvcover)
		vlight.Grant(M)
	else
		vlight.Remove(M)
		cut_overlay(atvcover)



//TURRETS!
/obj/vehicle/atv/turret
	var/obj/machinery/porta_turret/syndicate/vehicle_turret/turret = null


/obj/machinery/porta_turret/syndicate/vehicle_turret
	name = "mounted turret"
	scan_range = 7
	emp_vunerable = 1
	density = 0


/obj/vehicle/atv/turret/New()
	. = ..()
	turret = new(loc)
	turret.base = src

/obj/vehicle/atv/turret/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 1)
	. = ..()
	riding_datum = new/datum/riding/atv/turret

