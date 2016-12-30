// ************************* Barometer! ******************************

/obj/item/device/barometer
	name = "barometer"
	desc = "A persistent device used for tracking weather and storm patterns. IN SPACE!"
	icon_state = "barometer"
	var/cooldown
	var/cooldown_time = 250
	var/accuracy // 0 is the best accuracy.

/obj/item/device/barometer/New()
	..()
	barometers += src

/obj/item/device/barometer/Destroy()
	barometers -= src
	return ..()

/obj/item/device/barometer/proc/ping()
	if(isliving(loc))
		var/mob/living/L = loc
		L << "<span class='notice'>[src] is ready!</span>"
	playsound(get_turf(src), 'sound/machines/click.ogg', 100)

/obj/item/device/barometer/attack_self(mob/user)
	var/turf/T = get_turf(user)
	if(!T)
		return

	playsound(get_turf(src), 'sound/effects/pop.ogg', 100)
	if(world.time < cooldown)
		user << "<span class='warning'>[src] is prepraring itself.</span>"
		return

	//var/area/user_area = T.loc

	var/datum/weather/ongoing_weather = null
	for(var/V in SSweather.existing_weather)
		var/datum/weather/W = V
		if(W.barometer_predictable && (W.target_z == T.z) && !(W.stage == END_STAGE)/* && istype(user_area, W.area_type)*/)
			ongoing_weather = W
			break

	if(ongoing_weather)
		if((ongoing_weather.stage == MAIN_STAGE) || (ongoing_weather.stage == WIND_DOWN_STAGE))
			user << "<span class='warning'>[src] can't trace anything while the storm is [ongoing_weather.stage == MAIN_STAGE ? "already here!" : "winding down."]</span>"
			return

		var/time = butchertime((ongoing_weather.next_hit_time - world.time)/10)
		user << "<span class='notice'>The next [ongoing_weather] will hit in [round(time)] seconds.</span>"
		if(ongoing_weather.aesthetic)
			user << "<span class='warning'>[src] says that the next storm will breeze on by.</span>"
	else
		var/next_hit = SSweather.next_hit_by_zlevel["[T.z]"]
		var/fixed = next_hit ? next_hit - world.time : -1
		if(fixed < 0)
			user << "<span class='warning'>[src] was unable to trace any weather patterns.</span>"
		else
			fixed = butchertime(round(fixed / 10))
			user << "<span class='warning'>A storm will land in approximately [fixed] seconds.</span>"
	cooldown = world.time + cooldown_time
	addtimer(src, "ping", cooldown_time)

/obj/item/device/barometer/proc/butchertime(amount)
	if(!amount)
		return
	if(accuracy)
		var/time = amount
		var/inaccurate = round(accuracy*(1/3))
		if(prob(50))
			time -= inaccurate
		if(prob(50))
			time += inaccurate
		return time
	else
		return amount

/obj/item/device/barometer/mining
	desc = "A special device used for tracking ash storms."

/obj/item/device/barometer/tribal
	desc = "A device handed down from ashwalker to ashwalker. This tool is used to speak with the wind, translate it's whispers, and figure out when a storm will hit."
	accuracy = 20