/obj/machinery/computer/telescience
	name = "\improper Telepad Control Console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	circuit = /obj/item/weapon/circuitboard/computer/cooldown_holder/telesci_console
	var/sending = 1
	var/obj/machinery/telepad/telepad = null
	var/temp_msg = "Telescience control console initialized.<BR>Welcome."

	// VARIABLES //
	var/datum/projectile_data/last_tele_data = null
	var/z_co = 1
	var/obj/item/device/tsbeacon/selection
	var/offset_x = 0
	var/offset_y = 0

	// Based on the power used
	var/teleporting = 0
	var/obj/item/device/gps/inserted_gps
	var/last_target

/obj/machinery/computer/telescience/Destroy()
	if(inserted_gps)
		inserted_gps.loc = loc
		inserted_gps = null
	return ..()

/obj/machinery/computer/telescience/attack_paw(mob/user)
	user << "<span class='warning'>You are too primitive to use this computer!</span>"
	return

/obj/machinery/computer/telescience/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/device/gps))
		if(!inserted_gps)
			inserted_gps = W
			user.unEquip(W)
			W.loc = src
			user.visible_message("[user] inserts [W] into \the [src]'s GPS device slot.", "<span class='notice'>You insert [W] into \the [src]'s GPS device slot.</span>")
	else if(istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		if(M.buffer && istype(M.buffer, /obj/machinery/telepad))
			telepad = M.buffer
			z_co = 1
			selection = telepad.beacon
			offset_x = 0
			offset_y = 0
			M.buffer = null
			user << "<span class='caution'>You upload the data from the [W.name]'s buffer.</span>"
	else
		return ..()

/obj/machinery/computer/telescience/attack_ai(mob/user)
	src.attack_hand(user)

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/telescience/interact(mob/user)
	var/t
	if(inserted_gps)
		t += "<A href='?src=\ref[src];ejectGPS=1'>Eject GPS</A>"
		t += "<A href='?src=\ref[src];setMemory=1'>Set GPS memory</A>"
	else
		t += "<span class='linkOff'>Eject GPS</span>"
		t += "<span class='linkOff'>Set GPS memory</span>"
	if(!telepad)
		in_use = 0     //Yeah so if you deconstruct teleporter while its in the process of shooting it wont disable the console
		t += "<div class='statusDisplay'>No telepad located. <BR>Please add telepad data.</div><BR>"
	else
		var/obj/item/weapon/circuitboard/computer/cooldown_holder/telesci_console/CM = circuit
		var/timeleft = CM.cooldownLeft()
		if(timeleft)
			temp_msg = "Telepad is recharging power.<BR>Please wait [round((timeleft) / 10)] seconds."
		else
			temp_msg = "Telepad ready and operational."
		t += "<div class='statusDisplay'>[temp_msg]</div><BR>"
		t += "Sector: "
		for (var/i in 1 to ZLEVEL_SPACEMAX)
			if(z_co == i)
				t += "<span class='linkOn'>[i]</span>"
			else if(i == ZLEVEL_CENTCOM)
				t += "<span class='linkOff'>[i]</span>"
			else
				t += "<A href='?src=\ref[src];setz=[i]'>[i]</A>"
		t += "<br>Selected beacon:<br>"
		if(selection && selection.can_be_found(z_co))
			var/turf/sloc = selection.get_loc()
			var/locstring = "([sloc.x], [sloc.y]) [(sloc.z == ZLEVEL_STATION || sloc.z == ZLEVEL_MINING) ? get_area(sloc) : "???"]"
			t += "<div class='statusDisplay'>[selection.name]<br>[locstring]</div><br>"
			t += "<div class='statusDisplay'>x: "
			for (var/i in -selection.range to selection.range)
				if(offset_x == i)
					t += "<span class='linkOn'>[i>0 ? "+" : ""][i]</span>"
				else
					t += "<A href='?src=\ref[src];offsetx=[i]'>[i>0 ? "+" : ""][i]</A>"
			t += "<br>y: "
			for (var/i in -selection.range to selection.range)
				if(offset_y == i)
					t += "<span class='linkOn'>[i>0 ? "+" : ""][i]</span>"
				else
					t += "<A href='?src=\ref[src];offsety=[i]'>[i>0 ? "+" : ""][i]</A>"
			t += "<br><A href='?src=\ref[src];send=1'>Send</A>"
			t += " <A href='?src=\ref[src];receive=1'>Receive</A>"
			if(selection.has_action)
				if(selection.action_available)
					t += " <A href='?src=\ref[src];beaconaction=1'>[selection.action_name]</A>"
				else
					t +=  "<span class='linkOff'>[selection.action_name]</span>"
			t += "</div><br><A href='?src=\ref[src];deselect=1'>Deselect</A>"
			t += " <A href='?src=\ref[src];rename=1'>Rename</A>"
		else if(selection)
			t += "<div class='statusDisplay'>[selection.name]<br><span class='bad'>No connection</span></div><br>"
			t += "<div class='statusDisplay'>x: <span class='bad'>No connection</span><br>y: <span class='bad'>No connection</span><br>"
			t += "<span class='linkOff'>Send</span> <span class='linkOff'>Receive</span></div><br>"
			t += "<A href='?src=\ref[src];deselect=1'>Deselect</A>"
			t += " <span class='linkOff'>Rename</span>"
		else
			t += "<div class='statusDisplay'>No beacon selected<br>Untargeted launch available</div><br>"
			t += "<div class='statusDisplay'>x: <span class='average'>Untargeted</span><br>y: <span class='average'>Untargeted</span><br>"
			t += "<A href='?src=\ref[src];randomsend=1'>Send</A> <A href='?src=\ref[src];randomrec=1'>Receive</A></div><br>"
			t += "<span class='linkOff'>Deselect</span> <span class='linkOff'>Rename</span>"
		// Information about the last teleport
		t += "<br><br>"
		for (var/B in tsbeacon_list)
			var/obj/item/device/tsbeacon/TSB = B
			if(!TSB || !TSB.can_be_found(z_co)) continue
			var/turf/sloc = TSB.get_loc()
			if(TSB == selection)
				t += "<span class='linkOn'>Select</span>"
			else
				t += "<A href='?src=\ref[src];select=\ref[TSB]'>Select</A>"
			var/locstring
			locstring = "([sloc.x], [sloc.y]) [(sloc.z == ZLEVEL_STATION || sloc.z == ZLEVEL_MINING) ? get_area(sloc) : "???"]"
			t += " [TSB.name] [locstring]<br>"
	var/datum/browser/popup = new(user, "telesci", name, 600, 600)
	popup.set_content(t)
	popup.open()
	return

/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, get_turf(telepad))
		s.start()
	else
		return

/obj/machinery/computer/telescience/proc/telefail()
	sparks()
	visible_message("<span class='warning'>The telepad weakly fizzles.</span>")
	return

/obj/machinery/computer/telescience/proc/teleport(mob/user, random = 0)
	if(z_co < 1 || z_co > ZLEVEL_SPACEMAX || z_co == ZLEVEL_CENTCOM)
		temp_msg = "ERROR!<BR>Forbidden sector."
		return
	if(!random)
		if(!selection || !selection.can_be_found(z_co))
			temp_msg = "ERROR!<BR>Cannot locate beacon."
			return
		if(offset_x < -selection.range || offset_x > selection.range)
			temp_msg = "ERROR!<BR>Impossible x offset."
			return
		if(offset_y < -selection.range || offset_y > selection.range)
			temp_msg = "ERROR!<BR>Impossible y offset."
			return

	var/obj/item/weapon/circuitboard/computer/cooldown_holder/telesci_console/CM = circuit
	var/timeleft = CM.cooldownLeft()
	if(timeleft)
		return

	if(teleporting)
		temp_msg = "Telepad is in use.<BR>Please wait."
		return

	if(telepad)
		var/spawn_time = 60/((telepad.efficiency + 1)*(telepad.efficiency + 1))
		flick("pad-beam", telepad)
		teleporting = 1
		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad.loc, 'sound/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			temp_msg = "Powering up bluespace crystals.<BR>Please wait."

		spawn(spawn_time) // in seconds
			if(!telepad)
				return
			if(telepad.stat & NOPOWER)
				return
			if(!random && (!selection || !selection.can_be_found(z_co)))
				temp_msg = "ERROR!<BR>Beacon lock lost during power up sequence."
				updateDialog()
				return
			var/turf/target
			if(random)
				target = random_accessible_turf(z_co)
			else
				target = selection.get_offset(offset_x, offset_y)
			if(!target)
				temp_msg = "ERROR!<BR>Bluespace instability. Please report this incident."
				updateDialog()
				return
			last_target = target
			var/area/A = get_area(target)

			teleporting = 0
			CM.nextAllowedTime = world.time + spawn_time * 20

			// use a lot of power
			use_power(spawn_time * 20)

			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(5, 1, get_turf(telepad))
			s.start()

			temp_msg = "Teleport successful.<BR>Target: ([target.x], [target.y], [target.z])"

			var/sparks = get_turf(target)
			var/datum/effect_system/spark_spread/y = new /datum/effect_system/spark_spread
			y.set_up(5, 1, sparks)
			y.start()

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			var/log_msg = ""
			log_msg += ": [key_name(user)] has teleported "

			if(sending)
				source = dest
				dest = target

			flick("pad-beam", telepad)
			playsound(telepad.loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue

							log_msg += "[key_name(L)] (on a chair), "
						else
							continue
					else if(!isobserver(ROI))
						continue
				if(ismob(ROI))
					var/mob/T = ROI
					log_msg += "[key_name(T)], "
				else
					log_msg += "[ROI.name]"
					if (istype(ROI, /obj/structure/closet))
						var/obj/structure/closet/C = ROI
						log_msg += " ("
						for(var/atom/movable/Q as mob|obj in C)
							if(ismob(Q))
								log_msg += "[key_name(Q)], "
							else
								log_msg += "[Q.name], "
						if (dd_hassuffix(log_msg, "("))
							log_msg += "empty)"
						else
							log_msg = dd_limittext(log_msg, length(log_msg) - 2)
							log_msg += ")"
					log_msg += ", "
				do_teleport(ROI, dest)

			if (dd_hassuffix(log_msg, ", "))
				log_msg = dd_limittext(log_msg, length(log_msg) - 2)
			else
				log_msg += "nothing"
			log_msg += " [sending ? "to" : "from"] [target.x], [target.y], [target.z] ([A ? A.name : "null area"])"
			investigate_log(log_msg, "telesci")
			updateDialog()

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(!telepad)
		updateDialog()
		return
	if(telepad.panel_open)
		temp_msg = "ERROR!<BR>Telepad undergoing physical maintenance operations."
	if(teleporting)
		return
	if(href_list["setz"])
		var/A = href_list["setz"]
		A = text2num(A)
		if(A < 1 || A > ZLEVEL_SPACEMAX || A == ZLEVEL_CENTCOM)
			updateDialog()
			return
		z_co = A
		selection = null
		offset_x = 0
		offset_y = 0

	if(href_list["offsetx"])
		var/A = href_list["offsetx"]
		A = text2num(A)
		if(!selection || !selection.can_be_found(z_co) || A < -selection.range || A > selection.range)
			updateDialog()
			return
		offset_x = A

	if(href_list["offsety"])
		var/A = href_list["offsety"]
		A = text2num(A)
		if(!selection || !selection.can_be_found(z_co) || A < -selection.range || A > selection.range)
			updateDialog()
			return
		offset_y = A

	if(href_list["select"])
		var/obj/item/device/tsbeacon/TSB = locate(href_list["select"])
		if(!TSB || !TSB.can_be_found(z_co))
			updateDialog()
			return
		selection = TSB
		offset_x = Clamp(offset_x, -selection.range, selection.range)
		offset_y = Clamp(offset_y, -selection.range, selection.range)

	if(href_list["deselect"])
		selection = null
		offset_x = 0
		offset_y = 0

	if(href_list["rename"])
		if(!selection || !selection.can_be_found(z_co))
			updateDialog()
			return
		var/t = stripped_input(usr, "Enter new name", name, null, 20)
		if(!t || !usr.canUseTopic(src) || !selection || !selection.can_be_found(z_co))
			updateDialog()
			return
		selection.update_name(t)
	if(href_list["beaconaction"])
		if(!selection || !selection.can_be_found(z_co) || !selection.has_action || !selection.action_available)
			updateDialog()
			return
		selection.beacon_action()
	if(href_list["ejectGPS"])
		if(inserted_gps)
			inserted_gps.loc = loc
			inserted_gps = null

	if(href_list["setMemory"])
		if(last_target && inserted_gps)
			inserted_gps.locked_location = last_target
			temp_msg = "SUCCESS!<BR>Location saved."
		else
			temp_msg = "ERROR!<BR>No data was stored."

	if(href_list["send"])
		sending = 1
		teleport(usr)

	if(href_list["receive"])
		sending = 0
		teleport(usr)

	if(href_list["randomsend"])
		sending = 1
		teleport(usr, 1)

	if(href_list["randomrec"])
		sending = 0
		teleport(usr, 1)

	updateDialog()