//Start with a harness, and are slightly stronger even without one.

//TACTICAL DOLPHIN

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical
	//don't put the name or desc here, leave that in add_harness and remove_harness.
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	speed = 0
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/dolphinmeat = 2, /obj/item/weapon/reagent_containers/food/snacks/syndicake = 1)
	eats = list(/obj/item/weapon/reagent_containers/food/snacks/syndicake = 5)
	AIStatus = AI_OFF
	gold_core_spawnable = 0

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/New()
	..()
	var/obj/item/weapon/storage/tactical_harness/ranged/tmp_harness = new /obj/item/weapon/storage/tactical_harness/ranged/syndicate/dolphin()
	tmp_harness.add_harness(src, null)

//TACTICAL CARP

/mob/living/simple_animal/hostile/carp/tactical
	//don't put the name or desc here, leave that in add_harness and remove_harness.
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	speed = 0
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 2, /obj/item/weapon/reagent_containers/food/snacks/syndicake = 1)
	eats = list(/obj/item/weapon/reagent_containers/food/snacks/syndicake = 5)
	AIStatus = AI_OFF
	gold_core_spawnable = 0

/mob/living/simple_animal/hostile/carp/tactical/New()
	..()
	var/obj/item/weapon/storage/tactical_harness/ranged/tmp_harness = new /obj/item/weapon/storage/tactical_harness/ranged/syndicate/carp()
	tmp_harness.add_harness(src, null)

//TACTICAL CORGI

/mob/living/simple_animal/pet/dog/corgi/tactical
	gold_core_spawnable = 0

/mob/living/simple_animal/pet/dog/corgi/tactical/New()
	..()
	var/obj/item/weapon/storage/tactical_harness/corgi/tmp_harness = new /obj/item/weapon/storage/tactical_harness/corgi()
	tmp_harness.add_harness(src, null)

