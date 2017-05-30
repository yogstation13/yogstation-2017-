/mob/living/carbon/alien/proc/damage_delay()
	var/firedelay = max(1, ((fireloss / 10) * 0.2))
	var/brutedelay = max(1, ((bruteloss / 10) * 0.2))
	var/finaldelay = firedelay + brutedelay
	if(finaldelay == 1 || (bruteloss < 50 && fireloss < 50)))
		if(!(bruteloss + fireloss < 50))
			finaldelay = 0
	return finaldelay