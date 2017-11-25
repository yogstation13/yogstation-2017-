/datum/cyberman_network
	var/list/cybermen_analyze_targets = list("the captain's antique laser gun" = /obj/item/weapon/gun/energy/laser/captain, //stolen from objective_items.dm. Could just use the objective datums instead.
								"the head of security's personal laser gun" = /obj/item/weapon/gun/energy/gun/hos,
								"a hand teleporter" = /obj/item/weapon/hand_tele,
								"the chief engineer's advanced magnetic boots" = /obj/item/clothing/shoes/magboots/advance,
								"the hypospray" = /obj/item/weapon/reagent_containers/hypospray/CMO,
								"the nuclear authentication disk" = /obj/item/weapon/disk/nuclear, //lucky if you also get the "nuke station" objective
								"a pinpointer" = /obj/item/weapon/pinpointer, //also lucky, but less so.
								"an ablative armor vest" = /obj/item/clothing/suit/armor/laserproof,
								"the ion rifle" = /obj/item/weapon/gun/energy/ionrifle,//because irony (ion-ry)
								"the reactive teleport armor" = /obj/item/clothing/suit/armor/reactive,
								"the station blueprints" = /obj/item/areaeditor/blueprints)

	var/list/cybermen_hack_targets = list("a communications console" = /obj/machinery/computer/communications,
							"an APC" = /obj/machinery/power/apc,
							"an air alarm" = /obj/machinery/airalarm,
							"an identification console" = /obj/machinery/computer/card,
							"the station's RnD server" = /obj/machinery/r_n_d/server,//might already be hacked due to a previous objective
							"a telecomminications hub" = /obj/machinery/telecomms/hub,//hopefully these haven't all been deconstructed yet
							"a microwave" = /obj/machinery/microwave,
							// /mob/living/silicon/robot/ = "a cyborg"//needs a check in is_valid(). Removed because of overlap with hacking the AI
							)


/datum/objective/cybermen
	var/name = "Unnamed Objective"
	var/phase
	var/win_upon_completion = 0
	explanation_text = "Nothing"
	dangerrating = 10 //seems like a good number

/datum/objective/cybermen/proc/is_valid()//ensure the objective is completeable.
	return 1

/datum/objective/cybermen/proc/make_valid()//some objectives can be made valid by reducing the number or changing the targets - this method should warn cybermen and return 1 if it succeeds.
	return 0

/datum/objective/cybermen/proc/admin_create_objective(mob/user = usr)
	return

/datum/objective/cybermen/check_completion()
	return ..()

//////////////////////////////
//////////EXPLORE/////////////
//////////////////////////////
/datum/objective/cybermen/explore
	phase = "Explore"

//GET RESEARCH LEVELS
/datum/objective/cybermen/explore/get_research_levels
	name = "Download Research Levels"
	var/target_research_levels

/datum/objective/cybermen/explore/get_research_levels/New()
	..()
	target_research_levels = rand(8, 10)
	check_completion()//updates explanation_text.

/datum/objective/cybermen/explore/get_research_levels/check_completion()//yes, I copy-pasted from ninjacode.
	if(..())
		return 1
	var/current_amount = 0
	for(var/datum/tech/current_data in cyberman_network.cybermen_research_downloaded)
		if(current_data.level)
			current_amount += (current_data.level-1)//can't let that level 1 junk give us points
	explanation_text = "Download [target_research_levels] research level\s by hacking the station's RnD server, the server controller, or technology disks. So far [current_amount] research levels have been downloaded."
	return current_amount >= target_research_levels

/datum/objective/cybermen/explore/get_research_levels/admin_create_objective(mob/user = usr)
	if(alert("Set number of research levels?", user, "Set", "Random") == "Random")
		return
	var/num = input("Select number of research levels required:", user, 0) as num
	target_research_levels = num
	check_completion()//updates explanation_text.

//GET SECRET DOCUMENTS
/datum/objective/cybermen/explore/get_secret_documents//how can you hack pieces of paper? Nanomachines or something.
	name = "Analyze Secret Documents"
	explanation_text = "Aquire the NT secret documents located in the vault, and upload them to the cybermen network by hacking them."

/datum/objective/cybermen/explore/get_secret_documents/check_completion()
	if(..())
		return 1
	for(var/obj/item/documents/secret/nanotrasen/D in cyberman_network.cybermen_hacked_objects)
		return 1
	return 0

//GET ACCESS
/datum/objective/cybermen/explore/get_access
	name = "Download Access"
	explanation_text = "Aquire an ID with Captain-level access upload it to the cybermen network by hacking it."
	var/required_access = access_captain

/datum/objective/cybermen/explore/get_access/check_completion()
	if(..())
		return 1
	return (required_access in cyberman_network.cybermen_access_downloaded)

/datum/objective/cybermen/explore/get_access/admin_create_objective(mob/user = usr)
	if(alert("Required access?", user, "Captain", "Custom") == "Captain")
		return
	var/list/L = list()
	for(var/V in get_all_accesses())
		L[get_access_desc(V)] = V
	var/access_name = input("Set custom required access:", user, 0) as anything in L
	required_access = L[access_name]
	explanation_text = "Aquire an ID with [get_access_desc(required_access)]-level access upload it to the cybermen network by hacking it."

//////////////////////////////
//////////EXPAND//////////////
//////////////////////////////
/datum/objective/cybermen/expand
	phase = "Expand"

//RECRUIT CYBERMEN
/datum/objective/cybermen/expand/convert_crewmembers
	name = "Recruit Cybermen"
	var/target_cybermen_num

/datum/objective/cybermen/expand/convert_crewmembers/New()
	..()
	target_cybermen_num = rand(6, 8)
	check_completion()//updates explanation_text.


/datum/objective/cybermen/expand/convert_crewmembers/is_valid()
	var/humans_on_station = 0
	for(var/mob/living/carbon/human/survivor in living_mob_list)
		if(survivor.loc.z == ZLEVEL_STATION && survivor.key)
			humans_on_station++
	return target_cybermen_num <= humans_on_station

/datum/objective/cybermen/expand/convert_crewmembers/make_valid()
	var/humans_on_station = 0
	for(var/mob/living/carbon/human/survivor in living_mob_list)
		if(survivor.loc.z == ZLEVEL_STATION && survivor.key)
			humans_on_station++
	#ifdef CYBERMEN_DEBUG
	to_chat(world, "Humans on station: [humans_on_station]")
	#endif
	if(humans_on_station > 3)//needs a somewhat sane lower limit
		target_cybermen_num = min(target_cybermen_num, humans_on_station)
		cyberman_network.message_all_cybermen("<span class='notice'>Too few humans detected aboard the station. Number of required cybermen reduced to [target_cybermen_num].</span>")
		check_completion()//updates explanation_text.
		return 1
	else
		return 0

/datum/objective/cybermen/expand/convert_crewmembers/check_completion()
	if(..())
		return 1
	var/living_cybermen = 0
	for(var/datum/mind/M in cyberman_network.cybermen)
		if(M.current && !(M.current.stat & DEAD))
			living_cybermen++
	explanation_text = "Convert crewmembers until there are [target_cybermen_num] living cybermen on the station. There are currently [living_cybermen] living cybermen on the station."
	return living_cybermen >= target_cybermen_num

/datum/objective/cybermen/expand/convert_crewmembers/admin_create_objective(mob/user = usr)
	if(alert("Set number of required cybermen?", user, "Set", "Random") == "Random")
		return
	var/num = input("Select number of cybermen required:", user, 0) as num
	target_cybermen_num = num
	check_completion()//updates explanation_text.

//HACK AI
/datum/objective/cybermen/expand/hack_ai
	name = "Hack AI"
	var/mob/living/silicon/ai/targetAI

/datum/objective/cybermen/expand/hack_ai/New()
	..()
	for(var/V in ai_list)
		var/mob/living/silicon/ai/new_ai = V
		if(new_ai && new_ai.key)
			targetAI = new_ai
			explanation_text = "Hack [targetAI.name], the AI. This can be done through the AI core, an intellicard holding the AI, or an AI law upload console set to the AI."
			break

/datum/objective/cybermen/expand/hack_ai/is_valid()
	return targetAI && targetAI.key

/datum/objective/cybermen/expand/hack_ai/make_valid()
	targetAI = null
	for(var/V in ai_list)
		var/mob/living/silicon/ai/new_ai = V
		if(new_ai && new_ai.key)
			targetAI = new_ai
			explanation_text = "Hack [targetAI.name], the AI. This can be done through the AI core, an intellicard holding the AI, or an AI law upload console set to the AI."
			cyberman_network.message_all_cybermen("Cybermen AI hack target changed. New AI hack target is [targetAI.name].")
			return 1
	return 0

/datum/objective/cybermen/expand/hack_ai/check_completion()
	if(..())
		return 1
	return targetAI in cyberman_network.cybermen_hacked_objects

/datum/objective/cybermen/expand/hack_ai/admin_create_objective(mob/user = usr)
	if(alert("Select required AI?", user, "Select", "Random") == "Random")
		return
	var/list/L = list()
	for(var/V in ai_list)
		var/mob/living/silicon/ai/AI = V
		L[AI.name] = AI
	if(!L.len)
		alert("No AI candidates", user)
		return
	var/ai_name = input("Set custom AI:", user, 0) as anything in L
	if(!ai_name)
		return
	var/the_ai = L[ai_name]
	if(the_ai)
		targetAI = the_ai
		explanation_text = "Hack [targetAI.name], the AI. This can be done through the AI core, an intellicard holding the AI, or an AI law upload console set to the AI."

//CONVERT HEADS
/datum/objective/cybermen/expand/convert_heads
	name = "Infiltrate Command Staff"
	var/target_heads_num

/datum/objective/cybermen/expand/convert_heads/New()
	..()
	target_heads_num = pick(2, 3)
	check_completion()//updates explanation_text.

/datum/objective/cybermen/expand/convert_heads/is_valid()
	return 1//could check how many heads there are, but cybermen could just get head IDs, so no real need to.

/datum/objective/cybermen/expand/convert_heads/check_completion()
	if(..())
		return 1
	var/list/candidates = list()
	for(var/datum/data/record/t in data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		if(rank in command_positions)
			for(var/datum/mind/M in cyberman_network.cybermen)
				if(M.current.real_name == name)//possible issues with duplicate names
					candidates += "\n[M.current.real_name] is the [rank]"
					break
	explanation_text = "Place [target_heads_num] cybermen into command positions, either by having a cyberman promoted or converting a current head."
	if(candidates.len)
		explanation_text += " Currently, the following heads are cybermen:"
		for(var/candidate in candidates)
			explanation_text += candidate
	else
		explanation_text += " No heads are currently cybermen."
	return candidates.len >= target_heads_num

/datum/objective/cybermen/expand/convert_heads/admin_create_objective(mob/user = usr)
	if(alert("Set number of required heads?", user, "Set", "Random") == "Random")
		return
	var/num = input("Select number of heads required:", user, 0) as num
	target_heads_num = num
	check_completion()//updates explanation_text.

//////////////////////////////
//////////EXPLOIT/////////////
//////////////////////////////
/datum/objective/cybermen/exploit
	phase = "Exploit"

//ANALYZE AND HACK SOME RANDOM THINGS
/datum/objective/cybermen/exploit/analyze_and_hack
	name = "Analyze and Hack"
	var/list/targets = list()//these two lists must remain in synch.
	var/descriptions = list()
	var/num_analyze_targets = 2//change explanation_text if you change either of these
	var/num_hack_targets = 1

/datum/objective/cybermen/exploit/analyze_and_hack/New()
	..()
	var/list/analyze_target_candidates = cyberman_network.cybermen_analyze_targets.Copy()
	var/list/hack_target_candidates = cyberman_network.cybermen_hack_targets.Copy()
	var/remaining = num_analyze_targets
	while(remaining)
		var/candidate = pick(analyze_target_candidates)
		#ifdef CYBERMEN_DEBUG
		to_chat(world, "Analysis Candidates:")
		for(var/curcandidate in analyze_target_candidates)
			to_chat(world, "  [curcandidate]")
		to_chat(world, "Selected: [candidate]")
		#endif
		if(candidate)
			descriptions += candidate
			targets += analyze_target_candidates[candidate]
			analyze_target_candidates -= candidate
		remaining--
	remaining = num_hack_targets
	while(remaining)
		var/candidate = pick(hack_target_candidates)
		if(candidate)
			descriptions += candidate
			targets += hack_target_candidates[candidate]
			hack_target_candidates -= hack_target_candidates[candidate]
		remaining--
	check_completion()//takes care of explanation text.
	#ifdef CYBERMEN_DEBUG
	to_chat(world, "Targets:")
	for(var/cur in targets)
		to_chat(world, "  [cur]")
	#endif

/datum/objective/cybermen/exploit/analyze_and_hack/is_valid()
	//everything on the analyze list is a high-risk item, so we'll assume they haven't been spaced or destroyed.
	//everything on the hack list is constructable, even the cyborg, so we'll call it valid even if they don't exist at the moment.
	return 1

/datum/objective/cybermen/exploit/analyze_and_hack/make_valid()
	return 1

/datum/objective/cybermen/exploit/analyze_and_hack/check_completion()
	if(..())
		return 1
	var/list/targets_copy = targets.Copy()
	var/list/done_indicators = list()
	for(var/current2 in targets_copy)
		var/done_indicator = "(<font color='red'>Not Completed</font>)"
		for(var/current in cyberman_network.cybermen_hacked_objects)
			if(!current)
				continue
			if(istype(current, current2))
				targets_copy -= current2
				done_indicator = "(<font color='green'>Completed</font>)"
				break
		done_indicators += done_indicator

	explanation_text = "Obtain and analyze [descriptions[1]][done_indicators[1]] and [descriptions[2]][done_indicators[2]], and hack [descriptions[3]][done_indicators[3]]."
	return targets_copy.len == 0

/datum/objective/cybermen/exploit/analyze_and_hack/admin_create_objective(mob/user = usr)
	if(alert("Select Analyze and Hack targets?", user, "Select", "Random") == "Random")
		return
	descriptions = list()
	targets = list()
	for(var/i=0;i<num_analyze_targets;i++)
		var/target_name = input("Select analysis target [i+1]:", user) as anything in cyberman_network.cybermen_analyze_targets
		descriptions += target_name
		targets += cyberman_network.cybermen_analyze_targets[target_name]
	for(var/i=0;i<num_hack_targets;i++)
		var/target_name = input("Select hack target [i+1]:", user) as anything in cyberman_network.cybermen_hack_targets
		descriptions += target_name
		targets += cyberman_network.cybermen_hack_targets[target_name]
	check_completion()//takes care of explanation text.

/*
//ANALYZE SOME RANDOM THINGS
//commented out for now because analyze and hack is essentially the same thing.
//maybe you could load some materials on the supply shuttle and hack the supply console, sending them to some cyberman HQ?
/datum/objective/cybermen/exploit/analyze_materials

/datum/objective/cybermen/exploit/analyze_materials/New()
	//generate dem lists
	explanation_text = "Obtain and analyze "

/datum/objective/cybermen/exploit/analyze_materials/check_completion()
	//???
	..()
*/

//////////////////////////////
/////////EXTERMINATE//////////
//////////////////////////////
/datum/objective/cybermen/exterminate
	phase = "Exterminate"
	win_upon_completion = 1

/datum/objective/cybermen/exterminate/is_valid()
	return 1//probably should not touch this becuase it is a game-ending objective. Don't ever want it to change.

/datum/objective/cybermen/exterminate/make_valid()
	return 1//probably should not touch this becuase it is a game-ending objective. Don't ever want it to change.


//GET DAT FUKKIN DISK
/datum/objective/cybermen/exterminate/nuke_station
	name = "Nuke Station"
	explanation_text = "Destroy the station with the nuclear device in the vault. Hack the nuclear core to bypass the Centcom password lock. The nuclear authentication disk is still required. Do not allow the escape shuttle to leave the station."

/datum/objective/cybermen/exterminate/nuke_station/check_completion()
	if(..())
		return 1
	return ticker.mode.station_was_nuked && (SSshuttle.emergency.mode < SHUTTLE_ESCAPE)

//HIJACK SHUTTLE
/datum/objective/cybermen/exterminate/hijack_shuttle
	name = "Hijack Shuttle"
	var/required_escaped_cybermen

/datum/objective/cybermen/exterminate/hijack_shuttle/New()
	..()
	required_escaped_cybermen = min(6, cyberman_network.cybermen.len)
	explanation_text = "Hijack the escape shuttle, ensuring that no non-cybermen escape on it. At least [required_escaped_cybermen] Cybermen must escape on the shuttle. The escape pods may be ignored."

/datum/objective/cybermen/exterminate/hijack_shuttle/check_completion()
	if(..())
		return 1
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	var/area/A = SSshuttle.emergency.areaInstance
	var/cybermen_escaped = 0
	for(var/mob/living/player in player_list)
		#ifdef CYBERMEN_DEBUG
		to_chat(world, "Checking Player [player]")
		to_chat(world, "Mind: [player.mind]")
		to_chat(world, "Stat: [player.stat]")
		to_chat(world, "Human: [istype(player, /mob/living/carbon/human)]")
		to_chat(world, "Area: [get_area(player) == A]")
		to_chat(world, "")
		#endif
		if(player.mind && player.stat != DEAD && istype(player, /mob/living/carbon/human) && get_area(player) == A)
			if(player.mind && !ticker.mode.is_cyberman(player.mind))
				return 0
			cybermen_escaped++
 	return cybermen_escaped >= required_escaped_cybermen

/datum/objective/cybermen/exterminate/hijack_shuttle/

//KILL NON-CYBERMEN
/datum/objective/cybermen/exterminate/eliminate_humans
	name = "Exterminate Humans"
	var/target_percent

/datum/objective/cybermen/exterminate/eliminate_humans/New()
	..()
	target_percent = 60
	check_completion()//updates explanation_text.

/datum/objective/cybermen/exterminate/eliminate_humans/check_completion()//I mean, you COULD just cart all those pesky non-cybermen off to mining. But that's no fun. The alternative is the possibility that the cybermen have to search the asteroid and deep space for the non-cybermen, and that's even less fun.
	if(..())
		return 1
	var/cybermen_num = 0
	var/non_cybermen_num = 0
	for(var/mob/living/carbon/human/survivor in living_mob_list)
		if(survivor.loc.z == ZLEVEL_STATION && survivor.key)
			if(ticker.mode.is_cyberman(survivor.mind))
				cybermen_num++
			else
				non_cybermen_num++
	var/percent = (cybermen_num + non_cybermen_num > 0) && (cybermen_num / (cybermen_num + non_cybermen_num))*100
	explanation_text = "Ensure at least [target_percent]% of the humanoid population of the station is comprised of cybermen, by either killing, converting, or exiling non-cybermen. Using the data you have collected on human physiology, we have drastically reduced the time it takes to convert additional humans. Do not allow the escape shuttle to leave the station. Sensors indicate that [percent]% of the station's living crew are currently cybermen."
	return (SSshuttle.emergency.mode < SHUTTLE_ESCAPE) && (percent >= target_percent)

/datum/objective/cybermen/exterminate/eliminate_humans/admin_create_objective(mob/user = usr)
	if(alert("Set required % cybermen?", user, "Set", "Standard([target_percent]%)") != "Set")
		return
	var/num = input("Select required % cybermen:", user, 0) as num
	target_percent = Clamp(num, 0, 100)
	check_completion()//updates explanation_text.

//////////////////////////////
////////////MISC//////////////
//////////////////////////////

/datum/objective/cybermen/custom
	name = "Custom"

/datum/objective/cybermen/custom/admin_create_objective(mob/user = usr)
	phase = stripped_input(user, "Enter phase name:")
	explanation_text = stripped_input(usr, "Enter objective text:", user)
	win_upon_completion = alert("Cyberman victory upon completion?", user, "Yes", "No") == "Yes" ? 1 : 0
	alert("Note that an admin must use \"Force Objective Completion\" in the Cyberman Panel to complete this objective and advance the game.", user, "Okay")
