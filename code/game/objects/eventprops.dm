//NOTICE//
//Kmc here, this is stuff for an event I have planned, guidelines for use://
//You need to supply a laserbattery and the death laser and a firing_console and a planet to blow up//
//After they have screwed the battery into the grid, it can begin charging, it takes a SHIT load of power to actually charge this thing and should take about 20 minutes or so to charge//
//After it charges, it fires. You need to make it do stuff after it fires as it's a fluff thing. Think of it like a giant prop!//

/obj/machinery/deathray
	icon = 'icons/obj/lavaland/deathray.dmi'
	icon_state = "base"
	density = 0			//the idea is that you walk over this as it fits into the floor
	anchored = 1
	can_be_unanchored = 0
	name = "FLEIJA mkIV laser"
	desc = "An immensely powerful mounted laser cannon, the immense weight is held with a large truss and mounting points, it is mounted below the station and requires an external power supply to operate"
	var/ready = 0
	var/firing = 0


/obj/planet
	icon = 'icons/obj/planet.dmi'
	icon_state = "planet"
	density = 0			//it's in the distance
	anchored = 1
	can_be_unanchored = 0
	name = "planet"
	desc = "A beautiful planet that glows red, it is very far in the distance"
	var/random
	var/destroyed = 0

/obj/planet/proc/kaboom()
	if(!destroyed) //dont blow up an already blown up planet
		playsound_global('sound/effects/planetdeath.ogg', repeat=0, channel=1, volume=100)
		random = rand(100, 4000)
		icon_state = "explosion"
		name = "Debris Field"
		desc = "A husk of a once large planet floating in the distance, it makes you feel remorse for all the people who once lived down there..."
		destroyed = 1
		for(var/mob/M in mob_list)
			shake_camera(M, 15, 1)
			continue
		sleep(100)
		icon_state = "destroyed"
		priority_announce("Outpost [random]. respond! we just lost contact, are you alright..!? RESPOND!", "Syndicate Open Broadcast", 'sound/AI/commandreport.ogg')
		sleep(500)
		random = rand(10000,99999)
		priority_announce("This is syndicate command, we just lost [random] civilians in a massive strike!", "Syndicate Open Broadcast", 'sound/AI/commandreport.ogg')


//a massive death ray that hangs low, below the station

/obj/machinery/deathray/proc/shake_everyone() //copy paste from gravgen
	var/turf/T = get_turf(src)
	for(var/mob/M in mob_list)
		if(M.z != z)
			continue
		M.update_gravity(M.mob_has_gravity())
		if(M.client)
			shake_camera(M, 15, 1)
			M.playsound_local(T, 'sound/effects/alert.ogg', 100, 1, 0.5)


/obj/machinery/deathray/proc/fire()
	icon_state = "fire"
	shake_everyone()
	playsound_global('sound/effects/laserfire.ogg', repeat=0, channel=1, volume=75)
	sleep(4)
	icon_state = "fired"
	sleep(100) //10 seconds
	icon_state = "poweringdown"
	sleep(20)
	icon_state = "base"
	firing = 0
	ready = 0
	for(var/obj/item/device/laserbattery/L in world)
		L.firing = 0

	for(var/obj/planet/P in world)
		P.kaboom() //blow up the planet


/obj/machinery/deathray/proc/charge()
	icon_state = "powering"
	playsound_global('sound/effects/clockcult_gateway_disrupted.ogg', repeat=0, channel=1, volume=75)
	sleep(100)
	fire()


//Trademarked Kmc code whitespace TM//

/obj/machinery/firing_console 	//fluff
	icon = 'icons/obj/computer.dmi'
	icon_state = "deathray1"
	name = "Ballistic Calibration Computer"
	density = 1
	anchored = 1


//obj/machinery/firing_console/New()
//	START_PROCESSING(SSobj, src)

//obj/machinery/firing_console/process()
//	if(!spam)
//		calibrate()
//		spam = 1
//	else if (spam)
//		return


//obj/machinery/firing_console/proc/calibrate()
//	sleep(3000) //5 mins
//	switch(state)
//		if(1) //if it was on state 1, make it state 2
//			icon_state = "deathray2"
//			state = 2
//			return
//		if(2)
//			icon_state = "deathray3"
//			state = 3
//			return

//	if(state == 3)
//		if(!spam)
//			priority_announce("ERROR Fleija charging impaired, energy runoff CRITICAL, firing console is not calibrated.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
//			spam = 1
//			for(var/obj/item/device/laserbattery/L in world) //find our laser batteries and drain them
//				L.drain_rate = 0 //battery cannot charge whilst console is out of order
//				return


/obj/machinery/firing_console/attack_hand(mob/user) //type that shit to recalibrate!
	playsound(src,'sound/effects/typing.ogg',25,1)
	src.say("Recalibration complete")




/obj/machinery/firing_console/attack_ai(mob/user)
	playsound(src,'sound/effects/typing.ogg',25,1)


//End whitespace//

//modded powersink to act as a  battery for the death ray, it won't explode but will warn admins so they can fire the deathray
/obj/item/device/laserbattery
	desc = "A large battery used to charge the MK. Fleija orbital laser."
	name = "fleija laser energy core"
	icon_state = "laserbattery0"
	item_state = "electronic"
	w_class = 4
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	materials = list(MAT_METAL=750)
	origin_tech = "powerstorage=5;syndicate=5"
	var/drain_rate = 1600000	// amount of power to drain per tick
	var/power_drained = 0 		// has drained this much power
	var/max_power = 4e8		// power required to fire the laser
	var/mode = 0		// 0 = off, 1=clamped (off), 2=operating
	var/admins_warned = 0 // stop spam, only warn the admins once, when we are ready to fire

	var/const/DISCONNECTED = 0
	var/const/CLAMPED_OFF = 1
	var/const/OPERATING = 2
	var/warned20 = 0
	var/warned50 = 0
	var/warned70 = 0
	var/firing = 0 //is the laser firing? prevents spam
	var/percentage

	var/obj/structure/cable/attached		// the attached cable

/obj/item/device/laserbattery/examine(mob/user)
	..()
	percentage = (power_drained / max_power) * 100
	user<< "<span class='notice'>[src] is [percentage] % full.</span>"


/obj/item/device/laserbattery/update_icon()
	icon_state = "laserbattery[mode == OPERATING]"

/obj/item/device/laserbattery/proc/set_mode(value)
	if(value == mode)
		return
	switch(value)
		if(DISCONNECTED)
			attached = null
			if(mode == OPERATING)
				STOP_PROCESSING(SSobj, src)
			anchored = 0
			density = 0

		if(CLAMPED_OFF)
			if(!attached)
				return
			if(mode == OPERATING)
				STOP_PROCESSING(SSobj, src)
			anchored = 1
			density = 1

		if(OPERATING)
			if(!attached)
				return
			START_PROCESSING(SSobj, src)
			anchored = 1
			density = 1

	mode = value
	update_icon()
	SetLuminosity(0)

/obj/item/device/laserbattery/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(mode == DISCONNECTED)
			var/turf/T = loc
			if(isturf(T) && !T.intact)
				attached = locate() in T
				if(!attached)
					to_chat(user, "<span class='warning'>This device must be placed over an exposed, powered cable node!</span>")
				else
					set_mode(CLAMPED_OFF)
					user.visible_message( \
						"[user] attaches \the [src] to the cable.", \
						"<span class='notice'>You attach \the [src] to the cable.</span>",
						"<span class='italics'>You hear some wires being connected to something.</span>")
			else
				to_chat(user, "<span class='warning'>This device must be placed over an exposed, powered cable node!</span>")
		else
			set_mode(DISCONNECTED)
			user.visible_message( \
				"[user] detaches \the [src] from the cable.", \
				"<span class='notice'>You detach \the [src] from the cable.</span>",
				"<span class='italics'>You hear some wires being disconnected from something.</span>")
	else
		return ..()

/obj/item/device/laserbattery/attack_paw()
	return

/obj/item/device/laserbattery/attack_ai()
	return

/obj/item/device/laserbattery/attack_hand(mob/user)
	switch(mode)
		if(DISCONNECTED)
			..()

		if(CLAMPED_OFF)
			user.visible_message( \
				"[user] activates \the [src]!", \
				"<span class='notice'>You activate \the [src].</span>",
				"<span class='italics'>You hear a loud whir.</span>")
			message_admins("Laser charging sequence begun by:[key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
			set_mode(OPERATING)

		if(OPERATING)
			user.visible_message( \
				"[user] deactivates \the [src]!", \
				"<span class='notice'>You deactivate \the [src].</span>",
				"<span class='italics'>You hear a click.</span>")
			set_mode(CLAMPED_OFF)

/obj/item/device/laserbattery/proc/charged()
	if(!firing)
		priority_announce("FLEIJA LASER CHARGED: Target: CONFIRMED. PREPARING TO FIRE.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
		message_admins("Laser battery at([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) is charged, death ray will fire soon!.")
		power_drained = 0
		set_mode(CLAMPED_OFF)
		warned20 = 0	//reset the warnings
		warned50 = 0
		warned70 = 0
		firing = 1
		for(var/obj/machinery/deathray/L in world) //fire all lasers in the world
			L.ready = 1
			L.charge()
		STOP_PROCESSING(SSobj, src)


/obj/item/device/laserbattery/process()
	if(!attached)
		set_mode(DISCONNECTED)
		return

	var/datum/powernet/PN = attached.powernet
	if(PN)
		SetLuminosity(5)

		// found a powernet, so drain up to max power from it
		percentage = (power_drained / max_power) * 100

		var/drained = min ( drain_rate, PN.avail )
		PN.load += drained
		power_drained += drained

		// if tried to drain more than available on powernet
		// now look for APCs and drain their cells
		if(drained < drain_rate)
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				if(istype(T.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/A = T.master
					if(A.operating && A.cell)
						A.cell.charge = max(0, A.cell.charge - 50)
						power_drained += 50
						if(A.charging == 2) // If the cell was full
							A.charging = 1 // It's no longer full

	if(power_drained > max_power * 0.20)
		if(!warned20) //prevent spam
			priority_announce("WARNING Fleija laser battery capacity at 20%, continue to supply power.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
			warned20 = 1

	if(power_drained > max_power * 0.50)
		if(!warned50)
			priority_announce("WARNING Fleija laser battery capacity at 50%, continue to supply power.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
			warned50 = 1
	if(power_drained > max_power * 0.70)
		if(!warned70)
			priority_announce("WARNING Fleija laser battery capacity at 70%, continue to supply power.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
			warned70 = 1

	if(power_drained > max_power * 0.98)
		if (!admins_warned)
			admins_warned = 1
			message_admins("Laser battery at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) is 95% full, firing will commence shortly.")
		priority_announce("WARNING Fleija laser battery capacity at 95%, adjusting aim trajectory.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')
		playsound_global('sound/effects/alert.ogg', repeat=0, channel=1, volume=75)

	if(power_drained >= max_power)
		charged()

