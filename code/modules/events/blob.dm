/datum/round_event_control/blob
	name = "Blob"
	typepath = /datum/round_event/blob
	weight = 10
	max_occurrences = 1

	min_players = 30

	gamemode_blacklist = list("blob", "nuclear", "revolution") //Just in case a blob survives that long

/datum/round_event/blob
	announceWhen	= 12
	endWhen			= 120

/datum/round_event/blob/announce()
	priority_announce("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak5.ogg')


/datum/round_event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)
		return kill()

	var/list/mob/dead/observer/candidates = pollCandidates("Do you want to play as a blob?", ROLE_BLOB, null, FALSE, 200)
	if(!candidates.len)
		return kill()
	
	for(var/client/C in candidates)
		if(!(C.prefs.toggles & MIDROUND_ANTAG))
			candidates -= C
			
	if(!candidates.len)
		return kill()

	var/mob/dead/observer/new_blob = pick(candidates)
	if(!new_blob)
		return kill()

	new_blob.become_overmind()
	message_admins("[new_blob]/([new_blob.key]) has been made into a blob overmind by an event.")
	log_game("[new_blob]/([new_blob.key]) was spawned as a blob overmind by an event.")