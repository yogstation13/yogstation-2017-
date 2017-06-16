//WIZARD MODE
//An angry nerd with godlike powers is unleashed upon the station.
//ARGS:
///DUO - Two standard wizards, but each must eliminate the other in addition to their objectives.
///TRIFECTA - High stakes, magic fueled double agent (plus normal objectives)
///RAGING - Forget one wizard, an entire wizard invasion force boards Space Station 13.
///BULLSHIT_RAGING - The wizards don't stop.  The wizards never stop.  WHY WON'T THE WIZARDS STOP?
///ONLY_ONE - Everyone becomes a wizard, imbued with great magical powers and a desire to kill everyone but themselves.

/datum/game_mode/wizard
	name = "wizard"
	config_tag = "wizard"
	antag_flag = ROLE_WIZARD
	end_condition = END_CONDITION_WEAK //If there's other modes in play, the death of the wizard won't end them.
	required_players = 20
	required_enemies = 1
	recommended_enemies = 1
	enemy_minimum_age = 14
	prob_traitor_ai = 18
	var/use_huds = 0
	var/finished = 0

	//raging mages vars
	var/max_mages = 1 //Determines wizard respawn ability
	var/mages_made = 0
	var/making_mage = 0
	var/time_check = 1500
	var/time_checked
	var/spawn_delay_min = 500
	var/spawn_delay_max = 700

	var/list/datum/mind/wizards = list()
	var/list/datum/mind/apprentices = list()
	var/list/datum/mind/target_list = list() //For double-agent esque modes

/datum/game_mode/wizard/announce()
	world << "<B>The current game mode is - Wizard!</B>"
	if(has_arg("RAGING"))
		world << "<B>The <span class='warning'>Space Wizard Federation</span> is pissed, help defeat all the space wizards!</B>"
		return
	if(has_arg("BULLSHIT_RAGING"))
		world << "<B>The <span class='warning'>Space Wizard Federation</span> is super pissed, survive the onslaught and escape!</B>"
		return
	if(has_arg("ONLY_ONE"))
		world << "<B>The <span class='warning'>Space Wizard Federation</span> has ordered a bunch of wizards to kill each other for their own amusment!</B>"
		return
	world << "<B>There is a <span class='danger'>SPACE WIZARD</span>\black on the station. You can't let him achieve his objective!</B>"

/datum/game_mode/wizard/pre_setup(datum/game/G, list/a)
	args = a
	time_checked = world.time

	if(has_arg("RAGING"))
		max_mages = round(num_players() / 8)
		if(max_mages < 1)
			max_mages = 1
		if(max_mages > 20) //haha yeah right
			max_mages = 20

	if(has_arg("BULLSHIT_RAGING"))
		max_mages = INFINITY //hey, it's in the name

	var/roundstart_wizards = 1
	if(has_arg("DUO"))
		roundstart_wizards = 2
	if(has_arg("TRIFECTA"))
		roundstart_wizards = 3
	if(has_arg("ONLY_ONE"))
		roundstart_wizards = num_players()
		end_condition = END_CONDITION_STRONG //Objective is to kill EVERYTHING, other modes be damned

	mages_made += roundstart_wizards

	var/list/datum/mind/selected_wizards = G.prepare_candidates(antag_flag, roundstart_wizards)

	for(var/v in selected_wizards)
		var/datum/mind/wizard = v
		wizards += wizard
		wizard.assigned_role = "Wizard"
		wizard.special_role = "Wizard"
		if(wizardstart.len == 0)
			wizard.current << "<span class='boldannounce'>A starting location for you could not be found, please report this bug!</span>"
			return 0

	for(var/datum/mind/wiz in wizards)
		if(has_arg("ONLY_ONE"))
			wiz.current.loc = pick(blobstart) //Not enough room on the wizard ship for all players, drop them straight on the station.
		else
			wiz.current.loc = pick(wizardstart)

	return 1


/datum/game_mode/wizard/post_setup()
	if (has_arg("DUO") || has_arg("TRIFECTA")) //The only difference between these two is the number of wizards spawned, if you want you can add more options
		var/i = 0
		for(var/datum/mind/wizard in wizards)
			i++
			if(i + 1 > wizards.len)
				i = 0
			target_list[wizard] = wizards[i + 1]

	for(var/datum/mind/wizard in wizards)
		log_game("[wizard.key] (ckey) has been selected as a Wizard")
		equip_wizard(wizard.current)
		forge_wizard_objectives(wizard)
		if(use_huds)
			update_wiz_icons_added(wizard)
		greet_wizard(wizard)
		name_wizard(wizard.current)
	..()
	return


/datum/game_mode/wizard/proc/forge_wizard_objectives(datum/mind/wizard)
	if (has_arg("DUO") || has_arg("TRIFECTA")) //Simply adds on to the standard objective set
		forge_backstab_objectives(wizard)
	if (has_arg("ONLY_ONE"))
		var/datum/objective/only_one/killemall = new
		wizard.objectives += killemall
		return
	switch(rand(1,100))
		if(1 to 30)

			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			if (!(locate(/datum/objective/escape) in wizard.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = wizard
				wizard.objectives += escape_objective
		if(31 to 60)
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			if (!(locate(/datum/objective/escape) in wizard.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = wizard
				wizard.objectives += escape_objective

		if(61 to 85)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			if (!(locate(/datum/objective/survive) in wizard.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = wizard
				wizard.objectives += survive_objective

		else
			if (!(locate(/datum/objective/hijack) in wizard.objectives))
				var/datum/objective/hijack/hijack_objective = new
				hijack_objective.owner = wizard
				wizard.objectives += hijack_objective
	return

/datum/game_mode/wizard/proc/forge_backstab_objectives(datum/mind/wizard)
	var/datum/objective/assassinate/wizard/kill_objective = new
	kill_objective.owner = wizard
	kill_objective.target = target_list[wizard]
	kill_objective.update_explanation_text()
	wizard.objectives += kill_objective

/datum/game_mode/wizard/proc/name_wizard(mob/living/carbon/human/wizard_mob)
	//Allows the wizard to choose a custom name or go with a random one. Spawn 0 so it does not lag the round starting.
	var/wizard_name_first = pick(wizard_first)
	var/wizard_name_second = pick(wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	spawn(0)
		var/newname = copytext(sanitize(input(wizard_mob, "You are the Space Wizard. Would you like to change your name to something else?", "Name change", randomname) as null|text),1,MAX_NAME_LEN)

		if (!newname)
			newname = randomname

		wizard_mob.real_name = newname
		wizard_mob.name = newname
		if(wizard_mob.mind)
			wizard_mob.mind.name = newname
	return


/datum/game_mode/wizard/proc/greet_wizard(datum/mind/wizard, you_are=1)
	if (has_arg("RAGING") || has_arg("BULLSHIT_RAGING"))
		if (you_are)
			wizard.current << "<span class='boldannounce'>You are a Space Wizard!</span>"
		wizard.current << "<B>The Space Wizards Federation has given you the following tasks:</B>"
		wizard.current << "<b>Objective Alpha</b>: Make sure the station pays for its actions against our diplomats."
	else
		if (you_are)
			wizard.current << "<span class='boldannounce'>You are the Space Wizard!</span>"
		wizard.current << "<B>The Space Wizards Federation has given you the following tasks:</B>"

	var/obj_count = 1
	for(var/datum/objective/objective in wizard.objectives)
		wizard.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return


/datum/game_mode/wizard/proc/learn_basic_spells(mob/living/carbon/human/wizard_mob)
	if(!istype(wizard_mob) || !wizard_mob.mind)
		return 0
	wizard_mob.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile(null)) //Wizards get Magic Missile and Ethereal Jaunt by default
	wizard_mob.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(null))


/datum/game_mode/wizard/proc/equip_wizard(mob/living/carbon/human/wizard_mob)
	if (!istype(wizard_mob))
		return
	if(wizard_mob.dna && wizard_mob.dna.species.dangerous_existence)
		wizard_mob.set_species(/datum/species/human)
	//So zards properly get their items when they are admin-made.
	qdel(wizard_mob.wear_suit)
	qdel(wizard_mob.head)
	qdel(wizard_mob.shoes)
	qdel(wizard_mob.r_hand)
	qdel(wizard_mob.r_store)
	qdel(wizard_mob.l_store)

	wizard_mob.equip_to_slot_or_del(new /obj/item/device/radio/headset(wizard_mob), slot_ears)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(wizard_mob), slot_w_uniform)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(wizard_mob), slot_shoes)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(wizard_mob), slot_wear_suit)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(wizard_mob), slot_head)
	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(wizard_mob), slot_back)
	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(wizard_mob), slot_in_backpack)
	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll(wizard_mob), slot_r_store)
	var/obj/item/weapon/spellbook/spellbook = new /obj/item/weapon/spellbook(wizard_mob)
	spellbook.owner = wizard_mob
	wizard_mob.equip_to_slot_or_del(spellbook, slot_r_hand)

	wizard_mob << "You will find a list of available spells in your spell book. Choose your magic arsenal carefully."
	wizard_mob << "The spellbook is bound to you, and others cannot use it."
	wizard_mob << "In your pockets you will find a teleport scroll. Use it as needed."
	wizard_mob.mind.store_memory("<B>Remember:</B> do not forget to prepare your spells.")
	wizard_mob.update_icons()
	return 1


/datum/game_mode/wizard/check_finished()
	if (has_arg("RAGING") || has_arg("BULLSHIT_RAGING"))
		return check_raging_completion()

	if (has_arg("ONLY_ONE"))
		var/living_wizards = 0
		var/how_many_there_can_be = 1
		for (var/datum/mind/wizard in wizards)
			if(isliving(wizard.current) && wizard.current.stat!=DEAD)
				living_wizards++
		if (living_wizards <= how_many_there_can_be)
			return 1

	for(var/datum/mind/wizard in wizards)
		if(isliving(wizard.current) && wizard.current.stat!=DEAD)
			return ..()

	if(SSevent.wizardmode) //If summon events was active, turn it off
		SSevent.toggleWizardmode()
		SSevent.resetFrequency()

	return ..()

/datum/game_mode/wizard/proc/check_raging_completion()
	var/wizards_alive = 0
	for(var/datum/mind/wizard in wizards)
		if(!istype(wizard.current,/mob/living/carbon))
			continue
		if(istype(wizard.current,/mob/living/carbon/brain))
			continue
		if(wizard.current.stat==DEAD)
			continue
		if(wizard.current.stat==UNCONSCIOUS)
			if(wizard.current.health < 0)
				wizard.current << "<font size='4'>The Space Wizard Federation is upset with your performance and have terminated your employment.</font>"
				wizard.current.death()
			continue
		wizards_alive++
	if(!time_checked)
		time_checked = world.time
	if("BULLSHIT_RAGING" in args)
		if(world.time > time_checked + time_check)
			max_mages = INFINITY
			time_checked = world.time
			make_more_mages()
			return ..()
	if (wizards_alive)
		if(world.time > time_checked + time_check && (mages_made < max_mages))
			time_checked = world.time
			make_more_mages()

	else
		if(mages_made >= max_mages)
			finished = 1
			return ..()
		else
			make_more_mages()
	return ..()

/datum/game_mode/wizard/proc/make_more_mages()

	if(making_mage)
		return 0
	if(mages_made >= max_mages)
		return 0
	making_mage = 1
	mages_made++
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	spawn(rand(spawn_delay_min, spawn_delay_max))
		message_admins("SWF is still pissed, sending another wizard - [max_mages - mages_made] left.")
		for(var/mob/dead/observer/G in player_list)
			if(G.client && !G.client.holder && !G.client.is_afk() && (ROLE_WIZARD in G.client.prefs.be_special))
				if(!jobban_isbanned(G, ROLE_WIZARD) && !jobban_isbanned(G, "Syndicate"))
					if(ticker.game.age_check(G.client, src))
						candidates += G
		if(!candidates.len)
			message_admins("No applicable ghosts for the next ragin' mage, asking ghosts instead.")
			var/time_passed = world.time
			for(var/mob/dead/observer/G in player_list)
				if(!jobban_isbanned(G, "wizard") && !jobban_isbanned(G, "Syndicate"))
					if(ticker.game.age_check(G.client, src))
						spawn(0)
							switch(alert(G, "Do you wish to be considered for the position of Space Wizard Foundation 'diplomat'?","Please answer in 30 seconds!","Yes","No"))
								if("Yes")
									if((world.time-time_passed)>300)//If more than 30 game seconds passed.
										continue
									candidates += G
								if("No")
									continue

			sleep(300)
		if(!candidates.len)
			message_admins("This is awkward, sleeping until another mage check...")
			making_mage = 0
			mages_made--
			return
		else
			shuffle(candidates)
			for(var/mob/i in candidates)
				if(!i || !i.client) continue //Dont bother removing them from the list since we only grab one wizard

				theghost = i
				break

		if(theghost)
			var/mob/living/carbon/human/new_character= makeBody(theghost)
			new_character.mind.make_Wizard()
			making_mage = 0
			wizards += new_character
			return 1

/datum/game_mode/wizard/proc/makeBody(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	G_found.client.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	new_character.key = G_found.key

	return new_character

/datum/game_mode/wizard/declare_completion()
	if(finished)
		feedback_set_details("round_end_result","loss - wizard killed")
		world << "<span class='userdanger'>The wizard[(wizards.len>1)?"s":""] has been killed by the crew! The Space Wizards Federation has been taught a lesson they will not soon forget!</span>"
	..()
	return 1


/datum/game_mode/wizard/round_report()
	if(wizards.len)
		var/text = "<br><font size=3><b>the wizards/witches were:</b></font>"

		for(var/datum/mind/wizard in wizards)

			text += "<br><b>[wizard.key]</b> was <b>[wizard.name]</b> ("
			if(wizard.current)
				if(wizard.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(wizard.current.real_name != wizard.name)
					text += " as <b>[wizard.current.real_name]</b>"
			else
				text += "body destroyed"
			text += ")"

			var/count = 1
			var/wizardwin = 1
			for(var/datum/objective/objective in wizard.objectives)
				if(objective.check_completion())
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("wizard_objective","[objective.type]|SUCCESS")
				else
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("wizard_objective","[objective.type]|FAIL")
					wizardwin = 0
				count++

			if(wizard.current && wizard.current.stat!=2 && wizardwin)
				text += "<br><font color='green'><B>The wizard was successful!</B></font>"
				feedback_add_details("wizard_success","SUCCESS")
			else
				text += "<br><font color='red'><B>The wizard has failed!</B></font>"
				feedback_add_details("wizard_success","FAIL")
			if(wizard.spell_list.len>0)
				text += "<br><B>[wizard.name] used the following spells: </B>"
				var/i = 1
				for(var/obj/effect/proc_holder/spell/S in wizard.spell_list)
					text += "[S.name]"
					if(wizard.spell_list.len > i)
						text += ", "
					i++
			text += "<br>"

		world << text
	return 1

//OTHER PROCS

//To batch-remove wizard spells. Linked to mind.dm.
/mob/proc/spellremove(mob/M)
	if(!mind)
		return
	for(var/X in src.mind.spell_list)
		var/obj/effect/proc_holder/spell/spell_to_remove = X
		qdel(spell_to_remove)
		mind.spell_list -= spell_to_remove

/*Checks if the wizard can cast spells.
Made a proc so this is not repeated 14 (or more) times.*/
/mob/proc/casting()
//Removed the stat check because not all spells require clothing now.
	if(!istype(usr:wear_suit, /obj/item/clothing/suit/wizrobe))
		usr << "I don't feel strong enough without my robe."
		return 0
	if(!istype(usr:shoes, /obj/item/clothing/shoes/sandal))
		usr << "I don't feel strong enough without my sandals."
		return 0
	if(!istype(usr:head, /obj/item/clothing/head/wizard))
		usr << "I don't feel strong enough without my hat."
		return 0
	else
		return 1

//returns whether the mob is a wizard (or apprentice)
/proc/iswizard(mob/living/M)
	return istype(M) && M.mind && (M.mind.special_role == "Wizard")


/datum/game_mode/wizard/proc/update_wiz_icons_added(datum/mind/wiz_mind)
	var/datum/atom_hud/antag/wizhud = huds[ANTAG_HUD_WIZ]
	wizhud.join_hud(wiz_mind.current)
	set_antag_hud(wiz_mind.current, ((wiz_mind in wizards) ? "wizard" : "apprentice"))

/datum/game_mode/wizard/proc/update_wiz_icons_removed(datum/mind/wiz_mind)
	var/datum/atom_hud/antag/wizhud = huds[ANTAG_HUD_WIZ]
	wizhud.leave_hud(wiz_mind.current)
	set_antag_hud(wiz_mind.current, null)
