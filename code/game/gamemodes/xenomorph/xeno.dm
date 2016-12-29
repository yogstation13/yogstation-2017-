/*
#define PREDATORS_UNKNOWN 0
#define PREDATORS_ALIVE 1
#define PREDATORS_DEAD 2

*/
var/list/turf/xenomorphweeds = list()

/datum/game_mode
	var/list/datum/mind/xenomorphs = list(
	"QUEEN" = list (),
	"HUNTERS" = list (),
	"SENITELS" = list (),
	"DRONES" = list ()
	)

	// "xenomorphs" list saves mind datums. not mobs.


	var/list/datum/mind/predators = list()

	var/queensuffix

/datum/game_mode/proc/checkHive() // if it returns 0 - it can be anything. else it returns a caste
	var/hcount = xenomorphs.len["HUNTERS"]
	var/scount = xenomorphs.len["SENITELS"]
	var/dcount = xenomorphs.len["DRONES"]

	if(!hcount || !scount || !dcount)
		return 0


	if(hcount == (scount && dcount))
		return 0

	if(hcount > scount)
		if(scount > dcount)
			return "drone"

		else
			return "senitel"

	else
		if(hcount > dcount)
			return "drone"

		else
			return "hunter"

/datum/game_mode/xenomorph
	name = "alien"
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
	var/yautijalaunch = FALSE
	var/ERTlaunch = FALSE


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

	if(istype(M.current, /mob/living/carbon/alien/humanoid/hunter))
		AddHunter(M)

	if(istype(M.current, /mob/living/carbon/alien/humanoid/sentinel))
		AddSenitel(M)

	if(istype(M.current, /mob/living/carbon/alien/humanoid/drone))
		AddDrone(M)

/datum/game_mode/xenomorph/proc/AddQueen(var/datum/mind/M)
	if(!Xregister(M))
		return

	xenomorphs["QUEEN"] += M
	xenomorphs += M
	M.assigned_role = "xeno queen"
	M.special_role = "xeno queen"

/datum/game_mode/xenomorph/proc/AddHunter(var/datum/mind/M)
	if(!Xregister(M))
		return

	xenomorphs["HUNTERS"] += M
	xenomorphs += M
	M.assigned_role = "xeno hunter"
	M.special_role = "xeno hunter"

/datum/game_mode/xenomorph/proc/AddSenitel(var/datum/mind/M)
	if(!Xregister(M))
		return

	xenomorphs["SENITELS"] += M
	xenomorphs += M
	M.assigned_role = "xeno sentinel"
	M.special_role = "xeno sentinel"

/datum/game_mode/xenomorph/proc/AddDrone(var/datum/mind/M)
	if(!Xregister(M))
		return

	xenomorphs["DRONES"] += M
	xenomorphs += M
	M.assigned_role = "xeno drone"
	M.special_role = "xeno drone"

// queen is always chosen.
// than a 50/50 shot at hunter or sentinel
// drone can only be chosen when a hunter or sentinel has already been

/datum/game_mode/xenomorph/pre_setup()
	var/player_count = 10
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
			AddQueen(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno queen")
			continue

		var/hunt_guard_diff_prob = 100

		if(hunter_sentinel_ticker)
			hunt_guard_diff_prob = hunt_guard_diff_prob / 2

		if(prob(hunt_guard_diff_prob))
			hunter_sentinel_ticker++
			AddHunter(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno hunter")
			continue


		if(prob(hunt_guard_diff_prob))
			AddSenitel(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno sentinel")
			continue

		else if(!drone_chosen)
			drone_chosen = TRUE
			AddDrone(alive_xenomorph)
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno drone")
			continue

		else
			continue
	return 1

/datum/game_mode/xenomorph/post_setup()

	alien_weed_control_count = rand(950,1250)

	var/list/spawns = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "xeno-spawn")
			spawns += A

	var/RNGspawn = pick(spawns)

	for(var/datum/mind/alien_brethern in xenomorphs)
		var/greeted_forged_moved
		for(var/turf/open/floor/F in orange(1, RNGspawn))
			if(greeted_forged_moved)
				continue
			var/list/turf/floors = list()
			floors += F
			var/pickfloor = pick(floors)
			alien_brethern.current.loc = pickfloor

			greet_xeno_and_transform(alien_brethern, alien_brethern.assigned_role)
			greeted_forged_moved = TRUE

	var/shuffle_universe_luck = rand(3000,4500)
	spawn(shuffle_universe_luck)
		priority_announce("Xenomorphic lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation. All personel are instructed to assist in the extermination of this species. This is not a drill.", "CRITICAL: Biohazard Alert", 'sound/machines/Alarm.ogg')
		SSshuttle.emergency.mode = SHUTTLE_STRANDED

	var/colony
	var/mob/living/carbon/alien/alien

	for(var/datum/mind/M in xenomorphs["QUEEN"])
		alien = M.current
		colony = alien.HD.colony_suffix
		queensuffix = alien.HD.colony_suffix

	if(colony)
		for(var/datum/mind/xenos in xenomorphs)
			if(colony)
				alien = xenos.current
				alien.HD.colony_suffix = colony
	else
		message_admins("ERROR: Queen failed to configure a colony suffix. Reloading the queensuffix. Please check the mode under TICKER.")
		update_queen_suffix()

	return ..()

/datum/game_mode/xenomorph/proc/greet_xeno_and_transform(datum/mind/hbrain, role)
	if(!role)
		return
	var/mob/living/l
	var/mob/living/M = hbrain.current

	switch(role)
		if("xeno hunter")
			l = new /mob/living/carbon/alien/humanoid/hunter(hbrain.current.loc)

		if("xeno sentinel")
			l = new /mob/living/carbon/alien/humanoid/sentinel(hbrain.current.loc)

		if("xeno queen")
			l = new /mob/living/carbon/alien/humanoid/royal/queen(hbrain.current.loc)

		if("xeno drone")
			l = new /mob/living/carbon/alien/humanoid/drone(hbrain.current.loc)

	if(hbrain)
		hbrain.transfer_to(l)
		var/datum/objective/weedconquer/W = new
		W.owner = l
		l.mind.objectives += W
		l.mind.special_role = hbrain.special_role
		l.mind.assigned_role = hbrain.assigned_role
		hbrain.current = l
		l << "<span class='alertalien'>You are a <B>[role]</B>!</span>"
		l << "<B><span class='alien'>Objective #1</B>: [W.explanation_text]</span>"
		var/mob/living/carbon/alien/A = l
		if(hbrain.special_role != "xeno queen")
			A.HD = new /datum/huggerdatum/default(origin = l)
		qdel(M)
	else
		message_admins("ERROR: [ticker.mode] has failed to greet and transform [hbrain.current] / [hbrain.current.ckey]. Contact a coder!")

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
	message_admins("total crew: [totalcrew]")
	var/centcommexpectation = alivecrew * 1/8
	message_admins("this is centcomms exxpectation: [centcommexpectation]")
	if(centcommexpectation < 1)
		centcommexpectation = 1
	message_admins("this is centcomms exxpectation: [centcommexpectation]")
	if(ERTlaunch)
		return
	if(alivecrew <= centcommexpectation)
		ERTlaunch = TRUE
		message_admins("An AI admin is automatically assembling an ERT squad due to the crew's casualty rate: [deadcrew]/[totalcrew] crewmembers dead.")
		var/type = "Amber: Full ERT (Armoury Access)"
		var/num = 7
		var/obj = "Assist the crew, call the emergency shuttle, collect and report casualities, and exterminate the xenomorphs"
		makeEmergencyresponseteam(TRUE, type, num, obj)
		priority_announce("An Emergency Response Team has been dispatched to your station. Please standby.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")

/datum/game_mode/xenomorph/check_finished()
	..()

	if(alien_weed_control_count <= xenomorphweeds.len)
		return TRUE

	if(calculateXenos(1) == DEAD)
		SSshuttle.emergency.mode = SHUTTLE_IDLE
		priority_announce("The Emergency Shuttle can now be called.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")
	else if (SSshuttle.emergency.mode == SHUTTLE_IDLE && calculateXenos(1) != DEAD)
		SSshuttle.emergency.mode = SHUTTLE_STRANDED
		priority_announce("The Emergency Shuttle can no longer be called.", null, 'sound/AI/commandreport.ogg', "Alert - Nanotrasen")

	if(!ERTlaunch) // Has an ERT already been sent?
		check_for_ERT()

//	update_queen_suffix()

	if(!calculateXenos())
		return FALSE
	else
		return TRUE

/datum/game_mode/xenomorph/proc/update_queen_suffix()
	if(queensuffix)
		return

	var/mob/living/carbon/alien/A

	for(var/datum/mind/M in xenomorphs["QUEEN"])
		if(istype(M.current, /mob/living/carbon/alien))
			A = M.current

	queensuffix = A.HD.colony_suffix

/datum/game_mode/xenomorph/declare_completion()
	if(alien_weed_control_count <= xenomorphweeds.len)
		if(!calculateXenos())
			feedback_set_details("round_end_result","win - xenomorphs took over")
			world << "<FONT size = 5><B>Xenomorphs Major Win!</B></FONT>"
			world << "<B>The entire station was taken over by alien weeds.</B>"
		else
			feedback_set_details("round_end_result","win - xenomorphs exterminated, but weeds took over")
			world << "<FONT size = 5><B>Xenomorphs Minor Win!</B></FONT>"
			world << "<B>The station was taken over by alien weeds but, the xenomorphs were exterminated.</B>"

	else if(station_was_nuked)
		if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
			feedback_set_details("round_end_result", "neutral win - nuked xenos")
			world << "<FONT size = 5><B>Nuclear Win!</B></FONT>"
			world << "<B>The crew evacuated, but had to nuke their station to get rid of the xenomorphs.</B>"
		else
			feedback_set_details("round_end_result", "neutral win - nuked themselves")
			world << "<FONT size = 5><B>Neutral Win!</B></FONT>"
			world << "<B>The crew nuked the station without evacuating to get rid of the xenomorphs!</B>"

	else if (alien_weed_control_count > xenomorphweeds.len)
		if(!calculateXenos())
			feedback_set_details("round_end_result","lose - xenomorphs were defeated")
			world << "<FONT size = 5><B>Unknwon Win</B></FONT>"
			world << "<B>The station and xenomorphs were at war... and the round suddenly ended. This is not suppose to happen.</B>"
		else
			feedback_set_details("round_end_result","lose - the xenomorphs were exterminated")
			world << "<FONT size = 5><B>Crew Major Win!</B></FONT>"
			world << "<B>The Research Staff aboard [station_name()] managed to contain the xenomorphic outbreak!</B>"
	..()
	return

//helpers

/datum/game_mode/xenomorph/proc/calculateXenos(var/justqueen) // is the hive alive? 0 - yes, 1 - no
	var/hive
	var/datum/mind/M = findQueen(1)

	if(M)
		if(justqueen)
			return M.current
		if(M.current)
			if(M.current.stat != DEAD)
				return FALSE // false if queens alive. however, if not than it's up to whether there's even 1 xenomorph alive
	else
		return TRUE

	for(var/datum/mind/minds in xenomorphs)
		if(minds.assigned_role != "xeno queen")
			if(minds.current.stat != DEAD && minds.current.stat > DEAD)
				hive++

	if(!hive)
		return TRUE
	else
		return FALSE



/datum/game_mode/xenomorph/proc/findQueen(var/mind) // 1 yes i found her, 0 no shes out with another hive again
	var/queen
	for(var/datum/mind/M in xenomorphs["QUEEN"])
		if(mind)
			queen = M
		else
			queen = M.current

	return queen


/datum/objective/weedconquer
	explanation_text = "Conquer the station!"

/datum/objective/weedconquer/check_completion()
	if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/xenomorph))
		var/datum/game_mode/xenomorph/X = ticker.mode
		if(X.alien_weed_control_count <= xenomorphweeds.len)
			return TRUE
	return FALSE


/proc/compareAlienSuffix(var/suffix1, var/suffix2)
	if(suffix1 == suffix2)
		return TRUE
	else
		return FALSE

/*
/proc/compareHD(var/datum/huggerdatum/H1, var/datum/huggerdatum/H2)
	if(H1.colony_suffix == H2.colony_suffix)
		return TRUE
	else
		return FALSE
*/