/turf/closed/wall/mineral/cult
	name = "runed metal wall"
	desc = "A cold metal wall engraved with indecipherable symbols. Studying them causes your head to pound."
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult"
	canSmoothWith = null
<<<<<<< HEAD
	var/alertthreshold
=======
	sheet_type = /obj/item/stack/sheet/runed_metal
	sheet_amount = 1
	girder_type = /obj/structure/girder/cult
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

/turf/closed/wall/mineral/cult/Initialize()
	new /obj/effect/overlay/temp/cult/turf(src)
	..()

/turf/closed/wall/mineral/cult/devastate_wall()
	new sheet_type(get_turf(src), sheet_amount)

/turf/closed/wall/mineral/cult/narsie_act()
	return

/turf/closed/wall/mineral/cult/ratvar_act()
	. = ..()
	if(istype(src, /turf/closed/wall/mineral/cult)) //if we haven't changed type
		var/previouscolor = color
		color = "#FAE48C"
		animate(src, color = previouscolor, time = 8)
		addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)

/turf/closed/wall/mineral/cult/process()
	..()
	if(alertthreshold)
		alertthreshold--

/turf/closed/wall/mineral/cult/Bumped(atom/movable/C as mob)
	if(istype(C,/mob/living/simple_animal/hostile/construct))
		var/mob/living/simple_animal/hostile/construct/construct = C
		if(!construct.phaser)
			return
		if(construct.pulling)
			construct.stop_pulling()
		construct.forceMove(get_turf(src))
	return

/turf/closed/wall/mineral/cult/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/tome) && iscultist(user))
		if(src.density == 1)
			user <<"<span class='notice'>Your tome passes through the wall as if it's thin air.</span>"
			alpha = 60
			density = 0
			opacity = 0
			var/messaged_admins
			for(var/turf/open/ST in orange(1, src))
				if(messaged_admins || alertthreshold)
					break
				if(istype(ST, /turf/open/space/))
					messaged_admins = TRUE
					message_admins("[src] <A href='?_src_=holder;jumpto=\ref[src]'>([x], [y], [z])</A> has been opened by [user]/[user.ckey] near a space vacuum.")
					log_game("[user]/[user.ckey] used their arcane tome to open a runed wall, which was adjacent to a space tile.")
					alertthreshold += 500
		else
			user <<"<span class='notice'>Your tome solidly connects with the wall.</span>"
			alpha = initial(src.alpha)
			density = 1
			opacity = 1
		return
	else
		..()

/turf/closed/wall/mineral/cult/artificer
	name = "runed stone wall"
	desc = "A cold stone wall engraved with indecipherable symbols. Studying them causes your head to pound."

/turf/closed/wall/mineral/cult/artificer/break_wall()
	new /obj/effect/overlay/temp/cult/turf(get_turf(src))
	return null //excuse me we want no runed metal here

/turf/closed/wall/mineral/cult/artificer/devastate_wall()
	new /obj/effect/overlay/temp/cult/turf(get_turf(src))

//Clockwork wall: Causes nearby tinkerer's caches to generate components.
/turf/closed/wall/clockwork
	name = "clockwork wall"
	desc = "A huge chunk of warm metal. The clanging of machinery emanates from within."
	explosion_block = 2
	hardness = 10
	slicing_duration = 80
	sheet_type = /obj/item/stack/tile/brass
	sheet_amount = 1
	girder_type = /obj/structure/destructible/clockwork/wall_gear
	var/obj/effect/clockwork/overlay/wall/realappearence
	var/obj/structure/destructible/clockwork/cache/linkedcache

/turf/closed/wall/clockwork/Initialize()
	..()
	new /obj/effect/overlay/temp/ratvar/wall(src)
	new /obj/effect/overlay/temp/ratvar/beam(src)
	realappearence = new /obj/effect/clockwork/overlay/wall(src)
	realappearence.linked = src
	change_construction_value(5)

/turf/closed/wall/clockwork/examine(mob/user)
	..()
	if((is_servant_of_ratvar(user) || isobserver(user)) && linkedcache)
		to_chat(user, "<span class='brass'>It is linked to a Tinkerer's Cache, generating components!</span>")

/turf/closed/wall/clockwork/Destroy()
	if(linkedcache)
		linkedcache.linkedwall = null
		linkedcache = null
	change_construction_value(-5)
	if(realappearence)
		qdel(realappearence)
		realappearence = null
	return ..()

/turf/closed/wall/clockwork/ReplaceWithLattice()
	..()
	for(var/obj/structure/lattice/L in src)
		L.ratvar_act()

/turf/closed/wall/clockwork/narsie_act()
	..()
	if(istype(src, /turf/closed/wall/clockwork)) //if we haven't changed type
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)
		addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)

/turf/closed/wall/clockwork/dismantle_wall(devastated=0, explode=0)
	if(devastated)
		devastate_wall()
		ChangeTurf(/turf/open/floor/plating)
	else
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		var/newgirder = break_wall()
		if(newgirder) //maybe we want a gear!
			transfer_fingerprints_to(newgirder)
		ChangeTurf(/turf/open/floor/clockwork)

	for(var/obj/O in src) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

/turf/closed/wall/clockwork/devastate_wall()
	for(var/i in 1 to 2)
		new/obj/item/clockwork/alloy_shards/large(src)
	for(var/i in 1 to 2)
		new/obj/item/clockwork/alloy_shards/medium(src)
	for(var/i in 1 to 3)
		new/obj/item/clockwork/alloy_shards/small(src)


/turf/closed/wall/vault
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/closed/wall/ice
	icon = 'icons/turf/walls/icedmetal_wall.dmi'
	icon_state = "iced"
	desc = "A wall covered in a thick sheet of ice."
	canSmoothWith = null
	hardness = 35
	slicing_duration = 150 //welding through the ice+metal

/turf/closed/wall/rust
	name = "rusted wall"
	desc = "A rusted metal wall."
	icon = 'icons/turf/walls/rusty_wall.dmi'
	hardness = 45

/turf/closed/wall/r_wall/rust
	name = "rusted reinforced wall"
	desc = "A huge chunk of rusted reinforced metal."
	icon = 'icons/turf/walls/rusty_reinforced_wall.dmi'
	hardness = 15
