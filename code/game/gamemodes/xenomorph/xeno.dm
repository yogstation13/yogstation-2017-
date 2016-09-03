#define PREDATORS_UNKNOWN 0
#define PREDATORS_ALIVE 1
#define PREDATORS_DEAD 2 // obviously, when all the predators are dead. game force ends, good job.


/datum/game_mode
	var/list/datum/mind/queens = list()

	// we use these lists to balance out the hive
	var/list/datum/mind/hunters = list()
	var/list/datum/mind/senitels = list()
	var/list/datum/mind/drones = list()

	// secret easter egg???
	var/list/datum/mind/predators = list()
	var/predators_aboard

/datum/game_mode/xenomorph
	name = "alien" //infestation
	config_tag = "alien"
	antag_flag = ROLE_ALIEN
	required_players = 30
	required_enemies = 1
	required_enemies = 1
	recommended_enemies = 3 // max: 1 queen, 1-2 hunters/senitels and rarely drones
	enemy_minimum_age = 14

	var/alien_weed_control_count


/datum/game_mode/xenomorph/announce()
	world << "<B>The current gamemode is - Alien Infestation!</B>"
	world << "A transportation shuttle mysteriously dissapered while carrying live xenomorphs from a determined \
	uninhabitable planet. Nanotrasen has identified the same creatures to be inhabitating SS13 but, was too late \
	to cancel the next shift.\n <B>Xenomorphs</B>: Restore the Queen's glory and make turn the station into your \
	own colony! Planting weeds increases the growth of her colony, however make sure to use strategy to outsmart \
	the puny meatbags! Always listen to the queen. You may never disobey her.\n<B>Personnel</B> : Stop the xenomorphs \
	from building their colony and save SS13! Make sure to eradicated weeds when you see them!</B>"

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
			queens += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno queen"
			alive_xenomorph.special_role = "xeno queen"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno queen")
			continue

		var/hunt_guard_diff_prob = 100

		if(hunter_sentinel_ticker)
			hunt_guard_diff_prob = hunt_guard_diff_prob / 2

		if(prob(hunt_guard_diff_prob))
			hunter_sentinel_ticker++
			hunters += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno hunter"
			alive_xenomorph.special_role = "xeno hunter"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno hunter")
			continue


		if(prob(hunt_guard_diff_prob + 40)) // 90% chance if you aren't being a hunter, 10% chance for drone. 140% chance (for sentinel) if a hunter hasn't been chosen.
			sentinels += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno sentinel"
			alive_xenomorph.special_role = "xeno sentinel"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno sentinel")
			continue

		else
			drones += alive_xenomorph
			alive_xenomorph.assigned_role = "xeno drone"
			alive_xenomorph.special_role = "xeno drone"
			log_game("[alive_xenomorph.key] (ckey) has been selected as a xeno drone")
			continue

	return 1

/datum/game_mode/xenomorph/post_setup()

	var/obj/effect/landmark/alien_spawn
	var/list/xenomorphs = list()


	for(var/obj/effect/landmark/A in landmarks_list) // they spawn in only one location.
		if(A.name == "xeno-spawn")
			if(alien_spawn.len)
				continue
			alien_spawn = get_turf(A)

	for(var/datum/mind/x0 in queens)
		xenomorphs += xenomorphs
	for(var/datum/mind/x1 in hunters)
		xenomorphs += x1
	for(var/datum/mind/x2 in sentinels)
		xenomorphs += x2
	for(var/datum/mind/x3 in drones)
		xenomorphs += x3

	for(var/datum/mind/alien_brethern in xenomorphs)
		for(var/turf/open/floor/F in orange(1, alien_spawn))
			var/list/turfs/floors = list()
			floors += F
			var/pickfloor = pick(floors)
			alien_brethern.current.loc = pickfloor

			forge_xenomorph_objectives(alien_brethern)
			greet_xeno_and_transform(alien_brethern, alien_brethern.assigned_role)


	var/shuffle_universe_luck = rand(2570,3000) // this at least gives time for the queen to prepare. I don't want to make anyone anxious - Super

	spawn(shuffle_universe_luck)
		priority_announce("Xenomorphic lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation. All personel are instructed to assist in the extermination of these species.", "CRITICAL: Biohazard Alert", 'sound/machines/Alarm.ogg')

	return ..()

/datum/game_mode/xenomorph/greet_xeno_and_transform(mob/living/M, role)
	if(!role)
		return
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

	if(M.mind)
		affected_mob.mind.transfer_to(l)
		var/datum/objective/weedconquer/W = new
		W.owner = l
		l.mind.objectives += W
		l << "<span class='alertalien'>You are a <B>[role]</B>!</span>"
		l << "<B><span class='alien'>Objective #[obj_count]</B>: [objective.explanation_text]</span>"
	else
		message_admins("ERROR: [ticker.mode] has failed to convert [M] into a xenomorph at the start of the round.")
	qdel(M)




/datum/objective/weedconquer
	explanation_text = "Conquer the station and form a colony for your queen by planting your alien weeds!"

/*
/datum/objective/weedconquer/check_completion()
	if(ticker && ticker.mode && ticker.mode. )
		return 1
	return 0
*/
