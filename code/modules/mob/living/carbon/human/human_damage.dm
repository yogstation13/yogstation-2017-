//Updates the mob's health from bodyparts and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(GODMODE in status_flags)
		return
	var/total_burn	= 0
	var/total_blunt = 0
	var/total_sharp = 0
	for(var/X in bodyparts)	//hardcoded to streamline things a bit
		var/obj/item/bodypart/BP = X
		total_blunt	+= BP.blunt_dam
		total_sharp += BP.sharp_dam
		total_burn	+= BP.burn_dam
	health = maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_blunt - total_sharp
	update_stat()
	if(((maxHealth - total_burn) < config.health_threshold_dead) && stat == DEAD )
		ChangeToHusk()
		if(on_fire)
			shred_clothing()
	med_hud_set_health()
	med_hud_set_status()


//These procs fetch a cumulative total damage from all bodyparts
/mob/living/carbon/human/getBluntLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		amount += BP.blunt_dam
	return amount

/mob/living/carbon/human/getSharpLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		amount += BP.sharp_dam
	return amount

/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		amount += (BP.blunt_dam + BP.sharp_dam)
	return amount


/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		amount += BP.burn_dam
	return amount

//Set brute/burn damages to the amount specified.
/mob/living/carbon/human/setBluntLoss(amount)
	var/set_damage = max(0, amount)
	var/current_damage = getBluntLoss()

	if(current_damage > set_damage)
		heal_overall_damage(current_damage - set_damage, 0)
	else if(current_damage < set_damage)
		take_overall_damage(set_damage - current_damage, 0)

/mob/living/carbon/human/setSharpLoss(amount)
	var/set_damage = max(0, amount)
	var/current_damage = getSharpLoss()

	if(current_damage > set_damage)
		heal_overall_damage(current_damage - set_damage, 0)
	else if(current_damage < set_damage)
		take_overall_damage(set_damage - current_damage, 0)

/mob/living/carbon/human/setFireLoss(amount)
	var/set_damage = max(0, amount)
	var/current_damage = getFireLoss()

	if(current_damage > set_damage)
		heal_overall_damage(0, current_damage - set_damage)
	else if(current_damage < set_damage)
		take_overall_damage(0, set_damage - current_damage)

/mob/living/carbon/human/adjustSharpLoss(amount)
	if(GODMODE in status_flags)
		return 0
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/carbon/human/adjustBluntLoss(amount)
	if(GODMODE in status_flags)
		return 0
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/carbon/human/adjustFireLoss(amount)
	if(GODMODE in status_flags)
		return 0
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/carbon/human/proc/hat_fall_prob()
	var/multiplier = 1
	var/obj/item/clothing/head/H = head
	var/loose = 40
	if(stat || (FAKEDEATH in status_flags))
		multiplier = 2
	if(H.flags_cover & (HEADCOVERSEYES | HEADCOVERSMOUTH) || H.flags_inv & (HIDEEYES | HIDEFACE))
		loose = 0
	return loose * multiplier

////////////////////////////////////////////

//Returns a list of damaged bodyparts
/mob/living/carbon/human/proc/get_damaged_bodyparts(sharp, blunt, burn)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if((sharp + blunt && BP.blunt_dam + BP.sharp_dam) || (burn && BP.burn_dam))
			parts += BP
	return parts

//Returns a list of damageable bodyparts
/mob/living/carbon/human/proc/get_damageable_bodyparts()
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.blunt_dam + BP.burn_dam + BP.sharp_dam < BP.max_damage)
			parts += BP
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(sharp, blunt, burn)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(sharp, blunt,burn)
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.heal_damage(blunt,sharp,burn,0))
		update_damage_overlays(0)
	updatehealth()

//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(blunt,sharp , burn)
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts()
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.take_damage(blunt, sharp, burn))
		update_damage_overlays(0)
	updatehealth()


//Heal MANY bodyparts, in random order
/mob/living/carbon/human/heal_overall_damage(blunt ,sharp , burn, updating_health=1)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(blunt,sharp,burn)

	var/update = 0
	while(parts.len && (blunt + sharp>0 || burn>0) )
		var/obj/item/bodypart/picked = pick(parts)

		var/blunt_was = picked.blunt_dam
		var/sharp_was = picked.sharp_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(blunt,sharp,burn,0)

		blunt -= (blunt_was-picked.blunt_dam)
		sharp -= (sharp_was-picked.sharp_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	if(updating_health)
		updatehealth()
		if(update)
			update_damage_overlays(0)

// damage MANY bodyparts, in random order
/mob/living/carbon/human/take_overall_damage(blunt, sharp, burn)
	if(GODMODE in status_flags)
		return	//godmode

	var/list/obj/item/bodypart/parts = get_damageable_bodyparts()
	var/update = 0
	while(parts.len && (blunt>0 || sharp>0 || burn>0) )
		var/obj/item/bodypart/picked = pick(parts)
		var/blunt_per_part = blunt/parts.len
		var/sharp_per_part = sharp/parts.len
		var/burn_per_part = burn/parts.len

		var/blunt_was = picked.blunt_dam
		var/sharp_was = picked.sharp_dam
		var/burn_was = picked.burn_dam


		update |= picked.take_damage(sharp_per_part,burn_per_part,blunt_per_part)

		blunt	-= (picked.blunt_dam - blunt_was)
		sharp	-= (picked.sharp_dam - sharp_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	if(update)
		update_damage_overlays(0)

////////////////////////////////////////////


/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BLUNT, def_zone = null, blocked = 0)
	// depending on the species, it will run the corresponding apply_damage code there
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src)
