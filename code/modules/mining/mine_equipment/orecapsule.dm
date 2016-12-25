/obj/item/orecapsule
	name = "ore-box capsule"
	desc = "A small one-use capsule that summons an orebox."
	var/obj/structure/ore_box/box

/obj/item/orecapsule/attack_self(mob/user)
	user << "<span class='warning'>[src] starts shaking! It's going to summon the orebox!</span>"
	addtimer(src, "summonorebox", 50, TRUE, user)

/obj/item/orecapsule/proc/summonorebox(mob/user)
	var/turf/T = get_turf(user)
	if(!T)
		return
	box = new(src)
	box.forceMove(T)
	qdel(src) // rest in peace.