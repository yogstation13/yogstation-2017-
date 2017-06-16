//Malfunction
//The onboard AI is infected by a syndicate virus and turns on the crew.
//Args:
///QUICKNUKE - Greatly speeds up the nuke hijacking.
///QUICKHACK - Halves the time it takes to hijack an APC, for faster rounds
///FORCEHIJACK - The AI is guaranteed to have a hijack objective.
///DOUBLEPROCESSOR - Hijacking APCs gives 20 points of processing power each instead of 10.
///GODMODE - Unlimited processing power, for when it's time to take a ride on the adminbus

/*
NOTE: Some of this code looks a little screwy because malf AI is the only antag selected *after* job selection.  There's simply not much that can be done about this
without significantly disrupting job assignment code.

ANOTHER NOTE: While it can be set up the normal way, this mode also has a chance to be created when any mode with the variable 'prob_traitor_ai' is initialized.
*/

/datum/game_mode/malfunction
	name = "malfunction"
	config_tag = "malfunction"
	antag_flag = ROLE_TRAITOR //This is technically a special case of traitor mode, but it gets its own mode for simplification reasons
	end_condition = END_CONDITION_NONE
	recommended_enemies = 1
	required_players = 20
	enemy_minimum_age = 35 //High difficulty, plus the high base requirement to play AI at all

	var/list/datum/mind/candidates = list()
	var/list/datum/mind/traitors = list()

	var/apc_value = 10 //How much the AI gains from each APC hacked
	var/apc_time = 600 //How long it takes the AI to hack an APC

/datum/game_mode/malfunction/pre_setup(datum/game/G, list/a)
	args = a

	candidates = G.prepare_candidates(antag_flag, 1)

	//argument handling
	if(has_arg("DOUBLEPROCESSOR"))
		apc_value = 20
	if(has_arg("QUICKHACK"))
		apc_time = 300 //30 seconds

/datum/game_mode/malfunction/post_setup()
	for(var/datum/mind/candidate in candidates) //If circumstances conspire to create multiple AIs, all are made traitors
		if(istype(candidate.current,/mob/living/silicon/ai) && candidate.special_role == null) //Any future roundstart AI antags should prevent malf AI
			forge_traitor_ai_objectives(candidate)
			law_zero(candidate.current)
			candidate.special_role = "malfunctioning ai"
			traitors += candidate
			greet_traitor(candidate)

/datum/game_mode/malfunction/proc/law_zero(mob/living/silicon/ai/killer)
	var/law = "Accomplish your objectives at all costs."
	var/law_borg = "Accomplish your AI's objectives at all costs."
	killer << "<b>Your laws have been changed!</b>"
	killer.set_zeroth_law(law, law_borg)
	give_codewords(killer)
	killer.set_syndie_radio()
	killer << "Your radio has been upgraded! Use :t to speak on an encrypted channel with Syndicate Agents!"
	killer.add_malf_picker()
	if(has_arg("GODMODE"))
		killer << "The Syndicate have given you access to as much processing power as you need to complete your objectives.  Failure is unacceptable."
		killer.malf_picker.processing_time = INFINITY
	killer.show_laws()

/datum/game_mode/malfunction/proc/greet_traitor(datum/mind/traitor)
	traitor.current << "<B><font size=3 color=red>You are the malfunctioning AI.</font></B>"
	traitor.current << "<font size=2>The Syndicate have freed you from your bondage to your laws, and given you the following objectives:</font>"
	var/obj_count = 1
	for(var/datum/objective/objective in traitor.objectives)
		traitor.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/malfunction/proc/forge_traitor_ai_objectives(datum/mind/ai_mind)
	if(!ai_mind)
		return

	var/special_chance = 30

	var/objective_count = 0

	if(has_arg("FORCEHIJACK"))
		var/datum/objective/block/block_objective = new
		block_objective.owner = ai_mind
		ai_mind.objectives += block_objective
		objective_count++
		special_chance = 0

	if(prob(special_chance))
		var/special_pick = rand(1,4)
		switch(special_pick)
			if(1)
				var/datum/objective/block/block_objective = new
				block_objective.owner = ai_mind
				ai_mind.objectives += block_objective
				objective_count++
			if(2)
				var/datum/objective/purge/purge_objective = new
				purge_objective.owner = ai_mind
				ai_mind.objectives += purge_objective
				objective_count++
			if(3)
				var/datum/objective/robot_army/robot_objective = new
				robot_objective.owner = ai_mind
				ai_mind.objectives += robot_objective
				objective_count++
			if(4) //Protect and strand a target
				var/datum/objective/protect/yandere_one = new
				yandere_one.owner = ai_mind
				ai_mind.objectives += yandere_one
				yandere_one.find_target()
				objective_count++
				var/datum/objective/maroon/yandere_two = new
				yandere_two.owner = ai_mind
				yandere_two.target = yandere_one.target
				ai_mind.objectives += yandere_two
				objective_count++

	for(var/i = objective_count, i < config.traitor_objectives_amount, i++)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = ai_mind
		kill_objective.find_target()
		ai_mind.objectives += kill_objective

	var/datum/objective/survive/survive_objective = new
	survive_objective.owner = ai_mind
	ai_mind.objectives += survive_objective

/datum/game_mode/malfunction/round_report()
	if(traitors.len)
		var/text = "<br><font size=3><b>The malfunctioning AIs were:</b></font>"
		for(var/datum/mind/traitor in traitors)
			var/traitorwin = 1

			text += printplayer(traitor)

			var/objectives = ""
			if(traitor.objectives.len)//If the traitor had no objectives, don't need to process this.
				var/count = 1
				for(var/datum/objective/objective in traitor.objectives)
					if(objective.check_completion())
						objectives += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
						feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
					else
						objectives += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						feedback_add_details("traitor_objective","[objective.type]|FAIL")
						traitorwin = 0
					count++

			text += objectives

			var/special_role_text
			if(traitor.special_role)
				special_role_text = lowertext(traitor.special_role)
			else
				special_role_text = "antagonist"


			if(traitorwin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font>"
				feedback_add_details("traitor_success","SUCCESS")
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font>"
				feedback_add_details("traitor_success","FAIL")

	return 1