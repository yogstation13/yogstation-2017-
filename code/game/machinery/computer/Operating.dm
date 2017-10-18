/obj/machinery/computer/operating
	name = "operating computer"
	desc = "Used to monitor the vitals of a patient during surgery or for identifying organs and implants inside of the patient."
	icon_screen = "crew"
	icon_keyboard = "med_key"
	circuit = /obj/item/weapon/circuitboard/computer/operating
	var/mob/living/carbon/human/patient = null
	var/obj/structure/table/optable/table = null

	var/menu = 1 // one is the standard surgery set up two is scanning cubicles, implant cases, and possibly diskettes, three is database.
	var/list/implants = list(
		/obj/item/weapon/implant/mindshield,
		/obj/item/weapon/implant/tracking,
		/obj/item/weapon/implant/chem,

		)


	var/list/organs = list(
		/obj/item/organ/heart,
		/obj/item/organ/appendix,
		/obj/item/organ/brain,
		/obj/item/organ/brain/alien,
		/obj/item/organ/body_egg/alien_embryo,
		)
	var/scanmsg

	var/obj/item/weapon/storage/handcooler/cubicle/cube = null
	var/obj/item/weapon/implantcase/case = null

	var/lastscan



/obj/machinery/computer/operating/New()
	..()
	if(ticker)
		find_table()

/obj/machinery/computer/operating/erase_data()
	implants = null
	organs = null
	for(var/obj/O in src)
		if(O in (implants || organs))
			qdel(O)

/obj/machinery/computer/operating/process()
	..()

	if(!organs)
		bootup_organs()

	if(!implants)
		bootup_implants()

/obj/machinery/computer/operating/proc/bootup_organs()
	audible_message("[src] reboots their organ database and reverts back the intiial set.")
	organs += /obj/item/organ/heart
	organs += /obj/item/organ/appendix
	organs += /obj/item/organ/brain
	organs += /obj/item/organ/brain/alien
	organs += /obj/item/organ/body_egg/alien_embryo


/obj/machinery/computer/operating/proc/bootup_implants()
	audible_message("[src] reboots their implant database and reverts back the intiial set.")
	implants += /obj/item/weapon/implant/mindshield
	implants += /obj/item/weapon/implant/tracking
	implants += /obj/item/weapon/implant/chem

/obj/machinery/computer/operating/initialize()
	find_table()

/obj/machinery/computer/operating/proc/find_table()
	for(var/dir in cardinal)
		table = locate(/obj/structure/table/optable, get_step(src, dir))
		if(table)
			table.computer = src
			break


/obj/machinery/computer/operating/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/operating/interact(mob/user)
	var/dat = ""
	switch(src.menu)
		if(1)
			dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a><BR>"
			dat += "<a href='byond://?src=\ref[src];menu=2'><< Switch Mode >></a><br>"
			if(table)
				dat += "<B>Patient information:</B><BR>"
				if(table.check_patient())
					patient = table.patient
					dat += get_patient_info()
				else
					patient = null
					dat += "<B>No patient detected</B>"
			else
				dat += "<B>Operating table not found.</B>"
		if(2)
			dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a><BR>"
			dat += "<a href='byond://?src=\ref[src];menu=1'><< Switch Mode >></a><br>"
			if(!cube && !case)
				dat += "<B>There is nothing to scan inside of the operating computer's slots.</B>"

			if (cube)
				var/obj/item/weapon/storage/handcooler/cubicle/thecube = new /obj/item/weapon/storage/handcooler/cubicle
				usr << browse_rsc(icon(thecube.icon,thecube.icon_state), "thecube.png")
				dat += "<br><img src=thecube.png><br>"
				dat += "<a href='byond://?src=\ref[src];cubicle=eject'>Eject Cubicle</a>"
				dat += "<br><a href='byond://?src=\ref[src];cubicle=scan'>Scan</a>"

			if (case)
				var/obj/item/weapon/implantcase/IC = new /obj/item/weapon/implantcase
				if(src.case.imp)
					usr << browse_rsc(icon(IC.icon,"implantcase-r"), "implantcase.png")
				else
					usr << browse_rsc(icon(IC.icon,"implantcase-0"), "implantcase.png")
				dat += "<br><img src=implantcase.png><br>"
				dat += "<a href='byond://?src=\ref[src];icase=eject'>Eject Implant Case</a>"
				dat += "<br><a href='byond://?src=\ref[src];icase=scan'>Scan</a>"

			dat += "<BR><a href='byond://?src=\ref[src];checkaccess=1'><< Open Database >></a>"

			dat += "<BR>[src.scanmsg]"
		if(3)
			var/something = get_database_info()
			dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a><BR><BR>"
			dat += "<TITLE>Nanotrasen Organ-Implant Database</TITLE><center><b>Current logs:</b></center>"
			dat += something
			dat += "<BR><a href='byond://?src=\ref[src];menu=2'>Back</a><br>"

	var/datum/browser/popup = new(user, "op", "Operating Computer", 400, 500)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/operating/proc/get_patient_info()
	var/dat = {"
				<div class='statusLabel'>Patient:</div> [patient.stat ? "<span class='bad'>Non-Responsive</span>" : "<span class='good'>Stable</span>"]<BR>
				<div class='statusLabel'>Blood Type:</div> [patient.dna.blood_type]
				<BR>
				<div class='line'><div class='statusLabel'>Health:</div><div class='progressBar'><div style='width: [max(patient.health, 0)]%;' class='progressFill good'></div></div><div class='statusValue'>[patient.health]%</div></div>
				<div class='line'><div class='statusLabel'>\> Brute Damage:</div><div class='progressBar'><div style='width: [max(patient.getBruteLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getBruteLoss()]%</div></div>
				<div class='line'><div class='statusLabel'>\> Resp. Damage:</div><div class='progressBar'><div style='width: [max(patient.getOxyLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getOxyLoss()]%</div></div>
				<div class='line'><div class='statusLabel'>\> Toxin Content:</div><div class='progressBar'><div style='width: [max(patient.getToxLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getToxLoss()]%</div></div>
				<div class='line'><div class='statusLabel'>\> Burn Severity:</div><div class='progressBar'><div style='width: [max(patient.getFireLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getFireLoss()]%</div></div>
				"}
	if(patient.surgeries.len)
		dat += "<BR><BR><B>Initiated Procedures</B><div class='statusDisplay'>"
		for(var/datum/surgery/procedure in patient.surgeries)
			dat += "[capitalize(procedure.name)]<BR>"
			var/datum/surgery_step/surgery_step = procedure.get_surgery_step()
			dat += "Next step: [capitalize(surgery_step.name)]<BR>"
		dat += "</div>"

	dat += "<BR><BR><B> Implants discovered in the patient:</B><BR>"
	var/implantcheck
	for(var/obj/item/weapon/implant/I in patient.contents)
		if(locate(I) in implants)
			if(implantcheck != 1)
				implantcheck = 1
			dat += "<div class='statusDisplay'>[I.name]"
			dat += "<BR>[I.desc]"
			if(I.icon_state != "generic")
				var/iconname = "[rand(1,9999)]"

				var/iconname_chosen = iconname // so other icons don't become others. Now think of this. A random number is chosen from 1 to 9999, what are the chances things will go wrong and it will choose the same number it has already chosen? An event so unlikely, it's effectively impossible, such as oxygen spontaneously becoming gold. A miracle.
				usr << browse_rsc(icon(I.icon, I.icon_state), "[iconname_chosen].png")
				dat += "<BR><img src=[iconname_chosen].png>"
			dat += "</div><BR>" // no icons, no fun.
	if(!implantcheck)
		dat += "None located with the current database information."

	dat += "<BR><BR><B> Organs discovered within the patient:</B><BR>"
	var/organcheck
	for(var/obj/item/organ/O in patient.internal_organs)
		if(locate(O) in organs)
			if(!organcheck)
				organcheck = 1
			dat += "<div class='statusDisplay'>[O.name]"
			if(O.desc)
				dat += "<BR>[O.desc]" // some organs do not have descriptions
			var/organname = "[rand(1,9999)]"
			var/organname_chosen = organname
			usr << browse_rsc(icon(O.icon, O.icon_state), "[organname_chosen].png")
			dat += "<BR><img src=[organname_chosen].png>"
			dat += "<BR>Located in [O.zone]."
			dat += "</div><BR>"

	if(!organcheck)
		dat += "None located with the current database information."
	return dat


/obj/machinery/computer/operating/Topic(href, href_list)
	if (href_list["cubicle"]).
		switch(href_list["cubicle"])
			if("scan")
				if (!cube)
					scanmsg = "<BR><span class='warning'>Loading error.</span>"
					updateUsrDialog()
					return

				var/pass = cube.scancheck()
				if (!pass)
					scanmsg = "<BR><span class='warning'>Scan error.</span>"
					updateUsrDialog()
					return

				for(var/obj/item/organ/O in cube)
				/*	if(O.decay == -1)
						scanmsg = "<BR><span class='warning'>The organ has decayed. It is unsuitable for scanning.</span>"
						updateUsrDialog()
						return */

					if(O in organs)
						scanmsg = "<BR><span class='warning'>Scan error. Organ is already in the database</span>"
						updateUsrDialog()
						return


					organs += O
					playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
					lastscan = O.name

				scanmsg = "Previous scan was successful."
				updateUsrDialog()

			if("eject")
				if(cube)
					cube.loc = src.loc
					cube = null
				updateUsrDialog()

	else if (href_list["icase"])
		switch(href_list["icase"])
			if("scan")
				if (!case)
					src.scanmsg = "<BR><font class='bad'>Scan error.</font>"
					src.updateUsrDialog()
					return

				if(!case.imp)
					src.scanmsg = "<BR><font class='bad'>Scan error.</font>"
					src.updateUsrDialog()
					return

				for(var/obj/item/weapon/implant/theimplant in case)

					if(locate(case.imp) in implants)
						src.scanmsg = "<font class='bad'><BR>Scan error. Implant is already in the database.</font>"
						src.updateUsrDialog()
						return

					theimplant = case.imp
					implants += theimplant
					lastscan = case.imp.name
					playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)

				scanmsg = "Previous scan was successful."
				updateUsrDialog()

			if("eject")
				if(src.case)
					src.case.loc = src.loc
					src.case = null
				src.updateUsrDialog()


	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])
		src.updateUsrDialog()


	else if (href_list["refresh"])
		src.updateUsrDialog()

	else if (href_list["checkaccess"])
		if(ishuman(usr)) // AI's and borgs will surpass this check.
			src.scanID()
		menu = 3
		updateUsrDialog()

/obj/machinery/computer/operating/proc/scanID(mob/user)
	var/mob/living/carbon/human/M = usr
	var/obj/item/weapon/card/id/I = M.get_idcard()
	if (istype(I, /obj/item/device/pda))
		var/obj/item/device/pda/pda = I
		I = pda.id
	if(M.wear_id)
		if((5 in I.access))
			menu = 3
			updateUsrDialog()
			return

	user <<"<span class='warning'>Access denied.</span>"
	return

/obj/machinery/computer/operating/attackby(obj/item/W, mob/user, params)
	if(src.menu == 2)
		if (istype(W, /obj/item/weapon/storage/handcooler/cubicle) && !istype(W, /obj/item/weapon/storage/handcooler/cubicle/multi))
			if(!src.cube)
				if(!user.drop_item())
					return ..()
				W.loc = src
				src.cube = W
				src.cube.loc = W.loc
				to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
				src.updateUsrDialog()
				return

		if (istype(W, /obj/item/weapon/implantcase))
			if(!src.case)
				if(!user.drop_item())
					return ..()
				W.loc = src
				src.case = W
				to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
				src.updateUsrDialog()
				return

	else if (istype(W, /obj/item/weapon/storage/handcooler/cubicle) || istype(W, /obj/item/weapon/implantcase))
		src.menu = 2
		interact(user)
		src.updateUsrDialog()

	else
		..()
	return

/obj/machinery/computer/operating/proc/get_database_info()
	var/dat = ""
	for(var/A in implants)
		var/obj/A2 = new A
		if(A2.name == lastscan)
			dat += "<BR>[A2.name] - Latest update to the database."
		else
			dat += "<BR>[A2.name]"

	for(var/A in organs)
		var/obj/A3 = new A
		if(A3.name == lastscan)
			dat += "<BR>[A3.name] - Latest update to the database."
		else
			dat += "<BR>[A3.name]"
	return dat