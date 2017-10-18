/*
	New methods:
	pulse - sends a pulse into a wire for hacking purposes
	cut - cuts a wire and makes any necessary state changes
	mend - mends a wire and makes any necessary state changes
	canAIControl - 1 if the AI can control the airlock, 0 if not (then check canAIHack to see if it can hack in)
	canAIHack - 1 if the AI can hack into the airlock to recover control, 0 if not. Also returns 0 if the AI does not *need* to hack it.
	hasPower - 1 if the main or backup power are functioning, 0 if not.
	requiresIDs - 1 if the airlock is requiring IDs, 0 if not
	isAllPowerCut - 1 if the main and backup power both have cut wires.
	regainMainPower - handles the effect of main power coming back on.
	loseMainPower - handles the effect of main power going offline. Usually (if one isn't already running) spawn a thread to count down how long it will be offline - counting down won't happen if main power was completely cut along with backup power, though, the thread will just sleep.
	loseBackupPower - handles the effect of backup power going offline.
	regainBackupPower - handles the effect of main power coming back on.
	shock - has a chance of electrocuting its target.
*/

// Wires for the airlock are located in the datum folder, inside the wires datum folder.

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6
var/list/airlock_overlays = list()

/obj/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "closed"

	var/aiControlDisabled = 0 //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = 0 // if 1, this door can't be hacked by the AI
	var/secondsMainPowerLost = 0 //The number of seconds until power is restored.
	var/secondsBackupPowerLost = 0 //The number of seconds until power is restored.
	var/spawnPowerRestoreRunning = 0
	var/lights = 1 // bolt lights show by default
	secondsElectrified = 0 //How many seconds remain until the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/aiDisabledIdScanner = 0
	var/aiHacking = 0
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	var/doortype = /obj/structure/door_assembly/door_assembly_0
	var/justzap = 0
	normalspeed = 1
	var/obj/item/weapon/electronics/airlock/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	autoclose = 1
	var/obj/item/device/doorCharge/charge = null //If applied, causes an explosion upon opening the door
	var/detonated = 0
	var/doorOpen = 'sound/machines/airlock.ogg'
	var/doorClose = 'sound/machines/AirlockClose.ogg'
	var/doorDeni = 'sound/machines/DeniedBeep.ogg' // i'm thinkin' Deni's
	var/boltUp = 'sound/machines/BoltsUp.ogg'
	var/boltDown = 'sound/machines/BoltsDown.ogg'
	var/noPower = 'sound/machines/DoorClick.ogg'

	var/airlock_material = null //material of inner filling; if its an airlock with glass, this should be set to "glass"
	var/overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'

	var/image/old_frame_overlay //keep those in order to prevent unnecessary updating
	var/image/old_filling_overlay
	var/image/old_lights_overlay
	var/image/old_panel_overlay
	var/image/old_weld_overlay
	var/image/old_sparks_overlay

	explosion_block = 1

/obj/machinery/door/airlock/New()
	..()
	wires = new /datum/wires/airlock(src)
	if(src.closeOtherId != null)
		spawn (5)
			for (var/obj/machinery/door/airlock/A in airlocks)
				if(A.closeOtherId == src.closeOtherId && A != src)
					src.closeOther = A
					break
	if(glass)
		airlock_material = "glass"
	update_icon()

/obj/machinery/door/airlock/lock()
	bolt()

/obj/machinery/door/airlock/proc/bolt()
	if(locked)
		return
	locked = 1
	playsound(src,boltDown,30,0,3)
	update_icon()

/obj/machinery/door/airlock/unlock()
	unbolt()

/obj/machinery/door/airlock/proc/unbolt()
	if(!locked)
		return
	locked = 0
	playsound(src,boltUp,30,0,3)
	update_icon()

/obj/machinery/door/airlock/narsie_act()
	var/turf/T = get_turf(src)
	var/runed = prob(20)
	if(prob(20))
		if(glass)
			if(runed)
				new/obj/machinery/door/airlock/cult/glass(T)
			else
				new/obj/machinery/door/airlock/cult/unruned/glass(T)
		else
			if(runed)
				new/obj/machinery/door/airlock/cult(T)
			else
				new/obj/machinery/door/airlock/cult/unruned(T)
		qdel(src)

/obj/machinery/door/airlock/ratvar_act() //Airlocks become pinion airlocks that only allow servants
	if(glass)
		new/obj/machinery/door/airlock/clockwork/brass(get_turf(src))
	else
		new/obj/machinery/door/airlock/clockwork(get_turf(src))
	qdel(src)

/obj/machinery/door/airlock/Destroy()
	qdel(wires)
	wires = null
	if(id_tag)
		for(var/obj/machinery/doorButtons/D in machines)
			D.removeMe(src)
	return ..()

/obj/machinery/door/airlock/bumpopen(mob/living/user) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return
			else /*if(src.justzap)*/
				return
		else if(user.hallucination > 50 && prob(10) && src.operating == 0)
			to_chat(user, "<span class='userdanger'>You feel a powerful shock course through your body!</span>")
			user.staminaloss += 50
			user.stunned += 5
			return
	..()

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.secondsElectrified != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/canAIControl(mob/user)
	return ((aiControlDisabled != 1) && (!isAllPowerCut()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((aiControlDisabled==1) && (!hackProof) && (!isAllPowerCut()));

/obj/machinery/door/airlock/hasPower()
	return ((secondsMainPowerLost == 0 || secondsBackupPowerLost == 0) && !(stat & NOPOWER))

/obj/machinery/door/airlock/requiresID()
	return !(wires.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerCut()
	if((wires.is_cut(WIRE_POWER1) || wires.is_cut(WIRE_POWER2)) && (wires.is_cut(WIRE_BACKUP1) || wires.is_cut(WIRE_BACKUP2)))
		return TRUE

/obj/machinery/door/airlock/proc/regainMainPower()
	if(src.secondsMainPowerLost > 0)
		src.secondsMainPowerLost = 0

/obj/machinery/door/airlock/proc/loseMainPower()
	if(src.secondsMainPowerLost <= 0)
		src.secondsMainPowerLost = 60
		if(src.secondsBackupPowerLost < 10)
			src.secondsBackupPowerLost = 10
	if(!src.spawnPowerRestoreRunning)
		src.spawnPowerRestoreRunning = 1
		spawn(0)
			var/cont = 1
			while (cont)
				sleep(10)
				if(qdeleted(src))
					return
				cont = 0
				if(secondsMainPowerLost>0)
					if(!wires.is_cut(WIRE_POWER1) && !wires.is_cut(WIRE_POWER2))
						secondsMainPowerLost -= 1
						updateDialog()
					cont = 1

				if(secondsBackupPowerLost>0)
					if(!wires.is_cut(WIRE_BACKUP1) && !wires.is_cut(WIRE_BACKUP2))
						secondsBackupPowerLost -= 1
						updateDialog()
					cont = 1
			spawnPowerRestoreRunning = 0
			updateDialog()

/obj/machinery/door/airlock/proc/loseBackupPower()
	if(src.secondsBackupPowerLost < 60)
		src.secondsBackupPowerLost = 60

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(src.secondsBackupPowerLost > 0)
		src.secondsBackupPowerLost = 0

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/proc/shock(mob/user, prb)
	if(!hasPower())		// unpowered, no shock
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(!prob(prb))
		return 0 //you lucked out, no shock for you
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start() //sparks always.
	if(electrocute_mob(user, get_area(src), src))
		actionstaken += "\[[time_stamp()]\]shocked [user]/[user.ckey]"
		hasShocked = 1
		spawn(10)
			hasShocked = 0
		return 1
	else
		return 0

/obj/machinery/door/airlock/update_icon(state=0, override=0)
	if(operating && !override)
		return
	switch(state)
		if(0)
			if(density)
				state = AIRLOCK_CLOSED
			else
				state = AIRLOCK_OPEN
			icon_state = ""
		if(AIRLOCK_OPEN, AIRLOCK_CLOSED)
			icon_state = ""
		if(AIRLOCK_DENY, AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG)
			icon_state = "nonexistenticonstate" //MADNESS
	set_airlock_overlays(state)

/obj/machinery/door/airlock/proc/set_airlock_overlays(state)
	var/image/frame_overlay
	var/image/filling_overlay
	var/image/lights_overlay
	var/image/panel_overlay
	var/image/weld_overlay
	var/image/sparks_overlay

	switch(state)
		if(AIRLOCK_CLOSED)
			frame_overlay = get_airlock_overlay("closed", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closed", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closed", icon)
			if(panel_open)
				panel_overlay = get_airlock_overlay("panel_closed", overlays_file)
			if(welded)
				weld_overlay = get_airlock_overlay("welded", overlays_file)
			if(lights && hasPower())
				if(locked)
					lights_overlay = get_airlock_overlay("lights_bolts", overlays_file)
				else if(emergency)
					lights_overlay = get_airlock_overlay("lights_emergency", overlays_file)

		if(AIRLOCK_DENY)
			if(!hasPower())
				return
			frame_overlay = get_airlock_overlay("closed", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closed", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closed", icon)
			if(panel_open)
				panel_overlay = get_airlock_overlay("panel_closed", overlays_file)
			if(welded)
				weld_overlay = get_airlock_overlay("welded", overlays_file)
			lights_overlay = get_airlock_overlay("lights_denied", overlays_file)

		if(AIRLOCK_EMAG)
			frame_overlay = get_airlock_overlay("closed", icon)
			sparks_overlay = get_airlock_overlay("sparks", overlays_file)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closed", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closed", icon)
			if(panel_open)
				panel_overlay = get_airlock_overlay("panel_closed", overlays_file)
			if(welded)
				weld_overlay = get_airlock_overlay("welded", overlays_file)

		if(AIRLOCK_CLOSING)
			frame_overlay = get_airlock_overlay("closing", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closing", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closing", icon)
			if(lights && hasPower())
				lights_overlay = get_airlock_overlay("lights_closing", overlays_file)
			if(panel_open)
				panel_overlay = get_airlock_overlay("panel_closing", overlays_file)

		if(AIRLOCK_OPEN)
			frame_overlay = get_airlock_overlay("open", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_open", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_open", icon)
			if(panel_open)
				panel_overlay = get_airlock_overlay("panel_open", overlays_file)

		if(AIRLOCK_OPENING)
			frame_overlay = get_airlock_overlay("opening", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_opening", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_opening", icon)
			if(lights && hasPower())
				lights_overlay = get_airlock_overlay("lights_opening", overlays_file)
			if(panel_open)
				panel_overlay = get_airlock_overlay("panel_opening", overlays_file)

	//doesn't use overlays.Cut() for performance reasons
	if(frame_overlay != old_frame_overlay)
		overlays -= old_frame_overlay
		overlays += frame_overlay
		old_frame_overlay = frame_overlay
	if(filling_overlay != old_filling_overlay)
		overlays -= old_filling_overlay
		overlays += filling_overlay
		old_filling_overlay = filling_overlay
	if(lights_overlay != old_lights_overlay)
		overlays -= old_lights_overlay
		overlays += lights_overlay
		old_lights_overlay = lights_overlay
	if(panel_overlay != old_panel_overlay)
		overlays -= old_panel_overlay
		overlays += panel_overlay
		old_panel_overlay = panel_overlay
	if(weld_overlay != old_weld_overlay)
		overlays -= old_weld_overlay
		overlays += weld_overlay
		old_weld_overlay = weld_overlay
	if(sparks_overlay != old_sparks_overlay)
		overlays -= old_sparks_overlay
		overlays += sparks_overlay
		old_sparks_overlay = sparks_overlay

/proc/get_airlock_overlay(icon_state, icon_file)
	var/iconkey = "[icon_state][icon_file]"
	if(airlock_overlays[iconkey])
		return airlock_overlays[iconkey]
	airlock_overlays[iconkey] = image(icon_file, icon_state)
	return airlock_overlays[iconkey]

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			update_icon(AIRLOCK_OPENING)
		if("closing")
			update_icon(AIRLOCK_CLOSING)
		if("deny")
			if(!stat)
				update_icon(AIRLOCK_DENY)
				playsound(src,doorDeni,50,0,3)
				sleep(6)
				update_icon(AIRLOCK_CLOSED)

/obj/machinery/door/airlock/examine(mob/user)
	..()
	if(charge && !panel_open && in_range(user, src))
		to_chat(user, "<span class='warning'>The maintenance panel seems haphazardly fastened.</span>")
	if(charge && panel_open)
		to_chat(user, "<span class='warning'>Something is wired up to the airlock's electronics!</span>")

/obj/machinery/door/airlock/attack_ai(mob/user)
	if(!src.canAIControl(user))
		if(src.canAIHack())
			src.hack(user)
			return
		else
			to_chat(user, "<span class='warning'>Airlock AI control has been blocked with a firewall. Unable to hack.</span>")
		user << browse(null, "window=airlock")
		user.unset_machine()
	if(emagged)
		to_chat(user, "<span class='warning'>Unable to interface: Airlock is unresponsive.</span>")
		user << browse(null, "window=airlock")
		user.unset_machine()
		return
	if(detonated)
		to_chat(user, "<span class='warning'>Unable to interface. Airlock control panel damaged.</span>")
		user << browse(null, "window=airlock")
		user.unset_machine()
		return
	show_ai_menu(user)

/obj/machinery/door/airlock/proc/show_ai_menu(mob/user)
	//aiDisable - 1 idscan, 2 disrupt main power, 3 disrupt backup power, 4 drop door bolts, 5 un-electrify door, 7 close door, 11 lift access override
	//aiEnable - 1 idscan, 4 raise door bolts, 5 electrify door for 30 seconds, 6 electrify door indefinitely, 7 open door, 11 enable access override
	var/dat = ""
	dat += "<span align='right'><A href='?src=\ref[src];refresh=1'>Refresh</A></span>"

	dat += "<table>"
	dat += "<tr><td>Main Power</td>"
	if(secondsMainPowerLost > 0)
		dat += "<td><span class='linkOff'>Disrupt</span></td>"
		if(wires.is_cut(WIRE_POWER1) || wires.is_cut(WIRE_POWER2))
			dat += "<td><font color='red'>Offline: Power wire cut</font></td></tr>"
		else
			dat += "<td><font color='red'>Offline: [secondsMainPowerLost] seconds</font></td></tr>"
	else
		dat += "<td><A href='?src=\ref[src];aiDisable=2'>Disrupt</A></td><td></td></tr>"

	dat += "<tr><td>Backup Power</td>"
	if(secondsBackupPowerLost > 0)
		dat += "<td><span class='linkOff'>Disrupt</span></td>"
		if(wires.is_cut(WIRE_POWER1) || wires.is_cut(WIRE_POWER2))
			dat += "<td><font color='red'>Offline: Backup power wire cut</font></td></tr>"
		else
			dat += "<td><font color='red'>Offline: [secondsBackupPowerLost] seconds</font></td></tr>"
	else
		dat += "<td><A href='?src=\ref[src];aiDisable=3'>Disrupt</A></td><td></td></tr>"

	dat += "<tr><td>ID Scan</td>"
	if(wires.is_cut(WIRE_IDSCAN))
		dat += "<td><span class='linkOff'>On</span><span class='linkOff'>Off</span></td><td><font color='red'>IDScan wire cut</font></td></tr>"
	else if(aiDisabledIdScanner)
		dat += "<td><A href='?src=\ref[src];aiEnable=1'>On</A><span class='linkOn'>Off</span></td><td></td></tr>"
	else
		dat += "<td><span class='linkOn'>On</span><A href='?src=\ref[src];aiDisable=1'>Off</A></td><td></td></tr>"

	dat += "<tr><td>Door Lights</td>"
	if(wires.is_cut(WIRE_LIGHT))
		dat += "<td><span class='linkOff'>On</span><span class='linkOff'>Off</span></td><td><font color='red'>Lighting wire cut</font></td></tr>"
	else if(lights)
		dat += "<td><span class='linkOn'>On</span><A href='?src=\ref[src];aiDisable=10'>Off</A></td><td></td></tr>"
	else
		dat += "<td><A href='?src=\ref[src];aiEnable=10'>On</A><span class='linkOn'>Off</span></td><td></td></tr>"

	dat += "<tr><td>Emergency Access</td>"
	if(emergency)
		dat += "<td><A href='?src=\ref[src];aiDisable=11'>Off</A><span class='linkOn'>On</span></td><td></td></tr>"
	else
		dat += "<td><span class='linkOn'>Off</span><A href='?src=\ref[src];aiEnable=11'>On</A></td><td></td></tr>"

	dat += "<tr><td>Safety Override</td>"
	if(wires.is_cut(WIRE_SAFETY))
		dat += "<td><span class='linkOff'>Off</span><span class='linkOff'>On</span></td><td><font color='red'>Safety wire cut</font></td></tr>"
	else if(safe)
		dat += "<td><span class='linkOn'>Off</span><A href='?src=\ref[src];aiDisable=8'>On</A></td><td></td></tr>"
	else
		dat += "<td><A href='?src=\ref[src];aiEnable=8'>Off</A><span class='linkOn'>On</span></td><td></td></tr>"

	dat += "<tr><td>Speed Override</td>"
	if(wires.is_cut(WIRE_TIMING))
		dat += "<td><span class='linkOff'>Off</span><span class='linkOff'>On</span></td><td><font color='red'>Speed wire cut</font></td></tr>"
	else if(normalspeed)
		dat += "<td><span class='linkOn'>Off</span><A href='?src=\ref[src];aiDisable=9'>On</A></td><td></td></tr>"
	else
		dat += "<td><A href='?src=\ref[src];aiEnable=9'>Off</A><span class='linkOn'>On</span></td><td></td></tr>"

	dat += "<tr><td>Electrification</td>"
	if(wires.is_cut(WIRE_SHOCK))
		dat += "<td><span class='linkOff'>Off</span><span class='linkOff'>On</span><span class='linkOff'>30s</span></td><td><font color='red'>Electrification wire cut</font></td></tr>"
	else if(secondsElectrified == -1)
		dat += "<td><A href='?src=\ref[src];aiDisable=5'>Off</A><span class='linkOn'>On</span><span class='linkOff'>30s</span></td><td></td></tr>"
	else if(secondsElectrified > 0)
		dat += "<td><A href='?src=\ref[src];aiDisable=5'>Off</A><span class='linkOff'>On</span><span class='linkOn'>30s</span></td><td><font color='red'>[secondsElectrified] seconds remaining</font></td></tr>"
	else
		dat += "<td><span class='linkOn'>Off</span><A href='?src=\ref[src];aiEnable=6'>On</A><A href='?src=\ref[src];aiEnable=5'>30s</A></td><td></td></tr>"

	dat += "<tr><td>Door Bolts</td>"
	if(wires.is_cut(WIRE_BOLTS))
		dat += "<td><span class='linkOff'>Raised</span><span class='linkOff'>Dropped</span></td><td><font color='red'>Bolt wire cut</font></td></tr>"
	else if(locked)
		dat += "<td><A href='?src=\ref[src];aiEnable=4'>Raised</A><span class='linkOn'>Dropped</span></td><td></td></tr>"
	else
		dat += "<td><span class='linkOn'>Raised</span><A href='?src=\ref[src];aiDisable=4'>Dropped</A></td><td></td></tr>"

	dat += "<tr></tr>"

	dat += "<tr><td>Door Control</td>"
	if(density)
		dat += "<td><A href='?src=\ref[src];aiEnable=7'>Open</A><span class='linkOn'>Close</span></td><td></td></tr>"
	else
		dat += "<td><span class='linkOn'>Open</span><A href='?src=\ref[src];aiEnable=7'>Close</A></td><td></td></tr>"

	dat += "</table>"
	user.set_machine(src)
	var/datum/browser/popup = new /datum/browser(user, "airlock", "Airlock Control")
	popup.set_content(dat)
	popup.open(TRUE)


/obj/machinery/door/airlock/proc/hack(mob/user)
	set waitfor = 0
	if(src.aiHacking == 0)
		src.aiHacking = 1
		to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
		sleep(50)
		if(src.canAIControl(user))
			to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
			src.aiHacking=0
			return
		else if(!src.canAIHack())
			to_chat(user, "Connection lost! Unable to hack airlock.")
			src.aiHacking=0
			return
		to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
		sleep(20)
		to_chat(user, "Attempting to hack into airlock. This may take some time.")
		sleep(200)
		if(src.canAIControl(user))
			to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
			src.aiHacking=0
			return
		else if(!src.canAIHack())
			to_chat(user, "Connection lost! Unable to hack airlock.")
			src.aiHacking=0
			return
		to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
		sleep(170)
		if(src.canAIControl(user))
			to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
			src.aiHacking=0
			return
		else if(!src.canAIHack())
			to_chat(user, "Connection lost! Unable to hack airlock.")
			src.aiHacking=0
			return
		to_chat(user, "Transfer complete. Forcing airlock to execute program.")
		sleep(50)
		//disable blocked control
		src.aiControlDisabled = 2
		to_chat(user, "Receiving control information from airlock.")
		sleep(10)
		//bring up airlock dialog
		src.aiHacking = 0
		if(user)
			src.attack_ai(user)

/obj/machinery/door/airlock/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/door/airlock/attack_hand(mob/user)
	if(!(istype(user, /mob/living/silicon) || IsAdminGhost(user)))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return

	if(ishuman(user) && prob(40) && src.density)
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 60)
			playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
			if(!istype(H.head, /obj/item/clothing/head/helmet))
				H.visible_message("<span class='danger'>[user] headbutts the airlock.</span>", \
									"<span class='userdanger'>You headbutt the airlock!</span>")
				var/obj/item/bodypart/affecting = H.get_bodypart("head")
				H.Stun(5)
				H.Weaken(5)
				if(affecting && affecting.take_damage(10, 0))
					H.update_damage_overlays(0)
			else
				visible_message("<span class='danger'>[user] headbutts the airlock. Good thing they're wearing a helmet.</span>")
			return

	if(panel_open)
		wires.interact(user)
	else
		..()
	return


/obj/machinery/door/airlock/Topic(href, href_list, var/nowindow = 0)
	// If you add an if(..()) check you must first remove the var/nowindow parameter.
	// Otherwise it will runtime with this kind of error: null.Topic()
	if(!nowindow)
		..()
	if(usr.incapacitated() && !IsAdminGhost(usr))
		return
	add_fingerprint(usr)
	if(href_list["close"])
		usr << browse(null, "window=airlock")
		if(usr.machine==src)
			usr.unset_machine()
			return

	if((in_range(src, usr) && istype(src.loc, /turf)) && panel_open)
		usr.set_machine(src)

	var/no_window_msg

	if((istype(usr, /mob/living/silicon) && src.canAIControl(usr)) || IsAdminGhost(usr))
		//AI
		//aiDisable - 1 idscan, 2 disrupt main power, 3 disrupt backup power, 4 drop door bolts, 5 un-electrify door, 7 close door, 8 door safties, 9 door speed, 11 emergency access
		//aiEnable - 1 idscan, 4 raise door bolts, 5 electrify door for 30 seconds, 6 electrify door indefinitely, 7 open door,  8 door safties, 9 door speed, 11 emergency access

		if(href_list["aiDisable"])
			var/code = text2num(href_list["aiDisable"])
			switch (code)
				if(1)
					//disable idscan
					if(wires.is_cut(WIRE_IDSCAN))
						to_chat(usr, "The IdScan wire has been cut - So, you can't disable it, but it is already disabled anyways.")
					else if(src.aiDisabledIdScanner)
						to_chat(usr, "You've already disabled the IdScan feature.")
					else
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] disabled IDScan"
						src.aiDisabledIdScanner = 1
						no_window_msg = "ID scan disabled."
				if(2)
					//disrupt main power
					if(src.secondsMainPowerLost == 0)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] disabled main power"
						src.loseMainPower()
						no_window_msg = "Airlock main power disabled."
						update_icon()
					else
						to_chat(usr, "Main power is already offline.")
				if(3)
					//disrupt backup power
					if(src.secondsBackupPowerLost == 0)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] disabled backup power"
						src.loseBackupPower()
						no_window_msg = "Airlock backup power disabled."
						update_icon()
					else
						to_chat(usr, "Backup power is already offline.")
				if(4)
					//drop door bolts
					if(wires.is_cut(WIRE_BOLTS))
						to_chat(usr, "You can't drop the door bolts - The door bolt dropping wire has been cut.")
					else
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] bolted"
						bolt()
						no_window_msg = "Door bolts dropped."
				if(5)
					//un-electrify door
					if(wires.is_cut(WIRE_SHOCK))
						to_chat(usr, text("Can't un-electrify the airlock - The electrification wire is cut."))
					else if(src.secondsElectrified==-1 || src.secondsElectrified>0)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] unelectrified"
						src.secondsElectrified = 0
						no_window_msg = "Door un-electrified."

				if(8)
					// Safeties!  We don't need no stinking safeties!
					if(wires.is_cut(WIRE_SAFETY))
						to_chat(usr, text("Control to door sensors is disabled."))
					else if (src.safe)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] disabled safeties"
						safe = 0
						no_window_msg = "Door safeties disabled."
					else
						to_chat(usr, text("Firmware reports safeties already overriden."))

				if(9)
					// Door speed control
					if(wires.is_cut(WIRE_TIMING))
						to_chat(usr, text("Control to door timing circuitry has been severed."))
					else if (src.normalspeed)
						normalspeed = 0
						no_window_msg = "Door speed accelerated."
					else
						to_chat(usr, text("Door timing circuitry already accelerated."))
				if(7)
					//close door
					if(src.welded)
						to_chat(usr, text("The airlock has been welded shut!"))
					else if(src.locked)
						to_chat(usr, text("The door bolts are down!"))
					else if(!src.density)
						close()
					else
						open()

				if(10)
					// Bolt lights
					if(wires.is_cut(WIRE_LIGHT))
						to_chat(usr, text("Control to door bolt lights has been severed.</a>"))
					else if (src.lights)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] disabled bolt lights"
						lights = 0
						update_icon()
						no_window_msg = "Door bolt lights disabled."
					else
						to_chat(usr, text("Door bolt lights are already disabled!"))

				if(11)
					// Emergency access
					if (src.emergency)
						emergency = 0
						update_icon()
						no_window_msg = "Airlock emergency access disabled."
					else
						to_chat(usr, text("Emergency access is already disabled!"))


		else if(href_list["aiEnable"])
			var/code = text2num(href_list["aiEnable"])
			switch (code)
				if(1)
					//enable idscan
					if(wires.is_cut(WIRE_IDSCAN))
						to_chat(usr, "You can't enable IdScan - The IdScan wire has been cut.")
					else if(src.aiDisabledIdScanner)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] enabled IDScan"
						src.aiDisabledIdScanner = 0
						no_window_msg = "ID scan enabled."
					else
						to_chat(usr, "The IdScan feature is not disabled.")
				if(4)
					//raise door bolts
					if(wires.is_cut(WIRE_BOLTS))
						to_chat(usr, text("The door bolt drop wire is cut - you can't raise the door bolts."))
					else if(!src.locked)
						to_chat(usr, text("The door bolts are already up."))
					else
						if(src.hasPower())
							actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] unbolted"
							unbolt()
							no_window_msg = "Door bolts raised."
						else
							to_chat(usr, text("Cannot raise door bolts due to power failure."))

				if(5)
					//electrify door for 30 seconds
					if(wires.is_cut(WIRE_SHOCK))
						to_chat(usr, text("The electrification wire has been cut."))
					else if(src.secondsElectrified==-1)
						to_chat(usr, text("The door is already indefinitely electrified. You'd have to un-electrify it before you can re-electrify it with a non-forever duration."))
					else if(src.secondsElectrified!=0)
						to_chat(usr, text("The door is already electrified. You can't re-electrify it while it's already electrified."))
					else
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] electrified"
						add_logs(usr, src, "electrified")
						src.secondsElectrified = 30
						spawn(10)
							while (src.secondsElectrified>0)
								src.secondsElectrified-=1
								if(src.secondsElectrified<0)
									src.secondsElectrified = 0
								src.updateUsrDialog()
								sleep(10)
				if(6)
					//electrify door indefinitely
					if(wires.is_cut(WIRE_SHOCK))
						to_chat(usr, text("The electrification wire has been cut."))
					else if(src.secondsElectrified==-1)
						to_chat(usr, text("The door is already indefinitely electrified."))
					else if(src.secondsElectrified!=0)
						to_chat(usr, text("The door is already electrified. You can't re-electrify it while it's already electrified."))
					else
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] electrified indefinitely"
						add_logs(usr, src, "electrified")
						src.secondsElectrified = -1
						no_window_msg = "Door electrified"

				if (8) // Not in order >.>
					// Safeties!  Maybe we do need some stinking safeties!
					if(wires.is_cut(WIRE_SAFETY))
						to_chat(usr, text("Control to door sensors is disabled."))
					else if (!src.safe)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] enabled safeties"
						safe = 1
						src.updateUsrDialog()
						no_window_msg = "Door safeties enabled."
					else
						to_chat(usr, text("Firmware reports safeties already in place."))

				if(9)
					// Door speed control
					if(wires.is_cut(WIRE_TIMING))
						to_chat(usr, text("Control to door timing circuitry has been severed."))
					else if (!src.normalspeed)
						normalspeed = 1
						src.updateUsrDialog()
						no_window_msg = "Door speed set to normal."
					else
						to_chat(usr, text("Door timing circuitry currently operating normally."))

				if(7)
					//open door
					if(src.welded)
						to_chat(usr, text("The airlock has been welded shut!"))
					else if(src.locked)
						to_chat(usr, text("The door bolts are down!"))
					else if(src.density)
						open()
					else
						close()
				if(10)
					// Bolt lights
					if(wires.is_cut(WIRE_LIGHT))
						to_chat(usr, text("Control to door bolt lights has been severed.</a>"))
					else if (!src.lights)
						actionstaken += "\[[time_stamp()]\][usr]/[usr.ckey] enabled bolt lights"
						lights = 1
						update_icon()
						src.updateUsrDialog()
						no_window_msg = "Door bolt lights enabled."
					else
						to_chat(usr, text("Door bolt lights are already enabled!"))
				if(11)
					// Emergency access
					if (!src.emergency)
						emergency = 1
						update_icon()
						no_window_msg = "Airlock emergency access enabled."
					else
						to_chat(usr, text("Emergency access is already enabled!"))

	add_fingerprint(usr)
	if(nowindow)
		if(no_window_msg)
			to_chat(usr, no_window_msg)
	if(usr.machine == src)
		updateUsrDialog()

/obj/machinery/door/airlock/attackby(obj/item/C, mob/user, params)
	if(!issilicon(user) && !IsAdminGhost(user))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	add_fingerprint(user)
	if(istype(C, /obj/item/weapon/screwdriver))
		if(panel_open && detonated)
			to_chat(user, "<span class='warning'>[src] has no maintenance panel!</span>")
			return
		panel_open = !panel_open
		to_chat(user, "<span class='notice'>You [panel_open ? "open":"close"] the maintenance panel of the airlock.</span>")
		src.update_icon()
	else if(is_wire_tool(C))
		return attack_hand(user)
	else if(istype(C, /obj/item/weapon/pai_cable))
		var/obj/item/weapon/pai_cable/cable = C
		cable.plugin(src, user)
	else if(get_airlock_painter(C))
		change_paintjob(C, user)
	else if(istype(C, /obj/item/device/doorCharge))
		if(!panel_open)
			to_chat(user, "<span class='warning'>The maintenance panel must be open to apply [C]!</span>")
			return
		if(emagged)
			return
		if(charge && !detonated)
			to_chat(user, "<span class='warning'>There's already a charge hooked up to this door!</span>")
			return
		if(detonated)
			to_chat(user, "<span class='warning'>The maintenance panel is destroyed!</span>")
			return
		to_chat(user, "<span class='warning'>You apply [C]. Next time someone opens the door, it will explode.</span>")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has placed [C] on [src] <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>(JMP)</a></span>")
		user.drop_item()
		panel_open = 0
		update_icon()
		C.loc = src
		charge = C
	else
		return ..()


/obj/machinery/door/airlock/try_to_weld(obj/item/weapon/weldingtool/W, mob/user)
	if(!operating && density)
		if(W.remove_fuel(0,user))
			user.visible_message("[user] is [welded ? "unwelding":"welding"] the airlock.", \
							"<span class='notice'>You begin [welded ? "unwelding":"welding"] the airlock...</span>", \
							"<span class='italics'>You hear welding.</span>")
			playsound(loc, 'sound/items/Welder.ogg', 40, 1)
			if(do_after(user,40/W.toolspeed, 1, target = src))
				if(density && !operating)//Door must be closed to weld.
					if( !istype(src, /obj/machinery/door/airlock) || !user || !W || !W.isOn() || !user.loc )
						return
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					welded = !welded
					user.visible_message("[user.name] has [welded? "welded shut":"unwelded"] [src].", \
										"<span class='notice'>You [welded ? "weld the airlock shut":"unweld the airlock"].</span>")
					actionstaken += "\[[time_stamp()]\][user]/[user.ckey] [welded?"welded":"unwelded"]"
					update_icon()

/obj/machinery/door/airlock/try_to_crowbar(obj/item/I, mob/user)
	var/beingcrowbarred = null
	if(istype(I, /obj/item/weapon/crowbar) )
		beingcrowbarred = 1
	else
		beingcrowbarred = 0
	if(panel_open && charge)
		to_chat(user, "<span class='notice'>You carefully start removing [charge] from [src]...</span>")
		playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
		if(!do_after(user, 150/I.toolspeed, target = src))
			to_chat(user, "<span class='warning'>You slip and [charge] detonates!</span>")
			charge.ex_act(1)
			user.Weaken(3)
			return
		user.visible_message("<span class='notice'>[user] removes [charge] from [src].</span>", \
							 "<span class='notice'>You gently pry out [charge] from [src] and unhook its wires.</span>")
		charge.loc = get_turf(user)
		charge = null
		return
	if( beingcrowbarred && (density && welded && !operating && src.panel_open && (!hasPower()) && !src.locked) )
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("[user] removes the electronics from the airlock assembly.", \
							 "<span class='notice'>You start to remove electronics from the airlock assembly...</span>")
		if(do_after(user,40/I.toolspeed, target = src))
			if(src.loc)
				if(src.doortype)
					var/obj/structure/door_assembly/A = new src.doortype(src.loc)
					A.heat_proof_finished = src.heat_proof //tracks whether there's rglass in
				else
					new /obj/structure/door_assembly/door_assembly_0(src.loc)
					//If you come across a null doortype, it will produce the default assembly instead of disintegrating.

				if(emagged)
					to_chat(user, "<span class='warning'>You discard the damaged electronics.</span>")
					qdel(src)
					return
				to_chat(user, "<span class='notice'>You remove the airlock electronics.</span>")

				var/obj/item/weapon/electronics/airlock/ae
				if(!electronics)
					ae = new/obj/item/weapon/electronics/airlock( src.loc )
					if(req_one_access)
						ae.one_access = 1
						ae.accesses = src.req_one_access
					else
						ae.accesses = src.req_access
				else
					ae = electronics
					electronics = null
					ae.loc = src.loc

				qdel(src)
				return
	else if(hasPower())
		to_chat(user, "<span class='warning'>The airlock's motors resist your efforts to force it!</span>")
	else if(locked)
		to_chat(user, "<span class='warning'>The airlock's bolts prevent it from being forced!</span>")
	else if( !welded && !operating)
		if(beingcrowbarred == 0) //being fireaxe'd
			var/obj/item/weapon/twohanded/fireaxe/F = I
			if(F.wielded)
				spawn(0)
					if(density)
						open(2)
					else
						close(2)
			else
				to_chat(user, "<span class='warning'>You need to be wielding the fire axe to do that!</span>")
		else
			spawn(0)
				if(density)
					open(2)
				else
					close(2)

/obj/machinery/door/airlock/plasma/attackby(obj/item/C, mob/user, params)
	if(C.is_hot() > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma airlock ignited by [key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		log_game("Plasma wall ignited by [key_name(user)] in ([x],[y],[z])")
		ignite(C.is_hot())
	else
		return ..()

/obj/machinery/door/airlock/open(forced=0)
	if( operating || welded || locked )
		return 0
	if(!forced)
		if(!hasPower() || wires.is_cut(WIRE_OPEN))
			return 0
	if(charge && !detonated)
		panel_open = 1
		update_icon(AIRLOCK_OPENING)
		visible_message("<span class='warning'>[src]'s panel is blown off in a spray of deadly shrapnel!</span>")
		charge.loc = get_turf(src)
		charge.ex_act(1)
		detonated = 1
		charge = null
		for(var/mob/living/carbon/human/H in orange(1,src))
			H.Paralyse(8)
			H.adjust_fire_stacks(1)
			H.IgniteMob() //Guaranteed knockout and ignition for nearby people
			H.apply_damage(20, BRUTE, "chest")
		return
	if(forced < 2)
		if(emagged)
			return 0
		use_power(50)
		playsound(src.loc, doorOpen, 30, 1)
		if(src.closeOther != null && istype(src.closeOther, /obj/machinery/door/airlock/) && !src.closeOther.density)
			src.closeOther.close()
	else
		playsound(src.loc, 'sound/machines/airlockforced.ogg', 30, 1)

	if(!density)
		return 1
	if(!ticker || !ticker.mode)
		return 0
	operating = 1
	update_icon(AIRLOCK_OPENING, 1)
	src.SetOpacity(0)
	sleep(5)
	src.density = 0
	sleep(9)
	src.layer = OPEN_DOOR_LAYER
	update_icon(AIRLOCK_OPEN, 1)
	SetOpacity(0)
	operating = 0
	air_update_turf(1)
	update_freelook_sight()

	if(autoclose && normalspeed)
		addtimer(src, "autoclose", 150)
	else if(autoclose && !normalspeed)
		addtimer(src, "autoclose", 10)

	return 1


/obj/machinery/door/airlock/close(forced=0)
	if(operating || welded || locked)
		return
	if(!forced)
		if(!hasPower() || wires.is_cut(WIRE_BOLTS))
			return
	if(safe)
		for(var/atom/movable/M in get_turf(src))
			if(M.density && M != src) //something is blocking the door
				addtimer(src, "autoclose", 60)
				return

	if(forced < 2)
		if(emagged)
			return
		use_power(50)
		playsound(src.loc, doorClose, 30, 1)
	else
		playsound(src.loc, 'sound/machines/airlockforced.ogg', 30, 1)

	var/obj/structure/window/killthis = (locate(/obj/structure/window) in get_turf(src))
	if(killthis)
		killthis.ex_act(2)//Smashin windows

	if(density)
		return 1
	operating = 1
	update_icon(AIRLOCK_CLOSING, 1)
	src.layer = CLOSED_DOOR_LAYER
	sleep(5)
	src.density = 1
	if(!safe)
		crush()
	sleep(9)
	update_icon(AIRLOCK_CLOSED, 1)
	if(visible && !glass)
		SetOpacity(1)
	operating = 0
	air_update_turf(1)
	update_freelook_sight()
	if(safe)
		CheckForMobs()
	return 1

/obj/machinery/door/airlock/proc/prison_open()
	if(emagged)
		return
	src.locked = 0
	src.open()
	src.locked = 1
	src.actionstaken += "\[[time_stamp()]\]PRISON BREAK"
	return


/obj/machinery/door/airlock/proc/change_paintjob(obj/item/weapon/airlock_painter/W, mob/user)
	W = get_airlock_painter(W)
	if(!W.can_use(user))
		return

	var/list/optionlist
	if(airlock_material == "glass")
		optionlist = list("Public", "Public2", "Engineering", "Atmospherics", "Security", "Command", "Medical", "Research", "Mining", "Maintenance")
	else
		optionlist = list("Public", "Engineering", "Atmospherics", "Security", "Command", "Medical", "Research", "Mining", "Maintenance", "External", "High Security")

	var/paintjob = input(user, "Please select a paintjob for this airlock.") as anything in optionlist
	if((!in_range(src, usr) && src.loc != usr) || !W.use(user))
		return
	switch(paintjob)
		if("Public")
			icon = 'icons/obj/doors/airlocks/station/public.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_0
		if("Public2")
			icon = 'icons/obj/doors/airlocks/station2/glass.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_glass
		if("Engineering")
			icon = 'icons/obj/doors/airlocks/station/engineering.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_eng
		if("Atmospherics")
			icon = 'icons/obj/doors/airlocks/station/atmos.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_atmo
		if("Security")
			icon = 'icons/obj/doors/airlocks/station/security.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_sec
		if("Command")
			icon = 'icons/obj/doors/airlocks/station/command.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_com
		if("Medical")
			icon = 'icons/obj/doors/airlocks/station/medical.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_med
		if("Research")
			icon = 'icons/obj/doors/airlocks/station/research.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_research
		if("Mining")
			icon = 'icons/obj/doors/airlocks/station/mining.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_min
		if("Maintenance")
			icon = 'icons/obj/doors/airlocks/station/maintenance.dmi'
			overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_mai
		if("External")
			icon = 'icons/obj/doors/airlocks/external/external.dmi'
			overlays_file = 'icons/obj/doors/airlocks/external/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_ext
		if("High Security")
			icon = 'icons/obj/doors/airlocks/highsec/highsec.dmi'
			overlays_file = 'icons/obj/doors/airlocks/highsec/overlays.dmi'
			doortype = /obj/structure/door_assembly/door_assembly_highsecurity
	update_icon()

/obj/machinery/door/airlock/CanAStarPass(obj/item/weapon/card/id/ID)
//Airlock is passable if it is open (!density), bot has access, and is not bolted shut or powered off)
	return !density || (check_access(ID) && !locked && hasPower())

/obj/machinery/door/airlock/emag_act(mob/user)
	if(!operating && density && hasPower() && !emagged)
		operating = 1
		update_icon(AIRLOCK_EMAG, 1)
		sleep(6)
		if(qdeleted(src))
			return
		operating = 0
		if(!open())
			update_icon(AIRLOCK_CLOSED, 1)
		emagged = 1
		actionstaken += "\[[time_stamp()]\][user]/[user.ckey] emagged"
		desc = "<span class='warning'>Its access panel is smoking slightly.</span>"
		lights = 0
		locked = 1
		loseMainPower()
		loseBackupPower()

/obj/machinery/door/airlock/attack_alien(mob/living/carbon/alien/humanoid/user)
	add_fingerprint(user)
	if(isElectrified())
		shock(user, 100) //Mmm, fried xeno!
		return
	if(!density) //Already open
		return
	if(locked || welded) //Extremely generic, as aliens only understand the basics of how airlocks work.
		to_chat(user, "<span class='warning'>[src] refuses to budge!</span>")
		return
	user.visible_message("<span class='warning'>[user] begins prying open [src].</span>",\
						"<span class='noticealien'>You begin digging your claws into [src] with all your might!</span>",\
						"<span class='warning'>You hear groaning metal...</span>")
	var/time_to_open = 5
	if(hasPower())
		time_to_open = 50 //Powered airlocks take longer to open, and are loud.
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, 1)


	if(do_after(user, time_to_open, target = src))
		if(density && !open(2)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
			to_chat(user, "<span class='warning'>Despite your efforts, [src] managed to resist your attempts to open it!</span>")
