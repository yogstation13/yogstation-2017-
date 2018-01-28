/datum/round_event_control/borer
	name = "Borer"
	typepath = /datum/round_event/borer
	weight = 15
	max_occurrences = 1

	earliest_start = 12000

/datum/round_event/borer
	announceWhen = 3000 //Borers get 5 minutes till the crew tries to murder them.
	endWhen = 2
	var/spawned = 0

	var/spawncount = 0

	var/borersSpawned = 0
	var/list/vents = list()

/datum/round_event/borer/announce()
	if(spawned)
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg') //Borers seem like normal xenomorphs.


/datum/round_event/borer/start()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in machines)
		if(qdeleted(temp_vent))
			continue
		if(temp_vent.loc.z == ZLEVEL_STATION && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.PARENT1
			if(temp_vent_parent.other_atmosmch.len > 20)
				vents += temp_vent

	if(!vents.len)
		return kill()

	var/total_humans = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.stat != DEAD)
			total_humans++

	total_borer_hosts_needed = round(6 + total_humans/7)

	spawncount += total_borer_hosts_needed



/datum/round_event/borer/tick()
	if(!borersSpawned) //Has the event tried to spawn borers yet?
		borersSpawned = 1

		var/list/mob/dead/observer/candidates = pollCandidates("Do you want to play as a borer?", ROLE_BORER, null, ROLE_BORER, 300)
		if(!candidates.len)
			kill()
			return

		spawncount = Clamp(spawncount, 0, candidates.len)
		spawncount = Clamp(spawncount, 0, vents.len)

		while(spawncount > 0)
			var/obj/vent = pick_n_take(vents)
			var/mob/dead/observer/C = pick_n_take(candidates) //So as to not spawn the same person twice

			var/mob/living/simple_animal/borer/borer = new(vent.loc)
			borer.transfer_personality(C.client)

			spawned++
			spawncount--

			log_game("[borer]/([borer.ckey]) was spawned as a cortical borer.")
			message_admins("[borer]/[borer.ckey] was spawned as a cortical borer.")

