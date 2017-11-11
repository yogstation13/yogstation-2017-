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
	var/traits = "You are a golem"

/datum/species/golem/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	addtimer(src, "explain_traits", 10, , C)

/datum/species/golem/proc/explain_traits(mob/living/carbon/C)
	C << "<span class='notice'>[traits]</span>"

/datum/species/golem/random
	name = "Random Golem"
	blacklisted = FALSE
	dangerous_existence = FALSE

/datum/species/golem/random/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	var/datum/species/golem/golem_type = pick(typesof(/datum/species/golem) - src.type)
	if(ishuman(C)) //Not risking it
		var/mob/living/carbon/human/H = C
		H.set_species(golem_type)

/datum/species/golem/iron
	name = "Iron Golem"
	id = "iron"
	fixed_mut_color = "aaa"
	meat = /obj/item/stack/sheet/metal
	armor = 50
	siemens_coeff = 2
	punchdamagelow = 8
	punchdamagehigh = 20
	punchstunthreshold = 15
	stunmod = 1.5
	traits = "As an <span class='danger'>Iron Golem</span>, your punches pack a punch!"


/datum/species/golem/adamantine
	name = "Adamantine Golem"
	id = "adamantine"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem/adamantine
	fixed_mut_color = "4ed"
	armor = 55
	traits = "As an <span class='danger'>Adamantine Golem</span>, you have decent armor!"

/datum/species/golem/plasma
	name = "Plasma Golem"
	id = "plasma"
	fixed_mut_color = "a3d"
	specflags = list(NOBREATH,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE,NODISMEMBER,MUTCOLORS) //So he properly catches fire
	armor = 35
	burnmod = 2
	heatmod = 2
	speedmod = 1
	heatmod = 2
	meat = /obj/item/stack/sheet/mineral/plasma
	traits = "As a <span class='danger'>Plasma Golem</span>, you dissolve on death!"

/datum/species/golem/plasma/spec_death(gibbed, mob/living/carbon/human/H)
	var/turf/open/T = get_turf(H)
	T.atmos_spawn_air("plasma=100;TEMP=[T20C]")
	H.dust()

/datum/species/golem/diamond
	name = "Diamond Golem"
	id = "diamond"
	fixed_mut_color = "0ff"
	armor = 80
	speedmod = 3.5
	stunmod = 0.5
	staminamod = 1.5
	meat = /obj/item/stack/sheet/mineral/diamond
	traits = "As a <span class='danger'>Diamond Golem</span>, you are very durable, but very slow!"

/datum/species/golem/gold
	name = "Gold Golem"
	id = "gold"
	fixed_mut_color = "ee0"
	armor = 30
	speedmod = 1
	meat = /obj/item/stack/sheet/mineral/gold
	traits = "As a <span class='danger'>Golden Golem</span>, your armor is both weaker and lighter!"

/datum/species/golem/silver
	name = "Silver Golem"
	id = "silver"
	fixed_mut_color = "ddd"
	armor = 50
	siemens_coeff = 2
	burnmod = 0.5 //Silver has a high thermal conductivity. So burn disperses?
	meat = /obj/item/stack/sheet/mineral/silver
	traits = "As a <span class='danger'>Silver Golem</span>, you are resistant to burn!"

/datum/species/golem/uranium
	name = "Uranium Golem"
	id = "uranium"
	fixed_mut_color = "7f0"
	meat = /obj/item/stack/sheet/mineral/uranium
	armor = 40
	traits = "As a <span class='danger'>Uranium Golem</span>, your armor emits radiating pulses!"

/datum/species/golem/uranium/spec_life(mob/living/carbon/human/H)
	radiation_pulse(get_turf(H), 2, 4, 2, 0)

/datum/species/golem/glass
	name = "Glass Golem"
	id = "glass"
	fixed_mut_color = "5a96b4aa"
	meat = /obj/item/stack/sheet/glass
	reflective = FALSE
	armor = 10
	burnmod = 0.5
	brutemod = 2
	speedmod = 0.5
	traits = "As a <span class='danger'>Glass Golem</span>, you're vulnerable to brute attacks, but resistant to burning and are immune to lasers!"

/datum/species/golem/glass/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	if(istype(P, /obj/item/projectile/beam))
		return -1

/datum/species/golem/glass/spec_death(gibbed, mob/living/carbon/human/H)
	for(var/obj/item/I in H)
		H.unEquip(I)
	for(var/i=1, i <= rand(3,5), i++)
		new /obj/item/weapon/shard(get_turf(H))
	playsound(H, "shatter", 70, 1)
	H.visible_message("<span class='danger'>[H]'s glass body shatters into pieces...</span>")
	qdel(H)

/datum/species/golem/glass/r_glass
	name = "Reinforced Glass Golem"
	id = "r_glass"
	fixed_mut_color = "4193B9A"
	meat = /obj/item/stack/sheet/rglass
	reflective = FALSE
	armor = 30
	brutemod = 1.5
	speedmod = 1
	traits = "As a <span class='danger'>Reinforced Glass Golem</span>, lasers pass though you, but have a weaker armor!"

/datum/species/golem/plasteel
	name = "Plasteel Golem"
	id = "plasteel"
	fixed_mut_color = "918396"
	armor = 65
	burnmod = 0.9
	speedmod = 3
	siemens_coeff = 1
	meat = /obj/item/stack/sheet/plasteel
	traits = "As a <span class='danger'>Plasteel Golem</span>, your armor is strong, but you're considerably slower!"

/datum/species/golem/sand
	name = "Sand Golem"
	id = "sand"
	fixed_mut_color = "FAD95F"
	armor = 0
	brutemod = 0.1
	burnmod = 3.5 //2 welder hits for crit
	speedmod = 0
	meat = /obj/item/stack/sheet/mineral/sandstone
	traits = "As a <span class='danger'>Sand Golem</span>, you're immune to all but burn damage!"

/datum/species/golem/sand/spec_death(gibbed, mob/living/carbon/human/H)
	for(var/obj/item/I in H)
		H.unEquip(I)
	for(var/i=1, i <= rand(3,5), i++)
		new /obj/item/weapon/ore/glass(get_turf(H))
	playsound(H, "sound/effects/shovel_dig.ogg", 70, 1)
	H.visible_message("<span class='danger'>[H]'s sandy body crumbles to dust...</span>")
	qdel(H)

/datum/species/golem/sand/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	if(istype(P, /obj/item/projectile/bullet))
		playsound(H, "sound/effects/shovel_dig.ogg", 70, 1)
		H.visible_message("<span class='danger'>The bullet sinks harmlessly in [H]'s sandy body!</span>", \
		"<span class='userdanger'>The bullet sinks harmlessly in [H]'s sandy body!</span>")
		return 2

/datum/species/golem/alloy
	name = "Alien Alloy Golem"
	id = "alloy"
	fixed_mut_color= "F9D2FF"
	meat = /obj/item/stack/sheet/mineral/abductor
	mutant_organs = list(/obj/item/organ/tongue/abductor)
	speedmod = 1
	traits = "As an <span class='danger'>Alien Alloy Golem</span>, you regenerate. You are, however, only able to be heard by other alloy golems!"

/datum/species/golem/alloy/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return
	H.heal_overall_damage(1,1)
	H.adjustToxLoss(-1)
	H.adjustOxyLoss(-1)

/datum/species/golem/wood
	name = "Wooden Golem"
	id = "wood"
	fixed_mut_color = "49311c"
	specflags = list(NOBREATH,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE,NODISMEMBER,MUTCOLORS,PLANT) //Plant reactions and no resisttemp
	meat = /obj/item/stack/sheet/mineral/wood
	armor = 30
	burnmod = 2
	speedmod = 1.5
	var/datum/species/plant/plant //Just pass the procs from phytosians
	traits = "As a <span class='danger'>Wooden Golem</span>, you regenerate in light, but are weak to fire!"

/datum/species/golem/wood/New()
	..()
	plant = new/datum/species/plant()

/datum/species/golem/wood/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	plant.handle_chemicals(chem, H) //All the plant reactions

/datum/species/golem/wood/spec_life(mob/living/carbon/human/H)
	plant.spec_life(H) //Same regen as plants and all

/datum/species/golem/mythril
	name = "Mythril golem"
	id = "mythril"
	fixed_mut_color = "ffa07a"
	meat = /obj/item/stack/sheet/mineral/mythril
	armor = 70
	speedmod = 3
	burnmod = 0.8
	traits = "As a <span class='danger'>Mythril Golem</span>, you can walk through lava and storms like rivers and rain!"

/datum/species/golem/mythril/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.weather_immunities |= "lava"
	C.weather_immunities |= "ash"

/datum/species/golem/mythril/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.weather_immunities -= "ash"
	C.weather_immunities -= "lava"

/datum/species/golem/mythril/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	if(istype(P, /obj/item/projectile/magic))
		playsound(H, "sound/magic/lightningbolt.ogg", 70, 1)
		H.visible_message("<span class='danger'>The [P.name] harmlessly dissipates on [H]'s dense body!</span>")
		return 2

/datum/species/golem/bananium
	name = "Bananium Golem"
	id = "bananium"
	fixed_mut_color = "ff0"
	say_mod = "honks"
	var/obj/item/weapon/implant/sad_trombone/honker
	meat = /obj/item/stack/sheet/mineral/bananium

/datum/species/golem/bananium/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	honker = new/obj/item/weapon/implant/sad_trombone()
	honker.implant(C)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.dna.add_mutation(CLOWNMUT)

/datum/species/golem/bananium/on_species_loss(mob/living/carbon/C)
	. = ..()
	honker.removed(C)
	qdel(honker)
	honker = null
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.dna.remove_mutation(CLOWNMUT)

/datum/species/golem/bananium/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H)
	playsound(get_turf(H), 'sound/items/bikehorn.ogg', 50, 0)
	..()
