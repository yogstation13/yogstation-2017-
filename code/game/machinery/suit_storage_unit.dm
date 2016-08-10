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
	var/obj/item/storage = null

	var/suit_type = null
	var/helmet_type = null
	var/mask_type = null
	var/storage_type = null

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
	storage_type = /obj/item/weapon/tank/jetpack/oxygen/captain

/obj/machinery/suit_storage_unit/command
	suit_type = /obj/item/clothing/suit/space/heads
	helmet_type = /obj/item/clothing/head/helmet/space/heads
	mask_type = /obj/item/clothing/mask/breath


/obj/machinery/suit_storage_unit/engine
	suit_type = /obj/item/clothing/suit/space/hardsuit/engine
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/ce
	suit_type = /obj/item/clothing/suit/space/hardsuit/engine/elite
	mask_type = /obj/item/clothing/mask/breath
	storage_type= /obj/item/clothing/shoes/magboots/advance

/obj/machinery/suit_storage_unit/security
	suit_type = /obj/item/clothing/suit/space/hardsuit/security
	mask_type = /obj/item/clothing/mask/gas/sechailer
	storage_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/hos
	suit_type = /obj/item/clothing/suit/space/hardsuit/security/hos
	mask_type = /obj/item/clothing/mask/gas/sechailer
	storage_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/atmos
	suit_type = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	mask_type = /obj/item/clothing/mask/gas
	storage_type = /obj/item/weapon/watertank/atmos

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
	storage_type = /obj/item/weapon/tank/jetpack/oxygen/harness

/obj/machinery/suit_storage_unit/ert/command
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/ert/security
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert/sec
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/ert/engineer
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert/engi
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots/security

/obj/machinery/suit_storage_unit/ert/medical
	suit_type = /obj/item/clothing/suit/space/hardsuit/ert/med
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots/security

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
	if(storage_type)
		storage = new storage_type(src)
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
			if(storage)
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
	storage = null
	occupant = null

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
	if(occupant)
		user << "<span class='warning'>It's too cluttered inside to fit in!</span>"
		return

	var/enterdelay = 5

	if(target != user)
		enterdelay += 25
		target.visible_message("<span class='warning'>[user] starts shoving [target] into [src]!</span>", "<span class='userdanger'>[user] starts shoving you into [src]!</span>")

	if(do_mob(user, target, enterdelay))
		if(target == user)
			user.visible_message("<span class='warning'>[user] slips into [src] and closes the door behind them!</span>", "<span class=notice'>You slip into [src]'s cramped space and shut its door.</span>")
		else
			target.visible_message("<span class='warning'>[user] pushes [target] into [src] and shuts its door!<span>", "<span class='userdanger'>[user] shoves you into [src] and shuts the door!</span>")
		close_machine(target)
		cycle_clothes(target)
		add_fingerprint(user)


/obj/machinery/suit_storage_unit/proc/cycle_clothes(mob/user)
	playsound(src, 'sound/weapons/sonic_jackhammer.ogg', 50, 1)
	if(occupant && emagged)
		cook()
		return

	if(!ishuman(user))
		user << "<span class='warning'>[src] states your biological form is incompatiable with this suit storage unit's software!</span>"
		return

	var/mob/living/carbon/human/H = user
	var/turf/T = get_turf(src)

	locked = TRUE

	if(suit)
		var/obj/outfit = null

		if(H.wear_suit)
			outfit = H.wear_suit
			H.unEquip(outfit)

		if(outfit)
			T.contents += suit

		if(H.can_equip(suit, slot_wear_suit))
			H.equip_to_slot_or_del(suit, slot_wear_suit)
			suit = outfit
		else
			suit = null

	if(helmet)
		var/obj/oldhelm
		if(H.head)
			oldhelm = H.head
			H.unEquip(oldhelm)

		if(oldhelm)
			T.contents += helmet

		if(H.can_equip(helmet, slot_head))
			H.equip_to_slot_or_del(helmet, slot_head)
			helmet = oldhelm
		else
			helmet = null

	if(mask)
		var/obj/oldmask
		if(H.wear_mask)
			oldmask = H.wear_mask
			H.unEquip(oldmask)

		if(oldmask)
			T.contents += mask

		if(H.can_equip(mask, slot_wear_mask))
			H.equip_to_slot_or_del(mask, slot_wear_mask)
			mask = oldmask
		else
			mask = null


	if(storage)
		if(istype(storage, /obj/item/clothing/shoes))
			var/obj/item/clothing/shoes/s = storage
			var/obj/item/clothing/shoes/shoes
			if(H.shoes)
				shoes = H.shoes
				H.unEquip(shoes)

			if(s)
				T.contents += s

			if(H.can_equip(s, slot_shoes))
				H.equip_to_slot_or_del(s, slot_shoes)
				storage = shoes
			else
				storage = null

		else if(istype(storage, /obj/item))
			var/obj/item/I = storage
			if(I.flags & SLOT_BACK) // checks for objects on your back.
				var/obj/item/backpack
				if(H.back)
					backpack = H.back
					H.unEquip(backpack)

				if(I)
					T.contents += I

				if(H.can_equip(I, slot_back))
					H.equip_to_slot_or_del(I, slot_back)
					storage = backpack

				else
					storage = null
			else // checks for objects in general
				var/obj/O
				if(H.s_store)
					O = H.s_store
					H.unEquip(O)

				if(I)
					T.contents += I

				if(H.can_equip(I, slot_s_store))
					H.equip_to_slot_or_del(I, slot_s_store)
					storage = O
				else
					storage = null

	locked = FALSE
	open_machine(0)

	H.loc = T
	H.reset_perspective(null)
	H.update_canmove()
	occupant = null

	spawn(10)
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)

/obj/machinery/suit_storage_unit/emag_act(mob/user)
	if(emagged)
		if(!uv_super)
			uv_super = TRUE

	else
		emagged = TRUE
		if(!uv_super)
			uv_super = TRUE

	user << "<span class='warning'>You activate the UV's super setting.</span>"

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
			storage = null
			qdel(storage)
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
		if(istype(I, /obj/item/clothing/suit))
			if(suit)
				user << "<span class='warning'>The unit already contains a suit!.</span>"
				return
			if(!user.drop_item())
				return
			suit = I
		else if(istype(I, /obj/item/clothing/head))
			if(helmet)
				user << "<span class='warning'>The unit already contains a helmet!</span>"
				return
			if(!user.drop_item())
				return
			helmet = I
		else if(istype(I, /obj/item/clothing/mask))
			if(mask)
				user << "<span class='warning'>The unit already contains a mask!</span>"
				return
			if(!user.drop_item())
				return
			mask = I
		else
			if(storage)
				user << "<span class='warning'>The auxiliary storage compartment is full!</span>"
				return
			if(!user.drop_item())
				return
			storage = I

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
	if(storage)
		data["storage"] = storage.name
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
			else if(!helmet && !mask && !suit && !storage && !occupant)
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
				if("storage")
					storage.loc = loc
					storage = null
			. = TRUE
	update_icon()