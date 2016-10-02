
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 1.5

/datum/reagent/toxin/on_mob_life(mob/living/M)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM, 0)
		. = 1
	..()

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	color = "#00FF00"
	toxpwr = 0

/datum/reagent/toxin/mutagen/reaction_mob(mob/living/carbon/M, method=TOUCH, reac_volume)
	if(!..())
		return
	if(!M.has_dna())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if((method==VAPOR && prob(min(33, reac_volume))) || method==INGEST || method==PATCH || method==INJECT)
		randmuti(M)
		if(prob(98))
			randmutb(M)
		else
			randmutg(M)
		M.updateappearance()
		M.domutcheck()
	..()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/M)
	if(istype(M))
		M.apply_effect(5,IRRADIATE,0)
	return ..()

/datum/reagent/toxin/plasma
	name = "Plasma"
	id = "plasma"
	description = "Plasma in its liquid form."
	color = "#8228A0"
	toxpwr = 3

/datum/reagent/toxin/plasma/on_mob_life(mob/living/M)
	if(holder.has_reagent("epinephrine"))
		holder.remove_reagent("epinephrine", 2*REM)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.adjustPlasma(20)
	return ..()

/datum/reagent/toxin/plasma/reaction_obj(obj/O, reac_volume)
	if((!O) || (!reac_volume))
		return 0
	O.atmos_spawn_air("plasma=[reac_volume];TEMP=[T20C]")

/datum/reagent/toxin/plasma/reaction_turf(turf/open/T, reac_volume)
	if(istype(T))
		T.atmos_spawn_air("plasma=[reac_volume];TEMP=[T20C]")
	return

/datum/reagent/toxin/plasma/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 2)
		return
	..()

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "A powerful poison used to stop respiration."
	color = "#7DC3A0"
	toxpwr = 0

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/M)
	. = TRUE
	var/mob/living/carbon/C
	if(iscarbon(M))
		C = M
		CHECK_DNA_AND_SPECIES(C)
		if(NOBREATH in C.dna.species.specflags)
			. = FALSE

	if(.)
		M.adjustOxyLoss(6, 0)
		if(C)
			C.losebreath += 3
			if(prob(10))
				C.silent = max(C.silent, 3)
		if(prob(40))
			M.emote("gasp")
	..()

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/M)
	if(prob(50))
		M << "<span class='danger'>Your insides are burning!</span>"
		M.adjustToxLoss(50*REM, 0)
		. = 1
	else if(prob(50))
		M.adjustCloneLoss(50*REM, 0)
		M << "<span class='danger'>You're melting away!</span>"
		. = 1
	..()

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "This stuff wiped out the space-americas a long time ago."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

/datum/reagent/toxin/minttoxin/on_mob_life(mob/living/M)
	if(M.nutrition = min(M.nutrition + 100, NUTRITION_LEVEL_FULL)
		M.gib()
	return ..()

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded spess carp."
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state for a short period of time."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/carbon/M)
	switch(current_cycle)
		if(1 to 20)
			M.status_flags |= FAKEDEATH
			M.adjustOxyLoss(0.5*REM, 0)
			M.Weaken(5, 0)
			M.silent = max(M.silent, 5)
			M.tod = worldtime2text()
			..()
			. = 1
		if(20 to INFINITY)
			return

/datum/reagent/toxin/zombiepowder/on_mob_delete(mob/M)
	M.status_flags -= FAKEDEATH
	..()

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen. Not a thing to be messed with."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/M)
	M.hallucination += 30
	M.adjustBrainLoss(4)
	return ..()

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

/datum/reagent/toxin/plantbgone/reaction_obj(obj/O, reac_volume)
	if(istype(O,/obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.take_damage(rand(15,35), BRUTE, 0) // Kills alien weeds pretty fast
	else if(istype(O,/obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O,/obj/effect/spacevine))
		var/obj/effect/spacevine/SV = O
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == VAPOR)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.wear_mask) // If not wearing a mask
				var/damage = min(round(0.4*reac_volume, 0.1),10)
				C.adjustToxLoss(damage)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	description = "A harmful toxic mixture to kill weeds. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75

/datum/reagent/toxin/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	description = "A harmful toxic mixture to kill pests. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1

/datum/reagent/toxin/pestkiller/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == VAPOR)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.wear_mask) // If not wearing a mask
				var/damage = min(round(0.4*reac_volume, 0.1),10)
				C.adjustToxLoss(damage)

/datum/reagent/toxin/spore
	name = "Spore Toxin"
	id = "spore"
	description = "A natural toxin produced by blob spores that inhibits vision when ingested."
	color = "#9ACD32"
	toxpwr = 2

/datum/reagent/toxin/spore/on_mob_life(mob/living/M)
	M.damageoverlaytemp = 60
	M.update_damage_hud()
	M.blur_eyes(5)
	M.Dizzy(3)
	return ..()

/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin"
	id = "spore_burning"
	description = "A natural toxin produced by blob spores that induces combustion in its victim."
	color = "#9ACD32"
	toxpwr = 0.5

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(4)
	M.IgniteMob()
	return ..()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative that induces confusion and drowsiness before putting its target to sleep."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1 * REAGENTS_METABOLISM

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 9)
			M.confused += 2
			M.drowsyness += 2
			M.adjustStaminaLoss(2*REM, 0)
		if(9 to 30)
			M.Sleeping(2, 0)
			. = 1
		if(31 to INFINITY)
			M.Sleeping(2, 0)
			M.adjustToxLoss((current_cycle - 50)*REM, 0)
			. = 1
	..()

/datum/reagent/toxin/chloralhydrate/delayed
	id = "chloralhydrate2"

/datum/reagent/toxin/chloralhydrate/delayed/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 10)
			return
		if(10 to 20)
			M.confused += 1
			M.drowsyness += 1
		if(20 to INFINITY)
			M.Sleeping(2, 0)
	..()

/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "A specially-engineered sedative disguised as beer. It induces instant sleep in its target."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/beer2/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 50)
			M.Sleeping(2, 0)
		if(51 to INFINITY)
			M.Sleeping(2, 0)
			M.adjustToxLoss((current_cycle - 50)*REM, 0)
	return ..()

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	id = "coffeepowder"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	id = "teapowder"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.5

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin"
	id = "mutetoxin"
	description = "A nonlethal poison that inhibits speech in its victim."
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/M)
	M.silent = max(M.silent, 3)
	..()

/datum/reagent/toxin/staminatoxin
	name = "Tirizene"
	id = "tirizene"
	description = "A nonlethal poison that causes extreme fatigue and weakness in its victim."
	color = "#6E2828"
	data = 13
	toxpwr = 0

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/M)
	M.adjustStaminaLoss(REM * data, 0)
	data = max(data - 1, 3)
	..()
	. = 1

/datum/reagent/toxin/polonium
	name = "Polonium"
	id = "polonium"
	description = "An extremely radioactive material in liquid form. Ingestion results in fatal irradiation."
	reagent_state = LIQUID
	color = "#787878"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/polonium/on_mob_life(mob/living/M)
	M.radiation += 4
	..()

/datum/reagent/toxin/histamine
	name = "Histamine"
	id = "histamine"
	description = "Histamine's effects become more dangerous depending on the dosage amount. They range from mildly annoying to incredibly lethal."
	reagent_state = LIQUID
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0

/datum/reagent/toxin/histamine/on_mob_life(mob/living/M)
	if(prob(50))
		switch(pick(1, 2, 3, 4))
			if(1)
				M << "<span class='danger'>You can barely see!</span>"
				M.blur_eyes(3)
			if(2)
				M.emote("cough")
			if(3)
				M.emote("sneeze")
			if(4)
				if(prob(75))
					M << "You scratch at an itch."
					M.adjustBruteLoss(2*REM, 0)
					. = 1
	..()

/datum/reagent/toxin/histamine/overdose_process(mob/living/M)
	M.adjustOxyLoss(2*REM, 0)
	M.adjustBruteLoss(2*REM, 0)
	M.adjustToxLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	description = "Formaldehyde, on its own, is a fairly weak toxin. It contains trace amounts of Histamine, very rarely making it decay into Histamine.."
	reagent_state = LIQUID
	color = "#B4004B"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/M)
	if(prob(5))
		holder.add_reagent("histamine", pick(5,15))
		holder.remove_reagent("formaldehyde", 1.2)
	else
		return ..()

/datum/reagent/toxin/venom
	name = "Venom"
	id = "venom"
	description = "An exotic poison extracted from highly toxic fauna. Causes scaling amounts of toxin damage and bruising depending and dosage. Often decays into Histamine."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/venom/on_mob_life(mob/living/M)
	toxpwr = 0.2*volume
	M.adjustBruteLoss((0.3*volume)*REM, 0)
	. = 1
	if(prob(15))
		M.reagents.add_reagent("histamine", pick(5,10))
		M.reagents.remove_reagent("venom", 1.1)
	else
		..()

/datum/reagent/toxin/neurotoxin2
	name = "Neurotoxin"
	id = "neurotoxin2"
	description = "Neurotoxin will inhibit brain function and cause toxin damage before eventually knocking out its victim."
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/neurotoxin2/on_mob_life(mob/living/M)
	if(M.brainloss + M.toxloss <= 60)
		M.adjustBrainLoss(3*REM)
		M.adjustToxLoss(1.5*REM, 0)
		. = 1
	if(current_cycle = 5)
		M.Sleeping(4, 0)
		. = 1
	..()

/datum/reagent/toxin/cyanide
	name = "Cyanide"
	id = "cyanide"
	description = "An infamous poison known for its use in assassination. Causes small amounts of toxin damage with a small chance of oxygen damage or a stun."
	reagent_state = LIQUID
	color = "#00B4FF"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 2

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/M)
	if(prob(5))
		M.losebreath += 3
	if(prob(8))
		M << "You feel horrendously weak!"
		M.Stun(0.5, 0)
		M.adjustToxLoss(3*REM, 0)
	return ..()
	
	

/datum/reagent/toxin/questionmark // food poisoning
	name = "Bad Food"
	id = "????"
	description = "????"
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	
/datum/reagent/toxin/replitium
	name = "Replitium"
	id = "replitium"
	description = "A chemical that, while only mildly toxic, continually replicates in the afflicted victim's bloodstream to make more of itself."
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0.2

/datum/reagent/toxin/replitium/on_mob_life(mob/living/M)
	if(prob(80))
		holder.add_reagent("replitium", pick(2,5)) //random small amounts, but since every bit counts...
	if(holder.has_reagent("calomel"))
		holder.remove_reagent("replitium", 600*REM) //calomel treats this otherwise awful abomination
	
/datum/reagent/toxin/hemoharrigium
	name = "Hemoharragium"
	id = "hemoharragium"
	description = "A debilitating poison that corrodes the blood vessels, causing massive internal bleeding."
	reagent_state = LIQUID
	color = "#FF0000" //just #FFFuck me up fam
	metabolization_rate = 1.5 * REAGENTS_METABOLISM //decays quickly
	toxpwr = 0
	
/datum/reagent/toxin/hemoharragium/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.vessel)
			H.vessel.remove_reagent("blood",rand(1, 3))
	..()

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Rotatium"
	id = "rotatium"
	description = "A constantly swirling, oddly colourful fluid. Causes the consumer's sense of direction and hand-eye coordination to become wild."
	reagent_state = LIQUID
	color = "#FFFF00" //RGB: 255, 255, 0 Bright ass yellow
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0
	var/rotate_timer = 0

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/M)
	rotate_timer++
	if(M.reagents.get_reagent_amount("rotatium") < 2)
		M.client.dir = NORTH
		..()
		return
	if(rotate_timer >= rand(5,30)) //Random rotations are wildly unpredictable and hilarious
		rotate_timer = 0
		M.client.dir = pick(NORTH, EAST, SOUTH, WEST)
	..()

/datum/reagent/toxin/rotatium/on_mob_delete(mob/living/M)
	M.client.dir = NORTH
	..()
	
/datum/reagent/toxin/maloculin
	name = "Maloculin"
	id = "maloculin"
	description = "Causes the vitreous in the eye to solidify as long as it's in the system of the victim, causing blindness."
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
		
/datum/reagent/toxin/maloculin/on_mob_life(mob/living/M)
	if(holder.has_reagent("oculine"))
		holder.remove_reagent("maloculin", 8*REM)
		if(prob(5))
			M << "<span class='userdanger'>The burning in your eyes subsides.</span>"
	switch(current_cycle)
		if(1 to 15)
			M.blur_eyes(10)
			M.adjust_eye_damage(1)
			if(prob(5))
				M << "<span class='userdanger'>Your eyes burn!</span>"
		if(15 to 30)
			M.blur_eyes(15)
			M.adjust_eye_damage(3)
			if(prob(10))
				M << "<span class='userdanger'>Your feel a stabbing pain in your eyes!</span>"
		if(30 to 60)
			M.blur_eyes(20)
				M.adjust_eye_damage(5)
				if(M.eye_damage >= 30)
					M.become_nearsighted()
					if(prob(M.eye_damage - 10 + 1))
						if(M.become_blind())
							M << "<span class='userdanger'>You go blind!</span>"
		if(60 to INFINITY)
			M.become_blind()
	

/datum/reagent/toxin/itching_powder
	name = "Itching Powder"
	id = "itching_powder"
	description = "A powder that induces itching upon contact with the skin. Causes the victim to scratch at their itches and has a very low chance to decay into Histamine."
	reagent_state = LIQUID
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/itching_powder/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.reagents.add_reagent("itching_powder", reac_volume)

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/M)
	if(prob(15))
		M << "You scratch at your head."
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(prob(15))
		M << "You scratch at your leg."
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(prob(15))
		M << "You scratch at your arm."
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(prob(1))
		M << "You scratch too hard!"
		M.adjustBruteLoss(10*REM,0)
		. = 1 //lol
	if(prob(2))
		M.reagents.add_reagent("histamine",rand(1,3))
		M.reagents.remove_reagent("itching_powder",1.2)
		return
	..()

/datum/reagent/toxin/initropidril
	name = "Initropidril"
	id = "initropidril"
	description = "A powerful poison with insidious effects. It can cause stuns, lethal breathing failure, and cardiac arrest."
	reagent_state = LIQUID
	color = "#7F10C0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/M)
	if(prob(25))
		var/picked_option = rand(1,3)
		switch(picked_option)
			if(1)
				M.Stun(3, 0)
				M.Weaken(3, 0)
				. = 1
			if(2)
				M.losebreath += 10
				M.adjustOxyLoss(rand(10), 0)
				. = 1
			if(3)
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(!H.heart_attack)
						H.heart_attack = 1 // rip in pepperoni
						if(H.stat == CONSCIOUS)
							H.visible_message("<span class='userdanger'>[H] clutches at their chest as if their heart stopped!</span>")
					else
						H.losebreath += 10
						H.adjustOxyLoss(rand(5,25), 0)
						. = 1
	return ..() || .

/datum/reagent/toxin/pancuronium
	name = "Pancuronium"
	id = "pancuronium"
	description = "An undetectable toxin that swiftly incapacitates its victim. May also cause breathing failure."
	reagent_state = LIQUID
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/M)
	if(current_cycle >= 5)
		M.Paralyse(2, 0)
		. = 1
	if(prob(20))
		M.losebreath += 4
	..()

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental"
	id = "sodium_thiopental"
	description = "Sodium Thiopental induces heavy weakness in its target as well as unconsciousness."
	reagent_state = LIQUID
	color = "#6496FA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/M)
	if(current_cycle >= 5)
		M.Sleeping(2, 0)
	M.adjustStaminaLoss(20*REM, 0)
	..()
	. = 1

/datum/reagent/toxin/sulfonal
	name = "Sulfonal"
	id = "sulfonal"
	description = "A stealthy poison that deals minor toxin damage and eventually puts the target to sleep."
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/M)
	if(current_cycle >= 13)
		M.Sleeping(2, 0)
	return ..()

/datum/reagent/toxin/amanitin
	name = "Amanitin"
	id = "amanitin"
	description = "A very powerful delayed toxin. Upon full metabolization, a massive amount of toxin damage will be dealt depending on how long it has been in the victim's bloodstream."
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/M)
	M.adjustToxLoss(current_cycle*3*REM)
	..()

/datum/reagent/toxin/lipolicide
	name = "Lipolicide"
	id = "lipolicide"
	description = "A powerful toxin that will destroy fat cells, massively reducing body weight in a short time. More deadly to those without nutriment in their body."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/M)
	if(!holder.has_reagent("nutriment"))
		M.adjustToxLoss(0.5*REM, 0)
	M.nutrition = max( M.nutrition - 5 * REAGENTS_METABOLISM, 0)
	M.overeatduration = 0
	return ..()

/datum/reagent/toxin/coniine
	name = "Coniine"
	id = "coniine"
	description = "Coniine metabolizes extremely slowly, but deals high amounts of toxin damage and stops breathing."
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75

/datum/reagent/toxin/coniine/on_mob_life(mob/living/M)
	M.losebreath += 5
	return ..()

/datum/reagent/toxin/curare
	name = "Curare"
	id = "curare"
	description = "Causes slight toxin damage followed by chain-stunning and oxygen damage."
	reagent_state = LIQUID
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/curare/on_mob_life(mob/living/M)
	if(current_cycle >= 11)
		var /obj/item/organ/lungs/L = M.getorganslot("lungs")
		if(L)
			L.decay += 5
			if(L.decay >= 100)
    			qdel(L)
		M.Weaken(3, 0)
	M.adjustOxyLoss(1*REM, 0)
	. = 1
	..()

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Heparin"
	id = "heparin"
	description = "A powerful anticoagulant, used to treat cardiac issues and stop clotting."
	reagent_state = LIQUID
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/heparin/on_mob_life(mob/living/M)
	if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(H.heart_attack)
						H.heart_attack = 0 // treats myocardial infarction
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.bleed_rate = min(H.bleed_rate + 2, 8)
		H.adjustBruteLoss(1, 0) //Brute damage increases with the amount they're bleeding
		. = 1
	return ..() || .

/datum/reagent/toxin/teslium //Teslium. Causes periodic shocks, and makes shocks against the target much more effective.
	name = "Teslium"
	id = "teslium"
	description = "An unstable, electrically-charged metallic slurry. Periodically electrocutes its victim, and makes electrocutions against them more deadly."
	reagent_state = LIQUID
	color = "#20324D" //RGB: 32, 50, 77
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	var/shock_timer = 0

/datum/reagent/toxin/teslium/on_mob_life(mob/living/M)
	shock_timer++
	if(shock_timer >= rand(5,30)) //Random shocks are wildly unpredictable
		shock_timer = 0
		M.electrocute_act(rand(5,20), "Teslium in their body", 1, 1) //Override because it's caused from INSIDE of you
		playsound(M, "sparks", 50, 1)
	..()


/datum/reagent/toxin/capilletum
	name = "Capilletum"
	id = "capilletum"
	description = "A powerful toxin that mimicks the patterns of punctured skin, matching their pigments and shapes, and spreading it around the body. Unlike other toxins, it only has short side effects like possible hunger. Easy now, it doesn't make them have a crutch for brains."
	color = "#FFB9D2"
	metabolization_rate = 0.3
	toxpwr = 0

//ACID


/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A strong mineral acid with the molecular formula H2SO4."
	color = "#00FF32"
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour

/datum/reagent/toxin/acid/reaction_mob(mob/living/carbon/C, method=TOUCH, reac_volume)
	if(!istype(C))
		return
	reac_volume = round(reac_volume,0.1)
	if(method == INGEST)
		C.adjustFireLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(method == INJECT)
		C.adjustFireLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
		return
	C.acid_act(acidpwr, toxpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_obj(obj/O, reac_volume)
	if(istype(O.loc, /mob)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	O.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(reac_volume,0.1)
	for(var/obj/O in T)
		O.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric acid"
	id = "facid"
	description = "Fluorosulfuric acid is a an extremely corrosive chemical substance."
	color = "#5050FF"
	toxpwr = 2
	acidpwr = 42.0

/datum/reagent/toxin/acid/fluacid/on_mob_life(mob/living/M)
	M.adjustFireLoss(current_cycle/10, 0) // I rode a tank, held a general's rank
	. = 1 // When the blitzkrieg raged and the bodies stank
	..() // Pleased to meet you, hope you guess my name
	
/datum/reagent/toxin/acid/flaacid
	name = Floroantimonic Acid
	id = flacid
	description = "A highly illegal, dangerous substance, floroantimonic acid is an incredible superacid, capable of melting even glass and plastic."
	color = "#79726C"
	toxpwr = 0
	acidpwr = 300 //it's a superacid, do you people know this shit

/datum/reagent/toxin/acid/flaacid/reaction_mob(mob/living/carbon/C, method=TOUCH, reac_volume)
	reac_volume = round(reac_volume,0.1)
	if(method == INGEST)
		C.adjustFireLoss(5*REM, 0)
		return
	if(method == INJECT)
		C.adjustFireLoss(5*REM, 0)
		return

/datum/reagent/toxin/acid/flaacid/on_mob_life(mob/living/M)
	if(prob(30))
		M.adjustFireLoss(current_cycle/5, 0)
		. = 1
		..()
	if(method == INGEST)
		if(prob(20))
			var/obj/item/organ/tongue/T = M.getorganslot("tongue")
				qdel(tongue)
			var /obj/item/organ/lungs/L = M.getorganslot("lungs")
				if(L)
					L.decay += 8
					if(L.decay >= 100)
    					qdel(L)
			M << "Your insides are melting away!."
		..()
	if(method == INJECT)
		. = TRUE
			var/mob/living/carbon/C
			if(iscarbon(M))
				C = M
				CHECK_DNA_AND_SPECIES(C)
				if(NOBLOOD in C.dna.species.specflags)
					. = FALSE
				if(BLOOD_VOLUME_SURVIVE to 0) //they have no blood in them/low enough not to matter
					. = FALSE
		if(.)
			M << "Your blood boils away!."
			H.blood_volume = max(H.blood_volume - 50, 0)
				
			
		

/datum/reagent/toxin/peaceborg/confuse
	name = "Dizzying Solution"
	id = "dizzysolution"
	description = "Makes the target off balance and dizzy"
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/peaceborg/confuse/on_mob_life(mob/living/M)
	M.confused += 1
	M.Dizzy(1)
	if(prob(20))
		M << "You feel confused and disorientated."
	..()

/datum/reagent/toxin/peaceborg/tire
	name = "Tiring Solution"
	id = "tiresolution"
	description = "An extremely weak stamina-toxin that tires out the target. Completely harmless."
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/peaceborg/tire/on_mob_life(mob/living/M)
	if(M.staminaloss < 50)
		M.adjustStaminaLoss(10)
	if(prob(30))
		M << "You should sit down and take a rest..."
	..()
