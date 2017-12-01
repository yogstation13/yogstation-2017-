/obj/item/orecapsule
	name = "ore-box capsule"
	desc = "A small one-use capsule that summons an orebox."
	icon = 'icons/obj/mining.dmi'
	icon_state = "capsule2"
	var/obj/structure/ore_box/box
	w_class = 1

/obj/item/orecapsule/attack_self(mob/user)
	to_chat(user, "<span class='warning'>[src] starts shaking! An orebox is emerging!</span>")
	addtimer(src, "summonorebox", 20, TRUE)

/obj/item/orecapsule/proc/summonorebox()
	var/turf/T = get_turf(src)
	if(!T)
		return
	box = new(src)
	box.forceMove(T)
	PoolOrNew(/obj/effect/particle_effect/smoke, get_turf(src))
	qdel(src)