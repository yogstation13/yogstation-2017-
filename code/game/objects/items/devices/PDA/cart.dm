/obj/item/weapon/cartridge
	name = "generic cartridge"
	desc = "A data cartridge for portable microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = 1

	var/obj/item/radio/integrated/radio = null
	var/functions = 0 //Bitflags in __DEFINES/pda.dm
	var/remote_door_id = ""
	var/bot_access_flags = 0 //Bit flags. Selection: SEC_BOT|MULE_BOT|FLOOR_BOT|CLEAN_BOT|MED_BOT
	var/list/area/atmos_alerts = list()
	var/list/area/fire_alerts = list()
	var/list/area/power_alerts = list()
	var/alert_flags = 0 //Bitflags in __DEFINES/pda.dm
	var/alert_toggles = 0

	var/spam_enabled = 0 //Enables "Send to All" Option
	var/mode = null
	var/menu
	var/datum/data/record/active1 = null //General
	var/datum/data/record/active2 = null //Medical
	var/datum/data/record/active3 = null //Security
	var/obj/machinery/computer/monitor/powmonitor = null // Power Monitor
	var/list/powermonitors = list()
	var/obj/machinery/computer/atmos_control/atmosmonitor = null
	var/list/atmosmonitors = list()
	var/message1	// used for status_displays
	var/message2
	var/list/stored_data = list()
	var/current_channel

	var/mob/living/simple_animal/bot/active_bot
	var/list/botlist = list()

/obj/item/weapon/cartridge/New()
	..()
	if(alert_flags & PDA_ATMOS_ALERT)
		atmos_alert_listeners |= src
	if(alert_flags & PDA_POWER_ALERT)
		power_alert_listeners |= src
	if(alert_flags & PDA_FIRE_ALERT)
		fire_alert_listeners |= src

/obj/item/weapon/cartridge/Destroy()
	atmos_alert_listeners -= src
	power_alert_listeners -= src
	fire_alert_listeners -= src
	return ..()

/obj/item/weapon/cartridge/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	functions = PDA_ENGINE_FUNCTIONS
	alert_flags = PDA_POWER_ALERT
	bot_access_flags = FLOOR_BOT

/obj/item/weapon/cartridge/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	functions = PDA_ATMOS_FUNCTIONS|PDA_ATMOS_MONITOR_FUNCTIONS
	alert_flags = PDA_ATMOS_ALERT|PDA_FIRE_ALERT
	bot_access_flags = FLOOR_BOT

/obj/item/weapon/cartridge/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	functions = PDA_MEDICAL_FUNCTIONS
	bot_access_flags = MED_BOT

/obj/item/weapon/cartridge/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	functions = PDA_REAGENT_FUNCTIONS
	bot_access_flags = MED_BOT

/obj/item/weapon/cartridge/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	functions = PDA_SECURITY_FUNCTIONS
	bot_access_flags = SEC_BOT

/obj/item/weapon/cartridge/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	functions = PDA_SECURITY_FUNCTIONS|PDA_MEDICAL_FUNCTIONS|PDA_MANIFEST_FUNCTIONS
	bot_access_flags = SEC_BOT

/obj/item/weapon/cartridge/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	icon_state = "cart-j"
	functions = PDA_JANITOR_FUNCTIONS
	bot_access_flags = CLEAN_BOT

/obj/item/weapon/cartridge/lawyer
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	functions = PDA_SECURITY_FUNCTIONS
	spam_enabled = 1

/obj/item/weapon/cartridge/clown
	name = "\improper Honkworks 5.0 cartridge"
	icon_state = "cart-clown"
	functions = PDA_CLOWN_FUNCTIONS
	var/honk_charges = 5

/obj/item/weapon/cartridge/mime
	name = "\improper Gestur-O 1000 cartridge"
	icon_state = "cart-mi"
	functions = PDA_MIME_FUNCTIONS
	var/mime_charges = 5

/obj/item/weapon/cartridge/librarian
	name = "\improper Lib-Tweet cartridge"
	icon_state = "cart-s"
	functions = PDA_NEWSCASTER_FUNCTIONS

/obj/item/weapon/cartridge/botanist
	name = "\improper Green Thumb v4.20 cartridge"
	icon_state = "cart-b"
	functions = PDA_BOTANY_FUNCTIONS

/obj/item/weapon/cartridge/roboticist
	name = "\improper B.O.O.P. Remote Control cartridge"
	desc = "Packed with heavy duty triple-bot interlink!"
	bot_access_flags = FLOOR_BOT|CLEAN_BOT|MED_BOT

/obj/item/weapon/cartridge/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."

/obj/item/weapon/cartridge/signal/toxins
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	functions = PDA_ATMOS_FUNCTIONS|PDA_REAGENT_FUNCTIONS

/obj/item/weapon/cartridge/signal/New()
	..()
	radio = new /obj/item/radio/integrated/signal(src)



/obj/item/weapon/cartridge/quartermaster
	name = "space parts & space vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	functions = PDA_QUARTERMASTER_FUNCTIONS
	bot_access_flags = MULE_BOT

/obj/item/weapon/cartridge/head
	name = "\improper Easy-Record DELUXE cartridge"
	icon_state = "cart-h"
	functions = PDA_MANIFEST_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS

/obj/item/weapon/cartridge/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	functions = PDA_MANIFEST_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS|PDA_JANITOR_FUNCTIONS|PDA_SECURITY_FUNCTIONS|PDA_NEWSCASTER_FUNCTIONS|PDA_QUARTERMASTER_FUNCTIONS
	bot_access_flags = MULE_BOT|CLEAN_BOT

/obj/item/weapon/cartridge/hos
	name = "\improper R.O.B.U.S.T. DELUXE cartridge"
	icon_state = "cart-hos"
	functions = PDA_SECURITY_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS|PDA_SECURITY_FUNCTIONS
	bot_access_flags = SEC_BOT


/obj/item/weapon/cartridge/ce
	name = "\improper Power-On DELUXE cartridge"
	icon_state = "cart-ce"
	functions = PDA_MANIFEST_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS|PDA_ENGINE_FUNCTIONS|PDA_ATMOS_FUNCTIONS|PDA_ATMOS_MONITOR_FUNCTIONS
	alert_flags = PDA_ATMOS_ALERT|PDA_FIRE_ALERT|PDA_POWER_ALERT
	bot_access_flags = FLOOR_BOT

/obj/item/weapon/cartridge/cmo
	name = "\improper Med-U DELUXE cartridge"
	icon_state = "cart-cmo"
	functions = PDA_MEDICAL_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS|PDA_REAGENT_FUNCTIONS|PDA_MEDICAL_FUNCTIONS
	bot_access_flags = MED_BOT

/obj/item/weapon/cartridge/rd
	name = "\improper Signal Ace DELUXE cartridge"
	icon_state = "cart-rd"
	functions = PDA_MANIFEST_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS|PDA_REAGENT_FUNCTIONS|PDA_ATMOS_FUNCTIONS
	bot_access_flags = FLOOR_BOT|CLEAN_BOT|MED_BOT

/obj/item/weapon/cartridge/rd/New()
	..()
	radio = new /obj/item/radio/integrated/signal(src)

/obj/item/weapon/cartridge/captain
	name = "\improper Value-PAK cartridge"
	desc = "Now with 450% more value!" //Give the Captain...EVERYTHING! (Except Mime and Clown)
	icon_state = "cart-c"
	functions = PDA_MANIFEST_FUNCTIONS|PDA_ENGINE_FUNCTIONS|PDA_SECURITY_FUNCTIONS|PDA_MEDICAL_FUNCTIONS|\
				PDA_REAGENT_FUNCTIONS|PDA_STATUS_DISPLAY_FUNCTIONS|PDA_ATMOS_FUNCTIONS|PDA_ATMOS_MONITOR_FUNCTIONS|\
				PDA_NEWSCASTER_FUNCTIONS|PDA_QUARTERMASTER_FUNCTIONS|PDA_JANITOR_FUNCTIONS|PDA_BOTANY_FUNCTIONS
	alert_flags = PDA_ATMOS_ALERT|PDA_FIRE_ALERT|PDA_POWER_ALERT
	bot_access_flags = SEC_BOT|MULE_BOT|FLOOR_BOT|CLEAN_BOT|MED_BOT
	spam_enabled = 1

/obj/item/weapon/cartridge/captain/New()
	..()
	radio = new /obj/item/radio/integrated/signal(src)

/obj/item/weapon/cartridge/syndicate
	name = "\improper Detomatix cartridge"
	icon_state = "cart"
	functions = PDA_REMOTE_DOOR_FUNCTIONS
	remote_door_id = "smindicate" //Make sure this matches the syndicate shuttle's shield/door id!!	//don't ask about the name, testing.
	var/shock_charges = 4

/obj/item/weapon/cartridge/slavemaster
	name = "\improper Slavemaster-2000 cartridge"
	icon_state = "cart"
	var/obj/item/weapon/implant/mindslave/imp = null

/obj/item/weapon/cartridge/softwaremaster //This is for debugging, do not give this out in game!
	name = "\improper H4XMAST3R cartridge"
	desc = "A pda cartridge used by centcomm for nefarious purposes."
	functions = PDA_ADMIN_FUNCTIONS
	icon_state = "cart"

/obj/item/weapon/cartridge/proc/unlock()
	if (!istype(loc, /obj/item/device/pda))
		return

	generate_menu()
	print_to_host(menu)
	return

/obj/item/weapon/cartridge/proc/print_to_host(text)
	if (!istype(loc, /obj/item/device/pda))
		return
	var/obj/item/device/pda/P = loc
	P.cart = text

	for (var/mob/M in viewers(1, loc.loc))
		if (M.client && M.machine == loc)
			P.attack_self(M)

	return

/obj/item/weapon/cartridge/proc/triggerAlarm(class, area/A, O, obj/alarmsource)
	var/msg
	var/turf/myTurf = get_turf(src)
	if(!alarmsource || !myTurf || (alarmsource.z != myTurf.z))
		return
	switch(class)
		if("Atmosphere")
			if(!(alert_flags & PDA_ATMOS_ALERT) || (A in atmos_alerts))
				return
			atmos_alerts += A
			if(alert_toggles & PDA_ATMOS_ALERT)
				msg = "Alert: Atmos alarm in \the [A]"
		if("Power")
			if(!(alert_flags & PDA_POWER_ALERT) || (A in power_alerts))
				return
			power_alerts += A
			if(alert_toggles & PDA_POWER_ALERT)
				msg = "Alert: Power alarm in \the [A]"
		if("Fire")
			if(!(alert_flags & PDA_FIRE_ALERT) || (A in fire_alerts))
				return
			fire_alerts += A
			if(alert_toggles & PDA_FIRE_ALERT)
				msg = "Alert: Fire alarm in \the [A]"
		else
			return
	if(istype(loc, /obj/item/device/pda))
		var/obj/item/device/pda/pda = loc
		if(!pda.silent && msg)
			playsound(pda.loc, 'sound/machines/twobeep.ogg', 50, 1)
			pda.audible_message("\icon[pda] [msg]", null, 3)

/obj/item/weapon/cartridge/proc/cancelAlarm(class, area/A, obj/alarmsource)
	var/msg
	var/turf/myTurf = get_turf(src)
	if(!alarmsource || !myTurf || (alarmsource.z != myTurf.z))
		return
	switch(class)
		if("Atmosphere")
			if(!(alert_flags & PDA_ATMOS_ALERT))
				return
			atmos_alerts -= A
			if(alert_toggles & PDA_ATMOS_ALERT)
				msg = "Notice: Atmos alarm cleared in \the [A]"
		if("Power")
			if(!(alert_flags & PDA_POWER_ALERT))
				return
			power_alerts -= A
			if(alert_toggles & PDA_POWER_ALERT)
				msg = "Notice: Power alarm cleared in \the [A]"
		if("Fire")
			if(!(alert_flags & PDA_FIRE_ALERT))
				return
			fire_alerts -= A
			if(alert_toggles & PDA_FIRE_ALERT)
				msg = "Notice: Fire alarm cleared in \the [A]"
		else
			return
	if(istype(loc, /obj/item/device/pda))
		var/obj/item/device/pda/pda = loc
		if(!pda.silent && msg)
			playsound(pda.loc, 'sound/machines/twobeep.ogg', 50, 1)
			pda.audible_message("\icon[pda] [msg]", null, 3)

/obj/item/weapon/cartridge/proc/post_status(command, data1, data2)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)


/obj/item/weapon/cartridge/proc/generate_menu(mob/user)
	switch(mode)
		if(40) //signaller
			var/obj/item/radio/integrated/signal/S = radio
			menu = "<h4><img src=pda_signaler.png> Remote Signaling System</h4>"

			menu += {"
					<a href='byond://?src=\ref[src];choice=Send Signal'>Send Signal</A><BR>
					Frequency:
					<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=-10'>-</a>
					<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=-2'>-</a>
					[format_frequency(S.frequency)]
					<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=2'>+</a>
					<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=10'>+</a><br>
					<br>
					Code:
					<a href='byond://?src=\ref[src];choice=Signal Code;scode=-5'>-</a>
					<a href='byond://?src=\ref[src];choice=Signal Code;scode=-1'>-</a>
					[S.code]
					<a href='byond://?src=\ref[src];choice=Signal Code;scode=1'>+</a>
					<a href='byond://?src=\ref[src];choice=Signal Code;scode=5'>+</a><br>"}
		if (41) //crew manifest

			menu = "<h4><img src=pda_notes.png> Crew Manifest</h4>"
			menu += "Entries cannot be modified from this terminal.<br><br>"
			if(data_core.general)
				for (var/datum/data/record/t in sortRecord(data_core.general))
					menu += "[t.fields["name"]] - [t.fields["rank"]]<br>"
			menu += "<br>"


		if (42) //status displays
			menu = "<h4><img src=pda_status.png> Station Status Display Interlink</h4>"

			menu += "\[ <A HREF='?src=\ref[src];choice=Status;statdisp=blank'>Clear</A> \]<BR>"
			menu += "\[ <A HREF='?src=\ref[src];choice=Status;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			menu += "\[ <A HREF='?src=\ref[src];choice=Status;statdisp=message'>Message</A> \]"
			menu += "<ul><li> Line 1: <A HREF='?src=\ref[src];choice=Status;statdisp=setmsg1'>[ message1 ? message1 : "(none)"]</A>"
			menu += "<li> Line 2: <A HREF='?src=\ref[src];choice=Status;statdisp=setmsg2'>[ message2 ? message2 : "(none)"]</A></ul><br>"
			menu += "\[ Alert: <A HREF='?src=\ref[src];choice=Status;statdisp=alert;alert=default'>None</A> |"
			menu += " <A HREF='?src=\ref[src];choice=Status;statdisp=alert;alert=redalert'>Red Alert</A> |"
			menu += " <A HREF='?src=\ref[src];choice=Status;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			menu += " <A HREF='?src=\ref[src];choice=Status;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR>"

		if (43)
			menu = "<h4><img src=pda_power.png> Power Monitors - Please select one</h4><BR>"
			powmonitor = null
			powermonitors = list()
			var/powercount = 0



			for(var/obj/machinery/computer/monitor/pMon in machines)
				if(!(pMon.stat & (NOPOWER|BROKEN)) )
					powercount++
					powermonitors += pMon


			if(!powercount)
				menu += "<span class='danger'>No connection<BR></span>"
			else

				menu += "<FONT SIZE=-1>"
				var/count = 0
				for(var/obj/machinery/computer/monitor/pMon in powermonitors)
					count++
					menu += "<a href='byond://?src=\ref[src];choice=Power Select;target=[count]'>[pMon] </a><BR>"

				menu += "</FONT>"

		if (433)
			menu = "<h4><img src=pda_power.png> Power Monitor </h4><BR>"
			if(!powmonitor || !powmonitor.attached || !powmonitor.attached.powernet || !powmonitor.attached.powernet.nodes)
				menu += "<span class='danger'>No connection<BR></span>"
			else
				var/list/L = list()
				for(var/obj/machinery/power/terminal/term in powmonitor.attached.powernet.nodes)
					if(istype(term.master, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/A = term.master
						L += A

				menu += "<PRE>Total power: [powmonitor.attached.powernet.viewavail] W<BR>Total load:  [num2text(powmonitor.attached.powernet.viewload,10)] W<BR>"

				menu += "<FONT SIZE=-1>"

				if(L.len > 0)
					menu += "Area                           Eqp./Lgt./Env.  Load   Cell<HR>"

					var/list/S = list(" Off","AOff","  On", " AOn")
					var/list/chg = list("N","C","F")

					for(var/obj/machinery/power/apc/A in L)
						menu += copytext(add_tspace(A.area.name, 30), 1, 30)
						menu += " [S[A.equipment+1]] [S[A.lighting+1]] [S[A.environ+1]] [add_lspace(A.lastused_total, 6)]  [A.cell ? "[add_lspace(round(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "  N/C"]<BR>"

				menu += "</FONT></PRE>"

		if (44) //medical records //This thing only displays a single screen so it's hard to really get the sub-menu stuff working.
			menu = "<h4><img src=pda_medical.png> Medical Record List</h4>"
			if(data_core.general)
				for(var/datum/data/record/R in sortRecord(data_core.general))
					menu += "<a href='byond://?src=\ref[src];choice=Medical Records;target=[R.fields["id"]]'>[R.fields["id"]]: [R.fields["name"]]<br>"
			menu += "<br>"
		if(441)
			menu = "<h4><img src=pda_medical.png> Medical Record</h4>"

			if(active1 in data_core.general)
				menu += "Name: [active1.fields["name"]] ID: [active1.fields["id"]]<br>"
				menu += "Sex: [active1.fields["sex"]]<br>"
				menu += "Age: [active1.fields["age"]]<br>"
				menu += "Rank: [active1.fields["rank"]]<br>"
				menu += "Fingerprint: [active1.fields["fingerprint"]]<br>"
				menu += "Physical Status: [active1.fields["p_stat"]]<br>"
				menu += "Mental Status: [active1.fields["m_stat"]]<br>"
			else
				menu += "<b>Record Lost!</b><br>"

			menu += "<br>"

			menu += "<h4><img src=pda_medical.png> Medical Data</h4>"
			if(active2 in data_core.medical)
				menu += "Blood Type: [active2.fields["blood_type"]]<br><br>"

				menu += "Minor Disabilities: [active2.fields["mi_dis"]]<br>"
				menu += "Details: [active2.fields["mi_dis_d"]]<br><br>"

				menu += "Major Disabilities: [active2.fields["ma_dis"]]<br>"
				menu += "Details: [active2.fields["ma_dis_d"]]<br><br>"

				menu += "Allergies: [active2.fields["alg"]]<br>"
				menu += "Details: [active2.fields["alg_d"]]<br><br>"

				menu += "Current Diseases: [active2.fields["cdi"]]<br>"
				menu += "Details: [active2.fields["cdi_d"]]<br><br>"

				menu += "Important Notes: [active2.fields["notes"]]<br>"
			else
				menu += "<b>Record Lost!</b><br>"

			menu += "<br>"
		if (45) //security records
			menu = "<h4><img src=pda_cuffs.png> Security Record List</h4>"
			if(data_core.general)
				for (var/datum/data/record/R in sortRecord(data_core.general))
					menu += "<a href='byond://?src=\ref[src];choice=Security Records;target=[R.fields["id"]]'>[R.fields["id"]]: [R.fields["name"]]<br>"

			menu += "<br>"
		if(451)
			menu = "<h4><img src=pda_cuffs.png> Security Record</h4>"

			if(active1 in data_core.general)
				menu += "Name: [active1.fields["name"]] ID: [active1.fields["id"]]<br>"
				menu += "Sex: [active1.fields["sex"]]<br>"
				menu += "Age: [active1.fields["age"]]<br>"
				menu += "Rank: [active1.fields["rank"]]<br>"
				menu += "Fingerprint: [active1.fields["fingerprint"]]<br>"
				menu += "Physical Status: [active1.fields["p_stat"]]<br>"
				menu += "Mental Status: [active1.fields["m_stat"]]<br>"
			else
				menu += "<b>Record Lost!</b><br>"

			menu += "<br>"

			menu += "<h4><img src=pda_cuffs.png> Security Data</h4>"
			if(active3 in data_core.security)
				menu += "Criminal Status: [active3.fields["criminal"]]<br>"

				menu += text("<BR>\nMinor Crimes:")

				menu +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
						<tr>
						<th>Crime</th>
						<th>Details</th>
						<th>Author</th>
						<th>Time Added</th>
						</tr>"}
				for(var/datum/data/crime/c in active3.fields["mi_crim"])
					menu += "<tr><td>[c.crimeName]</td>"
					menu += "<td>[c.crimeDetails]</td>"
					menu += "<td>[c.author]</td>"
					menu += "<td>[c.time]</td>"
					menu += "</tr>"
				menu += "</table>"

				menu += text("<BR>\nMajor Crimes:")

				menu +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Crime</th>
<th>Details</th>
<th>Author</th>
<th>Time Added</th>
</tr>"}
				for(var/datum/data/crime/c in active3.fields["ma_crim"])
					menu += "<tr><td>[c.crimeName]</td>"
					menu += "<td>[c.crimeDetails]</td>"
					menu += "<td>[c.author]</td>"
					menu += "<td>[c.time]</td>"
					menu += "</tr>"
				menu += "</table>"

				menu += "<BR>\nImportant Notes:<br>"
				menu += "[active3.fields["notes"]]"
			else
				menu += "<b>Record Lost!</b><br>"

			menu += "<br>"

		if (47) //quartermaster order records
			menu = "<h4><img src=pda_crate.png> Supply Record Interlink</h4>"

			menu += "<BR><B>Supply shuttle</B><BR>"
			menu += "Location: "
			switch(SSshuttle.supply.mode)
				if(SHUTTLE_CALL)
					menu += "Moving to "
					if(SSshuttle.supply.z != ZLEVEL_STATION)
						menu += "station"
					else
						menu += "centcomm"
					menu += " ([SSshuttle.supply.timeLeft(600)] Mins)"
				else
					menu += "At "
					if(SSshuttle.supply.z != ZLEVEL_STATION)
						menu += "centcomm"
					else
						menu += "station"
			menu += "<BR>Current approved orders: <BR><ol>"
			for(var/S in SSshuttle.shoppinglist)
				var/datum/supply_order/SO = S
				menu += "<li>#[SO.id] - [SO.pack.name] approved by [SO.orderer] [SO.reason ? "([SO.reason])":""]</li>"
			menu += "</ol>"

			menu += "Current requests: <BR><ol>"
			for(var/S in SSshuttle.requestlist)
				var/datum/supply_order/SO = S
				menu += "<li>#[SO.id] - [SO.pack.name] requested by [SO.orderer]</li>"
			menu += "</ol><font size=\"-3\">Upgrade NOW to Space Parts & Space Vendors PLUS for full remote order control and inventory management."

		if (48) //Slavermaster 2000 //Whoever came up with the idea of making menu choices numerical is a idiot.
			menu = "<h4><img src=pda_signaller.png> Slave Controller</h4>"

			menu += "<BR><B>Available Slaves: </B><BR>"
			if(src:imp.imp_in)
				menu += "<ul><li>[src:imp.imp_in]<A href='byond://?src=\ref[src];choice=Detonate Slave'> *Detonate*</a></li></ul>"
			else
				menu += "No slaves detected."

		if (49) //janitorial locator
			menu = "<h4><img src=pda_bucket.png> Persistent Custodial Object Locator</h4>"

			var/turf/cl = get_turf(src)
			if (cl)
				menu += "Current Orbital Location: <b>\[[cl.x],[cl.y]\]</b>"

				menu += "<h4>Located Mops:</h4>"

				var/ldat
				for (var/obj/item/weapon/mop/M in world)
					var/turf/ml = get_turf(M)

					if(ml)
						if (ml.z != cl.z)
							continue
						var/direction = get_dir(src, M)
						ldat += "Mop - <b>\[[ml.x],[ml.y] ([uppertext(dir2text(direction))])\]</b> - [M.reagents.total_volume ? "Wet" : "Dry"]<br>"

				if (!ldat)
					menu += "None"
				else
					menu += "[ldat]"

				menu += "<h4>Located Janitorial Cart:</h4>"

				ldat = null
				for (var/obj/structure/janitorialcart/B in world)
					var/turf/bl = get_turf(B)

					if(bl)
						if (bl.z != cl.z)
							continue
						var/direction = get_dir(src, B)
						ldat += "Cart - <b>\[[bl.x],[bl.y] ([uppertext(dir2text(direction))])\]</b> - Water level: [B.reagents.total_volume]/100<br>"

				if (!ldat)
					menu += "None"
				else
					menu += "[ldat]"

				menu += "<h4>Located Cleanbots:</h4>"

				ldat = null
				for (var/mob/living/simple_animal/bot/cleanbot/B in living_mob_list)
					var/turf/bl = get_turf(B)

					if(bl)
						if (bl.z != cl.z)
							continue
						var/direction = get_dir(src, B)
						ldat += "Cleanbot - <b>\[[bl.x],[bl.y] ([uppertext(dir2text(direction))])\]</b> - [B.on ? "Online" : "Offline"]<br>"

				if (!ldat)
					menu += "None"
				else
					menu += "[ldat]"

			else
				menu += "ERROR: Unable to determine current location."
			menu += "<br><br><A href='byond://?src=\ref[src];choice=49'>Refresh GPS Locator</a>"

		if(50)//atmos monitoring
			menu = "<h4><img src=pda_power.png> Atmosphere Monitors - Please select one</h4><BR>"
			atmosmonitor = null
			atmosmonitors = list()

			for(var/obj/machinery/computer/atmos_control/aMon in world)
				if(!(aMon.stat & (NOPOWER|BROKEN)) )
					atmosmonitors += aMon
			if(!atmosmonitors.len)
				menu += "<span class='danger'>No connection<BR></span>"
			else
				menu += "<FONT SIZE=-1>"
				var/count = 0
				for(var/obj/machinery/computer/atmos_control/aMon in atmosmonitors)
					count++
					menu += "<a href='byond://?src=\ref[src];choice=Atmos Select;target=[count]'>[aMon] </a><BR>"
				menu += "</FONT>"
		if(501)
			menu = "<h4><img src=pda_power.png> Atmosphere Monitor</h4><BR>"
			if(!atmosmonitor.sensors.len)
				menu += "<span class='danger'>No connection<BR></span>"
			else
				for(var/id_tag in atmosmonitor.sensors)
					var/list/data = atmosmonitor.sensor_information[id_tag]
					menu += "<b>[atmosmonitor.sensors[id_tag]]</b><ul>"
					if(data)
						if(data["pressure"])
							menu += "<li><B>Pressure:</B> [data["pressure"]] kPa<BR></li>"
						else
							menu += "<li><B>Pressure:</B> No pressure detected<BR></li>"
						if(data["temperature"])
							menu += "<li><B>Temperature:</B> [data["temperature"]] K<BR></li>"
						if(data["oxygen"]||data["toxins"]||data["nitrogen"]||data["carbon_dioxide"])
							menu += "<li><B>Gas Composition : </B></li>"
							if(data["oxygen"])
								menu += "<li>[data["oxygen"]]% O2;</li>"
							if(data["nitrogen"])
								menu += "<li>[data["nitrogen"]]% N;</li>"
							if(data["carbon_dioxide"])
								menu += "<li>[data["carbon_dioxide"]]% CO2;</li>"
							if(data["toxins"])
								menu += "<li>[data["toxins"]]% TX;</li>"
						menu += "</ul>"

					else
						menu = "<FONT class='bad'>[atmosmonitor.sensors[id_tag]] can not be found!</FONT><BR>"

		if(51)//alerts monitoring
			var/turf/myTurf = get_turf(src)
			for(var/alert in atmos_alerts|fire_alerts|power_alerts)
				var/area/a = alert
				if(a.z != myTurf.z)
					atmos_alerts -= a
					fire_alerts -= a
					power_alerts -= a
			menu = "<h4><img src=pda_signaler.png> Active Alerts</h4><BR>"
			if(alert_flags & PDA_ATMOS_ALERT)
				menu += "<b>Atmosphere Alerts:</b><ul>"
				for(var/alert in atmos_alerts)
					menu += "<li>[alert]</li>"
				menu += "</ul>"

			if(alert_flags & PDA_FIRE_ALERT)
				menu += "<b>Fire Alerts:</b><ul>"
				for(var/alert in fire_alerts)
					menu += "<li>[alert]</li>"
				menu += "</ul>"

			if(alert_flags & PDA_POWER_ALERT)
				menu += "<b>Power Alerts:</b><ul>"
				for(var/alert in power_alerts)
					menu += "<li>[alert]</li>"
				menu += "</ul>"

		if (53) // Newscaster
			menu = "<h4><img src=pda_notes.png> Newscaster Access</h4>"
			menu += "<br> Current Newsfeed: <A href='byond://?src=\ref[src];choice=Newscaster Switch Channel'>[current_channel ? current_channel : "None"]</a> <br>"
			var/datum/newscaster/feed_channel/current
			for(var/datum/newscaster/feed_channel/chan in news_network.network_channels)
				if (chan.channel_name == current_channel)
					current = chan
			if(!current)
				menu += "<h5> ERROR : NO CHANNEL FOUND </h5>"
				return
			var/i = 1
			for(var/datum/newscaster/feed_message/msg in current.messages)
				menu +="-[msg.returnBody(-1)] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[msg.returnAuthor(-1)]</FONT>\]</FONT><BR>"
				menu +="<b><font size=1>[msg.comments.len] comment[msg.comments.len > 1 ? "s" : ""]</font></b><br>"
				if(msg.img)
					user << browse_rsc(msg.img, "tmp_photo[i].png")
					menu +="<img src='tmp_photo[i].png' width = '180'><BR>"
				i++
				for(var/datum/newscaster/feed_comment/comment in msg.comments)
					menu +="<font size=1><small>[comment.body]</font><br><font size=1><small><small><small>[comment.author] [comment.time_stamp]</small></small></small></small></font><br>"
			menu += "<br> <A href='byond://?src=\ref[src];choice=Newscaster Message'>Post Message</a>"

		if (54) // Beepsky, Medibot, Floorbot, and Cleanbot access
			menu = "<h4><img src=pda_medbot.png> Bots Interlink</h4>"
			bot_control()

		if(55) // Admin stuff
			menu = "<h4><img src=pda_signaler.png>Software Viewer</h4><br>\
			<A href='byond://?src=\ref[src];choice=del_software;target=all'>\[Delete All Software\]</a><br>\
			<A href='byond://?src=\ref[src];choice=del_software;target=all_malware'>\[Delete All Malware\]</a><br>\
			<br>Active Software:<ul>"
			listclearnulls(active_software)
			for(var/V in active_software)
				var/datum/software/M = V
				menu += "<li>[M] in [M.host] <A href='byond://?src=\ref[src];choice=del_software;target=\ref[M]'>\[Delete\]</a></li>"
			menu += "</ul>"

/obj/item/weapon/cartridge/Topic(href, href_list)
	..()

	if (!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr.unset_machine()
		usr << browse(null, "window=pda")
		return

	var/obj/item/device/pda/pda = loc

	switch(href_list["choice"])
		if("Medical Records")
			active1 = find_record("id", href_list["target"], data_core.general)
			if(active1)
				active2 = find_record("id", href_list["target"], data_core.medical)
			pda.mode = 441
			mode = 441
			if(!active2)
				active1 = null

		if("Security Records")
			active1 = find_record("id", href_list["target"], data_core.general)
			if(active1)
				active3 = find_record("id", href_list["target"], data_core.security)
			pda.mode = 451
			mode = 451
			if(!active3)
				active1 = null

		if("Send Signal")
			spawn( 0 )
				var/obj/item/radio/integrated/signal/S = radio
				S.send_signal("ACTIVATE")
				return

		if("Signal Frequency")
			var/obj/item/radio/integrated/signal/S = radio
			var/new_frequency = sanitize_frequency(S.frequency + text2num(href_list["sfreq"]))
			S.set_frequency(new_frequency)

		if("Signal Code")
			var/obj/item/radio/integrated/signal/S = radio
			S.code += text2num(href_list["scode"])
			S.code = round(S.code)
			S.code = min(100, S.code)
			S.code = max(1, S.code)

		if("Status")
			switch(href_list["statdisp"])
				if("message")
					post_status("message", message1, message2)
				if("alert")
					post_status("alert", href_list["alert"])
				if("setmsg1")
					message1 = reject_bad_text(input("Line 1", "Enter Message Text", message1) as text|null, 40)
					updateSelfDialog()
				if("setmsg2")
					message2 = reject_bad_text(input("Line 2", "Enter Message Text", message2) as text|null, 40)
					updateSelfDialog()
				else
					post_status(href_list["statdisp"])
		if("Power Select")
			var/pnum = text2num(href_list["target"])
			powmonitor = powermonitors[pnum]
			pda.mode = 433
			mode = 433

		if("Atmos Select")
			var/pnum = text2num(href_list["target"])
			atmosmonitor = atmosmonitors[pnum]
			loc:mode = 501
			mode = 501

		if("Supply Orders")
			pda.mode =47
			mode = 47

		if("Newscaster Access")
			mode = 53

		if("Newscaster Message")
			var/pda_owner_name = pda.id ? "[pda.id.registered_name] ([pda.id.assignment])" : "Unknown"
			var/message = pda.msg_input()
			var/datum/newscaster/feed_channel/current
			for(var/datum/newscaster/feed_channel/chan in news_network.network_channels)
				if (chan.channel_name == current_channel)
					current = chan
			if(current.locked && current.author != pda_owner_name)
				pda.cart += "<h5> ERROR : NOT AUTHORIZED [pda.id ? "" : "- ID SLOT EMPTY"] </h5>"
				pda.Topic(null,list("choice"="Refresh"))
				return
			news_network.SubmitArticle(message,pda.owner,current_channel)
			pda.Topic(null,list("choice"=num2text(mode)))
			return

		if("Newscaster Switch Channel")
			current_channel = pda.msg_input()
			pda.Topic(null,list("choice"=num2text(mode)))
			return

		if("Detonate Slave")
			if(istype(src, /obj/item/weapon/cartridge/slavemaster))
				if(src:imp)
					if (ismob(src.loc))
						var/mob/detonator = src.loc
						if(ismob(src:imp.loc))
							var/mob/detonated = src:imp.loc
							log_game("[detonator.ckey]/([detonator] has detonated [detonated.ckey]/([detonated]) with a mindslave implant");
					src:imp.activate()

		if("del_software")
			if(functions & PDA_ADMIN_FUNCTIONS)
				var/target = href_list["target"]
				if(target)
					if(target == "all")
						if("Yes" == alert(usr, "Delete all software?", "Delete Software", "Yes", "No"))
							for(var/V in active_software)
								qdel(V)
							usr << "<span class='warning'>All software deleted.</span>"
					else if(target == "all_malware")
						if("Yes" == alert(usr, "Delete all malware?", "Delete Malware", "Yes", "No"))
							for(var/datum/software/malware/M in active_software)
								qdel(M)
							usr << "<span class='warning'>All malware deleted.</span>"
					else
						var/datum/software/S = locate(target)
						if(istype(S))
							qdel(S)
							usr << "<span class='warning'>Software deleted.</span>"
						else
							usr << "<span class='warning'>Error: software has already been deleted.</span>"
				pda.Topic(null,list("choice"=num2text(mode)))

	//Bot control section! Viciously ripped from radios for being laggy and terrible.
	if(href_list["op"])
		switch(href_list["op"])

			if("control")
				active_bot = locate(href_list["bot"])

			if("botlist")
				active_bot = null
			if("summon") //Args are in the correct order, they are stated here just as an easy reminder.
				active_bot.bot_control(command= "summon", user_turf= get_turf(usr), user_access= pda.GetAccess())
			else //Forward all other bot commands to the bot itself!
				active_bot.bot_control(command= href_list["op"], user= usr)

	if(href_list["mule"]) //MULEbots are special snowflakes, and need different args due to how they work.

		active_bot.bot_control(command= href_list["mule"], user= usr, pda= 1)

	generate_menu(usr)
	print_to_host(menu)



/obj/item/weapon/cartridge/proc/bot_control()


	var/mob/living/simple_animal/bot/Bot

//	if(!SC)
//		menu = "Interlink Error - Please reinsert cartridge."
//		return
	if(active_bot)
		menu += "<B>[active_bot]</B><BR> Status: (<A href='byond://?src=\ref[src];op=control;bot=\ref[active_bot]'><img src=pda_refresh.png><i>refresh</i></A>)<BR>"
		menu += "Model: [active_bot.model]<BR>"
		menu += "Location: [get_area(active_bot)]<BR>"
		menu += "Mode: [active_bot.get_mode()]"
		if(active_bot.allow_pai)
			menu += "<BR>pAI: "
			if(active_bot.paicard && active_bot.paicard.pai)
				menu += "[active_bot.paicard.pai.name]"
				if(active_bot.bot_core.allowed(usr))
					menu += " (<A href='byond://?src=\ref[src];op=ejectpai'><i>eject</i></A>)"
			else
				menu += "<i>none</i>"

		//MULEs!
		if(active_bot.bot_type == MULE_BOT)
			var/mob/living/simple_animal/bot/mulebot/MULE = active_bot
			var/atom/Load = MULE.load
			menu += "<BR>Current Load: [ !Load ? "<i>none</i>" : "[Load.name] (<A href='byond://?src=\ref[src];mule=unload'><i>unload</i></A>)" ]<BR>"
			menu += "Destination: [MULE.destination ? MULE.destination : "<i>None</i>"] (<A href='byond://?src=\ref[src];mule=destination'><i>set</i></A>)<BR>"
			menu += "Set ID: [MULE.suffix] <A href='byond://?src=\ref[src];mule=setid'><i> Modify</i></A><BR>"
			menu += "Power: [MULE.cell ? MULE.cell.percent() : 0]%<BR>"
			menu += "Home: [!MULE.home_destination ? "<i>none</i>" : MULE.home_destination ]<BR>"
			menu += "Delivery Reporting: <A href='byond://?src=\ref[src];mule=report'>[MULE.report_delivery ? "(<B>On</B>)": "(<B>Off</B>)"]</A><BR>"
			menu += "Auto Return Home: <A href='byond://?src=\ref[src];mule=autoret'>[MULE.auto_return ? "(<B>On</B>)": "(<B>Off</B>)"]</A><BR>"
			menu += "Auto Pickup Crate: <A href='byond://?src=\ref[src];mule=autopick'>[MULE.auto_pickup ? "(<B>On</B>)": "(<B>Off</B>)"]</A><BR><BR>" //Hue.

			menu += "\[<A href='byond://?src=\ref[src];mule=stop'>Stop</A>\] "
			menu += "\[<A href='byond://?src=\ref[src];mule=go'>Proceed</A>\] "
			menu += "\[<A href='byond://?src=\ref[src];mule=home'>Return Home</A>\]<BR>"

		else
			menu += "<BR>\[<A href='byond://?src=\ref[src];op=patroloff'>Stop Patrol</A>\] "	//patrolon
			menu += "\[<A href='byond://?src=\ref[src];op=patrolon'>Start Patrol</A>\] "	//patroloff
			menu += "\[<A href='byond://?src=\ref[src];op=summon'>Summon Bot</A>\]<BR>"		//summon
			menu += "Keep an ID inserted to upload access codes upon summoning."

		menu += "<HR><A href='byond://?src=\ref[src];op=botlist'><img src=pda_back.png>Return to bot list</A>"
	else
		menu += "<BR><A href='byond://?src=\ref[src];op=botlist'><img src=pda_refresh.png>Scan for active bots</A><BR><BR>"
		var/turf/current_turf = get_turf(src)
		var/zlevel = current_turf.z
		var/botcount = 0
		for(Bot in living_mob_list) //Git da botz
			if(!Bot.on || Bot.z != zlevel || Bot.remote_disabled || !(bot_access_flags & Bot.bot_type)) //Only non-emagged bots on the same Z-level are detected!
				continue //Also, the PDA must have access to the bot type.
			menu += "<A href='byond://?src=\ref[src];op=control;bot=\ref[Bot]'><b>[Bot.name]</b> ([Bot.get_mode()])<BR>"
			botcount++
		if(!botcount) //No bots at all? Lame.
			menu += "No bots found.<BR>"
			return

	return menu
