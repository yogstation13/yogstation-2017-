
/datum/weather/nuclear
	name = "nuclear detonation"
	desc = "A tactical nuclear detonation has been detected in station airspace."
	telegraph_duration = 280
	telegraph_message = "<span class='boldwarning'>A loud alarm blares in your ears as the sky turns orange, SEEK SHELTER!</span>"
	weather_message = "<span class='userdanger'><i>The air around you grows unbearably hot.</i></span>"
	weather_overlay = "nuclear_heatwave"
	end_overlay = "light_ash"
	telegraph_overlay = "nuclear_light_heatwave"
	weather_duration_lower = 200
	weather_duration_upper = 400
	weather_color = null
	telegraph_sound = 'sound/effects/nuclearblast.ogg'
	weather_sound = 'sound/effects/nuclearwind.ogg'
	end_duration = 300
	area_type = /area
	protected_areas = list(/area/turret_protected/ai,/area/engine/engine_smes,/area/medical/virology,/area/maintenance/asmaint2 ,/area/toxins/mixing,/area/maintenance/electrical ,/area/maintenance/fsmaint2 ,/area/hydroponics/backroom ,/area/maintenance/fsmaint ,/area/ai_monitored/nuke_storage,/area/maintenance/fpmaint2,/area/maintenance/aft)
	target_z = ZLEVEL_STATION
	end_message = "<span class='notice'>The air around you is filled with ash, it's hard to breathe....</span>"
	immunity_type = null //Are you immune to nukes?
	end_sound = 'sound/effects/nuclearallclear.ogg'

/datum/weather/nuclear/impact(atom/movable/M)
	if(isliving(M))
		var/mob/living/L = M
		var/resist = L.getarmor(null, "energy")
		if(prob(max(0,100-resist)))
			if(/obj/item/clothing/suit/fire || /obj/item/clothing/suit/space in L.contents)
				L.IgniteMob()
			else
				to_chat(L, "In an instant flash of heat, you are completely vaporized as your skin melts away.")
				L.dust()
		else
			L.IgniteMob()

/datum/weather/nuclear/telegraph()
	. = ..()
	priority_announce("WARNING: TACTICAL NUCLEAR DETONATION DETECTED IN SS13 AIRSPACE. ALL PERSONNEL ARE ADVISED TO SEEK SHELTER. OFFICIAL INSTRUCTIONS WILL FOLLOW.", "Nanotrasen Emergency Alert System")
	sleep(60)
	priority_announce("Official advice from Nanotrasen citizen's office: Put as much metal between you and the outside as possible. All space-facing zones are likely to be affected by the initial heatwave.", "Nanotrasen Emergency Alert System")

/datum/weather/nuclear/start()
	. = ..()
	for(var/mob/living/L in player_list)
		shake_camera(L, 7, 1)
	for(var/obj/machinery/light/T in machines)
		T.broken()
		if(prob(50))
			T.atmos_spawn_air("plasma=20;TEMP=1000")

/datum/weather/nuclear/end()
	if(..())
		return
	priority_announce("ERROR Contacting NTnet. Reverting communications to legacy system.", "Nanotrasen Emergency Alert System")
	sleep(60) //6 seconds
	priority_announce("Warning: Nuclear Fallout imminent. Do not leave shelters.", "Nanotrasen Emergency Alert System")
	sleep(300) //30 seconds
	SSweather.run_weather("nuclear fallout",1) //fallout follows rads
	if(emergency_access)
		revoke_maint_all_access()

/datum/weather/nuclear_fallout
	name = "nuclear fallout"
	desc = "Radioactive dust falls upon the station, you should get to maint..."
	telegraph_duration = 50
	telegraph_message = "<span class='boldwarning'>Ash falls from the sky, radioactive embers float everywhere.</span>"
	weather_message = "<span class='userdanger'><i>You feel a wave of hot ash fall down on you.</i></span>"
	weather_overlay = "light_ash"
	telegraph_overlay = "light_ash"
	weather_duration_lower = 1100
	weather_duration_upper = 1250
	weather_color = "green"
	telegraph_sound = null
	weather_sound = 'sound/effects/falloutwind.ogg'
	end_duration = 100
	area_type = /area
	protected_areas = list(/area/maintenance)
	target_z = ZLEVEL_STATION
	end_message = "<span class='notice'>The ash stops falling.</span>"
	immunity_type = "rad"

/datum/weather/nuclear_fallout/impact(mob/living/L)
	var/resist = L.getarmor(null, "rad")
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.dna && H.dna.species)
			if(!(RADIMMUNE in H.dna.species.specflags))
				if(prob(max(0,100-resist)))
					H.adjustToxLoss(1)



/client/proc/tactical_nuke_the_station()
	set name = "Fire tactical nuke "
	set category = "Fun"
	set popup_menu = 0
	if(!check_rights(R_FUN))
		return
	var/our_badmin = usr
	var/areyouDrunk = input(our_badmin, "Please confirm action", "Centcom Nuclear Failsafe") in list("YES","NO")
	switch(areyouDrunk)
		if("YES")
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","P")
			log_admin("[key_name(usr)] launched a nuke at the station!", 1)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] launched a nuke at the station!</span>")
			SSweather.run_weather("nuclear detonation",1)
			return 1
		if("NO")
			log_admin("[key_name(usr)] Resisted the temptation to press the nuclear launch button.", 1)
			return 0

