
/obj/item/device/wormhole_jaunter
	name = "wormhole jaunter"
	desc = "A single use device harnessing outdated wormhole technology, Nanotrasen has since turned its eyes to blue space for more accurate teleportation. The wormholes it creates are unpleasant to travel through, to say the least.\nThanks to modifications provided by the Free Golems, this jaunter can be worn on the belt to provide protection from chasms."
	icon = 'icons/obj/mining.dmi'
	icon_state = "Jaunter"
	item_state = "electronic"
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	origin_tech = "bluespace=2"
	slot_flags = SLOT_BELT

/obj/item/device/wormhole_jaunter/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user.name] activates the [src.name]!</span>")
	feedback_add_details("jaunter", "U") // user activated
	activate(user)

/obj/item/device/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(user)
	if(!device_turf||device_turf.z==2||device_turf.z>=7)
		user << "<span class='notice'>You're having difficulties getting the [src.name] to work.</span>"
		return FALSE
	return TRUE

/obj/item/device/wormhole_jaunter/proc/get_destinations(mob/user)
	var/list/destinations = list()

	if(isgolem(user))
		for(var/obj/item/device/radio/beacon/B in world)
			var/turf/T = get_turf(B)
			if(istype(T.loc, /area/ruin/powered/golem_ship))
				destinations += B
	else if(user.z == ZLEVEL_MINING)
		var/list/jauntlist = list()
		for(var/obj/machinery/jauntbeacon/J in jauntbeacons)
			if(J.on)
				jauntlist += J
				J.visible_message("<span class='warning'>[src] begins to light up.</span>")

		var/obj/machinery/jauntbeacon/closestJ = get_closest_atom(/obj/machinery/jauntbeacon, jauntlist, user)
		destinations += closestJ

	// In the event golem beacon is destroyed, send to station instead
	if(destinations.len)
		return destinations

	for(var/obj/item/device/radio/beacon/B in world)
		var/turf/T = get_turf(B)
		if(T.z == ZLEVEL_STATION)
			destinations += B

	return destinations

/obj/item/device/wormhole_jaunter/proc/activate(mob/user)
	if(!turf_check(user))
		return

	var/list/L = get_destinations(user)
	if(!L.len)
		user << "<span class='notice'>The [src.name] found no beacons in the world to anchor a wormhole to.</span>"
		return
	var/chosen_beacon = pick(L)
	var/obj/effect/portal/wormhole/jaunt_tunnel/J = new /obj/effect/portal/wormhole/jaunt_tunnel(get_turf(src), chosen_beacon, lifespan=100, precise=(rand(2,3)))
	J.target = chosen_beacon
	try_move_adjacent(J)
	playsound(src,'sound/effects/sparks4.ogg',50,1)
	qdel(src)

/obj/item/device/wormhole_jaunter/emp_act(power)
	var/triggered = FALSE

	if(usr.get_item_by_slot(slot_belt) == src)
		if(power == 1)
			triggered = TRUE
		else if(power == 2 && prob(50))
			triggered = TRUE

	if(triggered)
		usr.visible_message("<span class='warning'>The [src] overloads and activates!</span>")
		feedback_add_details("jaunter","E") // EMP accidental activation
		activate(usr)

/obj/item/device/wormhole_jaunter/proc/chasm_react(mob/user)
	if(user.get_item_by_slot(slot_belt) == src)
		user << "Your [src] activates, saving you from the chasm!</span>"
		feedback_add_details("jaunter","C") // chasm automatic activation
		activate(user)
	else
		user << "The [src] is not attached to your belt, preventing it from saving you from the chasm. RIP.</span>"


/obj/effect/portal/wormhole/jaunt_tunnel
	name = "jaunt tunnel"
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."

/obj/effect/portal/wormhole/jaunt_tunnel/teleport(atom/movable/M)
	if(istype(M, /obj/effect))
		return

	if(istype(M, /atom/movable))
		if(do_teleport(M, target, precision))
			// KERPLUNK
			playsound(M,'sound/weapons/resonator_blast.ogg',50,1)
			if(iscarbon(M))
				var/mob/living/carbon/L = M
				L.Weaken(3)
				if(ishuman(L))
					shake_camera(L, 20, 1)
					spawn(20)
						if(L)
							L.vomit(20)

var/list/jauntbeacons = list()	// only deployed beacons in here.

/obj/item/device/jauntbeacon
	name = "jaunt beacon"
	desc = "A specialized teleportation platform used in conjunction with jaunt beacons. Requires a wrench to use."
	icon_state = "gangtool-blue" //TEMP ICON
	item_state = "gangtool-blue" //TEMP ICON

/obj/item/device/jauntbeacon/attack_self(mob/user)
	user << "<span class='warning'>You set up [src].</span>"
	var/obj/machinery/jauntbeacon/J = new (get_turf(user))
	jauntbeacons += J
	qdel(src)

/obj/machinery/jauntbeacon
	name = "deployed jaunt beacon"
	density = 0
	icon_state = "mechfab1"
	var/bolted
	var/on

/obj/machinery/jauntbeacon/attack_hand(mob/user)
	if(bolted)
		on = !on
		user << "<span class='warning'>You turn [src] [on ? "on" : "off"].</span>"
	else
		user << "<span class='warning'>[src] needs to be bolted down first!</span>"

/obj/machinery/jauntbeacon/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		visible_message("<span class='notice'>[user] starts to wrench down [src] with [I].</span>")
		if(do_after(user, 50, target = src))
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			bolted = !bolted
			user << "<span class='warning'>You [bolted ? "tighten" : "loosen"] [src]'s bolts.</span>"
	else if(istype(I, /obj/item/weapon/crowbar))
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		if(bolted)
			user << "<span class='warning'>[src] resists [I]!</span>"
		else if(!bolted)
			user << "<span class='warning'>You begin to fork up [src].</span>"
			if(do_after(user, 60, target = src))
				user << "<span class='warning'>You fork up [src] with [I].</span>"
				jauntbeacons -= src
				new /obj/item/device/jauntbeacon(get_turf(user))
				qdel(src)
	else
		..()
