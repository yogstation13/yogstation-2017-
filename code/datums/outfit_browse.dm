

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

	return FALSE