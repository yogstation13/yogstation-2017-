

/datum/outfit_browse
	var/datum/outfit/outfitSelected
	var/jobSelected = "None"
	var/datum/browser/popup
	var/datum/mind/mind
	var/window_name = "Outfit Select"
	var/window_id = "outfit_select" //in case you want different browsers able to be open at the same time

	var/static/slots = list("uniform", "suit", "back", "belt", "gloves", "shoes",
						"head", "mask", "ears", "glasses", "id", "l_pocket",
						"r_pocket", "suit_store", "r_hand", "l_hand")

/datum/outfit_browse/New(datum/mind/M)
	mind = M
	outfitSelected = new /datum/outfit()
	..()

/datum/outfit_browse/proc/move_to_mob(var/mob/newmob)
	mind = newmob.mind

/datum/outfit_browse/proc/build_menu(mob/user)
	var/dat = ""
	/*
	var/datum/preferences/prefs = new /datum/preferences()
	prefs.copy_from(user)
	var/image/I = get_flat_human_icon(null, outfitSelected, prefs)
	user << browse_rsc(I, "cham_photo")
	dat += "<table>"
	dat += "<tr><th><b>Preview</b><br><img src=cham_photo height=80 width=80 border=4> <br><a href='?src=\ref[src];update=1'>Apply</a><br>&nbsp;</th><th valign='top' align='left'><b>Current Items:</b><br>"
	for(var/V in registered)
		var/datum/chameleon/C = V
		user << browse_rsc(icon(icon=C.target.icon, icon_state=C.target.icon_state), "cham_[C.chameleon_name]")
		dat += "<img src=cham_[C.chameleon_name] height=32 width=32 border=4> <a href='?src=\ref[src];change=\ref[C]'>Chameleon [C.chameleon_name]</a><br>"
	dat += "</th></tr>"
	dat += "<tr><th valign='top' align='left'><b>Jobs:</b><br>"
	for(var/V in (list("None") + get_all_jobs()))
		if(V == jobSelected)
			dat += "<b> [V]</b><br>"
		else
			dat += "<a href='?src=\ref[src];job=[V]'>[V]</a><br>"

	dat += "</th><th valign='top' align='left'>"
	dat += "<b>Job items:</b><br>"
	for(var/slot in slots)
		var/obj/O = outfitSelected.vars[slot] //this is not actually an object, it's a typepath. We're doing some witchcraft.
		if(O)
			dat += "[initial(O.vars[slot])]<br>"//witchcraft
	dat += "</th></tr></table>"
	*/
	return dat

/datum/outfit_browse/proc/menu(mob/user)
	var/dat = build_menu(user)
	var/datum/browser/popup = new(user, window_id, window_name, 450, 600)
	popup.set_content(dat)
	popup.open()

/datum/outfit_browse/Topic(href, href_list)
	if(href_list["job"])
		jobSelected = href_list["job"]
		var/datum/job/J = SSjob.GetJob(jobSelected)
		if(J && J.outfit)
			var/datum/outfit/job/O = new J.outfit()
			outfitSelected.copyFrom(O)
			outfitSelected.back = O.backpack
		else
			outfitSelected.clear()
		menu(usr)
		return TRUE

	//below this point you must be able to use your hands
	//if(usr.incapacitated())
	//	return FALSE

	return FALSE