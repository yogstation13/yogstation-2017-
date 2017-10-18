// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---
// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---
// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---

/obj/item/weapon/shuriken
	name = "yautja shuriken"
	desc = "A thrown Yautja weapon which is constructed with six retractable blades"
	//icon = 'icons/mob/predators.dmi'
	icon_state = "pred_disk_closed"
	item_state = "pred_disk_closed"
	force = 12
	throwforce = 120
	throw_speed = 6
	embedded_pain_multiplier = 32
	w_class = 2
	embed_chance = 100
	embedded_fall_chance = 0

/obj/item/weapon/shuriken/attack_self(mob/user)
	if(icon_state == "pred_disk_closed")
		icon_state = "pred_disk_open"
		item_state = "pred_disk_open"
		force = 12
		throwforce = 120
		slot_flags = SLOT_BACK
		throw_speed = 3
		embedded_pain_multiplier = 32
		w_class = 2
		embed_chance = 100
	else
		icon_state = "pred_disk_closed"
		item_state = "pred_disk_closed"
		force = 3
		throwforce = 30
		throw_speed = 2
		slot_flags = SLOT_BELT
		embedded_pain_multiplier = 0
		w_class = 1
		embed_chance = 0

/obj/item/weapon/shuriken/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		user.adjustBruteLoss(rand(3,9))
		to_chat(user, "<span class='danger'>The spear expands as you pick it up and cuts into you! It'd be best to leave it alone.</span>")
		user.drop_item()

/obj/item/weapon/twohanded/spear/combistick
	name = "yautja combistick"
	desc = "The Combistick is telescopic, making it relatively small and easy to store when not in use but extending to its full length when required in combat. It is made of incredibly light, sharp, thin but strong material. It can be used both as a close-quarters hand-to-hand weapon and thrown like a spear"
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

/obj/item/weapon/twohanded/spear/combistick/pickup(mob/living/user)
	..()
	if(!ispredator(user))
		user.adjustBruteLoss(rand(3,9))
		to_chat(user, "<span class='danger'>The spear expands as you pick it up and cuts into you! It'd be best to leave it alone.</span>")
		user.drop_item()

/obj/item/weapon/twohanded/spear/combistick/attack_self(mob/user)
	if(!ispredator(user))
		to_chat(user, "<span class='alert'>You have no idea how to operate this...</span>")
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
	desc = "A specialized mask incorporating a breathing apparatus and diagnostics. It is composed of unknown materials and appears to be resistant to all forms of damage."
	//icon = 'icons/mob/predators.dmi'
	icon_state = "hardsuit0-pred"
	item_state = "hardsuit0-pred"
	armor = list(melee = 45, bullet = 5, laser = 5, energy = 10, bomb = 5, bio = 100, rad = 75)
	brightness_on = 0 // a predator remains undetected.
	on = 0
	blockTracking = 1 // via the last comment
	item_color = "pred"
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
		to_chat(user, "<span class='danger'>You activate your helmets thermal imaging and low-light amplification systems</span>")

	else
		user.see_invisible = SEE_INVISIBLE_LIVING
		user.sight &= ~SEE_MOBS
		to_chat(user, "<span class='danger'>You deactivate your helmets functions.</span>")

// --- SUIT ---  --- SUIT ---  --- SUIT ---
// --- SUIT ---  --- SUIT ---  --- SUIT ---
// --- SUIT ---  --- SUIT ---  --- SUIT ---

/obj/item/clothing/suit/space/hardsuit/predator
	name = "yautja plate armour"
	desc = "A special multi-layer suit capable of resisting all forms of damage. It is extremely light and is composed of unknown materials."
	icon_state = "hardsuit_pred"
	item_state = "hardsuit_pred"
	slowdown = 0
	armor = list(melee = 17, bullet = 10, laser = 5, energy = 10, bomb = 45, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/twohanded/spear/combistick, /obj/item/weapon/shuriken)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/predator
	flags = NODROP

/obj/item/clothing/under/predator
	desc = "It's a Yautja Skinsuit capable of resisting small amounts of damage, it has multiple slots for storing equipment."
	name = "yautja skinsuit"
	icon_state = "pred"
	item_state = "pred"
	armor = list(melee = 3, bullet = 3, laser = 0, energy = 3, bomb = 3, bio = 3, rad = 5)
	has_sensor = 0
	random_sensor = 0
	can_adjust = 0


// --- GLOVES ---  --- GLOVES ---  --- GLOVES ---
// --- GLOVES ---  --- GLOVES ---  --- GLOVES ---
// --- GLOVES ---  --- GLOVES ---  --- GLOVES ---



/obj/item/clothing/gloves/combat/predator
	name = "yautja gloves"
	desc = "Gloves made out of very special fabric that prevents the predator from being shocked and prevents them from being burnt, along comes with retractable wristblades."
	var/retracted = 0 // controls whether call_blades() needs to recall the blades or not.
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/gloves/combat/predator/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H.l_hand, src) || istype(H.r_hand, src))
		..()
		return
	call_blades(user)

/obj/item/clothing/gloves/combat/predator/proc/call_blades(mob/user)
	var/gethand = user.get_active_hand()
	if(!gethand)
		var/SSHNG = get_turf(user.loc)
		var/obj/item/weapon/kitchen/knife/predator/glove = new /obj/item/weapon/kitchen/knife/predator(SSHNG)
		glove.wrist = src
		user.put_in_active_hand(glove)
		to_chat(user, "<span class='notice'>You retract your wrist blade! (Use Z to retract the wristblades a second time.)</span>")
	else
		to_chat(user, "<span class='danger'>There's already something in your hand!</span>")

/obj/item/clothing/gloves/combat/predator/attackby(obj/item/I, mob/living/user, params)
	..()
	if(istype(I, /obj/item/weapon/kitchen/knife/predator))
		var/obj/item/weapon/kitchen/knife/predator/PK = I
		if(PK.wrist)
			if(PK.wrist == src)
				to_chat(user, "<span class='notice'>You retract your wrist blade!</span>")
				qdel(I)

/obj/item/weapon/kitchen/knife/predator
	name = "wristblade"
	desc = "The weapon of choice for Predators, and preferred use for close range combat fights. Easily retractable, and comes in pairs of two for each wrist."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	flags = NODROP
	force = 20
	var/wrist = null // this will store which gloves the wristblades belong to.


/obj/item/weapon/kitchen/knife/predator/attack_self(mob/user)
	if(wrist)
		to_chat(user, "<span class='notice'>You retract your wrist blades!</span>")
		qdel(src)
	else
		..()

/obj/item/weapon/kitchen/knife/predator/process()
	..()
	if(!wrist)
		qdel(src)