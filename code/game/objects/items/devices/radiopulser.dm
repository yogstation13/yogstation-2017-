#define PULSECOOLDOWN 350

/obj/item/device/pulse
	name = "radio pulser"
	desc = "The prototype of a much larger weapon, the radio pulser sends a 360 electromagnetic burst which is picked up "
	icon_state = "shield0"
	flags = CONDUCT | NOBLUDGEON
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = 2
	origin_tech = "syndicate=4;magnets=4"
	var/cooldown
	var/scanradius = 25



/obj/item/device/pulse/attack_self(mob/user)
	if(cooldown)
		user << "<span class='danger'>The pulser is recharging!</span>"
		return
	user << "<span class='danger'>You trigger the pulser's creating a radio burst!</span>"
	for(var/obj/item/device/radio/headset/attracted_radio in view(user, scanradius))
		user << "<span class='alert'> *-----------------------*</span>"
		if(!attracted_radio)
			user << "<span class='alert'>The pulser was unable to locate any headsets nearby.</span>"
			triggercooldown()
			return
		if(attracted_radio in user)
			user << "<span class='notice'>A radio from the pulses starting point picks up the wave..</span>"
		else
			user << "<span class='notice'>You've picked up a signal! The radio's frequency is ... [attracted_radio.frequency]!</span>"
		if(prob(10))
			attracted_radio.audible_message("<span class='danger'>[src] begins buzzing loudly, as if it's picking up feedback from an unauthorized source.</span>")
		if(attracted_radio.keyslot)
			for(var/A in attracted_radio.keyslot.channels)
				user << "<span class='notice'>[A] channel frequencies are located within the radio!</span>"
				if(prob(10))
					attracted_radio.audible_message("<span class='danger'>[src] begins buzzing.</span>")
		if(attracted_radio.keyslot2)
			for(var/A in attracted_radio.keyslot2.channels)
				user << "<span class='notice'>[A] channel is located within the radio!</span>"
		var/dat = gettargetrange(user, target_radio = attracted_radio)
		user << "<span class='danger'>[dat]</span>"
		user << "<span class='alert'> *-----------------------*</span>"
		user << "<span class='alert'>Attempting to locate more radios . . .</span><BR>"
	triggercooldown()

/obj/item/device/pulse/proc/triggercooldown()
	cooldown = 1
	spawn(PULSECOOLDOWN)
		cooldown = !cooldown

/obj/item/device/pulse/proc/gettargetrange(mob/user, var/obj/item/device/radio/headset/target_radio)
	var/shortrange = scanradius / 5
	var/midrange = scanradius / 2

	if(target_radio in view(user, shortrange))
		return "You are at a short distance from the nearby radio!"
	if(target_radio in view(user, midrange))
		return "The are at a midway distance from the radio!"
	if(target_radio in view(user, scanradius))
		return "You are at a long-range distance away from the radio!"


/obj/item/device/pulse/nanotrasen
	name = "re-engineered pulse scanner"
	desc = "During the discoverment of the Syndicates plot to be able to discover planets and stations across the galaxy, Nanotrasen sent their top spies who had discovered their prototype. Nanotrasen engineers have been able to re-engineer the pulser, but have been crippled in attempts to double the originals radius."
	scanradius = 15