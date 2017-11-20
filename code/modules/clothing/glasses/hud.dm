/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = null //doesn't protect eyes because it's a monocle, duh
	origin_tech = "magnets=3;biotech=2"
	var/hud_type = null

/obj/item/clothing/glasses/hud/equipped(mob/living/carbon/human/user, slot)
	if(hud_type && slot == slot_glasses)
		var/datum/atom_hud/H = huds[hud_type]
		H.add_hud_to(user)

/obj/item/clothing/glasses/hud/dropped(mob/living/carbon/human/user)
	..()
	if(hud_type && istype(user) && user.glasses == src)
		var/datum/atom_hud/H = huds[hud_type]
		H.remove_hud_from(user)

/obj/item/clothing/glasses/hud/emp_act(severity)
	if(emagged == 0)
		emagged = 1
		desc = desc + " The display flickers slightly."

/obj/item/clothing/glasses/hud/emag_act(mob/user)
	if(emagged == 0)
		emagged = 1
		to_chat(user, "<span class='warning'>PZZTTPFFFT</span>")
		desc = desc + " The display flickers slightly."

/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	origin_tech = "magnets=3;biotech=2"
	hud_type = DATA_HUD_MEDICAL_ADVANCED

/obj/item/clothing/glasses/hud/health/optical
	name = "Optical Health Scanner HUD"
	desc = "A medical heads-up display that comes accustomed with an advanced optical meson scanner."
	darkness_view = 2
	vision_flags = SEE_TURFS
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/health/night
	name = "Night Vision Health Scanner HUD"
	desc = "An advanced medical head-up display that allows doctors to find patients in complete darkness."
	icon_state = "healthhudnight"
	item_state = "glasses"
	origin_tech = "magnets=4;biotech=4;plasmatech=4;engineering=5"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/diagnostic
	name = "Diagnostic HUD"
	desc = "A heads-up display capable of analyzing the integrity and status of robotics and exosuits."
	icon_state = "diagnostichud"
	origin_tech = "magnets=2;engineering=2"
	hud_type = DATA_HUD_DIAGNOSTIC

/obj/item/clothing/glasses/hud/diagnostic/night
	name = "Night Vision Diagnostic HUD"
	desc = "A robotics diagnostic HUD fitted with a light amplifier."
	icon_state = "diagnostichudnight"
	item_state = "glasses"
	origin_tech = "magnets=4;powerstorage=4;plasmatech=4;engineering=5"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/diagnostic/advanced
	name = "Advanced Diagnostic HUD"
	hud_type = DATA_HUD_DIAGNOSTIC_ADVANCED

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	origin_tech = "magnets=3;combat=2"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	var/syndicate = FALSE

/obj/item/clothing/glasses/hud/security/examine(mob/user)
	. = ..()
	if(!syndicate)
		to_chat(user, "<span class='notice'>To operate the criminal status of someone in range,  ALT + SHIFT and click on the target.</span>")
		to_chat(user, "<span class='notice'>To add crimes and comments to a person, hold CTRL + SHIFT and click on the target</span>")

/obj/item/clothing/glasses/hud/security/chameleon
	name = "Chameleon Security HUD"
	desc = "A stolen security HUD integrated with Syndicate chameleon technology. Toggle to disguise the HUD. Provides flash protection."
	flash_protect = 1
	syndicate = TRUE

/obj/item/clothing/glasses/hud/security/chameleon/attack_self(mob/user)
	chameleon(user)


/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "Eyepatch HUD"
	desc = "A heads-up display that connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	icon_state = "hudpatch"

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	origin_tech = "magnets=3;combat=3;engineering=3"
	darkness_view = 1
	flash_protect = 1
	tint = 1

/obj/item/clothing/glasses/hud/security/night
	name = "Night Vision Security HUD"
	desc = "An advanced heads-up display which provides id data and vision in complete darkness."
	icon_state = "securityhudnight"
	origin_tech = "magnets=4;combat=4;plasmatech=4;engineering=5"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	name = "HUD gar glasses"
	desc = "GAR glasses with a HUD."
	icon_state = "gars"
	item_state = "garb"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP

/obj/item/clothing/glasses/hud/security/sunglasses/gars/supergars
	name = "giga HUD gar glasses"
	desc = "GIGA GAR glasses with a HUD."
	icon_state = "supergars"
	item_state = "garb"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/hud/toggle
	name = "Toggle Hud"
	desc = "A hud with multiple functions."
	actions_types = list(/datum/action/item_action/switch_hud)

/obj/item/clothing/glasses/hud/toggle/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wearer = user
	if (wearer.glasses != src)
		return

	if (hud_type)
		var/datum/atom_hud/H = huds[hud_type]
		H.remove_hud_from(user)

	if (hud_type == DATA_HUD_MEDICAL_ADVANCED)
		hud_type = null
	else if (hud_type == DATA_HUD_SECURITY_ADVANCED)
		hud_type = DATA_HUD_MEDICAL_ADVANCED
	else
		hud_type = DATA_HUD_SECURITY_ADVANCED

	if (hud_type)
		var/datum/atom_hud/H = huds[hud_type]
		H.add_hud_to(user)

/obj/item/clothing/glasses/hud/toggle/thermal
	name = "Thermal HUD Scanner"
	desc = "Thermal imaging HUD in the shape of glasses."
	icon_state = "thermal"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	vision_flags = SEE_MOBS
	invis_view = 2

/obj/item/clothing/glasses/hud/toggle/thermal/attack_self(mob/user)
	..()
	switch (hud_type)
		if (DATA_HUD_MEDICAL_ADVANCED)
			icon_state = "meson"
		if (DATA_HUD_SECURITY_ADVANCED)
			icon_state = "thermal"
		else
			icon_state = "purple"
	user.update_inv_glasses()

/obj/item/clothing/glasses/hud/toggle/thermal/emp_act(severity)
	thermal_overload()
	..()

// ctrl + shift
/proc/security_scan_crime(var/mob/living/carbon/human/H, var/mob/living/carbon/human/A, allowed_access)
	var/perpname = A.get_face_name(H.get_id_name(""))
	var/datum/data/record/R = find_record("name", perpname, data_core.security)
	switch(alert("What would you like to add?","Security HUD","Minor Crime","Major Crime", "Comment", "Cancel"))
		if("Minor Crime")
			if(R)
				var/t1 = stripped_input(H, "Please input minor crime names:", "Security HUD", "", null)
				var/t2 = stripped_multiline_input(H, "Please input minor crime details:", "Security HUD", "", null)
				if(R)
					if (!t1 || !t2) return
					var/crime = data_core.createCrimeEntry(t1, t2, allowed_access, worldtime2text())
					data_core.addMinorCrime(R.fields["id"], crime)
					to_chat(H, "<span class='notice'>Successfully added a minor crime.</span>")
		if("Major Crime")
			if(R)
				var/t1 = stripped_input(H, "Please input major crime names:", "Security HUD", "", null)
				var/t2 = stripped_multiline_input(H, "Please input major crime details:", "Security HUD", "", null)
				if(R)
					if (!t1 || !t2) return
					var/crime = data_core.createCrimeEntry(t1, t2, allowed_access, worldtime2text())
					data_core.addMajorCrime(R.fields["id"], crime)
					to_chat(H, "<span class='notice'>Successfully added a major crime.</span>")
		if("Comment")
			if(R)
				var/t1 = stripped_multiline_input(H, "Add Comment:", "Secure. records", null, null)
				if(R)
					if (!t1) return
					var/counter = 1
					while(R.fields[text("com_[]", counter)])
						counter++
					R.fields[text("com_[]", counter)] = text("Made by [] on [] [], []<BR>[]", allowed_access, worldtime2text(), time2text(world.realtime, "MMM DD"), year_integer+540, t1,)
					to_chat(H, "<span class='notice'>Successfully added comment.</span>")

// ctrl + alt
/proc/security_scan_status(var/mob/living/carbon/human/H, var/mob/living/carbon/human/A, allowed_access)
	var/perpname = A.get_face_name(H.get_id_name(""))
	var/datum/data/record/R = find_record("name", perpname, data_core.general)
	R = find_record("name", perpname, data_core.security)
	if(R)
		var/setcriminal = input(H, "Specify a new criminal status for this person.", "Security HUD", R.fields["criminal"]) as anything in list("None", "*Arrest*", "Incarcerated", "Parolled", "Discharged", "Cancel")
		if(setcriminal != "Cancel")
			if(H.canUseHUD())
				H.investigate_log("[A.key] has been set from [R.fields["criminal"]] to [setcriminal] by [H.name] ([H.key]).", "records")
				R.fields["criminal"] = setcriminal
				A.sec_hud_set_security_status()
				return