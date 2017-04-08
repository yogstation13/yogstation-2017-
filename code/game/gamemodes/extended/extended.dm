/*
/datum/game_mode/extended
	name = "secret extended"
	config_tag = "secret extended"
	required_players = 0
	prob_traitor_ai = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	..()
<<<<<<< HEAD

/datum/game_mode/extended/announced
	name = "extended"
	config_tag = "extended"

/datum/game_mode/extended/announced/generate_station_goals()
=======
	*/

/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	required_players = 0
	prob_traitor_ai = 0
	// reroll_friendly = 1

/datum/game_mode/announce()
	world << "<B>The current game mode is - Extended!</B>"
	world << "<B>Just have fun!</B>"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	..()

/datum/game_mode/extended/generate_station_goals()
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee
	for(var/T in subtypesof(/datum/station_goal))
		var/datum/station_goal/G = new T
		station_goals += G
		G.on_report()

<<<<<<< HEAD
/datum/game_mode/extended/announced/send_intercept(report = 0)
	priority_announce("Thanks to the tireless efforts of our security and intelligence divisions, there are currently no credible threats to [station_name()]. All station construction projects have been authorized. Have a secure shift!", "Security Report", 'sound/AI/commandreport.ogg')
=======
/datum/game_mode/extended/send_intercept(report = 0)
	priority_announce("Thanks to the tireless efforts of our security and intelligence divisions, there are currently no credible threats to [station_name()]. All station construction projects have been authorized. Have a secure shift!", "Security Report", 'sound/AI/commandreport.ogg')
	for (var/datum/station_goal/G in station_goals)
		G.send_report()
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee
