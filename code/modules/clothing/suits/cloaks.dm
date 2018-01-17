/obj/item/clothing/suit/hooded/cloak/drake
	name = "drake armour"
	icon_state = "dragon"
	desc = "A suit of armour fashioned from the remains of an ash drake. "
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/resonator, /obj/item/device/mining_scanner, /obj/item/device/t_scanner/adv_mining_scanner, /obj/item/weapon/gun/energy/kinetic_accelerator, /obj/item/weapon/pickaxe, /obj/item/weapon/twohanded/spear)
	armor = list(melee = 70, bullet = 30, laser = 50, energy = 40, bomb = 70, bio = 60, rad = 50)
	hooded = 1
	hoodtype = /obj/item/clothing/head/cloakhood/drake
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	unacidable = 1

/obj/item/clothing/head/cloakhood/drake
	name = "drake helm"
	icon_state = "dragon"
	desc = "The skull of a dragon."
	armor = list(melee = 70, bullet = 30, laser = 50, energy = 40, bomb = 70, bio = 60, rad = 50)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1