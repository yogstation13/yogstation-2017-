/obj/item/module/assault/shockgloves
	name = "power glove module"
	id = "shock"
	desc = "Allows your gloves to apply ranged shock to target, provided there is a active powerline nearby. \
		Also insulates your gloves, isn't that nice? Cleverly disguised as a gavel block."
	verbose_desc = "Requires an exposed powernet wire to be nearby (within 1 tile range). If there is power in it, you will \
		attempt to apply a ranged shock to the target, after a 1 second delay. If the target is adjacent to you, the shock is instant. Damage depends on the available power in the powernet, so wire the generator directly into the grid for \
		most effectiveness."
	insertable_atom_types = list(/obj/item/clothing/gloves)
	applicable_atom_types = list(/mob/living/carbon)
	max_range = 6
	var/old_siemens
	var/const/SHOCK_COOLDOWN = 30 //3 seconds between shocks
	var/const/SHOCK_DELAY = 10 //you have to stand in place for 1 second before you actually shock someone. Melee shocks are instant

/obj/item/module/assault/shockgloves/on_install(obj/module_holder/holder, obj/item/clothing/gloves/owner)
	old_siemens = owner.siemens_coefficient
	owner.siemens_coefficient = 0
	..()

/obj/item/module/assault/shockgloves/on_remove(obj/module_holder/holder, obj/item/clothing/gloves/owner)
	owner.siemens_coefficient = old_siemens
	..()

/obj/item/module/assault/shockgloves/on_unarmed_attack(atom/A, mob/user)
	return action(A, user, 1) //melee range is instant shock

/obj/item/module/assault/shockgloves/on_ranged_attack(atom/A, mob/user)
	return action(A, user)

/obj/item/module/assault/shockgloves/can_be_applied(atom/A, mob/user)
	if(!..())
		return
	var/found_cable = FALSE
	var/damage
	for(var/obj/structure/cable/cable in view(1, user))
		found_cable = TRUE
		if(cable.powernet)
			damage = cable.powernet.get_electrocute_damage()
			if(damage > 0)
				break
	if(!found_cable)
		to_chat(user, "<span class='warning'>You need to be adjacent to an exposed power cable!</span>")
		return FALSE
	if(!damage)
		to_chat(user, "<span class='warning'>There are no cables nearby that have enough power to harm someone!</span>")
		return FALSE
	return damage //I know this isn't proper, but why in view(1, user) twice if I can avoid it?

//If shocking is successful, it stops processing the attack (so you won't try to help shake the person up after shocking them)
/obj/item/module/assault/shockgloves/action(mob/living/carbon/A, mob/user, instant = 0)
	var/damage = can_be_applied(A, user)

	if(!damage)
		return

	if(instant)
		user.visible_message("<span class='warning'>[user] touches [A], as \his \the [holder.owner] grow bright with electricity!</span>")
		A.electrocute_act(damage, user)
		. = TRUE
	else
		user.visible_message("<span class='warning'>[user] points \his palm at [A], as \the [holder.owner] grow bright with electricity! RUN!</span>")
		if(do_after(user, SHOCK_DELAY, target = user))
			if(world.time < next_allowed_time)
				return
			//This check is not as precise as something like 'in view(7)' (corners cause problems), but it's probably much cheaper
			if(can_see(user, A, max_range))
				playsound(get_turf(user), 'sound/magic/lightningbolt.ogg', 50, 1)
				user.Beam(A,icon_state="lightning[rand(1,12)]",icon='icons/effects/effects.dmi',time=5)
				A.electrocute_act(damage, user)
				. = TRUE
			else
				to_chat(user, "<span class='warning'>[A] is out of your view!</span>")
	if(.)
		next_allowed_time = world.time + SHOCK_COOLDOWN
		..() //Add attack logs