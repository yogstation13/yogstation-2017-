/*
 *********************************************************************************************
 * Concept by Alblaka
 * see http://forums.yogstation.net/index.php?threads/mode-cybermen.8096/ for gamemode details
 *********************************************************************************************
*/
#define CYBERMEN_BASE_HACK_POWER_1 20
#define CYBERMEN_BASE_HACK_POWER_2 10
#define CYBERMEN_BASE_HACK_POWER_3 5
#define CYBERMEN_BASE_HACK_POWER_4 1
#define CYBERMEN_BASE_HACK_RANGE_1 1
#define CYBERMEN_BASE_HACK_RANGE_2 3
#define CYBERMEN_BASE_HACK_RANGE_3 10
#define CYBERMEN_BASE_HACK_MAINTAIN_RANGE 10

//#define CYBERMEN_DEBUG

#ifdef CYBERMEN_DEBUG
#warn Warning: Cybermen debug text and abilities are enabled
#endif

var/datum/cyberman_network/cyberman_network

/datum/game_mode/cybermen
	name = "cybermen"
	config_tag = "cybermen"
	antag_flag = ROLE_CYBERMAN
	#ifdef CYBERMEN_DEBUG
	required_players = 1
	required_enemies = 1
	#else
	required_players = 30
	required_enemies = 2
	#endif
	recommended_enemies = 3
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Prison Officer")
	prob_traitor_ai = 18
	//yogstat_name = "cybermen"

/datum/game_mode/cybermen/announce()
	world << "The gamemode is Cybermen."

/datum/game_mode/cybermen/pre_setup()
	if(!cyberman_network)
		new /datum/cyberman_network()
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	#ifdef CYBERMEN_DEBUG
	var/cybermen_num = 1
	#else
	var/cybermen_num = max(3, round(num_players()/14))
	#endif

	var/list/datum/mind/tinmen = pick_candidate(amount = cybermen_num)
	update_not_chosen_candidates()

	for(var/v in tinmen)
		var/datum/mind/cyberman = v
		cyberman_network.cybermen += cyberman
		cyberman.cyberman = new /datum/cyberman_datum()
		cyberman.special_role = "Cyberman"
		cyberman.restricted_roles = restricted_jobs

	if(cyberman_network.cybermen.len < required_enemies)
		return 0

	return 1

/datum/game_mode/cybermen/post_setup()
	sleep(10)

	for(var/datum/mind/cyberman in cyberman_network.cybermen)
		log_game("[cyberman.key] (ckey) has been selected as a Cyberman.")
		spawn(9)
			cyberman_network.cybermen -= cyberman
			add_cyberman(cyberman, "<span class='boldannounce'><b><font size=3>You are a Cyberman!</font></b></span>\n<b>Any other Cybermen are your allies. Work together to complete your objectives. You will be given a total of four objectives, each revealed upon completion of the previous objective.</b>")
	spawn(10)
		cyberman_network.display_current_cybermen_objective()
	..()
	return

/*
/datum/game_mode/proc/is_cyberman(datum/mind/mind)//fast and simple one
	return mind && mind.cyberman && (mind in cybermen)
*/

/datum/game_mode/proc/is_cyberman(datum/mind/mind)//better for logging errors
	if(!mind || !cyberman_network)
		return 0
	var/in_cybermen = (mind in cyberman_network.cybermen)
	if((mind.cyberman && !in_cybermen) || (!mind.cyberman && in_cybermen))
		var/message = mind.cyberman ? "[mind] was found to have an initialized cyberman datum, but is not a registered cyberman. Please report this bug to a coder." : "[mind] was found to not have an initialized cyberman datum, but is a registered cyberman. Please report this bug to a coder."
		log_game(message)
		return 0
	return mind.cyberman

/datum/game_mode/proc/add_cyberman(datum/mind/cyberman, message_override)
	if(!cyberman_network)
		new /datum/cyberman_network()
	if(is_cyberman(cyberman))
		return
	cyberman_network.cybermen += cyberman//careful this doesn't happen twice.
	cyberman.cyberman = new /datum/cyberman_datum()
	cyberman.special_role = "cyberman"
	for(var/A in cyberman.cyberman.abilities)
		var/datum/action/cyberman/ability = A
		ability.Grant(cyberman.current)
	cyberman.current.attack_log += "\[[time_stamp()]\] <span class='danger'>Became a cyberman</span>"

	update_cybermen_icons_add(cyberman)
	var/datum/atom_hud/data/cybermen/hud = huds[DATA_HUD_CYBERMEN_HACK]
	hud.add_hud_to(cyberman.current)
	if(message_override)
		cyberman.current << message_override
	else
		cyberman.current << "<span class='boldannounce'><b><font size=3>You are now a Cyberman! Work with your fellow cybermen and do not harm them.</font></b></span>"

	var/mob/living/carbon/human/H = cyberman.current
	if(cyberman.assigned_role == "Clown")
		H << "<span class='notice'>Your superior Cyberman form has allowed you to overcome your clownish genetics.</span>"
		H.dna.remove_mutation(CLOWNMUT)
	if(isloyal(H))
		H << "<span class='notice'>Your loyalty implant has been deactivated, but not destroyed. While scanners will show that it is still active, you are no longer loyal to Nanotrasen.</span>"//I personnally am not a fan of this, but Alblaka said it so that's what I've done.

	cyberman.current << "<span class='notice'>As a Cyberman, hacking is your most valuable ability. Click on \'Prepare Hacking\' in the Cybermen tab to use it.</span>"
	cyberman.current << "<span class='notice'>You can use the Cyberman Broadcast to undetectably communicate with your fellow Cybermen. You can also use robot talk with .b, but this will alert any unhacked cyborgs or AIs to your presence.</span>"
	cyberman.current << "<span class='notice'>\n\"Cybermen\" is an experimental gamemode. If you find any bugs, please submit an issue on the server's github. If a bug prevents you from completing an objective, or you are not properly assigned an objective, contact an admin via ahelp.</span>"
	cyberman_network.display_all_cybermen_objectives(cyberman)

/datum/game_mode/proc/remove_cyberman(datum/mind/cyberman, var/message_override)
	if(!is_cyberman(cyberman) )
		return
	//drop all installed parts (except limbs)
	for(var/obj/item/weapon/stock_parts/capacitor/P in cyberman.cyberman.upgrades_installed)
		P.loc = cyberman.current.loc
		cyberman.cyberman.upgrades_installed -= P
	for(var/A in cyberman.cyberman.abilities)
		qdel(A)
	qdel(cyberman.cyberman)
	cyberman.cyberman = null//redundant but doesn't hurt to be safe.
	cyberman_network.cybermen -= cyberman
	cyberman.current.attack_log += "\[[time_stamp()]\] <span class='danger'>De-Cybermanized</span>"
	cyberman.special_role = null

	update_cybermen_icons_remove(cyberman)
	var/datum/atom_hud/data/cybermen/hud = huds[DATA_HUD_CYBERMEN_HACK]
	hud.remove_hud_from(cyberman.current)
	var/mob/living/carbon/human/H = cyberman.current

	if(issilicon(H))
		H.audible_message("<span class='notice'>[H] lets out a short blip.</span>", "<span class='userdanger'>You have been turned into a robot! You are no longer a cyberman! Though you try, you cannot remember anything about the cybermen or your time as one...</span>")
	else
		H.visible_message("<span class='big'>[H] looks like their mind is their own again!</span>", message_override ? message_override : "<span class='userdanger'>Your mind is your own again! You are no longer a cyberman! Though you try, you cannot remember anything about the cybermen or your time as one...</span>")
		if(isloyal(H))
			H << "<span class='notice'>Your loyalty implant has been re-activated - you are once again unfailingly loyal to Nanotrasen.</span>"

/datum/game_mode/cybermen/check_finished()
	return ..() || cyberman_network.cybermen_win

/datum/game_mode/cybermen/check_win()
	return cyberman_network.cybermen_win == 1

/datum/game_mode/cybermen/declare_completion()
	..()
	cyberman_network.process_cyberman_objectives()
	var/cybermen_won = (cyberman_network.cybermen_win == 1)

	//log_yogstat_data("gamemode.php?gamemode=cybermen&value=rounds&action=add&changed=1")

	if(!cybermen_won && SSshuttle.emergency.mode >= SHUTTLE_ESCAPE)
		world << "<span class='redtext'>The Cybermen failed to take control of the station!</span>"
		//log_yogstat_data("gamemode.php?gamemode=cybermen&value=crewwin&action=add&changed=1")
	else if(cybermen_won && station_was_nuked)
		world << "<span class='greentext'>The Cybermen win! They acivated the station's self-destruct device!</span>"
		//log_yogstat_data("gamemode.php?gamemode=cybermen&value=antagwin&action=add&changed=1")
	else if(cybermen_won)
		world << "<span class='greentext'>The Cybermen win! They have exterminated or stranded all of the non-cybermen!</span>"
		//log_yogstat_data("gamemode.php?gamemode=cybermen&value=antagwin&action=add&changed=1")
	else
		world << "<span class='redtext'>The Cybermen have failed!</span>"
		//log_yogstat_data("gamemode.php?gamemode=cybermen&value=crewwin&action=add&changed=1")
	return 1

/datum/game_mode/proc/auto_declare_completion_cybermen()
	if(cyberman_network && cyberman_network.cybermen.len > 0)
		world << "<br><span class='big'><b>The Cybermens' Objectives were:</b></span>"
		var/datum/objective/cybermen/O
		for(var/i = 1 to cyberman_network.cybermen_objectives.len-1)
			O = cyberman_network.cybermen_objectives[i]
			if(O)
				world << "Phase [i]:[O.phase]"
				world << "[O.explanation_text]"
				world << "<font color='green'><b>Completed</b></font><br>"
		O = cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len]
		world << "Phase [cyberman_network.cybermen_objectives.len]:[O.phase]"
		world << "[O.explanation_text]"
		world << (O.check_completion() ? "<font color='green'><b>Completed</b></font><br>" : "<font color='red'><b>Failed</b></font>")

		var/text = ""
		text += "<br><span class='big'><b>The Cybermen were:</b></span>"
		for(var/datum/mind/cyberman in cyberman_network.cybermen)
			text += printplayer(cyberman)
		world << text

datum/game_mode/proc/update_cybermen_icons_add(datum/mind/cyberman)
	var/datum/atom_hud/antag/cyberman_hud = huds[ANTAG_HUD_CYBERMEN]
	cyberman_hud.join_hud(cyberman.current)
	set_antag_hud(cyberman.current, "cybermen")

datum/game_mode/proc/update_cybermen_icons_remove(datum/mind/cyberman)
	var/datum/atom_hud/antag/cyberman_hud = huds[ANTAG_HUD_CYBERMEN]
	cyberman_hud.leave_hud(cyberman.current)
	set_antag_hud(cyberman.current, null)

////////////////////////////////////////////////////////
//CYBERMAN NETWORK
////////////////////////////////////////////////////////
//handles processing objectives and hacking

/datum/cyberman_network
	var/cybermen_win = 0
	var/list/datum/mind/cybermen = list()
	var/list/datum/objective/cybermen/cybermen_objectives = list()
	var/datum/objective/cybermen/queued_cybermen_objective = null
	var/list/datum/cyberman_hack/active_cybermen_hacks = list()
	var/list/cybermen_hacked_objects = list()//used for objectives, might someday be used for faster hacks on things that have already been hacked.
	var/list/datum/tech/cybermen_research_downloaded = list()//used for research objectives. May do other things as well someday.
	var/list/cybermen_access_downloaded = list()//have to use this because otherwise you could hack an ID and then change its access to get the objective, which makes no sense.
	var/list/hacking_log = list()
	var/list/cyberman_broadcast_log = list()

/datum/cyberman_network/New()
	cyberman_network = src
	START_PROCESSING(SSobj, src)
	generate_cybermen_objective(1)//there must always be an objective or it will cause runtimes.
	message_admins("The Cyberman Network has been initialized.")

/datum/cyberman_network/process(seconds)
	process_cyberman_hacking()
	process_cyberman_objectives()

/datum/cyberman_network/proc/log_hacking(message, high_priority = 0)
	if(high_priority)
		message_admins(message)
	hacking_log += "\[[time_stamp()]\][message]"

/datum/cyberman_network/proc/log_broadcast(message, high_priority = 0)
	if(high_priority)
		message_admins(message)
	cyberman_broadcast_log += "\[[time_stamp()]\][message]"

/datum/cyberman_network/proc/process_cyberman_hacking()

	for(var/datum/mind/cyberman in cybermen)
		cyberman.cyberman.process_hacking(cyberman.current)
	for(var/datum/cyberman_hack/H in active_cybermen_hacks)
		H.process()

	for(var/datum/cyberman_hack/H in active_cybermen_hacks)
		if(!H)
			active_cybermen_hacks -= H
	for(var/I in cybermen_hacked_objects)
		if(!I)
			cybermen_hacked_objects -= I
	#ifdef CYBERMEN_DEBUG
	if(active_cybermen_hacks && active_cybermen_hacks.len)
		world << "---------Active Hacks:-----------"
		for(var/datum/cyberman_hack/H in active_cybermen_hacks)
			world << "\t[H.target_name]"
	#endif
	for(var/datum/mind/cyberman in cybermen)
		if(!cyberman || qdeleted(cyberman))
			cybermen -= cyberman
			continue
		if(cyberman.cyberman.emp_hit > 0)
			cyberman.cyberman.emp_hit--

/datum/cyberman_network/proc/process_cyberman_objectives()
	if(cybermen_win)
		return
	if(cybermen_objectives.len == 0)
		return
	var/datum/objective/cybermen/T = cybermen_objectives[cybermen_objectives.len]
	if(T != null && (T.is_valid() || T.make_valid()) )
		if(T.check_completion() )
			if(!T.win_upon_completion)
				generate_cybermen_objective(cybermen_objectives.len+1)
				display_current_cybermen_objective()
			else
				//Cybermen win!
				if(!cybermen_win)
					cybermen_win = 1
					message_all_cybermen("<span class='greentext'>You have served the collective well.</span>")
	else
		message_all_cybermen("<span class='notice'>Cybermen objective has been rendered invalid, the collective is assigning a new objective...</span>")
		if(cybermen_objectives.len > 0)
			cybermen_objectives -= cybermen_objectives[cybermen_objectives.len]
		generate_cybermen_objective(cybermen_objectives.len+1)
		display_current_cybermen_objective()

/datum/cyberman_network/proc/generate_cybermen_objective(phase_num)
	if(queued_cybermen_objective)
		cybermen_objectives += queued_cybermen_objective
		queued_cybermen_objective = null
		return
	var/list/datum/objective/cybermen/explore_objectives = list(/datum/objective/cybermen/explore/get_research_levels, /datum/objective/cybermen/explore/get_secret_documents, /datum/objective/cybermen/explore/get_access)
	var/list/datum/objective/cybermen/expand_objectives = list(/datum/objective/cybermen/expand/convert_crewmembers, /datum/objective/cybermen/expand/hack_ai, /datum/objective/cybermen/expand/convert_heads)
	var/list/datum/objective/cybermen/exploit_objectives = list(/datum/objective/cybermen/exploit/analyze_and_hack)
	var/list/datum/objective/cybermen/exterminate_objectives = list(/datum/objective/cybermen/exterminate/nuke_station, /datum/objective/cybermen/exterminate/hijack_shuttle)//, /datum/objective/cybermen/exterminate/eliminate_humans)

	var/datum/objective/cybermen/current_objective
	phase_num = Clamp(phase_num, 1, 4)//You can get past 4 objectives with admin meddling in the Cyberman panel.
	switch(phase_num)
		if(1)
			//Explore
			current_objective = generate_cybermen_objective_helper(explore_objectives)
		if(2)
			//Expand
			current_objective = generate_cybermen_objective_helper(expand_objectives)
		if(3)
			//Exploit
			current_objective = generate_cybermen_objective_helper(exploit_objectives)
		if(4)
			//Exterminate
			current_objective = generate_cybermen_objective_helper(exterminate_objectives)
		else
			log_game("ERROR: cyberman objective number incorrect. Was [cybermen_objectives.len], should be 1, 2, 3, or 4.")
			message_admins("Cybermen objectives were not properly assigned.")
			return
	if(current_objective)
		cybermen_objectives += current_objective
	else
		log_game("ERROR: unable to select a valid cybermen objective from phase [phase_num] pool. Taking an objective from the next stage pool instead.")
		generate_cybermen_objective(phase_num+1)//this will make the cybermen have two later phase objectives for the round instead.

/datum/cyberman_network/proc/generate_cybermen_objective_helper(list/datum/objective/cybermen/possible_objectives)
	var/datum/objective/cybermen/current_objective = null
	while(!current_objective && possible_objectives.len > 0)
		var/type = pick(possible_objectives)
		current_objective = new type()
		if(!current_objective.is_valid() && !current_objective.make_valid() )
			possible_objectives -= current_objective
			current_objective = null
	return current_objective


/datum/cyberman_network/proc/display_all_cybermen_objectives(datum/mind/M)
	if(cybermen_objectives.len < 1)
		M.current << "<span class='notice'>No objectives to display.</span>"
		return
	var/datum/objective/cybermen/O
	M.current << "<span class='notice'>The objectives of the Cybermen aboard [station_name()] are as follows:</span>"
	for(var/i = 1 to cybermen_objectives.len-1)
		O = cybermen_objectives[i]
		if(O)
			O.check_completion()//needed for updating explanation text.
			M.current << "Phase [i]:[O.phase]"
			M.current << "[O.explanation_text]"
			M.current << "<font color='green'><b>Complete</b></font><br>"
	O = cybermen_objectives[cybermen_objectives.len]
	M.current << "Phase [cybermen_objectives.len]:[O.phase]"
	M.current << "[O.explanation_text]"
	M.current << (O.check_completion() ? "<font color='green'><b>Complete</b></font><br>" : "<font color='yellow'><b>In Progress</b></font>")

/datum/cyberman_network/proc/display_current_cybermen_objective()
	if(cybermen_objectives.len > 0)
		var/datum/objective/cybermen/O = cybermen_objectives[cybermen_objectives.len]
		O.check_completion()//needed for updating explanation text.
		message_all_cybermen("<span class='notice'>Cybermen objectives have advanced to stage [cybermen_objectives.len]:[O.phase]. Your new objective is: </span>")
		message_all_cybermen(O.explanation_text)
	else
		log_game("ERROR - [usr] attempted to display current cyberman objective when there are no objectives")

/datum/cyberman_network/proc/message_all_cybermen(message)
	for(var/datum/mind/cyberman in cybermen)
		cyberman.current << message

/datum/cyberman_network/proc/is_cyberman_or_being_converted(mob/living/carbon/human/H)//this one accepts mobs instead of minds, because conversion hacks target mobs, not minds.
	if(!istype(H))
		return 0
	if(ticker.mode.is_cyberman(H.mind))
		return 1
	for(var/datum/cyberman_hack/human/hack in cyberman_network.active_cybermen_hacks)
		if(hack.target == H)
			return 1
	return 0

////////////////////////////////////////////////////////
//CYBERMAN DATUM
////////////////////////////////////////////////////////

/datum/mind/
	var/datum/cyberman_datum/cyberman

/datum/cyberman_datum
	var/emp_hit = 0//if not 0, cyberman cannot hack or use cyberman broadcast. reduced by 1 every tick if it is greater than 0. set to -1 for infinite EMPed.
	var/quickhack = 0
	var/datum/cyberman_hack/selected_hack
	var/datum/cyberman_hack/manual_selected_hack
	var/hack_power_level_1 = CYBERMEN_BASE_HACK_POWER_1//might want to do all these in a single list instead of separate variables.
	var/hack_power_level_2 = CYBERMEN_BASE_HACK_POWER_2
	var/hack_power_level_3 = CYBERMEN_BASE_HACK_POWER_3
	var/hack_power_level_4 = CYBERMEN_BASE_HACK_POWER_4
	var/hack_max_dist_level_1 = CYBERMEN_BASE_HACK_RANGE_1
	var/hack_max_dist_level_2 = CYBERMEN_BASE_HACK_RANGE_2
	var/hack_max_dist_level_3 = CYBERMEN_BASE_HACK_RANGE_3
	var/hack_max_start_dist = 1
	var/hack_max_maintain_dist = CYBERMEN_BASE_HACK_MAINTAIN_RANGE
	var/list/upgrades_installed = list()
	var/list/datum/action/cyberman/abilities = list(new /datum/action/cyberman/commune(), new /datum/action/cyberman/cyberman_disp_objectives(), new /datum/action/cyberman/cyberman_toggle_quickhack(), new /datum/action/cyberman/cyberman_cancel_hack(), new /datum/action/cyberman/cyberman_manual_select_hack())

/datum/cyberman_datum/proc/validate(mob/living/carbon/human/user = usr)
	if(!user)
		return 0
	if(!ishuman(user))//cybermen need to be human.
		return 0
	if(!ticker.mode.is_cyberman(user.mind) )
		return 0
	if(user.mind.cyberman != src)
		log_game("[user] somehow tried to use cyberman abilities with someone else's cyberman datum. Please report this bug to a coder.")
		return 0
	return 1

/datum/cyberman_datum/proc/add_cyberman_abilities_to_statpanel(mob/user)
	if(!validate(user))
		return
	for(var/datum/action/cyberman/A in abilities)
		statpanel("[A.panel]", "", A.button)

/datum/cyberman_datum/proc/update_processing_power(mob/living/carbon/human/user = usr)
	if(!validate(user) )
		return
	hack_power_level_1 = CYBERMEN_BASE_HACK_POWER_1
	hack_power_level_2 = CYBERMEN_BASE_HACK_POWER_2
	hack_power_level_3 = CYBERMEN_BASE_HACK_POWER_3
	hack_power_level_4 = CYBERMEN_BASE_HACK_POWER_4
	hack_max_dist_level_1 = CYBERMEN_BASE_HACK_RANGE_1
	hack_max_dist_level_2 = CYBERMEN_BASE_HACK_RANGE_2
	hack_max_dist_level_3 = CYBERMEN_BASE_HACK_RANGE_3
	hack_max_maintain_dist = CYBERMEN_BASE_HACK_MAINTAIN_RANGE

	for(var/obj/item/bodypart/L in user.bodyparts)
		if(L.status == ORGAN_ROBOTIC)
			upgrades_installed |= L
	for(var/obj/item/bodypart/L in upgrades_installed)
		hack_power_level_1 += 1
		hack_power_level_2 += 1
		hack_power_level_3 += 1

	for(var/obj/item/weapon/stock_parts/capacitor/P in upgrades_installed)
		var/increase_amount = P.rating * 2.5
		hack_power_level_1 += increase_amount
		hack_power_level_2 += increase_amount
		hack_power_level_3 += increase_amount

/datum/cyberman_datum/proc/process_hacking(mob/living/carbon/human/user = usr)
	//this proc assumes that there are no null or qdeleted items in cybermen_active_hacks. If there are any nulls, it could cause a null pointer exception and break hacking for this tick.
	selected_hack = null
	if(!validate(user) || user.stat)
		return
	if(user.stat || user.stunned || emp_hit)
		return
	if(cyberman_network.active_cybermen_hacks.len == 0)
		return
	update_processing_power(user)
	if(manual_selected_hack && (manual_selected_hack in cyberman_network.active_cybermen_hacks) )
		selected_hack = manual_selected_hack
	else if(cyberman_network.active_cybermen_hacks.len > 0)
		var/best_preference = -1
		for(var/datum/cyberman_hack/current_hack in cyberman_network.active_cybermen_hacks)
			var/this_preference = current_hack.get_preference_for(user)
			if(this_preference > best_preference)
				best_preference = this_preference
				selected_hack = current_hack
	if(selected_hack)
		selected_hack.contribute_to(user)
	return

/datum/cyberman_datum/proc/emp_act(mob/living/carbon/human/mob, severity)
	mob.Stun(14)
	mob.Weaken(14)
	mob.silent = max(60, mob.silent)
	mob.adjustBrainLoss(40)
	mob.adjustBruteLoss(15)
	mob.adjustFireLoss(15)
	mob.visible_message("<span class='danger'>[mob] clutches their head, writhing in pain!</span>")
	emp_hit = max(60, emp_hit)

/datum/cyberman_datum/proc/get_status_objs(mob/living/carbon/human/user)
	var/list/obj/status_obj/status_objs = list()
	var/obj/status_obj/temp = new /obj/status_obj()
	if(selected_hack)
		var/manual_selected = manual_selected_hack ? "(manual)" : "(auto)"
		temp.assign_obj(selected_hack, "Currently Processing Hack[manual_selected]: [selected_hack.get_status(user)]")
	else
		temp.assign_obj(null, "Currently Processing Hack(auto): none")
	status_objs += temp
	for(var/datum/cyberman_hack/hack in cyberman_network.active_cybermen_hacks)
		if(hack && hack != selected_hack)
			temp = new /obj/status_obj()
			temp.assign_obj(hack, hack.get_status(user))
			status_objs += temp
	return status_objs

//these are so you can click on objects in the statpanel with a special name, without messing with the name of the object.
/obj/status_obj/
	var/obj/obj

/obj/status_obj/proc/assign_obj(obj/newObj, newName)
	obj = newObj
	name = newName

/obj/status_obj/DblClick()
	if(!obj)
		return
	return obj.DblClick()

/obj/status_obj/examine(mob/user)
	if(!obj)
		return
	obj.examine(user)

/*
/obj/status_obj/Click()
	if(!obj)
		return
	return obj.Click()
*/

//hacking hud
/datum/atom_hud/data/cybermen
	hud_icons = list(CYBERMEN_HACK_HUD)
