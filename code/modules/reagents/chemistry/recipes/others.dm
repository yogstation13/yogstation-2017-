
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("ethanol" = 1, "charcoal" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/spraytan
	name = "Spray Tan"
	id = "spraytan"
	result = "spraytan"
	required_reagents = list("orangejuice" = 1, "oil" = 1)
	result_amount = 2

/datum/chemical_reaction/spraytan2
	name = "Spray Tan"
	id = "spraytan"
	result = "spraytan"
	required_reagents = list("orangejuice" = 1, "cornoil" = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("water" = 1, "sodium" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/plasmasolidification
	name = "Solid Plasma"
	id = "solidplasma"
	result = null
	required_reagents = list("iron" = 5, "frostoil" = 5, "plasma" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/plasmasolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/plasma(location)
	return

/datum/chemical_reaction/capsaicincondensation
	name = "Capsaicincondensation"
	id = "capsaicincondensation"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 1, "ethanol" = 5)
	result_amount = 5

/datum/chemical_reaction/soapification
	name = "Soapification"
	id = "soapification"
	result = null
	required_reagents = list("liquidgibs" = 10, "lye"  = 10) // requires two scooped gib tiles
	required_temp = 374
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/soapification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/weapon/soap/homemade(location)
	return

/datum/chemical_reaction/candlefication
	name = "Candlefication"
	id = "candlefication"
	result = null
	required_reagents = list("liquidgibs" = 5, "oxygen"  = 5) //
	required_temp = 374
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/candlefication/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/candle(location)
	return

/datum/chemical_reaction/meatification
	name = "Meatification"
	id = "meatification"
	result = null
	required_reagents = list("liquidgibs" = 10, "nutriment" = 10, "carbon" = 10)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/meatification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/meatproduct(location)
	return

/datum/chemical_reaction/carbondioxide
	name = "Direct Carbon Oxidation"
	id = "burningcarbon"
	result = "co2"
	required_reagents = list("carbon" = 1, "oxygen" = 2)
	required_temp = 777 // pure carbon isn't especially reactive.
	result_amount = 3

////////////////////////////////// VIROLOGY //////////////////////////////////////////

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	result_amount = 15
	required_reagents = list("water" = 5, "milk" = 5)

/datum/chemical_reaction/virus_food_mutagen
	name = "mutagenic agar"
	id = "mutagenvirusfood"
	result = "mutagenvirusfood"
	result_amount = 1
	required_reagents = list("mutagen" = 1, "virusfood" = 1)

/datum/chemical_reaction/virus_food_synaptizine
	name = "virus rations"
	id = "synaptizinevirusfood"
	result ="synaptizinevirusfood"
	result_amount = 1
	required_reagents = list("synaptizine" = 1, "virusfood" = 1)

/datum/chemical_reaction/virus_food_plasma
	name = "virus plasma"
	id = "plasmavirusfood"
	result = "plasmavirusfood"
	result_amount = 1
	required_reagents = list("plasma" = 1, "virusfood" = 1)

/datum/chemical_reaction/virus_food_plasma_synaptizine
	name = "weakened virus plasma"
	id = "weakplasmavirusfood"
	result = "weakplasmavirusfood"
	result_amount = 2
	required_reagents = list("synaptizine" = 1, "plasmavirusfood" = 1)

/datum/chemical_reaction/virus_food_mutagen_sugar
	name = "sucrose agar"
	id = "sugarvirusfood"
	result = "sugarvirusfood"
	result_amount = 2
	required_reagents = list("sugar" = 1, "mutagenvirusfood" = 1)

/datum/chemical_reaction/virus_food_mutagen_salineglucose
	name = "sucrose agar"
	id = "salineglucosevirusfood"
	result = "sugarvirusfood"
	result_amount = 2
	required_reagents = list("salglu_solution" = 1, "mutagenvirusfood" = 1)

/datum/chemical_reaction/virus_food_uranium
	name = "Decaying uranium gel"
	id = "uraniumvirusfood"
	result = "uraniumvirusfood"
	result_amount = 1
	required_reagents = list("uranium" = 1, "virusfood" = 1)

/datum/chemical_reaction/virus_food_uranium_plasma
	name = "Unstable uranium gel"
	id = "uraniumvirusfood_plasma"
	result = "uraniumplasmavirusfood_unstable"
	result_amount = 1
	required_reagents = list("uranium" = 5, "plasmavirusfood" = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_gold
	name = "Stable uranium gel"
	id = "uraniumvirusfood_gold"
	result = "uraniumplasmavirusfood_stable"
	result_amount = 1
	required_reagents = list("uranium" = 10, "gold" = 10, "plasma" = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_silver
	name = "Stable uranium gel"
	id = "uraniumvirusfood_silver"
	result = "uraniumplasmavirusfood_stable"
	result_amount = 1
	required_reagents = list("uranium" = 10, "silver" = 10, "plasma" = 1)

/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	result = "blood"
	required_reagents = list("virusfood" = 1)
	required_catalysts = list("blood" = 1)
	var/level_min = 0
	var/level_max = 2

/datum/chemical_reaction/mix_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level_min, level_max)


/datum/chemical_reaction/mix_virus/mix_virus_2

	name = "Mix Virus 2"
	id = "mixvirus2"
	required_reagents = list("mutagen" = 1)
	level_min = 2
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_3

	name = "Mix Virus 3"
	id = "mixvirus3"
	required_reagents = list("plasma" = 1)
	level_min = 4
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_4

	name = "Mix Virus 4"
	id = "mixvirus4"
	required_reagents = list("uranium" = 1)
	level_min = 5
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_5

	name = "Mix Virus 5"
	id = "mixvirus5"
	required_reagents = list("mutagenvirusfood" = 1)
	level_min = 3
	level_max = 3

/datum/chemical_reaction/mix_virus/mix_virus_6

	name = "Mix Virus 6"
	id = "mixvirus6"
	required_reagents = list("sugarvirusfood" = 1)
	level_min = 4
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_7

	name = "Mix Virus 7"
	id = "mixvirus7"
	required_reagents = list("weakplasmavirusfood" = 1)
	level_min = 5
	level_max = 5

/datum/chemical_reaction/mix_virus/mix_virus_8

	name = "Mix Virus 8"
	id = "mixvirus8"
	required_reagents = list("plasmavirusfood" = 1)
	level_min = 6
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_9

	name = "Mix Virus 9"
	id = "mixvirus9"
	required_reagents = list("synaptizinevirusfood" = 1)
	level_min = 1
	level_max = 1

/datum/chemical_reaction/mix_virus/mix_virus_10

	name = "Mix Virus 10"
	id = "mixvirus10"
	required_reagents = list("uraniumvirusfood" = 1)
	level_min = 6
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_11

	name = "Mix Virus 11"
	id = "mixvirus11"
	required_reagents = list("uraniumplasmavirusfood_unstable" = 1)
	level_min = 7
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_12

	name = "Mix Virus 12"
	id = "mixvirus12"
	required_reagents = list("uraniumplasmavirusfood_stable" = 1)
	level_min = 8
	level_max = 8

/datum/chemical_reaction/mix_virus/rem_virus

	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list("synaptizine" = 1)
	required_catalysts = list("blood" = 1)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()

		////////////////////////////////// Mutation Toxins ///////////////////////////////////

/datum/chemical_reaction/stable_mutation_toxin
	name = "Stable Mutation Toxin"
	id = "stablemutationtoxin"
	result = "stablemutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "blood" = 1) //classic

/datum/chemical_reaction/lizard_mutation_toxin
	name = "Lizard Mutation Toxin"
	id = "lizardmutationtoxin"
	result = "lizardmutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "radium" = 1) //mutant

/datum/chemical_reaction/fly_mutation_toxin
	name = "Fly Mutation Toxin"
	id = "flymutationtoxin"
	result = "flymutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "mutagen" = 1) //VERY mutant

/datum/chemical_reaction/lizardfly_mutation_toxin
	name = "Unafly Mutation Toxin"
	id = "unaflymutationtoxin"
	result = "unaflymutationtoxin"
	result_amount = 1
	required_reagents = list("flymutationtoxin" = 1, "lizardmutationtoxin" = 1)

/datum/chemical_reaction/android_mutation_toxin
	name = "Android Mutation Toxin"
	id = "androidmutationtoxin"
	result = "androidmutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "teslium" = 1) //beep boop

/datum/chemical_reaction/androidfly_mutation_toxin
	name = "Flyternis Mutation Toxin"
	id = "flyternismutationtoxin"
	result = "flyternismutationtoxin"
	result_amount = 1
	required_reagents = list("flymutationtoxin" = 1, "androidmutationtoxin" = 1)

/datum/chemical_reaction/plant_mutation_toxin
	name = "Phytosian Mutation Toxin"
	id = "phytosianmutationtoxin"
	result = "phytosianmutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "robustharvestnutriment" = 1)

/datum/chemical_reaction/flytosian_mutation_toxin
	name = "Flytosian Mutation Toxin"
	id = "flytosianmutationtoxin"
	result = "flytosianmutationtoxin"
	result_amount = 1
	required_reagents = list("flymutationtoxin" = 1, "phytosianmutationtoxin" = 1)


/datum/chemical_reaction/jelly_mutation_toxin
	name = "Imperfect Mutation Toxin"
	id = "jellymutationtoxin"
	result = "jellymutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "slimejelly" = 1) //why would you even make this

/datum/chemical_reaction/abductor_mutation_toxin
	name = "Abductor Mutation Toxin"
	id = "abductormutationtoxin"
	result = "abductormutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "morphine" = 1)


/datum/chemical_reaction/pod_mutation_toxin
	name = "Podperson Mutation Toxin"
	id = "podmutationtoxin"
	result = "podmutationtoxin"
	result_amount = 1
	required_reagents = list("unstablemutationtoxin" = 1, "eznutriment" = 1) //plant food

/datum/chemical_reaction/golem_mutation_toxin
	name = "Golem Mutation Toxin"
	id = "golemmutationtoxin"
	result = "golemmutationtoxin"
	required_reagents = list("unstablemutationtoxin" = 1, "silver" = 1) //not too hard to get but also not just there in xenobio
	result_amount = 1

/datum/chemical_reaction/synth_mutation_toxin
	name = "Synth Mutation Toxin"
	id = "synthmutationtoxin"
	result = "synthmutationtoxin"
	required_reagents = list("androidmutationtoxin" = 1, "teslium" = 1)
	result_amount = 1


//BLACKLISTED RACES
/datum/chemical_reaction/skeleton_mutation_toxin
	name = "Skeleton Mutation Toxin"
	id = "skeletonmutationtoxin"
	result = "skeletonmutationtoxin"
	required_reagents = list("amutationtoxin" = 1, "milk" = 1) //good for yer bones
	result_amount = 1

/datum/chemical_reaction/zombie_mutation_toxin
	name = "Zombie Mutation Toxin"
	id = "zombiemutationtoxin"
	result = "zombiemutationtoxin"
	required_reagents = list("amutationtoxin" = 1, "toxin" = 1)
	result_amount = 1

/datum/chemical_reaction/ash_mutation_toxin //ash lizard
	name = "Ash Mutation Toxin"
	id = "ashmutationtoxin"
	result = "ashmutationtoxin"
	required_reagents = list("amutationtoxin" = 1, "lizardmutationtoxin" = 1, "ash" = 1)
	result_amount = 1


//DANGEROUS RACES
/datum/chemical_reaction/plasma_mutation_toxin
	name = "Plasma Mutation Toxin"
	id = "plasmamutationtoxin"
	result = "plasmamutationtoxin"
	result_amount = 1
	required_reagents = list("skeletonmutationtoxin" = 1, "plasma" = 1, "uranium" = 1) //this is very fucking powerful, so it's hard to make

/datum/chemical_reaction/shadow_mutation_toxin
	name = "Shadow Mutation Toxin"
	id = "shadowmutationtoxin"
	result = "shadowmutationtoxin"
	required_reagents = list("amutationtoxin" = 1, "liquid_dark_matter" = 1, "holywater" = 1)
	result_amount = 1

//Technically a mutation toxin
/datum/chemical_reaction/mulligan
	name = "Mulligan"
	id = "mulligan"
	result = "mulligan"
	required_reagents = list("humanmutationtoxin" = 1, "mutagen" = 1)
	result_amount = 1




////////////////////////////////// foam and foam precursor ///////////////////////////////////////////////////


/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5


/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2
	mob_react = 1

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='danger'>The solution spews out foam!</span>")
	var/datum/effect_system/foam_spread/s = new()
	s.set_up(created_volume, location, holder)
	s.start()
	holder.clear_reagents()
	return


/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminium" = 3, "foaming_agent" = 1, "facid" = 1)
	result_amount = 5
	mob_react = 1

/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='danger'>The solution spews out a metallic foam!</span>")

	var/datum/effect_system/foam_spread/metal/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "facid" = 1)
	result_amount = 5
	mob_react = 1

/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='danger'>The solution spews out a metallic foam!</span>")
	var/datum/effect_system/foam_spread/metal/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1


/////////////////////////////// Cleaning and hydroponics /////////////////////////////////////////////////

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	result = "weedkiller"
	required_reagents = list("toxin" = 1, "ammonia" = 4)
	result_amount = 5

/datum/chemical_reaction/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	result = "pestkiller"
	required_reagents = list("toxin" = 1, "ethanol" = 4)
	result_amount = 5

/datum/chemical_reaction/drying_agent
	name = "Drying agent"
	id = "drying_agent"
	result = "drying_agent"
	required_reagents = list("stable_plasma" = 2, "ethanol" = 1, "sodium" = 1)
	result_amount = 3

//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	name = "acetone"
	id = "acetone"
	result = "acetone"
	required_reagents = list("oil" = 1, "welding_fuel" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/carpet
	name = "carpet"
	id = "carpet"
	result = "carpet"
	required_reagents = list("space_drugs" = 1, "blood" = 1)
	result_amount = 2


/datum/chemical_reaction/oil
	name = "Oil"
	id = "oil"
	result = "oil"
	required_reagents = list("welding_fuel" = 1, "carbon" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/phenol
	name = "phenol"
	id = "phenol"
	result = "phenol"
	required_reagents = list("water" = 1, "chlorine" = 1, "oil" = 1)
	result_amount = 3

/datum/chemical_reaction/ash
	name = "Ash"
	id = "ash"
	result = "ash"
	required_reagents = list("oil" = 1)
	result_amount = 1
	required_temp = 480

/datum/chemical_reaction/colorful_reagent
	name = "colorful_reagent"
	id = "colorful_reagent"
	result = "colorful_reagent"
	required_reagents = list("stable_plasma" = 1, "radium" = 1, "space_drugs" = 1, "cryoxadone" = 1, "triple_citrus" = 1)
	result_amount = 5

/datum/chemical_reaction/life
	name = "Life"
	id = "life"
	result = null
	required_reagents = list("strange_reagent" = 1, "synthflesh" = 1, "blood" = 1)
	result_amount = 1
	required_temp = 374

/datum/chemical_reaction/life/on_reaction(datum/reagents/holder, created_volume)
	chemical_mob_spawn(holder, 1, "Life")

/datum/chemical_reaction/corgium
	name = "corgium"
	id = "corgium"
	result = null
	required_reagents = list("nutriment" = 1, "colorful_reagent" = 1, "strange_reagent" = 1, "blood" = 1)
	result_amount = 1
	required_temp = 374

/datum/chemical_reaction/corgium/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /mob/living/simple_animal/pet/dog/corgi(location)
	..()

/datum/chemical_reaction/hair_dye
	name = "hair_dye"
	id = "hair_dye"
	result = "hair_dye"
	required_reagents = list("colorful_reagent" = 1, "radium" = 1, "space_drugs" = 1)
	result_amount = 5

/datum/chemical_reaction/barbers_aid
	name = "barbers_aid"
	id = "barbers_aid"
	result = "barbers_aid"
	required_reagents = list("carpet" = 1, "radium" = 1, "space_drugs" = 1)
	result_amount = 5

/datum/chemical_reaction/concentrated_barbers_aid
	name = "concentrated_barbers_aid"
	id = "concentrated_barbers_aid"
	result = "concentrated_barbers_aid"
	required_reagents = list("barbers_aid" = 1, "mutagen" = 1)
	result_amount = 2

/datum/chemical_reaction/saltpetre
	name = "saltpetre"
	id = "saltpetre"
	result = "saltpetre"
	required_reagents = list("potassium" = 1, "nitrogen" = 1, "oxygen" = 3)
	result_amount = 3

/datum/chemical_reaction/lye
	name = "lye"
	id = "lye"
	result = "lye"
	required_reagents = list("sodium" = 1, "hydrogen" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/lye2
	name = "lye"
	id = "lye"
	result = "lye"
	required_reagents = list("ash" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/royal_bee_jelly
	name = "royal bee jelly"
	id = "royal_bee_jelly"
	result = "royal_bee_jelly"
	required_reagents = list("mutagen" = 10, "honey" = 40)
	result_amount = 5

/datum/chemical_reaction/laughter
	name = "laughter"
	id = "laughter"
	result = "laughter"
	required_reagents = list("banana" = 1, "sugar" = 1)
	result_amount = 2
