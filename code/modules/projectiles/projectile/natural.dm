/obj/item/projectile/bullet/dart/basilisk
	name = "freezing dart"
	icon_state = "ice_2"
	nodamage = 1 //The darts don't do much damage, but it adds up (especially since you may get hit 20+ times assaulting a tendril)

/obj/item/projectile/bullet/dart/basilisk/New()
	..()
	reagents.add_reagent("bolamine",5)
	reagents.add_reagent("cryptobiolin",2)
	reagents.add_reagent("frostoil", 2)

/obj/item/projectile/bullet/dart/basilisk/Bump(atom/A)
	..()
	if(istype(A, /turf/closed/mineral))
		var/turf/closed/mineral/M = A
		M.name = "frozen rock"
		M.desc = "A watcher missed."
		M.color = "#00ffff"