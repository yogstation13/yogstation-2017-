

//#define VOX_DEBUG

#ifdef VOX_DEBUG
#warn Warning: Vox raider debug text and abilities are enabled
#endif


/datum/game_mode
	var/list/datum/mind/raiders = list()
	var/list/raider_objectives = list()
	var/vox_geartick = 1


/datum/game_mode/voxheist
	name = "voxheist"
	config_tag = "voxheist"
	antag_flag = ROLE_VOX

	#ifdef VOX_DEBUG
	required_players = 1
	required_enemies = 1
	#else
	required_players = 30
	required_enemies = 4
	#endif

	recommended_enemies = 5
	enemy_minimum_age = 14

	var/max_raiders = 6
	var/returned_home = 0


/datum/game_mode/voxheist/announce()
	to_chat(world, "<b>The current game mode is - Vox Raiders!</b>")
	to_chat(world, "<b>An unidentified bluespace signature has slipped past the Icarus and is approaching [station_name()]!</b>")
	to_chat(world, "Whoever they are, they're likely up to no good. Protect the crew and station resources against this dastardly threat!")


/datum/game_mode/voxheist/pre_setup()
	var/n_raiders = min(max_raiders, max(required_enemies, round(num_players() / 10)))

	var/list/datum/mind/chosen_raiders = pick_candidate(amount = n_raiders)
	update_not_chosen_candidates()

	for(var/datum/mind/new_raider in chosen_raiders)
		raiders += new_raider
		new_raider.assigned_role = "Vox Raider"
		new_raider.special_role = "Vox Raider"

	if(raiders.len < required_enemies)
		return 0

	return 1


/datum/game_mode/voxheist/post_setup()
	var/spawnpos = 1
	var/list/turf/raider_spawn = list()
	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "Vox-Spawn")
			raider_spawn += get_turf(A)

	forge_vox_objectives()

	for(var/datum/mind/raider in raiders)
		log_game("[raider.key] (ckey) has been selected as a vox raider")

		if(spawnpos > raider_spawn.len)
			spawnpos = 1

		var/mob/living/carbon/human/L = raider.current
		L.loc = raider_spawn[spawnpos]

		greet_raider(L)
		equip_raider(L)
		raider.objectives = raider_objectives
		update_synd_icons_added(raider)	// Use the nuke ops antag hud for now

		spawnpos++


	return ..()


/datum/game_mode/proc/forge_vox_objectives()
	var/kidnaps_left = 2
	var/max_objectives = pick(2, 2, 2, 3, 3, 3, 3, 4, 4, 4)
	for(var/i in 1 to max_objectives)
		var/datum/objective/heist/O

		if(kidnaps_left && prob(40))	// 40% to get kidnap objective up to a maximum of 2
			kidnaps_left--
			O = new/datum/objective/heist/kidnap
		else
			if(prob(33))				// If it's steal objective, 33% for a hard one
				O = new/datum/objective/heist/steal/hard
			else						// 66% for an easy one
				O = new/datum/objective/heist/steal/easy

		raider_objectives += O

	raider_objectives += new/datum/objective/heist/inviolate_crew

	for(var/datum/objective/heist/O in raider_objectives)
		O.choose_target()



/datum/game_mode/proc/greet_raider(mob/M)
	if(!M)
		return 0

	var/greeting_text = "<b><span class='large_brass'>You are a Vox Raider!</span>\n\
	The Vox are a species of spacefaring birds that breath pure nitrogen.\n\
	The Shoal has hired you to steal or trade various items from the station\n\
	Your ship, the Skipjack, has been equipped for the job.\n\
	Use :x to speak in voxian and :t to talk on the syndicate channel.\n\
	<span class='danger'>The Shoal forbids excessive bloodletting. Minimize casualties or face banishment.</span></b>"
	to_chat(M, greeting_text)


	var/obj_count = 1
	for(var/datum/objective/objective in raider_objectives)
		to_chat(M, "<b>Objective #[obj_count++]</b>: [objective.explanation_text]")

	return 1


/datum/game_mode/proc/equip_raider(mob/living/carbon/human/L)
	if(!L || !istype(L))
		return 0

	L.set_species(/datum/species/vox)
	L.age = rand(12,20)
	L.fully_replace_character_name(L.real_name, vox_name())
	L.disabilities |= NOCLONE

	// This allows them to both speak and understand voxian and human
	// I was gonna make them only speak voxian but there's no other voxians on the station so it might be difficult to communicate
	// Handled in species_types.dm
	//L.languages_spoken = HUMAN|VOX
	//L.languages_understood = HUMAN|VOX


	//L.hair_style = "Short Vox Quills"		// broken
	L.facial_hair_style = "Shaved"
	L.underwear = "Nude"
	L.undershirt = "Nude"
	L.socks = "Nude"

	qdel(L.belt)
	qdel(L.back)
	qdel(L.ears)
	qdel(L.gloves)
	qdel(L.head)
	qdel(L.shoes)
	qdel(L.wear_id)
	qdel(L.wear_suit)
	qdel(L.w_uniform)

	switch(vox_geartick)
		if(1)
			L.equipOutfit(/datum/outfit/voxraider/raider)

		if(2)
			L.equipOutfit(/datum/outfit/voxraider/engineer)

		if(3)
			L.equipOutfit(/datum/outfit/voxraider/saboteur)

		if(4)
			L.equipOutfit(/datum/outfit/voxraider/medic)

	vox_geartick++
	L.update_body()


/datum/game_mode/voxheist/declare_completion()
	// no objectives, go straight to the feedback
	if(isnull(raider_objectives) || raider_objectives.len <= 0)
		return ..()

	var/win_type = "Major"
	var/win_group = "Crew"
	var/win_msg = ""
	var/completion_text = ""

	var/success = raider_objectives.len

	//Decrease success for failed objectives.
	for(var/datum/objective/O in raider_objectives)
		if(!(O.check_completion()))
			success--

	//Set result by objectives.
	var/obj_count = raider_objectives.len
	if(success == obj_count)					// If they completed all objectives, they are good birdos
		win_type = "Major"
		win_group = "Vox"
	else if(success > round(obj_count / 2))		// Since the objective count is random, minor victory is half objectives completed
		win_type = "Minor"
		win_group = "Vox"
	else										// Any less and they are bad
		win_type = "Minor"
		win_group = "Crew"

	//Now we modify that result by the state of the vox crew
	if(!is_raider_crew_alive())					// They all got wiped
		win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have been wiped out!</B>"
	else if(!is_raider_crew_safe())				// They left one of their comrades behind
		if(win_group == "Crew" && win_type == "Minor")
			win_type = "Major"

		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have left someone behind!</B>"
	else
		if(win_group == "Vox")
			if(win_type == "Minor")
				win_msg += "<B>The Vox Raiders escaped the station early!</B>"
			else
				win_msg += "<B>The Vox Raiders escaped the station!</B>"
		else
			win_msg += "<B>The Vox Raiders were repelled!</B>"

	completion_text += "<br><span class='danger'><FONT size = 3>[win_type] [win_group] victory!</FONT><br>[win_msg]</span>"

	feedback_set_details("round_end_result","heist - [win_type] [win_group]")

	var/count = 0
	for(var/datum/objective/objective in raider_objectives)
		count++

		if(objective.check_completion())
			completion_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
			feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
		else
			completion_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
			feedback_add_details("traitor_objective","[objective.type]|FAIL")

	var/text = "<br><br><FONT size = 2><B>The vox raiders were:</B></FONT>"
	var/end_area = get_area_master(locate(/area/shuttle/vox_shuttle))

	for(var/datum/mind/vox in raiders)
		text += "<br><b>[vox.key]</b> was <b>[vox.name]</b> the <b>[vox.assigned_role]</b> and"
		if(vox.current)
			if(vox.current.stat != DEAD)
				text += " <span class='greenannounce'>survived</span>"
			else
				text += " <span class='boldannounce'>died</span>"

			if(get_area_master(vox.current) != end_area) // areaMaster var can be used on this if move_contents_to proc refactored to use Move()
				text += " while being <span class='boldannounce'>left behind</span>"

			if(vox.current.real_name != vox.name)
				text += " as <b>[vox.current.real_name]</b>"
		else
			text += " <span class='boldannounce'>had their body destroyed</span>"

	completion_text += text
	to_chat(world, completion_text)

	..()
	return 1


/datum/game_mode/voxheist/proc/is_raider_crew_safe()
	if(!is_raider_crew_alive())
		return FALSE

	var/end_area = get_area_master(locate(/area/shuttle/vox_shuttle))

	for(var/datum/mind/raider in raiders)
		if(get_area_master(raider.current) != end_area)
			return 0

	return 1


/datum/game_mode/voxheist/proc/is_raider_crew_alive()
	var/raider_crew_count = raiders.len

	for(var/datum/mind/raider in raiders)
		if(raider && ishuman(raider.current) && raider.current.stat != DEAD)
			continue

		raider_crew_count--


	if(raider_crew_count <= 0)
		return 0

	return 1


/datum/game_mode/voxheist/check_finished()
	if(!is_raider_crew_alive() || returned_home)
		return 1

	return ..()