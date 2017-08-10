/datum/game_mode/
	var/list/vampires = list()

#define TOO_MANY_PLAYERS_MAKE_MORE_VAMPIRES 60

/datum/game_mode/vampire
	name = "vampire"
	config_tag = "vampire"
	antag_flag = ROLE_VAMPIRE
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chaplain")
	required_players = 15
	required_enemies = 3
	recommended_enemies = 1
	reroll_friendly = 1

/datum/game_mode/vampire/announce()
	world << "<b>The current game mode is Vampire!</b>"
	world << "<b>There are ominous vampires lurking within the shadows of the station! Stay on your toes!</b>"

/datum/game_mode/vampire/pre_setup()
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/playerbase = num_players()
	var/vampireknights = max(round(playerbase / 15), 1) // 3

	if(playerbase >= TOO_MANY_PLAYERS_MAKE_MORE_VAMPIRES)
		var/playerbasecut = num_players() - TOO_MANY_PLAYERS_MAKE_MORE_VAMPIRES
		var/makemore = TRUE
		while(playerbasecut -= 15 > 0)
			if(!makemore)
				break
			if(playerbasecut) // after we've counted 60 players for every 15 more make another vampire
				vampireknights++
			else
				makemore = FALSE


	var/list/datum/mind/court_of_vamps = pick_candidate(amount = vampireknights)
	update_not_chosen_candidates()

	for(var/v in court_of_vamps)
		var/datum/mind/chosenvamp = v
		vampires += chosenvamp
		chosenvamp.special_role = "Vampire"
		log_game("[chosenvamp.key] (ckey) has been selected as a vampire")
	return 1

/datum/game_mode/vampire/post_setup()
	for(var/datum/mind/vamp in vampires)
		forge_objectives(vamp)
		greet_vampire(vamp)
		transform_vampire(vamp)
	..()
	return 1

/datum/game_mode/vampire/proc/greet_vampire(datum/mind/vampire)
	vampire.current << "<B><span class='announcevampire'>You are a Vampire.</span></B>"
	var/obj_count = 1
	for(var/datum/objective/objective in vampire.objectives)
		vampire.current << "<span class='noticevampire'><B>Objective #[obj_count]</B>: [objective.explanation_text]</span>"
		obj_count++
	return

/datum/game_mode/vampire/proc/forge_objectives(datum/mind/M)
	var/blood_hunt = pick(800,1000)
	var/is_stealing = prob(50)

	var/datum/objective/blood/blood_objective = new
	blood_objective.owner = M
	blood_objective.bloodtarget = blood_hunt
	blood_objective.update_explanation_text()
	M.objectives += blood_objective

	if(is_stealing)
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = M
		steal_objective.find_target()
		M.objectives += steal_objective
	else
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = M
		kill_objective.find_target()
		M.objectives += kill_objective

	var/datum/objective/survive/survive_objective = new
	survive_objective.owner = M
	M.objectives += survive_objective

	// TODO: More Vampire-y objectives.

	return 0

/datum/game_mode/proc/transform_vampire(datum/mind/M)
	M.vampire = new(M)
	M.vampire.vampire = M.current
	M.vampire.Basic()

/datum/game_mode/proc/devampire(datum/mind/M)
	M.vampire.ForgetAbilities()
	M.vampire = null
	M.current << "<span class='alertvampire'>Your grip on the night is slipping away!</span>"


/datum/game_mode/vampire/declare_completion()
	..()
	return

/datum/game_mode/proc/auto_declare_completion_vampire()
	if(vampires.len)
		var/text = "<br><font size=3><b>The creatures of the night were:</b></font>"
		for(var/datum/mind/vamp in vampires)
			text += printplayer(vamp)
			var/count = 1
			var/vampirewin = TRUE

			var/objectives = ""
			for(var/datum/objective/objective in vamp.objectives)
				if(objective.check_completion())
					objectives += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("vampire_objective","[objective.type]|SUCCESS")
				else
					objectives += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("vampire_objective","[objective.type]|FAIL")
					vampirewin = FALSE
				count++

			text += objectives

			if(vampirewin)
				text += "<br><font color='green'><B>The vampire was successful!</B></font>"
				feedback_add_details("vampire_success","SUCCESS")
			else
				text += "<br><font color='red'><B>The vampire has failed!</B></font>"
				feedback_add_details("vampire_success","FAIL")
			text += "<br>"
		world << text
	return 1