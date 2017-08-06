/datum/vampire
	var/mob/living/carbon/human/vampire
	var/bloodcount
	var/isDraining
	var/obj/effect/proc_holder/vampire/chosen_click_attack
	var/mob/living/carbon/human/tracking
	var/obj/structure/closet/coffin/vampiric/coffin
	var/turf/hometurf
	var/basic_unlocked
	var/hundred_unlocked
	var/twohundred_unlocked
	var/threehundred_unlocked
	var/fourhundred_unlocked
	var/sixhundred_unlocked
	var/eighthundred_unlocked
	var/thousand_unlocked

/datum/vampire/proc/add_blood(amount, amthigh, amtlow)
	var/amt = amount
	if(amthigh && amtlow)
		amt = rand(amthigh, amtlow)

	bloodcount += amt
	return 1

/datum/vampire/proc/remove_blood(amount, amthigh, amtlow)
	var/amt = amount
	if(amthigh && amtlow)
		amt = rand(amthigh, amtlow)

	bloodcount -= amt
	if(bloodcount < 0)
		bloodcount = 0
	return 1

/datum/vampire/proc/Basic()
	if(basic_unlocked)
		return

	basic_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/bite(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/gaze(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/bloodtracking(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/digitaltracking(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/digitalvisbility(null))

	vampire.dna.species.update_life = FALSE
	vampire.dna.species.brutemod = 1
	vampire.dna.species.burnmod = 2
	vampire.dna.species.coldmod = 0
	vampire.dna.species.heatmod = 2

	vampire.dna.species.specflags |= NOBLOOD
	vampire.dna.species.specflags |= NOBREATH

	vampire.faction |= "Vampire"

/datum/vampire/proc/Hundred()
	hundred_unlocked = TRUE
	vampire.dna.species.toxmod = 0
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/clearstuns(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/hypno(null))

/datum/vampire/proc/TwoHundred()
	twohundred_unlocked = TRUE
	install_eyes(new /obj/item/organ/cyberimp/eyes/vampire/weak(get_turf(vampire)))
	// upon other things, ash reanimation works in

/datum/vampire/proc/ThreeHundred()
	threehundred_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/radiomalf(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/battrans(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/coffin(null))

/datum/vampire/proc/FourHundred()
	fourhundred_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/shriek(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/batswarm(null))

/datum/vampire/proc/SixHundred()
	sixhundred_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/strongclearstuns(null))
	for(var/obj/effect/proc_holder/vampire/clearstuns/CS in vampire.abilities)
		vampire.RemoveVampireSpell(CS)
	vampire.see_invisible = SEE_INVISIBLE_OBSERVER
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/rendghost(null))

/datum/vampire/proc/EightHundred()
	eighthundred_unlocked = TRUE
	vampire.dna.species.heatmod = 1
	vampire << "<span class='noticevampire'>Your glare and hypnotize abilities have grown powerful enough to break through sunglasses and gas masks now.</span>"
	install_eyes(new /obj/item/organ/cyberimp/eyes/vampire/strong(get_turf(vampire)))

	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/charm(null))

/datum/vampire/proc/Thousand()
	thousand_unlocked = TRUE

	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/summon(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/setsummonturf(null))

/datum/vampire/proc/ForgetAbilities()
	for(var/obj/effect/proc_holder/vampire/vampab in vampire.abilities)
		vampire.RemoveVampireSpell(vampab)
	//vampire.RemoveAbility()

/datum/vampire/process() // called in carbon life.
	if(!vampire)
		return
	check_bright_turf()
	check_burning_status()

/datum/vampire/proc/check_bright_turf()
	if(vampire.stat == DEAD)
		return

	if(thousand_unlocked)
		return

	var/turf/T = get_turf(vampire)
	if(T.get_lumcount() > 14.5)
		if((vampire.wear_suit && (vampire.wear_suit.flags & THICKMATERIAL)) && (vampire.head && (vampire.head.flags & THICKMATERIAL)))
			return
		vampire << 'sound/weapons/sear.ogg'
		vampire.apply_damage(5, BURN)
		vampire << "<span class='genesisred'>THE LIGHT </span><span class='alertvampire'> IT BURNS!!!</span>"

/datum/vampire/proc/check_burning_status()
	if(vampire.stat == DEAD)
		if(vampire.on_fire)
			for(var/obj/item/I in vampire) // You're not going in there looking like THAT!
				vampire.unEquip(I)
			var/obj/effect/decal/cleanable/ash/vampiric/V = new(get_turf(vampire), strong = check_ash_strength())
			handle_ash_movement(V, vampire)
			var/mob/M
			if(vampire.key)
				M = vampire
			else
				for(var/mob/dead/observer/ghost in mob_list)
					if(M)
						break
					if(ghost.name == vampire.name && ghost.real_name == vampire.real_name)
						M = ghost
						break
			M << "<span class='noticevampire'>Your body has been crumpled up into dust. Ashes to ashes, and \
				when blood falls over them you will be reborn.</span>"

/datum/vampire/proc/check_ash_strength() // you need to have at least drinken 200 blood to return back from ashes.
	if(twohundred_unlocked)
		return TRUE
	else
		return FALSE

/datum/vampire/proc/handle_ash_movement(obj/effect/decal/cleanable/ash/vampiric/V, mob/vamp)
	vampire.forceMove(V)
	V.storedmob = vamp

/datum/vampire/proc/install_eyes(obj/item/organ/cyberimp/eyes/E)
	var/obj/item/organ/cyberimp/eyes/eyes = vampire.getorgan(/obj/item/organ/cyberimp/eyes)
	if(eyes)
		eyes.Remove(vampire, 0, 1)
	if(E)
		E.Insert(vampire, 1)

#define FREEZE_TOUCH_TEMP	50

/datum/vampire/proc/freeze_touch(mob/living/carbon/human/H) // called in species.dm
	if(!prob(25))
		return

	H.bodytemperature = min(FREEZE_TOUCH_TEMP, H.bodytemperature - (0.8 * FREEZE_TOUCH_TEMP))
	H << "<span class='warning'>Your body begins to</span> <span class='alertvampire'>freeze up...</span>"

#undef FREEZE_TOUCH_TEMP

/datum/vampire/proc/check_for_new_ability()
	if(bloodcount >= 100)
		if(!hundred_unlocked)
			Hundred()
	if(bloodcount >= 200)
		if(!twohundred_unlocked)
			TwoHundred()
	if(bloodcount >= 300)
		if(!threehundred_unlocked)
			ThreeHundred()
	if(bloodcount >= 400)
		if(!fourhundred_unlocked)
			FourHundred()
	if(bloodcount >= 600)
		if(!sixhundred_unlocked)
			SixHundred()
	if(bloodcount >= 800)
		if(!eighthundred_unlocked)
			EightHundred()
	if(bloodcount >= 1000)
		if(!thousand_unlocked)
			Thousand()

// TESTING ONLY:

/mob/proc/makevampire()
	mind.vampire = new(mind)
	mind.vampire.vampire = mind.current
	mind.vampire.Basic()
	world << "turned [key] into a vampire"
	if(mind.vampire)
		return TRUE

// END TESTING STUFF

// under get_limit() we are using the vampire's current unlock requirements as a limit towards how much the vampire can do X (whatever you want to use the limit for).
// For instance, this is used as a cap towards how much blood a vampire can regenerate back inside of their coffin.

/datum/vampire/proc/get_limit()
	if(thousand_unlocked) 		return 1000
	if(eighthundred_unlocked)	return 800
	if(sixhundred_unlocked)		return 600
	if(fourhundred_unlocked)	return 400
	if(threehundred_unlocked)	return 300
	if(twohundred_unlocked)		return 200
	if(hundred_unlocked)		return 100
	return 0