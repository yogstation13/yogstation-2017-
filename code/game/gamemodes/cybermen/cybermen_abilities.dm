#define CYBERMEN_HACK_NOISE_DIST 3

//////////////////////
//Ability Activators//
//////////////////////

/datum/action/cyberman
	var/panel = "Cyberman"
	button_icon = 'icons/mob/actions.dmi'
	button_icon_state = "cyberman"
	background_icon_state = "bg_default"

/datum/action/cyberman/commune
	name = "Cyberman Broadcast"
	desc = "Communicate with fellow cybermen. Completely undetectable, but cannot be done if you have been recently EMPed."
	button_icon_state = "cyberman_broadcast"

/datum/action/cyberman/commune/Trigger()
	if(!(usr.mind && usr.mind.cyberman))
		usr << "You are not a cyberman, you should not be able to do this!"
		return 0
	return usr.mind.cyberman.use_broadcast(usr)

/datum/action/cyberman/cyberman_toggle_quickhack
	name = "Prepare Hacking"
	desc = "Enable or disable your cyberman hacking module."
	button_icon_state = "cyberman_hacking_off"

/datum/action/cyberman/cyberman_toggle_quickhack/Trigger()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.toggle_quickhack(usr)
	button_icon_state = usr.mind.cyberman.quickhack ? "cyberman_hacking_on" : "cyberman_hacking_off"
	UpdateButtonIcon()

/datum/action/cyberman/cyberman_manual_select_hack
	name = "Select Current Hack"
	desc = "Select the hack you are contributing processing power to."
	button_icon_state = "cyberman_select_hack"

/datum/action/cyberman/cyberman_manual_select_hack/Trigger()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.manual_select_hack(usr)

/datum/action/cyberman/cyberman_cancel_hack
	name = "Cancel Hack"
	desc = "End a hack prematurely."
	button_icon_state = "cyberman_cancel_hack"

/datum/action/cyberman/cyberman_cancel_hack/Trigger()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.manual_cancel_hack()

/datum/action/cyberman/cyberman_disp_objectives
	name = "Display Objectives"
	desc = "Display all cyberman objectives that have been assigned so far."
	button_icon_state = "cyberman_objectives"

/datum/action/cyberman/cyberman_disp_objectives/Trigger()
	cyberman_network.display_all_cybermen_objectives(usr.mind)

////////////////////
//Actual abilities//
////////////////////
/datum/cyberman_datum/proc/initiate_hack(atom/target, mob/living/carbon/human/user = usr)
	if(user.stat)//no more hacking while a ghost
		return
	if(!validate(user) )
		user << "<span class='warning'>You are not a Cyberman, you cannot initiate a hack.</span>"
		return
	if(emp_hit)
		user << "<span class='warning'>You were recently hit by an EMP, you cannot hack right now!</span>"
		return
	var/dist = get_dist(user, target)
	if(dist > hack_max_start_dist)
		user << "<span class='warning'>You are to far away to hack \the [target].</span>"
		return
	var/datum/cyberman_hack/newHack = target.get_cybermen_hack()
	if(newHack)
		if(dist <= 1)//someday there could be cybermen who can hack from range.
			target.add_fingerprint(user, 1)//let's assume cybermen have to touch the thing with their bare hand to hack it - we can make gloves work if they seem to be struggling.
		user.audible_message("<span class='danger'>You hear a faint sound of static.</span>", CYBERMEN_HACK_NOISE_DIST )
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			H << "<span class='warning'>You feel a tiny prick!</span>"
		cyberman_network.message_all_cybermen("<span class='notice'>[newHack.display_verb] of [newHack.target_name] started by [user.real_name].</span>")
		if(newHack.start())
			select_hack(user, newHack)
	else
		user << "<span class='warning'>\The [target] cannot be hacked.</span>"


/datum/cyberman_datum/proc/cancel_hack(mob/living/carbon/human/user = usr, datum/cyberman_hack/hack)
	if(!validate(user) || !hack || user.stat || user.stunned)
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(hack.can_cancel(user) )
		hack.drop("<span class='warning'>[hack.display_verb] of \the [hack.target_name] canceled by [user.real_name].<span>")
	else
		user << "<span class='warning'>You cannot cancel a hack unless you are close enough to maintain it!</span>"


/datum/cyberman_datum/proc/cancel_closest_component_hack(mob/living/carbon/human/user = usr, datum/cyberman_hack/multiple_vector/hack)
	if(!validate(user) || !hack || !istype(hack, /datum/cyberman_hack/multiple_vector))
		return
	hack.do_tick_calculations_if_required(user)
	if(!hack.tick_best_hack)
		user << "<span class='warning'>Error: No component hacks of [hack.target_name] detected.</span>"
		return
	if(!hack.tick_best_hack.can_cancel(user) )
		user << "<span class='warning'>You are not close enough to cancel the [hack.tick_best_hack.display_verb] of \the [hack.tick_best_hack.target_name], the closest component hack of \the [hack.target_name].</span>"
		return
	if(hack.component_hacks.len == 1 && !hack.innate_processing)//safeguard in case they don't realise that they are the last one hacking the ai/tcomms network/etc. If it is a magic admin/debug hack, though, you can always stop contributing.
		user << "<span class='warning'>The [hack.tick_best_hack.display_verb] of \the [hack.tick_best_hack.target_name] is the only remaining component hack of \the [hack.target_name]. If you want to cancel it, you must cancel the whole hack.</span>"
		return
	hack.tick_best_hack.drop("<span class='notice'>The [hack.tick_best_hack.display_verb] of \the [hack.tick_best_hack.target_name], which was contributing to the [hack.display_verb] of \the [hack.target_name], was canceled by [user.real_name].<span>")


/datum/cyberman_datum/proc/select_hack(mob/living/carbon/human/user = usr, datum/cyberman_hack/hack)
	if(!validate(user))
		return
	if(hack == user.mind.cyberman.manual_selected_hack)
		user.mind.cyberman.manual_selected_hack = null
	else
		user.mind.cyberman.manual_selected_hack = hack

/datum/cyberman_datum/proc/use_broadcast(mob/living/carbon/human/user = usr)
	if(user.stat == DEAD || user.stat == UNCONSCIOUS)//you can still use it while stunned.
		user << "<span class='warning'>You can't use that right now!</span>"
		return 0
	if(emp_hit)
		user << "<span class='warning'>You were hit by an EMP recently, you cannot use the cyberman broadcast!</span>"
		return 0
	var/input = stripped_input(user, "Enter a message to share with all other Cybermen.", "Cybermen Broadcast", "")
	if(input)
		cyberman_network.log_broadcast("[user.real_name]([user.ckey ? user.ckey : "No ckey"]) Sent a Cyberman Broadcast: [input]")
		log_say("[key_name(user)] : [input]", "CYBERMAN")
		//user.say_log_silent += "Cyberman Broadcast: [input]"
		for(var/datum/mind/cyberman in cyberman_network.cybermen)
			var/distorted_message = input
			if(cyberman.cyberman.emp_hit)
				distorted_message = Gibberish2(input, cyberman.cyberman.emp_hit*1.6)
			cyberman.current << "<span class='cyberman'>Cyberman Broadcast: [distorted_message]</span>"
		for(var/mob/dead in dead_mob_list)
			dead << "<span class='cyberman'>Cyberman Broadcast: [input]</span>"
	return 1

/datum/cyberman_datum/proc/get_user_selected_hack(mob/living/carbon/human/user = usr, display, null_option)
	var/list/hacks = list()
	for(var/datum/cyberman_hack/hack in cyberman_network.active_cybermen_hacks)
		hacks += hack.target_name
	if(null_option)
		hacks += null_option
	var/target_hack_name = input(usr, display, "Cyberman Hack Management") as null|anything in hacks
	if(!target_hack_name || target_hack_name == null_option)
		return null
	var/datum/cyberman_hack/target_hack = null
	for(var/datum/cyberman_hack/hack in cyberman_network.active_cybermen_hacks)//this will have issues if two different hacked objects have the same name.
		if(hack.target_name == target_hack_name)
			target_hack = hack
			break
	return target_hack

/datum/cyberman_datum/proc/toggle_quickhack(mob/living/carbon/human/user = usr)
	quickhack = !quickhack
	user << (user.mind.cyberman.quickhack ? "<span class='notice'>You prepare to hack nearby objects. Use alt- or middle-click to hack. You can double-click on a hack in the Status panel to focus on it, or shift-click on it to learn what it does.</span>" : "<span class='notice'>You decide not to hack anything for the moment. You will still contribute to nearby hacks passively.</span>")


/datum/cyberman_datum/proc/manual_select_hack(mob/living/carbon/human/user = usr)
	var/datum/cyberman_hack/selected_hack = get_user_selected_hack(user, "Choose which hack you wish to contribute to:", "(automatic)")
	if(selected_hack)
		select_hack(user, selected_hack)


/datum/cyberman_datum/proc/manual_cancel_hack(mob/living/carbon/human/user = usr)
	var/datum/cyberman_hack/selected_hack = get_user_selected_hack(user, "Choose which hack you wish to cancel:", "(none)")
	if(selected_hack)
		user.mind.cyberman.cancel_hack(user, selected_hack)


/datum/cyberman_datum/proc/manual_cancel_component_hack(mob/living/carbon/human/user = usr)
	var/datum/cyberman_hack/selected_hack = get_user_selected_hack(user, "(none)")
	if(selected_hack)
		user.mind.cyberman.cancel_closest_component_hack(usr, selected_hack)

/////////////////////////////////////////////
///////////////DEBUG/ADMIN///////////////////
/////////////////////////////////////////////

var/list/cybermen_debug_abilities = list(/datum/admins/proc/become_cyberman,
										 /datum/admins/proc/become_cyberman_instant,
										 /datum/admins/proc/cyberman_defect,
										 /datum/admins/proc/reroll_cybermen_objective,
										 /datum/admins/proc/force_complete_cybermen_objective,
										 /datum/admins/proc/set_cybermen_objective,
										 /datum/admins/proc/start_auto_hack,
										 /datum/admins/proc/cybermen_collective_broadcast
										    )

/datum/admins/proc/become_cyberman()
	set category = "Cyberman Debug"
	set name = "Become Cyberman"

	if(ticker.mode.is_cyberman(usr.mind))
		usr << "You are already a Cyberman!"
	else
		var/datum/cyberman_hack/newHack = usr.get_cybermen_hack()
		newHack.innate_processing = 10
		if(newHack)
			if(newHack.start())
				usr << "You are now becoming a Cyberman..."
			else
				usr << "Cyberman conversion failed."

/datum/admins/proc/become_cyberman_instant()
	set category = "Cyberman Debug"
	set name = "Become Cyberman (Instant)"

	if(ticker.mode.is_cyberman(usr.mind))
		usr << "You are already a Cyberman!"
	else
		ticker.mode.add_cyberman(usr.mind)


/datum/admins/proc/cyberman_defect()
	set category = "Cyberman Debug"
	set name = "Quit being a Cyberman"
	src << "Removing cyberman status..."
	ticker.mode.remove_cyberman(usr.mind)


/datum/admins/proc/reroll_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Reroll Objective"
	if(alert("Set a new random Cyberman objective?", usr, "Yes", "No") == "No" )
		return
	if(!cyberman_network)
		usr << "There is no Cyberman network to change the objective of."
		return

	message_admins("[key_name_admin(usr)] re-rolled the current cybermen objective.")
	log_admin("[key_name(usr)] re-rolled the current cybermen objective.")

	cyberman_network.message_all_cybermen("Re-assigning current objective...")
	cyberman_network.cybermen_objectives -= cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len]
	cyberman_network.generate_cybermen_objective(cyberman_network.cybermen_objectives.len+1)
	cyberman_network.display_current_cybermen_objective()

/datum/admins/proc/force_complete_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Force Complete Objective"
	if(alert("Set current Cybermen objective as completed?", usr, "Yes", "No") == "No" )
		return
	if(!cyberman_network)
		usr << "There is no Cyberman network to complete the objective of."
		return
	if(cyberman_network.cybermen_objectives.len)
		var/datum/objective/cybermen/O = cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len]
		if(O)
			O.completed = 1
			message_admins("[key_name_admin(usr)] has force-completed the cybermen objective: \"[O.explanation_text]\".")
			log_admin("[key_name(usr)] has force-completed the cybermen objective: \"[O.explanation_text]\".")
		else
			usr << "<span class='warning'>ERROR - Current Cybermen objective is null.</span>"
	else
		usr << "<span class='warning'>ERROR - No cybermen objective to force-complete.</span>"

/datum/admins/proc/set_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Set Current Objective"

	if(!cyberman_network)
		usr << "There is no Cyberman network to set the objective of."
		return
	var/list/objective_options = list()
	for(var/type in typesof(/datum/objective/cybermen/))
		var/datum/objective/cybermen/O = new type()
		if(O.name == "Unnamed Objective")
			continue
		objective_options += O.name
		objective_options[O.name] = O
	var/chosen_objective_name = input("Select new objective:") as null|anything in objective_options
	if(!chosen_objective_name)
		return
	var/datum/objective/cybermen/chosen_objective = objective_options[chosen_objective_name]
	chosen_objective.admin_create_objective()

	message_admins("[key_name_admin(usr)] has set the current cybermen objective to: \"[chosen_objective.explanation_text]\".")
	log_admin("[key_name(usr)] has set the current cybermen objective to: \"[chosen_objective.explanation_text]\".")

	cyberman_network.message_all_cybermen("Re-assigning current objective...")
	cyberman_network.cybermen_objectives -= cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len]
	cyberman_network.cybermen_objectives += chosen_objective
	cyberman_network.display_current_cybermen_objective()

/datum/admins/proc/set_cybermen_queued_objective()
	set category = "Cyberman Debug"
	set name = "Set Queued Objective"

	if(!cyberman_network)
		usr << "There is no Cyberman network to set the objective of."
		return
	var/list/objective_options = list()
	for(var/type in typesof(/datum/objective/cybermen/))
		var/datum/objective/cybermen/O = new type()
		if(O.name == "Unnamed Objective")
			continue
		objective_options += O.name
		objective_options[O.name] = O
	var/chosen_objective_name = input("Select new objective:") as null|anything in objective_options
	if(!chosen_objective_name)
		return
	var/datum/objective/cybermen/chosen_objective = objective_options[chosen_objective_name]
	chosen_objective.admin_create_objective()

	message_admins("[key_name_admin(usr)] has set the queued cybermen objective to: \"[chosen_objective.explanation_text]\".")
	log_admin("[key_name(usr)] has set the queued cybermen objective to: \"[chosen_objective.explanation_text]\".")

	cyberman_network.queued_cybermen_objective = chosen_objective

/datum/admins/proc/start_auto_hack(atom/target in world)
	set category = "Cyberman Debug"
	set name = "Start Automatic Hack"
	var/datum/cyberman_hack/newHack = target.get_cybermen_hack()
	if(newHack)
		if(newHack.start())
			newHack.innate_processing = 10
		else
			usr << "[newHack.display_verb] of [newHack.target_name] failed."
	else
		usr << "[target] cannot be hacked."

/datum/admins/proc/cybermen_collective_broadcast()
	set category = "Cyberman Debug"
	set name = "Cyberman Collective Broadcast"

	if(!cyberman_network)
		usr << "You cannot make a Cyberman Collective Broadcast, there are no cybermen to hear it."
		return
	var/input = stripped_input(usr, "Enter a message to share with all other Cybermen. This message will not be distorted by EMP effects.", "Cybermen Collective Broadcast", "")
	if(input)
		cyberman_network.log_broadcast("[usr] Sent a Cyberman Collective Broadcast: [input]", 1)
		for(var/datum/mind/cyberman in cyberman_network.cybermen)
			cyberman.current << "<span class='cybermancollective'>Cyberman Collective: [input]</span>"
		for(var/mob/dead in dead_mob_list)
			dead << "<span class='cybermancollective'>Cyberman Collective: [input]</span>"
