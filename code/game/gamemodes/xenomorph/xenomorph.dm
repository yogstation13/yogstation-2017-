/datum/game_mode/proc/FindHunters(dead)
	var/hcount
	for(var/datum/mind/H in xenomorphs["HUNTERS"])
		if(dead)
			hcount++
		else if(H.current.stat != DEAD)
			hcount++
	return hcount

/datum/game_mode/proc/FindWorkers(dead)
	var/wcount
	for(var/datum/mind/D in xenomorphs["WORKERS"])
		if(dead)
			wcount++
		else if(D.current.stat != DEAD)
			wcount++
	return wcount

/datum/game_mode/proc/checkHive() // if it returns 0 - it can be anything. else it returns a caste
	var/hcount = FindHunters()
	var/wcount = FindWorkers()

	if(hcount == wcount)
		return 0

	if(wcount > hcount)
		return "hunter"
	else
		return "worker"

var/list/turf/xenomorphweeds = list()

/datum/game_mode
	var/list/datum/mind/xenomorphs = list("QUEEN" = list (),"HUNTERS" = list (),"WORKERS" = list ())
	var/list/datum/mind/predators = list()
	var/queensuffix
	var/list/xenoprogressmarker = list("10" = FALSE, "20" = FALSE, "30" = FALSE, "40" = FALSE, "50" = FALSE, "60" = FALSE, "70" = FALSE, "80" = FALSE, "90" = FALSE, "100" = FALSE)
	var/predatorwave = null

	var/living_alien_targets = list()
	var/infested_count

/datum/game_mode/xenomorph
	name = "alien"
	config_tag = "alien"
	antag_flag = ROLE_ALIEN
	required_players = 30
	required_enemies = 1
	recommended_enemies = 3
	enemy_minimum_age = 14

	var/objective
	var/alien_weed_control_count
	var/infest_prc
	var/yautjalaunch = FALSE
	var/ERTlaunch = FALSE
	var/roundstartalert = FALSE
	var/roundstartxenocount


/datum/game_mode/xenomorph/announce()
	world << "<B>The current gamemode is - Alien Infestation!</B>"
	world << "A transportation shuttle mysteriously dissapered while carrying live xenomorphs from a determined \
	uninhabitable planet. Nanotrasen has identified the same creatures to be inhabitating SS13 but, was too late \
	to cancel the next shift.\n<B>Xenomorphs</B>: Restore the Queen's glory and take over the station! Turn it into your \
	own colony! Planting weeds increases the growth of her colony, however make sure to use strategy to outsmart \
	those puny meatbags! Always listen to your queen. You cannot disobey her.\n<B>Personnel</B> : Stop the xenomorphs at \
	all costs! Burn down their weeds and stop the takeover! Save Space Station 13!</B>"

/datum/game_mode/proc/Xregister(var/datum/mind/M)
	if(!M)
		return FALSE

	if(ticker && ticker.current_state == GAME_STATE_FINISHED)
		return FALSE

	else
		return TRUE


/datum/game_mode/xenomorph/proc/AddXenomorph(var/datum/mind/M)
	if(!M)	return
	if(!M.current)	return
	if(!Xregister(M)) return

	if(istype(M.current, /mob/living/carbon/alien/humanoid/hunter))
		AddHunter(M)

	if(istype(M.current, /mob/living/carbon/alien/humanoid/worker))
		AddSenitel(M)

	if(istype(M.current, /mob/living/carbon/alien/humanoid/worker))
		AddDrone(M)

	M.current.memory += translate_objective() + "<BR>"


/datum/game_mode/xenomorph/proc/AddQueen(var/datum/mind/M)
	xenomorphs["QUEEN"] += M
	xenomorphs += M
	M.assigned_role = "xeno queen"
	M.special_role = "xeno queen"

/datum/game_mode/xenomorph/proc/AddHunter(var/datum/mind/M)
	xenomorphs["HUNTERS"] += M
	xenomorphs += M
	M.assigned_role = "xeno hunter"
	M.special_role = "xeno hunter"

/datum/game_mode/xenomorph/proc/AddWorker(var/datum/mind/M)
	xenomorphs["WORKERS"] += M
	xenomorphs += M
	M.assigned_role = "xeno worker"
	M.special_role = "xeno worker"

/datum/game_mode/xenomorph/pre_setup()
	var/player_count = 10
	var/xeno_count = max(1, round(num_players()/player_count))

	var/list/datum/mind/hive = pick_candidate(amount = xeno_count)
	update_not_chosen_candidates()

	var/queen_chosen

	for(var/a in hive)
		var/datum/mind/alive_xenomorph = a
		if(!queen_chosen)
			queen_chosen = TRUE
			AddQueen(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno queen")
			continue
		if(prob(50))
			AddHunter(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno hunter")
			continue
		else
			AddWorker(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno worker")
			continue
		continue
	return 1

/datum/game_mode/xenomorph/proc/check_roundstart_alert()
	if(length(xenomorphs) > roundstartxenocount)
		priority_announce("Xenomorphic lifesigns detected aboard [station_name()]. \
		Secure any exterior access, including ducting and ventilation. All personnel are \
		instructed to assist in the extermination of this species. This is not a drill.",\
		"CRITICAL: Biohazard Alert", 'sound/AI/commandreport.ogg')
		roundstartalert = TRUE // now we can jostle between called and uncalled.
		SSshuttle.emergencyNoEscape = 1

/datum/game_mode/xenomorph/post_setup()

	alien_weed_control_count = rand(950,1250)
	infest_prc = rand(45,75)

	var/list/spawns = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "xeno_game_spawn")
			spawns += A
	var/RNGspawn

	if(length(spawns))
		RNGspawn  = pick(spawns)
	else
		RNGspawn = pick(blobstart)

	objective = pick(OBJECTIVE_CONQUER, OBJECTIVE_INFESTATION)

	for(var/datum/mind/alien_brethern in xenomorphs) // spawning
		var/greeted_forged_moved
		for(var/turf/open/floor/F in orange(1, RNGspawn))
			if(greeted_forged_moved)
				continue
			if(isalien(alien_brethern))
				continue
			var/list/turf/floors = list()
			floors += F
			var/pickfloor = pick(floors)
			alien_brethern.current.loc = pickfloor

			greet_xeno_and_transform(alien_brethern, alien_brethern.assigned_role)
			greeted_forged_moved = TRUE

	roundstartxenocount = length(xenomorphs)
	. = ..()

	var/colony
	var/datum/mind/M = xenomorphs["QUEEN"][1]
	var/mob/living/carbon/alien/A = M.current // runtime error because at random the selected mobs aren't turned into xenomorphs.
	colony = A.HD.colony_suffix
	queensuffix = A.HD.colony_suffix

	if(colony)
		for(var/datum/mind/xenos in xenomorphs)
			if(xenos.special_role == "xeno queen")
				continue
			A = xenos.current
			A.HD.colony_suffix = colony
	else
		message_admins("ERROR: Queen failed to configure a colony suffix. Reloading the queensuffix. Please check the mode under TICKER.")
		update_queen_suffix()
		message_admins("ERROR (2): If the following space is blank then something is very wrong: [queensuffix].")

	return .

/datum/game_mode/xenomorph/proc/greet_xeno_and_transform(datum/mind/hbrain, role)
	if(!role)
		message_admins("ERROR: Xeno Mode's greet_xeno_and_transform() reported a null role.")
		return
	var/mob/living/l
	var/mob/living/M = hbrain.current

	switch(role)
		if("xeno hunter")
			l = new /mob/living/carbon/alien/humanoid/hunter(hbrain.current.loc)

		if("xeno sentinel")
			l = new /mob/living/carbon/alien/humanoid/worker(hbrain.current.loc)

		if("xeno queen")
			l = new /mob/living/carbon/alien/humanoid/royal/queen(hbrain.current.loc)

		if("xeno drone")
			l = new /mob/living/carbon/alien/humanoid/worker(hbrain.current.loc)

	if(!hbrain)
		message_admins("ERROR: [ticker.mode] has failed to greet and transform [hbrain.current] / [hbrain.current.ckey]. Contact a coder!")
		return

	hbrain.transfer_to(l)
	if(!objective)
		objective = pick(OBJECTIVE_CONQUER, OBJECTIVE_INFESTATION) // giving it another shot.

	l.mind.special_role = hbrain.special_role
	l.mind.assigned_role = hbrain.assigned_role
	hbrain.current = l
	l << "<span class='alertalien'>You are a <B>[role]</B>!</span>"
	l.mind.memory += translate_objective() + "<BR>"
	var/mob/living/carbon/alien/A = l
	if(hbrain.special_role != "xeno queen") 	A.HD = new /datum/huggerdatum/default(origin = l)
	qdel(M)

/datum/game_mode/xenomorph/proc/check_for_ERT()
	var/totalcrew = 0
	var/deadcrew = 0
	var/alivecrew = 0
	for(var/mob/living/carbon/human/M in mob_list)
		if(M.get_assignment() && M.job)
			totalcrew++
			if(M.stat == DEAD)
				deadcrew++
			else
				alivecrew++
	var/centcommexpectation = max(alivecrew * 1/8, 1)
	if(ERTlaunch)
		return
	if(alivecrew <= centcommexpectation)
		ERTlaunch = TRUE
		var/type = "Red"
		var/num = 7
		var/obj = "Assist the crew, call the emergency shuttle, collect and report casualities, \
					and exterminate the xenomorphs. <BR> \
					By the time you read this there were [totalcrew] crewmembers in total. [deadcrew] are now deceased, and [alivecrew] are on board."
		makeEmergencyresponseteam(TRUE, type, num, obj)
		priority_announce("An Emergency Response Team has been dispatched to your station. Please standby.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")

/datum/game_mode/xenomorph/check_finished()
	..()

	if(alien_weed_control_count <= xenomorphweeds.len)
		return TRUE

	if(roundstartalert)
		if(calculateXenos(1) == DEAD) // The Queen has died!
			SSshuttle.emergency.mode = SHUTTLE_IDLE
			SSshuttle.emergencyNoEscape = 0
			priority_announce("The Emergency Shuttle can now be called.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")
		else if (!SSshuttle.emergencyNoEscape && calculateXenos(1) != DEAD)
			SSshuttle.emergencyNoEscape = 1
			//SSshuttle.emergency.mode = SHUTTLE_STRANDED
			priority_announce("The Emergency Shuttle can no longer be called.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")
		var/datum/mind/M = getQueen()
		if(M)
			if(M.current)
				if(M.current.z != ZLEVEL_STATION) // The Queen has left the z level!
					if(SSshuttle.emergencyNoEscape)
						SSshuttle.emergencyNoEscape = 0
						priority_announce("The Emergency Shuttle can now be called.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")

	else
		check_roundstart_alert()

	if(!ERTlaunch)
		check_for_ERT()

	check_hive_progress()

	if(!yautjalaunch)
		check_for_predator()

	if(!calculateXenos())
		return FALSE
	else
		return TRUE


#define PREDATOR_COEFF 0.45 // 45%

/datum/game_mode/xenomorph/proc/check_for_predator()
	if(xenomorphweeds.len)
		var/weedcount = length(xenomorphweeds)
		var/pred = alien_weed_control_count * PREDATOR_COEFF
		if(weedcount > pred)
			summonpredators()
			yautjalaunch = TRUE

/datum/game_mode/proc/summonpredators()
	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "pred[predatorwave]")
			var/obj/effect/mob_spawn/human/predator/P = new(get_turf(A))
			notify_ghosts("A Predator Cyropod has been awakened!", source = P, action = NOTIFY_ORBIT)
			var/obj/effect/landmark/L = new(get_turf(A))
			L.name = "pred[predatorwave + 1]"
			qdel(A)
	predatorwave++

/datum/game_mode/xenomorph/declare_completion()
	var/predcount
	for(var/datum/mind/M in predators)
		if(M.current.stat != DEAD)
			predcount++

	var/predtotal = 4 // it initializes on 4
	predtotal += predatorwave * 4 // since 4 is the current limit on the map.

	var/win = FALSE
	var/xenowin
	var/xenowinescape
	var/xenominor

	switch(objective)
		if("conquer")
			if(alien_weed_control_count <= xenomorphweeds.len)
				win = TRUE
				xenowin = "The entire station was taken over by alien weeds."
				xenowinescape = "The station was dominated in alien weeds, but the crew evacuated safely."
				xenominor = "The station was taken over by alien weeds, but the xenomorphs were exterminated."

		if("infestation")
			var/numoftargets = length(living_alien_targets) * (0.01*infest_prc)
			if(infested_count > numoftargets || (!length(living_alien_targets)))
				win = TRUE
				xenowin = "The aliens managed to infest [infest_prc]% of the original crew."
				xenowinescape = "The aliens might have managed to infest [infest_prc]% of the original crew, but \
					a part of it escaped to safety."
				xenominor = "The aliens managed to infest [infest_prc]% of the original crew, but were exterminated \
					in the end."

	if(win)
		if(!calculateXenos())
			feedback_set_details("round_end_result","win - xenomorphs took over")
			if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
				world << "<FONT size = 5><B>Xenomorphs Major Win!</B></FONT>"
				world << "<B>[xenowin]</B>"
			else if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
				world << "<FONT size = 5><B>Xenomorph Minor Win!</B></FONT>"
				world << "<B>[xenowinescape]</B>"
		else
			feedback_set_details("round_end_result","win - xenomorphs exterminated, but weeds took over")
			world << "<FONT size = 5><B>Xenomorphs Minor Win!</B></FONT>"
			world << "<B>[xenominor]</B>"

	else if(station_was_nuked)
		if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
			feedback_set_details("round_end_result", "neutral win - nuked xenos")
			world << "<FONT size = 5><B>Nuclear Win!</B></FONT>"
			world << "<B>The crew evacuated, but had to nuke their station to get rid of the xenomorphs.</B>"
		else
			feedback_set_details("round_end_result", "neutral win - nuked themselves")
			world << "<FONT size = 5><B>Neutral Win!</B></FONT>"
			world << "<B>The crew nuked the station without evacuating to get rid of the xenomorphs!</B>"

	else if (!win)
		if(!calculateXenos())
			if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
				feedback_set_details("round_end_result","neutral - crew left")
				world << "<FONT size = 5><B>Neutral Win</B></FONT>"
				world << "<B>The station and xenomorphs were at war... but the crew somehow evacuated.</B>"

			else
				feedback_set_details("round_end_result","lose - xenomorphs were defeated")
				world << "<FONT size = 5><B>Unknwon Win</B></FONT>"
				world << "<B>The station and xenomorphs were at war... and the round suddenly ended. This is not suppose to happen.</B>"
		else
			feedback_set_details("round_end_result","lose - the xenomorphs were exterminated")
			world << "<FONT size = 5><B>Crew Major Win!</B></FONT>"
			world << "<B>The Research Staff aboard [station_name()] managed to contain the xenomorph outbreak!</B>"

	if(yautjalaunch)
		world << "<B>There was a total of [predtotal] Yautja Predators this shift. [predcount] survived.</B>"
		var/trophynames
		for(var/mob/M in global_trophy_targets)
			trophynames += M.name + ", the [M.job], "
		if(length(trophynames))
			world << "<B>The Yautja Predators hunted down [trophynames]."
	else
		world << "<B>The Yautja Predators were not summoned this round.</B>"
	..()

/datum/game_mode/xenomorph/proc/auto_declare_completion_alien()
	if(istype(ticker.mode,/datum/game_mode/xenomorph) )
		if(length(xenomorphs["QUEEN"]))
			var/queenlen = length(xenomorphs["QUEEN"])
			var/text = "<FONT size = 2><B>The xenomorph queen[(queenlen > 1 ? "s were" : " was")]:</B></FONT>"
			for(var/datum/mind/xeno in xenomorphs["QUEEN"])
				text += printplayer(xeno)
			world << text
		if(predators.len)
			var/text2 = "<BR><FONT size = 2><B>The Predators were:</B></FONT>"
			for(var/datum/mind/pred1 in predators)
				text2 += printplayer(predators)
		return 1

/datum/game_mode/xenomorph/proc/translate_objective()
	switch(objective)
		if(OBJECTIVE_CONQUER)
			return "Your mission is to continously plant alien weeds on the station until you've finally conquered it. \
				Throughout this mission your hive will be updated on how far they've gone."

		if(OBJECTIVE_INFESTATION)
			return "Your mission is to infest [infest_prc]% of crewmembers. This only involves the personnel which arrived \
				at the very start of the shift. Late joins are not counted, though may help you."

/*		if(OBJECTIVE_KILL)
			return "Your mission is brutal. Your Queen has declared full out war on Space Station 13, and your goal is to \
				carry out her decree. The objective is to massacre [murder_prc]% of the crewmembers." */

/datum/game_mode/xenomorph/proc/check_hive_progress()
	if(objective != OBJECTIVE_CONQUER)
		return

	var/goal = alien_weed_control_count
	var/nextlevel = check_for_pecentage()
	if(!nextlevel)
		return
	var/nextlevelMult = nextlevel / 100
	var/calcWeed = goal * nextlevelMult
	if(xenomorphweeds.len > calcWeed)
		xenoprogressmarker[num2text(nextlevel)] = TRUE
		message_xenomorphs("Your hive has dominated [nextlevel]% of the station!", FALSE, "alienannounce")
	else
		var/currentlevel = nextlevel - 10
		nextlevelMult = currentlevel / 100
		var/calcPastWeed = goal * nextlevelMult
		if(xenomorphweeds.len < calcPastWeed)
			xenoprogressmarker[num2text(currentlevel)] = FALSE
			var/regresslevel = currentlevel - 10
			message_xenomorphs("Your weed reproduction has dropped from [currentlevel]% to [regresslevel]%!", FALSE, "alienannounce")

/datum/game_mode/xenomorph/proc/check_for_pecentage()
	if(xenoprogressmarker["10"])
		if(xenoprogressmarker["20"])
			if(xenoprogressmarker["30"])
				if(xenoprogressmarker["40"])
					if(xenoprogressmarker["50"])
						if(xenoprogressmarker["60"])
							if(xenoprogressmarker["70"])
								if(xenoprogressmarker["80"])
									if(xenoprogressmarker["90"])
										if(xenoprogressmarker["100"])
											return 100
									else
										return 90
								else
									return 80
							else
								return 70
						else
							return 60
					else
						return 50
				else
					return 40
			else
				return 30
		else
			return 20
	else
		return 10