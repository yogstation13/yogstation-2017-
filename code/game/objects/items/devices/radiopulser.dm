#define PULSECOOLDOWN 350

/obj/item/device/pulse
	name = "radio pulser"
	desc = "With one click of a button, this device will send a 360 electromagnetic burst which is picked up by various \
			headset devices associated with a heat signature."
	icon_state = "multitool_blue"
	flags = CONDUCT | NOBLUDGEON
	slot_flags = SLOT_BELT
	item_state = "multitool_b"
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = 2
	origin_tech = "syndicate=4;magnets=4"
	var/cooldown
	var/scanning = FALSE
	var/intensity = 3 // max 35, min 15. for people who want longer or closer ranges scanned
	var/scanradius = 25 // default scan radius
	var/freqhunt // none equals universal


/obj/item/device/pulse/examine(mob/user)
	..()
	user << "<span class='notice'>The intensity meter is aiming at a [intensity].</span>"
	if(user.mind in ticker.mode.syndicates)
		user << "<span class='notice'>You can tweak the intensity of the device by using CTRL+CLICK or ALT+CLICK</span>"
		user << "<span class='notice'>Use CTRL+SHIFT+CLICK to make the pulser only focus on certain types of radios.</span>"

/obj/item/device/pulse/attack_self(mob/living/carbon/human/user)
	if(cooldown)
		user << "<span class='danger'>The pulser is recharging!</span>"
		return

	if(scanning)
		user << "<span class='notice'>You disable the pulser.</span>"
		scanning = !scanning
		triggercooldown(user)
		return
	else
		scanning = TRUE
	user << "<span class='danger'>You trigger the pulser! (Activate the pulser again to disable it's scanning mode)</span>"
	var/turf/T = get_turf(src)
	var/list/scanned_radios = list()
	var/reached // whether the signal reached a valid headset


	for(var/mob/living/carbon/human/H in orange(scanradius,T))
		if(istype(H.ears, /obj/item/device/radio/headset))
			var/obj/item/device/radio/headset/attracted_radio = H.ears
			if(attracted_radio in user.ears)
				continue
			if(attracted_radio in scanned_radios)
				continue
			if(attracted_radio.frequency == SYND_FREQ) // syndicate radios remain undetected!
				continue
			if(freqhunt)
				if(!attracted_radio.keyslot.channels.Find(freqhunt))
					continue
			if(!scanning)
				break
			user << "<span class='notice'>*-------*</span>"
			user << "<span class='notice'>You've picked up a signal!</span>"
			if(prob(5))
				H << "<span class='danger'>[attracted_radio] begins buzzing loudly, as if it's picking up feedback from an unauthorized source.</span>"
			var/keyslots
			if(attracted_radio.keyslot)
				keyslots++
				for(var/A in attracted_radio.keyslot.channels)
					user << "<span class='notice'>[A] channel frequencies are located within the radio!</span>"
					if(prob(5))
						H << "<span class='danger'>[attracted_radio] begins buzzing.</span>"

			if(attracted_radio.keyslot2)
				keyslots++
				for(var/A in attracted_radio.keyslot2.channels)
					user << "<span class='notice'>[A] channel is located within the radio!</span>"

			if(!keyslots)
				user << "<span class='notice'>There aren't any extra channels associated with this radio.</span>"
			user << "<span class='notice'>This radio matches the records as [attracted_radio].</span>"

			var/dat = gettargetrange(user, target_radio = attracted_radio)
			user << "<span class='notice'>[dat]</span>"
			if(dat)
				scanned_radios.Add(attracted_radio)
				if(!reached)
					reached = 1
			user << "<span class='notice'>*-------*</span>"
			if(!scanning)
				break
			user << "<span class='alert'>Attempting to locate more radios . . .</span>"
			sleep(30)
			user << "<span class='alert'>Locating another signal . . .</span>"
			sleep(20)
			user << "<span class='alert'>Adding signal to queue . . .</span>"
			sleep(20)
			T = get_turf(src) // in case they moved
		else
			continue

	user << "<span class='alert'>Error. The pulser cannot locate any more radios.</span>"
	if(!reached)
		user << "<span class='alert'>The pulser was unable to locate any headsets nearby.</span>"
	if(scanning)
		scanning = !scanning
	triggercooldown(user)



/obj/item/device/pulse/AltClick(mob/user)
	if(scanning)
		user << "<span class='alert'>You can't tweak the intensity rating while it's scanning!</span>"
		return

	if(intensity == 1 || scanradius == 15)
		user << "<span class='alert'>You can't lower the intensity any further!</span>"
		return

	user << "<span class='alert'>You tweak the intensity rating and decrease the scanning radius.</span>"
	var/newradius = scanradius - 5
	scanradius = newradius
	intensity--

/obj/item/device/pulse/CtrlClick(mob/user)
	if(scanning)
		user << "<span class='alert'>You can't tweak the intensity rating while it's scanning!</span>"
		return

	if(intensity == 5 || scanradius == 35)
		user << "<span class='alert'>You can't improve the device's intensity any further!</span>"
		return

	user << "<span class='alert'>You tweak the intensity rating and increase the scanning radius.</span>"
	var/newradius = scanradius + 5
	scanradius = newradius
	intensity++

/obj/item/device/pulse/CtrlShiftClick(mob/user)
	if(scanning || cooldown)
		user << "<span class='alert'>The pulser is busy!</span>"
		return

	var/radioselect = input(user, "Pick your ping", "Frequency Chooser") as null|anything in list("Universal", "Command", "Security", "Science", "Engineering", "Supply", "Medical", "Service")
	if(!radioselect)
		return

	switch(radioselect)
		if("Universal")
			freqhunt = null

		if("Command")
			freqhunt = "Command"

		if("Security")
			freqhunt = "Security"

		if("Science")
			freqhunt = "Science"

		if("Engineering")
			freqhunt = "Engineering"

		if("Supply")
			freqhunt = "Supply"

		if("Medical")
			freqhunt = "Medical"

		if("Service")
			freqhunt = "Service"

	if(!freqhunt)
		return

	user << "<span class='notice'>The pulser will now only display radios with the [freqhunt] channel.</span>"

/obj/item/device/pulse/proc/triggercooldown(mob/user)
	cooldown = TRUE
	spawn(PULSECOOLDOWN)
		cooldown = !cooldown
		playsound(loc, 'sound/effects/pop.ogg', 100, 1, -6)
		user << "<span class='alert'>[src] is active again!</span>"

/obj/item/device/pulse/proc/gettargetrange(mob/user, obj/item/device/radio/headset/target_radio)
	var/shortrange = scanradius / 5
	var/midrange = scanradius / 2
	var/turf/T = get_turf(user)
	var/turf/TR = get_turf(target_radio)

	if(T.Distance(TR) <= shortrange)
		return "You are at a short distance away from the nearby radio!"
	if(T.Distance(TR) <= midrange)
		return "You are at a midrange distance away from the radio!"
	if(T.Distance(TR) <= scanradius)
		return "You are a long distance away from the radio!"