//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/neck/cloak
	name = "brown cloak"
	desc = "Also known as a cape."
	icon_state = "qmcloak"
	item_state = "qmcloak"
	w_class = 2
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/head/cloakhood
	name = "cloak hood"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "golhood"
	desc = "A hood for a cloak"
	body_parts_covered = HEAD
	flags = NODROP
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/cloak/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling themself with [src]! It looks like they're trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/clothing/neck/cloak/hos
	name = "head of security's cloak"
	desc = "Worn by Securistan, ruling the station with an iron fist. It's slightly armored."
	icon_state = "hoscloak"
	item_state = "hoscloak"

/obj/item/clothing/neck/cloak/qm
	name = "quartermaster's cloak"
	desc = "Worn by Cargonia, supplying the station with the necessary tools for survival."

/obj/item/clothing/neck/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "Worn by Meditopia, the valiant men and women keeping pestilence at bay. It's slightly shielded from contaminants."
	icon_state = "cmocloak"
	item_state = "cmocloak"

/obj/item/clothing/neck/cloak/ce
	name = "chief engineer's cloak"
	desc = "Worn by Engitopia, wielders of an unlimited power. It's slightly shielded against radiation."
	icon_state = "cecloak"
	item_state = "cecloak"

/obj/item/clothing/neck/cloak/rd
	name = "research director's cloak."
	desc = "Worn by Sciencia, thaumaturges and researchers of the universe. It's slightly shielded from contaminants."
	icon_state = "rdcloak"
	item_state = "rdcloak"

/obj/item/clothing/neck/cloak/cap
	name = "captain's cloak"
	desc = "Worn by the commander of Space Station 13."
	icon_state = "capcloak"
	item_state = "capcloak"