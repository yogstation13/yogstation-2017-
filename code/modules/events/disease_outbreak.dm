/datum/round_event_control/disease_outbreak
	name = "Disease Outbreak"
	typepath = /datum/round_event/disease_outbreak
	max_occurrences = 1
	min_players = 10
	weight = 5

/datum/round_event/disease_outbreak
	announceWhen	= 15

	var/virus_type
	ghost_announce = null //Gets overwritten in start(), this way we can have both the victim AND the virus


/datum/round_event/disease_outbreak/announce()
	priority_announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak7.ogg')

/datum/round_event/disease_outbreak/setup()
	announceWhen = rand(15, 30)

/datum/round_event/disease_outbreak/start()
	if(!virus_type)
		virus_type = pick(/datum/disease/dnaspread, /datum/disease/fluspanish, /datum/disease/cold9, /datum/disease/brainrot, /datum/disease/magnitis, /datum/disease/dna_retrovirus, /datum/disease/beesease)

	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 1)
			continue
		var/foundAlready = 0	// don't infect someone that already has the virus
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
			break
		if(H.stat == DEAD || foundAlready)
			continue

		var/datum/disease/D
		if(virus_type == /datum/disease/dnaspread)		//Dnaspread needs strain_data set to work.
			if(!H.dna || (H.disabilities & BLIND))	//A blindness disease would be the worst.
				continue
			D = new virus_type()
			var/datum/disease/dnaspread/DS = D
			DS.strain_data["name"] = H.real_name
			DS.strain_data["UI"] = H.dna.uni_identity
			DS.strain_data["SE"] = H.dna.struc_enzymes
		else
			D = new virus_type()
		H.AddDisease(D)
		D.carrier = 1
		ghost_announce = "[H.name] has been infected with [D.name]"
		interest = H
    
		message_admins("[H.real_name]/([H.key]) has been infected with [D.name] by an event.")
		log_game("[H.real_name]/([H.key]) has been infected with [D.name] by an event.")
		H.investigate_log("[H.real_name]/([H.key]) has been infected with [D.name] by an event.", "viro")

		break
