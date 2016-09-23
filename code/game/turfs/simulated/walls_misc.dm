/turf/closed/wall/mineral/cult
	name = "runed metal wall"
	desc = "A cold metal wall engraved with indecipherable symbols. Studying them causes your head to pound."
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult"
	walltype = "cult"
	builtin_sheet = null
	canSmoothWith = null
	var/alertthreshold

/turf/closed/wall/mineral/cult/New()
	PoolOrNew(/obj/effect/overlay/temp/cult/turf, src)
	..()

/turf/closed/wall/mineral/cult/break_wall()
	new/obj/item/stack/sheet/runed_metal(get_turf(src), 1)
	return (new /obj/structure/girder/cult(src))

/turf/closed/wall/mineral/cult/devastate_wall()
	new/obj/item/stack/sheet/runed_metal(get_turf(src), 1)

/turf/closed/wall/mineral/cult/narsie_act()
	return

/turf/closed/wall/mineral/cult/ratvar_act()
	..()
	if(istype(src, /turf/closed/wall/mineral/cult)) //if we haven't changed type
		var/previouscolor = color
		color = "#FAE48C"
		animate(src, color = previouscolor, time = 8)

/turf/closed/wall/mineral/cult/process()
	..()
	if(alertthreshold)
		alertthreshold--

/turf/closed/wall/mineral/cult/Bumped(atom/movable/C as mob)
	var/phasable=0
	if(istype(C,/mob/living/simple_animal/hostile/construct))
		var/mob/living/simple_animal/hostile/construct/construct = C
		if(!construct.phaser)
			return
		phasable = 2
		while(phasable>0)
			if(construct.pulling)
				construct.stop_pulling()
			src.density = 0
			src.alpha = 60
			src.opacity = 0
			sleep(10)
			phasable--
		src.density = 1
		src.alpha = initial(src.alpha)
		src.opacity = 1
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

/turf/closed/wall/mineral/cult/artificer
	name = "runed stone wall"
	desc = "A cold stone wall engraved with indecipherable symbols. Studying them causes your head to pound."

/turf/closed/wall/mineral/cult/artificer/break_wall()
	PoolOrNew(/obj/effect/overlay/temp/cult/turf, get_turf(src))
	return null //excuse me we want no runed metal here

/turf/closed/wall/mineral/cult/artificer/devastate_wall()
	PoolOrNew(/obj/effect/overlay/temp/cult/turf, get_turf(src))

//Clockwork wall: Causes nearby tinkerer's caches to generate components.
/turf/closed/wall/clockwork
	name = "clockwork wall"
	desc = "A huge chunk of warm metal. The clanging of machinery emanates from within."
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall"
	canSmoothWith = list(/turf/closed/wall/clockwork)
	smooth = SMOOTH_MORE
	explosion_block = 2

/turf/closed/wall/clockwork/New()
	..()
	PoolOrNew(/obj/effect/overlay/temp/ratvar/wall, src)
	PoolOrNew(/obj/effect/overlay/temp/ratvar/beam, src)
	START_PROCESSING(SSobj, src)
	clockwork_construction_value += 5

/turf/closed/wall/clockwork/Destroy()
	STOP_PROCESSING(SSobj, src)
	clockwork_construction_value -= 5
	..()

/turf/closed/wall/clockwork/process()
	if(prob(2))
		playsound(src, 'sound/magic/clockwork/fellowship_armory.ogg', rand(1, 5), 1, -4, 1, 1)
	for(var/obj/structure/clockwork/cache/C in orange(1, src))
		if(C.wall_generation_cooldown <= world.time)
			C.wall_generation_cooldown = world.time + CACHE_PRODUCTION_TIME
			generate_cache_component()
			playsound(src, 'sound/magic/clockwork/fellowship_armory.ogg', rand(15, 20), 1, -3, 1, 1)
			C.visible_message("<span class='warning'>Something clunks around inside of [C].</span>")

/turf/closed/wall/clockwork/ChangeTurf(path, defer_change = FALSE)
	if(path != type)
		change_construction_value(-5)
	return ..()

/turf/closed/wall/clockwork/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I
		if(!WT.remove_fuel(0,user))
			return 0
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		user.visible_message("<span class='notice'>[user] begins slowly breaking down [src]...</span>", "<span class='notice'>You begin painstakingly destroying [src]...</span>")
		if(!do_after(user, 120 / WT.toolspeed, target = src))
			return 0
		if(!WT.remove_fuel(1, user))
			return 0
		user.visible_message("<span class='notice'>[user] breaks apart [src]!</span>", "<span class='notice'>You break apart [src]!</span>")
		dismantle_wall()
		return 1
	return ..()

/turf/closed/wall/clockwork/ratvar_act()
	for(var/mob/M in src)
		M.ratvar_act()

/turf/closed/wall/clockwork/narsie_act()
	..()
	if(istype(src, /turf/closed/wall/clockwork)) //if we haven't changed type
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)

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

/turf/closed/wall/clockwork/break_wall()
	return new/obj/structure/clockwork/wall_gear(src)

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
	walltype = "iced"
	canSmoothWith = null
	hardness = 35
	slicing_duration = 150 //welding through the ice+metal

/turf/closed/wall/rust
	name = "rusted wall"
	desc = "A rusted metal wall."
	icon = 'icons/turf/walls/rusty_wall.dmi'
	icon_state = "arust"
	walltype = "arust"
	hardness = 45

/turf/closed/wall/r_wall/rust
	name = "rusted reinforced wall"
	desc = "A huge chunk of rusted reinforced metal."
	icon = 'icons/turf/walls/rusty_reinforced_wall.dmi'
	icon_state = "rrust"
	walltype = "rrust"
	hardness = 15

/turf/closed/wall/shuttle
	name = "wall"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	walltype = "shuttle"
	smooth = SMOOTH_FALSE

/turf/closed/wall/shuttle/smooth
	name = "wall"
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle"
	walltype = "shuttle"
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(/turf/closed/wall/shuttle/smooth, /obj/structure/window/shuttle, /obj/structure/shuttle/engine)

/turf/closed/wall/shuttle/smooth/nodiagonal
	smooth = SMOOTH_MORE
	icon_state = "shuttle_nd"

/turf/closed/wall/shuttle/smooth/overspace
	icon_state = "overspace"
	fixed_underlay = list("space"=1)

//sub-type to be used for interior shuttle walls
//won't get an underlay of the destination turf on shuttle move
/turf/closed/wall/shuttle/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(T.color != color)
		T.color = color
	if(T.dir != dir)
		T.dir = dir
	T.transform = transform
	return T

/turf/closed/wall/shuttle/copyTurf(turf/T)
	. = ..()
	T.transform = transform


//why don't shuttle walls habe smoothwall? now i gotta do rotation the dirty way <- DOUBLE GOOFBALL FOR NOT CALLING PARENT
/turf/closed/wall/shuttle/shuttleRotate(rotation)
	if(smooth)
		return ..()
	var/matrix/M = transform
	M.Turn(rotation)
	transform = M
