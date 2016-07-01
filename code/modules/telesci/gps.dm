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
	var/channel = "Common"

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
	var/gps_window_height = 110 + GPS_list.len * 20 // Variable window height, depending on how many GPS units there are to show
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		t += "<BR>Tag: [gpstag]"
		if(locked_location && locked_location.loc)
			t += "<BR>Bluespace coordinates saved: [locked_location.loc]"
			gps_window_height += 20

		for(var/obj/item/device/gps/G in GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(channel != G.channel)
				continue
			if(G.emped == 1)
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
			name = "global positioning system ([gpstag])"
			attack_self(usr)

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
	if(GT in orange(shortrange,T))
		return "GPS detected within short range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(GT in orange(midrange,T))
		return "GPS detected within medium range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(GT in orange(longrange,T))
		return "GPS detected within long range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

/obj/item/device/gps/scouter/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/device/gps))
		if(!istype(I, src))
			var/obj/item/device/gps/G = I
			user << "<span class='notice'>You link the scouter with the GPS device. It has now been added to the buddy list."
			G += buddies

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
	if(GT in orange(shortrange,T))
		return "GPS detected within short range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(GT in orange(midrange,T))
		return "GPS detected within medium range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(GT in orange(longrange,T))
		return "GPS detected within long range! Identified as [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(GT in orange(longerrange,T))
		return "GPS detected within an extrodinairly long range! Idnetified as a [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."

	if(GT in orange(muchlongerrange,T))
		return "GPS detected far, far away! Identified as a [G.gpstag]. Signal is [dir2text(get_dir(get_turf(src), get_turf(G)))] from your location."