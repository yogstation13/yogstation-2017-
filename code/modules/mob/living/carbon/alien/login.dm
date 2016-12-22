/mob/living/carbon/alien/Login()
	..()
	AddInfectionImages()
	UpdateThermalEffects()
	return

/mob/living/carbon/alien/proc/UpdateThermalEffects()
	if(!client)
		return

	for(var/i in client.images)
		client.images.Remove(i)

	for(var/mob/living/L in mob_list)
		if(isalien(L))
			return
		L.thermalOverlay = image(getThermalIcon(new/icon(L.icon,L.icon_state)), loc = L)
		L.thermalOverlay.override = 1
		client.images |= L.thermalOverlay

	if(client)
		overlay_fullscreen("thermal", /obj/screen/fullscreen/thermal)