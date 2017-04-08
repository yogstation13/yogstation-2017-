//Used for all kinds of weather, ex. lavaland ash storms.
SUBSYSTEM_DEF(weather)
	name = "Weather"
	flags = SS_BACKGROUND
	wait = 10
	var/list/processing = list()
	var/list/existing_weather = list()
	var/list/eligible_zlevels = list(ZLEVEL_LAVALAND)
	var/list/next_hit_by_zlevel = list() //Used by barometers to know when the next storm is coming

/datum/controller/subsystem/weather/fire()
	for(var/V in processing)
		var/datum/weather/W = V
		if(W.aesthetic)
			continue
		for(var/mob/living/L in GLOB.mob_list)
			if(W.can_impact(L))
				W.impact(L)
	for(var/Z in eligible_zlevels)
		var/list/possible_weather_for_this_z = list()
		for(var/V in existing_weather)
			var/datum/weather/WE = V
			if(WE.target_z == Z && WE.probability) //Another check so that it doesn't run extra weather
				possible_weather_for_this_z[WE] = WE.probability
		var/datum/weather/W = pickweight(possible_weather_for_this_z)
		if(!W)
			continue
		run_weather(W.name)
		eligible_zlevels -= Z
<<<<<<< HEAD
		var/randTime = rand(3000, 6000) //Around 5-10 minutes between weathers
		addtimer(src, "make_z_eligible", randTime, TIMER_UNIQUE, Z)
		next_hit_by_zlevel["[Z]"] = world.time + randTime + W.telegraph_duration
=======
		addtimer(CALLBACK(src, .proc/make_z_eligible, Z), rand(3000, 6000) + W.weather_duration_upper, TIMER_UNIQUE) //Around 5-10 minutes between weathers
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	..()
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		new W	//weather->New will handle adding itself to the list

/datum/controller/subsystem/weather/proc/run_weather(weather_name, Z)
	if(!weather_name)
		return
	for(var/V in existing_weather)
		var/datum/weather/W = V
		if(W.name == weather_name && W.target_z == Z)
			W.telegraph()

/datum/controller/subsystem/weather/proc/make_z_eligible(zlevel)
	eligible_zlevels |= zlevel
	next_hit_by_zlevel["[zlevel]"] = null
