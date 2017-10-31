/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man-portable anti-armor weapon designed to disable mechanical threats at range."
	icon_state = "ionrifle"
	item_state = null	//so the human update icon uses the icon_state instead.
	origin_tech = "combat=4;magnets=4"
	can_flashlight = 1
	w_class = 5
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/ion)
	ammo_x_offset = 3
	flight_x_offset = 17
	flight_y_offset = 9

/obj/item/weapon/gun/energy/ionrifle/emp_act(severity)
	return

/obj/item/weapon/gun/energy/ionrifle/carbine
	name = "ion carbine"
	desc = "The MK.II Prototype Ion Projector is a lightweight carbine version of the larger ion rifle, built to be ergonomic and efficient."
	icon_state = "ioncarbine"
	w_class = 3
	slot_flags = SLOT_BELT
	pin = null
	ammo_x_offset = 2
	flight_x_offset = 18
	flight_y_offset = 11

/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	origin_tech = "combat=4;materials=4;biotech=5;plasmatech=6"
	ammo_type = list(/obj/item/ammo_casing/energy/declone)
	pin = null
	ammo_x_offset = 1

/obj/item/weapon/gun/energy/decloner/update_icon()
	..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(power_supply.charge > shot.e_cost)
		overlays += "decloner_spin"

/obj/item/weapon/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "flora"
	item_state = "gun"
	ammo_type = list(/obj/item/ammo_casing/energy/flora/yield, /obj/item/ammo_casing/energy/flora/mut)
	origin_tech = "materials=2;biotech=4"
	modifystate = 1
	ammo_x_offset = 1
	selfcharge = 1

/obj/item/weapon/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"
	w_class = 4
	ammo_type = list(/obj/item/ammo_casing/energy/meteor)
	cell_type = "/obj/item/weapon/stock_parts/cell/potato"
	clumsy_check = 0 //Admin spawn only, might as well let clowns use it.
	selfcharge = 1

/obj/item/weapon/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = 1

/obj/item/weapon/gun/energy/mindflayer
	name = "\improper Mind Flayer"
	desc = "A prototype weapon recovered from the ruins of Research-Station Epsilon."
	icon_state = "xray"
	item_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/mindflayer)
	ammo_x_offset = 2


/obj/item/weapon/gun/energy/crossbow
	name = "mini radiation crossbow"
	desc = "A weapon favored by syndicate stealth specialists."
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = 2
	cell_type = /obj/item/weapon/stock_parts/cell/emproof
	materials = list(MAT_METAL=2000)
	origin_tech = "combat=4;magnets=4;syndicate=5"
	suppressed = 1
	ammo_type = list(/obj/item/ammo_casing/energy/bolt)
	weapon_weight = WEAPON_LIGHT
	unique_rename = 0
	var/overheat_time = 20
	var/overheat = FALSE

/obj/item/weapon/gun/energy/crossbow/shoot_live_shot()
	..()
	overheat = TRUE
	update_icon()
	addtimer(src,"reload",overheat_time)

/obj/item/weapon/gun/energy/crossbow/proc/reload()
	power_supply.give(500)
	if(!suppressed)
		playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	else
		to_chat(loc, "<span class='warning'>[src] silently charges up.<span>")
	overheat = FALSE
	update_icon()

/obj/item/weapon/gun/energy/crossbow/update_icon()
	if(!can_shoot())
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = initial(icon_state)


/obj/item/weapon/gun/energy/crossbow/large
	name = "energy crossbow"
	desc = "A reverse engineered weapon using syndicate technology."
	icon_state = "crossbowlarge"
	w_class = 3
	materials = list(MAT_METAL=4000)
	origin_tech = "combat=4;magnets=4;syndicate=2"
	suppressed = 0
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/large)
	pin = null

/obj/item/weapon/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	icon_state = "plasmacutter"
	item_state = "plasmacutter"
	modifystate = -1
	origin_tech = "combat=1;materials=3;magnets=2;plasmatech=3;engineering=1"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma)
	flags = CONDUCT | OPENCONTAINER
	attack_verb = list("attacked", "slashed", "cut", "sliced")
	force = 15
	sharpness = IS_SHARP
	can_charge = 0
	heat = 3800

/obj/item/weapon/gun/energy/plasmacutter/examine(mob/user)
	..()
	if(power_supply)
		user <<"<span class='notice'>[src] is [round(power_supply.percent())]% charged.</span>"

/obj/item/weapon/gun/energy/plasmacutter/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/stack/sheet/mineral/plasma))
		var/obj/item/stack/sheet/S = A
		S.use(1)
		power_supply.give(1000)
		to_chat(user, "<span class='notice'>You insert [A] in [src], recharging it.</span>")
	else if(istype(A, /obj/item/weapon/ore/plasma))
		qdel(A)
		power_supply.give(500)
		to_chat(user, "<span class='notice'>You insert [A] in [src], recharging it.</span>")
	else
		..()

/obj/item/weapon/gun/energy/plasmacutter/update_icon()
	return

/obj/item/weapon/gun/energy/plasmacutter/adv
	name = "advanced plasma cutter"
	icon_state = "adv_plasmacutter"
	origin_tech = "combat=3;materials=4;magnets=3;plasmatech=4;engineering=2"
	force = 18
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv)

/obj/item/weapon/gun/energy/wormhole_projector
	name = "bluespace wormhole projector"
	desc = "A projector that emits high density quantum-coupled bluespace beams."
	ammo_type = list(/obj/item/ammo_casing/energy/wormhole, /obj/item/ammo_casing/energy/wormhole/orange)
	item_state = null
	icon_state = "wormhole_projector"
	origin_tech = "combat=4;bluespace=6;plasmatech=4;engineering=4"
	var/obj/effect/portal/blue
	var/obj/effect/portal/orange

/obj/item/weapon/gun/energy/wormhole_projector/update_icon()
	icon_state = "[initial(icon_state)][select]"
	item_state = icon_state
	return

/obj/item/weapon/gun/energy/wormhole_projector/process_chamber()
	..()
	select_fire()

/obj/item/weapon/gun/energy/wormhole_projector/proc/portal_destroyed(obj/effect/portal/P)
	if(P.icon_state == "portal")
		blue = null
		if(orange)
			orange.target = null
	else
		orange = null
		if(blue)
			blue.target = null

/obj/item/weapon/gun/energy/wormhole_projector/proc/create_portal(obj/item/projectile/beam/wormhole/W)
	var/obj/effect/portal/P = new /obj/effect/portal(get_turf(W), null, src)
	P.precision = 0
	if(W.name == "bluespace beam")
		qdel(blue)
		blue = P
	else
		qdel(orange)
		P.icon_state = "portal1"
		orange = P
	if(orange && blue)
		blue.target = get_turf(orange)
		orange.target = get_turf(blue)


/* 3d printer 'pseudo guns' for borgs */

/obj/item/weapon/gun/energy/printer
	name = "cyborg lmg"
	desc = "A machinegun that fires 3d-printed flachettes slowly regenerated using a cyborg's internal power source."
	icon_state = "l6closed0"
	icon = 'icons/obj/guns/projectile.dmi'
	cell_type = "/obj/item/weapon/stock_parts/cell/secborg"
	ammo_type = list(/obj/item/ammo_casing/energy/c3dbullet)
	can_charge = 0
	charge_delay = 2
	burst_size = 3
	actions_types = list(/datum/action/item_action/toggle_firemode/trimode)

	var/list/burst_size_options = list(1, 3, 5)
	var/burst_mode = 2

/obj/item/weapon/gun/energy/printer/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/gun/energy/printer/process()
	charge_tick++
	if(charge_tick < charge_delay)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	if(power_supply.charge < power_supply.maxcharge)
		robocharge()
	return 1

/obj/item/weapon/gun/energy/printer/update_icon()
	return

/obj/item/weapon/gun/energy/printer/emp_act()
	return

/obj/item/weapon/gun/energy/printer/examine(mob/user)
	..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	to_chat(user, "Has [round(power_supply.charge/shot.e_cost)] round\s in it's replication chamber.")

/obj/item/weapon/gun/energy/printer/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/toggle_firemode/trimode)
		toggle_burst()

/obj/item/weapon/gun/energy/printer/proc/toggle_burst()
	burst_mode++

	if(burst_mode > burst_size_options.len)
		burst_mode %= burst_size_options.len

	burst_size = burst_size_options[burst_mode]

	if(burst_size_options[burst_mode] == 1)
		to_chat(usr, "<span class='notice'>You switch to semi-automatic.</span>")
	else
		to_chat(usr, "<span class='notice'>You switch to [burst_size_options[burst_mode]]-rnd burst.</span>")
	return

/datum/action/item_action/toggle_firemode/trimode
	name = "Toggle Firemode (1/3/5 round bursts)"

/obj/item/weapon/gun/energy/laser/instakill
	name = "instakill rifle"
	icon_state = "instagib"
	item_state = "instagib"
	desc = "A specialized ASMD laser-rifle, capable of flat-out disintegrating most targets in a single hit."
	ammo_type = list(/obj/item/ammo_casing/energy/instakill)
	force = 60
	origin_tech = "combat=7;magnets=6"

/obj/item/weapon/gun/energy/laser/instakill/red
	desc = "A specialized ASMD laser-rifle, capable of flat-out disintegrating most targets in a single hit. This one has a red design."
	icon_state = "instagibred"
	item_state = "instagibred"
	ammo_type = list(/obj/item/ammo_casing/energy/instakill/red)

/obj/item/weapon/gun/energy/laser/instakill/blue
	desc = "A specialized ASMD laser-rifle, capable of flat-out disintegrating most targets in a single hit. This one has a blue design."
	icon_state = "instagibblue"
	item_state = "instagibblue"
	ammo_type = list(/obj/item/ammo_casing/energy/instakill/blue)

/obj/item/weapon/gun/energy/laser/instakill/emp_act() //implying you could stop the instagib
	return

/obj/item/weapon/gun/energy/gravity_gun
	name = "one-point bluespace-gravitational manipulator"
	desc = "An experimental, multi-mode device that fires bolts of Zero-Point Energy, causing local distortions in gravity"
	ammo_type = list(/obj/item/ammo_casing/energy/gravipulse, /obj/item/ammo_casing/energy/gravipulse/alt)
	origin_tech = "combat=4;magnets=4;materials=6;powerstorage=4;bluespace=4"
	item_state = null
	icon_state = "gravity_gun"
	var/power = 4

/obj/item/weapon/gun/energy/temperature
	name = "temperature gun"
	icon = 'icons/obj/gun_temperatures.dmi'
	icon_state = "tempgun_4"
	item_state = "tempgun_4"
	fire_sound = 'sound/weapons/pulse3.ogg'
	desc = "A gun that changes the body temperature of its targets."
	var/temperature = 300
	var/target_temperature = 300
	var/e_cost = ""
	origin_tech = "combat=4;materials=4;powerstorage=3;magnets=2"
	ammo_type = list(/obj/item/ammo_casing/energy/temp)
	var/powercost = ""
	var/powercostcolor = ""
	var/emagged = 0			//ups the temperature cap from 500 to 1000, targets hit by beams over 500 Kelvin will burst into flames
	var/dat = ""
	cell_type = "/obj/item/weapon/stock_parts/cell/high"
	pin = null

/obj/item/weapon/gun/energy/temperature/New()
	..()
	update_icon()
	SSobj.processing |= src

/obj/item/weapon/gun/energy/temperature/Destroy()
	SSobj.processing -= src
	return ..()

/obj/item/weapon/gun/energy/temperature/newshot()
	..()
	chambered.temperature = temperature
	chambered.e_cost = e_cost

/obj/item/weapon/gun/energy/temperature/attack_self(mob/living/user as mob)
	user.set_machine(src)
	update_dat()
	user << browse("<TITLE>Temperature Gun Configuration</TITLE><HR>[dat]", "window=tempgun;size=510x102")
	onclose(user, "tempgun")

/obj/item/weapon/gun/energy/temperature/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/emag) && !emagged)
		emagged = 1
		user << "<span class='caution'>You double the gun's temperature cap ! Targets hit by searing beams will burst into flames !</span>"
		desc = "A gun that changes the body temperature of its targets. Its temperature cap has been hacked"  //Visibly emagged? Maybe not a great idea

/obj/item/weapon/gun/energy/temperature/process()
	switch(temperature)
		if(-INFINITY to 100)
			e_cost = 200
			powercost = "High"
		if(100 to 250)
			e_cost = 150
			powercost = "Medium"
		if(251 to 300)
			e_cost = 100
			powercost = "Low"
		if(301 to 400)
			e_cost = 150
			powercost = "Medium"
		if(401 to INFINITY)
			e_cost = 200
			powercost = "High"
	switch(powercost)
		if("High")		powercostcolor = "orange"
		if("Medium")	powercostcolor = "green"
		else			powercostcolor = "blue"
	if(target_temperature != temperature)
		var/difference = abs(target_temperature - temperature)
		if(difference >= (10 + 40*emagged)) //so emagged temp guns adjust their temperature much more quickly
			if(target_temperature < temperature)
				temperature -= (10 + 40*emagged)
			else
				temperature += (10 + 40*emagged)
		else
			temperature = target_temperature
		update_icon()

		if (istype(loc, /mob/living/carbon))
			var /mob/living/carbon/M = loc
			if (src == M.machine)
				update_dat()
				M << browse("<TITLE>Temperature Gun Configuration</TITLE><HR>[dat]", "window=tempgun;size=510x102")


/obj/item/weapon/gun/energy/temperature/proc/update_dat()
	dat = ""
	dat += "Current output temperature: "
	if(temperature > 500)
		dat += "<FONT color=red><B>[temperature]</B> ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F) </FONT>"
		dat += "<FONT color=red><B>SEARING!!</B></FONT>"
	else if(temperature > (T0C + 50))
		dat += "<FONT color=red><B>[temperature]</B> ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"
	else if(temperature > (T0C - 50))
		dat += "<FONT color=black><B>[temperature]</B> ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"
	else
		dat += "<FONT color=blue><B>[temperature]</B> ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"
	dat += "<BR>"
	dat += "Target output temperature: "	//might be string idiocy, but at least it's easy to read
	dat += "<A href='?src=\ref[src];temp=-100'>-</A> "
	dat += "<A href='?src=\ref[src];temp=-10'>-</A> "
	dat += "<A href='?src=\ref[src];temp=-1'>-</A> "
	dat += "[target_temperature] "
	dat += "<A href='?src=\ref[src];temp=1'>+</A> "
	dat += "<A href='?src=\ref[src];temp=10'>+</A> "
	dat += "<A href='?src=\ref[src];temp=100'>+</A>"
	dat += "<BR>"
	dat += "Power cost: "
	dat += "<FONT color=[powercostcolor]><B>[powercost]</B></FONT>"

/obj/item/weapon/gun/energy/temperature/proc/update_temperature()
	switch(temperature)
		if(501 to INFINITY)
			item_state = "tempgun_8"
		if(400 to 500)
			item_state = "tempgun_7"
		if(360 to 400)
			item_state = "tempgun_6"
		if(335 to 360)
			item_state = "tempgun_5"
		if(295 to 335)
			item_state = "tempgun_4"
		if(260 to 295)
			item_state = "tempgun_3"
		if(200 to 260)
			item_state = "tempgun_2"
		if(120 to 260)
			item_state = "tempgun_1"
		if(-INFINITY to 120)
			item_state = "tempgun_0"
	icon_state = item_state
/obj/item/weapon/gun/energy/temperature/update_icon()
	overlays = 0
	update_temperature()

/obj/item/weapon/gun/energy/temperature/ultra
	name = "ultra temperature gun"
	desc = "A gun that changes the body temperature of its targets to any temperature. ANY. TEMPERATURE.."

/obj/item/weapon/gun/energy/temperature/ultra/Topic(href, href_list)
	if (..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		src.target_temperature = src.target_temperature+amount
	if (istype(src.loc, /mob))
		attack_self(src.loc)
	src.add_fingerprint(usr)
	return