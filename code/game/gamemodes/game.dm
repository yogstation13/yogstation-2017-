//GAME.DM
//The object contained herein serves to track the various factions that may be in place on the station, as well as their goals.
//Support for multi-mode and midround modes are built-in, even to the point of two competing groups of the same antag being acceptable.

#define END_CONDITION_PENDING 0
#define END_CONDITION_NONE 1
#define END_CONDITION_WEAK 2
#define END_CONDITION_STRONG 3

/datum/game
	var/list/datum/game_mode/modes
	var/list/datum/game_mode/pending_modes //Modes that are selected stay here while the game is finalized

	var/datum/station_state/sstate

	var/list/datum/station_goal/station_goals = list()

	var/overridden = 0 //If the admins set a mode during the lobby period, this tells the ticker to respect their choice
	var/ready = 0 //This is true when the game has an acceptable mode and is ready to use it

	//The length of time to wait before sending the report is chosen randomly between these two values
	var/const/waittime_l = 600
	var/const/waittime_h = 1800 // started at 1800

//PICK MODES: Takes the gamemode section of the configuration file as an argument and picks some modes based on what it says.
//FORMAT:
//!modes //Beginning of mode definitions
//traitor-med;ling-low:50 //50 percent chance of traitorling, where a moderate amount of traitors are spawned and a low number of changelings.
//traitor-hi+da:25 //25 percent chance of double agent, with a high amount of traitors.  Note the 'da'; That's being passed as an argument to the mode.
//bloodcult-low+force_summon;clockcult-low+force_summon:25 //Multiple arguments are allowed, in any order.  This line might, for example, create cult vs cult summoning wars.
//modes! //end of mode definitions

/datum/mode_combo //struct
	var/list/modenames
	var/list/list/modeargs
	var/probability

/datum/mode_combo/proc/check_availible(list/datum/game_mode/modes, datum/game/G) //Returns 1 if all of its modes signal ready to start, and 0 otherwise.
	var/availible = 1
	for (var/datum/game_mode/modetype in modes)
		if (modetype.config_tag && (modetype.config_tag in modenames))
			availible = min(availible,modetype.check_compat(G))

	return availible

/datum/mode_combo/proc/check_malf(list/datum/game_mode/modes)
	var/probability_malf_ai = 0
	for (var/datum/game_mode/modetype in modes)
		if (modetype.config_tag && (modetype.config_tag in modenames))
			probability_malf_ai = min(probability_malf_ai, modetype.prob_traitor_ai) //Any mode with zero probability zeroes them all out

	if(prob(probability_malf_ai))
		modenames += "malfunction"
		modeargs += list()

//If count_only is 1, this returns the number of valid candidates
/datum/game/proc/prepare_candidates(role_type, count, count_only=0) //Returns a list of [count] valid candidates for the role you provide, and updates antag weight accordingly.
	var/list/players = list()
	var/list/candidates = list()
	var/list/drafted = list()
	var/datum/mind/applicant = null

	// Ultimate randomizing code right here
	for(var/mob/new_player/player in player_list)
		if(player.client && player.ready)
			players += player
			if(player.client.prefs.toggles & QUIET_ROUND)
				player.mind.quiet_round = 1

	// Shuffling, the players list is now ping-independent!!!
	// Goodbye antag dante
	players = shuffle(players)

	var/datum/game_mode/M = null //Used just below to determine the minimum age to be an antagonist.
	for(var/datum/game_mode/mode in modes)
		if(mode.antag_flag == role_type)
			M = mode

	for(var/mob/new_player/player in players)
		if(player.client && player.ready)
			if((role_type in player.client.prefs.be_special) && !(player.mind.quiet_round))
				if(!jobban_isbanned(player, "Syndicate") && !jobban_isbanned(player, role_type)) //Nodrak/Carn: Antag Job-bans
					if(age_check(player.client, M)) //Must be older than the minimum age
						candidates += player.mind				// Get a list of all the people who want to be the antagonist for this round
	if(count_only)
		return candidates.len
	if(candidates.len < count)
		for(var/mob/new_player/player in players)
			if(player.client && player.ready)
				if(!(role_type in player.client.prefs.be_special)) // We don't have enough people who want to be antagonist, make a seperate list of people who don't want to be one
					if(!jobban_isbanned(player, "Syndicate") && !jobban_isbanned(player, role_type)) //Nodrak/Carn: Antag Job-bans
						drafted += player.mind
						if(player.mind.quiet_round)
							player << "<span class='userdanger'>There aren't enough antag volunteers, so your quiet round setting will not be considered!</span>"
							player.mind.quiet_round = 0

	drafted = shuffle(drafted) // Will hopefully increase randomness, Donkie

	while(candidates.len < count)				// Pick randomlly just the number of people we need and add them to our list of candidates
		if(drafted.len > 0)
			applicant = pick(drafted)
			if(applicant)
				candidates += applicant
				drafted.Remove(applicant)

		else												// Not enough scrubs, ABORT ABORT ABORT
			break


	return pick_players(candidates, count)

/datum/game/proc/pick_players(list/datum/mind/candidates, count, role_type) //TODO: Update variable names in this function to cause less headaches
	var/list/chosen_ones = list()
	if (dbcon.IsConnected())
		var/list/ckey_listed = list()
		var/ckey_for_sql = ""

		// Add all our antag candidates to a list()
		for (var/datum/mind/player in candidates)
			ckey_listed += sanitizeSQL(get_ckey(player))

		// Turn the list into a string that we will use to filter the player table
		ckey_for_sql = jointext(ckey_listed, "', '")

		// Find all antag candidate antag-weights
		var/DBQuery/query_whitelist = dbcon.NewQuery("SELECT `ckey`, `antag_weight` FROM [format_table_name("player")] WHERE `ckey` IN ('[ckey_for_sql]')")

		if(!query_whitelist.Execute())
			return 0

		var/list/output = list()

		// Add all antag candidates weights to a list() and note the upper bound of the weight
		var/total = 0
		while(query_whitelist.NextRow())
			var/ckey = query_whitelist.item[1]
			var/weight = text2num(query_whitelist.item[2])
			output[ckey] = weight
			total += weight

		for(var/client/C in clients)
			C.last_cached_weight = output[C.ckey]
			C.last_cached_total_weight = total

		for(var/i in 1 to count)
			if(!candidates.len)
				break

			// Find a number between 0 and our weight upper bound
			var/R = rand(0, total)
			var/cumulativeWeight = 0
			var/datum/mind/final_candidate
			// We will loop through each antag candidate until we find the point where the
			// random number given intersects with a candidate. All other candidates will
			// have their chance to be antag increased while the selected candidate will have
			// their chance decreased
			for(var/ckey in output)
				var/weight = output[ckey]
				cumulativeWeight += weight

				if(R <= cumulativeWeight && !final_candidate)
					// Lowest weight is 25.
					weight = max(25, weight / 1.5)
					var/DBQuery/query = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `antag_weight` = [weight] WHERE `ckey` = '[ckey]'")
					query.Execute()

					for(var/datum/mind/candidate in candidates)
						if(get_ckey(candidate) == ckey)
							final_candidate = candidate
							total -= output[ckey]
							break
			// If after all this we still don't have a candidate, then use the legacy system
			if(!final_candidate)
				final_candidate = pick(candidates)

			chosen_ones += final_candidate
			candidates -= final_candidate
	else
		for(var/i in 1 to count)
			var/datum/mind/final_candidate = pick(candidates)
			chosen_ones += final_candidate
			candidates -= final_candidate

	update_not_chosen_candidates(candidates) //tfw candidate doesn't sound like a real word anymore

	return chosen_ones

/datum/game/proc/update_not_chosen_candidates(list/datum/mind/not_chosen)
	if(dbcon.IsConnected())
		//Ok, we're cheating quite a bit here, since this is ASSUMED to always run after we pick candidates, we
		//have cached antag weights saved on clients that were eligible via `last_cached_weight` variable
		//no need to query DB again
		for(var/v in not_chosen)
			var/datum/mind/candidate = v

			if(candidate.current && candidate.current.client)
				var/client/C = candidate.current.client

				if(C && C.last_cached_weight) //if it's not null, we've updated it during the picking stage
					var/SQL_ckey = sanitizeSQL(ckey(C.ckey)) //Better safe than sorry
					var/weight = C.last_cached_weight
					weight = min(400, weight * 1.5)
					var/DBQuery/query = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `antag_weight` = [weight] WHERE `ckey` = '[SQL_ckey]'")
					query.Execute()
					C.last_cached_weight = weight

//Tells the game object to configure itself in-place.  Pass the entire mode section of the configuration file, and this function will pick and prepare antagonists.
//Remember to call finalize_round() when the round starts!
/datum/game/proc/pick_modes(modeConfig)
	var/list/lines = splittext(modeConfig,"\n")
	lines -= "!modes" //beginning of mode defs
	lines -= "modes!" //end of mode defs

	var/list/datum/mode_combo/mode_combos = list()
	for (var/line in lines)
		var/datum/mode_combo/line_combo = new
		var/list/prob = splittext(line,":")
		line_combo.probability = prob[2]

		var/list/factions = splittext(prob[1],";")
		for (var/faction in factions)
			var/targetindex = line_combo.modenames.len + 1
			var/list/name = splittext(faction,"-")
			var/list/arguments = splittext(name[2],"+")
			line_combo.modenames[targetindex] = name
			line_combo.modeargs[targetindex] = arguments

		mode_combos += line_combo

	//To minimize the number of times we need to instantiate these, do it once here and have the mode combos share the instances
	var/list/datum/game_mode/mode_instances = list()
	for (var/T in subtypesof(/datum/game_mode))
		mode_instances += new T()

	var/list/datum/mode_combo/picker_list = list()
	for (var/datum/mode_combo/mc in mode_combos)
		if (mc.check_availible(mode_instances, src))
			picker_list[mc] = mc.probability

	var/datum/mode_combo/chosen = pickweight(picker_list) //Just pick one already
	chosen.check_malf(mode_instances)

	var/success = 1
	for (var/i = 1 to chosen.modenames.len)
		var/tag = chosen.modenames[i]
		var/list/args = chosen.modeargs[i]
		for (var/datum/game_mode/M in mode_instances)
			if (M.config_tag && (M.config_tag == tag))
				pending_modes += M
				mode_instances -= M
				success = min(success, pre_attach_mode(M, args, Debug2)) //Uses the Debug2 tag to determine mode forcing

	ready = success //Success will be 0 if any of the modes refused to start for some reason

	for (var/M in mode_instances) //We don't need these after all
		qdel(M)

/datum/game/proc/finalize_round() //Call this when everything is in place and its time to start the round
	for (var/datum/game_mode/M in pending_modes)
		finalize_mode(M)

	sstate = new /datum/station_state()
	sstate.count(1)

	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()

	generate_station_goals()
	if(config.intercept)
		spawn (rand(waittime_l, waittime_h))
			send_intercept()


//PRE-ATTACH: Chooses antagonists and remembers them, but does not tell them yet.  If you have something else you need to do (IE job distribution), do that after this.
/datum/game/proc/pre_attach_mode(datum/game_mode/mode, list/args, force_attach) //Returns 0 if the mode fails to attach, and 1 otherwise
	var/can_attach = mode.check_compat(src) //Give the mode an opportunity to refuse to turn on (for example, not enough living players)
	if(!(can_attach || force_attach))
		message_admins("Game mode [mode.name] failed to attach to the game, and WAS NOT forced to attach.  The round will continue without it.")
		return 0
	if(!can_attach) //&& force_attach) implied by program structure
		message_admins("Game mode [mode.name] failed to attach to the game, and WAS forced to attach.  This may cause adverse effects, depending on context.")

	var/success = mode.pre_setup(src, args) //Give players their special roles.
	if(!success)
		message_admins("Game mode [mode.name] returned an error while attempting to distribute roles.")
		if(!force_attach)
			message_admins("The round will continue without the [mode.name] mode.")
			return 0
		message_admins("Despite this, the gamemode will be forced to attach to the running game.")
	return 1

//FINALIZE: Give the antags their crap, and add the mode to our processing list.
/datum/game/proc/finalize_mode(datum/game_mode/mode)
	mode.post_setup()
	modes += mode

//CHECK COMPLETION: Polls the mode datums to ask them if they're ready for roundend.
//THREE TYPES: None (If all antags fail, round continues as extended), Weak (Causes roundend when all modes signal finished), Strong (Causes roundend immediately)
//The fourth, END_CONDITION_PENDING, is returned when the round hasn't finished yet.
//For example, traitor would be none, wizard weak, and blob and nukeops strong.
/datum/game/proc/check_completion()
	var/done = 0 //This is the strongest end condition returned
	var/waiting = 0 //This is true if there are modes still running
	for (var/datum/game_mode/mode in modes)
		var/res = mode.check_finished()
		done = max(done,res)
		if(!done)
			waiting = 1

	if ((done == END_CONDITION_NONE) || ((done == END_CONDITION_WEAK) && waiting))
		return 0

	return 1

//DECLARE COMPLETION: Tells the modes to output the round's results.
/datum/game/proc/declare_completion()
	for (var/datum/game_mode/mode in modes)
		mode.declare_completion()

	for (var/datum/game_mode/mode in modes)
		mode.round_report()

/datum/game/process()
	for(var/datum/game_mode/mode in modes)
		mode.process()

////////STATION GOALS\\\\\\\\\

/datum/game/proc/generate_station_goals()
	var/list/possible = list()
	for(var/T in subtypesof(/datum/station_goal))
		var/add_goal = 1
		var/datum/station_goal/G = T
		for(var/datum/game_mode/mode in modes)
			if(mode.config_tag in initial(G.gamemode_blacklist))
				add_goal = 0
				break
		if(add_goal)
			possible += T
	var/goal_weights = 0
	while(possible.len && goal_weights < STATION_GOAL_BUDGET)
		var/datum/station_goal/picked = pick_n_take(possible)
		goal_weights += initial(picked.weight)
		station_goals += new picked


/datum/game/proc/declare_station_goal_completion()
	for(var/V in station_goals)
		var/datum/station_goal/G = V
		G.print_result()


////////UTILITIES\\\\\\\\


/datum/game/proc/clear_antagonist(datum/mind/M) //De-antags someone
	for (var/datum/game_mode/mode in modes)
		mode.verify_removal(M)

/datum/game/proc/check_latejoin(datum/mind/M) //Offers players as latejoin antags to the modes
	var/mob/living/carbon/human/plr = M.current
	if (istype(plr))
		var res = 0
		for (var/datum/game_mode/mode in modes)
			if (!res)
				res = max(res, mode.make_antag_chance(plr))

/datum/game/proc/get_mode_by_tag(tag)
	for(var/datum/game_mode/mode in modes)
		if (mode.config_tag == tag)
			return mode
	return 0 //Check for this or bad things happen

/datum/game/proc/announce()
	for(var/datum/game_mode/mode in modes)
		mode.announce()

/datum/game/proc/get_explosion_in_progress()
	var/retval = 0
	for(var/datum/game_mode/mode in modes)
		retval = max(retval, mode.explosion_in_progress)

	return retval

/datum/game/proc/get_station_was_nuked()
	var/retval = 0
	for(var/datum/game_mode/mode in modes)
		retval = max(retval, mode.station_was_nuked)

	return retval

/datum/game/proc/send_intercept()
	var/intercepttext = "<FONT size = 3><B>Centcom Update</B> Requested status information:</FONT><HR>"
	intercepttext += "<B> Centcom has recently been contacted by the following syndicate affiliated organisations in your area, please investigate any information you may have:</B>"

	var/list/possible_modes = list()
	possible_modes.Add("revolution", "wizard", "nuke", "traitor", "malf", "changeling", "cult", "gang")

	possible_modes = shuffle(possible_modes) //shuffle the list to prevent meta

	var/datum/intercept_text/i_text = new /datum/intercept_text
	for(var/A in possible_modes)
		intercepttext += i_text.build(A)

	if(station_goals.len)
		intercepttext += "<hr><b fontsize = 10>Special Orders for [station_name()]:</b>"
		for(var/datum/station_goal/G in station_goals)
			G.on_report()
			intercepttext += G.get_report()

	print_command_report(intercepttext,"Centcom Status Summary")
	priority_announce("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.", 'sound/AI/intercept.ogg')
	if(security_level < SEC_LEVEL_BLUE)
		set_security_level(SEC_LEVEL_BLUE)

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/game/proc/age_check(client/C, datum/game_mode/M)
	if(get_remaining_days(C, M.enemy_minimum_age) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0


/datum/game/proc/get_remaining_days(client/C, minimum_age)
	if(!C)
		return 0
	if(!config.use_age_restriction_for_jobs)
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(minimum_age))
		return 0

	return max(0, minimum_age - C.player_age)