/obj/effect/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blank_blob"
	desc = "A huge, pulsating yellow mass."
	health = 400
	maxhealth = 400
	explosion_block = 6
	point_return = -1
	atmosblock = 1
	heatblock = 1
	health_regen = 0 //we regen in Life() instead of when pulsed
	var/overmind_get_delay = 0 //we don't want to constantly try to find an overmind, this var tracks when we'll try to get an overmind again
	var/core_regen = 2
	var/resource_delay = 0
	var/point_rate = 2


/obj/effect/blob/core/New(loc, client/new_overmind = null, new_rate = 2, placed = 0)
	blob_cores += src
	START_PROCESSING(SSobj, src)
	poi_list |= src
	update_icon() //so it atleast appears
	if(!placed && !overmind)
		qdel(src)

	if(overmind)
		update_icon()

	point_rate = new_rate
	..()

/obj/effect/blob/core/scannerreport()
	return "Directs the blob's expansion, gradually expands, and sustains nearby blob spores and blobbernauts."

/obj/effect/blob/core/update_icon()
	overlays.Cut()
	color = null
	var/image/I = new('icons/mob/blob.dmi', "blob")
	if(overmind)
		I.color = overmind.blob_reagent_datum.color
	overlays += I
	var/image/C = new('icons/mob/blob.dmi', "blob_core_overlay")
	overlays += C

/obj/effect/blob/core/Destroy()
	blob_cores -= src
	if(overmind)
		overmind.blob_core = null

	overmind = null
	STOP_PROCESSING(SSobj, src)
	poi_list -= src
	return ..()

/obj/effect/blob/core/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/effect/blob/core/ex_act(severity, target)
	var/damage = 50 - 10 * severity //remember, the core takes half brute damage, so this is 20/15/10 damage based on severity
	take_damage(damage, BRUTE)

/obj/effect/blob/core/check_health()
	..()
	if(overmind) //we should have an overmind, but...
		overmind.update_health_hud()

/obj/effect/blob/core/Life()
	if(!overmind)
		qdel(src)
	else
		if(resource_delay <= world.time)
			resource_delay = world.time + 10 // 1 second
			overmind.add_points(point_rate)

	health = min(maxhealth, health+core_regen)
	if(overmind)
		overmind.update_health_hud()

	Pulse_Area(overmind, 12, 4, 3)
	for(var/obj/effect/blob/normal/B in range(1, src))
		if(prob(5))
			B.change_to(/obj/effect/blob/shield/core, overmind)

	..()