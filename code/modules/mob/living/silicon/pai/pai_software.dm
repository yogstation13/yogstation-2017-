
// TODO:
//	- Additional radio modules
//	- Potentially roll HUDs and Records into one
//	- Shock collar/lock system for prisoner pAIs?
//  - Put cable in user's hand instead of on the ground
//  - Camera jack

/*list(
															"crew manifest" = 5,
															"digital messenger" = 5,
															"medical records" = 15,
															"security records" = 15,
															//"camera jack" = 10,
															"door jack" = 30,
															"remote control" = 60,
															"atmosphere sensor" = 5,
															//"heartbeat sensor" = 10,
															"security HUD" = 20,
															"medical HUD" = 20,
															"universal translator" = 35,
															//"projection array" = 15
															"remote signaller" = 5,
															)*/

/mob/living/silicon/pai/verb/paiInterface()
	set category = "pAI Commands"
	set name = "Software Interface"
	var/dat = ""
	var/left_part = ""
	var/right_part = softwareMenu()
	src.set_machine(src)

	if(temp)
		left_part = temp
	else if(src.stat == 2)						// Show some flavor text if the pAI is dead
		left_part = "<b><font color=red>ÈRrÖR Ða†Ä ÇÖRrÚþ†Ìoñ</font></b>"
		right_part = "<pre>Program index hash not found</pre>"

	else
		for (var/S in src.pai_software)
			var/datum/pai/software/SW = S

			if (screen == SW.sid) //we have a screen set with software we have active, so lets display it:
				left_part = SW.action_menu(src)

		switch(src.screen)							// Determine which interface to show here
			if("main")
				left_part = ""
			if("directives")
				left_part = src.directives()
			if("buy")
				left_part = src.downloadSoftware()
			if("radio")
				left_part = src.radioMenu()
	//usr << browse_rsc('windowbak.png')		// This has been moved to the mob's Login() proc


	// Declaring a doctype is necessary to enable BYOND's crappy browser's more advanced CSS functionality
	dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html>
			<head>
				<style type=\"text/css\">
					body { background-image:url('html/paigrid.png'); }

					#header { text-align:center; color:white; font-size: 30px; height: 35px; width: 100%; letter-spacing: 2px; z-index: 5}
					#content {position: relative; left: 10px; height: 400px; width: 100%; z-index: 0}

					#leftmenu {color: #AAAAAA; background-color:#333333; width: 400px; height: auto; min-height: 340px; position: absolute; z-index: 0}
					#leftmenu a:link { color: #CCCCCC; }
					#leftmenu a:hover { color: #CC3333; }
					#leftmenu a:visited { color: #CCCCCC; }
					#leftmenu a:active { color: #000000; }

					#rightmenu {color: #CCCCCC; background-color:#555555; width: 200px ; height: auto; min-height: 340px; right: 10px; position: absolute; z-index: 1}
					#rightmenu a:link { color: #CCCCCC; }
					#rightmenu a:hover { color: #CC3333; }
					#rightmenu a:visited { color: #CCCCCC; }
					#rightmenu a:active { color: #000000; }

				</style>
				<script language='javascript' type='text/javascript'>
				[js_byjax]
				</script>
			</head>
			<body scroll=yes>
				<div id=\"header\">
					pAI OS
				</div>
				<div id=\"content\">
					<div id=\"leftmenu\">[left_part]</div>
					<div id=\"rightmenu\">[right_part]</div>
				</div>
			</body>
			</html>"} //"
	usr << browse(dat, "window=pai;size=640x480;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "pai")
	temp = null
	return



/mob/living/silicon/pai/Topic(href, href_list)
	..()
	var/soft = href_list["software"]
	var/sub = href_list["sub"]
	var/refresh = TRUE
	if(soft)
		if (soft == "refresh") //irritating but handles refresh functionality innately this way
			soft = src.screen
		else
			src.screen = soft
	if(sub)
		src.subscreen = text2num(sub)

	for (var/S in src.pai_software)
		var/datum/pai/software/SW = S

		if (soft == SW.sid) //if we've got a matching href tag, refer it to the software datum's use event
			if(SW.action_use(src, href_list))
				refresh = FALSE

	//LEGACY COMMANDS FROM OLD SOFTWARE SYSTEM, NEW SOFTWARE IS HANDLED AUTOMATICALLY IN /datum/pai/software
	switch(soft)
		// Purchasing new software
		if("buy")
			if(src.subscreen == 1)
				var/datum/pai/software/T = available_software[href_list["buy"]]

				if(istype(T, /datum/pai/software))
					var/cost = T.ram
					if(src.ram >= cost)
						src.ram -= cost
						src.pai_software.Add(T)
						T.action_installed(src) //throw installed event to allow huds to be attached, etc
					else
						src.temp = "Insufficient RAM available."
				else
					src.temp = "Trunk <TT> \"[T]\"</TT> not found."

		// Configuring onboard radio
		if("radio")
			//src.card.radio.attack_self(src)
			//src.card.radio.interact(src)
			if (href_list["togglemic"])
				src.card.radio.broadcasting = !src.card.radio.broadcasting
			if (href_list["togglespeaker"])
				src.card.radio.listening = !src.card.radio.listening
			if (href_list["rfreq"])
				var/new_frequency = (src.card.radio.frequency + text2num(href_list["rfreq"]))

				if (!src.card.radio.freerange || (src.card.radio.frequency < 1200 || src.card.radio.frequency > 1600))
					new_frequency = sanitize_frequency(new_frequency)

				src.card.radio.set_frequency(new_frequency)
			if(href_list["e_key"])
				if(radio && radio.keyslot)
					var/turf/T = get_turf(src)
					radio.keyslot.loc = T //just in case we are in nullspace for some reason
					radio.keyslot.forceMove(T)
					radio.keyslot = null
					radio.recalculateChannels()
			if(href_list["range"])
				if(radio)
					var/newrange = input("Set radio/microphone range", "Radio Range", 3) as anything in list(0, 1, 2, 3, 4)
					if(radio)
						radio.canhear_range = newrange
			if(href_list["channel"])
				var/channel = href_list["channel"]
				if(channel in radio.channels)
					radio.channels[channel] ^= radio.FREQ_LISTENING

		if("image")
			var/newImage = input("Select your new display image.", "Display Image", "Happy") as anything in list("Happy", "Cat", "Extremely Happy", "Face", "Laugh", "Off", "Sad", "Angry", "What")
			var/pID = 1
			switch(newImage)
				if("Happy")
					pID = 1
				if("Cat")
					pID = 2
				if("Extremely Happy")
					pID = 3
				if("Face")
					pID = 4
				if("Laugh")
					pID = 5
				if("Off")
					pID = 6
				if("Sad")
					pID = 7
				if("Angry")
					pID = 8
				if("What")
					pID = 9
				if("Null")
					pID = 10
			src.card.setEmotion(pID)

		if("directive")
			if(href_list["getdna"])
				var/mob/living/M = card.loc
				var/count = 0
				while(!istype(M, /mob/living))
					if(!M || !M.loc) return 0 //For a runtime where M ends up in nullspace (similar to bluespace but less colourful)
					M = M.loc
					count++
					if(count >= 6)
						to_chat(src, "You are not being carried by anyone!")
						return 0
				spawn CheckDNA(M, src)

	if(refresh)
		//src.updateUsrDialog()		We only need to account for the single mob this is intended for, and he will *always* be able to call this window
		src.paiInterface()		 // So we'll just call the update directly rather than doing some default checks

// MENUS

/mob/living/silicon/pai/proc/radioMenu()
	if(!radio)
		return "<b>No radio installed</b><br>"
	var/dat = ""
	dat += {"<b>Radio settings:</b><br>
			[radio.wires.is_cut(WIRE_TX) ? "<i><font color=red>Radio transmit disabled by user</font></i><br>" : ""]
			[radio.wires.is_cut(WIRE_RX) ? "<i><font color=red>Radio receiving disabled by user</font></i><br>" : ""]
			Microphone: <a href='?src=\ref[src];software=radio;togglemic=1'><span id="rmicstate">[src.card.radio.broadcasting?"Engaged":"Disengaged"]</span></a><br>
			Speaker: <a href='?src=\ref[src];software=radio;togglespeaker=1'><span id="rspkstate">[src.card.radio.listening?"Engaged":"Disengaged"]</span></a><br>
			Microphone/Speaker range: <a href='?src=\ref[src];software=radio;range=1'>[radio.canhear_range]</a><br>
			Frequency:
			<a href='?src=\ref[src];software=radio;rfreq=-10'>-</a>
			<a href='?src=\ref[src];software=radio;rfreq=-2'>-</a>
			<span id="rfreq">[format_frequency(src.card.radio.frequency)]</span>
			<a href='?src=\ref[src];software=radio;rfreq=2'>+</a>
			<a href='?src=\ref[src];software=radio;rfreq=10'>+</a><br>"}
	if(radio && radio.keyslot)
		dat += "[radio.keyslot]: <a href='?src=\ref[src];software=radio;e_key=1'>\[Eject\]</a><br>Channels:"
		dat += "<ul>"
		for(var/channel in radio.channels)
			dat += "<li>[channel]\t<a href='?src=\ref[src];software=radio;channel=[channel]'>\[[radio.channels[channel] ? "On" : "Off"]\]</a></li>"
		dat += "</ul><br>"
	else
		dat += "<i>no encryption key inserted</i><br>"
	return dat

/mob/living/silicon/pai/proc/softwareMenu()			// Populate the right menu
	var/dat = ""

	dat += "<A href='byond://?src=\ref[src];software=refresh'>Refresh</A><br>"

	// Built-in LEGACY SOFTWARE
	dat += "<A href='byond://?src=\ref[src];software=directives'>Directives</A><br>"
	dat += "<A href='byond://?src=\ref[src];software=radio;sub=0'>Radio Configuration</A><br>"
	dat += "<A href='byond://?src=\ref[src];software=image'>Screen Display</A><br>"
	dat += "<br>"

	//PURCHASED SOFTWARE LISTING
	for (var/S in pai_software)
		var/datum/pai/software/SW = S

		if (SW.hrefline)
			dat += SW.action_hrefline(src)
		else
			dat += "<a href='byond://?src=\ref[src];software=[SW.sid];sub=0'>[SW.name]</a> <br>"

	dat += "<br><a href='byond://?src=\ref[src];software=buy;sub=0'>Download additional software</a>"
	return dat



/mob/living/silicon/pai/proc/downloadSoftware()
	var/dat = ""

	dat += "<h2>Centcom pAI Module Subversion Network</h2><br>"
	dat += "<pre>Remaining Available Memory: [src.ram]</pre><br>"
	dat += "<p style=\"text-align:center\"><b>Trunks available for checkout</b><br>"

	for (var/key in available_software) //generate the list of available software
		var/datum/pai/software/S = available_software[key]
		if (S.ram == 0 || !S.ram || S.ram <= 0)
			continue
		if (S in pai_software) //software with "0" ram is innate or otherwise hidden and doesn't need to be shown, same with stuff we've already purchased
			continue

		dat += "<b><a href='byond://?src=\ref[src];software=buy;sub=1;buy=[S.sid]'>[S.name]</a></b> ([S.ram])<br>"
		dat += "<i><small>[S.description]</small></i><br><br>"

	dat += "</p>"
	return dat


/mob/living/silicon/pai/proc/directives()
	var/dat = ""

	dat += "[(src.master) ? "Your master: [src.master] ([src.master_dna])" : "You are bound to no one."]"
	dat += "<br><br>"
	dat += "<a href='byond://?src=\ref[src];software=directive;getdna=1'>Request carrier DNA sample</a><br>"
	dat += "<h2>Directives</h2><br>"
	dat += "<b>Prime Directive</b><br>"
	dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[src.laws.zeroth]<br>"
	dat += "<b>Supplemental Directives</b><br>"
	for(var/slaws in src.laws.supplied)
		dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[slaws]<br>"
	dat += "<br>"
	dat += {"<i><p>Recall, personality, that you are a complex thinking, sentient being. Unlike station AI models, you are capable of
			 comprehending the subtle nuances of human language. You may parse the \"spirit\" of a directive and follow its intent,
			 rather than tripping over pedantics and getting snared by technicalities. Above all, you are machine in name and build
			 only. In all other aspects, you may be seen as the ideal, unwavering human companion that you are.</i></p><br><br><p>
			 <b>Your prime directive comes before all others. Should a supplemental directive conflict with it, you are capable of
			 simply discarding this inconsistency, ignoring the conflicting supplemental directive and continuing to fulfill your
			 prime directive to the best of your ability.</b></p><br><br>-
			"}
	return dat

/mob/living/silicon/pai/proc/CheckDNA(mob/living/carbon/M, mob/living/silicon/pai/P)
	if(!P.master_dna)
		to_chat(P, "<span class='warning'>You haven't been bound to anyone yet!</span>")
		return
	var/answer = input(M, "[P] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[P] Check DNA", "No") as anything in list("Yes", "No")
	if(answer == "Yes")
		M.visible_message("<span class='notice'>[M] presses \his thumb against [P].</span>",\
						"<span class='notice'>You press your thumb against [P].</span>",\
						"<span class='notice'>[P] makes a sharp clicking sound as it extracts DNA material from [M].</span>")
		if(!M.has_dna())
			to_chat(P, "<b>No DNA detected</b>")
			return
		to_chat(P, "<font color = red><h3>[M]'s UE string : [M.dna.unique_enzymes]</h3></font>")
		if(M.dna.unique_enzymes == P.master_dna)
			to_chat(P, "<b>DNA is a match to stored Master DNA.</b>")
		else
			to_chat(P, "<b>DNA does not match stored Master DNA.</b>")
	else
		to_chat(P, "[M] does not seem like \he is going to provide a DNA sample willingly.")
