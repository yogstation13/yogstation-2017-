/obj/vehicle/car //Non-buckle vehicles in which you can't see the driver. More like a real vehicle.
	name = "car"
	icon = 'icons/obj/car.dmi'
	icon_state = "car"
	var/mob/living/carbon/driver
	var/driver_visible =	FALSE  //Driver visible uses buckling, driver not visible uses contents. Using contents is preferable
	var/on = FALSE //whether the car is started or not
	var/maxhealth = 150
	var/health = 150

	//Car parts
	var/list/obj/item/car_part/installed_parts = list()

	var/obj/item/car_part/engine/engine
	var/obj/item/car_part/trunk/trunk
	var/obj/item/car_part/fuel_can/fuel_can
	var/obj/item/car_part/horn/horn
	var/obj/item/car_part/utility/utility
	var/obj/item/car_part/weapon/weapon

	//Action datums
	var/datum/action/innate/car/car_eject/eject_action = new
	var/datum/action/innate/car/car_start/start_action = new
	var/datum/action/innate/car/car_horn/horn_action = new
	var/datum/action/innate/car/car_weapon/weapon_action = new

/obj/vehicle/car/Destroy()
	exit_car()

/obj/vehicle/car/examine(mob/user)
	..()
	if(driver)
		user << "It seems to be occupied"

/obj/vehicle/car/AltClick(mob/living/user)
	if(trunk)
		trunk.Toggle(user)

/obj/vehicle/car/attackby(obj/item/W, mob/user)
	if(on)
		. = ..()
	else if(istype(W, /obj/item/car_part/engine))
		if(!engine)
			user.visible_message("<span class='danger'>[user] puts [W] into [src]</span>")
			engine = W
			qdel(W)
			vehicle_move_delay = engine.strength
			installed_parts += W
		else
			user << "<span class='warning'>There is no room for [W]</span>"
	else if(istype(W, /obj/item/car_part/trunk))
		if(!trunk)
			user.visible_message("<span class='danger'>[user] puts [W] into [src]</span>")
			trunk = W
			qdel(W)
			installed_parts += W
		else
			user << "<span class='warning'>There is no room for [W]</span>"
	else if(istype(W, /obj/item/car_part/fuel_can))
		if(!fuel_can)
			user.visible_message("<span class='danger'>[user] puts [W] into [src]</span>")
			fuel_can = W
			qdel(W)
			installed_parts += W
		else
			user << "<span class='warning'>There is no room for [W]</span>"
	else if(istype(W, /obj/item/car_part/horn))
		if(!horn)
			user.visible_message("<span class='danger'>[user] puts [W] into [src]</span>")
			horn = W
			qdel(W)
			installed_parts += W
		else
			user << "<span class='warning'>There is no room for [W]</span>"
	else if(istype(W, /obj/item/car_part/utility))
		if(!utility)
			user.visible_message("<span class='danger'>[user] puts [W] into [src]</span>")
			utility = W
			qdel(W)
			installed_parts += W
		else
			user << "<span class='warning'>There is no room for [W]</span>"
	else if(istype(W, /obj/item/car_part/weapon))
		if(!weapon)
			user.visible_message("<span class='danger'>[user] puts [W] into [src]</span>")
			weapon = W
			qdel(W)
			installed_parts += W
		else
			user << "<span class='warning'>There is no room for [W]</span>"
	else if(istype(W, /obj/item/weapon/wrench))
		var/removed_part = input(user, "Remove which equipment?", null, null) as null|anything in installed_parts
		user.put_in_hands(removed_part)
		installed_parts -= W

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
	if(world.time < next_vehicle_move)
		return
	fuel_can.fuel -= engine.fuel_use
	if(fuel_can.fuel < 5)
		on = FALSE
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
	if(engine || fuel_can)
		if(fuel_can.fuel > 5)
			return 1

/obj/vehicle/car/regular
	name = "basic car"
	pixel_x = -15

/obj/vehicle/car/regular/New()
	engine = new /obj/item/car_part/engine
	installed_parts += engine
	trunk = new /obj/item/car_part/trunk
	installed_parts += trunk
	fuel_can = new /obj/item/car_part/fuel_can
	installed_parts += fuel_can
	horn = new /obj/item/car_part/horn
	installed_parts += horn
	utility = new /obj/item/car_part/utility
	installed_parts += utility
	weapon = new /obj/item/car_part/weapon/projectile/tazer
	installed_parts += weapon
	weapon.my_car = src


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
