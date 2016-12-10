//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0.01
	flags = THICKMATERIAL
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	unacidable = 1
	burn_state = FIRE_PROOF
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	item_state = "bio_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	allowed = list(/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/pen,/obj/item/device/flashlight/pen, /obj/item/weapon/reagent_containers/dropper, /obj/item/weapon/reagent_containers/syringe, /obj/item/weapon/reagent_containers/hypospray)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	strip_delay = 70
	put_on_delay = 70
	unacidable = 1
	burn_state = FIRE_PROOF
	species_fit = list("Vox")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/suit.dmi'
		)

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"


//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"


//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	armor = list(melee = 25, bullet = 15, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security
	armor = list(melee = 25, bullet = 15, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	icon_state = "bio_security"


//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"


//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"


//CMO's biosuit, blue stripe
/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"


//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	item_state = "bio_suit"
	strip_delay = 40
	put_on_delay = 20
	species_fit = null
	sprite_sheets = null
