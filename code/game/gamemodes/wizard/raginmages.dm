/datum/game_mode/wizard/raginmages
	name = "ragin' mages"
	config_tag = "raginmages"
	required_players = 20
	use_huds = 1
	prob_traitor_ai = 0
	var/max_mages = 0
	var/making_mage = FALSE
	var/mages_made = 0
	var/time_checked = 0
	var/bullshit_mode = FALSE // requested by hornygranny
	var/time_check = 1500 // Every 150s, ask for a new wizard until the cap is reached

/datum/game_mode/wizard/announce()
	to_chat(world, "<B>The current game mode is - Ragin' Mages!</B>")
	to_chat(world, "<B>The <span class='warning'>Space Wizard Federation</span> is pissed, help defeat all the space wizards!</B>")

/datum/game_mode/wizard/raginmages/post_setup()
	..()
	var/playercount = 0
	if(!max_mages && !bullshit_mode)
		for(var/mob/living/player in mob_list)
			if(player.client && player.stat != DEAD)
				playercount += 1

			max_mages = Clamp(round(playercount / 8), 1, 20)

	if(bullshit_mode)
		max_mages = INFINITY

/datum/game_mode/wizard/raginmages/greet_wizard(datum/mind/wizard, you_are=1)
	if (you_are)
		to_chat(wizard.current, "<B>You are the Space Wizard!</B>")
	to_chat(wizard.current, "<B>The Space Wizards Federation has given you the following tasks:</B>")

	var/obj_count = 1
	to_chat(wizard.current, "<b>Objective Alpha</b>: Make sure the station pays for its actions against our diplomats")
	for(var/datum/objective/objective in wizard.objectives)
		to_chat(wizard.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++
	return

/datum/game_mode/wizard/raginmages/check_finished()
	var/wizards_alive = 0
	for(var/datum/mind/wizard in wizards)
		if(!iscarbon(wizard.current))
			continue

		if(isbrain(wizard.current))
			continue

		if(wizard.current.stat == DEAD)
			continue

		if(wizard.current.stat == UNCONSCIOUS)
			if(wizard.current.health < 0)
				to_chat(wizard.current, "<font size='4'>The Space Wizard Federation is upset with your performance and have terminated your employment.</font>")
				wizard.current.death()
			continue
		wizards_alive++

	if(!time_checked)
		time_checked = world.time

	if(bullshit_mode)
		if(world.time > time_checked + time_check)
			max_mages = INFINITY
			time_checked = world.time
			make_more_mages()
			return ..()

	if(wizards_alive)
		if(world.time > time_checked + time_check && (mages_made < max_mages))
			time_checked = world.time
			make_more_mages()
	else
		if(mages_made >= max_mages)
			finished = TRUE
		else
			make_more_mages()

	return ..()

/datum/game_mode/wizard/raginmages/proc/make_more_mages()
	if(making_mage)
		return

	if(mages_made >= max_mages)
		return

	making_mage = TRUE

	message_admins("SWF is still pissed, sending another wizard - [max_mages - mages_made] left.")
	// This sleeps for 60s
	var/list/mob/dead/observer/candidates = pollCandidates("Do you wish to be considered for the position of Space Wizard Foundation 'diplomat'?", ROLE_WIZARD, null, FALSE, 600)
	if(!candidates.len)
		message_admins("This is awkward, sleeping until another mage check...")
		making_mage = FALSE
		mages_made--
		return

	var/mob/dead/observer/theghost = pick(candidates)
	if(theghost)
		var/mob/living/carbon/human/new_character = makeBody(theghost)
		new_character.mind.make_Wizard()
		mages_made++

	making_mage = FALSE

/datum/game_mode/wizard/raginmages/declare_completion()
	if(finished)
		feedback_set_details("round_end_result","loss - wizard killed")
		to_chat(world, "<FONT size=3><B>The crew has managed to hold off the wizard attack! The Space Wizards Federation has been taught a lesson they will not soon forget!</B></FONT>")

	..(TRUE)

/datum/game_mode/wizard/raginmages/proc/makeBody(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	G_found.client.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	new_character.key = G_found.key

	return new_character

/datum/game_mode/wizard/raginmages/bullshit
	name = "very ragin' bullshit mages"
	config_tag = "veryraginbullshitmages"
	required_players = 20
	use_huds = 1
	bullshit_mode = TRUE
	time_check = 250
