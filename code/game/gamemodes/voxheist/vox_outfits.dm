
// Outfits for Vox Raiders.

/datum/outfit/voxraider
	name = "Vox Raider - Basic"

	uniform 	= /obj/item/clothing/under/vox/vox_robes
	
	id 			= /obj/item/weapon/card/id/syndicate/vox
	ears		= /obj/item/device/radio/headset/raider
	gloves 		= /obj/item/clothing/gloves/yellow/vox
	back		= /obj/item/weapon/storage/backpack
	shoes 		= /obj/item/clothing/shoes/magboots/vox
	suit_store	= /obj/item/weapon/tank/internals/nitrogen
	mask 		= /obj/item/clothing/mask/breath/vox
	r_pocket 	= /obj/item/device/flashlight

/datum/outfit/voxraider/post_equip(mob/living/carbon/human/H)
	var/obj/item/clothing/suit/space/hardsuit/vox/suit = H.wear_suit
	suit.ToggleHelmet()

	var/obj/item/weapon/tank/internals/t = H.s_store
	t.toggle_internals(H)

	var/obj/item/weapon/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.assignment = "Trader"
	W.update_label()

	H.update_icons()


datum/outfit/voxraider/raider
	name = "Vox Raider - Raider"

	suit 		= /obj/item/clothing/suit/space/hardsuit/vox/carapace

	glasses 	= /obj/item/clothing/glasses/thermal/monocle
	belt 		= /obj/item/weapon/melee/classic_baton/telescopic
	l_pocket 	= /obj/item/device/chameleon
	l_hand 		= /obj/item/weapon/gun/crossbow
	r_hand 		= /obj/item/stack/rods
	backpack_contents = list(/obj/item/weapon/storage/box/handcuffs = 1,\
		/obj/item/weapon/storage/box/flashbangs = 1)

/datum/outfit/voxraider/raider/post_equip(mob/living/carbon/human/H)
	var/obj/item/weapon/gun/crossbow/C = H.l_hand
	C.cell = new /obj/item/weapon/stock_parts/cell(C)
	C.cell.charge = 1000

	var/obj/item/stack/rods/R = H.r_hand
	R.amount = 20
	R.update_icon()

	..()


/datum/outfit/voxraider/engineer
	name = "Vox Raider - Engineer"

	suit 		= /obj/item/clothing/suit/space/hardsuit/vox/pressure

	belt 		= /obj/item/weapon/storage/belt/utility/full
	glasses		= /obj/item/clothing/glasses/meson/night
	l_hand		= /obj/item/weapon/rcd/combat
	r_hand		= /obj/item/weapon/storage/box/emps
	backpack_contents = list(/obj/item/weapon/storage/box/metalfoam = 1,\
		/obj/item/weapon/rcd_ammo/large = 2)


/datum/outfit/voxraider/saboteur
	name = "Vox Raider - Saboteur"

	suit 		= /obj/item/clothing/suit/space/hardsuit/vox/stealth

	glasses 	= /obj/item/clothing/glasses/thermal/monocle
	belt 		= /obj/item/weapon/storage/belt/utility/full
	l_pocket 	= /obj/item/weapon/card/emag/vox
	r_hand		= /obj/item/device/multitool/ai_detect
	backpack_contents = list(/obj/item/weapon/storage/box/handcuffs = 1,\
		/obj/item/weapon/aiModule/syndicate = 1,\
		///obj/item/weapon/aiModule/supplied/oxygen = 1,\	// Too much fun :(
		/obj/item/device/sbeacondrop/powersink = 1,\
		/obj/item/weapon/c4 = 2)
		///obj/item/device/doorCharge = 2)		// These kill people, that's mean


/datum/outfit/voxraider/medic
	name = "Vox Raider - Medic"

	suit 		= /obj/item/clothing/suit/space/hardsuit/vox/medic
 
	belt 		= /obj/item/weapon/defibrillator/compact/combat/loaded
	glasses 	= /obj/item/clothing/glasses/hud/health
	l_pocket 	= /obj/item/weapon/circular_saw
	l_hand		= /obj/item/weapon/gun/medbeam
	r_hand		= /obj/item/weapon/gun/dartgun/vox/medical
	backpack_contents = list(/obj/item/weapon/storage/firstaid/regular = 1,\
		/obj/item/weapon/dart_cartridge = 3)