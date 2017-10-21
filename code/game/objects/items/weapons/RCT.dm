/obj/item/weapon/rct
	name = "rapid-crate-teleporter (RCT)"
	desc = "A device used to rapidly teleport crates and closets around, alt-click to reset the location."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcd"
	origin_tech = "bluespace=4;syndicate=3"
	var/abbreviated_name = "RCT"
	var/datum/effect_system/spark_spread/spark_system
	var/turf/setlocation

/obj/item/weapon/rct/New()
	src.spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/rcd/Destroy()
	qdel(spark_system)
	spark_system = null

/obj/item/weapon/rct/attack_self(mob/living/carbon/user)
	if(!isturf(user.loc))
		user << "<span class='notice'>the [abbreviated_name] makes an angry noise.</span>"
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 1)
		return
	setlocation = user.loc
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	user << "<span class='notice'>You set the teleportation location of the [abbreviated_name].</span>"
	if(prob(20))
		src.spark_system.start()

/obj/item/weapon/rct/AltClick(mob/user)
	setlocation = null
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	user << "<span class='notice'>You reset the teleportation location of the [abbreviated_name]."
	if(prob(20))
		src.spark_system.start()

/obj/item/weapon/rct/attack_obj(obj/O, mob/living/user)
	if(istype(O, /obj/structure/closet))
		user << "<span class='notice'>You start teleporting the closet</span>"
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 30, target = O))
			var/obj/structure/closet/closet = O
			user.visible_message("<span class='warning'>Sparks fly from [abbreviated_name] as the [closet] dissapears!</span>")
			spark_system.start()
			if(!setlocation)
				for(var/obj/effect/landmark/C in landmarks_list)
					if(C.name == "carpspawn")
						closet.forceMove(C)
			else
				closet.forceMove(setlocation)

			spark_system.start()
			closet.close()
			if(istype(closet, /obj/structure/closet/crate))
				if(closet.can_weld_shut)
					closet.welded = TRUE
			else
				closet.welded = TRUE
			closet.update_icon()
