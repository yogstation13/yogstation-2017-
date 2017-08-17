obj/item/car_part
	name = "car parts"
	icon = 'icons/obj/car_parts.dmi'
	force = 4
	throwforce = 4
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	var/obj/vehicle/car/my_car

/obj/structure/car_frame
	name = "car frame"
	desc = "Looks like a regular car frame"
	icon = 'icons/obj/car.dmi'
	icon_state = "basic_frame"
	var/required_wheels = 4 //For snowflake "cars" that don't use 4 wheels
	var/required_metal = 10
	var/wheel_count = 0 //Amount of wheels attached
	var/car_type = /obj/vehicle/car //Type of car to spawn when it has wheels and metal

/obj/structure/car_frame/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/sheet/metal))
		if(wheel_count == required_wheels)
			var/obj/item/stack/sheet/metal/M = W
			if (M.use(required_metal))
				if(do_after(user, 20, target = src))
					user << "<span class='notice'>You add the metal plating to the car frame.</span>"
					new car_type(loc)
					qdel(src)
			else
				user << "<span class='warning'>You need [required_metal] sheets of metal to add the plating</span>"
				return
	else if(istype(W, /obj/item/car_part/wheel))
		if(wheel_count < required_wheels)
			if(do_after(user, 20, target = src))
				var/obj/item/car_part/wheel/WH = W
				user << "<span class='notice'>You add the wheel to the car frame.</span>"
				wheel_count++
				qdel(WH)
		else
			user << "<span class='notice'>The car already has 4 wheels.</span>"

/obj/item/car_part/wheel
	name = "wheel"
	desc = "Looks like the wheel of a car"
	icon_state = "wheel_stock"

//ENGINES//
/obj/item/car_part/engine
	name = "engine"
	desc = "Looks like the engine of a car"
	icon_state = "engine_stock"
	var/strength = 0.75 //Lower is faster
	var/fuel_use = 1 //Fuel use per tile

	var/start_sound = 'sound/effects/car_start.ogg'

//TRUNKS//
/obj/item/car_part/trunk
	name = "car trunk"
	desc = "Looks like the trunk of a car"
	icon_state = "trunk_stock"
	var/open
	var/obj/structure/closet/closet = new

/obj/item/car_part/trunk/proc/Toggle(mob/living/user)
	closet.toggle(user)

//FUEL CANS//
/obj/item/car_part/fuel_can
	name = "fuel canister"
	icon_state = "fueltank_stock"
	desc = "Looks like the fuel canister of a car"
	var/fuel = 1000

//CAR HORNS//
/obj/item/car_part/horn
	name = "car horn"
	desc = "Looks like the horn of a car"
	icon_state = "horn_stock"
	var/honk_sound = 'sound/items/bikehorn.ogg' //Leave null if you don't want the car to honk
	var/honk_spam_time = 20 //How long before the car can honk again in deciseconds.

//UTILITY ITEMS//
/obj/item/car_part/utility
	name = "car utility part"
	desc = "Looks like the utlity of a car"

//CAR WEAPONS//
/obj/item/car_part/weapon
	name = "car weapon part"
	desc = "Looks like the weapon of a car"

/obj/item/car_part/weapon/proc/Fire()
	return

//PROJECTILE CAR WEAPONS//
/obj/item/car_part/weapon/projectile
	name = "car weapon"
	var/projectile_type
	var/shots_per = 1
	var/fire_sound
	var/fire_delay = 15
	var/next_firetime

/obj/item/car_part/weapon/projectile/Fire()
	if(next_firetime > world.time)
		usr << "<span class='warning'>Your weapons are recharging.</span>"
		return
	for(var/i = 0; i < shots_per; i++)
		var/proj_type = text2path(projectile_type)
		var/obj/item/projectile/proj = new proj_type(my_car.loc)
		proj.starting = get_turf(my_car)
		proj.firer = usr
		proj.def_zone = "chest"
		playsound(my_car.loc, fire_sound, 50, 1)
		proj.dumbfire(my_car.dir)

	next_firetime = world.time + fire_delay

/obj/item/car_part/weapon/projectile/tazer
	name = "car tazer"
	icon_state = "tazer"
	projectile_type = "/obj/item/projectile/beam/disabler"
	shots_per = 1
	fire_sound = "sound/weapons/Taser.ogg"
	fire_delay = 25
