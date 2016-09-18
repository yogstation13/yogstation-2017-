#define PREDATORS_UNKNOWN 0
#define PREDATORS_ALIVE 1
#define PREDATORS_DEAD 2

var/list/turf/xenomorphweeds = list()

/datum/game_mode

	// we use these lists to balance out the hive
	// xenomorphs["QUEEN"]
	var/list/datum/mind/xenomorphs = list(
	"QUEEN" = list (),
	"HUNTERS" = list (),
	"SENITELS" = list (),
	"DRONES" = list ()
	)

	var/list/datum/mind/predators = list()
	var/predstatus = PREDATORS_UNKNOWN

/datum/game_mode/xenomorph
	name = "alien" //infestation
	config_tag = "alien"
	antag_flag = ROLE_ALIEN
	/*
	required_players = 30
	required_enemies = 1
	recommended_enemies = 3
	enemy_minimum_age = 14
	*/
	required_players = 1
	required_enemies = 1
	recommended_enemies = 1

	var/alien_weed_control_count
	var/yautijalaunch
	var/ERTlaunch


/datum/game_mode/xenomorph/announce()
	world << "<B>The current gamemode is - Alien Infestation!</B>"
	world << "A transportation shuttle mysteriously dissapered while carrying live xenomorphs from a determined \
	uninhabitable planet. Nanotrasen has identified the same creatures to be inhabitating SS13 but, was too late \
	to cancel the next shift.\n<B>Xenomorphs</B>: Restore the Queen's glory and make turn the station into your \
	own colony! Planting weeds increases the growth of her colony, however make sure to use strategy to outsmart \
	the puny meatbags! Always listen to the queen. You may never disobey her.\n<B>Personnel</B> : Stop the xenomorphs \
	and save SS13! Make sure to eradicated any sort of alien weeds when you see them because they'll use those to \
	take over!</B>"

/datum/game_mode/xenomorph/pre_setup()
	var/player_count = num_players()
	var/xeno_count = max(1, round(num_players()/player_count))

	var/list/datum/mind/hive = pick_candidate(amount = xeno_count)
	update_not_chosen_candidates()

	var/queen_chosen
	var/drone_chosen
	var/hunter_sentinel_ticker

	for(var/a in hive)
		var/datum/mind/alive_xenomorph = a
		if(!queen_chosen)
			queen_chosen = TRUE
			xenomorphs["QUEEN"] += alive_xenomorph
			xenomorphs += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno queen"
			alive_xenomorph.special_role = "xeno queen"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno queen")
			continue

		var/hunt_guard_diff_prob = 100

		if(hunter_sentinel_ticker)
			hunt_guard_diff_prob = hunt_guard_diff_prob / 2

		if(prob(hunt_guard_diff_prob))
			hunter_sentinel_ticker++
			xenomorphs["HUNTERS"] += alive_xenomorph
			xenomorphs += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno hunter"
			alive_xenomorph.special_role = "xeno hunter"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno hunter")
			continue


		if(prob(hunt_guard_diff_prob + 40)) // 90% chance if you aren't being a hunter, 10% chance for drone. 140% chance (for sentinel) if a hunter hasn't been chosen.
			xenomorphs["SENTINELS"] += alive_xenomorph
			xenomorphs += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno sentinel"
			alive_xenomorph.special_role = "xeno sentinel"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno sentinel")
			continue

		else if(!drone_chosen)
			drone_chosen = TRUE
			xenomorphs["DRONES"] += alive_xenomorph
			xenomorphs += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno drone"
			alive_xenomorph.special_role = "xeno drone"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno drone")
			continue

		else
			continue

	return 1

/datum/game_mode/xenomorph/post_setup()

	var/obj/effect/landmark/alien_spawn
	var/list/spawns = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "xeno-spawn")
			spawns += A

	var/RNGspawn = pick(spawns)
	alien_spawn = RNGspawn

	for(var/datum/mind/alien_brethern in xenomorphs)
		var/greeted_forged_moved
		for(var/turf/open/floor/F in orange(1, alien_spawn))
			if(greeted_forged_moved)
				continue
			var/list/turf/floors = list()
			floors += F
			var/pickfloor = pick(floors)
			alien_brethern.current.loc = pickfloor

			greet_xeno_and_transform(alien_brethern, alien_brethern.assigned_role)
			greeted_forged_moved = TRUE

	var/shuffle_universe_luck = rand(2570,3000) // this at least gives time for the queen to prepare. I don't want to make anyone anxious - Super

	spawn(shuffle_universe_luck)
		priority_announce("Xenomorphic lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation. All personel are instructed to assist in the extermination of this species. This is not a drill.", "CRITICAL: Biohazard Alert", 'sound/machines/Alarm.ogg')
		SSshuttle.emergency.mode = SHUTTLE_STRANDED
	return ..()

/datum/game_mode/xenomorph/proc/greet_xeno_and_transform(datum/mind/hbrain, role)
	if(!role)
		return
	var/mob/living/M = hbrain.current
	var/mob/living/l

	switch(role)
		if("xeno hunter")
			l = new /mob/living/carbon/alien/humanoid/hunter(M.loc)

		if("xeno sentinel")
			l = new /mob/living/carbon/alien/humanoid/sentinel(M.loc)

		if("xeno queen")
			l = new /mob/living/carbon/alien/humanoid/royal/queen(M.loc)

		if("xeno drone")
			l = new /mob/living/carbon/alien/humanoid/drone(M.loc)

	if(hbrain)
		hbrain.transfer_to(l)
		var/datum/objective/weedconquer/W = new
		W.owner = l
		l.mind.objectives += W
		l << "<span class='alertalien'>You are a <B>[role]</B>!</span>"
		l << "<B><span class='alien'>Objective #1</B>: [W.explanation_text]</span>"
	else
		message_admins("ERROR: [ticker.mode] has failed to greet and transform [M] / [M.ckey]. Contact a coder!")
	qdel(M)

/datum/objective/weedconquer
	explanation_text = "Take over the station with your alien weeds!"

/datum/objective/weedconquer/check_completion()
	if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/xenomorph))
		var/datum/game_mode/xenomorph/X = ticker.mode
		if(X.alien_weed_control_count <= xenomorphweeds.len)
			return 1
	return 0

/datum/game_mode/xenomorph/check_finished()
	if(!alien_weed_control_count)
		alien_weed_control_count = rand(950,1250)
		return 0

	if(alien_weed_control_count <= xenomorphweeds.len)
		return 1

	var/predatorcount
	if(yautijalaunch)
		for(var/datum/mind/M in predators.len)
			if(M.current && M.current.stat != DEAD)
				predatorcount++

	if(predstatus <= PREDATORS_UNKNOWN || predstatus == PREDATORS_DEAD)
		if(!calculateXenos())
			message_admins("{ISSS!!")
			return 0
		else
			message_admins("10/10")
			return 1

	if(predstatus == PREDATORS_ALIVE)
		if(!predatorcount)
			predstatus = PREDATORS_DEAD

	var/predators_vs_aliens = (alien_weed_control_count *  2/3) - 100 // around 3/6's
	if(predators_vs_aliens < 0)
		message_admins("ERROR: Predatorsinterested value has fallen under a zeorth value.") // fucking rotten tomato again
		return

	if(xenomorphweeds.len >= predators_vs_aliens)
		callPredators()

	if(ERTlaunch)
		..()
		return

	var/totalcrew
	var/deadcrew
	for(var/mob/living/carbon/human/M in mob_list)
		if(M.get_assignment())
			totalcrew++
			if(M.stat == DEAD)
				deadcrew++

	var/centcommexpectation = totalcrew * 1/8
	if(totalcrew <= centcommexpectation)
		message_admins("An AI admin is automatically assembling an ERT squad due to the crew's casualty rate: [deadcrew]/[totalcrew]")
		var/datum/admins/ai_admin = new /datum/admins

		ai_admin.makeEmergencyresponseteam(AI = TRUE, "Amber: Full ERT (Armoury Access)", 7, "Assist the crew, call the emergency shuttle, collect and report casualities, and exterminate the xenomorphs")
		priority_announce("An Emergency Response Team has been dispatched to your station. Please standby.", null, 'sound/AI/shuttledock.ogg', "Alert - Nanotrasen")
		ERTlaunch = TRUE


	..()

/datum/game_mode/xenomorph/declare_completion()
	if(alien_weed_control_count <= xenomorphweeds.len)
		if(calculateXenos())
			feedback_set_details("round_end_result","win - xenomorphs took over")
			world << "<FONT size = 5><B>Xenomorphs Major Win!</B></FONT>"
			world << "<B>The entire station was taken over by alien weeds.</B>"
		else
			feedback_set_details("round_end_result","win - xenomorphs took over, even after death")
			world << "<FONT size = 5><B>Xenomorphs Minor Win!</B></FONT>"
			world << "<B>The station was taken over by alien weeds but, the xenomorphs were still exterminated.</B>"

	else if (!calculateXenos() && alien_weed_control_count > xenomorphweeds.len)
		feedback_set_details("round_end_result","lose - the xenomorphs were exterminated")
		if(predstatus == PREDATORS_UNKNOWN)
			world << "<FONT size = 5><B>Crew Major Win!</B></FONT>"
			world << "<B>The Research Staff aboard [station_name()] managed to contain the xenomorphic outbreak!</B>"

		else if (predstatus == PREDATORS_DEAD)
			world << "<FONT size = 5><B>Crew Minor Win!</B></FONT>"
			world << "<B>The Research Staff aboard [station_name()] managed to contain the xenomorphic outbreak but, has gotten the attention of even more Yautija Warriors!</B>"

		else if(predstatus == PREDATORS_ALIVE)
			world << "<FONT size = 5><B>Crew Minor Win!</B></FONT>"
			world << "<B>The Research Staff aboard [station_name()] managed to contain the xenomorphic outbreak but, Yautija Warriors are interested in hunting more crewmembers!</B>"

	else if(station_was_nuked)
		feedback_set_details("round_end_result", "neutral win")
		world << "<FONT size = 5><B>Neutral Win!</B></FONT>"
		if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
			world << "<B>The crew evacuated but, had to nuke their station to get rid of the xenomorphs.</B>"
		else
			world << "<B>The crew nuked the station without evacuating to get rid of the xenomorphs!</B>"

	for(var/datum/mind/M in xenomorphs["QUEEN"])
		if(M.current)
			if(!M.current.stat)
				if(!SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
					feedback_set_details("round_end_result", "interrupted - A")
					world << "<FONT size = 5><B>Unknown Win</B></FONT>"
					world << "<B>The game was interrupted.</B>"
				else
					feedback_set_details("round_end_result", "xenomorphs averted")
					world << "<FONT size = 5><B>Neutral Win!</B></FONT>"
					world << "<B>The crew evacuated after the xenomorph queen died, leaving her hive on the station.</B>"
			else
				feedback_set_details("round_end_result", "interrupted - B")
				world << "<FONT size = 5><B>Unknwon Win</B></FONT>"
				world << "<B>The game was interrupted.</B>"
		else
			feedback_set_details("round_end_result", "interrupted - C")
			world << "<FONT size = 5><B>Server Win</B></FONT>"
			world << "<FONT size = 5><B>Uhm... the game ended, and the queens still alive.</B></FONT>"
	..()
	return

/datum/game_mode/xenomorph/proc/calculateXenos() //length
	var/queen
	var/knights
	var/hunters
	var/brewers

	for(var/datum/mind/M in xenomorphs)
		if(M.assigned_role == "xeno queen")
			if(M.current.stat != DEAD)
				message_admins("AAA")
				queen = M.current
				return 0

		if(M.assigned_role == "xeno hunters")
			if(M.current.stat != DEAD)
				hunters++

		if(M.assigned_role == "xeno sentinels")
			if(M.current.stat != DEAD)
				knights++

		if(M.assigned_role == "xeno drone")
			if(M.current.stat != DEAD)
				brewers++

	if(!queen && !knights && !hunters && !brewers)
		message_admins("AAAKAAAA")
		return 1
	else
		message_admins("SAD TIMES!")
		return 0

/datum/game_mode/xenomorph/proc/callPredators()
