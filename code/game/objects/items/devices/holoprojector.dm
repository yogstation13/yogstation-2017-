/obj/item/device/holoprojector
	name = "holographic item projector"
	desc = "A device which has the ability to scan items and create stationary holographs of them."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 0
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	origin_tech = "magnets=4;programming=4;syndicate=3"

	var/max_holographs = 5
	var/list/holographs = list()
	var/obj/item/current_item = null

/obj/item/device/holoprojector/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target,/obj/item))
		playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
		user << "<span class='notice'>Scanned [target].</span>"
		var/obj/temp = new/obj()
		temp.appearance = target.appearance
		temp.layer = initial(target.layer) // scanning things in your inventory
		current_item = temp.appearance
	else if(istype(target,/turf/open/floor))
		create_holograph(user, target)

/obj/item/device/holoprojector/proc/create_holograph(mob/user, turf/open/floor/target)
	if(!current_item)
		user << "<span class='warning'>You have not scanned anything to replicate yet!</span>"
		return

	if(holographs.len >= max_holographs)
		qdel(holographs[1])

	user << "<span class='notice'>You create a fake [current_item.name].</span>"
	playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 1, -6)
	new /obj/effect/dummy/holograph(target, src)

/obj/effect/dummy/holograph
	name = ""
	desc = ""
	density = 0
	var/obj/item/device/holoprojector/parent_projector = null

/obj/effect/dummy/holograph/New(loc, parent)
	if(parent)
		parent_projector = parent
		if(parent_projector.current_item)
			appearance = parent_projector.current_item.appearance
			desc += " It seems to be shimmering a little..."
		parent_projector.holographs += src
	..()

/obj/effect/dummy/holograph/Destroy()
	visible_message("<span class='danger'>[src] distorts for a moment, then disappears!</span>")
	if(parent_projector)
		parent_projector.holographs -= src
	return ..()

/obj/effect/dummy/holograph/attackby(obj/item/W, mob/user)
	visible_message("<span class='danger'>[W] passes right through [src]!</span>")
	qdel(src)

/obj/effect/dummy/holograph/attack_hand()
	visible_message("<span class='danger'>Your hand passes right through [src]!</span>")
	qdel(src)

/obj/effect/dummy/holograph/attack_animal()
	visible_message("<span class='danger'>Your appendage passes right through [src]!</span>")
	qdel(src)

/obj/effect/dummy/holograph/attack_slime()
	visible_message("<span class='danger'>Your blubber passes right through [src]!</span>")
	qdel(src)

/obj/effect/dummy/holograph/attack_alien()
	visible_message("<span class='danger'>Your claws pass right through [src]!</span>")
	qdel(src)

/obj/effect/dummy/holograph/ex_act(S, T)
	qdel(src)

/obj/effect/dummy/holograph/bullet_act()
	..()
	qdel(src)

/obj/effect/dummy/holograph/CtrlClick(mob/user)
	if(get_dist(src, user) > 1) return
	visible_message("<span class='danger'>You pass through [src] as you try to grab it!</span>")
	qdel(src)