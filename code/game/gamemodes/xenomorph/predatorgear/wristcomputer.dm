
/*
		***************************
			YAUTIJA WRIST COMPUTER
		***************************
		by Super3222

		* Power Node - allows us to suck the power out of things
		* Cloaking Device - makes us cloaked. not as strong as a ninjas.
		* Distraction Device - fakes a headset message, and fools xenomorphs as well.
		* Hacking Setting - virtually an emag
		* Sacrifice Setting - only works on dead hunters that still have their wrist computer with them.


		Activating it / using action button triggers the selected mode.
		CTRL click changes the mode.

		Possibilities in the future:
		- Emagging triggers boom()?
		- EMP's continue to do nothing?
*/

#define POWER_MODE			"power"
#define CLOAKING_MODE		"cloak"
#define DISTRACTION_MODE	"distract"
#define HACKING_MODE		"hack"
#define SACRIFICE_MODE		"sacrifice"

/obj/item/yautijaholster
	name = "computer holster"
	desc = "Holds the Yautija alien technology."
	icon_state = "computer_y"
	throw_range = 1
	slot_flags = SLOT_ID
	burn_state = FIRE_PROOF
	var/loggedin
	var/obj/item/yautijacomputer/YC
	actions_types = list(/datum/action/item_action/togglecomp)

/datum/action/item_action/togglecomp
	name = "Toggle Computer"
	button_icon_state = "computeractivate" // I guess this goes here....?

/obj/item/yautijaholster/New()
	..()
	YC = new(src)

/obj/item/yautijaholster/attack_self(mob/user)
	if(loggedin)
		if(ishuman(user))
			extend_computer(user)
		return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.wear_id != src)
			user << "<span class='warning'>You need [src] in your ID slot to log in.</span>"
			return
		loggedin = TRUE
		flags |= NODROP
		user << "<span class='notice'>You sucessfully log into the holster. [src] strings around your wrist, and clutches it.</span>"

/obj/item/yautijaholster/proc/extend_computer(mob/living/carbon/human/H)
	var/gethand = H.get_active_hand()
	if(!gethand)
		YC.forceMove(get_turf(H))
		H.put_in_active_hand(YC)
		H << "<span class='notice'>The computer screen rises.</span>"
	else if(gethand == YC)
		H.unEquip(YC, TRUE)
		YC.forceMove(src)
		H <<"<span class='notice'>The screen collapses back into the wrist computer.</span>"
		YC.cancelmode("all", H)
	else
		H << "<span class='warning'>There is something in your hand.</span>"

/datum/action/item_action/activatecomputer
	name = "Activate Yautija Computer"
	button_icon_state = "computeractivate"

/obj/item/yautijacomputer
	name = "alien wrist computer"
	desc = "It comes with thousands of interesting buttons and switches to press, but it's coded a very alien like language."
	throw_range = 1
	slot_flags = SLOT_ID
	actions_types = list(/datum/action/item_action/activatecomputer, /datum/action/item_action/switchcomputermode)
	icon_state = "cuff_red"
	item_state = "cuff_red"
	flags = NODROP
	icon_state = "screen_y"
	item_state = "screen_y"
	burn_state = FIRE_PROOF
	var/wired = TRUE
	var/loggedin
	var/setting = POWER_MODE
	var/drainrate = 50
	var/powerlore = "<span class='warning'>This mode is used to drain power from machines and devices allowing the wrist computer to function. Without it the wrist computer will shut down forever.</span>"
	var/powerstatus = FALSE // obviously false is off, true is on.
	var/cloakinglore = "<span class='warning'>This mode is used to toggle the cloaking feature equipped to the wrist computer. Cloaking yourself will not drain power, however toggling in and out of it will.</span>"
	var/cloakingstatus = FALSE
	var/cloakingdrain = 500
	var/distractionlore = "<span class='warning'>This mode is used to create a distraction by imitating a radio signal.</span>"
	var/distractiondrain = 500
	var/distractionstatus = FALSE
	var/hackinglore = "<span class='warning'>This mode enables our hacking feature. The longer this is activated for, the more it will drain our power.</span>"
	var/hackingstatus = FALSE
	var/hackingdrain = 100
	var/sacrificelore = "<span class='warning'>This mode is used for sacrificing our fellow hunters who have been defeated in battle. It requires a dead yautija that still has their wrist computer with them. Activate it, and in ten seconds their remote will spark a gigantic explosion.</span>"
	var/sacrificestatus = FALSE
	var/obj/item/weapon/stock_parts/cell/hyper/cell // powerful yautija equipment. operates on the same cell as science.
	var/image/pdarightoverlay

/obj/item/yautijacomputer/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	if(damage > 10)
		cancelmode("all", owner)
		owner << "<span class='warning'>The incoming blow connects with [src]!</span>"
	return 0

/obj/item/yautijacomputer/New()
	..()
	cell = new(src)

/obj/item/yautijacomputer/equipped(mob/user)
	..()
	pdarightoverlay = image('icons/mob/predators.dmi', "pda_right")
	user.overlays += pdarightoverlay

/obj/item/yautijacomputer/unequipped(mob/user)
	..()
	user.overlays -= pdarightoverlay
	pdarightoverlay = null
	flags &= ~NODROP

/obj/item/yautijacomputer/examine(mob/user)
	..()
	user << "<span class='warning'>There's a panel that reads [cell.charge]%.</span>"

/obj/item/yautijacomputer/process()
	if(wired)
		if(cloakingstatus)
			if(istype(loc, /mob/living/carbon/human))
				var/turf/T = get_turf(loc)
				if(T.lighting_lumcount >= 9)
					cloakact(loc, 1)
		if(!cell.charge)
			triggerFailure()
		else if(cell.charge < drainrate)
			triggerFailure()
		else
			cell.charge -= drainrate
		if(hackingstatus)
			exchangecost(hackingdrain)

/obj/item/yautijacomputer/proc/triggerFailure() // systems fail, so we reverse everything.
	wired = FALSE
	cancelmode("all")

/obj/item/yautijacomputer/attack_self(mob/user)
	if(!ispredator(user))
		user << "<span class='warning'>The blasted thing won't work! It's looking for something, but whatever it is - it's not you!</span>"
		return

	if(!cell.charge || !wired)
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


/datum/action/item_action/switchcomputermode
	name = "Switch Computer Mode"
	button_icon_state = "computertoggle"

/datum/action/item_action/switchcomputermode/Trigger()
	if(!..())
		return FALSE
	if(target)
		var/obj/item/I = target
		I.CtrlClick()
	return TRUE


/obj/item/yautijacomputer/CtrlClick()
	if(!(Adjacent(usr)))
		return

	var/mob/user = usr
	if(!ispredator(user))
		user << "<span class='warning'>Most of the information is encrypted in an alien-like language!</span>"
		return FALSE

	cancelmode("all")

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
			if(distractionstatus)
				distractionstatus = FALSE

		if(HACKING_MODE)
			if(hackingstatus)
				hackingstatus = FALSE

		if(SACRIFICE_MODE)
			if(sacrificestatus)
				sacrificestatus = FALSE

/obj/item/yautijacomputer/proc/poweract(mob/user)
	powerstatus = !powerstatus
	user << "<span class='notice'>You [powerstatus == FALSE ? "de" : ""]activate [src]'s power mode.</span>"

/obj/item/yautijacomputer/afterattack(atom/target, mob/user, proximity_flag)
	if(distractionstatus)
		if(istype(target, /mob/living/carbon/human))
			set_up_distract(user, target)
	if(hackingstatus)
		if(istype(target, /obj/))
			target.emag_act(user)

	if(sacrificestatus)
		if(istype(target, /mob/living/carbon/human))
			if(target == user)
				user << "<span class='warning'>You can't use this ability on yourself.</span>"
				return
			var/mob/living/T = target
			if(T.health > 0)
				user << "<span class='warning'>They are still alive.</span>"
				return

			user << "<span class='warning'>Your target has been confirmed. Now searching for the yautija wrist computer...</span>"
			var/obj/item/yautijacomputer/Y = locate() in target
			if(Y)
				user << "<span class='notice'>The wrist computer has been discovered! Now activating the self destruct mechanism...</span>"
				if(do_after(user, 50, target = target))
					user << "<span class='notice'>Farewell, fallen hunter.</span>"
					Y.boom()
	..()
	if(powerstatus)
		if(istype(target, /obj/machinery/power/apc))
			PoolOrNew(/obj/effect/particle_effect/sparks, get_turf(user))
			var/obj/machinery/power/apc/apc = target
			if(apc.cell)
				if(apc.cell.charge && (apc.cell.charge - drainrate))
					var/absorb = Clamp(cell.charge - drainrate, 0, apc.cell.maxcharge)
					apc.cell.use(absorb)
					user << "<span class='warning'>[src] gains [absorb]% more energy.</span>"
					PoolOrNew(/obj/effect/particle_effect/sparks, get_turf(user))

	if(istype(target, /obj/item/yautijaholster))
		var/obj/item/yautijaholster/YH = target
		if(YH.YC == src)
			user.unEquip(src, TRUE)
			forceMove(YH)
			user << "<span class='notice'>You store [src] back in [YH].</span>"

/obj/item/yautijacomputer/proc/cloakact(mob/user, force)
	if(force)
		user << "<span class='notice'>Your cloaking mode is deactivated!</span>"
	else
		user << "<span class='notice'>You toggle your cloaking mode.</span>"
	cloakingstatus = !cloakingstatus
	if(cloakingstatus)
		if(exchangecost(cloakingdrain))
			animate(user, alpha = 10,time = 15)
		else
			user << "<span class='warning'>Your cloaking mode cannot sustain it'self without power. Shutting down.</span>"
			cancelmode(CLOAKING_MODE)
			return
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
	user << "<span class='warning'>You [distractionstatus == TRUE ? "enable" : "disable"] your distraction mode.</span>"
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

			var/fakename = stripped_input(user, "Choose a name", "Distraction Set Up", src)
			if(fakename)
				user << "<span class='warning'>You have selected [fakename].</span>"
				var/fakedat = stripped_input(user, "Print out a message", "Distraction Set Up", src)
				if(fakedat)
					if(exchangecost(distractiondrain))
						var/fakemsg = "<B><span class='[chosenfreq]'>\[[freq]\] [fakename] </B>says, \"[fakedat]\"</span>"
						H << fakemsg
						user << "<span class='notice'>You have sent \"[fakemsg]\" to [H].</span>"
					else
						user << "<span class='notice'>You don't have enough power to use this.</span>"
				else
					user << cancelledtext
			else
				user << cancelledtext
		else
			user << cancelledtext

/obj/item/yautijacomputer/proc/hackingact(mob/user)
	if(exchangecost(hackingdrain))
		hackingstatus = !hackingstatus
		user << "<span class='warning'>You have [hackingstatus == TRUE ? "enabled" : "disabled"] subspace hacking mode</span>"
	else
		user << "<span class='warning'>You don't have enough power to toggle your hacking mode.</span>"

/obj/item/yautijacomputer/proc/sacrificeact(mob/user)
	sacrificestatus = !sacrificestatus
	user << "<span class='warning'>You [sacrificestatus == TRUE ?  "enable" : "disable"] your sacrifice module.[sacrificestatus == TRUE ? "This only works on fallen warriors" : ""].</span>"

/obj/item/yautijacomputer/proc/boom()
	visible_message("<span class='warning'>[src] is lighting up and beeping! It's going to go off!</span>",
					"<span class='warning'>[src] is lighting up and beeping! It's going to go off!</span>")
	flags |= NODROP
	sleep(500)
	explosion(loc,2,2,4,flame_range = 14)
