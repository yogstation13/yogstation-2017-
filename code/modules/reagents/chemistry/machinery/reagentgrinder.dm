/obj/machinery/reagentgrinder
		name = "\improper All-In-One Grinder"
		desc = "Used to grind things up into raw materials."
		icon = 'icons/obj/kitchen.dmi'
		icon_state = "juicer1"
		layer = BELOW_OBJ_LAYER
		anchored = 1
		use_power = 1
		idle_power_usage = 5
		active_power_usage = 100
		pass_flags = PASSTABLE
		var/operating = 0
		var/obj/item/weapon/reagent_containers/beaker = null
		var/limit = 10
		var/list/items = list()

/obj/machinery/reagentgrinder/New()
		..()
		beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		return

/obj/machinery/reagentgrinder/update_icon()
		icon_state = "juicer"+num2text(!isnull(beaker))
		return


/obj/machinery/reagentgrinder/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I))
		return
	if (istype(I, /obj/item/weapon/reagent_containers) && (I.flags & OPENCONTAINER) )
		if (!beaker)
			if(!user.drop_item())
				return 1
		beaker =  I
		beaker.loc = src
		to_chat(user, "<span class='notice'>You slide [I] into [src].</span>")
		update_icon()
		src.updateUsrDialog()
	else
		to_chat(user, "<span class='warning'>There's already a container inside.</span>")
	return 1 //no afterattack

	if(items.len >= limit)
		to_chat(user, "<span class='warning'>[src] is filled to capacity!</span>")
	//Fill machine with a bag!
	if(istype(I, /obj/item/weapon/storage/bag))
		var/obj/item/weapon/storage/bag/B = I
		for (var/obj/item/weapon/reagent_containers/food/snacks/grown/G in B.contents)
			B.remove_from_storage(G, src)
			items += G
			if(items && items.len >= limit) //Sanity checking so the blender doesn't overfill
				to_chat(user, "<span class='notice'>You fill the All-In-One grinder to the brim.</span>")
				break
	if(!I.contents.len)
		to_chat(user, "<span class='notice'>You empty the plant bag into the All-In-One grinder.</span>")
		src.updateUsrDialog()
		return 1

	if(!I.grind_results && !I.juice_results)
		if(user.a_intent == "harm")
			return ..()
		else
			to_chat(user, "<span class='warning'>You cannot grind [I] into reagents!</span>")
			return 1

	if(!I.grind_requirements(src)) //Error messages should be in the objects' definitions
		return

	if(user.drop_item())
		I.forceMove(src)
		items[I] = TRUE
		src.updateUsrDialog()
		return 0

/obj/machinery/reagentgrinder/attack_paw(mob/user)
		return src.attack_hand(user)

/obj/machinery/reagentgrinder/attack_ai(mob/user)
		return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user)
		user.set_machine(src)
		interact(user)

/obj/machinery/reagentgrinder/interact(mob/user) // The microwave Menu
		var/is_chamber_empty = 0
		var/is_beaker_ready = 0
		var/processing_chamber = ""
		var/beaker_contents = ""
		var/dat = ""

		if(!operating)
				for (var/obj/item/O in items)
						processing_chamber += "\A [O.name]<BR>"

				if (!processing_chamber)
						is_chamber_empty = 1
						processing_chamber = "Nothing."
				if (!beaker)
						beaker_contents = "<B>No beaker attached.</B><br>"
				else
						is_beaker_ready = 1
						beaker_contents = "<B>The beaker contains:</B><br>"
						var/anything = 0
						for(var/datum/reagent/R in beaker.reagents.reagent_list)
								anything = 1
								beaker_contents += "[R.volume] - [R.name]<br>"
						if(!anything)
								beaker_contents += "Nothing<br>"


				dat = {"
		<b>Processing chamber contains:</b><br>
		[processing_chamber]<br>
		[beaker_contents]<hr>
		"}
				if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
						dat += "<A href='?src=\ref[src];action=grind'>Grind the reagents</a><BR>"
						dat += "<A href='?src=\ref[src];action=juice'>Juice the reagents</a><BR><BR>"
				if(items && items.len > 0)
						dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
				if (beaker)
						dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
		else
				dat += "Please wait..."

		var/datum/browser/popup = new(user, "reagentgrinder", "All-In-One Grinder")
		popup.set_content(dat)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open(1)
		return

/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	if(operating)
		updateUsrDialog()
		return
	switch(href_list["action"])
		if ("grind")
			grind()
		if("juice")
			juice()
		if("eject")
			eject()
		if ("detach")
			detach()

/obj/machinery/reagentgrinder/proc/detach()
	if (usr.stat != 0)
		return
	if (!beaker)
		return
	beaker.loc = src.loc
	beaker = null
	update_icon()
	updateUsrDialog()

/obj/machinery/reagentgrinder/proc/eject()
	if (usr.stat != 0)
		return
	if (items && items.len == 0)
		return
	for(var/obj/item/O in items)
		O.loc = src.loc
		items -= O
	items = list()
	updateUsrDialog()

/obj/machinery/reagentgrinder/proc/remove_object(obj/item/O)
		items -= O
		qdel(O)

/obj/machinery/reagentgrinder/proc/juice()
	power_change()
	if(!beaker || (beaker && (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 250) //start shaking
	operating = 1
	updateUsrDialog()
	spawn(60)
		pixel_x = initial(pixel_x) //return to its spot after shaking
		operating = 0
		updateUsrDialog()
	for(var/obj/item/i in items)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/obj/item/I = i
		if(I.juice_results)
			juice_item(I)

/obj/machinery/reagentgrinder/proc/juice_item(obj/item/I) //Juicing results can be found in respective object definitions
	if(I.on_juice(src) == -1)
		to_chat(usr, "<span class='danger'>[src] shorts out as it tries to juice up [I], and transfers it back to storage.</span>")
		return
	beaker.reagents.add_reagent_list(I.juice_results)
	remove_object(I)

/obj/machinery/reagentgrinder/proc/grind()
	power_change()
	if(stat & (NOPOWER|BROKEN))
		return
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 250) //start shaking
	operating = 1
	updateUsrDialog()
	spawn(60)
		pixel_x = initial(pixel_x) //return to its spot after shaking
		operating = 0
		updateUsrDialog()
	for(var/i in items)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/obj/item/I = i
		if(I.grind_results)
			grind_item(i)

/obj/machinery/reagentgrinder/proc/grind_item(obj/item/I) //Grind results can be found in respective object definitions
	if(I.on_grind(src) == -1) //Call on_grind() to change amount as needed, and stop grinding the item if it returns -1
		to_chat(usr, "<span class='danger'>[src] shorts out as it tries to grind up [I], and transfers it back to storage.</span>")
		return
	beaker.reagents.add_reagent_list(I.grind_results)
	if(I.reagents)
		I.reagents.trans_to(beaker, I.reagents.total_volume)
	remove_object(I)