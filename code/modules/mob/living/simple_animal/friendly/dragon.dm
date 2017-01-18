//HOLA MI AMIGOS OLE!

/mob/living/simple_animal/pet/dragon
	name = "Red Dragon"
	desc = "A dragon so red and evil in nature that it makes your blood boil..  or maybe that's just the mask. Beneath its head you see a fancy collar, probably what they used to tame it."
	icon = 'icons/mob/pets.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	health = 110
	maxHealth = 110
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_sound = 'sound/magic/demon_attack1.ogg'
	response_help  = "pets"
	response_disarm = "nudges"
	response_harm   = "kicks"
	speak = list("OLE", "DELICIOUS", "WILL MAKE GOOD SANDWICH", "AHAHAHAHAHA")
	speak_emote = list("hisses", "re-adjusts its mask before yelling")
	emote_hear = list("hisses.", "HISSES.", "hisses a lot.")
	emote_see = list("bathes itself in flames.", "chases its tail.","glares.")
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 2, /obj/item/clothing/mask/luchador/rudos = 1)
	var/mob/living/simple_animal/pet/cat/mimekitty/movement_target
	see_in_dark = 8
	speak_chance = 1
	sentience_type = null // ha no
	turns_per_move = 5
	var/turns_since_scan = 0
	var/following = 0
	gold_core_spawnable = 2



/mob/living/simple_animal/pet/dragon/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("breathes a small circle of fire and rolls in it.", "sharpens its claws.", "swishes its tail around."))

	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/pet/cat/mimekitty/M in view(1,src))
				if(!M.stat && Adjacent(M))
					emote("me", 1, "devours \the [M]!")
					M.gib()
					movement_target = null
					stop_automated_movement = 0
					break
	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/pet/cat/mimekitty/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)

	if (following)
		return ..()
	for(var/mob/living/carbon/M in view(7, src))
		if (istype(M) && M.name == "Red Dragon")
			var/mob/living/target = M
			following = 1
			spawn(0)
				while(target in view(7, src))
					if(!target.Adjacent(src))
						step_to(src,target)
					sleep(3)
				following = 0
			break;
	return ..()

/mob/living/simple_animal/pet/dragon/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent == "harm")
		M << "<span class='warning'>You don't think it'd be wise to attack [src]...</span>"
		return 0
	else
		if(M && stat != DEAD)
			flick_overlay(image('icons/mob/animal.dmi',src,"heart-ani2",MOB_LAYER+1), list(M.client), 20)
			emote("me", 1, "eyes blaze with fire for a moment!")
	. = ..()


/mob/living/simple_animal/pet/dragon/attackby(obj/item/weapon/W, mob/user)
	if(user && stat != DEAD)
		if(istype(W,/obj/item/weapon/card/emag))
			user << "<span class='danger'>You break the mechanism keeping the collar on [src]'s neck.</span>"
			qdel(W)
			new /mob/living/simple_animal/hostile/reddragon(loc)
			qdel(src)
		emote("me",1,"devours the [W].  Its eyes blaze with immense heat...")
		qdel(W)
