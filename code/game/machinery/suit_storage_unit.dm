// SUIT STORAGE UNIT /////////////////close_machine(
/obj/machinery/suit_storage_unit
	name = "suit storage unit"
	desc = "An industrial unit made to hold space suits. It comes with a built-in UV cauterization mechanism. A small warning label advises that organic matter should not be placed into the unit."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "close"
	anchored = 1
	density = 1

	var/obj/item/clothing/suit/suit = null
	var/obj/item/clothing/head/helmet = null
	var/obj/item/clothing/mask/mask = null
	var/obj/item/clothing/shoes/shoes = null
	var/list/extra_items = null
	var/extra_items_max = null //determined based on how many extra_items are defined

	var/suit_type = null
	var/helmet_type = null
	var/mask_type = null
	var/shoes_type = null
	var/list/extra_types = null

	state_open = FALSE
	var/locked = FALSE
	panel_open = FALSE
	var/safeties = TRUE

	var/uv = FALSE
	var/uv_super = FALSE
	var/uv_cycles = 6

/obj/machinery/suit_storage_unit/standard_unit
	suit_type = /obj/item/clothing/suit/space/eva
	helmet_type = /obj/item/clothing/head/helmet/space/eva
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/captain
	suit_type = /obj/item/clothing/suit/space/captain
	helmet_type = /obj/item/clothing/head/helmet/space/captain
	mask_type = /obj/item/clothing/mask/gas
	extra_types = list(/obj/item/weapon/tank/jetpack/oxygen/captain)

/obj/machinery/suit_storage_unit/command
	suit_type = /obj/item/clothing/suit/space/heads
	helmet_type = /obj/item/clothing/head/helmet/space/heads
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/engine
	suit_type = /obj/item/clothing/suit/space/hardsuit/engine
	mask_type = /obj/item/clothing/mask/breath
	shoes_type = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/ce
	suit_type = /obj/item/clothing/suit/space/hardsuit/engine/elite
	mask_type = /obj/item/clothing/mask/breath
	shoes_type = /obj/item/clothing/shoes/magboots/advance

/obj/machinery/suit_storage_unit/security
	suit_type = /obj/item/clothing/suit/space/hardsuit/security
	mask_type = /obj/item/clothing/mask/gas/sechailer
	shoes_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/hos
	suit_type = /obj/item/clothing/suit/space/hardsuit/security/hos
	mask_type = /obj/item/clothing/mask/gas/sechailer
	shoes_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/atmos
	suit_type = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	mask_type = /obj/item/clothing/mask/gas
	extra_types = list(/obj/item/weapon/watertank/atmos)

/obj/machinery/suit_storage_unit/mining
	suit_type = /obj/item/clothing/suit/hooded/explorer
	mask_type = /obj/item/clothing/mask/gas/explorer

/obj/machinery/suit_storage_unit/mining/eva
	suit_type = /obj/item/clothing/suit/space/hardsuit/mining
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/cmo
	suit_type = /obj/item/clothing/suit/space/hardsuit/medical
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/rd
	suit_type = /obj/item/clothing/suit/space/hardsuit/rd
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/syndicate
	suit_type = /obj/item/clothing/suit/space/hardsuit/syndi
	mask_type = /obj/item/clothing/mask/gas/syndicate
	extra_types = list(/obj/item/weapon/tank/jetpack/oxygen/harness)

/obj/machinery/suit_storage_unit/ert/command
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert
	mask_type = /obj/item/clothing/mask/breath
	shoes_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/ert/security
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert/sec
	mask_type = /obj/item/clothing/mask/breath
	shoes_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/ert/engineer
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert/engi
	mask_type = /obj/item/clothing/mask/breath
	shoes_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/ert/medical
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert/med
	mask_type = /obj/item/clothing/mask/breath
	shoes_type = /obj/item/clothing/shoes/magboots/security

///mining medic///

/obj/machinery/suit_storage_unit/mmedic
	suit_type = /obj/item/clothing/suit/space/hardsuit/mining/mmedic
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/New()
	..()
	wires = new /datum/wires/suit_storage_unit(src)
	if(suit_type)
		suit = new suit_type(src)
	if(helmet_type)
		helmet = new helmet_type(src)
	if(mask_type)
		mask = new mask_type(src)
	if(shoes_type)
		shoes = new shoes_type(src)
	if(extra_types && extra_types.len)
		extra_items = list()
		extra_items_max = 0
		for(var/type in extra_types)
			var/num_to_create = extra_types[type]
			if(!num_to_create)
				num_to_create = 1
			extra_items_max += num_to_create
			for(var/i in 1 to num_to_create)
				extra_items += new type(src)
	update_icon()

/obj/machinery/suit_storage_unit/update_icon()
	overlays.Cut()

	if(uv)
		if(uv_super)
			overlays += "super"
		else if(occupant)
			overlays += "uvhuman"
		else
			overlays += "uv"
	else if(state_open)
		if(stat & BROKEN)
			overlays += "broken"
		else
			overlays += "open"
			if(suit)
				overlays += "suit"
			if(helmet)
				overlays += "helm"
			if(shoes)
				overlays += "storage"
	else if(occupant)
		overlays += "human"

/obj/machinery/suit_storage_unit/power_change()
	..()
	if(!is_operational() && state_open)
		open_machine()
		dump_contents()
	update_icon()

/obj/machinery/suit_storage_unit/proc/dump_contents()
	dropContents()
	helmet = null
	suit = null
	mask = null
	shoes = null
	occupant = null
	extra_items = null

/obj/machinery/suit_storage_unit/ex_act(severity, target)
	switch(severity)
		if(1)
			if(prob(50))
				open_machine()
				dump_contents()
			qdel(src)
		if(2)
			if(prob(50))
				open_machine()
				dump_contents()
				qdel(src)

/obj/machinery/suit_storage_unit/MouseDrop_T(atom/A, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !Adjacent(A) || !isliving(A))
		return
	var/mob/living/target = A
	if(!state_open)
		user << "<span class='warning'>The unit's doors are shut!</span>"
		return
	if(!is_operational())
		user << "<span class='warning'>The unit is not operational!</span>"
		return
	if(occupant || helmet || suit || shoes || (extra_items && extra_items.len))
		user << "<span class='warning'>It's too cluttered inside to fit in!</span>"
		return

	if(target == user)
		user.visible_message("<span class='warning'>[user] starts squeezing into [src]!</span>", "<span class='notice'>You start working your way into [src]...</span>")
	else
		target.visible_message("<span class='warning'>[user] starts shoving [target] into [src]!</span>", "<span class='userdanger'>[user] starts shoving you into [src]!</span>")

	if(do_mob(user, target, 30))
		if(occupant || helmet || suit || shoes || (extra_items && extra_items.len))
			return
		if(target == user)
			user.visible_message("<span class='warning'>[user] slips into [src] and closes the door behind them!</span>", "<span class=notice'>You slip into [src]'s cramped space and shut its door.</span>")
		else
			target.visible_message("<span class='warning'>[user] pushes [target] into [src] and shuts its door!<span>", "<span class='userdanger'>[user] shoves you into [src] and shuts the door!</span>")
		close_machine(target)
		add_fingerprint(user)

/obj/machinery/suit_storage_unit/proc/cook()
	if(uv_cycles)
		uv_cycles--
		uv = TRUE
		locked = TRUE
		update_icon()
		if(occupant)
			if(uv_super)
				occupant.adjustFireLoss(rand(20, 36))
			else
				occupant.adjustFireLoss(rand(10, 16))
			if(iscarbon(occupant))
				occupant.emote("scream")
		addtimer(src, "cook", 50, FALSE)
	else
		uv_cycles = initial(uv_cycles)
		uv = FALSE
		locked = FALSE
		if(uv_super)
			visible_message("<span class='warning'>[src]'s door creaks open with a loud whining noise. A cloud of foul black smoke escapes from its chamber.</span>")
			playsound(src, 'sound/machines/airlock_alien_prying.ogg', 50, 1)
			helmet = null
			qdel(helmet)
			suit = null
			qdel(suit) // Delete everything but the occupant.
			mask = null
			qdel(mask)
			shoes = null
			qdel(shoes)
			extra_items = null
			qdel(extra_items)
			// The wires get damaged too.
			wires.cut_all()
		else
			if(!occupant)
				visible_message("<span class='notice'>[src]'s door slides open. The glowing yellow lights dim to a gentle green.</span>")
			else
				visible_message("<span class='warning'>[src]'s door slides open, barraging you with the nauseating smell of charred flesh.</span>")
			playsound(src, 'sound/machines/AirlockClose.ogg', 25, 1)
			for(var/obj/item/I in src) //Scorches away blood and forensic evidence, although the SSU itself is unaffected
				I.clean_blood()
				I.fingerprints = list()
		open_machine(FALSE)
		if(occupant)
			dump_contents()

/obj/machinery/suit_storage_unit/proc/shock(mob/user, prb)
	if(!prob(prb))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(user && electrocute_mob(user, src, src))
			return 1

/obj/machinery/suit_storage_unit/relaymove(mob/user)
	container_resist()

/obj/machinery/suit_storage_unit/container_resist()
	var/mob/living/user = usr
	add_fingerprint(user)
	if(locked)
		visible_message("<span class='notice'>You see [user] kicking against the doors of [src]!</span>", "<span class='notice'>You start kicking against the doors...</span>")
		addtimer(src, "resist_open", 300, FALSE, user)
	else
		open_machine()
		dump_contents()

/obj/machinery/suit_storage_unit/proc/resist_open(mob/user)
	if(!state_open && occupant && (user in src) && user.stat == 0) // Check they're still here.
		visible_message("<span class='notice'>You see [user] bursts out of [src]!</span>", "<span class='notice'>You escape the cramped confines of [src]!</span>")
		open_machine()

/obj/machinery/suit_storage_unit/attackby(obj/item/I, mob/user, params)
	if(state_open && is_operational())
		if(istype(I, suit_type) || istype(I, /obj/item/clothing/suit/space))
			if(suit)
				user << "<span class='warning'>The unit already contains a suit!.</span>"
				return
			if(!user.drop_item())
				return
			suit = I
		else if(istype(I, helmet_type) || istype(I, /obj/item/clothing/head/helmet))
			if(helmet)
				user << "<span class='warning'>The unit already contains a helmet!</span>"
				return
			if(!user.drop_item())
				return
			helmet = I
		else if(istype(I, mask_type) || istype(I, /obj/item/clothing/mask))
			if(mask)
				user << "<span class='warning'>The unit already contains a mask!</span>"
				return
			if(!user.drop_item())
				return
			mask = I
		else if(istype(I, shoes_type) || istype(I, /obj/item/clothing/shoes))
			if(shoes)
				user << "<span class='warning'>The unit already contains a pair of shoes!</span>"
				return
			if(!user.drop_item())
				return
			shoes = I
		else if(extra_items)
			if(extra_items.len >= extra_items_max)
				user << "<span class='warning'>The auxiliary storage compartment is full!</span>"
				return
			if(!user.drop_item())
				return
			extra_items += I
		else
			user << "<span class='notice'>[I] doesn't fit into [src]</span>"
			return

		I.forceMove(src)
		visible_message("<span class='notice'>[user] inserts [I] into [src]</span>", "<span class='notice'>You load [I] into [src].</span>")
		update_icon()
		return

	if(panel_open && is_wire_tool(I))
		wires.interact(user)
	if(!state_open)
		if(default_deconstruction_screwdriver(user, "panel", "close", I))
			return
	if(default_pry_open(I))
		dump_contents()
		return

	return ..()

/obj/machinery/suit_storage_unit/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
										datum/tgui/master_ui = null, datum/ui_state/state = notcontained_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "suit_storage_unit", name, 400, 305, master_ui, state)
		ui.open()

/obj/machinery/suit_storage_unit/ui_data()
	var/list/data = list()
	data["locked"] = locked
	data["open"] = state_open
	data["safeties"] = safeties
	data["uv_active"] = uv
	data["uv_super"] = uv_super
	if(helmet)
		data["helmet"] = helmet.name
	if(suit)
		data["suit"] = suit.name
	if(mask)
		data["mask"] = mask.name
	if(shoes)
		data["shoes"] = shoes.name
	if(extra_items)
		var/list/extra_item_names = new/list(extra_items_max)
		var/iteration = 0
		for(var/v in extra_items)
			var/obj/item/extra_item = v
			extra_item_names[++iteration] += extra_item.name
		data["extra_items"] = extra_item_names
		data["max_extra_items"] = extra_items_max
	if(occupant)
		data["occupied"] = 1
	return data

/obj/machinery/suit_storage_unit/ui_act(action, params)
	if(..() || uv)
		return
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine(0)
				if(occupant)
					dump_contents() // Dump out contents if someone is in there.
			. = TRUE
		if("lock")
			locked = !locked
			. = TRUE
		if("uv")
			if(occupant && safeties)
				return
			else if(!helmet && !mask && !suit && !shoes && !(extra_items && extra_items.len) && !occupant)
				return
			else
				if(occupant)
					occupant << "<span class='userdanger'>[src]'s confines grow warm, then hot, then scorching. You're being burned [!occupant.stat ? "alive" : "away"]!</span>"
				cook()
				. = TRUE
		if("dispense")
			if(!state_open)
				return
			switch(params["item"])
				if("helmet")
					helmet.loc = loc
					helmet = null
				if("suit")
					suit.loc = loc
					suit = null
				if("mask")
					mask.loc = loc
					mask = null
				if("shoes")
					shoes.loc = loc
					shoes = null
				if("extra_items")
					var/item_num = text2num(params["item_num"])
					var/obj/item/thing = extra_items[item_num]
					thing.loc = loc
					extra_items -= thing
			. = TRUE
	update_icon()