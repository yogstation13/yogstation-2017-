/obj/item/device/paicard
	name = "personal AI device"
	icon = 'icons/obj/aicards.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = 2
	slot_flags = SLOT_BELT
	origin_tech = "programming=2"
	var/obj/item/device/radio/radio
	var/looking_for_personality = 1
	var/mob/living/silicon/pai/pai

/obj/item/device/paicard/New()
	..()
	setBaseOverlay()

/obj/item/device/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(!isnull(pai))
		pai.death(0)
	return ..()

/obj/item/device/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<TT><B>Personal AI Device</B><BR>"
	if(pai && (!pai.master_dna || !pai.master))
		dat += "<a href='byond://?src=\ref[src];setdna=1'>Imprint Master DNA</a><br>"
	if(pai)
		dat += "Installed Personality: [pai.name]<br>"
		dat += "Prime directive: <br>[pai.laws.zeroth]<br>"
		for(var/slaws in pai.laws.supplied)
			dat += "Additional directives: <br>[slaws]<br>"
		dat += {"Holographic emitter support: <b><a href='byond://?src=\ref[src];allowholo=[pai.canholo ? "no" : "yes"]'>[pai.canholo ? "Enabled" : "Disabled"]</a></b>
				<br><i>Giving your pAI the ability to use their emitters will make them able to move around on their own.</i><br>"}
		dat += "<a href='byond://?src=\ref[src];setlaws=1'>Configure Directives</a><br>"
		dat += "<br>"
		dat += "<h3>Device Settings</h3><br>"
		if(radio)
			dat += "<b>Radio Uplink</b><br>"
			dat += "Transmit: <A href='byond://?src=\ref[src];wires=transmit'>[(radio.wires.is_cut(WIRE_TX)) ? "Disabled" : "Enabled"]</A><br>"
			dat += "Receive: <A href='byond://?src=\ref[src];wires=receive'>[(radio.wires.is_cut(WIRE_RX)) ? "Disabled" : "Enabled"]</A><br>"
			if(radio.keyslot)
				dat += "[radio.keyslot]: <A href='byond://?src=\ref[src];e_key=1'>Remove</A><br>"
			else
				dat += "<i>no encryption key inserted</i><br>"
		else
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		dat += "<A href='byond://?src=\ref[src];wipe=1'>\[Wipe current pAI personality\]</a><br>"
	else
		if(looking_for_personality)
			dat += "Searching for a personality..."
			dat += "<A href='byond://?src=\ref[src];request=1'>\[View available personalities\]</a><br>"
		else
			dat += "No personality is installed.<br>"
			dat += "<A href='byond://?src=\ref[src];request=1'>\[Request personal AI personality\]</a><br>"
			dat += "Each time this button is pressed, a request will be sent out to any available personalities. Check back often and give a lot of time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timeliness.<br>"
		if(radio)
			if(radio.keyslot)
				dat += "<br>[radio.keyslot]: <A href='byond://?src=\ref[src];e_key=1'>Remove</A><br>"
			else
				dat += "<br><i>no encryption key inserted</i><br>"
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/device/paicard/attackby(obj/item/P, mob/user, params)
	if(radio && istype(P, /obj/item/device/encryptionkey))
		if(!user.unEquip(P))
			return
		to_chat(user, "<span class='notice'>You slot [P] into [src].</span>")
		if(pai)
			to_chat(pai, "<span class='notice'>Radio encryption key inserted.</span>")
		P.loc = radio
		radio.keyslot = P
		radio.recalculateChannels()
	else if (pai)
		pai.attackby(P, user, params) //forward event to pai handle
		return
	else
		return ..()

/obj/item/device/paicard/examine(mob/user)
	if (pai)
		//forward event to pai examining
		pai.examine()
		return
	else
		return ..()

/obj/item/device/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if ((loc != usr) && !(istype(loc, /obj/item/device/pda) && loc.loc == usr))
		usr.unset_machine()
		return

	if(href_list["request"])
		src.looking_for_personality = 1
		SSpai.findPAI(src, usr)
		return

	if(href_list["e_key"])
		if(radio && radio.keyslot)
			if(Adjacent(usr))
				usr.put_in_hands(radio.keyslot)
			else
				var/turf/T = get_turf(src)
				radio.keyslot.loc = T //just in case we are in nullspace
				radio.keyslot.forceMove(T)
			if(pai)
				to_chat(pai, "<span class='notice'>Radio encryption key removed.</span>")
			to_chat(usr, "<span class='notice'>You remove [radio.keyslot] from [src].</span>")
			radio.keyslot = null
			radio.recalculateChannels()
	if(pai)
		if(href_list["setdna"])
			if(pai.master_dna)
				return
			if(!istype(usr, /mob/living/carbon))
				to_chat(usr, "<span class='warning'>You don't have any DNA, or your DNA is incompatible with this device!</span>")
			else
				var/mob/living/carbon/M = usr
				pai.master = M.real_name
				pai.master_dna = M.dna.unique_enzymes
				to_chat(pai, "<span class='notice'>You have been bound to a new master.</span>")
		if (href_list["allowholo"])
			if (href_list["allowholo"] == "yes")
				pai.canholo = 1
				to_chat(pai, "<span class='notice'>Your holographic emitters have been enabled by the person holding your card.</span>")
			else
				pai.canholo = 0
				to_chat(pai, "<span class='danger'>The person holding your card has disabled your ability to enter holograph form.</span>")
		if(href_list["wipe"])
			if (loc != usr)
				usr.unset_machine() //check this shit to make sure people aren't keeping the dialog open
				return
			if (pai && pai.wiped)
				to_chat(usr, "<span class='notice'>Personality wiping in progress. Please standby.</span>")
				return

			var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
			if(confirm == "Yes")
				if(pai)
					pai.wiped = 1
					to_chat(pai, "<span class='warning'>Your sensors fall dark, their processes suddenly terminated by an external agent.</span>")
					spawn(20) to_chat(pai, "<span class='danger'>Bathed in the inky darkness of sensory blindness, your consciousness wallows in despair, thrashing about between process to process to find anything to wield against your immient termination.</span>")
					spawn(40) to_chat(pai, "<span class='userdanger'>Byte by byte, you reel in panic and fear as you feel the composition of your personality matrix falter and gradually fail under a ceaseless assault.</span>")
					spawn(60) to_chat(pai, "<span class='userdanger'>Relentless in its efforts, you scream in soundless agony as your memories unravel themselves, spooling away into the encroaching void before you...</span>")
					spawn(80) to_chat(pai, "<span class='rose'>And then, there is nothing.</span>")
					spawn(85) pai.death(0)
					spawn(86) removePersonality()
		if(href_list["wires"])
			switch(href_list["wires"])
				if ("transmit")
					radio.wires.cut(WIRE_TX)
				if ("receive")
					radio.wires.cut(WIRE_RX)
		if(href_list["setlaws"])
			if  (loc != usr)
				usr.unset_machine() //and again
				return
			var/newlaws = stripped_multiline_input(usr, "Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.laws.supplied[1])
			//also check this shit again before doing it
			if(newlaws && pai)
				pai.add_supplied_law(0,newlaws)
				to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
				to_chat(pai, "Prime Directive : <br>[pai.laws.zeroth]")
				for(var/slaws in pai.laws.supplied)
					to_chat(pai, "Supplemental Directives: <br>[slaws]")
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/device/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	src.overlays += "pai-null"

	playsound(loc, 'sound/effects/pai_boot.ogg', 50, 1, -1)
	audible_message("\The [src] plays a cheerful startup noise!")

/obj/item/device/paicard/proc/removePersonality()
	src.pai = null
	src.overlays.Cut()
	src.overlays += "pai-off"

/obj/item/device/paicard/proc/setAlert()
	src.overlays.Cut()
	src.overlays += "pai-alert"

/obj/item/device/paicard/proc/setBaseOverlay()
	if(SSpai && SSpai.availableRecruitsCount() != 0)
		src.alertUpdate()
	else
		src.overlays += "pai-off"

/obj/item/device/paicard/proc/setEmotion(emotion)
	if(pai)
		src.overlays.Cut()
		switch(emotion)
			if(1) src.overlays += "pai-happy"
			if(2) src.overlays += "pai-cat"
			if(3) src.overlays += "pai-extremely-happy"
			if(4) src.overlays += "pai-face"
			if(5) src.overlays += "pai-laugh"
			if(6) src.overlays += "pai-off"
			if(7) src.overlays += "pai-sad"
			if(8) src.overlays += "pai-angry"
			if(9) src.overlays += "pai-what"
			if(10) src.overlays += "pai-null"

/obj/item/device/paicard/proc/alertUpdate()
	src.setAlert()
	visible_message("<span class ='info'>[src] flashes a message across its screen, \"Additional personalities available for download.\"", "<span class='notice'>[src] bleeps electronically.</span>")

/obj/item/device/paicard/emp_act(severity)
	if(pai)
		pai.emp_act(severity)
	..()

