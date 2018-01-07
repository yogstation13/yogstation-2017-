/mob/living/silicon/pai/Life()
	updatehealth()
	if (stat == DEAD)
		return
	if (selfrepair == 1 && health < 100)
		if(prob(12))
			adjustBruteLoss(rand(-4, -8))

	if (health < -50)
		death()
	if(cable)
		if(get_dist(src, cable) > 1)
			var/turf/T = get_turf(loc)
			T.visible_message("<span class='warning'>[cable] rapidly retracts back into its spool.</span>", "<span class='italics'>You hear a click and the sound of wire spooling rapidly.</span>")
			qdel(cable)
			cable = null
	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")
	if(emitter_OD) //beacon overcharge software emitter stuff (/datum/pai/software/beacon_overcharge [beacon_overcharge.dm])
		if (getFireLoss() >= 75)
			var/datum/pai/software/beacon_overcharge/S = new /datum/pai/software/beacon_overcharge
			S.take_overload_damage(src)
		if (luminosity && luminosity < 6)
			if (prob(12))
				AddLuminosity(1)
				if (prob(50))
					adjustFireLoss(rand(6, 8))
					to_chat(src, "<span class='warning'>Your circuits sizzle and whine under the increased heat produced by your overloaded holographic emitters.</span>")
			if (luminosity && luminosity > 1 && prob(3))
				AddLuminosity(-1)
		else if (luminosity && luminosity == 6)
			if (prob(50))
				adjustFireLoss(rand(2, 4))
				to_chat(src, "<span class='warning'>Your circuits sizzle and whine under the increased heat produced by your overloaded holographic emitters.</span>")
				to_chat(src, "<span class='warning><b>/mnt/holo_em:</b> PROTOCOL WARNING: VOLTAGE MAXED</span>")

/mob/living/silicon/pai/updatehealth()
	if(GODMODE in status_flags)
		return
	health = maxHealth - getBruteLoss() - getFireLoss()
	update_stat()

