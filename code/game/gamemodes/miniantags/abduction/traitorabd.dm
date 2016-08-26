/datum/game_mode/traitor/traitorabd
	name = "traitor+abductor"
	config_tag = "traitorabd"
	antag_flag = ROLE_ABDUCTOR
	recommended_enemies = 1
	required_players = 1
	var/max_teams = 4
	abductor_teams = 1
	var/list/datum/mind/scientists = list()
	var/list/datum/mind/agents = list()
	var/list/datum/objective/team_objectives = list()
	var/list/team_names = list()
	var/finished = 0
	traitors_possible = 3


/datum/game_mode/traitor/traitorabd/announce()
	world << "<B>The current game mode is - Traitor + Abduction!</B>"
	world << "There are alien creatures on the station along with some syndicate operatives out for their own gain! Do not let the abductors or the traitors succeed!"

/datum/game_mode/traitor/traitorabd/pre_setup()
	if(!..())
 //message_admins("<B>Not enough traitor candidates to start Traitor+Abductor.</B>")
		return 0

	abductor_teams = max(1, min(max_teams,round(num_players()/config.abductor_scaling_coeff)))
	var/possible_teams = max(1,round(antag_candidates.len / 2))
	abductor_teams = min(abductor_teams,possible_teams)

	abductors.len = 2*abductor_teams
	scientists.len = abductor_teams
	agents.len = abductor_teams
	team_objectives.len = abductor_teams
	team_names.len = abductor_teams

	for(var/i=1,i<=abductor_teams,i++)
		if(!make_abductor_team(i))
			return 0
	return 1

/datum/game_mode/traitor/traitorabd/proc/make_abductor_team(team_number,preset_agent=null,preset_scientist=null)
	//Team Name
	team_names[team_number] = "Mothership [pick(possible_changeling_IDs)]" //TODO Ensure unique and actual alieny names
	//Team Objective
	var/datum/objective/experiment/team_objective = new
	team_objective.team = team_number
	team_objectives[team_number] = team_objective
	//Team Members

	if(!preset_agent || !preset_scientist)
		if(antag_candidates.len <2)
			return 0

	var/datum/mind/scientist
	var/datum/mind/agent

	if(!preset_scientist)
		scientist = pick_candidate(amount=1)[1]
	else
		scientist = preset_scientist

	if(!preset_agent)
		agent = pick_candidate(amount=1)[1]
	else
		agent = preset_agent


	scientist.assigned_role = "abductor scientist"
	scientist.special_role = "abductor scientist"
	log_game("[scientist.key] (ckey) has been selected as an abductor team [team_number] scientist.")

	agent.assigned_role = "abductor agent"
	agent.special_role = "abductor agent"
	log_game("[agent.key] (ckey) has been selected as an abductor team [team_number] agent.")

	abductors |= agent
	abductors |= scientist
	scientists[team_number] = scientist
	agents[team_number] = agent
	return 1

/datum/game_mode/traitor/traitorabd/post_setup()
	//Spawn Team
	var/list/obj/effect/landmark/abductor/agent_landmarks = new
	var/list/obj/effect/landmark/abductor/scientist_landmarks = new
	agent_landmarks.len = max_teams
	scientist_landmarks.len = max_teams
	for(var/obj/effect/landmark/abductor/A in landmarks_list)
		if(istype(A,/obj/effect/landmark/abductor/agent))
			agent_landmarks[text2num(A.team)] = A
		else if(istype(A,/obj/effect/landmark/abductor/scientist))
			scientist_landmarks[text2num(A.team)] = A

	var/datum/mind/agent
	var/obj/effect/landmark/L
	var/datum/mind/scientist
	var/team_name
	var/mob/living/carbon/human/H
	var/datum/species/abductor/S
	for(var/team_number=1,team_number<=abductor_teams,team_number++)
		team_name = team_names[team_number]
		agent = agents[team_number]
		H = agent.current
		L = agent_landmarks[team_number]
		H.loc = L.loc
		H.set_species(/datum/species/abductor)
		S = H.dna.species
		S.agent = 1
		S.team = team_number
		H.real_name = team_name + " Agent"
		equip_common(H,team_number)
		equip_agent(H,team_number)
		greet_agent(agent,team_number)

		scientist = scientists[team_number]
		H = scientist.current
		L = scientist_landmarks[team_number]
		H.loc = L.loc
		H.set_species(/datum/species/abductor)
		S = H.dna.species
		S.scientist = 1
		S.team = team_number
		H.real_name = team_name + " Scientist"
		equip_common(H,team_number)
		equip_scientist(H,team_number)
		greet_scientist(scientist,team_number)
	return ..()

//Used for create antag buttons
/datum/game_mode/traitor/traitorabd/proc/post_setup_team(team_number)
	var/list/obj/effect/landmark/abductor/agent_landmarks = new
	var/list/obj/effect/landmark/abductor/scientist_landmarks = new
	agent_landmarks.len = max_teams
	scientist_landmarks.len = max_teams
	for(var/obj/effect/landmark/abductor/A in landmarks_list)
		if(istype(A,/obj/effect/landmark/abductor/agent))
			agent_landmarks[text2num(A.team)] = A
		else if(istype(A,/obj/effect/landmark/abductor/scientist))
			scientist_landmarks[text2num(A.team)] = A

	var/datum/mind/agent
	var/obj/effect/landmark/L
	var/datum/mind/scientist
	var/team_name
	var/mob/living/carbon/human/H
	var/datum/species/abductor/S

	team_name = team_names[team_number]
	agent = agents[team_number]
	H = agent.current
	L = agent_landmarks[team_number]
	H.loc = L.loc
	H.set_species(/datum/species/abductor)
	S = H.dna.species
	S.agent = 1
	S.team = team_number
	H.real_name = team_name + " Agent"
	equip_common(H,team_number)
	equip_agent(H,team_number)
	greet_agent(agent,team_number)


	scientist = scientists[team_number]
	H = scientist.current
	L = scientist_landmarks[team_number]
	H.loc = L.loc
	H.set_species(/datum/species/abductor)
	S = H.dna.species
	S.scientist = 1
	S.team = team_number
	H.real_name = team_name + " Scientist"
	equip_common(H,team_number)
	equip_scientist(H,team_number)
	greet_scientist(scientist,team_number)



/datum/game_mode/traitor/traitorabd/proc/greet_agent(datum/mind/abductor,team_number)
	abductor.objectives += team_objectives[team_number]
	var/team_name = team_names[team_number]

	abductor.current << "<span class='notice'>You are an agent of [team_name]!</span>"
	abductor.current << "<span class='notice'>With the help of your teammate, kidnap and experiment on station crew members!</span>"
	abductor.current << "<span class='notice'>Use your stealth technology and equipment to incapacitate humans for your scientist to retrieve.</span>"

	var/obj_count = 1
	for(var/datum/objective/objective in abductor.objectives)
		abductor.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/traitor/traitorabd/proc/greet_scientist(datum/mind/abductor,team_number)
	abductor.objectives += team_objectives[team_number]
	var/team_name = team_names[team_number]

	abductor.current << "<span class='notice'>You are a scientist of [team_name]!</span>"
	abductor.current << "<span class='notice'>With the help of your teammate, kidnap and experiment on station crew members!</span>"
	abductor.current << "<span class='notice'>Use your tool and ship consoles to support the agent and retrieve human specimens.</span>"

	var/obj_count = 1
	for(var/datum/objective/objective in abductor.objectives)
		abductor.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/traitor/traitorabd/proc/equip_common(mob/living/carbon/human/agent,team_number)
	var/radio_freq = SYND_FREQ

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt/abductor(agent)
	R.set_frequency(radio_freq)
	agent.equip_to_slot_or_del(R, slot_ears)
	agent.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(agent), slot_shoes)
	agent.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(agent), slot_w_uniform) //they're greys gettit
	agent.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(agent), slot_back)

/datum/game_mode/traitor/traitorabd/proc/get_team_console(team)
	var/obj/machinery/abductor/console/console
	for(var/obj/machinery/abductor/console/c in machines)
		if(c.team == team)
			console = c
			break
	return console

/datum/game_mode/traitor/traitorabd/proc/equip_agent(mob/living/carbon/human/agent,team_number)
	if(!team_number)
		var/datum/species/abductor/S = agent.dna.species
		team_number = S.team

	var/obj/machinery/abductor/console/console = get_team_console(team_number)
	var/obj/item/clothing/suit/armor/abductor/vest/V = new /obj/item/clothing/suit/armor/abductor/vest(agent)
	if(console!=null)
		console.vest = V
		V.flags |= NODROP
	agent.equip_to_slot_or_del(V, slot_wear_suit)
	agent.equip_to_slot_or_del(new /obj/item/weapon/abductor_baton(agent), slot_belt)
	agent.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/alien(agent), slot_in_backpack)
	agent.equip_to_slot_or_del(new /obj/item/device/abductor/silencer(agent), slot_in_backpack)
	agent.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/abductor(agent), slot_head)
	agent.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate/abductor(agent), slot_wear_id)


/datum/game_mode/traitor/traitorabd/proc/equip_scientist(var/mob/living/carbon/human/scientist,var/team_number)
	if(!team_number)
		var/datum/species/abductor/S = scientist.dna.species
		team_number = S.team

	var/obj/machinery/abductor/console/console = get_team_console(team_number)
	var/obj/item/device/abductor/gizmo/G = new /obj/item/device/abductor/gizmo(scientist)
	if(console!=null)
		console.gizmo = G
		G.console = console
	scientist.equip_to_slot_or_del(G, slot_in_backpack)

	var/obj/item/weapon/implant/abductor/beamplant = new /obj/item/weapon/implant/abductor(scientist)
	beamplant.implant(scientist)


/datum/game_mode/traitor/traitorabd/check_finished()
	if(!finished)
		for(var/team_number=1,team_number<=abductor_teams,team_number++)
			var/obj/machinery/abductor/console/con = get_team_console(team_number)
			var/datum/objective/objective = team_objectives[team_number]
			if (con.experiment.points >= objective.target_amount)
				SSshuttle.emergency.request(null, 0.5)
				finished = 1
				return ..()
	return ..()

/datum/game_mode/traitor/traitorabd/declare_completion()
	for(var/team_number=1,team_number<=abductor_teams,team_number++)
		var/obj/machinery/abductor/console/console = get_team_console(team_number)
		var/datum/objective/objective = team_objectives[team_number]
		var/team_name = team_names[team_number]
		if(console.experiment.points >= objective.target_amount)
			world << "<span class='greenannounce'>[team_name] team fullfilled its mission!</span>"
		else
			world << "<span class='boldannounce'>[team_name] team failed its mission.</span>"
	..()
	return 1

/datum/game_mode/proc/auto_declare_completion_traitorabd()
	var/text = ""
	if(abductors.len)
		text += "<br><span class='big'><b>The abductors were:</b></span>"
		for(var/datum/mind/abductor_mind in abductors)
			text += printplayer(abductor_mind)
			text += printobjectives(abductor_mind)
		text += "<br>"
		if(abductees.len)
			text += "<br><span class='big'><b>The abductees were:</b></span>"
			for(var/datum/mind/abductee_mind in abductees)
				text += printplayer(abductee_mind)
				text += printobjectives(abductee_mind)
	text += "<br>"
	world << text

