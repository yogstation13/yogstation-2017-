/obj/vehicle/car //Non-buckle vehicles in which you can't see the driver. More like a real vehicle.
	name = "car"
	icon_state = "car"
	vehicle_move_delay = 1
	anchored = 1

	var/mob/living/carbon/driver
	var/driver_visible =	FALSE  //Driver visible uses buckling, driver not visible uses contents. Using contents is preferable
	var/on = FALSE //whether the car is started or not
	var/maxhealth = 150
	var/health = 150

	var/horn_sound = null //Leave empty to have no horn on the car
	var/horn_spam_time = 20 //Cooldown inbetween indiviudal honks

	var/ramming = FALSE //Whether or not this car is ramming people.
	var/rammed //To prevent double-ramming due to lag
	var/list/ramming_sounds = list() //Sounds for when you hit a person
	var/list/crash_sounds = list()  //Sounds for when you crash into a structure

	var/can_load_people = FALSE //Whether or not this car can have people in it's trunk, for meme vehicles
	var/list/load_sounds = list() //Sounds for when you load people into your car
	var/mob/list/loaded_humans = list() //Loaded people

	//Action datums
	var/datum/action/innate/car/car_eject/eject_action = new
	var/datum/action/innate/car/car_start/start_action = new
	var/datum/action/innate/car/car_horn/horn_action = new
	var/datum/action/innate/car/dump_load/dump_action = new

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
	if(ramming && !rammed)
		rammed = TRUE
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			src.visible_message("<span class='danger'>[src] rams into [H] and knocks them down!</span>")
			H.Weaken(3)
			if(ramming_sounds.len)
				playsound(loc, pick(ramming_sounds), 75)
		else if(istype(M, /obj/structure) || istype(M, /turf/closed))
			src.visible_message("<span class='warning'>[src] rams into [M] and crashes!</span>")
			if(crash_sounds.len)
				playsound(loc, pick(crash_sounds), 75)
			if(driver) //avoid nasty runtimes
				driver.Weaken(3)
			exit_car()
			if(loaded_humans.len)
				unload_all_humans()
			empty_object_contents()
		rammed = FALSE

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
	else if(can_load_people)
		user.visible_message("<span class='danger'>[user] starts stuffing [target] into [src]</span>")
		if(do_after(user, 20, target = src))
			if(load_sounds.len)
				playsound(loc, pick(load_sounds), 75)
			user.visible_message("<span class='danger'>[user] stuffs [target] into [src]</span>")
			load_human(target)

/obj/vehicle/car/relaymove(driver, direction)
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

/obj/vehicle/car/proc/load_human(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H && H.client && H in range(1))
		loaded_humans += H
	H.forceMove(src)

/obj/vehicle/car/proc/unload_human(mob/living/carbon/human/H, var/atom/newloc = loc)
	H.forceMove(newloc)
	loaded_humans -= H

/obj/vehicle/car/proc/unload_all_humans()
	for(var/mob/living/carbon/human/H in loaded_humans)
		H.Weaken(3)
		unload_human(H)

/obj/vehicle/car/proc/CanStart() //This exists if you want to add more conditions to starting up the car later on
	if(keycheck(driver))
		return 1
	else
		driver << "<span class='warning'>You need to hold the key to start [src]</span>"
