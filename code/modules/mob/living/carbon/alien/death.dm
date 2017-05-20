/mob/living/carbon/alien/spawn_gibs()
	xgibs(loc, viruses)

/mob/living/carbon/alien/gib_animation()
	new /obj/effect/overlay/temp/gib_animation(loc, "gibbed-a")

/mob/living/carbon/alien/spawn_dust()
	new /obj/effect/decal/remains/xeno(loc)

/mob/living/carbon/alien/dust_animation()
	new /obj/effect/overlay/temp/dust_animation(loc, "dust-a")


/mob/living/carbon/alien/death(gibbed)
/*	if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/xenomorph))
		ticker.mode.xenomorphs["QUEEN"] -= mind
		ticker.mode.xenomorphs["HUNTERS"] -= mind
		ticker.mode.xenomorphs["SENITELS"] -= mind
		ticker.mode.xenomorphs["DRONES"] -= mind
*/
	return ..()