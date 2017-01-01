/*
 HUMANS
*/

/datum/species/human
	name = "Human"
	id = "human"
	default_color = "FFFFFF"
	specflags = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("tail_human", "ears", "wings")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	use_skintones = 1
	roundstart = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human


/datum/species/human/qualifies_for_rank(rank, list/features)
	if((!features["tail_human"] || features["tail_human"] == "None") && (!features["ears"] || features["ears"] == "None"))
		return 1	//Pure humans are always allowed in all roles.

	//Mutants are not allowed in most roles.
	if(rank in security_positions) //This list does not include lawyers.
		return 0
	if(rank in science_positions)
		return 0
	if(rank in medical_positions)
		return 0
	if(rank in engineering_positions)
		return 0
	if(rank == "Quartermaster") //QM is not contained in command_positions but we still want to bar mutants from it.
		return 0
	return ..()

//Curiosity killed the cat's wagging tail.
/datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

#define EATING_MESSAGE_COOLDOWN 1200

/datum/species/human/fly
	// Humans turned into fly-like abominations in teleporter accidents.
	name = "Manfly"
	id = "manfly"
	say_mod = "buzzes"
	specflags = list(EYECOLOR,HAIR,FACEHAIR,LIPS) //Else the shits over with the amputations and make you invisible
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	use_skintones = 0
	mutant_organs = list(/obj/item/organ/tongue/fly)
	specflags = list()
	roundstart = 0
	limbs_id = "fly"
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN //I am here because flies


/datum/species/human/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/datum/species/human/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/human/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(istype(chem,/datum/reagent/consumable))
		var/datum/reagent/consumable/nutri_check = chem
		if(nutri_check.nutriment_factor > 0)
			var/turf/pos = get_turf(H)
			H.vomit(0, 0, 0, 1, 1)
			playsound(pos, 'sound/effects/splat.ogg', 50, 1)
			H.visible_message("<span class='danger'>[H] vomits on the floor!</span>", \
						"<span class='userdanger'>You throw up on the floor!</span>")
/*
 LIZARDPEOPLE
*/

/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Unathi"
	id = "lizard"
	say_mod = "hisses"
	default_color = "00FF00"
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings")
	mutant_organs = list(/obj/item/organ/tongue/lizard)
	default_features = list("mcolor" = "0F0", "tail" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "L"
	roundstart = 1

datum/species/lizard/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='notice'><b>You are Unathi.</b> Hailing from the homeworld of Moghes, your people are descended from an older race lost to the sands of time. Thick scales afford you protection from heat, but your cold-blooded nature is not exactly advantageous in a metal vessel surrounded by the cold depths of space.</span>"
	H << "<span class='notice'>You possess sharp claws that rend flesh easily, though NT obviously does not sanction their use against the crew.</span>"
	H << "<span class='notice'>Beware all things cold, for your metabolism cannot mitigate their effects as well as other warm-blooded creatures.</span>"

/datum/species/lizard/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

//I wag in death
/datum/species/lizard/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()
/*
 Lizard subspecies: ASHWALKERS
*/

/datum/species/lizard/ashwalker
	name = "Ash Walker"
	id = "lizard"
	specflags = list(MUTCOLORS,EYECOLOR,LIPS,NOBREATH,NOGUNS,NOMACHINERY)

/datum/species/lizard/ashwalker/chieftain
	specflags = list(MUTCOLORS,EYECOLOR,LIPS,NOBREATH,NOGUNS)

/datum/species/lizard/fly
	// lizards turned into fly-like abominations in teleporter accidents.
	name = "Unafly"
	id = "unafly"
	say_mod = "buzzes"
	mutant_organs = list(/obj/item/organ/tongue/fly)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	specflags = list(EYECOLOR,LIPS)
	roundstart = 0
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN //I am here because flies
	specflags = list()
	default_color = "FFFFFF"

/datum/species/lizard/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1


/datum/species/lizard/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(istype(chem,/datum/reagent/consumable))
		var/datum/reagent/consumable/nutri_check = chem
		if(nutri_check.nutriment_factor > 0)
			var/turf/pos = get_turf(H)
			H.vomit(0, 0, 0, 1, 1)
			playsound(pos, 'sound/effects/splat.ogg', 50, 1)
			H.visible_message("<span class='danger'>[H] vomits on the floor!</span>", \
						"<span class='userdanger'>You throw up on the floor!</span>")




/*
 ANDROIDS
 */


/datum/species/android
	//augmented half-silicon, half-human hybrids
	//ocular augmentations (they never asked for this) give them slightly improved nightsight (and permanent meson effect)
	//take additional damage from emp
	//can metabolize power cells
	name = "Preternis"
	id = "android"
	default_color = "FFFFFF"
	specflags = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,LIPS)
	say_mod = "intones"
	roundstart = 1
	attack_verb = "assault"
	darksight = 2
	brutemod = 0.95
	burnmod = 1.05
	heatmod = 1.05
	invis_sight = SEE_INVISIBLE_MINIMUM
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN

/datum/species/android/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if (istype(chem, /datum/reagent/consumable)) //paranoia paranoia type casting is coming to get me
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			food.nutriment_factor = food.nutriment_factor * 0.2
			if (world.time - last_eat_message > EATING_MESSAGE_COOLDOWN)
				H << "<span class='info'>NOTICE: Digestive subroutines are inefficient. Seek sustenance via power-cell CONSUME induction.</span>"
				last_eat_message = world.time
		return 0

/datum/species/android/handle_vision(mob/living/carbon/human/H)
	//custom override because darksight APPARENTLY DOESN"T WORK LIKE THIS BY DEFAULT??
	..()
	if (H.nutrition > NUTRITION_LEVEL_STARVING)
		if (H.glasses) //yes, this means that wearing prescription glasses or goggles cancels the darksight.
			var/obj/item/clothing/glasses/G = H.glasses
			H.see_in_dark = G.darkness_view + darksight
		else
			H.see_in_dark = darksight
		H.see_invisible = invis_sight
		return 1
	else
		if(!H.glasses) //they aren't wearing goggles and they are starving so nix the innate darksight
			H.see_in_dark = 0
			H.see_invisible = SEE_INVISIBLE_LIVING
		else //otherwise they are wearing goggles so just use that shit instead
			var/obj/item/clothing/glasses/G = H.glasses
			H.see_in_dark = G.darkness_view
			H.see_invisible = SEE_INVISIBLE_LIVING

/datum/species/android/fly
	// androids turned into fly-like abominations in teleporter accidents.
	name = "Flyternis"
	id = "flyternis"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	default_color = "FFFFFF"
	specflags = list()
	roundstart = 0
	sexes = 0
	mutant_organs = list(/obj/item/organ/tongue/fly)

/datum/species/android/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1


/datum/species/android/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(istype(chem,/datum/reagent/consumable))
		var/datum/reagent/consumable/nutri_check = chem
		if(nutri_check.nutriment_factor > 0)
			var/turf/pos = get_turf(H)
			H.vomit(0, 0, 0, 1, 1)
			playsound(pos, 'sound/effects/splat.ogg', 50, 1)
			H.visible_message("<span class='danger'>[H] vomits on the floor!</span>", \
						"<span class='userdanger'>You throw up on the floor!</span>")
	..()

/datum/species/android/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/datum/species/android/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='info'><b>You are a Preternis.</b> Half-human, half-silicon, you lie in the nebulous between of the two lifeforms, neither one, nor the other.</span>"
	H << "<span class='info'>Powerful ocular implants afford you greater vision in the darkness, but draw large amounts of power from your biological body. Should your stores run out, they will deactivate and leave you blind.</span>"
	H << "<span class='info'>Normal food is worth only a fraction of its normal sustenance to you. You must instead draw your nourishment from power cells, tapping into the energy contained within. Beware electromagnetic pulses, for they would do grevious damage to your internal organs..</span>"
	return ..()

/datum/species/android/handle_emp(mob/living/carbon/human/H, severity)
	..()
	H.lastburntype = "electric"
	switch(severity)
		if(1)
			H.adjustBruteLoss(10)
			H.adjustFireLoss(10)
			H.Stun(5)
			H.nutrition = H.nutrition * 0.4
			H.visible_message("<span class='danger'>Electricity ripples over [H]'s subdermal implants, smoking profusely.</span>", \
							"<span class='userdanger'>A surge of searing pain erupts throughout your very being! As the pain subsides, a terrible sensation of emptiness is left in its wake.</span>")
			H.attack_log += "Was hit with a severity 3(severe) EMP as an android. Lost 20 health."
		if(2)
			H.adjustBruteLoss(5)
			H.adjustFireLoss(5)
			H.Stun(2)
			H.nutrition = H.nutrition * 0.6
			H.visible_message("<span class='danger'>A faint fizzling emanates from [H].</span>", \
							"<span class='userdanger'>A fit of twitching overtakes you as your subdermal implants convulse violently from the electromagnetic disruption. Your sustenance reserves have been partially depleted from the blast.</span>")
			H.emote("twitch")
			H.attack_log += "Was hit with a severity 2(medium) EMP as an android. Lost 10 health."
		if(3)
			H.adjustFireLoss(2)
			H.adjustBruteLoss(3)
			H.Stun(1)
			H.nutrition = H.nutrition * 0.8
			H.emote("scream")
			H.attack_log += "Was hit with a severity 3(light) EMP as an android. Lost 5 health."

/datum/species/android/get_spans()
	return SPAN_ROBOT

/*
 PLANTPEOPLE
*/

/datum/species/plant
	// Creatures made of leaves and plant matter.
	name = "Phytosian"
	id = "plant"
	default_color = "59CE00"
	specflags = list(MUTCOLORS,EYECOLOR)
	attack_verb = "slice"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	burnmod = 1.5
	heatmod = 1.5
	coldmod = 1.5
	roundstart = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/plant

/datum/species/plant/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='info'><b>You are a Phytosian.</b> Born on the core-worlds of G-D52, you are a distant relative of a vestige of humanity long discarded. Symbiotic plant-cells suffuse your skin and provide a protective layer that keeps you alive, and affords you regeneration unmatched by any other race.</span>"
	H << "<span class='info'>Your physiology is similar, but fundamentally different to a normal carbon life form. The chlorophyll in your epidermis provides passive nourishment and regeneration in light, but your biological processes rely on some degree of light being present at all times.</span>"
	H << "<span class='info'>Darkness is your greatest foe. Even the cold expanses of space are lit by neighbouring stars, but the darkest recesses of the station's interior may prove to be your greatest foe. Stripped of light, you will wither and die. Heat and flame are even greater foes, as your epidermis is combustible.</span>"
	H << "<span class='info'>Be warned: you will perish quickly should you become so wounded that you lose consciousness in an area void of any meaningful light source.</span>"

/datum/species/plant/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plantbgone")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		if (prob(5))
			H << "<span class='warning'>Your skin rustles and wilts! You are dying!</span>"
		return 1

/datum/species/plant/on_hit(proj_type, mob/living/carbon/human/H)
	switch(proj_type)
		if(/obj/item/projectile/energy/floramut)
			if(prob(15))
				H.adjustToxLoss(5)
				H.Weaken(5)
				H.visible_message("<span class='warning'>[H] writhes in pain as \his vacuoles boil.</span>", "<span class='userdanger'>You writhe in pain as your vacuoles boil!</span>", "<span class='italics'>You hear the crunching of leaves.</span>")
				if(prob(80))
					randmutb(H)
				else
					randmutg(H)
			else
				H.adjustFireLoss(rand(5,15))
				H.show_message("<span class='userdanger'>The radiation beam singes you!</span>")
		if(/obj/item/projectile/energy/florayield)
			H.nutrition = min(H.nutrition+30, NUTRITION_LEVEL_FULL)
	return

/datum/species/plant/spec_life(mob/living/carbon/human/H)
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		var/area/A = H.loc.loc
		if(A.murders_plants == 1)
			if (H.mind)
				if (H.mind.special_role == "thrall")
					//thralled phytosians have their natural regeneration massively stunted, but their weakness to darkness removed
					if (H.stat != UNCONSCIOUS && H.stat != DEAD)
						H.adjustToxLoss(-0.1)
						H.adjustOxyLoss(-0.1)
						H.heal_overall_damage(0.2, 0.2)
						return

			if (T.get_lumcount() || H.dna.features["mcolor"]=="000") // if they're black, how will they eat light..? Also saves doing the div/0 check.
				var/R = hex2num(copytext(H.dna.features["mcolor"],1,2))
				var/G = hex2num(copytext(H.dna.features["mcolor"],2,3))
				var/B = hex2num(copytext(H.dna.features["mcolor"],3,0))

				var/max_col = max(R,G,B)
				R /= max_col
				G /= max_col
				B /= max_col

				var/food_R = T.r_lumcount * R
				var/food_G = T.g_lumcount * G
				var/food_B = T.b_lumcount * B

				var/light_exposed = (food_R + food_G + food_B) * 3 // Because of the fact that it uses their 'colour', not their value or saturation, they will always be limited to a third of the food they used to. So we multiply it by three.

				switch (light_exposed)
					if (-INFINITY to 0.1)
						H.nutrition -= 3
						if (prob(8))
							H << "<span class='userdanger'>Darkness! Your insides churn and your skin screams in pain!</span>"
						H.adjustOxyLoss(3)
						H.adjustToxLoss(1)
					if (0.1 to 3)
						//very low light
						H.nutrition -= light_exposed/1.5
						if (prob(10))
							H << "<span class='warning'>There isn't enough light here, and you can feel your body protesting the fact violently.</span>"
						H.adjustOxyLoss(3)
					if (3 to 6)
						//low light
						H.nutrition -= light_exposed/2
						if (prob(3))
							H << "<span class='warning'>The ambient light levels are too low. Your breath is coming more slowly as your insides struggle to keep up on their own.</span>"
							H.adjustOxyLoss(6)
					if (6 to 10)
						//medium, average, doing nothing for now
						H.nutrition += light_exposed/10
					if (10 to 22)
						//high light, regen here
						H.nutrition += light_exposed/6
						if (H.stat != UNCONSCIOUS && H.stat != DEAD)
							H.adjustToxLoss(-0.5)
							H.adjustOxyLoss(-0.5)
							H.heal_overall_damage(1, 1)
					if (22 to INFINITY)
						//super high light
						H.nutrition += light_exposed/4
						if (H.stat != UNCONSCIOUS && H.stat != DEAD)
							H.adjustToxLoss(-1)
							H.adjustOxyLoss(-0.5)
							H.heal_overall_damage(1.5, 1.5)
			else if(T.loc.luminosity == 1 || A.lighting_use_dynamic == 0)
				H.nutrition += 1.4
				if (H.stat != UNCONSCIOUS && H.stat != DEAD)
					H.adjustToxLoss(-1)
					H.adjustOxyLoss(-0.5)
					H.heal_overall_damage(1.5, 1.5)
			else
				//no light, this is baaaaaad
				H.nutrition -= 3
				if (prob(8))
					H << "<span class='userdanger'>Darkness! Your insides churn and your skin screams in pain!</span>"
				H.adjustOxyLoss(3)
				H.adjustToxLoss(1)
	else
		if(H.loc != /obj/mecha)
			//inside a container or something else, inflict low-level light degen
			H.nutrition -= 1.5
			if (prob(3))
				H << "<span class='warning'>There's not enough light reaching you in here. You start to feel very claustrophobic as your energy begins to drain away.</span>"
				H.adjustOxyLoss(9)
				H.adjustToxLoss(3)

	if(H.nutrition > NUTRITION_LEVEL_FULL)
		H.nutrition = NUTRITION_LEVEL_FULL

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		if (H.stat != UNCONSCIOUS && H.stat != DEAD)
			if (prob(5))
				H << "<span class='userdanger'>Your internal stores of light are depleted. Find a source to replenish your nourishment at once!</span>"
			H.take_overall_damage(2,0)

/datum/species/plant/fly
	// Phytosian turned into fly-like abominations in teleporter accidents.
	name = "Flytosian"
	id = "flytosian"
	specflags = list()
	say_mod = "buzzes"
	mutant_organs = list(/obj/item/organ/tongue/fly)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	roundstart = 0
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN //I am here because flies
	specflags = list()
	default_color = "000000"

/datum/species/plant/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/datum/species/plant/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1


/datum/species/plant/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(istype(chem,/datum/reagent/consumable))
		var/datum/reagent/consumable/nutri_check = chem
		if(nutri_check.nutriment_factor > 0)
			var/turf/pos = get_turf(H)
			H.vomit(0, 0, 0, 1, 1)
			playsound(pos, 'sound/effects/splat.ogg', 50, 1)
			H.visible_message("<span class='danger'>[H] vomits on the floor!</span>", \
						"<span class='userdanger'>You throw up on the floor!</span>")
	..()

#undef EATING_MESSAGE_COOLDOWN
/*
 PODPEOPLE
*/

/datum/species/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "Podperson"
	id = "pod"
	default_color = "59CE00"
	specflags = list(MUTCOLORS,EYECOLOR)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	burnmod = 1.25
	heatmod = 1.5
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/plant


/datum/species/pod/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = min(10,T.get_lumcount()) - 5
		H.nutrition += light_amount
		if(H.nutrition > NUTRITION_LEVEL_FULL)
			H.nutrition = NUTRITION_LEVEL_FULL
		if(light_amount > 2) //if there's enough light, heal
			H.heal_overall_damage(1,1)
			H.adjustToxLoss(-1)
			H.adjustOxyLoss(-1)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(2,0)

/datum/species/pod/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plantbgone")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/pod/on_hit(proj_type, mob/living/carbon/human/H)
	switch(proj_type)
		if(/obj/item/projectile/energy/floramut)
			if(prob(15))
				H.rad_act(rand(30,80))
				H.Weaken(5)
				H.visible_message("<span class='warning'>[H] writhes in pain as \his vacuoles boil.</span>", "<span class='userdanger'>You writhe in pain as your vacuoles boil!</span>", "<span class='italics'>You hear the crunching of leaves.</span>")
				if(prob(80))
					randmutb(H)
				else
					randmutg(H)
				H.domutcheck()
			else
				H.adjustFireLoss(rand(5,15))
				H.show_message("<span class='userdanger'>The radiation beam singes you!</span>")
		if(/obj/item/projectile/energy/florayield)
			H.nutrition = min(H.nutrition+30, NUTRITION_LEVEL_FULL)
	return

/*
 SHADOWPEOPLE
*/

/datum/species/shadow
	// Humans cursed to stay in the darkness, lest their life forces drain. They regain health in shadow and die in light.
	name = "???"
	id = "shadow"
	darksight = 8
	invis_sight = SEE_INVISIBLE_MINIMUM
	sexes = 0
	ignored_by = list(/mob/living/simple_animal/hostile/faithless)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/shadow
	specflags = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,NODISMEMBER)
	dangerous_existence = 1
	speedmod = 4

/datum/species/shadow/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount()

		if(light_amount > 2) //if there's enough light, start dying
			H.take_overall_damage(1,1)
		else if (light_amount < 2) //heal in the dark
			H.heal_overall_damage(1,1)

/*
 JELLYPEOPLE
*/

/datum/species/jelly
	// Entirely alien beings that seem to be made entirely out of gel. They have three eyes and a skeleton visible within them.
	name = "Xenobiological Jelly Entity"
	id = "jelly"
	default_color = "00FF90"
	say_mod = "chirps"
	eyes = "jelleyes"
	specflags = list(MUTCOLORS,EYECOLOR,NOBLOOD,VIRUSIMMUNE,TOXINLOVER)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	exotic_blood = "slimejelly"
	var/datum/action/innate/regenerate_limbs/regenerate_limbs


/datum/species/jelly/on_species_loss(mob/living/carbon/C)
	if(regenerate_limbs)
		regenerate_limbs.Remove(C)
	..()

/datum/species/jelly/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		regenerate_limbs = new
		regenerate_limbs.Grant(C)

/datum/species/jelly/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD) //can't farm slime jelly from a dead slime/jelly person indefinitely
		return
	if(!H.blood_volume)
		H.blood_volume += 5
		H.adjustBruteLoss(5)
		H << "<span class='danger'>You feel empty!</span>"

	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		if(H.nutrition >= NUTRITION_LEVEL_STARVING)
			H.blood_volume += 3
			H.nutrition -= 2.5
	if(H.blood_volume < BLOOD_VOLUME_OKAY)
		if(prob(5))
			H << "<span class='danger'>You feel drained!</span>"
	if(H.blood_volume < BLOOD_VOLUME_BAD)
		Cannibalize_Body(H)
	H.update_action_buttons_icon()

/datum/species/jelly/proc/Cannibalize_Body(mob/living/carbon/human/H)
	var/list/limbs_to_consume = list("r_arm", "l_arm", "r_leg", "l_leg") - H.get_missing_limbs()
	var/obj/item/bodypart/consumed_limb
	if(!limbs_to_consume.len)
		H.losebreath++
		return
	if(H.get_num_legs()) //Legs go before arms
		limbs_to_consume -= list("r_arm", "l_arm")
	consumed_limb = H.get_bodypart(pick(limbs_to_consume))
	consumed_limb.drop_limb()
	H << "<span class='userdanger'>Your [consumed_limb] is drawn back into your body, unable to maintain its shape!</span>"
	qdel(consumed_limb)
	H.blood_volume += 20

/datum/action/innate/regenerate_limbs
	name = "Regenerate Limbs"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimeheal"
	background_icon_state = "bg_alien"

/datum/action/innate/regenerate_limbs/IsAvailable()
	if(..())
		var/mob/living/carbon/human/H = owner
		var/list/limbs_to_heal = H.get_missing_limbs()
		if(limbs_to_heal.len < 1)
			return 0
		if(H.blood_volume >= BLOOD_VOLUME_OKAY+40)
			return 1
		return 0

/datum/action/innate/regenerate_limbs/Activate()
	var/mob/living/carbon/human/H = owner
	var/list/limbs_to_heal = H.get_missing_limbs()
	if(limbs_to_heal.len < 1)
		H << "<span class='notice'>You feel intact enough as it is.</span>"
		return
	H << "<span class='notice'>You focus intently on your missing [limbs_to_heal.len >= 2 ? "limbs" : "limb"]...</span>"
	if(H.blood_volume >= 40*limbs_to_heal.len+BLOOD_VOLUME_OKAY)
		H.regenerate_limbs()
		H.blood_volume -= 40*limbs_to_heal.len
		H << "<span class='notice'>...and after a moment you finish reforming!</span>"
		return
	else if(H.blood_volume >= 40)//We can partially heal some limbs
		while(H.blood_volume >= BLOOD_VOLUME_OKAY+40)
			var/healed_limb = pick(limbs_to_heal)
			H.regenerate_limb(healed_limb)
			limbs_to_heal -= healed_limb
			H.blood_volume -= 40
		H << "<span class='warning'>...but there is not enough of you to fix everything! You must attain more mass to heal completely!</span>"
		return
	H << "<span class='warning'>...but there is not enough of you to go around! You must attain more mass to heal!</span>"

/*
 SLIMEPEOPLE
*/

/datum/species/jelly/slime
	// Humans mutated by slime mutagen, produced from green slimes. They are not targetted by slimes.
	name = "Slimeperson"
	id = "slime"
	default_color = "00FFFF"
	darksight = 3
	specflags = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,NOBLOOD,VIRUSIMMUNE,TOXINLOVER,EASYDISMEMBER,EASYLIMBATTACHMENT)
	say_mod = "says"
	eyes = "eyes"
	hair_color = "mutcolor"
	hair_alpha = 150
	ignored_by = list(/mob/living/simple_animal/slime)
	burnmod = 0.5
	coldmod = 2
	heatmod = 0.5
	var/datum/action/innate/split_body/slime_split
	var/datum/action/innate/swap_body/body_swap

/datum/species/jelly/slime/on_species_loss(mob/living/carbon/C)
	if(slime_split)
		slime_split.Remove(C)
	if(body_swap)
		body_swap.Remove(C)
	C.faction -= "slime"
	C.blood_volume = min(C.blood_volume, BLOOD_VOLUME_NORMAL)
	..()

/datum/species/jelly/slime/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		slime_split = new
		slime_split.Grant(C)
	C.faction |= "slime"

/datum/species/jelly/slime/spec_life(mob/living/carbon/human/H)
	if(H.blood_volume >= BLOOD_VOLUME_SLIME_SPLIT)
		if(prob(5))
			H << "<span class='notice'>You feel very bloated!</span>"
	else if(H.nutrition >= NUTRITION_LEVEL_WELL_FED)
		H.blood_volume += 3
		H.nutrition -= 2.5

	..()


/datum/action/innate/split_body/IsAvailable()
	if(..())
		var/mob/living/carbon/human/H = owner
		if(H.blood_volume >= BLOOD_VOLUME_SLIME_SPLIT)
			return 1
		return 0

/datum/action/innate/split_body
	name = "Split Body"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimesplit"
	background_icon_state = "bg_alien"

/datum/action/innate/split_body/Activate()
	var/mob/living/carbon/human/H = owner
	H << "<span class='notice'>You focus intently on moving your body while standing perfectly still...</span>"
	H.notransform = 1
	if(H.blood_volume >= BLOOD_VOLUME_SLIME_SPLIT)
		var/mob/living/carbon/human/spare = new /mob/living/carbon/human(H.loc)
		spare.underwear = "Nude"
		H.dna.transfer_identity(spare, transfer_SE=1)
		H.dna.features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
		var/rand_num = rand(1, 999)
		spare.real_name = "[spare.dna.real_name] ([rand_num])"
		spare.name = "[spare.dna.real_name] ([rand_num])"
		spare.updateappearance(mutcolor_update=1)
		spare.domutcheck()
		spare.Move(get_step(H.loc, pick(NORTH,SOUTH,EAST,WEST)))
		H.blood_volume = BLOOD_VOLUME_SAFE
		H.notransform = 0
		var/datum/species/jelly/slime/SS = H.dna.species
		if(!H.mind.slime_bodies.len) //if this is our first time splitting add current body
			SS.body_swap = new
			SS.body_swap.Grant(H)
			H.mind.slime_bodies += H
		H.mind.slime_bodies += spare
		SS.body_swap = new
		SS.body_swap.Grant(spare)
		H.mind.transfer_to(spare)
		spare << "<span class='notice'>...and after a moment of disorentation, you're besides yourself!</span>"
		return
	H << "<span class='warning'>...but there is not enough of you to go around! You must attain more mass to split!</span>"
	H.notransform = 0

/datum/action/innate/swap_body
	name = "Swap Body"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimeswap"
	background_icon_state = "bg_alien"

/datum/action/innate/swap_body/Activate()
	var/list/temp_body_list = list()

	for(var/slime_body in owner.mind.slime_bodies)
		var/mob/living/carbon/human/body = slime_body
		if(!istype(body) || !body.dna || !body.dna.species || body.dna.species.id != "slime" || body.stat == DEAD || qdeleted(body))
			owner.mind.slime_bodies -= body
			continue
		if((body != owner) && (body.stat == CONSCIOUS)) //Only swap into conscious bodies that are not the ones we're in
			temp_body_list += body

	if(owner.mind.slime_bodies.len == 1) //if our current body is our only one it means the rest are dead
		owner << "<span class='warning'>Something is wrong, you cannot sense your other bodies!</span>"
		Remove(owner)
		return

	if(!temp_body_list.len)
		owner << "<span class='warning'>You can sense your bodies, but they are unconscious.</span>"
		return

	var/body_name = input(owner, "Select the body you want to move into", "List of active bodies") as null|anything in temp_body_list

	if(!body_name)
		return

	var/mob/living/carbon/human/selected_body = body_name

	if(selected_body.stat == UNCONSCIOUS || owner.stat == UNCONSCIOUS) //sanity check
		owner << "<span class='warning'>The user or the target body have become unconscious during selection.</span>"
		return

	owner.mind.transfer_to(selected_body)

/*
 GOLEMS
*/

/datum/species/golem
	// Animated beings of stone. They have increased defenses, and do not need to breathe. They're also slow as fuuuck.
	name = "Golem"
	id = "golem"
	specflags = list(NOBREATH,RESISTTEMP,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE,NODISMEMBER,MUTCOLORS)
	speedmod = 2
	armor = 55
	siemens_coeff = 0
	punchdamagelow = 5
	punchdamagehigh = 14
	punchstunthreshold = 11 //about 40% chance to stun
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_w_uniform)
	nojumpsuit = 1
	sexes = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem
	// To prevent golem subtypes from overwhelming the odds when random species
	// changes, only the Random Golem type can be chosen
	blacklisted = TRUE
	dangerous_existence = TRUE
	limbs_id = "golem"
	fixed_mut_color = "aaa"

/datum/species/golem/random
	name = "Random Golem"
	blacklisted = FALSE
	dangerous_existence = FALSE

/datum/species/golem/random/New()
	. = ..()
	var/list/golem_types = typesof(/datum/species/golem) - src.type
	var/datum/species/golem/golem_type = pick(golem_types)
	name = initial(golem_type.name)
	id = initial(golem_type.id)
	meat = initial(golem_type.meat)

/datum/species/golem/adamantine
	name = "Adamantine Golem"
	id = "adamantine"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem/adamantine
	fixed_mut_color = "4ed"

/datum/species/golem/plasma
	name = "Plasma Golem"
	id = "plasma"
	fixed_mut_color = "a3d"

/datum/species/golem/diamond
	name = "Diamond Golem"
	id = "diamond"
	fixed_mut_color = "0ff"

/datum/species/golem/gold
	name = "Gold Golem"
	id = "gold"
	fixed_mut_color = "ee0"

/datum/species/golem/silver
	name = "Silver Golem"
	id = "silver"
	fixed_mut_color = "ddd"

/datum/species/golem/uranium
	name = "Uranium Golem"
	id = "uranium"
	fixed_mut_color = "7f0"


/*
 FLIES
*/

/datum/species/fly
	// Humans turned into fly-like abominations in teleporter accidents.
	name = "Human?"
	id = "fly"
	say_mod = "buzzes"
	mutant_organs = list(/obj/item/organ/tongue/fly)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly

/datum/species/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1


/datum/species/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(istype(chem,/datum/reagent/consumable))
		var/datum/reagent/consumable/nutri_check = chem
		if(nutri_check.nutriment_factor > 0)
			var/turf/pos = get_turf(H)
			H.vomit(0, 0, 0, 1, 1)
			playsound(pos, 'sound/effects/splat.ogg', 50, 1)
			H.visible_message("<span class='danger'>[H] vomits on the floor!</span>", \
						"<span class='userdanger'>You throw up on the floor!</span>")
	..()

/*
 SKELETONS
*/

/datum/species/skeleton
	// 2spooky
	name = "Spooky Scary Skeleton"
	id = "skeleton"
	say_mod = "rattles"
	blacklisted = 1
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	specflags = list(NOBREATH,RESISTTEMP,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE,NOHUNGER,EASYDISMEMBER,EASYLIMBATTACHMENT)
	mutant_organs = list(/obj/item/organ/tongue/bone)

/*
 ZOMBIES
*/

/datum/species/zombie
	// 1spooky
	name = "High Functioning Zombie"
	id = "zombie"
	say_mod = "moans"
	sexes = 0
	blacklisted = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	specflags = list(NOBREATH,RESISTTEMP,NOBLOOD,RADIMMUNE,NOZOMBIE,EASYDISMEMBER,EASYLIMBATTACHMENT, TOXINLOVER)
	mutant_organs = list(/obj/item/organ/tongue/zombie)
	speedmod = 2

/datum/species/zombie/infectious
	name = "Infectious Zombie"
	no_equip = list(slot_wear_mask, slot_head)
	armor = 20 // 120 damage to KO a zombie, which kills it

/datum/species/zombie/infectious/spec_life(mob/living/carbon/C)
	. = ..()
	C.a_intent = "harm" // THE SUFFERING MUST FLOW
	if(C.InCritical())
		C.death()
		// Zombies only move around when not in crit, they instantly
		// succumb otherwise, and will standup again soon

/datum/species/zombie/infectious/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	// Drop items in hands
	// If you're a zombie lucky enough to have a NODROP item, then it stays.
	if(C.unEquip(C.l_hand))
		C.put_in_l_hand(new /obj/item/zombie_hand(C))
	if(C.unEquip(C.r_hand))
		C.put_in_r_hand(new /obj/item/zombie_hand(C))

	// Next, deal with the source of this zombie corruption
	var/obj/item/organ/body_egg/zombie_infection/infection
	infection = C.getorganslot("zombie_infection")
	if(!infection)
		infection = new(C)

/datum/species/zombie/infectious/on_species_loss(mob/living/carbon/C)
	. = ..()
	var/obj/item/zombie_hand/left = C.l_hand
	var/obj/item/zombie_hand/right = C.r_hand
	// Deletion of the hands is handled in the items dropped()
	if(istype(left))
		C.unEquip(left, TRUE)
	if(istype(right))
		C.unEquip(right, TRUE)

// Your skin falls off
/datum/species/krokodil_addict
	name = "Human"
	id = "zombie"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	mutant_organs = list(/obj/item/organ/tongue/zombie)

/datum/species/abductor
	name = "Abductor"
	id = "abductor"
	darksight = 3
	say_mod = "gibbers"
	sexes = 0
	specflags = list(NOBLOOD,NOBREATH,VIRUSIMMUNE,NOGUNS)
	mutant_organs = list(/obj/item/organ/tongue/abductor)
	var/scientist = 0 // vars to not pollute spieces list with castes
	var/agent = 0
	var/team = 1

var/global/image/plasmaman_on_fire = image("icon"='icons/mob/OnFire.dmi', "icon_state"="plasmaman")

/datum/species/plasmaman
	name = "Plasmaman"
	id = "plasmaman"
	say_mod = "rattles"
	sexes = 0
	meat = /obj/item/stack/sheet/mineral/plasma
	specflags = list(NOBLOOD,RADIMMUNE,NOTRANSSTING,VIRUSIMMUNE,NOHUNGER)
	safe_oxygen_min = 0 //We don't breath this
	safe_toxins_min = 16 //We breath THIS!
	safe_toxins_max = 0
	dangerous_existence = 1 //So so much
	blacklisted = 1 //See above
	burnmod = 2
	heatmod = 2
	speedmod = 1

/datum/species/plasmaman/spec_life(mob/living/carbon/human/H)
	var/datum/gas_mixture/environment = H.loc.return_air()

	if(!istype(H.w_uniform, /obj/item/clothing/under/plasmaman) || !istype(H.head, /obj/item/clothing/head/helmet/space/plasmaman))
		if(environment)
			var/total_moles = environment.total_moles()
			if(total_moles)
				if(environment.gases["o2"] && (environment.gases["o2"][MOLES] /total_moles) >= 0.01)
					H.adjust_fire_stacks(0.5)
					if(!H.on_fire && H.fire_stacks > 0)
						H.visible_message("<span class='danger'>[H]'s body reacts with the atmosphere and bursts into flames!</span>","<span class='userdanger'>Your body reacts with the atmosphere and bursts into flame!</span>")
					H.IgniteMob()
	else
		if(H.fire_stacks)
			var/obj/item/clothing/under/plasmaman/P = H.w_uniform
			if(istype(P))
				P.Extinguish(H)
	H.update_fire()

/datum/species/plasmaman/before_equip_job(datum/job/J, mob/living/carbon/human/H, visualsOnly = FALSE)
	var/datum/outfit/plasmaman/O = new /datum/outfit/plasmaman
	H.equipOutfit(O, visualsOnly)
	H.internal = H.r_hand
	H.update_internals_hud_icon(1)
	return 0

/datum/species/plasmaman/qualifies_for_rank(rank, list/features)
	if(rank in security_positions)
		return 0
	if(rank == "Clown" || rank == "Mime")//No funny bussiness
		return 0
	return ..()



/datum/species/synth
	name = "Synth" //inherited from the real species, for health scanners and things
	id = "synth"
	say_mod = "beep boops" //inherited from a user's real species
	sexes = 0
	specflags = list(NOTRANSSTING,NOBREATH,VIRUSIMMUNE,NOHUNGER) //all of these + whatever we inherit from the real species
	safe_oxygen_min = 0
	safe_toxins_min = 0
	safe_toxins_max = 0
	safe_co2_max = 0
	SA_para_min = 0
	SA_sleep_min = 0
	dangerous_existence = 1
	blacklisted = 1
	meat = null
	exotic_damage_overlay = "synth"
	limbs_id = "synth"
	var/list/initial_specflags = list(NOTRANSSTING,NOBREATH,VIRUSIMMUNE,NOHUNGER) //for getting these values back for assume_disguise()
	var/disguise_fail_health = 75 //When their health gets to this level their synthflesh partially falls off
	var/datum/species/fake_species = null //a species to do most of our work for us, unless we're damaged

/datum/species/synth/Destroy()
	var/fs = fake_species
	fake_species = null
	qdel(fs)
	return ..()

/datum/species/synth/military
	name = "Military Synth"
	id = "military_synth"
	armor = 25
	punchdamagelow = 10
	punchdamagehigh = 19
	punchstunthreshold = 14 //about 50% chance to stun
	disguise_fail_health = 50

/datum/species/synth/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	assume_disguise(old_species, H)
	..()
	for(var/V in H.internal_organs)
		var/obj/item/organ/O = V
		O.name = "synthetic [O.name]"

/datum/species/synth/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "synthflesh")
		chem.reaction_mob(H, TOUCH, 2 ,0) //heal a little
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1
	else
		return ..()


/datum/species/synth/proc/assume_disguise(datum/species/S, mob/living/carbon/human/H)
	if(S && !istype(S, type))
		name = S.name
		say_mod = S.say_mod
		sexes = S.sexes
		specflags = initial_specflags.Copy()
		specflags.Add(S.specflags)
		attack_verb = S.attack_verb
		attack_sound = S.attack_sound
		miss_sound = S.miss_sound
		meat = S.meat
		mutant_bodyparts = S.mutant_bodyparts.Copy()
		mutant_organs = S.mutant_organs.Copy()
		default_features = S.default_features.Copy()
		nojumpsuit = S.nojumpsuit
		no_equip = S.no_equip.Copy()
		limbs_id = S.id
		use_skintones = S.use_skintones
		fixed_mut_color = S.fixed_mut_color
		hair_color = S.hair_color
		fake_species = new S.type
		mutant_bodyparts = fake_species.mutant_bodyparts.Copy()
	else
		name = initial(name)
		say_mod = initial(say_mod)
		specflags = initial_specflags.Copy()
		attack_verb = initial(attack_verb)
		attack_sound = initial(attack_sound)
		miss_sound = initial(miss_sound)
		mutant_bodyparts = list()
		default_features = list()
		nojumpsuit = initial(nojumpsuit)
		no_equip = list()
		qdel(fake_species)
		fake_species = null
		meat = initial(meat)
		limbs_id = "synth"
		use_skintones = 0
		sexes = 0
		fixed_mut_color = ""
		hair_color = ""
	if(H)
		H.regenerate_icons()

/datum/species/synth/spec_husk(mob/living/carbon/human/H)
	assume_disguise(null, H)

//Proc redirects:
//Passing procs onto the fake_species, to ensure we look as much like them as possible

/datum/species/synth/handle_hair(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_hair(H, forced_colour)
	else
		return ..()


/datum/species/synth/handle_body(mob/living/carbon/human/H)
	if(fake_species)
		fake_species.handle_body(H)
	else
		return ..()


/datum/species/synth/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_body(H,forced_colour)
	else
		return ..()


/datum/species/synth/get_spans()
	if(fake_species)
		return fake_species.get_spans()
	return list()


/datum/species/synth/handle_speech(message, mob/living/carbon/human/H)
	if(H.health > disguise_fail_health)
		if(fake_species)
			return fake_species.handle_speech(message,H)
		else
			return ..()
	else
		return ..()

/datum/species/synth/spec_life(mob/living/carbon/human/H)
	if(fake_species && (H.health > disguise_fail_health))
		fake_species.spec_life(H)
	else
		..()

/*
SYNDICATE BLACK OPS
*/
//The hardcore return of the failed Deathsquad augmentation project
//Now it's own, wizard-tier, very robust, lone antag
/datum/species/corporate
	name = "Corporate Agent"
	id = "agent"
	hair_alpha = 0
	say_mod = "declares"
	speedmod = -2//Fast
	brutemod = 0.7//Tough against firearms
	burnmod = 0.65//Tough against lasers
	coldmod = 0
	heatmod = 0.5//it's a little tough to burn them to death not as hard though.
	punchdamagelow = 20
	punchdamagehigh = 30//they are inhumanly strong
	punchstunthreshold = 25
	attack_verb = "smash"
	attack_sound = "sound/weapons/resonator_blast.ogg"
	blacklisted = 1
	use_skintones = 0
	specflags = list(RADIMMUNE,VIRUSIMMUNE,NOBLOOD,PIERCEIMMUNE,EYECOLOR,NODISMEMBER,NOHUNGER)
	sexes = 0

/datum/species/angel
	name = "Angel"
	id = "angel"
	default_color = "FFFFFF"
	specflags = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("tail_human", "ears", "wings")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "Angel")
	use_skintones = 1
	no_equip = list(slot_back)
	blacklisted = 1
	limbs_id = "human"
	skinned_type = /obj/item/stack/sheet/animalhide/human

	var/datum/action/innate/flight/fly

/datum/species/angel/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	if(H.dna && H.dna.species &&((H.dna.features["wings"] != "Angel") && ("wings" in H.dna.species.mutant_bodyparts)))
		H.dna.features["wings"] = "Angel"
		H.update_body()
	if(ishuman(H)&& !fly)
		fly = new
		fly.Grant(H)


/datum/species/angel/on_species_loss(mob/living/carbon/human/H)
	if(fly)
		fly.Remove(H)
	if(FLYING in specflags)
		specflags -= FLYING
	ToggleFlight(H,0)
	if(H.dna && H.dna.species &&((H.dna.features["wings"] != "None") && ("wings" in H.dna.species.mutant_bodyparts)))
		H.dna.features["wings"] = "None"
		H.update_body()
	..()

/datum/species/angel/spec_life(mob/living/carbon/human/H)
	HandleFlight(H)

/datum/species/angel/proc/HandleFlight(mob/living/carbon/human/H)
	if(FLYING in specflags)
		if(!CanFly(H))
			ToggleFlight(H,0)
			H.float(0)
			return 0
		H.float(1)
		return 1
	else
		H.float(0)
		return 0

/datum/species/angel/proc/CanFly(mob/living/carbon/human/H)
	if(H.stat || H.stunned || H.weakened)
		return 0
	if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))	//Jumpsuits have tail holes, so it makes sense they have wing holes too
		H << "Your suit blocks your wings from extending!"
		return 0
	var/turf/T = get_turf(H)
	if(!T)
		return 0

	var/datum/gas_mixture/environment = T.return_air()
	if(environment && !(environment.return_pressure() > 30))
		H << "<span class='warning'>The atmosphere is too thin for you to fly!</span>"
		return 0
	else
		return 1

/datum/action/innate/flight
	name = "Toggle Flight"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "slimesplit"
	background_icon_state = "bg_alien"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/angel/A = H.dna.species
	if(A.CanFly(H))
		if(FLYING in A.specflags)
			H << "<span class='notice'>You settle gently back onto the ground...</span>"
			A.ToggleFlight(H,0)
			H.update_canmove()
		else
			H << "<span class='notice'>You beat your wings and begin to hover gently above the ground...</span>"
			H.resting = 0
			A.ToggleFlight(H,1)
			H.update_canmove()

/datum/species/angel/proc/flyslip(mob/living/carbon/human/H)
	var/obj/buckled_obj
	if(H.buckled)
		buckled_obj = H.buckled

	H << "<span class='notice'>Your wings spazz out and launch you!</span>"

	playsound(H.loc, 'sound/misc/slip.ogg', 50, 1, -3)

	H.accident(H.l_hand)
	H.accident(H.r_hand)

	var/olddir = H.dir

	H.stop_pulling()
	if(buckled_obj)
		buckled_obj.unbuckle_mob(H)
		step(buckled_obj, olddir)
	else
		for(var/i=1, i<5, i++)
			spawn (i)
				step(H, olddir)
				H.spin(1,1)
	return 1


/datum/species/angel/spec_stun(mob/living/carbon/human/H,amount)
	if(FLYING in specflags)
		ToggleFlight(H,0)
		flyslip(H)
	. = ..()

/datum/species/angel/negates_gravity()
	if(FLYING in specflags)
		return 1

/datum/species/angel/space_move()
	if(FLYING in specflags)
		return 1

/datum/species/angel/proc/ToggleFlight(mob/living/carbon/human/H,flight)
	if(flight && CanFly(H))
		stunmod = 2
		speedmod = -1
		specflags += FLYING
		override_float = 1
		H.pass_flags |= PASSTABLE
		H.OpenWings()
	else
		stunmod = 1
		speedmod = 0
		specflags -= FLYING
		override_float = 0
		H.pass_flags &= ~PASSTABLE
		H.CloseWings()
