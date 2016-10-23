
/obj/structure/divine/trap
	name = "A bug"
	icon_state = "trap"
	density = 0
	alpha = 30 //initially quite hidden when not "recharging"
	health = 1
	maxhealth = 1
	trap = TRUE
	autocolours = FALSE
	var/last_trigger = 0
	var/time_between_triggers = 200 //20 seconds to recharge


/obj/structure/divine/trap/Crossed(atom/movable/AM)
	if(last_trigger + time_between_triggers > world.time)
		return
	alpha = 30
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.stat <= stat_affected)
			if(L.null_rod_check())
				var/obj/item/I = L.null_rod_check()
				L.visible_message("<span class='warning'>[L]'s [I.name] [resist_string], protecting them from [src]'s effects!</span>", \
				"<span class='userdanger'>Your [I.name] [resist_string], protecting you!</span>")
				return
		last_trigger = world.time
		alpha = 200
		trap_effect(L)
		animate(src, alpha = 30, time = time_between_triggers)

/obj/structure/divine/trap/examine(mob/user)
	..()
	if(!isliving(user)) //Stops ghosts from revealing traps when dead
		return
	user << "You reveal a trap!"
	alpha = 200
	animate(src, alpha = 30, time = time_between_triggers)


/obj/structure/divine/trap/proc/trap_effect(mob/living/L)
	return


/obj/structure/divine/trap/stun
	name = "shock trap"
	icon_state = "trap-shock"


/obj/structure/divine/trap/stun/trap_effect(mob/living/L)
	L << "<span class='danger'><B>You are paralyzed from the intense shock!</B></span>"
	L.Weaken(5)
	L.adjustFireLoss(25)
	var/turf/Lturf = get_turf(L)
	new /obj/effect/particle_effect/sparks/electricity(Lturf)
	new /obj/effect/particle_effect/sparks(Lturf)


/obj/structure/divine/trap/fire
	name = "flame trap"
	icon_state = "trap-fire"


/obj/structure/divine/trap/fire/trap_effect(mob/living/L)
	L << "<span class='danger'><B>You are lit ablaze!</B></span>"
	L.Weaken(1)
	var/turf/Lturf = get_turf(L)
	new /obj/effect/hotspot(Lturf)
	new /obj/effect/particle_effect/sparks(Lturf)


/obj/structure/divine/trap/chill
	name = "frost trap"
	icon_state = "trap-frost"


/obj/structure/divine/trap/chill/trap_effect(mob/living/L)
	L << "<span class='danger'><B>You're frozen solid!</B></span>"
	L.Weaken(1)
	L.bodytemperature -= 300
	new /obj/effect/particle_effect/sparks(get_turf(L))


/obj/structure/divine/trap/damage
	name = "earth trap"
	icon_state = "trap-earth"


/obj/structure/divine/trap/damage/trap_effect(mob/living/L)
	L << "<span class='danger'><B>The ground quakes beneath your feet!</B></span>"
	L.Weaken(5)
	L.adjustBruteLoss(35)
	var/turf/Lturf = get_turf(L)
	new /obj/effect/particle_effect/sparks(Lturf)
	new /obj/structure/flora/rock(Lturf)


/obj/structure/divine/trap/ward
	name = "divine ward"
	icon_state = "ward"
	health = 150
	maxhealth = 150
	density = 1
	time_between_triggers = 1200 //Exists for 2 minutes
	

/obj/structure/divine/trap/examine(mob/user)
	..()
	if(!is_handofgod_cultist(user))
		usr << "Some kind of trap placed by a divine power."
	else
		if(istype(A, /obj/structure/divine/trap))
			usr << "A bug. Report this to a coder."
		if(istype(A, /obj/structure/divine/trap/stun))
			usr << "An electrifying trap that packs a shocking suprise for those who cross it. Hit it to destroy it."
		if(istype(A, /obj/structure/divine/trap/fire))
			usr << "A trap that ignites those who cross it. Hit it to destroy it."
		if(istype(A, /obj/structure/divine/trap/chill))
			usr << "A trap that gives those who cross it a chilly reception. Hit it to destroy it."
		if(istype(A, /obj/structure/divine/trap/damage))
			usr << "A trap that causes a small earthquake centered on those who cross it. Hit it to destroy it."
		if(istype(A, /obj/structure/divine/trap/ward))
			usr << "A divine barrier that blocks passage. You can hit it a lot to destroy it, else it will fade shortly."


/obj/structure/divine/trap/ward/New()
	..()
	spawn(time_between_triggers)
		if(src)
			qdel(src)
