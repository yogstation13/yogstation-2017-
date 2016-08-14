
/obj/item/weapon/rapid_engineering_device
	name = "\improper Rapid Engineering Device (RED)"
	desc = "A device used to rapidly build, paint, and deconstruct pipes, walls, floors, and doors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "HT_RCD"
	opacity = 0
	density = 0
	anchored = 0
	flags = CONDUCT | NOBLUDGEON
	force = 0
	throwforce = 14
	throw_speed = 3
	throw_range = 5
	w_class = 3
	origin_tech = "engineering=5;materials=3"
	req_access_txt = "11"

	var/datum/effect_system/spark_spread/spark_system
	var/obj/item/weapon/pipe_dispenser/rpd
	var/obj/item/weapon/rcd/rcd
	var/obj/item/weapon/airlock_painter/painter
	var/mode = RED_RCD_MODE
	var/list/mode_names = list("Construction", "Piping", "Airlock Painting")

/obj/item/weapon/rapid_engineering_device/New()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	rpd = new /obj/item/weapon/pipe_dispenser(src)
	rpd.name = name //so the error messages show the correct name
	rpd.abbreviated_name = "RED"

	rcd = new /obj/item/weapon/rcd(src)
	rcd.max_matter = 200
	rcd.name = name
	rcd.abbreviated_name = "RED"
	rcd.no_ammo_message = "<span class='warning'>The \'Low Ammo\' light on \the [src] blinks yellow.</span>"

	painter = new /obj/item/weapon/airlock_painter(src)
	painter.name = name
	qdel(painter.ink)
	painter.ink = null

	update_desc()

/obj/item/weapon/rapid_engineering_device/loaded/New()
	..()
	rcd.matter = rcd.max_matter
	painter.ink = new /obj/item/device/toner(src)

/obj/item/weapon/rapid_engineering_device/Destroy()
	qdel(rpd)
	qdel(rcd)
	qdel(spark_system)
	return ..()

/obj/item/weapon/rapid_engineering_device/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/device/toner))
		painter.attackby(W, user, params)
	else
		rcd.handle_load_matter(W, user)
	update_desc()

/obj/item/weapon/rapid_engineering_device/proc/update_desc()
	desc = initial(desc) + " It is currently in [mode_names[mode]] configuration. Use Alt-Click to change its configuration."

/obj/item/weapon/rapid_engineering_device/examine(mob/user)
	..()
	switch(mode)
		if(RED_AIRLOCK_PAINTER_MODE)
			painter.get_examine_info(user)
		if(RED_RCD_MODE)
			user << "<span class='notice'>It has [rcd.matter]/[rcd.max_matter] matter-units stored.</span>"

/obj/item/weapon/rapid_engineering_device/attack_self(mob/user)
	..()
	switch(mode)
		if(RED_RCD_MODE)
			rcd.attack_self(user)
			//maybe handle sparks?
		if(RED_RPD_MODE)
			rpd.show_menu(user, src)
		if(RED_AIRLOCK_PAINTER_MODE)
			painter.attack_self(user)

/obj/item/weapon/rapid_engineering_device/afterattack(atom/A, mob/user, proximity)
	switch(mode)
		if(RED_RCD_MODE)
			rcd.afterattack(A, user, proximity)
		if(RED_RPD_MODE)
			rpd.afterattack(A, user, proximity)

//VERBS AND ALT-CLICK

/obj/item/weapon/rapid_engineering_device/AltClick(mob/user)
	..()
	if(loc == user && user.canUseTopic(src) )
		toggle_mode()

/obj/item/weapon/rapid_engineering_device/verb/toggle_mode()
	set name = "Change Mode"
	set category = "Object"
	set src in usr

	mode = mode % mode_names.len + 1
	usr << "<span class='notice'>You switch \the [src] to [mode_names[mode]] configuration.</span>"
	update_desc()

	//toggle the sprite and play animation, if necessary.
	src.spark_system.start()

/obj/item/weapon/rapid_engineering_device/verb/change_airlock_access()
	set name = "Change Airlock Access"
	set category = "Object"
	set src in usr
	rcd.show_menu(usr, src)

/obj/item/weapon/rapid_engineering_device/verb/change_airlock_setting()
	set name = "Change Airlock Setting"
	set category = "Object"
	set src in usr
	rcd.change_airlock_setting()

//TOPIC

/obj/item/weapon/rapid_engineering_device/Topic(href, href_list)
	if(!usr.canUseTopic(src))
		rpd.handle_failed_topic(usr)//remove the window.
		rcd.handle_failed_topic(usr)
		return
	src.add_fingerprint(usr)
	switch(href_list["device_type"])
		if("RCD")
			rcd.handle_topic(href, href_list, src)
		if("RPD")
			usr.set_machine(src)
			rpd.handle_topic(href, href_list, src)

/obj/item/weapon/rapid_engineering_device/suicide_act(mob/user)
	switch(mode)
		if(RED_RCD_MODE)
			return rcd.suicide_act(user)
		if(RED_RPD_MODE)
			return rpd.suicide_act(user, src)
		if(RED_AIRLOCK_PAINTER_MODE)
			return painter.suicide_act(user)