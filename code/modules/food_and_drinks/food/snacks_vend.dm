////////////////////////////////////////////SNACKS FROM VENDING MACHINES////////////////////////////////////////////
//in other words: junk food
//don't even bother looking for recipes for these

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 25
	filling_color = "#D2691E"
	foodtype = JUNKFOOD

/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 25
	filling_color = "#8B0000"
	requires_opening = TRUE
	open = FALSE
	foodtype = JUNKFOOD | MEAT

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 1
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 20
	filling_color = "#FFD700"
	requires_opening = TRUE
	open = FALSE
	foodtype = JUNKFOOD | FRIED

/obj/item/weapon/reagent_containers/food/snacks/chips/attack(mob/M, mob/user)
	if(ishuman(M))
		if(!open)
			user << "<span class='warning'>You haven't opened the bag yet!</span>"
			return
	return ..()

/obj/item/weapon/reagent_containers/food/snacks/attack_self(mob/user)
	if(requires_opening)
		if(!open)
			visible_message("<span class='notice'>[user] opens up a bag of [src].</span>",\
							"<span class='notice'>[user] opens up a bag of [src].</span>")
			playsound(loc, 'sound/effects/openingbag.ogg', 100, 1)
			open = TRUE

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	name = "4no raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	list_reagents = list("nutriment" = 2, "sugar" = 4)
	junkiness = 25
	filling_color = "#8B0000"
	foodtype = JUNKFOOD | FRUIT

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	name = "space twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer than you will."
	list_reagents = list("sugar" = 4)
	junkiness = 25
	filling_color = "#FFD700"
	foodtype = JUNKFOOD | GRAIN

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	name = "cheesie honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth."
	icon_state = "cheesie_honkers"
	trash = /obj/item/trash/cheesie
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 25
	filling_color = "#FFD700"
	requires_opening = TRUE
	open = FALSE
	foodtype = JUNKFOOD | DAIRY

/obj/item/weapon/reagent_containers/food/snacks/syndicake
	name = "syndi-cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	trash = /obj/item/trash/syndi_cakes
	list_reagents = list("nutriment" = 4, "doctorsdelight" = 5)
	filling_color = "#F5F5DC"
	foodtype = GRAIN | FRUIT | VEGETABLES

/obj/item/weapon/reagent_containers/food/snacks/toritose
	name = "toritos"
	desc = "An elegant snack for a civilized time. Be careful however, for the snack can become incredibly salty. Hopefully stands on it's own in the market."
	icon_state = "toritose"
	trash = /obj/item/trash/toritose
	list_reagents = list("nutriment" = 1, "sugar" = 1, "sodiumchloride" = 5)
	junkiness = 21
	filling_color = "#FF0000"
	requires_opening = TRUE
	open = FALSE
	foodtype = JUNKFOOD | GRAIN | FRIED

/obj/item/weapon/reagent_containers/food/snacks/borer
	name = "borer yummies"
	desc = "So good they'll squeeze your brains out!"
	icon_state = "chips"
	bitesize = 2
	list_reagents = list("nutriment" = 1, "sugar" = 2)
	junkiness = 12
	foodtype = JUNKFOOD | FRIED
