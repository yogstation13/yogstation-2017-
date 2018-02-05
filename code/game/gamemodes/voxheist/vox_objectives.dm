
/datum/objective/heist
	explanation_text = "Nothing"

/datum/objective/heist/proc/choose_target()
	return

/datum/objective/heist/proc/is_unique_target()
	return 1


/datum/objective/heist/kidnap/is_unique_target(possible_target)
	for(var/datum/objective/heist/kidnap/O in ticker.mode.raider_objectives)
		if(O.target && (O.target == possible_target))
			return 0

	return 1

/datum/objective/heist/kidnap/choose_target()
	var/list/roles = list("Chief Engineer", "Research Director", "Roboticist", "Chemist", "Medical Doctor", "Quartermaster", "Atmospheric Technician")

	for(var/role in shuffle(roles))
		find_target_by_role(role)
		if(target)
			break

	if(isnull(target)) // If we cannot find some target at certain roles, just pick someone random
		var/list/possible_targets = list()
		for(var/datum/mind/possible_target in get_crewmember_minds())
			if(ishuman(possible_target.current) && (possible_target.current.stat != 2) && (!possible_target.special_role) && is_unique_target(possible_target))
				possible_targets += possible_target

		if(possible_targets.len > 0)
			target = pick(possible_targets)

	if(target)
		explanation_text = "The Shoal has a need for [target.current.real_name], the [target.assigned_role]. Take them alive."
	else
		explanation_text = "Free Objective"

	return target

/datum/objective/heist/kidnap/check_completion()
	if(target)
		if(isnull(target.current)/* || target.current.stat == DEAD*/) // We can clone them after we get them back anyway. (This doesn't mean they can just kill their target)
			return FALSE // They're destroyed, nice.

		var/end_area = get_area_master(locate(/area/shuttle/vox_shuttle))
		if(get_area_master(target.current) != end_area)
			return FALSE

	return TRUE


/datum/objective/heist/inviolate_crew
	explanation_text = "Do not leave any Vox behind, alive or dead."

/datum/objective/heist/inviolate_crew/check_completion()
	var/datum/game_mode/voxheist/H = ticker.mode
	return H.is_raider_crew_safe()


/datum/objective/heist/steal
	var/datum/objective_item/heist/targetinfo = null //Save the chosen item datum so we can access it later.
	var/list/item_list = list()
	var/list/areas = list(/area/shuttle/vox_shuttle)

/datum/objective/heist/steal/is_unique_target(possible_target)
	for(var/datum/objective/heist/steal/O in ticker.mode.raider_objectives)
		if(O.targetinfo && O.targetinfo.target && (O.targetinfo.target == possible_target))
			return 0

	return 1


/datum/objective/heist/steal/choose_target()
	var/approved_targets = list()
	for(var/datum/objective_item/heist/possible_item in item_list)
		if(is_unique_target(possible_item.target))
			approved_targets += possible_item

	targetinfo = safepick(approved_targets)
	update_explanation_text()

/datum/objective/heist/steal/check_completion()
	var/list/search = list()
	var/found = 0

	for(var/A in areas)
		var/area/B = locate(A)
		search += recursive_type_check(B, targetinfo.target)

	if(targetinfo.custom_check)
		return targetinfo.check_special_completion(search)

	for(var/C in search)
		found++

	return (found >= targetinfo.amount)


/datum/objective/heist/steal/easy/New()
	..()

	if(!item_list.len)//Only need to fill the list when it's needed.
		init_subtypes(/datum/objective_item/heist/easy, item_list)

/datum/objective/heist/steal/hard/New()
	..()

	if(!item_list.len)//Only need to fill the list when it's needed.
		init_subtypes(/datum/objective_item/heist/hard, item_list)


/datum/objective/heist/steal/easy/update_explanation_text()
	explanation_text = "We are lacking in some trivial devices. Steal or trade [targetinfo.name]."

/datum/objective/heist/steal/hard/update_explanation_text()
	explanation_text = "We are lacking in expensive hardware or bioware. Steal or trade [targetinfo.name]."



/datum/objective_item/heist
	var/list/areas = list(/area/shuttle/vox_shuttle)
	var/obj/item/target = null		// Maybe turn this into 2 lists, one list of items that NEED to be there and one list where atleast one needs to be there?
	var/custom_check = 0

	var/amount = 0
	var/min = 0
	var/max = 0

/datum/objective_item/heist/New()
	amount = rand(min, max)

	if(amount == 1)
		name = "\a [name]"
	else
		name = "[amount] [name]"


/datum/objective_item/heist/easy/microwave
	name = "microwave ovens"
	target = /obj/machinery/microwave
	min = 2
	max = 2

/datum/objective_item/heist/easy/piano
	name = "space piano"
	target = /obj/structure/piano
	min = 1
	max = 1

/datum/objective_item/heist/easy/canister
	name = "canister containing atleast 28 moles of plasma"
	target = /obj/machinery/portable_atmospherics/canister
	custom_check = 1
	min = 1
	max = 1

// Check if all of the canisters on the shuttle have atleast 28 moles of plasma combined.
/datum/objective_item/heist/easy/canister/check_special_completion(list/obj/machinery/portable_atmospherics/canister/items)
	var/found_amount = 0
	var/target_amount = text2num(name)
	for(var/obj/machinery/portable_atmospherics/canister/C in items)
		found_amount += C.air_contents.gases["plasma"] ? C.air_contents.gases["plasma"][MOLES] : 0

	return found_amount >= target_amount


/datum/objective_item/heist/easy/borgrecharger
	name = "cyborg recharging stations"
	target = /obj/machinery/recharge_station
	min = 2
	max = 2

/datum/objective_item/heist/easy/fueltank
	name = "fuel tanks"
	target = /obj/structure/reagent_dispensers/fueltank
	min = 2
	max = 4

/datum/objective_item/heist/easy/ionrifle
	name = "ion rifle"
	target = /obj/item/weapon/gun/energy/ionrifle
	min = 1
	max = 1


/datum/objective_item/heist/hard/engine
	name = "complete particle accelerator"
	target = /obj/structure/particle_accelerator
	custom_check = 1
	min = 1
	max = 1

/datum/objective_item/heist/hard/engine/check_special_completion()
	var/list/search = list()
	var/list/contents = list(/obj/structure/particle_accelerator/fuel_chamber,
								/obj/machinery/particle_accelerator/control_box,
								/obj/structure/particle_accelerator/particle_emitter/center,
								/obj/structure/particle_accelerator/particle_emitter/left,
								/obj/structure/particle_accelerator/particle_emitter/right,
								/obj/structure/particle_accelerator/power_box,
								/obj/structure/particle_accelerator/end_cap)

	for(var/A in areas)
		var/area/B = locate(A)
		search += recursive_type_check(B, /obj/structure/particle_accelerator)
		search += recursive_type_check(B, /obj/machinery/particle_accelerator)	// Damn control box

	for(var/C in contents)
		for(var/atom/A in search)
			if(istype(A, C)) //Does search contain this part type
				continue

			return 0 //It didn't, fail the object


	return 1


/datum/objective_item/heist/hard/nuke
	name = "heavily radioactive plutonium core from the onboard self-destruct"
	target = /obj/item/nuke_core
	min = 1
	max = 1

/datum/objective_item/heist/hard/fox
	name = "fox"
	target = /mob/living/simple_animal/pet/fox
	min = 1
	max = 1
