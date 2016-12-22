/obj/item/weapon/shuriken
	name = "yautja shuriken"
	desc = "An alien shruiken with strange markings drawn on the hilt of it."
	icon_state = "dread_frisbee"
	item_state = "dread_frisbee"
	force = 3
	throwforce = 5
	throw_speed = 2
	w_class = 1

/obj/item/weapon/shuriken/attack_self(mob/user)
	if(icon_state == "dread_frisbee")
		if(!ispredator(user))
			user << "<span class='warning'>It doesn't seem like the shurikens willing to open!</span>"
			return

		icon_state = "dread_frisbee_on"
		item_state = "dread_frisbee_on"
		force = 8
		throwforce = 45
		throw_speed = 7
		w_class = 4
		embed_chance = 100
	else
		icon_state = "dread_frisbee"
		item_state = "dread_frisbee"
		force = 3
		throwforce = 5
		throw_speed = 2
		w_class = 1
		embed_chance = 0

/obj/item/weapon/shuriken/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		if(icon_state == "dread_frisbee_on")
			attack_self(user)

/obj/item/weapon/shuriken/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>A thrown Yautja weapon which is constructed with six retractable blades.</span>"

/obj/item/weapon/twohanded/spear/combistick
	name = "yautja combistick"
	desc = "A robust comat stick which looks like it'd be extremely deadly in close quarters."
	icon_state = "pred_spear_off"
	item_state = "pred_spear_off"
	force = 3
	w_class = 1
	slot_flags = SLOT_BELT
	force_unwielded = 3
	force_wielded = 7
	throwforce = 3
	throw_speed = 1

/obj/item/weapon/twohanded/spear/combistick/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>The Combistick is telescopic, making it relatively small and easy to store when not in use \
	but extending to its full length when required in combat. It is made of incredibly light, sharp, thin \
	but strong material. It can be used both as a close-quarters hand-to-hand weapon usually when your primary \
	weapon is unavaiable. It is recommended to use this as a spear</span>"

/obj/item/weapon/twohanded/spear/combistick/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		if(icon_state == "pred_spear_on")
			attack_self(user)

/obj/item/weapon/twohanded/spear/combistick/attack_self(mob/user)
	if(!ispredator(user))
		user << "<span class='alert'>You have no idea how to operate this...</span>"
		if(prob(99))
			return
		else
			user << "<span class='alert'>[src] expands rapidly!</span>"

	if(icon_state == "pred_spear_off")
		icon_state = "pred_spear_on"
		item_state = "pred_spear_on"
		force = 15
		w_class = 5
		slot_flags = SLOT_BACK
		force_unwielded = 15
		force_wielded = 15
		throwforce = 18
		throw_speed = 7
		embedded_impact_pain_multiplier = 2
		embed_chance = 100
	else
		icon_state = "pred_spear_off"
		item_state = "pred_spear_off"
		force = 3
		w_class = 1
		slot_flags = SLOT_BELT
		force_unwielded = 3
		force_wielded = 3
		throwforce = 3
		throw_speed = 1
		embedded_impact_pain_multiplier = 1
		embed_chance = 0

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
		user << "<span class='danger'>You deactivate your helmets special functions. You are now vunerable to tracking.</span>"

/obj/item/clothing/suit/space/hardsuit/predator
	name = "yautja plate armour"
	desc = "A special multi-layer suit capable of resisting all forms of damage. \
	It is extremely light and is composed of unknown materials. Comes equipped with a plasma \
	gun attached to the back of the outer plate."
	icon_state = "predatorarmor"
	item_state = "predatorarmor"
	slowdown = 0
	armor = list(melee = 20, bullet = 5, laser = 30, energy = 10, bomb = 45, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/twohanded/spear/combistick, /obj/item/weapon/shuriken)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/predator
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	var/obj/item/skinsuit/subsuit

/obj/item/clothing/suit/space/hardsuit/predator/New()
	..()
	subsuit = new(src)

/obj/item/skinsuit
	desc = "It's a Yautja Skinsuit capable of resisting small amounts of damage, \
	it appears to be connected to a wrist plate which contains retractable wristblades."
	name = "yautja skinsuit"
	icon_state = "pred-armour"
	item_state = "pred-armour"
	actions_types = list(/datum/action/item_action/retractwristblades)


/datum/action/item_action/retractwristblades
	name = "Toggle Wristblades"


/obj/item/skinsuit/attack_self(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		var/gethand = user.get_active_hand()
		if(gethand == src)
			return

		if(!gethand)
			var/stealthed = get_turf(user.loc)
			var/obj/item/weapon/kitchen/knife/predator/PT = new /obj/item/weapon/kitchen/knife/predator(stealthed)
			PT.owner = src
			L.put_in_active_hand(PT)
			user << "<span class='notice'>You retract your wrist blade!</span>"

		else if(istype(gethand, /obj/item/weapon/kitchen/knife/predator))
			var/obj/item/weapon/kitchen/knife/predator/wristblade = gethand
			if(wristblade.owner == src)
				qdel(wristblade)
				user << "<span class='notice'>You retract your wristblade!</span>"

		else
			user << "<span class='danger'>There is something in your hand! You cannot extend your blades.</span>"

/obj/item/weapon/kitchen/knife/predator
	name = "wristblade"
	desc = "An extremely sharp alien blade that illuminates in the light."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "wristblade"
	item_state = "wristblade"
	flags = NODROP
	force = 20
	sharpness = IS_SHARP
	var/owner


/obj/item/weapon/kitchen/knife/predator/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>The weapon of choice for Predators, and preferred use for close range combat fights. \
	Connected to their skinsuit, this weapon is regularly used to decapitate prey dead or alive</span>"

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
	desc = "If you don't have the stomach for it don't peek."
	max_w_class = 5
	storage_slots = 7
	can_hold = list(/obj/item/bodypart/head)


/obj/item/clothing/shoes/predator
	name = "predator feet"
	desc = "these look really odd... wait, how the hell are you reading this?"
	icon_state = null
	item_state = null
	flags = NODROP | NOSLIP | ABSTRACT