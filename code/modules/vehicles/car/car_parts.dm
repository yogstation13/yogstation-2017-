obj/item/car_part
	name = "car parts"
	icon = 'icons/obj/car_parts.dmi'
	force = 4
	throwforce = 4
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT

/obj/item/car_part/frame
	name = "car frame"
	description = "Looks like the frame of a car"

/obj/item/car_part/wheel
	name = "wheel"
	description = "Looks like the frame of a car"

/obj/item/car_part/engine
	name = "engine"
	description = "Looks like the frame of a car"
	var/strength = 1 //SPEEEEEEEEED
	var/fuel_drain = 1
	var/fuel_type =

/obj/item/car_part/trunk
	name = "car trunk"
	description = "Looks like the frame of a car"
	var/max_mob_size = MOB_SIZE_HUMAN //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 1 // how many human sized mob/living can fit together inside the trunk.
	var/storage_capacity = 10

/obj/item/car_part/fuel_can
	name = "fuel canister"
	description = "Looks like the frame of a car"
	var/fuel_amount = 100

/obj/item/car_part/horn
	name = "car horn"
	description = "Looks like the frame of a car"
	var/honk_sound = 'sound/items/bikehorn.ogg' //Leave null if you don't want the car to honk
	var/honk_spam_time = 30 //How long before the car can honk again in deciseconds.

/obj/item/car_part/utility
	name = "car utility part"
	description = "Looks like the frame of a car"

/obj/item/car_part/weapons
	name = "car weapon part"
	description = "Looks like the frame of a car"
