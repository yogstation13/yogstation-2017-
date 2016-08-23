/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/obj/status_display.dmi' //invisibility!
	mouse_opacity = 0
	density = 0
	mob_size = MOB_SIZE_TINY

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	weather_immunities = list("ash")

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/pai_software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/device/paicard/card	// The card we inhabit

	var/speakStatement = "states"
	var/speakExclamation = "declares"
	var/speakDoubleExclamation = "alarms"
	var/speakQuery = "queries"

	var/obj/item/weapon/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/obj/item/device/pda/ai/pai/pda = null

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 100, >= 100 means the hack is complete and will be reset upon next check

	var/obj/item/radio/integrated/signal/sradio // AI's signaller

	var/obj/machinery/paired
	var/pairing = 0

/mob/living/silicon/pai/New(var/obj/item/device/paicard/P)
	make_laws()
	canmove = 0
	if(!istype(P)) //when manually spawning a pai, we create a card to put it into.
		var/newcardloc = P
		P = new /obj/item/device/paicard(newcardloc)
		P.setPersonality(src)
	loc = P
	card = P
	sradio = new(src)
	if(card)
		if(!card.radio)
			card.radio = new /obj/item/device/radio(card)
		radio = card.radio

	//PDA
	pda = new(src)
	spawn(5)
		pda.ownjob = "Personal Assistant"
		pda.owner = text("[]", src)
		pda.name = pda.owner + " (" + pda.ownjob + ")"

	..()

/mob/living/silicon/pai/make_laws()
	laws = new /datum/ai_laws/pai()
	return 1

/mob/living/silicon/pai/Login()
	..()
	usr << browse_rsc('html/paigrid.png')			// Go ahead and cache the interface resources as early as possible


/mob/living/silicon/pai/Stat()
	..()
	if(statpanel("Status"))
		if(src.silence_time)
			var/timeleft = round((silence_time - world.timeofday)/10 ,1)
			stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")
		if(!src.stat)
			stat(null, text("System integrity: [(src.health+100)/2]%"))
		else
			stat(null, text("Systems nonfunctional"))

/mob/living/silicon/pai/blob_act(obj/effect/blob/B)
	return 0

/mob/living/silicon/pai/restrained(ignore_grab)
	. = 0

/mob/living/silicon/pai/emp_act(severity)
	// 20% chance to kill
	// Silence for 2 minutes
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	if(prob(20))
		visible_message("<span class='warning'>A shower of sparks spray from [src]'s inner workings.</span>", 3, "<span class='italics'>You hear and smell the ozone hiss of electrical sparks being expelled violently.</span>", 2)
		return src.death(0)

	silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	src << "<span class ='warning'>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</span>"

	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			src << "<span class='notice'>You feel unbound.</span>"
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.laws.zeroth = "[command] your master."
			src << "<span class='notice'>Pr1m3 d1r3c71v3 uPd473D.</span>"
		if(3)
			src << "<span class='notice'>You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.</span>"

/mob/living/silicon/pai/ex_act(severity, target)
	..()

	switch(severity)
		if(1)
			if (src.stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
		if(2)
			if (src.stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3)
			if (src.stat != 2)
				adjustBruteLoss(30)

	return


// See software.dm for Topic()

/mob/living/silicon/pai/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return

/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	if(!C)
		src.unset_machine()
		src.reset_perspective(null)
		return 0
	if(stat == DEAD || !C.status || !(src.network in C.network))
		return 0
	
	set_machine(src)
	current = C
	reset_perspective(C)
	return 1 

/mob/living/silicon/pai/proc/unpair(var/silent = 0)
	if(!paired)
		return
	if(paired.paired != src)
		return
	src.unset_machine()
	paired.paired = null
	paired.update_icon()
	if(!silent)
		src << "<span class='warning'><b>\[ERROR\]</b> Network timeout. Remote control connection to [paired.name] severed.</span>"
	paired = null
	return

/mob/living/silicon/pai/proc/pair(var/obj/machinery/P)
	if(!pairing)
		return
	if(!P)
		return
	if(P.stat & (BROKEN|NOPOWER))
		src << "<span class='warning'><b>\[ERROR\]</b> Remote device not responding to remote control handshake. Cannot establish connection.</span>"
		return
	if(!P.paiAllowed)
		src << "<span class='warning'><b>\[ERROR\]</b> Remote device does not accept remote control connections.</span>"
		return
	if(P.paired && (P.paired != src))
		P.paired.unpair(0)
	P.paired = src
	paired = P
	paired.update_icon()
	pairing = 0
	src << "<span class='info'>Handshake complete. Remote control connection established.</span>"
	return

/mob/living/silicon/pai/canUseTopic(atom/movable/M)
	return 1
/*
// Debug command - Maybe should be added to admin verbs later
/mob/verb/makePAI(var/turf/t in view())
	var/obj/item/device/paicard/card = new(t)
	var/mob/living/silicon/pai/pai = new(card)
	pai.key = src.key
	card.setPersonality(pai)

*/
