#define NEARCRIT_JITTERCAP 150

/mob/living/carbon/movement_delay()
	. = ..()
	. += grab_state * 3
	if(legcuffed)
		. += legcuffed.slowdown
		legcuffed.cuff_act(src)
	if(!get_leg_ignore()) //ignore the fact we lack legs
		var/leg_amount = get_num_legs()
		. += 6 - 3*leg_amount //the fewer the legs, the slower the mob
		if(!leg_amount)
			. += 6 - 3*get_num_arms() //crawling is harder with fewer arms
	if(lying)
		. += 10
		if(is_nearcrit(src))
			. += 20
			jitteriness = min(jitteriness + 20, NEARCRIT_JITTERCAP)
			emote(pick("moan", "cry"))
			if(prob(10))
				flash_color(src, color = "#FF0000", time = 5)
				to_chat(src, "<span class='genesisred'>THE PAIN!</span>" )


var/const/NO_SLIP_WHEN_WALKING = 1
var/const/SLIDE = 2
var/const/GALOSHES_DONT_HELP = 4

/mob/living/carbon/slip(s_amount, w_amount, obj/O, lube)
	add_logs(src,, "slipped",, "on [O ? O.name : "floor"]")
	return loc.handle_slip(src, s_amount, w_amount, O, lube)


/mob/living/carbon/Process_Spacemove(movement_dir = 0)
	if(..())
		return 1
	if(!isturf(loc))
		return 0

	// Do we have a jetpack implant (and is it on)?
	var/obj/item/organ/cyberimp/chest/thrusters/T = getorganslot("thrusters")
	if(istype(T) && movement_dir && T.allow_thrust(0.01))
		return 1

	var/obj/item/weapon/tank/jetpack/J = get_jetpack()
	if(istype(J) && (movement_dir || J.stabilizers) && J.allow_thrust(0.01, src))
		return 1



/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			src.nutrition -= HUNGER_FACTOR/10
			if(src.m_intent == "run")
				src.nutrition -= HUNGER_FACTOR/10
		if((src.disabilities & FAT) && src.m_intent == "run" && src.bodytemperature <= 360)
			src.bodytemperature += 2
