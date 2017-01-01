/*
	The resolution rules for attacks are as follows:
	1. UnarmedAttack calls m_resolve_UnarmedAttack and resolves the module interactions BEFORE
	   calling attack_hand, so you will try to apply module effects to items on the ground when you click on them, and also
	   modules will be tried to be applied to anything like doors/computers before you interact with it.
	2. Same rules for RangedAttack, really. But it's only called if the thing you clicked is > 1 tile away.
	3. Both of these are resolved after the glove Touch proc that I'm not touching just yet.
	4. The switch on which proc to use reuses attack_type defines (Currently UNARMED_ATTACK, PROJECTILE_ATTACK).

	By default, the equipment module resolution sequence is as thus (these are attack procs for when you click on something with empty hand) - see resolve_order.dm for more info:
	1. Head->Suit->Jumpsuit->Gloves (no boots)
	2. Modules have a unique_resolution variable in them, which means that only one of the same module can be resolved.
	   We use a list that we pass around to the module holder procs on all items.
	3. UnarmedAttack is going to be called if the target is adjecent
	4. RangedAttack is only going to be called if you are not adjecent to the clicked thing

	These are called in code/_onclick/other_mobs.dm UnarmedAttack/RangedAttack procs.

	Everything is handled using the 'resolve_order' datum that controls the order in which items are resolved
	This proc uses clothing slot defines from code/_DEFINES/clothing.dm to compare them to the datum's order list
*/
/mob/proc/resolve_assault_modules(atom/A, resolve_proc, datum/resolve_order/order)

/mob/proc/has_active_module(id, slot)

/mob/proc/resolve_defense_modules(obj/item/I, mob/living/user, obj/item/bodypart/affecting, proj_attack, datum/resolve_order/defense_order)

/mob/living/carbon/human/resolve_assault_modules(atom/A, resolve_proc, datum/resolve_order/attack_order)
	var/datum/resolve_order/attack_resolve_order

	if(!istype(attack_order))
		attack_resolve_order = get_attack_order_datum(resolve_proc)
	else
		attack_resolve_order = attack_order

	if(islist(attack_order))
		attack_resolve_order.append(attack_order)

	if(!attack_resolve_order || !attack_resolve_order.order || !attack_resolve_order.order.len)
		return FALSE

	var/obj/item/item_to_resolve 
	var/resolved = FALSE

	for(var/v in attack_resolve_order.order)
		item_to_resolve = get_item_by_slot(v)

		if(item_to_resolve && istype(item_to_resolve))
			switch(resolve_proc)
				if(UNARMED_MELEE_CLICK, UNARMED_RANGE_CLICK, ARMED_MELEE_CLICK, ARMED_RANGE_CLICK)
					if(item_to_resolve.resolve_assault_modules(A, src, resolve_proc))
						resolved = TRUE

	if(resolved)
		changeNext_move(CLICK_CD_MELEE)

	return resolved

/mob/living/carbon/human/has_active_module(id, slot)
	if(!id)
		return

	if(islist(slot))
		for(var/v in slot)
			var/obj/item/to_check = get_item_by_slot(slot)
			if(to_check)
				if(to_check.has_active_module(id))
					return TRUE
	else if(slot)
		var/obj/item/to_check = get_item_by_slot(slot)
		if(to_check)
			if(to_check.has_active_module(id))
				return TRUE
	else
		var/obj/item/to_check
		for(var/obj/item/v in contents) //I hope to god this is good enough and I don't have to manually go though slots
			to_check = v
			if(to_check.has_active_module(id))
				return TRUE
	return FALSE

/mob/living/carbon/human/resolve_defense_modules(atom/I, mob/living/user, obj/item/bodypart/affecting, attack_type, datum/resolve_order/defense_order)
	if(!istype(affecting)) //if we pass the zone (projectile attack, for example)
		affecting = get_bodypart(affecting)

	if(!affecting) //limb missing, failsafe copy from species code
		affecting = bodyparts[1]

	var/datum/resolve_order/human/defense_resolve_order
	
	if(!istype(defense_order))
		defense_resolve_order = get_defense_order_datum(affecting.body_part)
	else
		defense_resolve_order = defense_order

	if(islist(defense_order))
		defense_resolve_order.append(defense_order)

	if(!defense_resolve_order || !defense_resolve_order.order || !defense_resolve_order.order.len)
		return FALSE

	//Resolve global defense modules first (personal shields, for example, etc)
	//We resolve all global modules, rather than stopping as soon as one of them returns TRUE
	var/resolved = FALSE
	for(var/obj/item/v in contents)
		if(v.resolve_defense_modules(I, user, src, attack_type, ONHIT_GLOBAL))
			resolved = TRUE

	if(resolved) //if one of the global modules resolve this, we stop here
		return TRUE

	//Now resolve modules on the hit bodypart
	resolved = FALSE
	for(var/v in defense_resolve_order.order)
		var/obj/item/to_check = get_item_by_slot(v)
		if(to_check)
			if(to_check.resolve_defense_modules(I, user, src, attack_type, ONHIT_LOCAL))
				resolved = TRUE

	return resolved

/*
	Order datum helpers
*/
/mob/proc/get_attack_order_datum(attack_type)

/mob/proc/get_defense_order_datum(body_part)

/mob/living/carbon/human/get_attack_order_datum(attack_type)
	var/datum/resolve_order/human/order
	if(attack_type)
		switch(attack_type)
			if(UNARMED_MELEE_CLICK, UNARMED_RANGE_CLICK) //resolve all default (see comment block at the top) equipment
				order = new /datum/resolve_order/human/attack/default()
			if(ARMED_MELEE_CLICK, ARMED_RANGE_CLICK) //only resolve the item in hand
				order = new()
				if(hand)
					order.append(slot_l_hand)
				else
					order.append(slot_r_hand)
	else
		order = new()
	return order

/mob/living/carbon/human/get_defense_order_datum(body_part)
	var/datum/resolve_order/human/order

	switch(body_part)
		if(HEAD)
			order = new /datum/resolve_order/human/defense/head(hand)
		if(CHEST, ARM_RIGHT, ARM_LEFT)
			order = new /datum/resolve_order/human/defense/body(hand)
		if(LEG_RIGHT, LEG_LEFT)
			order = new /datum/resolve_order/human/defense/legs(hand)

	return order