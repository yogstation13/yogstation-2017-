/datum/round_event_control/blob
	name = "Blob"
	typepath = /datum/round_event/blob
	weight = 5
	max_occurrences = 1

	min_players = 20
	earliest_start = 36000 //60 minutes

	gamemode_blacklist = list("blob") //Just in case a blob survives that long

/datum/round_event/blob
	announceWhen	= 12
	endWhen			= 120
	var/new_rate = 2
	ghost_announce = TRUE //Update this aswell as the ghost_announce proc if you inevitably make blob not force a random player

/datum/round_event/blob/New(var/strength)
	..()
	if(strength)
		new_rate = strength

/datum/round_event/blob/announce()
	priority_announce("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak5.ogg')


/datum/round_event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)
		return kill()
	interest = new/obj/effect/blob/core(T, null, new_rate)
