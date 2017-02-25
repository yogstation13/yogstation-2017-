/obj/item/projectile/temp/basilisk
	name = "freezing blast"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	temperature = 50

/obj/item/projectile/temp/basilisk/Bump(atom/A)
	..()
	if(istype(A, /turf/closed/mineral))
		var/turf/closed/mineral/M = A
		M.name = "frozen rock"
		M.desc = "A watcher missed."
		M.color = "#00ffff"
