#define ASH_WALKER_SPAWN_THRESHOLD 2

//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/mob/living/simple_animal/hostile/spawner/ash_walker
	name = "ash walker nest"
	desc = "A nest built around a necropolis tendril. The eggs seem to grow unnaturally fast..."
	icon = 'icons/mob/nest.dmi'
	icon_state = "ash_walker_nest"
	icon_living = "ash_walker_nest"
	faction = list("ashwalker")
	health = 200
	maxHealth = 200
	loot = list(/obj/effect/gibspawner, /obj/item/device/assembly/signaler/anomaly)
	del_on_death = 1
	var/meat_counter
	var/mob/living/carbon/human/chief = null
	var/weepcycle = 30

/mob/living/simple_animal/hostile/spawner/ash_walker/Life()
	..()
	if(!stat)
		consume()
		spawn_mob()
	if(chief)
		if(chief.stat == DEAD)
			if(prob(rand(5,60)))
				visible_message("<span class='warning'>[src] begins to rock back and forth, and weep in silence. It appears to have lost connection to it's chief.</span>")
			if(weepcycle != 0)
				weepcycle--
			else
				blossom_hero()
				chief = null
				weepcycle = 30

/mob/living/simple_animal/hostile/spawner/ash_walker/proc/consume()
	for(var/mob/living/H in view(src,1)) //Only for corpse right next to/on same tile
		if(H.stat)
			visible_message("<span class='warning'>Serrated tendrils eagerly pull [H] to [src], tearing the body apart as its blood seeps over the eggs.</span>")
			playsound(get_turf(src),'sound/magic/Demon_consume.ogg', 100, 1)
			if(istype(H,/mob/living/simple_animal/hostile/megafauna/dragon))
				meat_counter += 20
			else if(ischiefwalker(H)) // the nest has reconnected with the chief, reuniting them one final time. or with another random chief walker that'll help them get over their former bond.
				if(weepcycle) // either way it won't eat the meat
					if(weepcycle > 5)
						weepcycle -= 5
					else
						weepcycle = 0
			else
				meat_counter ++
			for(var/obj/item/W in H)
				H.unEquip(W)
			H.gib()

/mob/living/simple_animal/hostile/spawner/ash_walker/spawn_mob()
	if(meat_counter >= ASH_WALKER_SPAWN_THRESHOLD)
		new /obj/effect/mob_spawn/human/ash_walker(get_step(src.loc, SOUTH))
		visible_message("<span class='danger'>One of the eggs swells to an unnatural size and tumbles free. It's ready to hatch!</span>")
		meat_counter -= ASH_WALKER_SPAWN_THRESHOLD

/mob/living/simple_animal/hostile/spawner/ash_walker/New()
	..()
	blossom_hero()

/mob/living/simple_animal/hostile/spawner/ash_walker/proc/blossom_hero()
	var/turf/T = get_turf(src)
	var/obj/effect/mob_spawn/human/ash_walker/chief/hero = new(src.loc)
	hero.loc = T
	hero.nest = src