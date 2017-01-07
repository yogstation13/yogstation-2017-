/obj/item/weapon/shuriken
	name = "yautja shuriken"
	desc = "An alien shruiken with strange markings drawn on the hilt of it."
	icon_state = "dread_frisbee"
	item_state = "dread_frisbee"
	force = 3
	throwforce = 5
	throw_speed = 2
	w_class = 1

/obj/item/weapon/shuriken/attack_self(mob/user)
	if(icon_state == "dread_frisbee")
		if(!ispredator(user))
			user << "<span class='warning'>It doesn't seem like the shurikens willing to open!</span>"
			return

		icon_state = "dread_frisbee_on"
		item_state = "dread_frisbee_on"
		force = 8
		throwforce = 45
		throw_speed = 10
		w_class = 4
		embed_chance = 100
		throw_range = 28
	else
		icon_state = "dread_frisbee"
		item_state = "dread_frisbee"
		force = 3
		throwforce = 5
		throw_speed = 2
		w_class = 1
		embed_chance = 0

/obj/item/weapon/shuriken/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		if(icon_state == "dread_frisbee_on")
			attack_self(user)

/obj/item/weapon/shuriken/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>A thrown Yautja weapon which is constructed with six retractable blades.</span>"

/obj/item/weapon/twohanded/spear/combistick
	name = "yautja combistick"
	desc = "A robust comat stick which looks like it'd be extremely deadly in close quarters."
	icon_state = "pred_spear_off"
	item_state = "pred_spear_off"
	force = 3
	w_class = 1
	slot_flags = SLOT_BELT
	force_unwielded = 3
	force_wielded = 7
	throwforce = 3
	throw_speed = 1

/obj/item/weapon/twohanded/spear/combistick/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>The Combistick is telescopic, making it relatively small and easy to store when not in use \
	but extending to its full length when required in combat. It is made of incredibly light, sharp, thin \
	but strong material. It can be used both as a close-quarters hand-to-hand weapon usually when your primary \
	weapon is unavaiable. It is recommended to use this as a spear</span>"

/obj/item/weapon/twohanded/spear/combistick/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		if(icon_state == "pred_spear_on")
			attack_self(user)

/obj/item/weapon/twohanded/spear/combistick/attack_self(mob/user)
	if(!ispredator(user))
		user << "<span class='alert'>You have no idea how to operate this...</span>"
		if(prob(99))
			return
		else
			user << "<span class='alert'>[src] expands rapidly!</span>"

	if(icon_state == "pred_spear_off")
		icon_state = "pred_spear_on"
		item_state = "pred_spear_on"
		force = 15
		w_class = 5
		slot_flags = SLOT_BACK
		force_unwielded = 15
		force_wielded = 15
		throwforce = 18
		throw_speed = 7
		embedded_impact_pain_multiplier = 2
		embed_chance = 100
	else
		icon_state = "pred_spear_off"
		item_state = "pred_spear_off"
		force = 3
		w_class = 1
		slot_flags = SLOT_BELT
		force_unwielded = 3
		force_wielded = 3
		throwforce = 3
		throw_speed = 1
		embedded_impact_pain_multiplier = 1
		embed_chance = 0

/obj/item/clothing/head/helmet/space/hardsuit/predator
	name = "yautja bio-mask"
	desc = "A specialized mask incorporating a breathing apparatus and diagnostics. \
	It is composed of unknown materials and appears to be resistant to all forms of damage."
	icon_state = "predator-helmet"
	item_state = "predator-helmet"
	item_color = "pred"
	armor = list(melee = 45, bullet = 5, laser = 5, energy = 10, bomb = 5, bio = 100, rad = 75)
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	actions_types = list(/datum/action/item_action/toggle_helmet_light)


/obj/item/clothing/head/helmet/space/hardsuit/predator/attack_self(mob/user)
	if(!ispredator(user))
		return

	on = !on
	if(on)
		user.sight = SEE_MOBS
		user.see_invisible = SEE_INVISIBLE_MINIMUM
		blockTracking = 1
		user << "<span class='danger'>You activate your helmets thermal imaging and low-light amplification systems. This will also block tracking from potential enemy forces.</span>"

	else
		user.see_invisible = SEE_INVISIBLE_LIVING
		user.sight &= ~SEE_MOBS
		blockTracking = 0
		user << "<span class='danger'>You deactivate your helmets special functions. You are now vunerable to tracking.</span>"

/obj/item/clothing/suit/space/hardsuit/predator
	name = "yautja plate armour"
	desc = "A special multi-layer suit capable of resisting all forms of damage. \
	It is extremely light and is composed of unknown materials. Comes equipped with a plasma \
	gun attached to the back of the outer plate."
	icon_state = "predatorarmor"
	item_state = "predatorarmor"
	slowdown = 0
	armor = list(melee = 20, bullet = 5, laser = 30, energy = 10, bomb = 45, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/twohanded/spear/combistick, /obj/item/weapon/shuriken)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/predator
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	var/datum/action/retractwristblades/retract

/obj/item/clothing/suit/space/hardsuit/predator/New()
	..()
	retract = new(src)

/obj/item/clothing/suit/space/hardsuit/predator/equipped(mob/user)
	..()
	if(user)
		retract.Grant(user)

/obj/item/clothing/suit/space/hardsuit/predator/unequipped(mob/user)
	..()
	if(user)
		retract.Remove(user)

/datum/action/retractwristblades
	name = "Toggle Wristblades"

/datum/action/retractwristblades/Trigger()
	var/mob/user = owner
	if(isliving(user))
		var/mob/living/L = user
		var/gethand = user.get_active_hand()
		if(gethand == src)
			return
		if(!gethand)
			var/stealthed = get_turf(user.loc)
			var/obj/item/weapon/predator/PT = new /obj/item/weapon/predator(stealthed)
			PT.owner = src
			L.put_in_active_hand(PT)
			user << "<span class='notice'>You retract your wrist blade!</span>"
		else if(istype(gethand, /obj/item/weapon/predator))
			var/obj/item/weapon/predator/wristblade = gethand
			if(wristblade.owner == src)
				qdel(wristblade)
				user << "<span class='notice'>You retract your wristblade!</span>"
		else
			user << "<span class='danger'>There is something in your hand! You cannot extend your blades.</span>"

/obj/item/weapon/predator
	name = "wristblade"
	desc = "An extremely sharp alien blade that illuminates sharply in the light."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "wristblade"
	item_state = "wristblade"
	flags = NODROP
	force = 24
	sharpness = IS_SHARP
	var/owner
	block_chance = 75

/obj/item/weapon/predator/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>The weapon of choice for Predators, and preferred use for close range combat fights. \
	Connected to their skinsuit, this weapon is regularly used to decapitate prey dead or alive</span>"

/obj/item/weapon/predator/attack_self(mob/user)
	if(owner)
		user << "<span class='notice'>You retract your wrist blades!</span>"
		qdel(src)

/obj/item/weapon/predator/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	if(damage && attack_type == MELEE_ATTACK && prob(final_block_chance))
		visible_message("<span class='danger'>[owner] deflects [attack_text] with [src] creating a resonating noise!</span>")
		return 1
	return 0

/obj/item/weapon/predator/dropped() // if we somehow drop it, maybe through explosion or torn off, whoever finds it earns it
	if(owner)
		owner = null
	if(flags & NODROP)
		flags &= ~NODROP
	..()

/obj/item/weapon/storage/belt/mining/yautija
	name = "yautija trophy sac"
	desc = "If you don't have the stomach for it don't peek."
	max_w_class = 5
	storage_slots = 7
	can_hold = list(/obj/item/bodypart/head)

/obj/item/clothing/shoes/predator
	name = "predator feet"
	desc = "these look really odd... wait, how the hell are you reading this?"
	icon_state = null
	item_state = null
	flags = NODROP | NOSLIP | ABSTRACT

/obj/item/clothing/under/predator
	name = "predator torso"
	icon_state = null
	item_state = null
	flags = NODROP | ABSTRACT

/*
		***************************
			YAUTIJA WRIST COMPUTER
		***************************

		* Power Node - allows us to suck the power out of things
		* Cloaking Device - makes us cloaked. not as strong as a ninjas.
		* Distraction Device - fakes a headset message, and fools xenomorphs as well.
		* Hacking Setting - virtually an emag
		* Sacrifice Setting - only works on dead hunters that still have their wrist computer with them.


		Activating it / using action button triggers the selected mode.
		CTRL click changes the mode.
*/

#define POWER_MODE			1
#define CLOAKING_MODE		2
#define DISTRACTION_MODE	3
#define HACKING_MODE		4
#define SACRIFICE_MODE		5

/obj/item/yautijacomputer
	name = "alien wrist computer"
	desc = "It comes with thousands of interesting buttons and switches to press, and a very strange language that it loads with."
	throw_range = 1
	var/wired = TRUE
	var/setting = POWER_MODE
	var/drainrate = 10
	var/powerlore = "<span class='warning'>This mode is used to drain power from machines and devices allowing the wrist computer to function. Without it the wrist computer will shut down forever.</span>"
	var/powerstatus = FALSE // obviously false is off, true is on.
	var/cloakinglore = "<span class='warning'>This mode is used to toggle the cloaking feature equipped to the wrist computer. Cloaking yourself will not drain power, however toggling in and out of it will.</span>"
	var/cloakingstatus = FALSE
	var/cloakingdrain = 100
	var/destractinglore = "<span class='warning'>This mode is used to create a distraction by imitating a radio signal.</span>"
	var/destractiondrain = 100
	var/destractionstatus = FALSE
	var/hackinglore = "<span class='warning'>This mode enables our hacking feature. The longer this is activated for, the more it will drain our power.</span>"
	var/hackingdrain = 50
	var/sacrificelore = "<span class='warning'>This mode is used for sacrificing our fellow hunters who have been defeated in battle. It requires a dead yautija that still has their wrist computer with them. Activate it, and in ten seconds their remote will spark a gigantic explosion.</span>"
	var/obj/item/weapon/stock_parts/cell/hyper/cell // powerful yautija equipment. operates on the same cell as science.

/obj/item/yautijacomputer/New()
	..()
	powercell = new(src)

/obj/item/yautijacomputer/examine(mob/user)
	..()
	user << "<span class='warning'>There's a panel that reads [cell.charge]%.</span>"

/obj/item/yautijacomputer/process()
	if(wired)
		if(!powercell.charge)
			triggerFailure()
		else if(powercell.charge < drainrate)
			triggerFailure()
		else
			cell.charge -= drain

/obj/item/yautijacomputer/proc/triggerFailure() // systems fail, so we reverse everything.
	wired = FALSE
	cancelmode("all")

/obj/item/yautijacomputer/attack_self(mob/user)
	if(!ispredator(user))
		user << "<span class='warning'>The blasted thing won't work! It's looking for something, but whatever it is - it's not you!</span>"
		return

	if(!powercell.charge || !wired)
		user << "<span class='warning'>[src] is out of charge, and can no longer function.</span>"
		return

	switch(setting)
		if(POWER_MODE)
			poweract(user)
		if(CLOAKING_MODE)
			cloakact(user)
		if(DISTRACTION_MODE)
			distractact(user)
		if(HACKING_MODE)
			hackingact(user)
		if(SACRIFICE_MODE)
			sacrificeact(user)

/obj/item/yautijacomputer/CtrlClick()
	if(!(Adjacent(usr)))
		return

	var/mob/user = usr
	if(!ispredator(user))
		user << "<span class='warning'>Most of the information is encrypted in an alien-like language!</span>"
		return

	cancelmode(setting)

	var/toggle = input(user, "[src]", "[src]") as null|anything in list("Power Mode", "Cloaking Mode", "Distraction Mode", "Hacking Mode", "Sacrifice Mode")
	if(!toggle)
		return
	switch(toggle)
		if("Power Mode")
			setting = POWER_MODE
			user << powerlore
		if("Cloaking Mode")
			setting = CLOAKING_MODE
			user << cloakinglore
		if("Distraction Mode")
			setting = DISTRACTION_MODE
			user << distractionlore
		if("Hacking Mode")
			setting = HACKING_MODE
			user << hackinglore
		if("Sacrifice Mode")
			setting = SACRIFICE_MODE
			user << sacrificelore

	playsound(loc, 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/yautijacomputer/proc/cancelmode(type, mob/user) // undoes anything from a previous mode before we switch over.
	if(!type)
		return

	switch(type)
		if("all")
			cancelmode(POWER_MODE)
			cancelmode(CLOAKING_MODE)
			cancelmode(HACKING_MODE)
			cancelmode(DISTRACTION_MODE)
			cancelmode(SACRIFICE_MODE)

		if(POWER_MODE)
			if(powerstatus)
				powerstatus = FALSE

		if(CLOAKING_MODE)
			if(cloakingstatus)
				cloakingstatus = FALSE
				if(user)
					animate(user, alpha = 255,time = 5)

		if(DISTRACTION_MODE)
			if(destractionstatus)
				destractionstatus = FALSE

		if(HACKING_MODE)

		if(SACRIFICE_MODE)


/obj/item/yautijacomputer/proc/poweract(mob/user)
	user << "<span class='notice'>You [powerstatus == FALSE ? "de" : ""]activate [src]'s power mode.</span>'
	powerstatus = !powerstatus

/obj/item/yautijacomputer/afterattack(atom/target, mob/user, proximity_flag)
	if(distractionstatus)
		if(istype(target, mob/living/carbon/human))
			set_up_distract(user, H)
	..()
	if(powerstatus)
		if(istype(target, /obj/machinery/power/apc))
			PoolOrNew(/obj/effect/particle_effect/sparks, get_turf(target))
			var/obj/machinery/power/apc/apc = target
			if(apc.cell)
				if(apc.cell.charge && (apc.cell.charge - drainrate))
					var/absorb = clamp(cell.charge - drainrate, 0, apc.cell.maxcharge)
					apc.cell.use(absorb)
					user << "<span class='warning'>[src] gains [absorb]% more energy.</span>"

/obj/item/yautijacomputer/proc/cloakact(mob/user, force)
	if(force)
		user << "<span class='notice'>Your cloaking mode is deactivated!</span>"
	else
		user << "<span class='notice'>You toggle your cloaking mode.</span>"
	cloakingstatus = !cloakingstatus
	if(cloakingstatus)
		if(exchangecost(cloakdrain))
			animate(user, alpha = 10,time = 15)
		else
			user << "<span class='warning'>Your cloaking mode cannot sustain it'self without power. Shutting down.</span>"
			cancelmode(CLOAKING_MODE)
			return

		var/turf/T
		while(cloakingstatus)
			T = user.loc
			if(T.lighting_lumcount >= 15)
				cloakact(user, 1)
				break
	else
		animate(user, alpha = 255,time = 15)
		visible_message("<span class='warning'>[user] is exposed!</span>")

/obj/item/yautijacomputer/proc/exchangecost(num) // returning false means it cannot be done
	if(!num)
		return 0

	if(cell.charge > num)
		cell.charge -= num
		return 1
	else
		return 0

/obj/item/yautijacomputer/proc/distractact(mob/user)
	distractionstatus = !distractionstatus
	user << "<span class='warning'>You [destractionstatus == TRUE ? "enable" : "disable"] your distraction mode.</span>"
	if(distractionstatus)
		if(!(exchangecost(distractiondrain)))
			cancelmode(DISTRACTION_MODE)
			user << "<span class='warning'>Distraction mode shuts down!</span>"

/obj/item/yautijacomputer/proc/set_up_distract(mob/user, mob/living/carbon/human/H)
	var/cancelledtext = "<span class='warning'>Distraction cancelled.</span>"
	if(user && H)
		var/freq = input(user, "Choose the department", "Distraction Set Up", src) as null|anything in list("Common", "Service", "Supply", "Medical", "Security", "Engineering", "Command")
		if(freq)
			var/chosenfreq
			switch(freq)
				if("Common") chosenfreq = "radio"
				if("Service") chosenfreq = "servradio"
				if("Supply") chosenfreq = "suppradio"
				if("Medical") chosenfreq = "medradio"
				if("Security") chosenfreq = "secradio"
				if("Engineering") chosenfreq = "engradio"
				if("Command") chosenfreq = "comradio"

			var/fakename = input(user, "Choose a name", "Distraction Set Up", src)
			if(fakename)
				user << "<span class='warning'>You have selected [fakename].</span>"
				var/fakedat = input(user, "Print out a message", "Distraction Set Up", src)
				if(fakedat)
					var/fakemsg = "\[[freq]\] [fakename] says, \"[fakedat]\""
					H << fakemsg
					user << "<span class='notice'>You have sent \"[fakemsg]\" to [H].</span>"
				else
					user << cancelledtext
			else
				user << cancelledtext
		else
			user << cancelledtext