/mob/living/Login()
	..()
	//Mind updates
	sync_mind()
	mind.show_memory(src, 0)

	//Round specific stuff
	if(ticker && ticker.mode)
		switch(ticker.mode.name)
			if("sandbox")
				CanBuild()

	update_damage_hud()
	update_health_hud()

	//Vents
	if(ventcrawler)
		src << "<span class='notice'>You can ventcrawl! Use alt+click on vents to quickly travel about the station.</span>"

	if(ranged_ability)
		client.click_intercept = ranged_ability
		src << "<span class='notice'>You currently have <b>[ranged_ability.name]</b> active!</span>"

	UpdateAlienThermal()

/mob/living/proc/UpdateAlienThermal()
	if(istype(src, /mob/living/carbon/alien))
		return
	if(thermalOverlay)
		RemoveAlienThermal()

	thermalOverlay = image(getThermalIcon(new/icon(icon,icon_state)), loc = src)
	thermalOverlay.override = 1

	for(var/mob/living/L in mob_list)
		if(isalien(L))
			if(L.client)
				L.client.images |= thermalOverlay

/mob/living/proc/RemoveAlienThermal()
	if(!thermalOverlay)
		return

	if(istype(src, /mob/living/carbon/alien))
		return

	for(var/mob/living/carbon/alien/A in mob_list)
		if(A.client)
			if(A.client.images)
				A.client.images.Remove(thermalOverlay)
	qdel(thermalOverlay)