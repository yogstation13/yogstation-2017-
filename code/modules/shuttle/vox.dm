
/obj/machinery/computer/shuttle/vox
	name = "vox shuttle terminal"
	circuit = /obj/item/weapon/circuitboard/computer/vox_shuttle
	icon_screen = "syndishuttle"
	icon_keyboard = "vox_key"
	req_access = list(access_vox)
	shuttleId = "vox_shuttle"
	possible_destinations = "vox_ne;vox_nw;vox_n;vox_se;vox_sw;vox_s;vox_custom"

/obj/machinery/computer/shuttle/vox/Topic(href, href_list)
	var/mob/user = usr

	if(href_list["move"] == "vox_away")
		if(ticker && istype(ticker.mode, /datum/game_mode/voxheist))
			if(world.time < 6000)	// 10 minutes
				to_chat(usr, "<span class='warning'>It's too early to return.</span>")
				return 0

			switch(alert("OOC INFO: Returning to the vox home will end your raid and report your success or failure.", "Confirmation", "Yes", "No"))
				if("Yes")
					message_admins("[key_name_admin(user)] had ended the vox raid - (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>)")
					log_admin("[key_name(user)] had ended the vox raid")

					possible_destinations = ""
					ticker.mode:returned_home = 1	// We have already checked if ticker.mode is the right type
				if("No")
					return 0
	else
		if(href_list["move"])
			// Makes it so you can only go back to the vox home after atleast travelling to the station once
			possible_destinations += ";vox_away"

	..()


/obj/item/weapon/circuitboard/computer/vox_shuttle
	name = "circuit board (Vox Shuttle)"
	build_path = /obj/machinery/computer/shuttle/vox


/obj/machinery/computer/camera_advanced/shuttle_docker/vox
	name = "vox shuttle navigation computer"
	desc = "Used to designate a precise transit location for the vox shuttle."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	z_lock = ZLEVEL_STATION
	shuttleId = "vox_shuttle"
	shuttlePortId = "vox_custom"
	shuttlePortName = "custom location"
	jumpto_ports = list("vox_away", "vox_ne", "vox_nw", "vox_n", "vox_se", "vox_sw", "vox_s")
	view_range = 13
	//x_offset = -4
	y_offset = 10
