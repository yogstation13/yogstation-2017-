/*
 *	Absorbs /obj/item/weapon/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/weapon/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = 0
	var/open = 0
	w_class = 3
	max_w_class = 2
	max_combined_w_class = 14

/obj/item/weapon/storage/secure/examine(mob/user)
	..()
	to_chat(user, text("The service panel is [open ? "open" : "closed"]."))

/obj/item/weapon/storage/secure/attackby(obj/item/weapon/W, mob/user, params)
	if(locked)
		if (istype(W, /obj/item/weapon/screwdriver))
			if (do_after(user, 20/W.toolspeed, target = src))
				open =! open
				user.show_message("<span class='notice'>You [open ? "open" : "close"] the service panel.</span>", 1)
			return
		if ((istype(W, /obj/item/device/multitool)) && (open == 1)&& (!l_hacking))
			user.show_message("<span class='danger'>Now attempting to reset internal memory, please hold.</span>", 1)
			l_hacking = 1
			if (do_after(usr, 100/W.toolspeed, target = src))
				if (prob(40))
					l_setshort = 1
					l_set = 0
					user.show_message("<span class='danger'>Internal memory reset.  Please give it a few seconds to reinitialize.</span>", 1)
					sleep(80)
					l_setshort = 0
					l_hacking = 0
				else
					user.show_message("<span class='danger'>Unable to reset internal memory.</span>", 1)
					l_hacking = 0
			else
				l_hacking = 0
			return
		//At this point you have exhausted all the special things to do when locked
		// ... but it's still locked.
		return

	// -> storage/attackby() what with handle insertion, etc
	return ..()

/obj/item/weapon/storage/secure/emag_act(mob/user)
	if(locked)
		if(!emagged)
			emagged = 1
			overlays += image('icons/obj/storage.dmi', icon_sparking)
			sleep(6)
			overlays = null
			overlays += image('icons/obj/storage.dmi', icon_locking)
			locked = 0
			to_chat(user, "<span class='notice'>You short out the lock on [src].</span>")

/obj/item/weapon/storage/secure/MouseDrop(over_object, src_location, over_location)
	if (locked)
		add_fingerprint(usr)
		to_chat(usr, "<span class='warning'>It's locked!</span>")
		return 0
	..()

/obj/item/weapon/storage/secure/attack_self(mob/user)
	user.set_machine(src)
	var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (locked ? "LOCKED" : "UNLOCKED"))
	var/message = "Code"
	if ((l_set == 0) && (!emagged) && (!l_setshort))
		dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
	if (emagged)
		dat += text("<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>")
	if (l_setshort)
		dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
	message = text("[]", code)
	if (!locked)
		message = "*****"
	dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
	user << browse(dat, "window=caselock;size=300x280")

/obj/item/weapon/storage/secure/Topic(href, href_list)
	..()
	if ((usr.stat || usr.restrained()) || (get_dist(src, usr) > 1))
		return
	if (href_list["type"])
		if (href_list["type"] == "E")
			if ((l_set == 0) && (length(code) == 5) && (!l_setshort) && (code != "ERROR"))
				l_code = code
				l_set = 1
			else if ((code == l_code) && (emagged == 0) && (l_set == 1))
				locked = 0
				overlays = null
				overlays += image('icons/obj/storage.dmi', icon_opened)
				code = null
			else
				code = "ERROR"
		else
			if ((href_list["type"] == "R") && (emagged == 0) && (!l_setshort))
				locked = 1
				overlays = null
				code = null
				close(usr)
			else
				code += text("[]", href_list["type"])
				if (length(code) > 5)
					code = "ERROR"
		add_fingerprint(usr)
		for(var/mob/M in viewers(1, loc))
			if ((M.client && M.machine == src))
				attack_self(M)
			return
	return

/obj/item/weapon/storage/secure/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
	if(locked)
		to_chat(user, "<span class='warning'>It's locked!</span>")
		return 0
	return ..()

/obj/item/weapon/storage/secure/can_be_inserted(obj/item/W, stop_messages = 0)
	if(locked)
		return 0
	return ..()


// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/weapon/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = 8
	hitsound = "swing_hit"
	throw_speed = 2
	throw_range = 4
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 21
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")

/obj/item/weapon/storage/secure/briefcase/New()
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/pen(src)
	return ..()

/obj/item/weapon/storage/secure/briefcase/attack_hand(mob/user)
	if ((loc == user) && (locked == 1))
		to_chat(usr, "<span class='warning'>[src] is locked and cannot be opened!</span>")
	else if ((loc == user) && (!locked))
		if(!silent)
			playsound(loc, "rustle", 50, 1, -5)
		if (user.s_active)
			user.s_active.close(user) //Close and re-open
		show_to(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				close(M)
		orient2hud(user)
	add_fingerprint(user)
	return

//Syndie variant of Secure Briefcase. Contains space cash, slightly more robust.
/obj/item/weapon/storage/secure/briefcase/syndie
	force = 15

/obj/item/weapon/storage/secure/briefcase/syndie/New()
	for(var/i = 0, i < storage_slots - 2, i++)
		new /obj/item/stack/spacecash/c1000(src)
	return ..()


// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/weapon/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = 8
	w_class = 8
	max_w_class = 8
	anchored = 1
	density = 0
	cant_hold = list(/obj/item/weapon/storage/secure/briefcase)

/obj/item/weapon/storage/secure/safe/New()
	..()
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/pen(src)

/obj/item/weapon/storage/secure/safe/attack_hand(mob/user)
	return attack_self(user)

/obj/item/weapon/storage/secure/safe/HoS/New()
	..()
	//new /obj/item/weapon/storage/lockbox/clusterbang(src) This item is currently broken... and probably shouldnt exist to begin with (even though it's cool)