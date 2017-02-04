/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	startWhen = 3
	endWhen = startWhen + 1
	announceWhen	= 1

/datum/round_event/radiation_storm/announce()
	priority_announce("High levels of radiation detected near the station. Enter maintenence immediately to avoid life-threatening damage..", "Anomaly Alert", 'sound/AI/radiation.ogg')
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	SSweather.run_weather("radiation storm",1)
	if(!emergency_access)
		make_maint_all_access()
