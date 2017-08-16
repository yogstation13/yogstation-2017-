/obj/vehicle/car/proc/GrantActions(mob/living/user)
	if(src.honk_sound)
		horn_action.Grant(user, src)
	eject_action.Grant(user, src)

/obj/vehicle/car/proc/RemoveActions(mob/living/user)
	horn_action.Remove(user)
	eject_action.Remove(user)

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
	if(world.time - last_honk_time > car.honk_spam_time)
		car.visible_message("<span class='danger'>The [car] loudly honks</span>")
		car.driver << "<span class='notice'>You press the car horn.</span>"
		playsound(car.loc, car.honk_sound, 50)
		last_honk_time = world.time
	else
		car.driver << "<span class='notice'>The horn needs to recover first.</span>"
