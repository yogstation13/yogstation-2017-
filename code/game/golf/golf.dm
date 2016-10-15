//This is for the mini-game golf.
/obj/machinery/golfhole
	desc = "A hole for the game of golf. Try to score a hole in one."
	name = "golf hole"
	icon = 'code/game/golf/golfstuff.dmi'
	icon_state = "redgolfhole_u"
	anchored = 0
	var/holestate = 0

/obj/machinery/golfhole/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench))
		switch(holestate)
			if(0)
				holestate = 1
				icon_state = "redgolfhole"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures the golf hole to the floor.", \
				"<span class='notice'>You secure the golf hole to the floor.</span>", \
			"	<span class='italics'>You hear a ratchet</span>")
				src.anchored = 1
			if(1)
				holestate = 0
				icon_state = "redgolfhole_u"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures the golf hole  from the floor.", \
				"<span class='notice'>You unwrench the golf hole from the floor.</span>", \
				"<span class='italics'>You hear a ratchet.</span>")
				src.anchored = 0

/obj/machinery/golfhole/CanPass(atom/movable/mover, turf/target, height=0)
	if (contents.len >= 3)
		visible_message("<span class='notice'>The golf hole is full! Try removing golfballs from the hole.</span>")
		return ..(mover, target, height)
	if (istype(mover,/obj/item/golfball) && mover.throwing  && anchored)
		var/obj/item/golfball = mover
		if(prob(75))
			golfball.loc = src
			visible_message("<span class='notice'>The golfball lands in the [src].</span>")

			update_icon()
		else
			visible_message("<span class='notice'>The golfball bounces out of the [src]!</span>")
		return 0
	else
		return ..(mover, target, height)


/obj/machinery/golfhole/attack_hand(atom, mob/user)
	var/obj/item/golfball/ball = locate(/obj/item/golfball) in contents
	if (ball)
		visible_message("<span class='notice'>The golfball is removed from the hole.</span>")
		ball.loc = get_turf(src.loc)

        //Do Something


/obj/machinery/golfhole/proc/hole_place_item_in(obj/item/golfball, mob/user)
	golfball.loc = src
	user.visible_message("[user.name] knocks the golfball into the [src].", \
						"<span class='notice'>You knock the golfball into the [src].</span>")

/obj/machinery/golfhole/blue
	desc = "A hole for the game of golf. Try to score a hole in one."
	name = "golf hole"
	icon = 'code/game/golf/golfstuff.dmi'
	icon_state = "bluegolfhole_u"
	anchored = 0

/obj/machinery/golfhole/blue/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench))
		switch(holestate)
			if(0)
				holestate = 1
				icon_state = "bluegolfhole"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures the golf hole to the floor.", \
				"<span class='notice'>You secure the golf hole to the floor.</span>", \
			"	<span class='italics'>You hear a ratchet</span>")
				src.anchored = 1
			if(1)
				holestate = 0
				icon_state = "bluegolfhole_u"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures the golf hole  from the floor.", \
				"<span class='notice'>You unwrench the golf hole from the floor.</span>", \
				"<span class='italics'>You hear a ratchet.</span>")
				src.anchored = 0

/obj/machinery/golfhole/blue/CanPass(atom/movable/mover, turf/target, height=0)
	if (contents.len >= 3)
		visible_message("<span class='notice'>The golf hole is full! Try removing golfballs from the hole.</span>")
		return ..(mover, target, height)
	if (istype(mover,/obj/item/golfball) && mover.throwing  && anchored)
		var/obj/item/golfball = mover
		if(prob(75))
			golfball.loc = src
			visible_message("<span class='notice'>The golfball lands in the [src].</span>")

			update_icon()
		else
			visible_message("<span class='notice'>The golfball bounces out of the [src]!</span>")
		return 0
	else
		return ..(mover, target, height)


/obj/machinery/golfhole/blue/attack_hand(atom, mob/user)
	var/obj/item/golfball/ball = locate(/obj/item/golfball) in contents
	if (ball)
		visible_message("<span class='notice'>The golfball is removed from the hole.</span>")
		ball.loc = get_turf(src.loc)

        //Do Something


/obj/machinery/golfhole/blue/proc/blue_place_item_in(obj/item/golfball, mob/user)
	golfball.loc = src
	user.visible_message("[user.name] knocks the golfball into the [src].", \
						"<span class='notice'>You knock the golfball into the [src].</span>")

/obj/machinery/golfhole/puttinggreen
	desc = "The captain's putting green for the game of golf. Try to score a hole in one."
	name = "Captain's putting green"
	icon = 'code/game/golf/golfstuff.dmi'
	icon_state = "puttinggreen"
	anchored = 1

/obj/machinery/golfhole/puttinggreen/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench))
		switch(holestate)
			if(0)
				holestate = 1
				icon_state = "puttinggreen"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures the golf hole to the floor.", \
				"<span class='notice'>You secure the golf hole to the floor.</span>", \
			"	<span class='italics'>You hear a ratchet</span>")
				src.anchored = 1
			if(1)
				holestate = 0
				icon_state = "puttinggreen"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures the golf hole  from the floor.", \
				"<span class='notice'>You unwrench the golf hole from the floor.</span>", \
				"<span class='italics'>You hear a ratchet.</span>")
				src.anchored = 0

/obj/machinery/golfhole/puttinggreen/CanPass(atom/movable/mover, turf/target, height=0)
	if (contents.len >= 3)
		visible_message("<span class='notice'>The putting green is full! Try removing golfballs from the hole.</span>")
		return ..(mover, target, height)
	if (istype(mover,/obj/item/golfball) && mover.throwing  && anchored)
		var/obj/item/golfball = mover
		if(prob(75))
			golfball.loc = src
			visible_message("<span class='notice'>The golfball lands in the [src].</span>")

			update_icon()
		else
			visible_message("<span class='notice'>The golfball bounces out of the [src]!</span>")
		return 0
	else
		return ..(mover, target, height)


/obj/machinery/golfhole/puttinggreen/attack_hand(atom, mob/user)
	var/obj/item/golfball/ball = locate(/obj/item/golfball) in contents
	if (ball)
		visible_message("<span class='notice'>The golfball is removed from the hole.</span>")
		ball.loc = get_turf(src.loc)

        //Do Something

/obj/machinery/golfhole/puttinggreen/proc/pgreen_place_item_in(obj/item/golfball, mob/user)
	golfball.loc = src
	user.visible_message("[user.name] knocks the golfball into the [src].", \
						"<span class='notice'>You knock the golfball into the [src].</span>")

/obj/item/golfball
	desc = "A ball for the game of golf."
	name = "golfball"
	icon = 'code/game/golf/golfstuff.dmi'
	icon_state ="golfball"
	throwforce = 12
	attack_verb = list("hit")

/obj/item/golfball/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/golfclub))
		var/turf/throw_at = get_ranged_target_turf(src, get_dir(user, src), 3 /*Magic numbers, We'll fix this later...*/)
		throw_at_fast(throw_at, 3 /*Magic numbers, We'll fix this later...*/, 2)

/obj/item/golfclub
	desc = "A club for the game of golf."
	name = "golfclub"
	icon = 'code/game/golf/golfstuff.dmi'
	icon_state ="golfclub"
	force = 8
	attack_verb = list("smacked", "struck")

/obj/structure/closet/golf
	name = "golf supplies closet"
	desc = "This unit contains all the supplies for golf."
	icon = 'icons/obj/closet.dmi'
	icon_state = "golf"

/obj/structure/closet/golf/New()
	..()
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfball(src)
	new /obj/item/golfclub(src)
	new /obj/item/golfclub(src)
	new /obj/item/golfclub(src)
	new /obj/item/golfclub(src)
	new /obj/machinery/golfhole(src)
	new /obj/machinery/golfhole(src)
	new /obj/machinery/golfhole/blue(src)
	new /obj/machinery/golfhole/blue(src)