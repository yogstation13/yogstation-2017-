//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * GAMEMODES (by Rastaf0)
 *
 * In the new mode system all special roles are fully supported.
 * You can have proper wizards/traitors/changelings/cultists during any mode.
 * Only two things really depends on gamemode:
 * 1. Starting roles, equipment and preparations
 * 2. Conditions of finishing the round.
 *
 */


/datum/game_mode
	var/name = "invalid"
	var/role_name = "clown"
	var/config_tag = null
	var/votable = 1
	var/list/args = list() //Roundstart arguments to the mode

	var/station_was_nuked = 0 //see nuclearbomb.dm and malfunction.dm
	var/explosion_in_progress = 0 //sit back and relax

	var/list/restricted_jobs = list()	// Jobs it doesn't make sense to be.  I.E chaplain or AI cultist
	var/list/protected_jobs = list("Security Officer","Detective", "Warden", "Head of Security", "Captain", "Head of Personnel") //These roles can never be antag
	var/required_players = 0
	var/required_enemies = 0
	var/recommended_enemies = 0
	var/antag_flag = null //preferences flag such as BE_WIZARD that need to be turned on for players to be antag

	var/prob_traitor_ai = 0

	var/end_condition = END_CONDITION_NONE //Possibilities are END_CONDITION_NONE, END_CONDITION_WEAK, and END_CONDITION_STRONG
	//See game.dm for more info

	var/reroll_friendly 	//During mode conversion only these are in the running
	var/enemy_minimum_age = 7 //How many days must players have been playing before they can play this antagonist

	var/mob/living/living_antag_player = null //Black magic optimization


/datum/game_mode/proc/announce() //to be called when round starts
	world << "<B>Notice</B>: [src] did not define announce()"


///check_compat()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/check_compat(datum/game/G)
	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			playerC++
	if(!Debug2)
		if(playerC < required_players)
			return 0
	var/num_antag_candidates = G.prepare_candidates(antag_flag,0,1)
	if(!Debug2)
		if(num_antag_candidates < required_enemies)
			return 0
		return 1
	else
		world << "<span class='notice'>DEBUG: GAME STARTING WITHOUT PLAYER NUMBER CHECKS, THIS WILL PROBABLY BREAK SHIT."
		return 1


///pre_setup()
///Attempts to select players for special roles the mode might have.
/datum/game_mode/proc/pre_setup(datum/game/G, list/a)
	return 1


///post_setup()
///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup(report=0) //Gamemodes can override the intercept report. Passing a 1 as the argument will force a report.

	feedback_set_details("round_start","[time2text(world.realtime)]")
	if(ticker && ticker.mode)
		feedback_set_details("game_mode","[ticker.mode]")
	if(revdata.commit)
		feedback_set_details("revision","[revdata.commit]")
	feedback_set_details("server_ip","[world.internet_address]:[world.port]")
	return 1

///process()
///Called by the game datum
/datum/game_mode/process()
	return 0

/datum/game_mode/proc/check_finished() //to be called by ticker
	if(SSshuttle.emergency && (SSshuttle.emergency.mode == SHUTTLE_ENDGAME))
		return end_condition
	if(station_was_nuked)
		return end_condition

	if(living_antag_player && living_antag_player.mind && isliving(living_antag_player) && living_antag_player.stat != DEAD && !isnewplayer(living_antag_player) &&!isbrain(living_antag_player))
		return END_CONDITION_PENDING //A resource saver: once we find someone who has to die for all antags to be dead, we can just keep checking them, cycling over everyone only when we lose our mark.

	for(var/mob/Player in living_mob_list)
		if(Player.mind && Player.stat != DEAD && !isnewplayer(Player) &&!isbrain(Player))
			if(Player.mind.special_role && Player.mind.special_role == role_name) //Someone's still antaging!
				living_antag_player = Player
				return END_CONDITION_PENDING

	return end_condition


/datum/game_mode/proc/declare_completion()
	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	var/escaped_humans = 0
	var/escaped_total = 0

	for(var/mob/M in player_list)
		if(M.client)
			clients++
			if(ishuman(M))
				if(!M.stat)
					surviving_humans++
					if(M.z == 2)
						escaped_humans++
			if(!M.stat)
				surviving_total++
				if(M.z == 2)
					escaped_total++


			if(isobserver(M))
				ghosts++

	if(clients > 0)
		feedback_set("round_end_clients",clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts",ghosts)
	if(surviving_humans > 0)
		feedback_set("survived_human",surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total",surviving_total)
	if(escaped_humans > 0)
		feedback_set("escaped_human",escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total",escaped_total)
	send2irc("Server", "Round just ended.")
	return 0

/datum/game_mode/proc/round_report() //Dumps the round's results
	return ""


/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0


/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/new_player/P in player_list)
		if(P.client && P.ready)
			. ++

///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	. = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(player.stat != DEAD && player.mind && (player.mind.assigned_role in command_positions))
			. |= player.mind


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	. = list()
	for(var/mob/player in mob_list)
		if(player.mind && (player.mind.assigned_role in command_positions))
			. |= player.mind

//////////////////////////////////////////////
//Keeps track of all living security members//
//////////////////////////////////////////////
/datum/game_mode/proc/get_living_sec()
	. = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(player.stat != DEAD && player.mind && (player.mind.assigned_role in security_positions))
			. |= player.mind

////////////////////////////////////////
//Keeps track of all  security members//
////////////////////////////////////////
/datum/game_mode/proc/get_all_sec()
	. = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(player.mind && (player.mind.assigned_role in security_positions))
			. |= player.mind

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/display_roundstart_logout_report()
	var/msg = "<span class='boldnotice'>Roundstart logout report\n\n</span>"
	for(var/mob/living/L in mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.suiciding)	//Suicider
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<span class='boldannounce'>Suicide</span>)\n"
					continue //Disconnected client
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/D in mob_list)
			if(D.mind && D.mind.current == L)
				if(L.stat == DEAD)
					if(L.suiciding)	//Suicider
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<span class='boldannounce'>Suicide</span>)\n"
						continue //Disconnected client
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						continue //Adminghost, or cult/wizard ghost
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<span class='boldannounce'>Ghosted</span>)\n"
						continue //Ghosted while alive



	for(var/mob/M in mob_list)
		if(M.client && M.client.holder)
			M << msg

/datum/game_mode/proc/printplayer(datum/mind/ply, fleecheck)
	var/text = "<br><b>[ply.key]</b> was <b>[ply.name]</b> the <b>[ply.assigned_role]</b> and"
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += " <span class='boldannounce'>died</span>"
		else
			text += " <span class='greenannounce'>survived</span>"
		if(fleecheck && ply.current.z > ZLEVEL_STATION)
			text += " while <span class='boldannounce'>fleeing the station</span>"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += " <span class='boldannounce'>had their body destroyed</span>"
	return text

/datum/game_mode/proc/printobjectives(datum/mind/ply)
	var/text = ""
	var/count = 1
	for(var/datum/objective/objective in ply.objectives)
		if(objective.check_completion())
			text += "<br><b>Objective #[count]</b>: [objective.explanation_text] <span class='greenannounce'>Success!</span>"
		else
			text += "<br><b>Objective #[count]</b>: [objective.explanation_text] <span class='boldannounce'>Fail.</span>"
		count++
	return text

/datum/game_mode/proc/replace_jobbaned_player(mob/living/M, role_type, pref)
	var/list/mob/dead/observer/candidates = pollCandidates("Do you want to play as a [role_type]?", "[role_type]", null, pref, 100)
	var/mob/dead/observer/theghost = null
	if(candidates.len)
		theghost = pick(candidates)
		M << "Your mob has been taken over by a ghost! Appeal your job ban if you want to avoid this in the future!"
		message_admins("[key_name_admin(theghost)] has taken control of ([key_name_admin(M)]) to replace a jobbaned player.")
		M.ghostize(0)
		M.key = theghost.key

/datum/game_mode/proc/verify_removal(datum/mind/M)
	return 1

/datum/game_mode/proc/has_arg(argument)
	return (argument in args)

/datum/game_mode/proc/make_antag_chance(mob/living/P)
	return 0