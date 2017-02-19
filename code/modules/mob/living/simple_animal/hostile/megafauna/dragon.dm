/mob/living/simple_animal/hostile/megafauna/dragon
	name = "ash drake"
	desc = "Guardians of the necropolis."
	health = 2500
	maxHealth = 2500
	attacktext = "chomps"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	friendly = "stares down"
	icon = 'icons/mob/lavaland/dragon.dmi'
	faction = list("mining")
	weather_immunities = list("lava","ash")
	speak_emote = list("roars")
	armour_penetration = 40
	melee_damage_lower = 40
	melee_damage_upper = 40
	speed = 1
	move_to_delay = 10
	ranged = 1
	flying = 1
	mob_size = MOB_SIZE_LARGE
	pixel_x = -16
	aggro_vision_range = 18
	idle_vision_range = 5
	loot = list(/obj/structure/closet/crate/necropolis/dragon)
	butcher_results = list(/obj/item/weapon/ore/diamond = 5, /obj/item/stack/sheet/sinew = 5, /obj/item/stack/sheet/animalhide/ashdrake = 10, /obj/item/stack/sheet/bone = 30)
	var/anger_modifier = 0
	var/obj/item/device/gps/internal
	var/swooping = 0
	var/swoop_cooldown = 0
	var/ability_scaling = 1
	deathmessage = "collapses into a pile of bones, its flesh sloughing away."
	death_sound = 'sound/magic/demon_dies.ogg'
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)

/mob/living/simple_animal/hostile/megafauna/dragon/New()
	..()
	internal = new/obj/item/device/gps/internal/lavaland/dragon(src)

/mob/living/simple_animal/hostile/megafauna/dragon/Destroy()
	qdel(internal)
	. = ..()

/mob/living/simple_animal/hostile/megafauna/dragon/adjustHealth(amount)
	if(swooping)
		return 0
	return ..()

/mob/living/simple_animal/hostile/megafauna/dragon/AttackingTarget()
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
				adjustBruteLoss(-L.maxHealth/2)
				L.gib()

/mob/living/simple_animal/hostile/megafauna/dragon/Process_Spacemove(movement_dir = 0)
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

/mob/living/simple_animal/hostile/megafauna/dragon/OpenFire()
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

/mob/living/simple_animal/hostile/megafauna/dragon/proc/fire_rain()
	visible_message("<span class='danger'>Fire rains from the sky!</span>")
	for(var/turf/turf in range(round(12*ability_scaling,1),get_turf(src)))
		if(prob(10))
			new /obj/effect/overlay/temp/target(turf)

/mob/living/simple_animal/hostile/megafauna/dragon/proc/fire_walls()
	var/list/attack_dirs = list(NORTH,EAST,SOUTH,WEST)
	if(prob(50))
		attack_dirs = list(NORTH,WEST,SOUTH,EAST)
	playsound(get_turf(src),'sound/magic/Fireball.ogg', 200, 1)

	for(var/d in attack_dirs)
		spawn(0)
			var/turf/E = get_edge_target_turf(src, d)
			var/range = round(10*ability_scaling,1)
			for(var/turf/open/J in getline(src,E))
				if(!range)
					break
				range--
				PoolOrNew(/obj/effect/hotspot,J)
				J.hotspot_expose(700,50,1)
				for(var/mob/living/L in J)
					if(L != src)
						L.adjustFireLoss(round(20*ability_scaling,1))
						L << "<span class='danger'>You're hit by the drake's fire breath!</span>"
				sleep(1)

/mob/living/simple_animal/hostile/megafauna/dragon/proc/swoop_attack(fire_rain = 0, atom/movable/manual_target)
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
	animate(src, pixel_x = 0, pixel_z = 0, time = 10)
	sleep(10)
	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 200, 1)
	for(var/mob/living/L in range(1,tturf))
		if(L == src)
			continue
		if(L.stat)
			visible_message("<span class='danger'>[src] slams down on [L], crushing them!</span>")
			L.gib()
		else
			var/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
			L.adjustBruteLoss(round(75*ability_scaling,1))
			L.throw_at_fast(throwtarget)
			visible_message("<span class='danger'>[L] is thrown clear of [src]!</span>")
	for(var/mob/M in range(7,src))
		shake_camera(M, 15, 1)

	stop_automated_movement = FALSE
	swooping = 0
	density = 1

/mob/living/simple_animal/hostile/megafauna/dragon/AltClickOn(atom/movable/A)
	if(!istype(A))
		return
	if(swoop_cooldown >= world.time)
		src << "You need to wait 20 seconds between swoop attacks!"
		return
	swoop_attack(1, A)

/obj/item/device/gps/internal/lavaland/dragon
	icon_state = null
	gpstag = "Fiery Signal"
	desc = "Here there be dragons."
	invisibility = 100

/mob/living/simple_animal/hostile/megafauna/dragon/lesser
	name = "lesser ash drake"
	maxHealth = 300
	health = 300
	faction = list("neutral")
	melee_damage_upper = 30
	melee_damage_lower = 30
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	loot = list()

/mob/living/simple_animal/hostile/megafauna/dragon/reddragon
	name = "Red Dragon"
	desc = "A dragon so red and evil in nature that it makes your blood boil..  or maybe that's just the mask."
	icon = 'icons/mob/pets.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	maxHealth = 220
	health = 220
	faction = list()
	mob_size = MOB_SIZE_SMALL
	pixel_x = 0
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 2, /obj/item/clothing/mask/luchador/rudos = 1)
	armour_penetration = 15
	melee_damage_upper = 15
	melee_damage_lower = 15
	ability_scaling = 0.34
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1) //Takes reduced fire damage unlike the lesser one because it's an AI and AI is dumb and needs handholding.
	loot = list()

