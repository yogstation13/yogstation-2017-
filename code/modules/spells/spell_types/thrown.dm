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
		usr << "<span class='warning'>You need a free hand to cast this!</span>"
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