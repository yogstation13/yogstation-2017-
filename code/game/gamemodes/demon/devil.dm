//DEVIL MODE
//Now with an actual game_mode datum instead of a hacky approximation

/datum/game_mode/devil
	name = "demonic invasion"
	config_tag = "devil"
	antag_flag = ROLE_TRAITOR
	restricted_jobs = list("AI", "Cyborg", "Chief Engineer", "Research Director", "Chief Medical Officer")
	required_players = 20
	required_enemies = 1
	recommended_enemies = 3
	enemy_minimum_age = 14
	prob_traitor_ai = 18

	var/list/datum/mind/sintouched = list()
	var/list/datum/mind/devils = list()
	//At the time of this writing, the only place the below is written to is in demoninfo.dm in the proc /datum/devilinfo/proc/increase_arch_devil()
	var/devil_ascended = 0 // Number of arch devils on station

/datum/game_mode/devil/announce()
	world << "<B>The current game mode is - Demonic Invasion!</B>"
	world << "<B>Several demons are lurking on the station in disguise!<BR>Demons -  Ascend by purchasing the crew's souls! <BR>Crew - Learn the demon's true name, and banish them!</B>"

/datum/game_mode/devil/pre_setup(datum/game/G, list/a)
	args = a

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	var/demons_to_create = recommended_enemies
	devils = G.prepare_candidates(antag_flag, demons_to_create)

/datum/game_mode/devil/post_setup()
	for(var/datum/mind/devil in devils)
		finalize_devil(devil)

/datum/game_mode/devil/proc/finalize_devil(datum/mind/devil_mind)
	devil_mind.special_role = "devil"

	var/mob/living/carbon/human/S = devil_mind.current
	var/trueName= randomDevilName()
	var/datum/objective/devil/soulquantity/soulquant = new
	soulquant.owner = devil_mind
	var/datum/objective/devil/obj_2 = pick(new /datum/objective/devil/soulquality(null), new /datum/objective/devil/sintouch(null))
	obj_2.owner = devil_mind
	devil_mind.objectives += obj_2
	devil_mind.objectives += soulquant
	devil_mind.devilinfo = devilInfo(trueName, 1)
	devil_mind.store_memory("Your devilic true name is [devil_mind.devilinfo.truename]<br>[lawlorify[LAW][devil_mind.devilinfo.ban]]<br>[lawlorify[LAW][devil_mind.devilinfo.bane]]<br>[lawlorify[LAW][devil_mind.devilinfo.obligation]]<br>[lawlorify[LAW][devil_mind.devilinfo.banish]]<br>")
	devil_mind.devilinfo.owner = devil_mind
	devil_mind.devilinfo.give_base_spells(1)
	spawn(10)
		if(devil_mind.assigned_role == "Clown")
			S << "<span class='notice'>Your infernal nature has allowed you to overcome your clownishness.</span>"
			S.dna.remove_mutation(CLOWNMUT)

/datum/game_mode/devil/declare_completion()
	if(devils.len)
		if(devil_ascended) //At least one
			world << "<span class='redtext'>[devil_ascended > 1 ? "Multiple devils" : "A devil"] managed to ascend!  [devils.len > 1 ? "Devils win!" : "The devil wins!"]</span>"
			feedback_set_details("round_end_result","win - devil(s) ascended")
		else
			world << "<span class='greentext'>The devil[devils.len > 1 ? "s" : ""] failed to ascend!  The crew wins!</span>"
			feedback_set_details("round_end_result","loss - devil(s) did not ascend")

/datum/game_mode/devil/round_report()
	var/text = ""
	text += "<br><span class='big'><b>The devils were:</b></span>"
	for(var/D in devils)
		var/datum/mind/devil = D
		text += printplayer(devil)
		text += printdevilinfo(devil)
		text += printobjectives(devil)
	text += "<br>"
	if(sintouched.len)
		text += "<br><span class='big'><b>The sintouched were:</b></span>"
		var/list/sintouchedUnique = uniqueList(sintouched)
		for(var/S in sintouchedUnique)
			var/datum/mind/sintouched_mind = S
			text += printplayer(sintouched_mind)
			text += printobjectives(sintouched_mind)
		text += "<br>"
	text += "<br>"
	world << text

//Utilities

/datum/game_mode/devil/proc/printdevilinfo(datum/mind/ply)
	if(!ply.devilinfo)
		return ""
	var/text = "</br>The devil's true name is: [ply.devilinfo.truename]</br>"
	text += "The devil's bans were:</br>"
	text += "	[lawlorify[LORE][ply.devilinfo.ban]]</br>"
	text += "	[lawlorify[LORE][ply.devilinfo.bane]]</br>"
	text += "	[lawlorify[LORE][ply.devilinfo.obligation]]</br>"
	text += "	[lawlorify[LORE][ply.devilinfo.banish]]</br>"
	return text

/datum/mind/proc/announceDevilLaws()
	if(!devilinfo)
		return
	current << "<span class='warning'><b>You remember your link to the infernal.  You are [src.devilinfo.truename], an agent of hell, a devil.  And you were sent to the plane of creation for a reason.  A greater purpose.  Convince the crew to sin, and embroiden Hell's grasp.</b></span>"
	current << "<span class='warning'><b>However, your infernal form is not without weaknesses.</b></span>"
	current << lawlorify[LAW][src.devilinfo.bane]
	current << lawlorify[LAW][src.devilinfo.ban]
	current << lawlorify[LAW][src.devilinfo.obligation]
	current << lawlorify[LAW][src.devilinfo.banish]
	current << "<br/><br/> <span class='warning'>Remember, the crew can research your weaknesses if they find out your devil name.</span><br>"
	var/obj_count = 1
	current << "<span class='notice'>Your current objectives:</span>"
	for(var/O in objectives)
		var/datum/objective/objective = O
		current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++

/datum/game_mode/proc/update_devil_icons_added(datum/mind/devil_mind)
	var/datum/atom_hud/antag/hud = huds[ANTAG_HUD_DEVIL]
	hud.join_hud(devil_mind.current)
	set_antag_hud(devil_mind.current, "devil")

/datum/game_mode/proc/update_devil_icons_removed(datum/mind/devil_mind)
	var/datum/atom_hud/antag/hud = huds[ANTAG_HUD_DEVIL]
	hud.leave_hud(devil_mind.current)
	set_antag_hud(devil_mind.current, null)

/datum/game_mode/proc/update_sintouch_icons_added(datum/mind/sin_mind)
	var/datum/atom_hud/antag/hud = huds[ANTAG_HUD_SINTOUCHED]
	hud.join_hud(sin_mind.current)
	set_antag_hud(sin_mind.current, "sintouched")

/datum/game_mode/proc/update_sintouch_icons_removed(datum/mind/sin_mind)
	var/datum/atom_hud/antag/hud = huds[ANTAG_HUD_SINTOUCHED]
	hud.leave_hud(sin_mind.current)
	set_antag_hud(sin_mind.current, null)

/datum/game_mode/proc/update_soulless_icons_added(datum/mind/soulless_mind)
	var/datum/atom_hud/antag/hud = huds[ANTAG_HUD_SOULLESS]
	hud.join_hud(soulless_mind.current)
	set_antag_hud(soulless_mind.current, "soulless")

/datum/game_mode/proc/update_soulless_icons_removed(datum/mind/soulless_mind)
	var/datum/atom_hud/antag/hud = huds[ANTAG_HUD_SOULLESS]
	hud.leave_hud(soulless_mind.current)
	set_antag_hud(soulless_mind.current, null)