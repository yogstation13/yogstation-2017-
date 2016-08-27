var/list/GPS_list = list()

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016. Alt+click to toggle power."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2
	slot_flags = SLOT_BELT
	origin_tech = "materials=2;magnets=1;bluespace=2"
	var/gpstag = "COM0"
	var/emped = 0
	var/turf/locked_location
	var/tracking = FALSE
	var/channel = "common"
	var/emagged = 0
	var/savedlocation // preferably filled with x,y,z

/obj/item/device/gps/New()
	..()
	GPS_list.Add(src)
	name = "global positioning system ([gpstag])"

/obj/item/device/gps/Destroy()
	GPS_list.Remove(src)
	return ..()

/obj/item/device/gps/emp_act(severity)
	emped = TRUE
	overlays -= "working"
	overlays += "emp"
	addtimer(src, "reboot", 300)

/obj/item/device/gps/proc/reboot()
	emped = FALSE
	overlays -= "emp"
	overlays += "working"

/obj/item/device/gps/AltClick(mob/user)
	if(!user.canUseTopic(src, be_close=TRUE))
		return //user not valid to use gps
	if(emped)
		user << "It's busted!"
	if(tracking)
		overlays -= "working"
		user << "[src] is no longer tracking, or visible to other GPS devices."
		tracking = FALSE
	else
		overlays += "working"
		user << "[src] is now tracking, and visible to other GPS devices."
		tracking = TRUE

/obj/item/device/gps/attack_self(mob/user)
	if(!tracking)
		user << "[src] is turned off. Use alt+click to toggle it back on."
		return

	var/obj/item/device/gps/t = ""
	var/turf/gpsturf = get_turf(src)
	var/area/gpsarea = get_area(src)
	var/gps_window_height = 110 + GPS_list.len * 20 // Variable window height, depending on how many GPS units there are to show
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A>"
		t += "<BR><B>[gpstag]: [format_text(gpsarea.name)] ([gpsturf.x], [gpsturf.y], [gpsturf.z])</B>"
		if(savedlocation)
			t += "<BR><B>SAVE: [savedlocation]</B>"
		if(locked_location && locked_location.loc)
			t += "<BR>Bluespace coordinates saved: [locked_location.loc]"
			gps_window_height += 20

		for(var/obj/item/device/gps/G in GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G == src)
				continue
			if(channel != G.channel)
				continue
			if((G.emagged || G.emped) == 1)
				t += "<BR>[tracked_gpstag]: ERROR"
			else if(G.tracking)
				t += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([pos.x], [pos.y], [pos.z])"
			else
				continue
	var/datum/browser/popup = new(user, "GPS", name, 360, min(gps_window_height, 350))
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/gps/Topic(href, href_list)
	..()
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(in_range(src, usr))
			gpstag = a
			if(emagged)
				name = "ERROR"
			else
				name = "global positioning system ([gpstag])"
			attack_self(usr)


/obj/item/device/gps/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/device/multitool))
		playsound(loc, 'sound/machines/click.ogg', 20, 1)
		var/pointing_a_remote_at_the_tv = input(user, "Please choose a channel", name, gpstag) as anything in list("common", "medical", "science", "engine", "lavaland")

		if(!pointing_a_remote_at_the_tv)
			return

		if(emagged)
			return

		channel = "[pointing_a_remote_at_the_tv]"
		user << "<span class='notice'>You change the GPS's channel to [pointing_a_remote_at_the_tv]."

/obj/item/device/gps/emag_act(mob/user)
	if(!emagged)
		user << "<span class='warning'>You scramble the GPS's tag interface."
		emagged = 1

/obj/item/device/gps/medical
	gpstag = "MED0"
	channel = "medical"

/obj/item/device/gps/science
	icon_state = "gps-s"
	gpstag = "SCI0"
	channel = "science"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gpstag = "ENG0"
	channel = "engine"

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gpstag = "MINE0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."
	channel = "lavaland"

/obj/item/device/gps/internal
	icon_state = null
	flags = ABSTRACT
	tracking = TRUE
	gpstag = "Eerie Signal"
	desc = "Report to a coder immediately."
	invisibility = INVISIBILITY_MAXIMUM

/obj/item/device/gps/internal/lavaland
	channel = "lavaland"

/obj/item/device/gps/mining/internal
	icon_state = "gps-m"
	gpstag = "MINER"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."
