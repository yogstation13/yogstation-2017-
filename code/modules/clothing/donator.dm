// HEAD --- HEAD --- HEAD

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A nice comfy beanie hat. Very stylish, and very warm."
	icon_state = "beanie"
	item_state = "beanie"

/obj/item/clothing/head/bike
	name = "bike helmet"
	desc = "A bike helmet. Although it looks cool, it is made from recycled materials and is extremely flimsy. You can plainly see the face of the wearer through the darkened visor."
	icon_state = "bike"
	item_state = "bike"

/obj/item/clothing/head/hardsuit_helm_clown
	name = "clown hardsuit helm"
	desc = "An incredibly flimsy helm made to look like a hardsuit helm. You can plainly see the face of the wearer through the visor."
	icon_state = "hardsuit_helm_clown"
	item_state = "hardsuit_helm_clown"

/obj/item/clothing/head/det_hat/cowboy/sheriff
	name = "sheriff cowboy hat"
	desc = "A sheriffs hat. YEEEEEEEEEEEEEEEEEEEEEEEEEEEEHAWWWWW! This gives you as much authority as your local officer ... in your head."
	icon_state = "cowboy_sheriff"
	item_state = "cowboy_sheriff"

/obj/item/clothing/head/crusader
	name = "crusader helmet"
	desc = "A thin metal crusader helmet. It looks like it wouldn't take much of a beating."
	icon_state = "crusader"
	item_state = "crusader"

/obj/item/clothing/head/det_hat/cowboy
	name = "cowboy hat"
	desc = "A cowboy hat. YEEEHAWWWWW. Whoo! Yeah!"
	icon_state = "cowboy_hat"
	item_state = "cowboy_hat"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	candy_cooldown = 700

/obj/item/clothing/head/dallas
	name = "dallas hat"
	desc = "A patriotic hat, with a clipping signed Yogstation."
	icon_state = "dallas"
	item_state = "dallas"

/obj/item/clothing/head/drinking_hat
	name = "drinking hat"
	desc = "A utilitarian drinking hat. Unfortunately, it doesn't support alcoholic drinks."
	icon_state = "drinking_hat"
	item_state = "drinking_hat"
	var/obj/item/weapon/reagent_containers/food/drinks/soda_cans/can_one = null
	var/obj/item/weapon/reagent_containers/food/drinks/soda_cans/can_two = null
	actions_types = list(/datum/action/item_action/drinkinghat)

/obj/item/clothing/head/drinking_hat/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/reagent_containers/food/drinks/soda_cans))
		var/obj/item/weapon/reagent_containers/food/drinks/soda_cans/SC = I
		if(SC.cracked)
			user << "<span class='notice'>The soda can has already been opened!</span>"
			return

		if(can_one && can_two)
			user << "<span class='notice'>[src] is full!</span>"
			return

		if(!user.drop_item())
			return

		if(!can_one)
			can_one = I
			I.loc = src
			return

		if(!can_two)
			can_two = I
			I.loc = src
			return

	else
		..()

/datum/action/item_action/drinkinghat
	name = "Drink Through Straws"


/obj/item/clothing/head/drinking_hat/attack_self(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.get_active_hand() == src)
			if(can_one)
				can_one.loc = get_turf(user)
				can_one = null

			if(can_two)
				can_two.loc = get_turf(user)
				can_two = null

			user << "<span class='notice'>You empty out your drinking hat.</span>"
			return

	if(!can_one && !can_two)
		user << "<span class='notice'>Your hat isn't carrying any soda cans!</span>"
		return

	if(can_one)
		if(!can_one.cracked)
			can_one.cracked = TRUE
		can_one.attack(user, user)
		user.visible_message("<span class='notice'>[user] drinks through the first straw connected to [src]!</span>", "<span class='notice'>You drink through [src]'s first straw.</span>")

	if(can_two)
		if(!can_two.cracked)
			can_two.cracked = TRUE
		can_two.attack(user, user)
		user.visible_message("<span class='notice'>[user] drinks through the second straw connected to [src]!</span>", "<span class='notice'>You drink through [src]'s second straw.</span>")

/obj/item/clothing/head/microwave
	name = "microwave hat"
	desc = "A microwave hat. Luckily the harmful components were removed but, really with these things and Nanotrasen it's a 50/50 chance."
	icon_state = "microwave"
	item_state = "microwave"


/obj/item/clothing/head/microwave/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting their head inside of [src] and messing with the buttons! It looks like they're trying to kill themself!</span>")
	user.emote("scream")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/bodypart/head/head in H.bodyparts)
			head.burn_dam += 200
			playsound(loc, 'sound/weapons/sear.ogg', 50, 1)

		H.apply_damages(burn=500, def_zone = "head")

	spawn(20)
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		qdel(src)
	return (FIRELOSS)

/obj/item/clothing/head/sith_hood
	name = "sith hood"
	desc = "A sith hood, unfortunately it doesn't have cookies."
	icon_state = "sith_hood"
	item_state = "sith_hood"

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A turban."
	icon_state = "turban"
	item_state = "turban"


// SUIT -- SUIT -- SUIT

/obj/item/clothing/suit/cloak/sith_cloak
	name = "sith cloak"
	desc = "A sith cloak, while stylishly black and makes you feel like an emperor it offers no additional properties of the Robust."
	icon_state = "sith_cloak"
	item_state = "sith_cloak"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING

/obj/item/clothing/suit/armor/hardsuit_clown
	name = "clown hardsuit"
	desc = "A hardsuit... anything but."
	icon_state = "hardsuit_clown"
	item_state = "hardsuit_clown"

/obj/item/clothing/suit/armor/hardsuit_clown/hit_reaction()
	playsound(loc, 'sound/items/bikehorn.ogg', 50, 1, -1)
	return 0

// OUTFIT -- OUTFIT -- OUTFIT

/obj/item/clothing/under/sith_suit
	name = "sith suit"
	desc = "It was your destiny to look upon this suit, says the writing on the side."
	icon_state = "sith_suit"
	item_state = "sith_suit"
