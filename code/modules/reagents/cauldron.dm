/obj/structure/reagent_holder
	name = "cauldron"
	desc = "A big thing for storing and mixing lots of reagents"
	icon = 'icons/obj/cauldron.dmi'
	icon_state = "cauldron"
	density = 1
	anchored = 1
	var/mode = 0 // 0 = pull, 1 = push
	flags = OPENCONTAINER

/obj/structure/reagent_holder/New()
	create_reagents(1000)
	update_icon()
	..()

/obj/structure/reagent_holder/Destroy()
	reagents.reaction(loc, TOUCH) // All the reagents spill onto the floor
	return ..()

/obj/structure/reagent_holder/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/weapon/wrench))
		if(do_after(user, 40, target = src))
			new /obj/item/stack/sheet/metal(loc, 10)
			qdel(src)
	else
		return ..()

/obj/structure/reagent_holder/on_reagent_change()
	update_icon()
	return ..()

/obj/structure/reagent_holder/update_icon()
	var icon_index = Ceiling(reagents.total_volume * 9 / reagents.maximum_volume)
	var/image/I = image(icon = 'icons/obj/cauldron.dmi', icon_state = "filled-[icon_index]")
	I.color = mix_color_from_reagents(reagents.reagent_list)
	overlays = list(mode ? "pushing" : "pulling", I)

/obj/structure/reagent_holder/attack_hand(user)
	mode = !mode
	user << "Using a beaker on [src] will now [mode ? "add" : "remove"] reagents"
	update_icon()
