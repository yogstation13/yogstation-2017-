/mob/living/silicon/pai/Life()
	updatehealth()
	if (src.stat == DEAD)
		return
	if (src.selfrepair == 1 && src.health < 100)
		if(prob(12))
			adjustBruteLoss(rand(-4, -8))

	if (src.health < -50)
		death()
	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf(src.loc)
			T.visible_message("<span class='warning'>[src.cable] rapidly retracts back into its spool.</span>", "<span class='italics'>You hear a click and the sound of wire spooling rapidly.</span>")
			qdel(src.cable)
			cable = null
	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			src << "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>"

/mob/living/silicon/pai/updatehealth()
	if(GODMODE in status_flags)
		return
	health = maxHealth - getBruteLoss() - getFireLoss()
	update_stat()

