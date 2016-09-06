/mob/living/simple_animal/hostile/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard_dead"
	speak_emote = list("hisses")
	health = 5
	maxHealth = 5
	faction = list("Lizard")
	attacktext = "bites"
	attacktext = "bites"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	ventcrawler = 2
	density = 0
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = 2
	environment_smash = 0
	var/list/edibles = list(/mob/living/simple_animal/butterfly, /mob/living/simple_animal/cockroach)

/mob/living/simple_animal/hostile/lizard/CanAttack(atom/the_target)//Can we actually attack a possible target?
	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return 0
	if(can_eat(the_target))
		return 1
	return 0

/mob/living/simple_animal/hostile/lizard/AttackingTarget()
	if(can_eat(target))
		visible_message("[name] consumes [target] in a single gulp", "<span class='notice'>You consume [target] in a single gulp</span>")
		qdel(target) //Nom
		LoseTarget()
		adjustBruteLoss(-2)
	else
		..()

/mob/living/simple_animal/hostile/lizard/proc/can_eat(obj/item/I)
	return is_type_in_list(I, edibles)

/mob/living/simple_animal/hostile/lizard/gex
	name = "Gex"
	desc = "The janitor's pet lizard. Likes to eat trash."
	wanted_objects = list(/obj/item/trash, /obj/item/weapon/grown/bananapeel)
	var/last_health_increase = 0
	var/health_increase_cooldown = 600

/mob/living/simple_animal/hostile/lizard/gex/Life()
	if(world.time - last_health_increase >= health_increase_cooldown)
		if(!search_objects)
			visible_message("<span class='notice'>[src] looks hungry.</span>", "<span class='notice'>You feel hungry.</span>")
		search_objects = 1
	else
		search_objects = 0
	..()

/mob/living/simple_animal/hostile/lizard/gex/can_eat(obj/item/I)
	if(..())
		return 1 //he'll always eat bugs
	if(world.time - last_health_increase < health_increase_cooldown)
		return 0
	return is_type_in_list(I, wanted_objects)

/mob/living/simple_animal/hostile/lizard/gex/AttackingTarget()
	if(can_eat(target))
		visible_message("<span class='notice'>[name] consumes [target] in a single gulp.</span>", "<span class='notice'>You consume [target] in a single gulp.</span>")
		qdel(target)
		LoseTarget()
		if(world.time - last_health_increase >= health_increase_cooldown)
			maxHealth += 1
			last_health_increase = world.time
			search_objects = 0
		adjustBruteLoss(-2)
	else
		..()
