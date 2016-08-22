// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---
// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---
// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---

/obj/item/weapon/shuriken
	name = "yautja shuriken"
	desc = "A thrown Yautja weapon which is constructed with six retractable blades"
	icon_state = "dread_frisbee"
	item_state = "dread_frisbee"
	force = 12
	throwforce = 120
	throw_speed = 6
	w_class = 4
	embed_chance = 100
	embedded_fall_chance = 0

/obj/item/weapon/shuriken/attack_self(mob/user)
	if(icon_state == "dread_frisbee")
		if(!ispredator(user))
			user << "<span class='warning'>The damn things stuck!</span>"
			return

		icon_state = "dread_frisbee_on"
		item_state = "dread_frisbee_on"
		force = 12
		throwforce = 120
		throw_speed = 3
		w_class = 4
		embed_chance = 100
	else
		icon_state = "dread_frisbee"
		item_state = "dread_frisbee"
		force = 3
		throwforce = 30
		throw_speed = 2
		w_class = 1
		embed_chance = 0

/obj/item/weapon/shuriken/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		if(icon_state == "dread_frisbee_on")
			attack_self(user)

/obj/item/weapon/twohanded/spear/combistick
	name = "yautja combistick"
	desc = "The Combistick is telescopic, making it relatively small and easy to store when not in use \
	but extending to its full length when required in combat. It is made of incredibly light, sharp, thin \
	but strong material. It can be used both as a close-quarters hand-to-hand weapon and thrown like a spear"
	icon_state = "pred_spear_off"
	item_state = "pred_spear_off"
	force = 3
	w_class = 1
	slot_flags = SLOT_BELT
	force_unwielded = 3
	force_wielded = 7
	throwforce = 3
	throw_speed = 1

/obj/item/weapon/twohanded/spear/combistick/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		user.adjustBruteLoss(rand(3,9))
		user << "<span class='danger'>The spear expands as you pick it up and cuts into you! It'd be best to leave it alone.</span>"
		user.drop_item()

/obj/item/weapon/twohanded/spear/combistick/attack_self(mob/user)
	if(!ispredator(user))
		user << "<span class='alert'>You have no idea how to operate this...</span>"
		if(prob(99))
			return
	if(icon_state == "pred_spear_off")
		icon_state = "pred_spear_on"
		item_state = "pred_spear_on"
		force = 15
		w_class = 4
		slot_flags = SLOT_BACK
		force_unwielded = 20
		force_wielded = 40
		throwforce = 150
		throw_speed = 4
		embedded_impact_pain_multiplier = 3
	else
		icon_state = "pred_spear_off"
		item_state = "pred_spear_off"
		force = 3
		w_class = 1
		slot_flags = SLOT_BELT
		force_unwielded = 3
		force_wielded = 7
		throwforce = 3
		throw_speed = 1
		embedded_impact_pain_multiplier = 0




/obj/item/weapon/twohanded/spear/combistick/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first)
	if(!ispredator(thrower))
		audible_message("[src] flops mid-air from the incredibly weak throw!")
		return
	..()


// --- HELMET ---  --- HELMET ---  --- HELMET ---
// --- HELMET ---  --- HELMET ---  --- HELMET ---
// --- HELMET ---  --- HELMET ---  --- HELMET ---

/obj/item/clothing/head/helmet/space/hardsuit/predator
	name = "yautja bio-mask"
	desc = "A specialized mask incorporating a breathing apparatus and diagnostics. \
	It is composed of unknown materials and appears to be resistant to all forms of damage."
	icon_state = "predator-helmet"
	item_state = "predator-helmet"
	item_color = "pred"
	armor = list(melee = 45, bullet = 5, laser = 5, energy = 10, bomb = 5, bio = 100, rad = 75)
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	actions_types = list(/datum/action/item_action/toggle_helmet_light)


/obj/item/clothing/head/helmet/space/hardsuit/predator/attack_self(mob/user)
	if(!ispredator(user))
		return

	on = !on
	if(on)
		user.sight = SEE_MOBS
		user.see_invisible = SEE_INVISIBLE_MINIMUM
		blockTracking = 1
		user << "<span class='danger'>You activate your helmets thermal imaging and low-light amplification systems. This will also block tracking from potential enemy forces.</span>"

	else
		user.see_invisible = SEE_INVISIBLE_LIVING
		user.sight &= ~SEE_MOBS
		blockTracking = 0
		user << "<span class='danger'>You deactivate your helmets special functions. You are vunerable to tracking</span>"

// --- SUIT ---  --- SUIT ---  --- SUIT ---
// --- SUIT ---  --- SUIT ---  --- SUIT ---
// --- SUIT ---  --- SUIT ---  --- SUIT ---

/obj/item/clothing/suit/space/hardsuit/predator
	name = "yautja plate armour"
	desc = "A special multi-layer suit capable of resisting all forms of damage. \
	It is extremely light and is composed of unknown materials."
	icon_state = "hardsuit_pred"
	item_state = "hardsuit_pred"
	slowdown = 0
	armor = list(melee = 17, bullet = 10, laser = 5, energy = 10, bomb = 45, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/twohanded/spear/combistick, /obj/item/weapon/shuriken)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/predator

/obj/item/clothing/under/predator
	desc = "It's a Yautja Skinsuit capable of resisting small amounts of damage, \
	it seems to have attached wristblades which cannot be removed.."
	name = "yautja skinsuit"
	icon_state = "pred-armour"
	item_state = "pred-armour"
	armor = list(melee = 3, bullet = 3, laser = 0, energy = 3, bomb = 3, bio = 3, rad = 5)
	slowdown = -2
	has_sensor = 0
	random_sensor = 0
	can_adjust = 0
	actions_types = list(/datum/action/item_action/retractwristblades)


/datum/action/item_action/retractwristblades
	name = "Toggle Wristblades"


/obj/item/clothing/under/predator/attack_self(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		var/gethand = user.get_active_hand()
		if(gethand == src)
			return

		if(!gethand)
			var/SSHNG = get_turf(user.loc)
			var/obj/item/weapon/kitchen/knife/predator/PT = new /obj/item/weapon/kitchen/knife/predator(SSHNG)
			PT.owner = src
			L.put_in_active_hand(PT)
			user << "<span class='notice'>You retract your wrist blade!</span>"
		else
			user << "<span class='danger'>There is something in your hand! You cannot extend your blades.</span>"

/obj/item/weapon/kitchen/knife/predator
	name = "wristblade"
	desc = "The weapon of choice for Predators, and preferred use for close range combat fights. \
	Connected to their skinsuit, this weapon is regularly used to decapitate prey in order to store trophies."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "wristblade"
	item_state = "wristblade"
	flags = NODROP
	force = 20
	var/owner


/obj/item/weapon/kitchen/knife/predator/attack_self(mob/user)
	if(owner)
		user << "<span class='notice'>You retract your wrist blades!</span>"
		qdel(src)


/obj/item/weapon/kitchen/knife/predator/dropped()
	if(owner)
		owner = null
	if(flags & NODROP)
		flags &= ~NODROP

	..()

/obj/item/weapon/storage/belt/mining/yautija
	name = "yautija trophy sac"
	desc = "If you don't have the stomach... don't even fucking peek..."
	max_w_class = 5
	can_hold = list(/obj/item/bodypart/head)


/obj/item/clothing/shoes/predator
	name = "predator feet"
	desc = "these look really odd"
	icon_state = null
	item_state = null
	flags = NODROP | NOSLIP | ABSTRACT