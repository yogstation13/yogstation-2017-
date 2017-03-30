/datum/action/item_action/toggle_yautja_biomask
	name = "Toggle BioMask Enhancement"
	button_icon_state = "thermal-off"

/obj/item/clothing/head/helmet/space/hardsuit/predator/AltClick()
	if(tightenedscope)
		tightenedscope.AltClick(usr)

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
	on = FALSE
	var/obj/item/scope/security/yautija/tightenedscope

/obj/item/clothing/head/helmet/space/hardsuit/predator/New()
	..()
	tightenedscope = new(src)
	var/datum/action/item_action/toggle_scope_zoom/zoomd = new /datum/action/item_action/toggle_scope_zoom(src)
	zoomd.scope = tightenedscope

/obj/item/clothing/head/helmet/space/hardsuit/predator/Destroy()
	qdel(tightenedscope) // safety check.
	..()

/obj/item/clothing/head/helmet/space/hardsuit/predator/attack_self(mob/user)
	if(!ispredator(user))
		return

	on = !on

	if(on)
		user.sight = SEE_MOBS
		user.see_invisible = SEE_INVISIBLE_MINIMUM
		blockTracking = 1
		user << "<span class='danger'>You activate your helmets thermal imaging and low-light amplification systems. This will also block tracking from potential enemy forces.</span>"
		for(var/datum/action/item_action/toggle_helmet_light/THL in src)
			THL.button_icon_state = "thermal-on"
			THL.UpdateButtonIcon()

	else
		user.see_invisible = SEE_INVISIBLE_LIVING
		user.sight &= ~SEE_MOBS
		blockTracking = 0
		user << "<span class='danger'>You deactivate your helmets special functions. You are now vunerable to tracking.</span>"
		for(var/datum/action/item_action/toggle_helmet_light/THL in src)
			THL.button_icon_state = "thermal-off"
			THL.UpdateButtonIcon()