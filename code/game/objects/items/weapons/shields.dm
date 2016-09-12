#define SHIELD_NORMAL 0
#define SHIELD_CRACKED 1
#define SHIELD_BREAKING 2

#define IMPROPERBLOCK 0
#define PROPERBLOCK 1

var/global/list/blockcheck = list("[NORTH]" = list("[SOUTH]" = PROPERBLOCK, "[EAST]" = PROPERBLOCK, "[WEST]" = PROPERBLOCK, "[NORTH]" = IMPROPERBLOCK),
"[EAST]" = list("[SOUTH]" = PROPERBLOCK, "[WEST]" = PROPERBLOCK, "[EAST]" = IMPROPERBLOCK, "[NORTH]" = PROPERBLOCK),
"[SOUTH]" = list("[NORTH]" = PROPERBLOCK, "[WEST]" = PROPERBLOCK, "[EAST]" = PROPERBLOCK, "[SOUTH]" = IMPROPERBLOCK ),
"[WEST]" = list("[NORTH]" = PROPERBLOCK, "[EAST]" = PROPERBLOCK, "[SOUTH]" = PROPERBLOCK, "[WEST]" = IMPROPERBLOCK) )

/obj/item/weapon/proc/check_for_positions(mob/living/carbon/human/H, atom/movable/AM)
	var/facing_hit = blockcheck["[H.dir]"]["[AM.dir]"]
//	message_admins("This is [H] and his direction is [H.dir].") //break glass if needed -Super
//	message_admins("This is [AM] and his direction is [AM.dir].")
	return facing_hit

/obj/item/weapon/shield
	name = "shield"
	icon = 'icons/obj/weapons.dmi'
	block_chance = 50
	var/block_limit = 0 // used to see whether a weapon has enough force to break a shield
	var/shieldstate = SHIELD_NORMAL
	var/shieldhealth


/obj/item/weapon/shield/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		final_block_chance += 80
	else if(attack_type == PROJECTILE_ATTACK)
		final_block_chance -= 20
	else
		return 1

/obj/item/weapon/shield/proc/shatter_reaction(mob/living/carbon/human/owner)
	owner.visible_message("<span class='danger'>[owner]'s shield shatters after blocking an attack!</span class>")
	var/break_location = get_turf(loc)
	var/obj/item/weapon/shield/broken/B = new /obj/item/weapon/shield/broken(break_location)
	owner.put_in_active_hand(B)
	var/formershield = icon_state
	B.generateshield(formershield)
	qdel(src)

/obj/item/weapon/shield/proc/check_shatter(mob/living/carbon/human/owner, damage)
	if(damage)
		var/examinedhealth = shieldhealth - damage
		if(examinedhealth >= 50)
			shieldstate = SHIELD_CRACKED
			owner.visible_message("<span class='danger'>[owner]'s shield cracks slightly from the hit!</span class>")
			shieldhealth = examinedhealth
			return 1
		if(examinedhealth >= 25) // below 50
			shieldstate = SHIELD_BREAKING
			owner.visible_message("<span class='danger'>[owner]'s shield begins to fall apart from the hit!<span class>")
			shieldhealth = examinedhealth
			return 1

		if(examinedhealth >= 6 || examinedhealth < 4)
			shieldstate = null
			shatter_reaction(owner)
			shieldhealth = examinedhealth
			return 0

		else
			return 1

/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon_state = "riot"
	slot_flags = SLOT_BACK
	force = 10
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = 4
	materials = list(MAT_GLASS=7500, MAT_METAL=1000)
	origin_tech = "materials=3;combat=4"
	attack_verb = list("shoved", "bashed")
	block_chance = 50
	block_limit = 25
	shieldhealth = 75
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/weapon/shield/riot/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		return ..()

/obj/item/weapon/shield/riot/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type, atom/movable/AT)
	if(attack_type == MELEE_ATTACK)
		if(!check_for_positions(owner,AT))
			return 0
		if(damage > block_limit)
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			var/roll_for_shatter = check_shatter(owner, damage)
			if(roll_for_shatter)
				return 1
			else
				return 0
		else
			return 1

	else if(attack_type == UNARMED_ATTACK)
		if(!check_for_positions(owner,AT))
			return 0
		else
			return 1


	else if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(isitem(AT))
			var/obj/item/O = AT
			if(O.thrower_dir)
				O.dir = O.thrower_dir
			if(!check_for_positions(owner,O))
				return 0
			else
				return 1
		else
			final_block_chance += 50
			return ..()

	else if(attack_type == PROJECTILE_ATTACK)
		if(!check_for_positions(owner,AT))
			return 0
		return ..()

	else if (attack_type == HULK_ATTACK) // trying to block a hulk backfires.
		playsound(src, 'sound/effects/bang.ogg', 100, 1)
		owner.unEquip(src)
		var/target = src.loc
		for(var/i = 0, i < 7, i++)
			target = get_step(target, pick(alldirs))
		src.throw_at(target,7,1, spin = 0)
		if(prob(final_block_chance))
			owner.Weaken(2) // if it ain't tossin, they're takin the heat
		return 0
	else
		return 1

/obj/item/weapon/shield/riot/examine(mob/user)
	..()
	if(shieldstate == SHIELD_CRACKED)
		user << "<span class='notice'>The shield has a few cracks in it.</span class>"
	if(shieldstate == SHIELD_BREAKING)
		user << "<span class='danger'>The shield is breaking apart.</span class>"

/obj/item/weapon/shield/riot/roman
	name = "roman shield"
	desc = "Bears an inscription on the inside: <i>\"Romanes venio domus\"</i>."
	icon_state = "roman_shield"
	item_state = "roman_shield"

/obj/item/weapon/shield/riot/roman/prop
	desc = "Made of cheap, lightweight plastic. Bears an inscription on the inside: <i>\"Romanes venio domus\"</i>."
	force = 3
	throwforce = 3
	block_limit = 9

/obj/item/weapon/shield/riot/roman/prop/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	return 0

/obj/item/weapon/shield/riot/buckler
	name = "wooden buckler"
	desc = "A medieval wooden buckler."
	icon_state = "buckler"
	item_state = "buckler"
	materials = list()
	origin_tech = "materials=1;combat=3;biotech=2"
	burn_state = FLAMMABLE
	block_limit = 15
	block_chance = 30

/obj/item/weapon/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most melee attacks. Protects user from almost all energy projectiles. It can be retracted, expanded, and stored anywhere."
	icon_state = "eshield0" // eshield1 for expanded
	force = 3
	throwforce = 3
	throw_speed = 3
	throw_range = 5
	w_class = 1
	origin_tech = "materials=4;magnets=5;syndicate=6"
	attack_verb = list("shoved", "bashed")
	var/active = FALSE
	var/on_force = 10
	var/on_throwforce = 8
	var/on_throw_speed = 2
	var/on_w_class = 4
	var/clumsy_check = 1
	var/icon_state_base = "eshield"

/obj/item/weapon/shield/energy/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type, atom/movable/AT)
	if(active)
		if(attack_type == UNARMED_ATTACK)
			if(!check_for_positions(owner,AT))
				return 0
			else
				return 1
		else
			return 0
	else
		return 0

/obj/item/weapon/shield/energy/IsReflect(def_zone)
//	if(!check_for_positions(D,M))
//		return 0
	return (active)

/obj/item/weapon/shield/energy/attack_self(mob/living/carbon/human/user)
	if((clumsy_check && (user.disabilities & CLUMSY)) && prob(50))
		user << "<span class='warning'>You beat yourself in the head with [src].</span>"
		user.take_organ_damage(5)
	active = !active
	icon_state = "[icon_state_base][active]"

	if(active)
		force = on_force
		throwforce = on_throwforce
		throw_speed = on_throw_speed
		w_class = on_w_class
		playsound(user, 'sound/weapons/saberon.ogg', 35, 1)
		user << "<span class='notice'>[src] is now active.</span>"
	else
		force = initial(force)
		throwforce = initial(throwforce)
		throw_speed = initial(throw_speed)
		w_class = initial(w_class)
		playsound(user, 'sound/weapons/saberoff.ogg', 35, 1)
		user << "<span class='notice'>[src] can now be concealed.</span>"
	add_fingerprint(user)

/obj/item/weapon/shield/riot/tele
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon_state = "teleriot0"
	origin_tech = "materials=3;combat=4;engineering=4"
	slot_flags = null
	force = 3
	throwforce = 3
	throw_speed = 3
	throw_range = 4
	w_class = 3
	shieldhealth = 95
	var/active = FALSE

/obj/item/weapon/shield/riot/tele/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	if(active)
		return ..()
	return 0

/obj/item/weapon/shield/riot/tele/attack_self(mob/living/user)
	active = !active
	icon_state = "teleriot[active]"
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)

	if(active)
		force = 8
		throwforce = 5
		throw_speed = 2
		w_class = 4
		slot_flags = SLOT_BACK
		user << "<span class='notice'>You extend \the [src].</span>"
	else
		force = 3
		throwforce = 3
		throw_speed = 3
		w_class = 3
		slot_flags = null
		user << "<span class='notice'>[src] can now be concealed.</span>"
	add_fingerprint(user)


/obj/item/weapon/shield/broken
	name = "broken shield"
	desc = "Not much to salvage... If wanna look like a badass, hang it on your wall and say you shot Captain America."
	force = 2
	throwforce = 3
	throw_range = 5
	w_class = 3
	var/formershield

/obj/item/weapon/shield/broken/proc/generateshield(formershield)
	if(formershield)
		src.icon_state = "broken-[formershield]"
		src.item_state = "broken-[formershield]"
	playsound(src, "shatter", 70, 1)

/obj/item/weapon/shield/broken/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	return 0

#undef SHIELD_NORMAL
#undef SHIELD_CRACKED
#undef SHIELD_BREAKING