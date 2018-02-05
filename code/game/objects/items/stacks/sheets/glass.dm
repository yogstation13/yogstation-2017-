/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "glass"
	desc = "HOLY SHEET! That is a lot of glass."
	singular_name = "glass sheet"
	icon = 'icons/obj/materials.dmi'
	icon_state = "glass"
	materials = list(MAT_GLASS=MINERAL_MATERIAL_AMOUNT)
	origin_tech = "materials=1"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/glass

/obj/item/stack/sheet/glass/cyborg
	materials = list()
	is_cyborg = 1
	cost = 500

/obj/item/stack/sheet/glass/fifty
	amount = 50

/obj/item/stack/sheet/glass/attack_self(mob/user)
	construct_window(user)

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if (get_amount() < 1 || CC.get_amount() < 5)
			to_chat(user, "<span class='warning>You need five lengths of coil and one sheet of glass to make wired glass!</span>")
			return
		CC.use(5)
		use(1)
		to_chat(user, "<span class='notice'>You attach wire to the [name].</span>")
		var/obj/item/stack/light_w/new_tile = new(user.loc)
		new_tile.add_fingerprint(user)
	else if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && src.get_amount() >= 1)
			var/obj/item/stack/sheet/rglass/RG = new (user.loc)
			RG.add_fingerprint(user)
			var/obj/item/stack/sheet/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			V.use(1)
			G.use(1)
			if (!G && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, "<span class='warning'>You need one rod and one sheet of glass to make reinforced glass!</span>")
			return
	else
		return ..()

/obj/item/stack/sheet/glass/proc/construct_window(mob/user)
	if(!user || !src)
		return 0
	if(!istype(user.loc,/turf))
		return 0
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 0
	if(zero_amount())
		return 0
	var/title = "Sheet-Glass"
	title += " ([src.get_amount()] sheet\s left)"
	switch(alert(title, "Would you like full tile glass or one direction?", "One Direction", "Full Window", "Cancel", null))
		if("One Direction")
			if(!src)
				return 1
			if(src.loc != user)
				return 1

			var/list/directions = new/list(cardinal)
			var/i = 0
			for (var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, "<span class='warning'>There are too many windows in this location.</span>")
					return 1
				directions-=win.dir
				if(!(win.ini_dir in cardinal))
					to_chat(user, "<span class='danger'>Can't let you do that.</span>")
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list( user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break

			var/obj/structure/window/W
			W = new /obj/structure/window( user.loc, 0 )
			W.dir = dir_to_set
			W.ini_dir = W.dir
			W.anchored = 0
			W.air_update_turf(1)
			src.use(1)
			W.add_fingerprint(user)
		if("Full Window")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			if(src.get_amount() < 2)
				to_chat(user, "<span class='warning'>You need more glass to do that!</span>")
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, "<span class='warning'>There is a window in the way!</span>")
				return 1
			var/obj/structure/window/W
			W = new /obj/structure/window/fulltile( user.loc, 0 )
			W.anchored = 0
			W.air_update_turf(1)
			W.add_fingerprint(user)
			src.use(2)
	return 0


/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	desc = "Glass which seems to have rods or something stuck in them."
	singular_name = "reinforced glass sheet"
	icon = 'icons/obj/materials.dmi'
	icon_state = "rglass"
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT/2, MAT_GLASS=MINERAL_MATERIAL_AMOUNT)
	origin_tech = "materials=2"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/rglass

/obj/item/stack/sheet/rglass/cyborg
	materials = list()
	var/datum/robot_energy_storage/metsource
	var/datum/robot_energy_storage/glasource
	var/metcost = 250
	var/glacost = 500

/obj/item/stack/sheet/rglass/cyborg/get_amount()
	return min(round(metsource.energy / metcost), round(glasource.energy / glacost))

/obj/item/stack/sheet/rglass/cyborg/use(amount) // Requires special checks, because it uses two storages
	metsource.use_charge(amount * metcost)
	glasource.use_charge(amount * glacost)
	return

/obj/item/stack/sheet/rglass/cyborg/add(amount)
	metsource.add_charge(amount * metcost)
	glasource.add_charge(amount * glacost)
	return

/obj/item/stack/sheet/rglass/attack_self(mob/user)
	construct_window(user)

/obj/item/stack/sheet/rglass/proc/construct_window(mob/user)
	if(!user || !src)
		return 0
	if(!istype(user.loc,/turf))
		return 0
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 0
	var/title = "Sheet Reinf. Glass"
	title += " ([src.get_amount()] sheet\s left)"
	switch(input(title, "Would you like full tile glass a one direction glass pane or a windoor?") in list("One Direction", "Full Window", "Windoor", "Cancel"))
		if("One Direction")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			var/list/directions = new/list(cardinal)
			var/i = 0
			for (var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, "<span class='danger'>There are too many windows in this location.</span>")
					return 1
				directions-=win.dir
				if(!(win.ini_dir in cardinal))
					to_chat(user, "<span class='danger'>Can't let you do that.</span>")
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list( user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break

			var/obj/structure/window/W
			W = new /obj/structure/window/reinforced( user.loc, 1 )
			W.state = 0
			W.dir = dir_to_set
			W.ini_dir = W.dir
			W.anchored = 0
			W.add_fingerprint(user)
			src.use(1)

		if("Full Window")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			if(src.get_amount() < 2)
				to_chat(user, "<span class='warning'>You need more glass to do that!</span>")
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, "<span class='warning'>There is a window in the way!</span>")
				return 1
			var/obj/structure/window/W
			W = new /obj/structure/window/reinforced/fulltile(user.loc, 1)
			W.state = 0
			W.anchored = 0
			W.add_fingerprint(user)
			src.use(2)

		if("Windoor")
			if(!src || src.loc != user || !isturf(user.loc))
				return 1

			for(var/obj/structure/windoor_assembly/WA in user.loc)
				if(WA.dir == user.dir)
					to_chat(user, "<span class='warning'>There is already a windoor assembly in that location!</span>")
					return 1

			for(var/obj/machinery/door/window/W in user.loc)
				if(W.dir == user.dir)
					to_chat(user, "<span class='warning'>There is already a windoor in that location!</span>")
					return 1

			if(src.get_amount() < 5)
				to_chat(user, "<span class='warning'>You need more glass to do that!</span>")
				return 1

			var/obj/structure/windoor_assembly/WD = new(user.loc)
			WD.state = "01"
			WD.anchored = 0
			WD.add_fingerprint(user)
			src.use(5)
			switch(user.dir)
				if(SOUTH)
					WD.dir = SOUTH
					WD.ini_dir = SOUTH
				if(EAST)
					WD.dir = EAST
					WD.ini_dir = EAST
				if(WEST)
					WD.dir = WEST
					WD.ini_dir = WEST
				else //If the user is facing northeast. northwest, southeast, southwest or north, default to north
					WD.dir = NORTH
					WD.ini_dir = NORTH
		else
			return 1


	return 0