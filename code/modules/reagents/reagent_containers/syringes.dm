#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1

/obj/item/weapon/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe that can hold up to 15 units."
	icon = 'icons/obj/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 15
	var/mode = SYRINGE_DRAW
	var/busy = 0		// needed for delayed drawing of blood
	var/allow_ammo = 1  //If we allow it to be used in the darts
	var/piercing
	materials = list(MAT_METAL=10, MAT_GLASS=20)

/obj/item/weapon/reagent_containers/syringe/New()
	..()
	if(list_reagents) //syringe starts in inject mode if its already got something inside
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_self(mob/user)
	mode = !mode
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_paw()
	return attack_hand()

/obj/item/weapon/reagent_containers/syringe/attackby(obj/item/I, mob/user, params)
	return

/obj/item/weapon/reagent_containers/syringe/afterattack(atom/target, mob/user , proximity)
	if(busy)
		return
	if(!proximity)
		return
	if(!target.reagents)
		return

	var/mob/living/L
	if(isliving(target))
		L = target
		if(!L.can_inject(user, 1))
			return

	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "<span class='notice'>The syringe is full.</span>"
				return

			if(L) //living mob
				var/drawn_amount = reagents.maximum_volume - reagents.total_volume
				if(target != user)
					target.visible_message("<span class='danger'>[user] is trying to take a blood sample from [target]!</span>", \
									"<span class='userdanger'>[user] is trying to take a blood sample from [target]!</span>")
					busy = 1
					if(!do_mob(user, target))
						busy = 0
						return
					if(reagents.total_volume >= reagents.maximum_volume)
						return
				busy = 0
				if(L.transfer_blood_to(src, drawn_amount))
					user.visible_message("[user] takes a blood sample from [L].")
				else
					user << "<span class='warning'>You are unable to draw any blood from [L]!</span>"

			else //if not mob
				if(!target.reagents.total_volume)
					user << "<span class='warning'>[target] is empty!</span>"
					return

				if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers) && !istype(target,/obj/item/slime_extract))
					user << "<span class='warning'>You cannot directly remove reagents from [target]!</span>"
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				user << "<span class='notice'>You fill [src] with [trans] units of the solution.</span>"
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				user << "<span class='notice'>[src] is empty.</span>"
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/cigarette) && !istype(target, /obj/item/weapon/storage/fancy/cigarettes))
				user << "<span class='warning'>You cannot directly fill [target]!</span>"
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "<span class='notice'>[target] is full.</span>"
				return

			if(L) //living mob
				if(L != user)
					L.visible_message("<span class='danger'>[user] is trying to inject [L]!</span>", \
											"<span class='userdanger'>[user] is trying to inject [L]!</span>")
					if(!do_mob(user, L))
						return
					if(!reagents.total_volume)
						return
					if(L.reagents.total_volume >= L.reagents.maximum_volume)
						return

					L.visible_message("<span class='danger'>[user] injects [L] with the syringe!", \
									"<span class='userdanger'>[user] injects [L] with the syringe!")

				var/list/rinject = list()
				var/viruslist = ""
				for(var/datum/reagent/R in reagents.reagent_list)
					if(istype(R, /datum/reagent/blood))
						var/datum/reagent/blood/RR = R
						for(var/datum/disease/D in RR.data["viruses"])
							viruslist += " [D.name]"
							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/DD = D
								viruslist += " \[ symptoms: "
								for(var/datum/symptom/S in DD.symptoms)
									viruslist += "[S.name] "
								viruslist += "\]"
					rinject += R.name
				var/contained = english_list(rinject)

				if(viruslist)
					investigate_log("[user.real_name] ([user.ckey]) injected [L.real_name] ([L.ckey]) with [viruslist]", "viro")

				if(L != user)
					add_logs(user, L, "injected", src, addition=" which had [contained]")
				else
					log_attack("<font color='red'>[user.name] ([user.ckey]) injected [L.name] ([L.ckey]) with [src.name], which had [contained] (INTENT: [uppertext(user.a_intent)])</font>")
					L.attack_log += "\[[time_stamp()]\] <font color='orange'>Injected themselves ([contained]) with [src.name].</font>"

			var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
			reagents.reaction(L, INJECT, fraction)
			reagents.trans_to(target, amount_per_transfer_from_this)
			user << "<span class='notice'>You inject [amount_per_transfer_from_this] units of the solution. The syringe now contains [reagents.total_volume] units.</span>"
			if (reagents.total_volume <= 0 && mode==SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()


/obj/item/weapon/reagent_containers/syringe/update_icon()
	var/rounded_vol = Clamp(round((reagents.total_volume / volume * 15),5), 0, 15)
	overlays.Cut()
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		overlays += injoverlay
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")
		filling.icon_state = "syringe[rounded_vol]"
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling
		return filling

/obj/item/weapon/reagent_containers/syringe/epinephrine
	name = "syringe (epinephrine)"
	desc = "Contains epinephrine - used to stabilize patients."
	list_reagents = list("epinephrine" = 15)

/obj/item/weapon/reagent_containers/syringe/charcoal
	name = "syringe (charcoal)"
	desc = "Contains charcoal."
	list_reagents = list("charcoal" = 15)

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "syringe (spaceacillin)"
	desc = "Contains antiviral agents."
	list_reagents = list("spaceacillin" = 15)

/obj/item/weapon/reagent_containers/syringe/bioterror
	name = "bioterror syringe"
	desc = "Contains several paralyzing reagents."
	list_reagents = list("neurotoxin" = 5, "mutetoxin" = 5, "sodium_thiopental" = 5)

/obj/item/weapon/reagent_containers/syringe/stimulants
	name = "Stimpack"
	desc = "Contains stimulants."
	amount_per_transfer_from_this = 20
	volume = 60
	list_reagents = list("stimulants" = 60)

/obj/item/weapon/reagent_containers/syringe/calomel
	name = "syringe (calomel)"
	desc = "Contains calomel."
	list_reagents = list("calomel" = 15)

/obj/item/weapon/reagent_containers/syringe/lethal
	name = "lethal injection syringe"
	desc = "A syringe used for lethal injections. It can hold up to 50 units."
	amount_per_transfer_from_this = 50
	volume = 50

/obj/item/weapon/reagent_containers/syringe/lethal/choral
	list_reagents = list("chloralhydrate" = 50)

/obj/item/weapon/reagent_containers/syringe/mulligan
	name = "Mulligan"
	desc = "A syringe used to completely change the users identity."
	amount_per_transfer_from_this = 1
	volume = 1
	list_reagents = list("mulligan" = 1)

/obj/item/weapon/reagent_containers/syringe/gluttony
	name = "Gluttony's Blessing"
	desc = "A syringe recovered from a dread place. It probably isn't wise to use."
	amount_per_transfer_from_this = 1
	volume = 1
	list_reagents = list("gluttonytoxin" = 1)

/obj/item/weapon/reagent_containers/syringe/bluespace
	name = "bluespace syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals"
	amount_per_transfer_from_this = 20
	volume = 60
	origin_tech = "bluespace=4;materials=4;biotech=4"

/obj/item/weapon/reagent_containers/syringe/noreact
	name = "cryo syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	volume = 20
	origin_tech = "materials=3;engineering=3"

/obj/item/weapon/reagent_containers/syringe/noreact/New()
	. = ..()
	reagents.set_reacting(FALSE)


/obj/item/dart_casing
	name = "syringe casing"
	desc = "A casing made for syringes to be used in needle guns."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "dart_0_medical"
	w_class = 1
	var/purpose = "medical"
	var/loaded            //If it's loaded
	var/max_chemicals = 1 //The amount of different chemicals it allows
	var/allow_reload      //If you can insert and remove needles freely
	var/projectile_type = /obj/item/projectile/bullet/dart/syringe
	var/reagent

/obj/item/dart_casing/medical
	name = "medical dart"
	icon_state = "dart_0_medical"
	purpose = "medical"
	projectile_type = /obj/item/projectile/bullet/dart/syringe/medical

/obj/item/dart_casing/combat
	name = "combat dart"
	icon_state = "dart_0_combat"
	purpose = "combat"
	allow_reload = 1
	max_chemicals = 2
	projectile_type = /obj/item/projectile/bullet/dart/syringe/combat

/obj/item/dart_casing/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers/syringe) && !contents.len)
		var/obj/item/weapon/reagent_containers/syringe/S = I
		if(!S.allow_ammo)
			user << "<span class='warning'>[S] does not fit in [src]!</span>"
			return
		if(S.reagents.reagent_list.len > max_chemicals)
			user << "<span class='warning'>[src] rejects [S] due to build in safety precautions!</span>"
			return
		else
			if(!user.unEquip(S))
				return
			S.loc = src
			update_icon()
			user << "<span class='notice'>You insert [S] into [src].</span>"
			playsound(src,'sound/machines/click.ogg',10,1)
			return 1
	else
		..()


/obj/item/dart_casing/update_icon()
	overlays.Cut()
	loaded = 0
	name = "empty [purpose] dart"
	for(var/obj/item/weapon/reagent_containers/syringe/I in src)
		if(I.update_icon())
			overlays += I.update_icon()
		if(contents.len)
			loaded = 1
			reagent = I.reagents.reagent_list[1]
			name = "[reagent] [purpose] dart"
	icon_state = "dart_[loaded]_[purpose]"



/obj/item/dart_casing/attack_self(mob/user)
	if(contents.len && allow_reload)
		user.put_in_hands(src.contents[1])
		user << "<span class='notice'>You empty [src].</span>"
		playsound(src,'sound/machines/click.ogg',10,1)
		update_icon()
	else
		..()

/obj/item/dart_casing/dropped()
	update_icon()
	..()

/obj/item/dart_casing/New(var/loc, var/reagent_to_add, var/reagent_amount = 15, allow_reload, max_chemicals)
	..()
	if(reagent_to_add)
		var/obj/item/weapon/reagent_containers/syringe/S = new /obj/item/weapon/reagent_containers/syringe(src)
		S.reagents.add_reagent(reagent_to_add, reagent_amount)
	update_icon()
