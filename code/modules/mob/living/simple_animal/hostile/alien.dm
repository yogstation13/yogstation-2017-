#define ALIEN_HAUL_ASS 1

/mob/living/simple_animal/hostile/alien
	name = "alien hunter"
	desc = "A toothy, musclebound predator."
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_s"
	icon_living = "alienh_s"
	icon_dead = "alienh_dead"
	icon_gib = "syndicate_gib"
	response_help = "pets"
	response_disarm = "shoves"
	response_harm = "slaps"
	speed = 0
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 2,
							/obj/item/stack/sheet/animalhide/xeno = 2,
							/obj/item/organ/alien/plasmavessel/small/tiny = 1,
							/obj/item/organ/alien/hivenode = 1)
	maxHealth = 150
	health = 150
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashes"
	speak_emote = list("hisses")
	bubble_icon = "alien"
	a_intent = "harm"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	damage_coeff = list(BRUTE = 1, BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	unsuitable_atmos_damage = 15
	faction = list("alien")
	status_flags = list(CANPUSH)
	minbodytemp = 0
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_MINIMUM
	unique_name = 1
	gold_core_spawnable = 0
	death_sound = 'sound/voice/hiss6.ogg'
	candismember = TRUE
	force_threshold = 3
	deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw..."
	var/alien_state

/mob/living/simple_animal/hostile/alien/drone
	name = "alien drone"
	desc = "The drone variant of the xenomorph caste. Weaker physically, but by no means less dangerous."
	icon_state = "aliend_s"
	icon_living = "aliend_s"
	icon_dead = "aliend_dead"
	health = 100
	maxHealth = 100
	melee_damage_lower = 10
	melee_damage_upper = 10
	retreat_distance = 2
	minimum_distance = 2
	var/plant_cooldown = 30
	var/plants_off = 0
	ranged = 1
	candismember = FALSE //weak drones
	projectiletype = /obj/item/projectile/neurotox/superlight

	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 2,
							/obj/item/stack/sheet/animalhide/xeno = 1,
							/obj/item/organ/alien/plasmavessel/small = 1,
							/obj/item/organ/alien/hivenode = 1,
							/obj/item/organ/alien/resinspinner = 1)

/mob/living/simple_animal/hostile/alien/drone/handle_automated_action()
	if(!..()) //AIStatus is off
		return
	plant_cooldown--
	if(AIStatus == AI_IDLE)
		if(!plants_off && prob(10) && plant_cooldown<=0)
			plant_cooldown = initial(plant_cooldown)
			SpreadPlants()

/mob/living/simple_animal/hostile/alien/drone/adjustHealth(amount)
	. = ..()
	if(health < (maxHealth/3))
		alien_state = ALIEN_HAUL_ASS
	else
		alien_state = 0

/mob/living/simple_animal/hostile/alien/drone/Life()
	. = ..()
	if(.)
		if(alien_state == ALIEN_HAUL_ASS)
			retreat_distance = 9
			minimum_distance = 9
		else
			retreat_distance = initial(retreat_distance)
			minimum_distance = initial(minimum_distance)

/mob/living/simple_animal/hostile/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_s"
	icon_living = "aliens_s"
	icon_dead = "aliens_dead"
	desc = "The hive-guardian caste of the xenomorph species. Has very accurate spit."
	health = 200
	maxHealth = 200
	melee_damage_lower = 19
	melee_damage_upper = 19
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 2,
							/obj/item/stack/sheet/animalhide/xeno = 1,
							/obj/item/organ/alien/plasmavessel/small = 1,
							/obj/item/organ/alien/hivenode = 1,
							/obj/item/organ/alien/acid = 1,
							/obj/item/organ/alien/neurotoxin = 1)



/mob/living/simple_animal/hostile/alien/queen
	name = "alien queen"
	icon_state = "alienq_s"
	icon_living = "alienq_s"
	icon_dead = "alienq_dead"
	health = 250
	maxHealth = 250
	desc = "The big momma. Lays eggs, plants weeds, and takes no shit."
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5
	move_to_delay = 4
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 4,
							/obj/item/stack/sheet/animalhide/xeno = 2)
	projectiletype = /obj/item/projectile/neurotox/heavy
	projectilesound = 'sound/weapons/pierce.ogg'
	status_flags = list()
	unique_name = 0
	var/sterile = 0
	var/plants_off = 0
	var/egg_cooldown = 30
	var/plant_cooldown = 30
	environment_smash = 2

/mob/living/simple_animal/hostile/alien/proc/SpreadPlants()
	if(!isturf(loc) || istype(loc, /turf/open/space))
		return
	if(locate(/obj/structure/alien/weeds/node) in get_turf(src))
		return
	visible_message("<span class='alertalien'>[src] has planted some alien weeds!</span>")
	new /obj/structure/alien/weeds/node(loc)

/mob/living/simple_animal/hostile/alien/proc/LayEggs()
	if(!isturf(loc) || istype(loc, /turf/open/space))
		return
	if(locate(/obj/structure/alien/egg) in get_turf(src))
		return
	visible_message("<span class='alertalien'>[src] has laid an egg!</span>")
	new /obj/structure/alien/egg(loc)

/mob/living/simple_animal/hostile/alien/queen/large
	name = "alien empress"
	icon = 'icons/mob/alienqueen.dmi'
	icon_state = "alienq"
	icon_living = "alienq"
	icon_dead = "alienq_dead"
	bubble_icon = "alienroyal"
	desc = "The bigger momma. Rules over all the queens below it, and their hives by extention. Hobbies include: murder."
	move_to_delay = 4
	maxHealth = 600
	health = 600
	environment_smash = 3
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 10,
							/obj/item/stack/sheet/animalhide/xeno = 2,
							/obj/item/organ/alien/plasmavessel/large/queen = 1,
							/obj/item/organ/alien/hivenode = 1,
							/obj/item/organ/alien/resinspinner = 1,
							/obj/item/organ/alien/acid = 1,
							/obj/item/organ/alien/neurotoxin = 1,
							/obj/item/organ/alien/eggsac = 1,
							/obj/item/organ/brain/alien = 1) //only the queen is smart
	mob_size = MOB_SIZE_LARGE
	gold_core_spawnable = 0
	candismember = TRUE
	force_threshold = 8
	var/obj/effect/proc_holder/spell/aoe_turf/repulse/xeno/simplemob/bitchslap

/mob/living/simple_animal/hostile/alien/queen/large/New()
	..()
	bitchslap = new /obj/effect/proc_holder/spell/aoe_turf/repulse/xeno/simplemob()
	AddSpell(bitchslap)

/mob/living/simple_animal/hostile/alien/queen/large/adjustHealth(amount)
	. = ..()
	if(health < (maxHealth/3))
		summon_backup(30)
		visible_message("<span class='alertalien'>[src] lets out a shrill scream!</span>")
		playsound(src.loc, 'sound/voice/hiss5.ogg', 40, 1, 1)
		if(bitchslap)
			if(bitchslap.cast_check(0, src))
				bitchslap.choose_targets(src)
	else
		return

/mob/living/simple_animal/hostile/alien/queen/large/handle_automated_action()
	if(!..()) //AIStatus is off
		return
	egg_cooldown--
	plant_cooldown--
	if(AIStatus == AI_IDLE)
		if(!plants_off && prob(10) && plant_cooldown<=0)
			plant_cooldown = initial(plant_cooldown)
			SpreadPlants()
		if(!sterile && prob(10) && egg_cooldown<=0)
			egg_cooldown = initial(egg_cooldown)
			LayEggs()
	if(AIStatus == AI_ON)
		if(health < (maxHealth/3) && prob (20))
			if(bitchslap.cast_check(0, src))
				bitchslap.choose_targets(src)

/obj/effect/proc_holder/spell/aoe_turf/repulse/xeno/simplemob
	charge_max = 100
	cooldown_min = 100
	player_lock = 0


/mob/living/simple_animal/hostile/alien/praetorian
	name = "alien praetorian"
	desc = "The Empress' guardian slash fuckbuddy, if certain low quality magazines are to be believed."
	icon_state = "alienp"
	icon_living = "alienp"
	icon_dead = "alienp_dead"
	bubble_icon = "alien_royal"
	move_to_delay = 3
	maxHealth = 450
	health = 450
	environment_smash = 2
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 5,
							/obj/item/stack/sheet/animalhide/xeno = 2,
							/obj/item/organ/alien/plasmavessel = 1,
							/obj/item/organ/alien/hivenode = 1,
							/obj/item/organ/alien/resinspinner = 1,
							/obj/item/organ/alien/acid = 1,
							/obj/item/organ/alien/neurotoxin = 1)
	projectilesound = 'sound/weapons/pierce.ogg'
	projectiletype = /obj/item/projectile/neurotox/heavy
	status_flags = list()
	ranged = 1
	retreat_distance = 1

/obj/item/projectile/neurotox //base format,
	name = "neurotoxin"
	damage = 30
	icon_state = "toxin"

/obj/item/projectile/neurotox/superlight //drones, self defense
	name = "neurotoxin spatter"
	damage = 15
	icon_state = "toxin"
	stamina = 10

/obj/item/projectile/neurotox/heavy //queens and prae, purely lethal
	name = "heavy neurotoxin"
	damage = 45
	icon_state = "toxin"
	armour_penetration = 40

/obj/item/projectile/neurotox/admin //murderboning admins
	name = "absurdly overpowered acid"
	damage = 200
	icon_state = "toxin"

/mob/living/simple_animal/hostile/alien/handle_temperature_damage()
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(0) //aliens don't care about cold
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(20)

/mob/living/simple_animal/hostile/alien/maid
	name = "lusty xenomorph maid"
	melee_damage_lower = 0
	melee_damage_upper = 0
	a_intent = "help"
	friendly = "caresses"
	desc = "This ambitious xenomorph's gotten a job and moved out from home. They get letters weekly from their mother, signed in human blood."
	environment_smash = 0
	gold_core_spawnable = 1
	icon_state = "maid"
	icon_living = "maid"
	icon_dead = "maid_dead"
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 1,
							/obj/item/stack/sheet/animalhide/xeno = 1,
							/obj/item/organ/brain/alien = 1, //alien maids are also really smart as well, but the economic downturn is hard on everyone. 5 years at xeno college and a masters in egg laying for a part time job cleaning floors.
							/obj/item/weapon/reagent_containers/glass/rag = 1)


/mob/living/simple_animal/hostile/alien/maid/AttackingTarget()
	if(istype(target, /atom/movable))
		if(istype(target, /obj/effect/decal/cleanable))
			visible_message("[src] cleans up \the [target].")
			qdel(target)
			return
		var/atom/movable/M = target
		M.clean_blood()
		visible_message("[src] polishes \the [target].")

/mob/living/simple_animal/hostile/alien/maid/adjustHealth(amount)
	. = ..()
	if(stat == DEAD)
		desc = "Rest in peace, lusty xenomorph. It only ever wanted to polish the captain's laser."
	else
		desc = initial(desc)

#undef ALIEN_HAUL_ASS
