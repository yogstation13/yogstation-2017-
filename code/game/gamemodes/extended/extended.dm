/datum/game_mode/extended
	name = "extended (secret)"
	config_tag = "extended_secret"
	required_players = 0
	prob_traitor_ai = 0
	//reroll_friendly = 1

/datum/game_mode/announce()
	world << "<B>The current game mode is - Extended Role-Playing!</B>"
	world << "<B>Just have fun and role-play!</B>"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	..()


/datum/game_mode/extended/announced
	name = "extended (announced)"
	config_tag = "extended"
	required_players = 0
	prob_traitor_ai = 0

/datum/game_mode/extended/announced/generate_station_goals()
	for(var/T in subtypesof(/datum/station_goal))
		var/datum/station_goal/G = new T
		station_goals += G
		G.on_report()

/datum/game_mode/extended/announced/send_intercept(report = 0)
	priority_announce("Thanks to the tireless efforts of our security and intelligence divisions, there are currently no credible threats to [station_name()]. All station construction projects have been authorized. Have a secure shift!", "Security Report", 'sound/AI/commandreport.ogg')
	for (var/datum/station_goal/G in station_goals)
		G.send_report()
