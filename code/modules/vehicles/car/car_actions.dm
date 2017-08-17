/obj/vehicle/car/proc/GrantActions(mob/living/user)
	if(horn_sound)
		horn_action.Grant(user, src)
	eject_action.Grant(user, src)
	start_action.Grant(user, src)
	dump_action.Grant(user, src)

/obj/vehicle/car/proc/RemoveActions(mob/living/user)
	if(horn_sound)
		horn_action.Remove(user)
	eject_action.Remove(user)
	start_action.Remove(user)
	dump_action.Remove(user)

/datum/action/innate/car
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUNNED | AB_CHECK_CONSCIOUS
	var/obj/vehicle/car/car

/datum/action/innate/car/Grant(mob/living/L, obj/vehicle/car/C)
	. = ..()
	car = C

/datum/action/innate/car/Destroy()
	. = ..()
	car = null

/datum/action/innate/car/car_eject
	name = "Get out of car"
	button_icon_state = "car_eject"

/datum/action/innate/car/car_eject/Activate()
	if(!owner || !iscarbon(owner))
		return
	if(!car || car.driver != owner)
		return
	car.exit_car()

/datum/action/innate/car/car_horn
	name = "Honk"
	button_icon_state = "car_horn"
	var/last_honk_time

/datum/action/innate/car/car_horn/Activate()
	if(world.time - last_honk_time > car.horn_spam_time)
		car.visible_message("<span class='danger'>[car] loudly honks</span>")
		car.driver << "<span class='notice'>You press the car horn.</span>"
		playsound(car.loc, car.horn_sound, 75)
		last_honk_time = world.time
	else
		car.driver << "<span class='notice'>The horn needs to recover first.</span>"

/datum/action/innate/car/car_start
	name = "Toggle Ignition"
	button_icon_state = "car_horn"

/datum/action/innate/car/car_start/Activate()
	if(car.CanStart())
		if(car.on)
			button_icon_state = "car_eject"
		else
			button_icon_state = "car_horn"
			playsound(car.loc, 'sound/effects/car_start.ogg', 50)
		car.on = !car.on

/datum/action/innate/car/dump_load
	name = "Dump contents"
	button_icon_state = "car_horn"

/datum/action/innate/car/dump_load/Activate()
	car.visible_message("<span class='danger'>[car] dumps all of it's contents on the floor.	</span>")
	if(car.loaded_humans.len)
		car.unload_all_humans()
	car.empty_object_contents()
