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

	vampire << "<span class='noticevampire'>You are new to the call of darkness. Listen now as you begin your journey.</span>"
	vampire << "<span class='noticevampire'><B>Bite</B> will allow you to drain blood from your victims. You will need to have them in a simple grab state. It does not need to be aggressive, but if you prefer it that way go ahead.</span>"
	vampire << "<span class='noticevampire'><B>Gaze</B> will freeze your enemies in place. Activating it will not freeze them immediately, but queue it in a mouse attack. Using your middle mouse button will cast an actual gaze. Sunglasses and gas masks will block this attack... for now.</span>"
	vampire << "<span class='noticevampire'><B>Bloodtracking</B> will allow you to find out where a trace of blood came from. Activating this is much like gaze, where it queues the spell in your middle mouse button. However, this can only be used on specific blood spills. A unique hud will appear around the owner of the blood you're tracking.</span>"
	vampire << "<span class='noticevampire'><B>Digital Tracking</B> will toggle whether the AI can track you.</span>"
	vampire << "<span class='noticevampire'><B>Digital Visibility</B> will track whether you'll appear on cameras.</span>"

	vampire << "<br><br>"
	vampire << "<span class='noticevampire'>However, being a vampire does not only give you an array of spells, but skills to go along with them.</span>"
	vampire << "<span class='noticevampire'>Considering you are a vampire, <B>you are dead</B>. This means you do not need to breathe, you have no blood, and if you're phytosian you can walk into darkness all you want.</span>"
	vampire << "<span class='noticevampire'><B>Stay away from flames.</B> They will severely hurt you.</span>"
	vampire << "<span class='noticevampire'><B>The Cold is your ally.</B> It cannot hurt you.</span>"

	vampire << "<span class='noticevampire'>Now go on and begin your adventure. The more blood you collect, the more abilities and skills you will unlock.</span>"

/datum/vampire/proc/Hundred()
	hundred_unlocked = TRUE
	vampire.dna.species.toxmod = 0
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/clearstuns(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/hypno(null))


	vampire << "<span class='announcevampire'><B>You have become stronger.</B></span>"
	vampire << "<span class='noticevampire'><B>Toxin is now another one of your allies.</B> You are immune to toxin damage.</span>"
	vampire << "<span class='noticevampire'><B>Clear Stuns</B> is a strong ability that will give you a rush of energy, and jolt you back up from any stuns.</span>"
	vampire << "<span class='noticevampire'><B>Hypnotize</B> is a much more powerful form of gaze. This ability will put your enemies to sleep. It has a four second delay after casting it on an enemy. It queues like gaze as well.</span>"

/datum/vampire/proc/TwoHundred()
	twohundred_unlocked = TRUE
	install_eyes(new /obj/item/organ/cyberimp/eyes/vampire/weak(get_turf(vampire)))
	// upon other things, ash reanimation works in
	vampire << "<span class='announcevampire'><B>You have become stronger.</B></span>"
	vampire << "<span class='noticevampire'><B>Your attraction to darkness becomes stronger.</B> You can now see further in the dark.</span>"
	vampire << "<span class='noticevampire'><B>You can come back from ashes.</B> If you are ever creamated and your body is reduced to ashes you will ressurect whenever blood is spilt on them.</span>"

/datum/vampire/proc/ThreeHundred()
	threehundred_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/radiomalf(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/battrans(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/coffin(null))
	vampire << "<span class='announcevampire'><B>You have become stronger.</B></span>"
	vampire << "<span class='noticevampire'><B>Radio Malfunction</B> is a valuable ability that will deactivate all radios within close range. This includes headsets or hand-held radios on other people.</span>"
	vampire << "<span class='noticevampire'><B>Bat Transformation</B> will transform you into a bat allowing you to seep through airlocks, and harness other talents.</span>"
	vampire << "<span class='noticevampire'><B>Assign Coffin</B> will allow you to assign a coffin as your vampiric home. When assigning a coffin you will be able to generate health and blood.</span>"

/datum/vampire/proc/FourHundred()
	fourhundred_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/shriek(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/batswarm(null))
	vampire << "<span class='announcevampire'><B>You have become stronger.</B></span>"
	vampire << "<span class='noticevampire'><B>Agonizing Shriek</B> is a powerful ability that will allow you to scram at astonishing heights shattering glass, breaking computers, and at the same time stunning and freezing people.</span>"
	vampire << "<span class='noticevampire'><B>Bat Swarm</B> will summon six to eight angry bats</span>"

/datum/vampire/proc/SixHundred()
	sixhundred_unlocked = TRUE
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/strongclearstuns(null))
	for(var/obj/effect/proc_holder/vampire/clearstuns/CS in vampire.abilities)
		vampire.RemoveVampireSpell(CS)
	vampire.see_invisible = SEE_INVISIBLE_OBSERVER
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/rendghost(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/cloakofdarkness(null))

	vampire << "<span class='announcevampire'><B>You have become much stronger.</B></span>"
	vampire << "<span class='noticevampire'>Your sight can now see between dimensions. <B>You can now see ghosts.</B></span>"
	vampire << "<span class='noticevampire'><B>Clear Stuns</B> has been upgraded. It will now fill you with stimulants and omnizine.</span>"
	vampire << "<span class='noticevampire'><B>Rend Ghost</B> will allow you to bite a ghost, as long as it is in an adjacent tile. This will assure you blood.</span>"
	vampire << "<span class='noticevampire'><B>Cloak of Darkness</B> will allow you to fade into the dark.</span>"


/datum/vampire/proc/EightHundred()
	eighthundred_unlocked = TRUE
	vampire.dna.species.heatmod = 1
	install_eyes(new /obj/item/organ/cyberimp/eyes/vampire/strong(get_turf(vampire)))

	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/charm(null))

	vampire << "<span class='noticevampire'>Your skills are becoming quite powerful. <B>Gaze</B> for instance, now works through sunglasses and gas masks.</span>"
	vampire << "<span class='noticevampire'><B>Heat</B> no longer does extra damage to you. You will take as much damage from it as a mere human.</span>"
	vampire << "<span class='noticevampire'><B>Your eyes</B> are even stronger than before. You will be protected from flashes, be granted thermal vision, and have complete darkness vision.</span>"
	vampire << "<span class='noticevampire'><B>Charm Creature</B> is a skill that will make simplemobs friendly towards vampires.</span>"

/datum/vampire/proc/Thousand()
	thousand_unlocked = TRUE

	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/summon(null))
	vampire.AddVampireSpell(new /obj/effect/proc_holder/vampire/setsummonturf(null))

	vampire << "<span class='noticevampire'>You have done an <B>outstanding job</B>.</span>"
	vampire << "<span class='noticevampire'><B>Summon Coffin</B> will allow you to instantly summon your designated coffin.</span>"
	vampire << "<span class='noticevampire'><B>Set Summon Turf</B> will set a turf as a destination for your summon coffin ability. If one is not selected, then summon coffin will transport it directly to you.</span>"
	vampire << "<span class='noticevampire'>You can now <B>regrow limbs</B> from healing in your coffin.</span>"
	vampire << "<span class='noticevampire'>You are now <B>immune to holy water poisoning</B>. However it will still get you wasted.</span>"


/datum/vampire/proc/ForgetAbilities()
	for(var/obj/effect/proc_holder/vampire/vampab in vampire.abilities)
		vampire.RemoveVampireSpell(vampab)
	//vampire.RemoveAbility()

/datum/vampire/process() // called in carbon life.
	if(!vampire)
		return
//	check_bright_turf()
	check_burning_status()
	check_for_chapel()
	check_for_ghost_vision()

/*
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
*/

/datum/vampire/proc/check_for_ghost_vision()
	if(!sixhundred_unlocked)
		return
	if(vampire.see_invisible != SEE_INVISIBLE_OBSERVER)
		vampire.see_invisible = SEE_INVISIBLE_OBSERVER


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

/datum/vampire/proc/check_for_chapel()
	if(istype(get_area(vampire), /area/chapel))
		vampire.apply_damage(5, BURN)
		vampire << "<span class='genesisred'>THE CHAPEL!</span> <span class='alertvampire'>IT BURNS!</span>"

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