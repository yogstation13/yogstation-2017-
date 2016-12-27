/mob/living/simple_animal/hostile/megafauna
	name = "boss of this gym"
	desc = "Attack the weak point for massive damage."
	health = 1000
	maxHealth = 1000
	a_intent = "harm"
	sentience_type = SENTIENCE_BOSS
	environment_smash = 3
	dismember_chance = 33
	luminosity = 3
	weather_immunities = list("lava","ash")
	robust_searching = 1
	ranged_ignores_vision = TRUE
	stat_attack = 1
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	layer = LARGE_MOB_LAYER //Looks weird with them slipping under mineral walls and cameras and shit otherwise
	var/alert_admins_z_level = 1
	var/alert_admins_area = 1

	var/turf/aggroed_from = null
	var/turf/aggro_log = null
	var/lastTarget = "no target"

/mob/living/simple_animal/hostile/megafauna/New()
	..()
	aggro_log = list()

/mob/living/simple_animal/hostile/megafauna/death(gibbed)
	if(health > 0)
		return
	else
		feedback_set_details("megafauna_kills","[initial(name)]")
		..()

/mob/living/simple_animal/hostile/megafauna/gib()
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/dust()
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/AttackingTarget()
	..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(ranged && ranged_cooldown <= world.time)
				OpenFire()


/mob/living/simple_animal/hostile/megafauna/onShuttleMove()
	var/turf/oldloc = loc
	. = ..()
	if(!.)
		return
	var/turf/newloc = loc
	message_admins("Megafauna [src] \
		(<A HREF='?_src_=holder;adminplayerobservefollow=\ref[src]'>FLW</A>) \
		moved via shuttle from ([oldloc.x],[oldloc.y],[oldloc.z]) to \
		([newloc.x],[newloc.y],[newloc.z])")

/mob/living/simple_animal/hostile/megafauna/Life()
	..()
	if(loc && (loc.z != ZLEVEL_LAVALAND) && alert_admins_z_level)
		message_admins("A live [src.name] ([src.desc]) has left the lavaland and is currently on another z level. <A HREF='?_src_=holder;adminplayerobservefollow=\ref[src]'>FLW</A> ([loc.x], [loc.y], [loc.z])")
		log_admin("[src] is off of the lavaland.")
		alert_admins_z_level = 0
		spawn(3000) // a cooldown, so it'll alert the admins again if it's still off the z level.
			alert_admins_z_level = 1

	var/area/A = get_area(src)
	if(!istype(A, /area/lavaland/surface/outdoors) && alert_admins_area)
		message_admins("A live [src.name] ([src.desc]) was led [aggroed_from ? "a distance of [get_dist(aggroed_from, src)] tiles " : ""] to [A] by [lastTarget]. Check the aggro_log var of this creature to see where it was led from.<A HREF='?_src_=holder;adminplayerobservefollow=\ref[src]'>FLW</A> ([loc.x], [loc.y], [loc.z])")
		log_admin("[src] was led to [A] by [lastTarget].")
		alert_admins_area = 0
		spawn(3000)
			alert_admins_area = 1

/mob/living/simple_animal/hostile/megafauna/experience_pressure_difference(pressure_difference, direction)
	return //Immune to Space Wind

/mob/living/simple_animal/hostile/megafauna/Aggro()
	aggroed_from = get_turf(src)
	if(target)
		if(ismob(target))
			var/mob/M = target
			lastTarget = "[M.real_name] ([M.key])"
		else
			lastTarget = "[target]"
	else
		lastTarget = "no target"
	..()

/mob/living/simple_animal/hostile/megafauna/LoseTarget()
	var/turf/T = get_turf(src)
	aggro_log += "Lost target [lastTarget] at [T ? "[T.x], [T.y], [T.z]" : "null loc"] after being pulled from [aggroed_from ? "[aggroed_from.x], [aggroed_from.y], [aggroed_from.z]" : "null loc"][(T && aggroed_from) ? " (distance of [get_dist(T, aggroed_from)])" : ""]."
	aggroed_from = null
	..()