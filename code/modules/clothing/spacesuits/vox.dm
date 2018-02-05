
/obj/item/clothing/suit/space/hardsuit/vox
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/restraints,/obj/item/weapon/tank)
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/vox

	species_restricted = list(VOX_SHAPED)
	species_fit = list(VOX_SHAPED)

/obj/item/clothing/suit/space/hardsuit/vox/New()
	jetpack = new /obj/item/weapon/tank/jetpack/suit(src)
	jetpack.gas_type = "n2"
	..()

/obj/item/clothing/head/helmet/space/hardsuit/vox
	actions_types = list()
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	visor_flags = STOPSPRESSUREDMAGE
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	
	species_restricted = list(VOX_SHAPED)
	species_fit = list(VOX_SHAPED)


/obj/item/clothing/suit/space/hardsuit/vox/pressure
	name = "alien pressure suit"
	icon_state = "vox-pressure"
	item_state = "vox-pressure"
	desc = "A huge, armored, pressurized suit, designed for distinctly nonhuman proportions."
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/vox/pressure

/obj/item/clothing/head/helmet/space/hardsuit/vox/pressure
	name = "alien helmet"
	icon_state = "vox-pressure"
	item_state = "vox-pressure"
	desc = "Hey, wasn't this a prop in \'The Abyss\'?"



/obj/item/clothing/suit/space/hardsuit/vox/carapace
	name = "alien carapace armor"
	desc = "An armored, segmented carapace with glowing purple lights. It looks pretty run-down."
	icon_state = "vox-carapace"
	item_state = "vox-carapace"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/vox/carapace

/obj/item/clothing/head/helmet/space/hardsuit/vox/carapace
	name = "alien visor"
	desc = "A glowing visor, perhaps stolen from a depressed Cylon."
	icon_state = "vox-carapace"
	item_state = "vox-carapace"



/obj/item/clothing/suit/space/hardsuit/vox/stealth
	name = "alien stealth suit"
	desc = "A sleek black suit. It seems to have a tail, and is very heavy."
	icon_state = "vox-stealth"
	item_state = "vox-stealth"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/vox/stealth

/obj/item/clothing/head/helmet/space/hardsuit/vox/stealth
	name = "alien stealth helmet"
	desc = "A smoothly contoured, matte-black alien helmet."
	icon_state = "vox-stealth"
	item_state = "vox-stealth"



/obj/item/clothing/suit/space/hardsuit/vox/medic
	name = "alien armor"
	desc = "An almost organic looking nonhuman pressure suit."
	icon_state = "vox-medic"
	item_state = "vox-medic"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/vox/medic

/obj/item/clothing/head/helmet/space/hardsuit/vox/medic
	name = "alien goggled helmet"
	desc = "An alien helmet with enormous goggled lenses."
	icon_state = "vox-medic"
	item_state = "vox-medic"