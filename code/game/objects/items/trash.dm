//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/janitor.dmi'
	desc = "This is rubbish."
	w_class = 1
	burn_state = FLAMMABLE

/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state= "4no_raisins"

/obj/item/trash/candy
	name = "candy"
	icon_state= "candy"

/obj/item/trash/cheesie
	name = "cheesie honkers"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "chips"
	icon_state = "chips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/syndi_cakes
	name = "syndi-cakes"
	icon_state = "syndi_cakes"

/obj/item/trash/waffles
	name = "waffles tray"
	icon_state = "waffles"

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"
	burn_state = FIRE_PROOF

/obj/item/trash/pistachios
	name = "pistachios pack"
	icon_state = "pistachios_pack"

/obj/item/trash/semki
	name = "semki pack"
	icon_state = "semki_pack"

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	burn_state = FIRE_PROOF

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

/obj/item/trash/can
	name = "crushed can"
	icon_state = "cola"
	burn_state = FIRE_PROOF
/obj/item/trash/attack(mob/M, mob/living/user)
	return

/obj/item/trash/toritose
	name = "toritos"
	icon_state = "toritose"

/obj/item/trash/coal
	name = "coal"
	desc = "Gifted to the naughty."
	icon_state = "coal"
	var/assigned

/obj/item/trash/coal/attack_self(mob/user)
	if(user.mind)
		if(user.mind.assigned_role == "Santa")
			if(assigned)
				to_chat(user, "<span class='warning'>[src] hwas assigned to [src].</span>")
				return
			to_chat(user, "<span class='warning'>Who do you want to assign this too?</span>")
			var/naughty = reject_bad_name(stripped_input(user, "Assign someone to the naughty list.", "Naughty Inscription", name),1)
			if(!naughty)
				return
			var/accepted
			for(var/mob/M in mob_list)
				if(M.name == "[naughty]")
					accepted = TRUE
					assigned = M.name
					desc = "It has [M.name]'s name on it."
					naughty_list += M

			if(!accepted)
				to_chat(user, "<span class='warning'>You either have the wrong person, or you've spelled their name wrong. Effect cancelled.</span>")
				return

			to_chat(user, "<span class='warning'>You have successfully added [naughty] to the naughty list.</span>")