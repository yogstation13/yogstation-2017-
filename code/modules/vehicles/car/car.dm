/obj/vehicle/car //Non-buckle vehicles in which you can't see the driver. More like a real vehicle.
	name = "car"
	icon = 'icons/obj/car.dmi'
	icon_state = "car"
	var/mob/living/carbon/driver
	var/driver_visible =	FALSE  //Driver visible uses buckling, driver not visible uses contents. Using contents is preferable
	var/on = FALSE //whether the car is started or not
	var/maxhealth = 150
	var/health = 150

	var/horn_sound = null //Leave empty to have no horn on the car

	//Action datums
	var/datum/action/innate/car/car_eject/eject_action = new
	var/datum/action/innate/car/car_start/start_action = new
	var/datum/action/innate/car/car_horn/horn_action = new

/obj/vehicle/car/Destroy()
	exit_car()

/obj/vehicle/car/examine(mob/user)
	..()
	if(driver)
		user << "It seems to be occupied"

/obj/vehicle/car/Bump(atom/movable/M)
	. = ..()
	if(auto_door_open && istype(M, /obj/machinery/door))
		M.Bumped(driver)

/obj/vehicle/car/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if(user.incapacitated() || user.lying	|| !ishuman(user))
		return
	if(!istype(target) || target.buckled)
		return

	if(user == target)
		if(driver)
			user << "<span class='warning'>[name] is already occupied!</span>"
			return
		user.visible_message("<span class='danger'>[user] starts getting into [src]</span>")
		if(do_after(user, 20, target = src))
			user.visible_message("<span class='danger'>[user] gets into [src]</span>")
			enter_car(user)

/obj/vehicle/car/relaymove(mob/user, direction)
	if(!on)
		return
	.=..()

/obj/vehicle/car/proc/enter_car(mob/living/carbon/human/H)
	if(H && H.client && H in range(1))
		driver = H
		GrantActions(H)

		if(driver_visible) //Buckling
			user_buckle_mob(H, H, FALSE)
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
	RemoveActions(driver)
	if(driver_visible) //Buckling
		driver.unbuckle_mob(driver, forced)
	else //Using contents
		driver.forceMove(newloc)
	driver = null

/obj/vehicle/car/proc/CanStart()
	return 1

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
