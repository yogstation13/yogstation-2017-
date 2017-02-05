/obj/item/orecapsule
	name = "ore-box capsule"
	desc = "A small one-use capsule that summons an orebox."
	icon = 'icons/obj/mining.dmi'
	icon_state = "capsule2"
	var/obj/structure/ore_box/box

/obj/item/orecapsule/attack_self(mob/user)
	user << "<span class='warning'>[src] starts shaking! It's going to summon the orebox!</span>"
	addtimer(src, "summonorebox", 50, TRUE)

/obj/item/orecapsule/proc/summonorebox()
	var/turf/T = get_turf(src)
	if(!T)
		return
	box = new(src)
	box.forceMove(T)
	PoolOrNew(/obj/effect/particle_effect/smoke, get_turf(src))
	qdel(src) // rest in peace.