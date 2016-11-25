#define STARTUP_STAGE 1
#define MAIN_STAGE 2
#define WIND_DOWN_STAGE 3
#define END_STAGE 4

/datum/weather
	var/name = "storm"
	var/start_up_time = 300 //30 seconds
	var/start_up_message = "The wind begins to pick up."
	var/start_up_sound
	var/duration = 120 //2 minutes
	var/duration_lower = 120
	var/duration_upper = 120
	var/duration_sound
	var/duration_message = "A storm has started!"
	var/wind_down = 300 // 30 seconds
	var/wind_down_message = "The storm is passing."
	var/wind_down_sound

	var/target_z = 1
	var/exclude_walls = TRUE
	var/area_type = /area/space
	var/stage = STARTUP_STAGE


	var/start_up_overlay = "lava"
	var/duration_overlay = "lava"
	var/overlay_layer = AREA_LAYER //This is the default area layer, and above everything else. TURF_LAYER is floors/below walls and mobs.
	var/purely_aesthetic = FALSE //If we just want gentle rain that doesn't hurt people
	var/list/impacted_areas = list()
	var/immunity_type = "storm"

	var/duration_timer // handled in process_time()

/datum/weather/New()
	..()
	START_PROCESSING(SSobj, src)

/datum/weather/proc/weather_start_up()
	for(var/area/N in get_areas(area_type))
		if(N.z == target_z)
			impacted_areas += N
	duration = rand(duration_lower,duration_upper)
	update_areas()
	for(var/mob/M in player_list)
		if(M.z == target_z)
			M << "<span class='warning'><B>[start_up_message]</B></span>"
			if(start_up_sound)
				M << start_up_sound
	duration_timer = (start_up_time / 20) // subbed from /10 ) -15
	sleep(start_up_time)
	stage = MAIN_STAGE
	weather_main()

/datum/weather/process()
	spawn(1)
		if(duration_timer)
			duration_timer--


/datum/weather/proc/weather_main()
	update_areas()
	for(var/mob/M in player_list)
		if(M.z == target_z)
			M << "<span class='userdanger'><i>[duration_message]</i></span>"
			if(duration_sound)
				M << duration_sound
	if(purely_aesthetic)
		sleep(duration*10)
	else  //Storm effects
		for(var/i in 1 to duration-1)
			for(var/mob/living/L in living_mob_list)
				var/area/storm_area = get_area(L)
				if(storm_area in impacted_areas)
					storm_act(L)
			sleep(10)

	stage = WIND_DOWN_STAGE
	weather_wind_down()

/datum/weather/proc/weather_wind_down()
	update_areas()
	for(var/mob/M in player_list)
		if(M.z == target_z)
			M << "<span class='danger'><B>[wind_down_message]</B></span>"
			if(wind_down_sound)
				M << wind_down_sound
	sleep(wind_down)

	stage = END_STAGE
	update_areas()


/datum/weather/proc/storm_act(mob/living/L)
	if(immunity_type in L.weather_immunities)
		return

/datum/weather/proc/update_areas()
	for(var/area/N in impacted_areas)
		N.layer = overlay_layer
		N.icon = 'icons/effects/weather_effects.dmi'
		N.invisibility = 0
		switch(stage)
			if(STARTUP_STAGE)
				N.icon_state = start_up_overlay

			if(MAIN_STAGE)
				N.icon_state = duration_overlay

			if(WIND_DOWN_STAGE)
				N.icon_state = start_up_overlay

			if(END_STAGE)
				N.icon_state = initial(N.icon_state)
				N.icon = 'icons/turf/areas.dmi'
				N.layer = AREA_LAYER //Just default back to normal area stuff since I assume setting a var is faster than initial
				N.invisibility = INVISIBILITY_MAXIMUM
				N.opacity = 0

/obj/item/device/barometer/attack_self(mob/user)
	if(world.time < cooldown)
		user << "<span class='warning'>[src] is prepraring itself.</span>"
		return 0
	if(!weather)
		user << "<span class='warning'>[src] was unable to trace any weather patterns! You should take some time to wait..</span>"
		return 0
	if(weather.stage == (MAIN_STAGE || WIND_DOWN_STAGE))
		user << "<span class='warning'>[src] can't trace anything while the storms are [weather.stage == MAIN_STAGE ? "already here!" : "winding down."]</span>"
		return 0

	cooldown = world.time + 50
	playsound(get_turf(src), 'sound/effects/pop.ogg', 100)
	var/time = weather.duration_timer
	if(accuracy)
		var/inaccurate = round(accuracy*(1/3))
		if(prob(50))
			time -= inaccurate
		if(prob(50))
			time += inaccurate

	user << "<span class='notice'>The next [weather] will hit in [round(time)] seconds.</span>"