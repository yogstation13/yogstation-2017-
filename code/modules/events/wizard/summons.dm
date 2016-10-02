/datum/round_event_control/wizard/summonguns //The Classic
	name = "Summon Guns"
	weight = 1
	typepath = /datum/round_event/wizard/summonguns/
	max_occurrences = 1
	earliest_start = 0

/datum/round_event_control/wizard/summonguns/New()
	if(config.no_summon_guns)
		weight = 0
	..()

/datum/round_event/wizard/summonguns/start()
	summon_guns(null, 10)

/datum/round_event_control/wizard/summonmagic //The Somewhat Less Classic
	name = "Summon Magic"
	weight = 1
	typepath = /datum/round_event/wizard/summonmagic/
	max_occurrences = 1
	earliest_start = 0

/datum/round_event_control/wizard/summonmagic/New()
	if(config.no_summon_magic)
		weight = 0
	..()

/datum/round_event/wizard/summonmagic/start()
	summon_magic(null, 10)