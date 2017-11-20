/obj/mecha/combat/tank
	desc = "A thundering beast of a tank. Its metal plates loom over you as it shudders the very deck with its movement."
	name = "NT-05 tank"
	icon = 'icons/mecha/tank.dmi'
	icon_state = "tank"
	step_in = 2
	dir_in = 1 //Facing North.
	health = 2000
	deflect_chance = 50
	damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8)
	max_temperature = 30000
	infra_luminosity = 8
	force = 0 //it can run people over though
	stepsound = 'sound/effects/tanktread.ogg'
	turnsound = 'sound/effects/tanktread.ogg'
//	wreckage = /obj/structure/mecha_wreckage/tank
	var/smash_damage = 120
	var/list/creaks = list('sound/effects/creak1.ogg','sound/effects/creak2.ogg','sound/effects/creak3.ogg') //deck creaks and breaks as the tank steamrolls over it.
	var/OP = 1

/obj/mecha/combat/tank/balanced
	desc = "A massive tank. It moves slowly and fires missiles."
	name = "NT-01 tank"
	icon = 'icons/mecha/tank.dmi'
	icon_state = "tank"
	step_in = 1
	dir_in = 1 //Facing North.
	health = 500
	deflect_chance = 20
	damage_absorption = list("brute"=0.3,"fire"=1.1,"bullet"=0.65,"laser"=0.60,"energy"=0.9,"bomb"=0.3)
	max_temperature = 30000
	infra_luminosity = 8
	OP = 0

/obj/mecha/combat/tank/balanced/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine/tank/balanced
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/missile_rack
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	return



/obj/mecha/combat/tank/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine/tank
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/tankbarrel
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	return

/obj/mecha/combat/tank/Bump(atom/movable/M)
	. = ..()
	if(istype(M, /obj/machinery/door))
		qdel(M)
		playsound(loc, 'sound/effects/bang.ogg', 75)
	if(ismob(M))
		var/mob/mob = M
		src.visible_message("<span class='danger'>[src] drives over [mob] and flattens them!</span>")
		mob.Weaken(3)
		Bumped(M)
	if(istype(M, /turf/closed/wall))
		var/turf/closed/wall/e = M
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
		src.visible_message("<span class='warning'>[src] smashes through [M], flattening it!</span>")
		e.dismantle_wall(1)
	else if(istype(M, /obj/mecha)) //:^)
		var/obj/mecha/Q = M
		Q.take_damage(smash_damage, BRUTE, 0)
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
		src.visible_message("<span class='warning'>[src] rams into [M], crushing it!</span>")
	else if(istype(M, /obj/structure))
		if(istype(M, /obj/structure/grille)) //:^)
			var/obj/structure/grille/Q = M
			Q.take_damage(smash_damage, BRUTE, 0)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			src.visible_message("<span class='warning'>[src] rams straight through [M], pulverizing it!</span>")

		else if(istype(M, /obj/structure/window)) //:^)
			var/obj/structure/window/Q = M
			Q.take_damage(smash_damage, BRUTE, 0)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			src.visible_message("<span class='warning'>[src] rams straight through [M], pulverizing it!</span>")

		else if(istype(M, /obj/structure/table)) //:^)
			var/obj/structure/table/Q = M
			Q.take_damage(smash_damage, BRUTE, 0)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			src.visible_message("<span class='warning'>[src] rams straight through [M], pulverizing it!</span>")
		else
			var/obj/structure/Q = M
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			src.visible_message("<span class='warning'>[src] rams straight through [M], pulverizing it!</span>")
			qdel(Q)

	else if(istype(M, /obj/machinery))
		if(istype(M, /obj/machinery/vending))
			var/obj/machinery/vending/F = M
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			F.fallover()
			return
		else
			var/obj/machinery/Q = M
			Q.take_damage(smash_damage, BRUTE, 0)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			src.visible_message("<span class='warning'>[src] ploughs through [M], pulverizing it!</span>")
			qdel(Q)

/obj/mecha/combat/tank/Bumped(atom/movable/AM)
	if(occupant)//can't run people over without a driver
		if(ismob(AM))
			var/mob/living/M = AM
			M.say("AHHHH!!!!!!")
			M.Paralyse(5)
			M.adjustBruteLoss(smash_damage)


/obj/mecha/combat/tank/Move()
	if(prob(1))
		var/tempsound = pick(creaks)
		playsound_global(tempsound,repeat=0, channel=1, volume=100)
		src.visible_message("<span class='danger'>the floor creaks and buckles under [src]'s weight!</span>")
	. = ..()


/obj/mecha/combat/tank/Process_Spacemove(movement_dir = 0)
	if(OP) //if it's the OP one
		return 1 //it can also fly because it hovers:^)
	else
		return 0 //only OP one can fly

/obj/item/mecha_parts/mecha_equipment/weapon/tankbarrel
	equip_cooldown = 10
	name = "GG double barrel tank cannon"
	desc = "The barrel from a tank, it fires pulse rounds, if you're reading this you probably got killed by it."
	icon_state = "mecha_tank"
	energy_drain = 10
	origin_tech = "materials=3;combat=6;powerstorage=4"
	projectile = /obj/item/projectile/beam/pulse/heavy
	projectiles_per_shot = 2
	fire_sound = 'sound/weapons/tankshell.ogg'




/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine/tank
	name = "FNX-2000 mounted machine gun"
	desc = "A prototype weapon being developed by NT. It fires incendiary rounds."
	icon_state = "chad_carbine"
	origin_tech = "materials=4;combat=8"
	equip_cooldown = 1
	projectile = /obj/item/projectile/bullet/incendiary/shell/dragonsbreath
	projectiles = 200
	projectile_energy_cost = 5
	projectiles_per_shot = 10
	fire_sound = 'sound/weapons/machinegun.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine/tank/balanced
	name = "FNX-2000 mounted machine gun"
	desc = "A standard tank mounted machine gun."
	icon_state = "chad_carbine"
	origin_tech = "materials=4;combat=4"
	equip_cooldown = 1
	projectile = /obj/item/projectile/bullet
	projectiles = 40
	projectile_energy_cost = 15
	projectiles_per_shot = 4
	fire_sound = 'sound/weapons/machinegun.ogg'