var/list/tsbeacon_list = list()

/obj/item/device/tsbeacon
	name = "telescience beacon"
	desc = "A bluespace beacon that provides a target for the telepad. Keep away from valuables!"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "tsbeacon"
	w_class = 2.0
	slot_flags = SLOT_BELT
	origin_tech = "bluespace=1;engineering=2"
	var/beacontag = "beacon"
	var/on = 1
	var/range = 4
	var/emped = 0
	var/turf/faketurf
	var/has_action = 0
	var/action_name = ""
	var/action_available = 1

/obj/item/device/tsbeacon/New()
	..()
	tsbeacon_list.Add(src)
	update_name("[rand(1, 1000)]")
	update_icon()

/obj/item/device/tsbeacon/Destroy()
	tsbeacon_list.Remove(src)
	on = 0
	..()

/obj/item/device/tsbeacon/update_icon()
	overlays.Cut()
	if(emped)
		overlays += "emp"
	else if(on)
		overlays += "working"

/obj/item/device/tsbeacon/proc/update_name(var/newname)
	if(newname)
		beacontag = newname
		name = "[initial(name)] ([beacontag])"

/obj/item/device/tsbeacon/emp_act(severity)
	emped = 1
	on = 1
	var/turf/t = get_turf(src)
	if(!t)
		return
	faketurf = random_accessible_turf(t.z)
	update_icon()
	spawn(3000)
		emped = 0
		faketurf = null
		update_icon()

/obj/item/device/tsbeacon/attack_self(mob/user)
	if(emped) return
	on = !on
	user << "<span class='caution'>You switch [src] [on ? "on" : "off"].</span>"
	update_icon()

/obj/item/device/tsbeacon/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/weapon/pen) || istype(I, /obj/item/toy/crayon))
		var/t = stripped_input(user, "What would you like the label to be?", name, null, 20)
		if(user.get_active_hand() != I)
			return
		if(!in_range(src, user) && loc != user)
			return
		update_name(t)
		return

/obj/item/device/tsbeacon/proc/get_loc()
	if (emped) return faketurf
	return get_turf(src)

/obj/item/device/tsbeacon/proc/can_be_found(z)
	var/turf/t = get_turf(src)
	if(!on || !t || t.z != z)
		return 0
	else
		return 1

/obj/item/device/tsbeacon/proc/get_offset(dx, dy)
	var/turf/t = get_turf(src)
	if(!t)
		return
	var/rx = Clamp(t.x + (emped ? rand(-range, range) : dx), TRANSITIONEDGE + 1, world.maxx - TRANSITIONEDGE - 2)
	var/ry = Clamp(t.y + (emped ? rand(-range, range) : dy), TRANSITIONEDGE + 1, world.maxy - TRANSITIONEDGE - 2)
	return locate(rx, ry, t.z)

/obj/item/device/tsbeacon/proc/beacon_action()
	return

/obj/item/device/tsbeacon/advanced
	name = "advanced telescience beacon"
	desc = "A bluespace beacon that provides a target for the telepad. Keep far, far away from valuables!"
	icon_state = "tsadvbeacon"
	origin_tech = "bluespace=3;engineering=4"
	range = 8

/obj/item/device/tsbeacon/advanced/telepad
	name = "telepad"
	desc = "How did you get it out? This is a bug. Please report it."

/obj/item/device/tsbeacon/advanced/telepad/emp_act(severity)
	return