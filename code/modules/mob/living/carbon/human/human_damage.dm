//Updates the mob's health from bodyparts and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(GODMODE in status_flags)
		return
	var/oldhealth = health
	var/total_burn	= 0
	var/total_brute	= 0
	for(var/X in bodyparts)	//hardcoded to streamline things a bit
		var/obj/item/bodypart/BP = X
		total_brute	+= BP.brute_dam
		total_burn	+= BP.burn_dam
	health = maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute
	update_stat()
	if(((maxHealth - total_burn) < config.health_threshold_dead) && stat == DEAD )
		ChangeToHusk()
		if(on_fire)
			shred_clothing()
	med_hud_set_health()
	med_hud_set_status()
	hulk_health_check(oldhealth)


//These procs fetch a cumulative total damage from all bodyparts
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		amount += BP.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		amount += BP.burn_dam
	return amount

//Set brute/burn damages to the amount specified.
/mob/living/carbon/human/setBruteLoss(amount)
	var/set_damage = max(0, amount)
	var/current_damage = getBruteLoss()

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

/mob/living/carbon/human/adjustBruteLoss(amount, updating_health, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(amount > 0)
		take_overall_damage(amount, 0, application)
	else
		heal_overall_damage(-amount, 0, application)

/mob/living/carbon/human/adjustFireLoss(amount, updating_health, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(amount > 0)
		take_overall_damage(0, amount, application)
	else
		heal_overall_damage(0, -amount, application)

/mob/living/carbon/human/adjustOxyLoss(amount, updating_health=1, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(dna && dna.species && application != DAMAGE_NO_MULTIPLIER)
		if(amount > 0)
			if(application in dna.species.damage_immunities)
				return
		else
			if(application in dna.species.heal_immunities)
				return
	oxyloss = Clamp(oxyloss + amount, 0, maxHealth*2)
	if(updating_health)
		updatehealth()

/mob/living/carbon/human/adjustToxLoss(amount, updating_health=1, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(dna && dna.species)
		if(application != DAMAGE_NO_MULTIPLIER)
			if(TOXINLOVER in dna.species.specflags)
				amount = -amount
				if(amount > 0)
					blood_volume -= 5*amount
				else
					blood_volume -= amount
			if(amount > 0)
				if(application in dna.species.damage_immunities)
					return 0
				amount *= dna.species.toxmod
			else
				if(application in dna.species.heal_immunities)
					return 0
	toxloss = Clamp(toxloss + amount, 0, maxHealth*2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/carbon/human/adjustCloneLoss(amount, updating_health=1, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(dna && dna.species && application != DAMAGE_NO_MULTIPLIER)
		if(amount > 0)
			if(application in dna.species.damage_immunities)
				return 0
			amount *= dna.species.clonemod
		else
			if(application in dna.species.heal_immunities)
				return 0
	cloneloss = Clamp(cloneloss + amount, 0, maxHealth*2)
	if(updating_health)
		updatehealth()


/mob/living/carbon/human/adjustBrainLoss(amount, updating_health=1, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(dna && dna.species && application != DAMAGE_NO_MULTIPLIER)
		if(amount > 0)
			if(application in dna.species.damage_immunities)
				return 0
			amount *= dna.species.brainmod
		else
			if(application in dna.species.heal_immunities)
				return 0
	brainloss = Clamp(brainloss + amount, 0, maxHealth*2)


/mob/living/carbon/adjustStaminaLoss(amount, updating_stamina = 1, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return 0
	if(dna && dna.species && application != DAMAGE_NO_MULTIPLIER)
		if(amount > 0)
			if(application in dna.species.damage_immunities)
				return 0
			amount *= dna.species.staminamod
		else
			if(application in dna.species.heal_immunities)
				return 0
	staminaloss = Clamp(staminaloss + amount, 0, maxHealth*2)
	if(updating_stamina)
		update_stamina()

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
/mob/living/carbon/human/proc/get_damaged_bodyparts(brute, burn)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if((brute && BP.brute_dam) || (burn && BP.burn_dam))
			parts += BP
	return parts

//Returns a list of damageable bodyparts
/mob/living/carbon/human/proc/get_damageable_bodyparts()
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.brute_dam + BP.burn_dam < BP.max_damage)
			parts += BP
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(brute, burn, application=DAMAGE_PHYSICAL)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute,burn)
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.heal_damage(brute,burn,0,application))
		update_damage_overlays(0)
	updatehealth()

//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(brute, burn, updating_health=1, application=DAMAGE_PHYSICAL)
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts()
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.take_damage(brute, burn, application))
		update_damage_overlays(0)
	updatehealth()


//Heal MANY bodyparts, in random order
/mob/living/carbon/human/heal_overall_damage(brute, burn, updating_health=1, application=DAMAGE_PHYSICAL)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute,burn)

	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/bodypart/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute, burn, 0, application)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	if(updating_health)
		updatehealth()
		if(update)
			update_damage_overlays(0)

// damage MANY bodyparts, in random order
/mob/living/carbon/human/take_overall_damage(brute, burn, application=DAMAGE_PHYSICAL)
	if(GODMODE in status_flags)
		return	//godmode
	if(dna && dna.species && application != DAMAGE_NO_MULTIPLIER)
		brute *= dna.species.brutemod
		burn *= dna.species.burnmod
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts()
	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/bodypart/picked = pick(parts)
		var/brute_per_part = brute/parts.len
		var/burn_per_part = burn/parts.len

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam


		update |= picked.take_damage(brute_per_part, burn_per_part, application)

		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	if(update)
		update_damage_overlays(0)

////////////////////////////////////////////


/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = 0, application=DAMAGE_PHYSICAL)
	// depending on the species, it will run the corresponding apply_damage code there
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, application)
