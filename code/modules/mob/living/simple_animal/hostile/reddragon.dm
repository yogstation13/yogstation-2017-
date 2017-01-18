/mob/living/simple_animal/hostile/reddragon
	name = "Red Dragon"
	desc = "A dragon so red and evil in nature that it makes your blood boil..  or maybe that's just the mask. It seems pretty pissed off."
	health = 220
	maxHealth = 220
	attacktext = "chomps"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	friendly = "stares down"
	icon = 'icons/mob/pets.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	weather_immunities = list("lava","ash")
	speak_emote = list("roars")
	melee_damage_lower = 15
	melee_damage_upper = 15
	speed = 1
	move_to_delay = 10
	ranged = 1
	flying = 1
	aggro_vision_range = 9
	idle_vision_range = 5
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 2, /obj/item/clothing/mask/luchador/rudos = 1)
	var/anger_modifier = 0
	var/swooping = 0
	var/swoop_cooldown = 0
	death_sound = 'sound/magic/demon_dies.ogg'



/mob/living/simple_animal/hostile/reddragon/adjustHealth(amount)
	if(swooping)
		return 0
	return ..()

/mob/living/simple_animal/hostile/reddragon/AttackingTarget()
	if(swooping)
		return
	else
		..()
		if(isliving(target))
			var/mob/living/L = target
			if(L.stat == DEAD)
				src.visible_message(
					"<span class='danger'>[src] devours [L]!</span>",
					"<span class='userdanger'>You feast on [L], restoring your health!</span>")
				adjustBruteLoss(-30)
				L.gib()

/mob/living/simple_animal/hostile/reddragon/Process_Spacemove(movement_dir = 0)
	return 1

/obj/effect/overlay/temp/fireball
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "fireball"
	name = "fireball"
	desc = "Get out of the way!"
	layer = FLY_LAYER
	randomdir = 0
	duration = 10
	pixel_z = 500

/obj/effect/overlay/temp/target
	icon = 'icons/mob/actions.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	luminosity = 2
	duration = 10

/obj/effect/overlay/temp/dragon_swoop
	name = "certain death"
	desc = "Don't just stand there, move!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "rune_large"
	layer = BELOW_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
	color = "#FF0000"
	duration = 10

/obj/effect/overlay/temp/target/ex_act()
	return

/obj/effect/overlay/temp/target/New()
	..()
	spawn()
		var/turf/T = get_turf(src)
		playsound(get_turf(src),'sound/magic/Fireball.ogg', 200, 1)
		var/obj/effect/overlay/temp/fireball/F = new(src.loc)
		animate(F, pixel_z = 0, time = 12)
		sleep(12)
		explosion(T, 0, 0, 1, 0, 0, 0, 1)
		qdel(F)
		qdel(src)

/mob/living/simple_animal/hostile/reddragon/OpenFire()
	anger_modifier = Clamp(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + ranged_cooldown_time

	if(prob(15 + anger_modifier) && !client)
		if(health < maxHealth/2)
			swoop_attack(1)
		else
			fire_rain()

	else if(prob(10+anger_modifier) && !client && !swooping)
		if(health > maxHealth/2)
			swoop_attack()
		else
			swoop_attack()
			swoop_attack()
			swoop_attack()
	else
		fire_walls()

/mob/living/simple_animal/hostile/reddragon/proc/fire_rain()
	src.say("LET'S SPICE IT UP A LITTLE OLE!")
	visible_message("<span class='danger'>Fire rains from the sky!</span>")
	for(var/turf/turf in range(6,get_turf(src)))
		if(prob(10))
			new /obj/effect/overlay/temp/target(turf)

/mob/living/simple_animal/hostile/reddragon/proc/fire_walls()
	var/list/attack_dirs = list(NORTH,EAST,SOUTH,WEST)
	if(prob(50))
		attack_dirs = list(NORTH,WEST,SOUTH,EAST)
	playsound(get_turf(src),'sound/magic/Fireball.ogg', 200, 1)

	for(var/d in attack_dirs)
		spawn(0)
			var/turf/E = get_edge_target_turf(src, d)
			var/range = 4
			for(var/turf/open/J in getline(src,E))
				if(!range)
					break
				range--
				PoolOrNew(/obj/effect/hotspot,J)
				J.hotspot_expose(700,50,1)
				for(var/mob/living/L in J)
					if(L != src)
						L.adjustFireLoss(10)
						L << "<span class='danger'>You're hit by the absolutely horrifying drake's fire breath!</span>"
				sleep(1)

/mob/living/simple_animal/hostile/reddragon/proc/swoop_attack(fire_rain = 0, atom/movable/manual_target)
	if(stat || swooping)
		return
	swoop_cooldown = world.time + 200
	var/swoop_target
	if(manual_target)
		swoop_target = manual_target
	else
		swoop_target = target
	stop_automated_movement = TRUE
	swooping = 1
	density = 0
	icon_state = "swoop"
	visible_message("<span class='danger'>[src] swoops up high!</span>")
	if(prob(50))
		animate(src, pixel_x = 500, pixel_z = 500, time = 10)
	else
		animate(src, pixel_x = -500, pixel_z = 500, time = 10)
	sleep(30)

	var/turf/tturf
	if(fire_rain)
		fire_rain()

	icon_state = "dragon"
	if(swoop_target)
		tturf = get_turf(swoop_target)
	else
		tturf = get_turf(src)
	forceMove(tturf)
	new/obj/effect/overlay/temp/dragon_swoop(tturf)
	animate(src, pixel_x = 0, pixel_z = 0, time = 15)
	sleep(15)
	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 200, 1)
	for(var/mob/living/L in range(1,tturf))
		if(L == src)
			continue
		if(L.stat)
			visible_message("<span class='danger'>[src] slams down on [L], bouncing off of them!</span>")
		else
			var/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
			L.adjustBruteLoss(25)
			L.throw_at_fast(throwtarget)
			visible_message("<span class='danger'>[L] is thrown clear of [src]!</span>")
	for(var/mob/M in range(4,src))
		shake_camera(M, 15, 1)

	stop_automated_movement = FALSE
	swooping = 0
	density = 1

/mob/living/simple_animal/hostile/reddragon/AltClickOn(atom/movable/A)
	if(!istype(A))
		return
	if(swoop_cooldown >= world.time)
		src << "You need to wait 20 seconds between swoop attacks!"
		return
	swoop_attack(1, A)
