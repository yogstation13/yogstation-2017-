/datum/game_mode
	var/list/datum/mind/queens = list()

	// we use these lists to balance out the hive
	var/list/datum/mind/hunters = list()
	var/list/datum/mind/senitels = list()
	var/list/datum/mind/drones = list()

	// secret easter egg???
	var/list/datum/mind/predators = list()

/datum/game_mode/xenomorph
	name = "alien infestation"
	config_tag = "alien"
	antag_flag = ROLE_ALIEN
	required_players = 30
	required_enemies = 1
	required_enemies = 1
	recommended_enemies = 3 // max: 1 queen, 1-2 hunters/senitels and rarely drones
	enemy_minimum_age = 14


/datum/game_mode/xenomorph/announce()
	world << "<B>The current gamemode is - Alien Infestation!</B>"
	world << "A transportation shuttle carrying live xenomorphs from a supposed uninhabitable planet mysteriously dissapered. Nanotrasen has identified the same creatures to be inhabitating SS13 and, was too late to cancel the next shift.\n <B>Xenomorphs</B>: Restore the Queen's glory and make turn the station into your own colony! Planting weeds increases the growth of her colony, however make sure to use strategy to outsmart the puny meatbags! Always listen to the queen. You may never disobey her.\n<B>Personnel</B> : Stop the xenomorphs from taking over your station! Make sure to eradicated weeds when you see them! Save SS13!</B>"



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


		if(prob(hunt_guard_diff_prob + 40)) // 90% chance if you aren't being a hunter, 10% chance for drone. 140% chance if a hunter hasn't been chosen.
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



