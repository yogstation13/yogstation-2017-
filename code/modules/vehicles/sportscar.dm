/obj/vehicle/sportscar
	name = "Nanotrasen 558 SE sport"
	desc = "A beautiful car,merging the modern NanoTrasen ideals with the classic Italian sports car aesthetic.This thing goes F A S T!"
	icon = 'icons/obj/sportscar.dmi'
	icon_state = "rari-open"
	keytype = /obj/item/key
	generic_pixel_x = 0
	generic_pixel_y = 0
	vehicle_move_delay = 0
	pixel_x = -15
	layer = 4.5 //above all mobs, should cause the mob that's riding it to look less dumb

/obj/vehicle/sportscar/Move(newloc,move_dir)
	if(has_buckled_mobs())
		playsound(src,'sound/effects/carrev.ogg',25,1)
	. = ..()

/obj/vehicle/sportscar/handle_vehicle_layer()
	layer = 4.5


/obj/vehicle/sportscar/handle_vehicle_offsets()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.dir = dir
			switch(dir)
				if(NORTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 3
					pixel_x = -15
				if(SOUTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 3
					pixel_x = -15
				if(EAST)
					buckled_mob.pixel_x = 10 //tweak me
					buckled_mob.pixel_y = 5
					pixel_x = 0
				if(WEST)
					buckled_mob.pixel_x = 20
					buckled_mob.pixel_y = 5
					pixel_x = 0

/obj/vehicle/sportscar/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		playsound(src,'sound/effects/unlock.ogg',25,1)
		icon_state = "rari"
	else
		playsound(src,'sound/effects/lock.ogg',25,1)
		icon_state = "rari-open"