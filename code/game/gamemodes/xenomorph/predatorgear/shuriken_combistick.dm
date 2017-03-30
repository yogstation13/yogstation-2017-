// TO DO: Boomerang effect?

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
	if(!ispredator(user))
		user << "<span class='warning'>It doesn't seem like the shurikens willing to open!</span>"
		return

	if(icon_state == "dread_frisbee")
		enable()
	else
		disable()

/obj/item/weapon/shuriken/proc/enable()
	icon_state = "dread_frisbee_on"
	item_state = "dread_frisbee_on"
	force = 8
	throwforce = 45
	throw_speed = 10
	w_class = 4
	embed_chance = 100
	throw_range = 28

/obj/item/weapon/shuriken/proc/disable()
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
			disable()

/obj/item/weapon/shuriken/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>A thrown Yautja weapon which is constructed with six retractable blades. It becomes a powerful device when used in conjunction with a scope.</span>"
#define COMBISTICK_CD 50 // 5 seconds.

/obj/item/weapon/twohanded/spear/combistick
	name = "yautja combistick"
	desc = "A robust comat stick which looks like it'd be extremely deadly in close quarters."
	icon_state = "pred_spear_off"
	item_state = "pred_spear_off"
	force = 3
	w_class = 1
	slot_flags = SLOT_BELT
	flags = HANDSLOW
	force_unwielded = 3
	force_wielded = 7
	throwforce = 3
	throw_speed = 1
	var/cd

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
			disarmspear()

/obj/item/weapon/twohanded/spear/combistick/attack_self(mob/user)
	if(!ispredator(user))
		user << "<span class='alert'>You don't know how to use this...</span>"
		if(prob(99))
			return
		else
			user << "<span class='alert'>[src] expands rapidly! It's a miracle!</span>"

	if(cd)
		if(cd > world.time)
			user << "<span class='alert'>[src] isn't ready.</span>"
			return
		else
			cd = world.time + COMBISTICK_CD

	if(icon_state == "pred_spear_off")
		expandspear()
	else
		disarmspear()

/obj/item/weapon/twohanded/spear/combistick/proc/expandspear()
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
	slowdown = 2
	block_chance = 90


/obj/item/weapon/twohanded/spear/combistick/proc/disarmspear()
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
	block_chance = 0