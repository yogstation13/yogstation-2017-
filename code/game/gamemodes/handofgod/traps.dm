
/obj/structure/divine/trap
	name = "A bug"
	icon_state = "trap"
	density = 0
	alpha = 30 //initially quite hidden when not "recharging"
	health = 1
	maxhealth = 1
	desc = "A bug. Report this to a coder."
	var/friendlycultdesc = "A bug. Report this to your god, and also a coder."
	var/enemycultdesc = "An enemy bug. This probably shouldn't exist, ahelp it."
	trap = TRUE
	autocolours = FALSE
	var/last_trigger = 0
	var/time_between_triggers = 200 //20 seconds to recharge
	var/side = "neutral" //"blue" or "red", also used for colouring structures when construction is started by a deity


/obj/structure/divine/trap/Crossed(atom/movable/AM)
	if(last_trigger + time_between_triggers > world.time)
		return
	alpha = 30
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.stat <= stat_affected)
			if((side == "red" && is_handofgod_redcultist(H)) || (side == "blue" && is_handofgod_bluecultist(H)))
				L << "<span class='notice'><B>You pass harmlessly over the trap.</B></span>"
				return
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
	if(!is_handofgod_cultist(user))
		desc = initial(desc)
	if((side == "red" && is_handofgod_redcultist(H)) || (side == "blue" && is_handofgod_bluecultist(H)))
		desc = friendlycultdesc
	else
		desc = enemycultdesc
	alpha = 200
	animate(src, alpha = 30, time = time_between_triggers)


/obj/structure/divine/trap/proc/trap_effect(mob/living/L)
	return


/obj/structure/divine/trap/stun
	name = "shock trap"
	icon_state = "trap-shock"
	desc = "Some trap. It looks rather shocking."
	var/friendlycultdesc = "A shocking trap with an electrifying suprise for enemies who cross it."
	var/enemycultdesc = "A shocking trap that'll fry you alive if you cross it. Hit it to destroy it."


/obj/structure/divine/trap/stun/trap_effect(mob/living/L)
	L << "<span class='danger'><B>You are paralyzed from the intense shock!</B></span>"
	L.Weaken(5)
	L.adjustFireLoss(35)
	var/turf/Lturf = get_turf(L)
	new /obj/effect/particle_effect/sparks/electricity(Lturf)
	new /obj/effect/particle_effect/sparks(Lturf)


/obj/structure/divine/trap/fire
	name = "flame trap"
	icon_state = "trap-fire"
	desc = "A trap that radiates heat."
	var/friendlycultdesc = "A trap that ignites enemies who cross it."
	var/enemycultdesc = "A trap that's a bit too hot to handle. Hit it to destroy it."


/obj/structure/divine/trap/fire/trap_effect(mob/living/L)
	L << "<span class='danger'><B>You are lit ablaze!</B></span>"
	L.Weaken(1)
	var/turf/Lturf = get_turf(L)
	new /obj/effect/hotspot(Lturf)
	new /obj/effect/particle_effect/sparks(Lturf)


/obj/structure/divine/trap/chill
	name = "frost trap"
	icon_state = "trap-frost"
	desc = "A chilling trap."
	var/friendlycultdesc = "A trap that'll freeze enemies who cross it solid."
	var/enemycultdesc = "A chilling trap that'll give you a cold reception, should you cross it. Hit it to give it the cold shoulder."


/obj/structure/divine/trap/chill/trap_effect(mob/living/L)
	L << "<span class='danger'><B>You're frozen solid!</B></span>"
	L.Weaken(1)
	L.bodytemperature -= 300
	new /obj/effect/particle_effect/sparks(get_turf(L))


/obj/structure/divine/trap/damage
	name = "earth trap"
	icon_state = "trap-earth"
	desc = "A trap that sadly does not have any earth-based puns to go with it."
	var/friendlycultdesc = "A trap that'll summon a mini earthquake underneath enemies who cross it."
	var/enemycultdesc = "A trap that will summon a mini earthquake underneath your feet. Hit it to destroy it."


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
	desc = "A barrier blocking your way."
	var/friendlycultdesc = "A barrier that you can click to make dense or passable."
	var/enemycultdesc = "An unholy barrier placed by an enemy god. You can wait for it to vanish, or hit it a lot."
	time_between_triggers = 1200 //Exists for 2 minutes
	
/obj/structure/divine/trap/ward/attack_hand(mob/user)
	if(iscarbon(user) && ( (side == "red" && is_handofgod_redcultist(H)) || (side == "blue" && is_handofgod_bluecultist(H)) ) && user.a_intent == "harm")
		if(density == 1)
			user.visible_message("<span class='notice'>You force the ward to become passable.</span>")
			density == 0
		if(density == 0)
			user.visible_message("<span class='notice'>You force the ward to become dense.</span>")
			density == 1
		qdel(src)
		return 1
	..()

/obj/structure/divine/trap/ward/New()
	..()
	spawn(time_between_triggers)
		if(src)
			qdel(src)
