/obj/vehicle/car //Non-buckle vehicles in which you can't see the driver. More like a real vehicle.
	name = "car"
	icon_state = "car"
	var/mob/living/carbon/driver
	var/driver_visible =	1 //Driver visible uses buckling, driver not visible uses contents.

	var/honk_sound = 'sound/items/bikehorn.ogg' //Leave null if you don't want the car to honk
	var/honk_spam_time = 30 //How long before the car can honk again in deciseconds.

	//Car parts


	//Action datums
	var/datum/action/innate/car/car_eject/eject_action = new
	var/datum/action/innate/car/car_horn/horn_action = new

/obj/vehicle/car/Destroy()
	exit_car()

/obj/vehicle/car/attackby(obj/item/W, mob/user)
	if(driver && driver_visible && W.force)
		W.attack(driver, user)
	else
		. = ..()

/obj/vehicle/car/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if(user.incapacitated() || user.lying	|| !ishuman(user))
		return
	if(!istype(target) || target.buckled)
		return

	if(user == target)
		if(driver)
			usr << "<span class='warning'>The [name] is already occupied!</span>"
			return
		user.visible_message("<span class='danger'>[user] starts getting into the [src]</span>")
		if(do_after(user, 20, target = src))
			user.visible_message("<span class='danger'>[user] gets into the [src]</span>")
			enter_car(user)

/obj/vehicle/car/proc/enter_car(mob/living/carbon/human/H)
	if(H && H.client && H in range(1))
		driver = H
		GrantActions(H)

		if(driver_visible) //Buckling
			user_buckle_mob(H, H, FALSE)
			message_admins("gay")
		else //Using contents
			H.forceMove(src)
			forceMove(loc)
			add_fingerprint(H)
		return 1
	else
		return 0

/obj/vehicle/car/proc/exit_car(var/forced, var/atom/newloc = loc)
	if(!driver)
		return
	if(!ishuman(driver))
		return

	driver = null
	RemoveActions(driver)

	if(driver_visible) //Buckling
		driver.unbuckle_mob(driver, forced)
	else //Using contentsssss
		driver.forceMove(newloc)

/obj/vehicle/car/examine(mob/user)
	..()
	if(driver)
		user << "It seems to be occupied"


/*
/obj/vehicle/car/clown
	name = "clown car"
	desc = "How someone could even fit in there is beyond me."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "clowncar"
	density = 1
	anchored = 0
	vehicle_move_delay = 2 //tick delay between movements, lower = faster, higher = slower
	view_range = 7


/obj/vehicle/car/clown/Bump(atom/movable/M)
	. = ..()
	if(M == var/mob/living/carbon/human/H)
		H.knockdown(50)
	else if(M == obj/structure) */
