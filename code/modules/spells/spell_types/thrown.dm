/obj/effect/proc_holder/spell/thrown
	name = "Thrown"
	desc = "This spell summons an item that must be thrown to cast."
	range = 7
	invocation = "THIS IS A TEST"
	invocation_type = "shout"

	var/held_icon = 'icons/obj/magic.dmi'
	var/held_icon_state = "2"
	var/speed = 2

/obj/effect/proc_holder/spell/thrown/proc/post_summon_holder(var/obj/item/cast_holder/CH)
	return

/obj/effect/proc_holder/spell/thrown/choose_targets()
	if(!iscarbon(usr)) return
	var/mob/living/carbon/C = usr

	var/obj/item/cast_holder/held = new()
	if(!(C.put_in_active_hand(held) || C.put_in_inactive_hand(held)))
		qdel(held)
		charge_counter = charge_max
		to_chat(usr, "<span class='warning'>You need a free hand to cast this!</span>")
		return

	held.spell = src
	held.icon = held_icon
	held.icon_state = held_icon_state
	held.name = name
	held.desc = desc
	post_summon_holder(held)
	C.throw_mode_on() // So we're instantly ready to cast.
	return

/obj/item/cast_holder
	name = "Cast holder"
	desc = "Holds a spell to be thrown"

	var/obj/effect/proc_holder/spell/thrown/spell = null
	var/cast = 0

/obj/item/cast_holder/dropped(mob/usermob)
	if(!cast)
		spell.perform(list(get_turf(src)), user = usermob) // You tried to drop the spell, it detonates on you. Bitch.
		cast = 1
	qdel(src)
	return

/obj/item/cast_holder/equipped(target,slot) // Destroy it if it changes place. Ever.
	if(!(slot == slot_l_hand || slot == slot_r_hand))
		dropped()
	return

/obj/item/cast_holder/on_enter_storage(target)
	return dropped()

/obj/item/cast_holder/prethrow_at(atom/target)
	if(spell.range >= max(abs(target.x-usr.x),abs(target.y-usr.y))) // Quick distance check.
		if(!cast)
			spell.perform(list(target))
			cast = 1
	else
		spell.charge_counter = spell.charge_max
	qdel(src)
	return 1; // So the rest of the throw isn't processed.


/obj/effect/proc_holder/spell/thrown/fireball
	name = "Fireball"
	desc = "A ball of heated fire. Explodes on impact"
	clothes_req = 0
	invocation = "ONI SOMA"
	invocation_type = "shout"
	charge_max = 60

	action_icon_state = "fireball"
	held_icon = 'icons/effects/fire.dmi'
	held_icon_state = "fire"

/obj/effect/proc_holder/spell/thrown/fireball/cast(list/targets, mob/user)
	for(var/atom/target in targets)
		var/turf/T = get_turf(target)
		var/obj/effect/fire_ball/F = new(get_turf(user))
		F.cast_at(T)

/obj/effect/proc_holder/spell/thrown/fireball/post_summon_holder(var/obj/item/cast_holder/CH)
	CH.force = 15
	CH.damtype = "fire"

/obj/effect/fire_ball
	name = "Fireball"
	desc = "Oh shit dodge!"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "fireball"
	pass_flags = PASSTABLE // Float over tables. Duh.

/obj/effect/fire_ball/proc/next_step(atom/target) // Silly diagnals first math.
	if (get_turf(target) == get_turf(src))
		return target
	if (abs(target.x - x) == abs(target.y - y))
		return get_step_towards(src, target)
	if (abs(target.x - x) > abs(target.y - y))
		if (target.x > x)
			return get_step(src, 4)
		return get_step(src, 8)
	if (target.y > y)
		return get_step(src, 1)
	return get_step(src, 2)

/obj/effect/fire_ball/proc/cast_at(target)
	spawn(-1)
		var/i = 14
		while(1)
			var/turf/current = next_step(target)
			if (!current.Adjacent(get_turf(src))) // Something stops us.
				break
			var/stop = 0
			for(var/atom/movable/A in current)
				if(A.density && !(A.pass_flags & LETPASSTHROW))
					stop = 1
					break
			if(stop)
				break
			if (current.density)
				break
			if (current == target)
				loc = get_turf(target)
				break
			i--
			if (i<=0)
				break // JUST incase we some how glitch out.
			dir = get_dir(loc,current)
			loc = current
			sleep(1)
		explosion(loc,-1,-1,2,5)
		qdel(src)


/obj/effect/proc_holder/spell/thrown/vortex
	name = "Vortex Wormhole"
	desc = "A ball of gravitational bluespace energy. Throw to create a portal to suck everything in. Wizards are not affected by the pull."
	clothes_req = 1
	invocation = "Vreet Em"
	invocation_type = "shout"
	charge_max = 200
	level_max = 3

	action_icon_state = "vortex"
	held_icon = 'icons/mob/actions.dmi'
	held_icon_state = "vortex"


/obj/effect/proc_holder/spell/thrown/vortex/choose_targets()
	var/area/A = get_area(usr)
	if(istype(A,/area/centcom/vortex))
		var/obj/effect/vortex/vortex = new(vortex_beacon.last_turf)
		vortex.max_lifespan = vortex.max_lifespan += 2*spell_level
		vortex.creator = usr
		invocation()
		start_recharge()
		return
	..()

/obj/effect/proc_holder/spell/thrown/vortex/cast(list/targets, mob/user)
	if(!(user in vortex_beacon.casters))
		vortex_beacon.casters.Add(user)
	for(var/atom/target in targets)
		var/obj/effect/vortex/vortex = new()
		vortex.max_lifespan = vortex.max_lifespan += 2*spell_level
		vortex.creator = user
		var/turf/T = get_turf(target)
		vortex.forceMove(T)
		playsound(T,'sound/magic/blink.ogg',80,1)
		break

/area/centcom/vortex
	name = "vortex"
	requires_power = 1

/obj/effect/vortex
	name = "vortex"
	icon = 'icons/mob/actions.dmi'
	icon_state = "vortex"
	anchored = 1
	density = 1
	var/max_lifespan = 4 //In seconds. This is actually 7 since it gives you 3 seconds for ever level. Standard being 4 + 1*3
	var/lifespan = 0
	var/creator

var/obj/effect/vortex_end/vortex_beacon

/obj/effect/vortex/New()
	..()
	vortex_beacon.Open()
	vortex_beacon.vortexes.Add(src)
	START_PROCESSING(SSobj, src)

/obj/effect/vortex/process()
	if(lifespan >= max_lifespan)
		stopVortex()
		return
	pullVortex()
	lifespan += 2
	addtimer(src, "pullVortex",10)

/obj/effect/vortex/attack_hand(mob/user)
	if(user == creator)
		to_chat(user, "<span class='notice'>You distort the [name].</span>")
		stopVortex()
	else if(!(user in vortex_beacon.casters))
		suck(user)

/obj/effect/vortex/proc/pullVortex()
	var/pulled = 0
	var/capacity = 10 //The spell is already too powerful, let's give it at least a small limit
	for(var/mob/living/L in orange(7,src))
		if(pulled >= capacity)
			return

		if(!(L in vortex_beacon.casters) && !(L.pulledby in vortex_beacon.casters))
			step_towards(L,src)
			pulled++

	for(var/obj/item/I in orange(0,src))
		if(!I.anchored)
			suck(I)

	for(var/obj/item/I in orange(7,src))
		if(pulled >= capacity)
			return
		if(!I.anchored)
			step_towards(I,src)
			pulled++

/obj/effect/vortex/proc/stopVortex()
	visible_message("<span class='warning'>The [name] collapses.</span>")
	vortex_beacon.vortexes.Remove(src)
	if(!vortex_beacon.vortexes.len)
		vortex_beacon.Close()
	STOP_PROCESSING(SSobj, src)
	vortex_beacon.last_turf = get_turf(src)
	qdel(src)

/obj/effect/vortex/Bumped(mob/A)
	suck(A)

/obj/effect/vortex/Bump(mob/A)
	suck(A)

/obj/effect/vortex/proc/suck(atom/movable/AM)
	AM.forceMove(vortex_beacon.loc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(!(L in vortex_beacon.casters))
			L.Stun(2)

/obj/effect/vortex_end
	name = "vortex"
	icon = 'icons/mob/actions.dmi'
	icon_state = "vortex"
	anchored = 1
	density = 1
	layer = 5
	var/icon_state_closed = "vortex_closed"
	var/list/vortexes = list()
	var/opened = FALSE
	var/turf/last_turf
	var/list/casters = list()

/obj/effect/vortex_end/New()
	..()
	vortex_beacon = src

/obj/effect/vortex_end/proc/Open()
	opened = TRUE
	icon_state = initial(icon_state)

/obj/effect/vortex_end/proc/Close()
	opened = FALSE
	icon_state = icon_state_closed
	var/i = 0
	for(var/obj/item/I in orange(6,src))
		if(i >= 20)
			break
		step(I,pick(NORTH,SOUTH,EAST,WEST))
		i++

/obj/effect/vortex_end/Bumped(mob/A)
	if((A in casters) || (A.pulledby in casters))
		if(vortexes.len)
			var/obj/effect/vortex/vortex = pick(vortexes)
			A.forceMove(get_turf(vortex))
		else if(A in casters)
			to_chat(A, "<span class='warning'>The vortex is closed, cast the spell again or find another way out!</span>")
	else if(isliving(A))
		var/mob/living/L = A
		L.Stun(4)
		playsound(get_turf(src), 'sound/magic/LightningShock.ogg', 30, 1, -1)


/obj/effect/vortex_end/attack_hand(mob/user)
	if(user in casters && opened)
		for(var/obj/effect/vortex/vortex in vortexes)
			if(vortex.creator == user)
				vortex.stopVortex()
				to_chat(user, "<span class='warning'>You closed a vortex!</span>")
				break

/obj/effect/vortex_end/Destroy(force)
	if(force)
		..()
		. = QDEL_HINT_HARDDEL_NOW
	else
		return QDEL_HINT_LETMELIVE