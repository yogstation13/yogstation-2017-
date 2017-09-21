/obj/item/device/holoprojector
	name = "holographic object projector"
	desc = "A device which has the ability to scan objects and create stationary holographs of them."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 0
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	origin_tech = "magnets=4;programming=4;syndicate=3"

	var/max_holographs = 6 //upgrade capacitor to increase max holograms
	var/list/holographs = list()
	var/atom/current_item = null
	var/current_item_dir = null
	var/list/allow_scanning_these = list(/obj/item) //upgrade microlaser to increase scanning abilities

	var/obj/item/weapon/stock_parts/micro_laser/laser
	var/obj/item/weapon/stock_parts/capacitor/cap

	var/replaced_parts = FALSE
	var/range = 1

/obj/item/device/holoprojector/New()
	..()
	laser = new(src)
	cap = new(src)

/obj/item/device/holoprojector/attack(mob/living/M, mob/user)
	return

/obj/item/device/holoprojector/afterattack(atom/target, mob/user, proximity)
	if(!target) return
	if(get_dist(user, target) > range) return
	if(!laser || !cap)
		user << "<span class='warning'>[src] is missing some parts!</span>"
		return

	if(istype(target, /obj/effect/dummy))
		qdel(target)
		user << "<span class='notice'>You remove the holograph.</span>"
		return

	for(var/T in allow_scanning_these)
		if(istype(target, T))
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 50, 1, -6)
			user << "<span class='notice'>Scanned [target].</span>"
			var/obj/temp = new/obj()
			temp.appearance = target.appearance
			temp.layer = initial(target.layer) // scanning things in your inventory
			current_item = temp.appearance
			current_item_dir = target.dir
			return

	if(istype(target,/turf/open))
		create_holograph(user, target)
	else
		user << "<span class='warning'>You cannot scan that!</span>"

/obj/item/device/holoprojector/proc/create_holograph(mob/user, turf/open/floor/target)
	if(!current_item)
		user << "<span class='warning'>You have not scanned anything to replicate yet!</span>"
		return

	if(holographs.len >= max_holographs)
		qdel(holographs[1])

	user << "<span class='notice'>You create a fake [current_item.name].</span>"
	playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 1, -6)
	new /obj/effect/dummy/holograph(target, src)

/obj/item/device/holoprojector/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(laser)
			laser.loc = get_turf(src.loc)
			laser = null
			replaced_parts = TRUE
		if(cap)
			cap.loc = get_turf(src.loc)
			cap = null
			replaced_parts = TRUE
		if(replaced_parts)
			replaced_parts = FALSE
			user << "<span class='notice'>You pop out the parts from [src].</span>"
			for(var/obj/effect/dummy/holograph/H in holographs)
				qdel(H)
		else
			user << "<span class='warning'>[src] does not have any parts installed!</span>"

	else if(istype(I, /obj/item/weapon/stock_parts/micro_laser) && !laser)
		if(!user.unEquip(I))
			return
		laser = I
		I.loc = src
		user << "<span class='notice'>You insert [laser.name] into [src].</span>"

		switch(laser.rating)
			if(1)
				allow_scanning_these = list(/obj/item)
			if(2)
				allow_scanning_these = list(/obj)
			if(3)
				allow_scanning_these = list(/obj, /mob)
			if(4)
				allow_scanning_these = list(/obj, /mob)

		range = 1+(laser.rating*2)

	else if(istype(I, /obj/item/weapon/stock_parts/capacitor) && !cap)
		if(!user.unEquip(I))
			return
		cap = I
		I.loc = src
		user << "<span class='notice'>You insert [cap.name] into [src].</span>"

		max_holographs = 8*cap.rating

/obj/item/device/holoprojector/attack_self(mob/user)
	user << "<span class='notice'>You disable the projector.</span>"
	for(var/obj/effect/dummy/holograph/H in holographs)
		qdel(H)

/obj/effect/dummy/holograph
	name = ""
	desc = ""
	density = 0
	var/obj/item/device/holoprojector/parent_projector = null
	var/datum/effect_system/spark_spread/spark_system

/obj/effect/dummy/holograph/New(loc, parent)
	if(parent)
		parent_projector = parent
		if(parent_projector.current_item)
			appearance = parent_projector.current_item.appearance
			dir = parent_projector.current_item_dir
			if(prob(100 - (parent_projector.cap.rating*11.25 + parent_projector.laser.rating*11.25))) //Better parts, higher chance of quality hologram, up to 90%
				desc += " <span class='italics'>It seems to be shimmering a little...</span>"
		parent_projector.holographs += src
	..()

/obj/effect/dummy/holograph/Destroy()
	var/msg = pick("[src] distorts for a moment, then disappears!","[src] flickers out of existence!","[src] suddenly disappears!","[src] warps wildly before disappearing!")
	visible_message("<span class='danger'>[msg]</span>")
	playsound(get_turf(src), "sparks", 100, 1)
	if(parent_projector)
		parent_projector.holographs -= src
	return ..()

/obj/effect/dummy/holograph/attackby(obj/item/W, mob/user)
	user << "<span class='danger'>[W] passes right through [src]!</span>"
	qdel(src)

/obj/effect/dummy/holograph/attack_hand(mob/user)
	user << "<span class='danger'>Your hand passes right through [src]!</span>"
	qdel(src)

/obj/effect/dummy/holograph/attack_animal(mob/user)
	user << "<span class='danger'>Your appendage passes right through [src]!</span>"
	qdel(src)

/obj/effect/dummy/holograph/attack_slime(mob/user)
	user << "<span class='danger'>Your blubber passes right through [src]!</span>"
	qdel(src)

/obj/effect/dummy/holograph/attack_alien(mob/user)
	user << "<span class='danger'>Your claws pass right through [src]!</span>"
	qdel(src)

/obj/effect/dummy/holograph/ex_act(S, T)
	qdel(src)

/obj/effect/dummy/holograph/bullet_act()
	..()
	qdel(src)

/obj/effect/dummy/holograph/CtrlClick(mob/user)
	if(get_dist(src, user) > 1) return
	user << "<span class='danger'>You pass through [src] as you try to grab it!</span>"
	qdel(src)

/obj/item/device/holoprojector/debug
	name = "debug holoprojector"
	max_holographs = 24
	allow_scanning_these = list(/obj, /mob)
	range = 9

/obj/item/device/holoprojector/debug/New()
	..()
	laser = new /obj/item/weapon/stock_parts/micro_laser/quadultra(src)
	cap = new /obj/item/weapon/stock_parts/capacitor/quadratic(src)
