/obj/item/clothing/suit/space/hardsuit/predator
	name = "yautja plate armour"
	desc = "A special multi-layer suit capable of resisting all forms of damage. \
	It is extremely light and is composed of unknown materials. Comes equipped with a plasma \
	gun attached to the back of the outer plate."
	icon_state = "predatorarmor"
	item_state = "predatorarmor"
	slowdown = 0
	armor = list(melee = 10, bullet = 5, laser = 30, energy = 10, bomb = 45, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/twohanded/spear/combistick, /obj/item/weapon/shuriken)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/predator
	actions_types = list(/datum/action/item_action/retractwristblades, /datum/action/item_action/toggle_helmet)
	var/obj/item/heartsensor/HS // TO DO : merge this into an action button.

/obj/item/clothing/suit/space/hardsuit/predator/New()
	..()
	HS = new(src)

/obj/item/clothing/suit/space/hardsuit/predator/equipped(mob/user)
	..()
	if(user)
		for(var/datum/action/X in HS.actions)
			X.Grant(user)

/obj/item/clothing/suit/space/hardsuit/predator/unequipped(mob/user)
	..()
	if(user)
		for(var/datum/action/X in HS.actions)
			X.Remove(user)

/obj/item/clothing/suit/space/hardsuit/predator/dropped()
	..()
	for(var/datum/action/X in src.contents)
		X.Remove(X.owner)

/obj/item/clothing/suit/space/hardsuit/predator/pickup(mob/living/carbon/user)
	..()
	for(var/datum/action/X in src.contents)
		X.Remove(user)
