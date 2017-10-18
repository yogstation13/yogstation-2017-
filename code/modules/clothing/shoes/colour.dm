/obj/item/clothing/shoes/sneakers

/obj/item/clothing/shoes/sneakers/black
	name = "black shoes"
	icon_state = "black"
	item_color = "black"
	desc = "A pair of black shoes."

	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/sneakers/black/redcoat
	item_color = "redcoat"	//Exists for washing machines. Is not different from black shoes in any way.

/obj/item/clothing/shoes/sneakers/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"
	item_color = "brown"

/obj/item/clothing/shoes/sneakers/brown/captain
	item_color = "captain"	//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/brown/hop
	item_color = "hop"		//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/brown/ce
	item_color = "chief"		//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/brown/rd
	item_color = "director"	//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/brown/cmo
	item_color = "medical"	//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/brown/qm
	item_color = "cargo"		//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/blue
	name = "blue shoes"
	icon_state = "blue"
	item_color = "blue"

/obj/item/clothing/shoes/sneakers/green
	name = "green shoes"
	icon_state = "green"
	item_color = "green"

/obj/item/clothing/shoes/sneakers/yellow
	name = "yellow shoes"
	icon_state = "yellow"
	item_color = "yellow"

/obj/item/clothing/shoes/sneakers/purple
	name = "purple shoes"
	icon_state = "purple"
	item_color = "purple"

/obj/item/clothing/shoes/sneakers/brown
	name = "brown shoes"
	icon_state = "brown"
	item_color = "brown"

/obj/item/clothing/shoes/sneakers/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"
	item_color = "red"

/obj/item/clothing/shoes/sneakers/white
	name = "white shoes"
	icon_state = "white"
	permeability_coefficient = 0.01
	item_color = "white"

/obj/item/clothing/shoes/sneakers/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rain_bow"
	item_color = "rainbow"

/obj/item/clothing/shoes/sneakers/orange
	name = "orange shoes"
	icon_state = "orange"
	item_color = "orange"


/obj/item/clothing/shoes/sneakers/yeezy
	name = "oreo trainers"
	icon_state = "yeezy_oreo"
	item_color = "yeezy_oreo"
	desc = "A pair of shoes with a white accent, these shoes are worth more than your salary."

/obj/item/clothing/shoes/sneakers/yeezy/orange
	name = "flashy trainers"
	icon_state = "yeezy_orange"
	item_color = "yeezy_orange"
	desc = "Deadstock. How you got a pair of these is beyond me..."


/obj/item/clothing/shoes/sneakers/yeezy/black
	name = "pirate black trainers"
	icon_state = "yeezy_black"
	item_color = "yeezy_black"
	desc = "Whilst still uncomfortably expensive, these black lowkey trainers make for a great entry into the sneaker game."


/obj/item/clothing/shoes/sneakers/yeezy/zebra
	name = "black and white striped trainers"
	icon_state = "yeezy_white"
	item_color = "yeezy_white"
	desc = "They're SO BRIGHT!!!! AAAAHHHHHHH"


/obj/item/clothing/shoes/sneakers/yeezy/green
	name = "khaki trainers"
	icon_state = "yeezy_green"
	item_color = "yeezy_green"
	desc = "Slightly more practical trainers that don't glow in the dark"

/obj/item/clothing/shoes/sneakers/yeezy/red
	name = "black and red trainers"
	icon_state = "yeezy_red"
	item_color = "yeezy_red"
	desc = "Who said that syndicate operatives only wear combat boots?"


/obj/item/clothing/shoes/sneakers/nmd
	name = "primeknit trainers"
	icon_state = "nmd_pk"
	item_color = "nmd_pk"
	desc = "Stylish running shoes. The comfy soles give you a spring in your step."

/obj/item/clothing/shoes/sneakers/nmd/collab
	name = "Nanotrasen collab trainers"
	icon_state = "nmd_nt"
	item_color = "nmd_nt"
	desc = "Very stylish shoes produced by nanotrasen in a collaboration with galactic sneakers inc."



/obj/item/clothing/shoes/sneakers/orange/attack_self(mob/user)
	if (src.chained)
		src.chained = null
		src.slowdown = SHOES_SLOWDOWN
		new /obj/item/weapon/restraints/handcuffs( user.loc )
		src.icon_state = "orange"
	return

/obj/item/clothing/shoes/sneakers/orange/attackby(obj/H, loc, params)
	..()
	if ((istype(H, /obj/item/weapon/restraints/handcuffs) && !( src.chained )))
		//H = null
		if (src.icon_state != "orange") return
		if(istype(H, /obj/item/weapon/restraints/handcuffs/cable))
			return 0
		qdel(H)
		src.chained = 1
		src.slowdown = 15
		src.icon_state = "orange1"
	return

/obj/item/clothing/shoes/sneakers/orange/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/C = user
		if(C.shoes == src && src.chained == 1)
			to_chat(user, "<span class='warning'>You need help taking these off!</span>")
			return
	..()
