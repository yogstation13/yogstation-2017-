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
	gpstag = "An Eerie Signal"
	desc = "Report to a coder immediately."
	invisibility = INVISIBILITY_MAXIMUM

/obj/item/device/gps/internal/lavaland
	channel = "lavaland"

/obj/item/device/gps/mining/internal
	icon_state = "gps-m"
	gpstag = "MINER"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."

/obj/item/device/gps/scouter
	desc = "This device appears to be a re-engineered GPS. Instead of tracking every GPS's coordinates, the scouting tool allows you to see which GPS is closest to your location."
	gpstag = "SCOUT0"
	icon_state = "gps-m"
	channel = "lavaland"
	icon_state = "gps-sc"
	var/list/buddies = list()
	var/scanlimit = 5
	var/shortrange = 6
	var/midrange = 12
	var/longrange = 18
	var/cooldown
	var/cd_multiplier = 150

/obj/item/device/gps/scouter/examine(mob/user)
	..()
	user << "<span class='notice'>To engage in a buddy system, connect this scouter with another GPS so it does not pick up it's signal.</span>"
	user << "<span class='notice'>Use CTRL+click to clear GPS's connected to your buddy system.</span>"

/obj/item/device/gps/scouter/New()
	..()
	GPS_list.Remove(src)
	name = "gps scouter"


/obj/item/device/gps/scouter/CtrlClick(mob/user)
	user << "<span class='alert'>You clear the buddy list.</span>"
	buddies = null

/obj/item/device/gps/scouter/attack_self(mob/user)
	if(!tracking)
		user << "[src] is turned off. Use alt+click to toggle it back on."
		return

	if(cooldown)
		user << "Your scouter is on a cool down."
		return

	var/scanned // calculates the amount of GPS's we've successfully scanned. if it gets to high and meets the scan limit, big CD
	var/turf/T2 = get_turf(src)

	for(var/obj/item/device/gps/GP in GPS_list)

		if(GP.channel != channel)
			continue

		if(!GP.tracking)
			continue

		if(GP in buddies)
			continue

		if(scanned >= scanlimit)
			scouterCD(user)
			break

		var/turf/T = get_turf(GP)
		if(T.z != T2.z)
			continue

		var/dat = run_scanner_report(GP)
		if(dat)
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			user << "<span class='alert'>[dat]</span>"
			scanned++

	if(!scanned)
		user << "<span class='warning'>The scouter device doesn't pick up anything.</span>"
		return

	if(scanned && !cooldown) // if we've scanned a few and there's still a CD to be had
		var/estimated_break = scanned * cd_multiplier
		cooldown = TRUE
		spawn(estimated_break)
			cooldown = FALSE
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			visible_message("<span class='notice'>[src] is online again!</span>")

/obj/item/device/gps/scouter/proc/run_scanner_report(obj/item/device/gps/G)
	var/turf/T = get_turf(src)
	var/turf/GT = get_turf(G)
	if(T.Distance(GT) <= shortrange)
		return "GPS detected within short range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(T.Distance(GT) <= midrange)
		return "GPS detected within medium range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(T.Distance(GT) <= longrange)
		return "GPS detected within long range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

/obj/item/device/gps/scouter/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/device/gps))
		if(!istype(I,src))
			user << "<span class='notice'>You link the scouter with the GPS device. It has now been added to the buddy list."
			buddies.Add(I)
			return
		else
			return ..()
	else
		return ..()

/obj/item/device/gps/scouter/proc/scouterCD(mob/user) // for when we scan over or equal to our scan limit
	cooldown = TRUE
	user << "<span class='danger'>[src] shuts down!</span>"
	spawn(1000)
		cooldown = FALSE
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message("[src] is online again!")

/obj/item/device/gps/scouter/advanced
	desc = "An upgrade of the latest GPS scouter, with much better performance, can scan for longer ranges, a much smaller cooldown, and will make all of the other miners jealous. With this baby, you could even woe a sexy xenomorph."
	icon_state = "gps-sc-adv"
	scanlimit = 20
	var/longerrange = 30
	var/muchlongerrange = 48
	cd_multiplier = 100

/obj/item/device/gps/scouter/advanced/New()
	..()
	name = "advanced gps scouter"

/obj/item/device/gps/scouter/advanced/run_scanner_report(obj/item/device/gps/G) // apparently 3/4 of this can't run with a ..() so the arguments will be here
	var/turf/T = get_turf(src)
	var/turf/GT = get_turf(G)
	if(T.Distance(GT) <= shortrange)
		return "GPS detected within short range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(T.Distance(GT) <= midrange)
		return "GPS detected within medium range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(T.Distance(GT) <= longrange)
		return "GPS detected within long range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(T.Distance(GT) <= longerrange)
		return "GPS detected within an extrodinairly long range! Idnetified as a [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(T.Distance(GT) <= muchlongerrange)
		return "GPS detected far, far away! Identified as a [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."