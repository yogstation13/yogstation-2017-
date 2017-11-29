/obj/machinery/computer/shuttle
	name = "Shuttle Console"
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	req_access = list( )
	circuit = /obj/item/weapon/circuitboard/computer/shuttle
	var/shuttleId
	var/possible_destinations = ""
	var/current_destination
	var/admin_controlled
	var/no_destination_swap = 0
	var/notification // assign a frequency here - ex: SEC_FREQ, etc
	var/cooldownlen
	var/awayspeech // enables awayspeech()

	var/sending

/obj/machinery/computer/shuttle/New(location, obj/item/weapon/circuitboard/computer/shuttle/C)
	..()
	if(istype(C))
		possible_destinations = C.possible_destinations
		shuttleId = C.shuttleId

	if(notification)
		var/obj/item/device/radio/R = new(src)
		R.set_frequency(notification)
		R.listening = FALSE

/obj/machinery/computer/shuttle/attack_hand(mob/user)
	if(..(user))
		return
	src.add_fingerprint(usr)

	var/list/options = params2list(possible_destinations)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	var/dat = "Status: [M ? M.getStatusText() : "*Missing*"]<br><br>"
	if(M)
		var/destination_found
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.id))
				continue
			if(M.canDock(S))
				continue
			destination_found = 1
			dat += "<A href='?src=\ref[src];move=[S.id]'>Send to [S.name]</A><br>"
		if(!destination_found)
			dat += "<B>Shuttle Locked</B><br>"
			if(admin_controlled)
				dat += "Authorized personnel only<br>"
				dat += "<A href='?src=\ref[src];request=1]'>Request Authorization</A><br>"
	dat += "<a href='?src=\ref[user];mach_close=computer'>Close</a>"

	var/datum/browser/popup = new(user, "computer", M ? M.name : "shuttle", 300, 300)
	popup.set_content("<center>[dat]</center>")
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/computer/shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(!allowed(usr))
		to_chat(usr, "<span class='danger'>Access denied.</span>")
		return

	if(href_list["move"])
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
		if(M.launch_status == ENDGAME_LAUNCHED)
			to_chat(usr, "<span class='warning'>You've already escaped. Never going back to that place again!</span>")
			return
		if(no_destination_swap)
			if(M.mode != SHUTTLE_IDLE)
				to_chat(usr, "<span class='warning'>Shuttle already in transit.</span>")
				return

		if(processcooldown(shuttleId, href_list["move"]))
			processnotification("cooldown")
			current_destination = href_list["move"]

		switch(SSshuttle.moveShuttle(shuttleId, href_list["move"], 1))
			if(0)
				to_chat(usr, "<span class='notice'>Shuttle received message and will be sent shortly.</span>")
				processnotification("awayspeech")

			if(1)
				to_chat(usr, "<span class='warning'>Invalid shuttle requested.</span>")
				endcooldown(noMove = TRUE)
			if(3)
				if(sending)
					to_chat(usr, "<span class='notice'>Shuttle received message and will be sent shortly.</span>")
					sending = FALSE
				else
					to_chat(usr, "<span class='warning'>Shuttle is preparing to take off. Please wait.</span>")

			else
				to_chat(usr, "<span class='notice'>Unable to comply.</span>")
				endcooldown(noMove = TRUE)

/obj/machinery/computer/shuttle/proc/processcooldown(shuttleID, moveID)
	if(cooldownlen)
		if(!(shuttleId in SSshuttle.cooldown_ids))
			SSshuttle.cooldown_ids.Add("[shuttleId]")
			addtimer(src, "endcooldown", cooldownlen, FALSE, shuttleID, moveID)
			sending = TRUE
			return 1
	return 0

/obj/machinery/computer/shuttle/proc/processnotification(type)
	if(notification)
		var/obj/item/device/radio/R = findradio()
		switch(type)
			if("cooldown")
				if(!cooldownlen)
					R.talk_into(src,"The [shuttleId] shuttle is taking off!",notification)
				else
					R.talk_into(src,"The [shuttleId] shuttle is leaving in [cooldownlen/10] seconds!",notification)

			if("awayspeech")
				R.talk_into(src, "[awayspeech()]", notification)

/obj/machinery/computer/shuttle/proc/endcooldown(sID, mID, noMove)
	SSshuttle.cooldown_ids.Remove(sID)
	if(!noMove)
		processnotification("awayspeech")
		SSshuttle.moveShuttle(sID, mID, 1, TRUE)


/obj/machinery/computer/shuttle/emag_act(mob/user)
	if(!emagged)
		src.req_access = list()
		emagged = 1
		to_chat(user, "<span class='notice'>You fried the consoles ID checking system.</span>")

/obj/machinery/computer/shuttle/proc/awayspeech(destination)
	return "The shuttle is blasting off to [current_destination]!"

/obj/machinery/computer/shuttle/proc/findradio()
	var/obj/item/device/radio/radio

	for(var/obj/item/device/radio/R in src.contents)
		if(R.frequency != notification)
			R.frequency = notification
		if(!radio)
			radio = R

	if(radio)
		return radio