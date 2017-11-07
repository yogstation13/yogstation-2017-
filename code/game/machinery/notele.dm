/obj/machinery/notele
	name = "anti-teleportation machine"
	desc = "Popular throughout the galaxy for countering teleportation within regions and areas."
	icon_state = "notele"
	var/activated
	var/image/o

/obj/machinery/notele/attack_hand(mob/user)
	activated = !activated
	to_chat(user, "<span class='warning'>You turn [src] [activated ? "on" : "off"].</span>")

	if(activated)
		var/area/A = get_area(src)
		if(A.outdoors)
			to_chat(user, "<span class='warning'>[src] does not work in the outdoors!</span>")
			return

		if(A.noteleport)
			to_chat(user, "<span class='warning'>This area cannot be manipulated by [src]!</span>")
			activated = FALSE
			return

		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		A.noteleport = TRUE
		o = image('icons/obj/machines/gravity_generator.dmi', "activated")
		overlays += o
		feedback_add_details("notele machine","activated")

	else
		playsound(loc, 'sound/effects/bamf.ogg', 50, 1)
		overlays -= o
		o = null
		to_chat(user, "<span class='warning'>You deactivate [src].</span>")

		var/area/A = get_area(src)
		if(A.noteleport)
			A.noteleport = FALSE

		feedback_add_details("notele machine","deactivated")

/obj/machinery/notele/Destroy()
	visible_message("<span class='warning'>[src] begins erupting!</span>")
	var/area/A = get_area(src)
	if(A.noteleport)
		A.noteleport = FALSE
	if(activated)
		overlays -= o
		o = null
	..()