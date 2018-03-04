/obj/machinery/aug_manipulator
	name = "\improper augment manipulator"
	desc = "A machine for custom fitting augmentations, with in-built spraypainter."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdapainter"
	density = TRUE
	anchored = TRUE
	var/obj/item/bodypart/storedpart
	var/initial_icon_state
	var/static/list/style_list_icons = list("standard" = 'icons/mob/augmentation/augments.dmi', "engineer" = 'icons/mob/augmentation/augments_engineer.dmi', "security" = 'icons/mob/augmentation/augments_security.dmi', "mining" = 'icons/mob/augmentation/augments_mining.dmi')


/obj/machinery/aug_manipulator/New()
    initial_icon_state = initial(icon_state)
    return ..()

/obj/machinery/aug_manipulator/update_icon()
	cut_overlays()

	if(stat & BROKEN)
		icon_state = "[initial_icon_state]-broken"
		return

	if(storedpart)
		add_overlay("[initial_icon_state]-closed")

	if(powered())
		icon_state = initial_icon_state
	else
		icon_state = "[initial_icon_state]-off"

/obj/machinery/aug_manipulator/Destroy()
	qdel(storedpart)
	return ..()

/obj/machinery/aug_manipulator/contents_explosion(severity, target)
	if(storedpart)
		storedpart.ex_act(severity, target)

/obj/machinery/aug_manipulator/handle_atom_del(atom/A)
	if(A == storedpart)
		storedpart = null
		update_icon()

/obj/machinery/aug_manipulator/attackby(obj/item/O, mob/user, params)
	if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/bodypart))
		var/obj/item/bodypart/B = O
		if(B.status != ORGAN_ROBOTIC)
			user << "<span class='warning'>The machine only accepts cybernetics!</span>"
			return
		if(storedpart)
			user << "<span class='warning'>There is already something inside!</span>"
			return
		else
			user.drop_item(O)
			O.forceMove(src)
			storedpart = O
			O.add_fingerprint(user)
			update_icon()


/obj/machinery/aug_manipulator/attack_hand(mob/user)
	if(!..())
		add_fingerprint(user)

		if(storedpart)
			var/augstyle = input(user, "Select style.", "Augment Custom Fitting") as null|anything in style_list_icons
			if(!augstyle)
				return
			if(!in_range(src, user))
				return
			if(!storedpart)
				return
			storedpart.icon = style_list_icons[augstyle]
			storedpart.limb_icon = style_list_icons[augstyle]
			eject_part(user)

		else
			user << "<span class='notice'>\The [src] is empty.</span>"

/obj/machinery/aug_manipulator/proc/eject_part(mob/living/user)
	if(storedpart)
		storedpart.forceMove(get_turf(src))
		storedpart = null
		update_icon()
	else
		user << "<span class='notice'>[src] is empty.</span>"

/obj/machinery/aug_manipulator/AltClick(mob/living/user)
	..()
	if(!user.canUseTopic(src))
		return
	else
		eject_part(user)

/obj/machinery/aug_manipulator/power_change()
	..()
	update_icon()