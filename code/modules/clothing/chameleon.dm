////////////////////
//CHAMELEON DATUM
////////////////////

/datum/chameleon
	var/list/chameleon_blacklist = list()
	var/list/chameleon_list = list()
	var/include_basetype = 0
	var/chameleon_type = null
	var/chameleon_name = "Item"
	var/obj/target
	var/datum/outfit_browse/chameleon/registeredWith
	var/antag_only = TRUE

/datum/chameleon/New(obj/T)
	target = T
	..()

/datum/chameleon/Destroy()
	deregister()
	return ..()

/datum/chameleon/proc/can_use(datum/mind/mind)
	if(!mind)
		return FALSE
	if(antag_only && !mind.special_role)
		return FALSE
	return TRUE

/datum/chameleon/proc/initialize_disguises()
	chameleon_blacklist += target.type
	var/list/temp_list
	if(include_basetype)
		temp_list = typesof(chameleon_type)
	else
		temp_list = subtypesof(chameleon_type)
	for(var/V in temp_list - (chameleon_blacklist))
		chameleon_list += V

/datum/chameleon/proc/random_look(mob/user)
	var/picked_item = pick(chameleon_list)
	// If a user is provided, then this item is in use, and we
	// need to update our icons and stuff

	if(user)
		update_look(user, picked_item)

	// Otherwise, it's likely a random initialisation, so we
	// don't have to worry

	else
		update_item(picked_item, user)

/datum/chameleon/proc/select_look(mob/user)
	if(user.incapacitated() || (target.loc != user))
		return
	var/list/item_names = list()
	var/list/namecounts = list()
	var/obj/item/picked_item
	for(var/U in chameleon_list)
		var/obj/item/I = U
		var/name = initial(I.name) //witchcraft
		if(name in item_names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		item_names[name] = I
	var/picked_name
	picked_name = input(user, "Select [chameleon_name] to change it to", "Chameleon [chameleon_name]", picked_name) as null|anything in item_names
	if(!picked_name || user.incapacitated() || (target.loc != user))
		return
	picked_item = item_names[picked_name]
	if(!picked_item)
		return
	update_look(user, picked_item)

/datum/chameleon/proc/update_look(mob/user, obj/item/picked_item)
	if(isliving(user))
		var/mob/living/C = user
		if(C.stat != CONSCIOUS)
			return

		update_item(picked_item, user)

		C.regenerate_icons()	//so our overlays update.

/datum/chameleon/proc/update_item(obj/item/picked_item, mob/user)
	target.name = initial(picked_item.name)
	target.desc = initial(picked_item.desc)
	target.icon_state = initial(picked_item.icon_state)
	if(istype(target, /obj/item))
		var/obj/item/I = target
		I.item_state = initial(picked_item.item_state)
		I.item_color = initial(picked_item.item_color)
		if(istype(target, /obj/item/clothing))
			var/obj/item/clothing/CL = I
			var/obj/item/clothing/PCL = picked_item
			CL.flags_cover = initial(PCL.flags_cover)
			CL.flags_inv = initial(PCL.flags_inv)
			if(istype(target, /obj/item/clothing/under))
				var/obj/item/clothing/under/UCL = target
				var/obj/item/clothing/under/PUCL = picked_item
				UCL.can_adjust = initial(PUCL.can_adjust)
				if(!UCL.can_adjust && UCL.adjusted)
					UCL.toggle_jumpsuit_adjust()
					user.update_inv_w_uniform()
	target.icon = initial(picked_item.icon)

/datum/chameleon/proc/deregister()
	if(registeredWith)
		registeredWith.deregisterItem(src)

/datum/chameleon/proc/register(mob/M)
	deregister()
	if(istype(M, /datum/outfit_browse/chameleon))
		var/datum/outfit_browse/chameleon/cb = M
		cb.registerItem(src)
		return

	if(M && M.mind)
		var/datum/outfit_browse/chameleon/B = M.mind.get_outfit_browser(OUTFIT_BROWSE_CHAMELEON)
		B.registerItem(src)

////////////////////
//CHAMELEON BROWSE
////////////////////

/datum/action/cham_browse
	name = "Chameleon Change"
	var/datum/outfit_browse/chameleon/chameleon_browse
	button_icon_state = "chameleon_menu"

/datum/action/cham_browse/Trigger()
	if(!owner || !owner.mind)
		qdel(src)
		return
	chameleon_browse.menu(owner)

/datum/action/cham_browse/Destroy()
	chameleon_browse.action = null
	return ..()


/datum/outfit_browse/chameleon
	window_name = "Chameleon Outfit Select"
	window_id = "cham_outfit_select"
	var/list/registered = list()
	var/datum/action/cham_browse/action

/datum/outfit_browse/chameleon/Destroy()
	if(action)
		qdel(action)
	for(var/C in registered)
		deregisterItem(C)
	return ..()

/datum/outfit_browse/chameleon/proc/deregisterItem(datum/chameleon/C)
	registered -= C
	C.registeredWith = null
	if(registered.len == 0)
		qdel(action)

/datum/outfit_browse/chameleon/proc/registerItem(datum/chameleon/C)
	if(!C.can_use(mind))
		return
	registered |= C
	C.registeredWith = src
	if(mind && mind.current && !action)
		action = new /datum/action/cham_browse()
		action.chameleon_browse = src
		action.Grant(mind.current)

/datum/outfit_browse/chameleon/move_to_mob(var/mob/newmob)
	for(var/V in registered)
		var/datum/chameleon/C = V
		C.deregister()
	for(var/obj/item/I in newmob)
		if(I.chameleon)
			I.chameleon.register(src)
	..()

/datum/outfit_browse/chameleon/build_menu(mob/user)
	var/dat = ""
	var/datum/preferences/prefs = new /datum/preferences()
	prefs.copy_from(user)
	var/image/I = get_flat_human_icon(null, outfitSelected, prefs)
	user << browse_rsc(I, "cham_photo")
	dat += "<table>"
	dat += "<tr><th><b>Preview</b><br><img src=cham_photo height=80 width=80 border=4> <br><a href='?src=\ref[src];update=1'>Apply</a><br>&nbsp;</th><th valign='top' align='left'><b>Current Items:</b><br>"
	for(var/V in registered)
		var/datum/chameleon/C = V
		user << browse_rsc(icon(icon=C.target.icon, icon_state=C.target.icon_state), "cham_[C.chameleon_name]")
		dat += "<img src=cham_[C.chameleon_name] height=32 width=32 border=4> <a href='?src=\ref[src];change=\ref[C]'>Chameleon [C.chameleon_name]</a><br>"
	dat += "</th></tr>"
	dat += "<tr><th valign='top' align='left'><b>Jobs:</b><br>"
	for(var/V in (list("None") + get_all_jobs()))
		if(V == jobSelected)
			dat += "<b> [V]</b><br>"
		else
			dat += "<a href='?src=\ref[src];job=[V]'>[V]</a><br>"

	dat += "</th><th valign='top' align='left'>"
	dat += "<b>Job items:</b><br>"
	for(var/slot in slots)
		var/obj/O = outfitSelected.vars[slot] //this is not actually an object, it's a typepath. We're doing some witchcraft.
		if(O)
			dat += "[initial(O.name)]<br>"//witchcraft
	dat += "</th></tr></table>"
	return dat

/datum/outfit_browse/chameleon/proc/updateAppearances(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	var/list/updating = registered.Copy()
	for(var/slot in slots)
		for(var/U in updating)
			var/datum/chameleon/C = U
			var/type = outfitSelected.vars[slot]
			if(type in C.chameleon_list)
				updating -= C
				C.update_look(H, type)
	return TRUE

/datum/outfit_browse/chameleon/Topic(href, href_list)
	if(..())
		return TRUE

	if(usr.incapacitated())
		return FALSE

	if(href_list["change"])
		var/datum/chameleon/C = locate(href_list["change"]) in registered
		if(!C)
			return
		C.select_look(usr)
		menu(usr)
		return TRUE

	if(href_list["update"])
		if(mind && mind.current)
			updateAppearances(mind.current)
			menu(usr)
		return TRUE

	return FALSE

////////////////////
//CHAMELEON ACTION
////////////////////

/datum/action/item_action/chameleon/drone/randomise
	name = "Randomise Headgear"
	button_icon_state = "random"

/datum/action/item_action/chameleon/drone/randomise/Trigger()
	if(!IsAvailable())
		return

	// Damn our lack of abstract interfeces
	if (istype(target, /obj/item/clothing/head/chameleon/drone))
		var/obj/item/clothing/head/chameleon/drone/X = target
		X.chameleon.random_look(owner)
	if (istype(target, /obj/item/clothing/mask/chameleon/drone))
		var/obj/item/clothing/mask/chameleon/drone/Z = target
		Z.chameleon.random_look(owner)

	return 1


/datum/action/item_action/chameleon/drone/togglehatmask
	name = "Toggle Headgear Mode"

/datum/action/item_action/chameleon/drone/togglehatmask/New()
	..()

	if (istype(target, /obj/item/clothing/head/chameleon/drone))
		button_icon_state = "drone_camogear_helm"
	if (istype(target, /obj/item/clothing/mask/chameleon/drone))
		button_icon_state = "drone_camogear_mask"

/datum/action/item_action/chameleon/drone/togglehatmask/Trigger()
	if(!IsAvailable())
		return

	// No point making the code more complicated if no non-drone
	// is ever going to use one of these

	var/mob/living/simple_animal/drone/D

	if(istype(owner, /mob/living/simple_animal/drone))
		D = owner
	else
		return

	// The drone unEquip() proc sets head to null after dropping
	// an item, so we need to keep a reference to our old headgear
	// to make sure it's deleted.
	var/obj/old_headgear = target
	var/obj/new_headgear

	if(istype(old_headgear,/obj/item/clothing/head/chameleon/drone))
		new_headgear = new /obj/item/clothing/mask/chameleon/drone()
	else if(istype(old_headgear,/obj/item/clothing/mask/chameleon/drone))
		new_headgear = new /obj/item/clothing/head/chameleon/drone()
	else
		to_chat(owner, "<span class='warning'>You shouldn't be able to toggle a camogear helmetmask if you're not wearing it</span>")
	if(new_headgear)
		// Force drop the item in the headslot, even though
		// it's NODROP
		D.unEquip(target, 1)
		qdel(old_headgear)
		// where is `slot_head` defined? WHO KNOWS
		D.equip_to_slot(new_headgear, slot_head)
	return 1



/*

/datum/action/item_action/chameleon/change
	name = "Chameleon Change"
	var/list/chameleon_blacklist = list()
	var/list/chameleon_list = list()
	var/chameleon_type = null
	var/chameleon_name = "Item"

/datum/action/item_action/chameleon/change/proc/initialize_disguises()
	if(button)
		button.name = "Change [chameleon_name] Appearance"
	chameleon_blacklist += target.type
	var/list/temp_list = subtypesof(chameleon_type)
	for(var/V in temp_list - (chameleon_blacklist))
		chameleon_list += V

/datum/action/item_action/chameleon/change/proc/select_look(mob/user)
	var/list/item_names = list()
	var/obj/item/picked_item
	for(var/U in chameleon_list)
		var/obj/item/I = U
		item_names += initial(I.name)
	var/picked_name
	picked_name = input("Select [chameleon_name] to change it to", "Chameleon [chameleon_name]", picked_name) as anything in item_names
	if(!picked_name)
		return
	for(var/V in chameleon_list)
		var/obj/item/I = V
		if(initial(I.name) == picked_name)
			picked_item = V
			break
	if(!picked_item)
		return
	update_look(user, picked_item)

/datum/action/item_action/chameleon/change/proc/random_look(mob/user)
	var/picked_item = pick(chameleon_list)
	// If a user is provided, then this item is in use, and we
	// need to update our icons and stuff

	if(user)
		update_look(user, picked_item)

	// Otherwise, it's likely a random initialisation, so we
	// don't have to worry

	else
		update_item(picked_item)

/datum/action/item_action/chameleon/change/proc/update_look(mob/user, obj/item/picked_item)
	if(isliving(user))
		var/mob/living/C = user
		if(C.stat != CONSCIOUS)
			return

		update_item(picked_item)

		C.regenerate_icons()	//so our overlays update.
	UpdateButtonIcon()

/datum/action/item_action/chameleon/change/proc/update_item(obj/item/picked_item)
	target.name = initial(picked_item.name)
	target.desc = initial(picked_item.desc)
	target.icon_state = initial(picked_item.icon_state)
	if(istype(target, /obj/item))
		var/obj/item/I = target
		I.item_state = initial(picked_item.item_state)
		I.item_color = initial(picked_item.item_color)
		if(istype(target, /obj/item/clothing))
			var/obj/item/clothing/CL = I
			var/obj/item/clothing/PCL = picked_item
			CL.flags_cover = initial(PCL.flags_cover)
			CL.flags_inv = initial(PCL.flags_inv)
			if(istype(target, /obj/item/clothing/under))
				var/obj/item/clothing/under/UCL = target
				var/obj/item/clothing/under/PUCL = picked_item
				UCL.can_adjust = initial(PUCL.can_adjust)
				if(!UCL.can_adjust && UCL.adjusted)
					UCL.toggle_jumpsuit_adjust()
					usr.update_inv_w_uniform()
	target.icon = initial(picked_item.icon)

/datum/action/item_action/chameleon/change/Trigger()
	if(!IsAvailable())
		return

	select_look(owner)
	return 1

*/

////////////////////
//CHAMELEON ITEMS
////////////////////

/obj/item/clothing/under/chameleon
//starts off as black
	name = "black jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	desc = "It's a plain jumpsuit. It has a small dial on the wrist."
	origin_tech = "syndicate=2"
	sensor_mode = 0 //Hey who's this guy on the Syndicate Shuttle??
	random_sensor = 0
	burn_state = FIRE_PROOF
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/under
	chameleon.chameleon_blacklist = list(/obj/item/clothing/under/shadowling,
		/obj/item/clothing/under/changeling,
		/obj/item/clothing/under/color/random,
		/obj/item/clothing/under/predator)
	chameleon.chameleon_name = "Jumpsuit"
	chameleon.initialize_disguises()

/obj/item/clothing/suit/chameleon
	name = "armor"
	desc = "A slim armored vest that protects against most types of damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	origin_tech = "syndicate=2"
	burn_state = FIRE_PROOF
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/tank/internals, /obj/item/device/flashlight, /obj/item/weapon/gun/energy/laser/chameleon)

/obj/item/clothing/suit/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/suit
	chameleon.chameleon_name = "Suit"
	chameleon.initialize_disguises()

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting condition."
	icon_state = "meson"
	item_state = "meson"
	origin_tech = "syndicate=2"
	burn_state = FIRE_PROOF
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/glasses/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/glasses
	chameleon.chameleon_name = "Glasses"
	chameleon.initialize_disguises()

/obj/item/clothing/gloves/chameleon
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"

	burn_state = FIRE_PROOF
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/gloves
	chameleon.chameleon_name = "Gloves"
	chameleon.initialize_disguises()

/obj/item/clothing/head/chameleon
	name = "grey cap"
	desc = "It's a baseball hat in a tasteful grey colour."
	icon_state = "greysoft"
	item_color = "grey"

	burn_state = FIRE_PROOF
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)

	var/datum/action/item_action/chameleon/change/chameleon_action = null

/obj/item/clothing/head/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/head
	chameleon.chameleon_name = "Hat"
	chameleon.initialize_disguises()

/obj/item/clothing/head/chameleon/drone
	// The camohat, I mean, holographic hat projection, is part of the
	// drone itself.
	flags = NODROP
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	// which means it offers no protection, it's just air and light

/obj/item/clothing/head/chameleon/drone/New()
	..()
	chameleon.random_look()
	var/datum/action/item_action/chameleon/drone/togglehatmask/togglehatmask_action = new(src)
	togglehatmask_action.UpdateButtonIcon()
	var/datum/action/item_action/chameleon/drone/randomise/randomise_action = new(src)
	randomise_action.UpdateButtonIcon()

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. While good for concealing your identity, it isn't good for blocking gas flow." //More accurate
	icon_state = "gas_alt"
	item_state = "gas_alt"
	burn_state = FIRE_PROOF
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)

	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH

	var/vchange = 1

	var/datum/action/item_action/chameleon/change/chameleon_action = null

/obj/item/clothing/mask/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/mask
	chameleon.chameleon_name = "Mask"
	chameleon.initialize_disguises()

/obj/item/clothing/mask/chameleon/attack_self(mob/user)
	vchange = !vchange
	to_chat(user, "<span class='notice'>The voice changer is now [vchange ? "on" : "off"]!</span>")


/obj/item/clothing/mask/chameleon/drone
	//Same as the drone chameleon hat, undroppable and no protection
	flags = NODROP
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	// Can drones use the voice changer part? Let's not find out.
	vchange = 0

/obj/item/clothing/mask/chameleon/drone/New()
	..()
	chameleon.random_look()
	var/datum/action/item_action/chameleon/drone/togglehatmask/togglehatmask_action = new(src)
	togglehatmask_action.UpdateButtonIcon()
	var/datum/action/item_action/chameleon/drone/randomise/randomise_action = new(src)
	randomise_action.UpdateButtonIcon()

/obj/item/clothing/mask/chameleon/drone/attack_self(mob/user)
	to_chat(user, "<span class='notice'>The [src] does not have a voice changer.</span>")

/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	item_color = "black"
	desc = "A pair of black shoes."
	permeability_coefficient = 0.05
	flags = SUPERNOSLIP
	origin_tech = "syndicate=3"
	burn_state = FIRE_PROOF
	can_hold_items = 1
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/clothing/shoes
	chameleon.chameleon_name = "Shoes"
	chameleon.initialize_disguises()

/obj/item/weapon/gun/energy/laser/chameleon
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/practice)
	clumsy_check = 0
	needs_permit = 0
	pin = /obj/item/device/firing_pin
	cell_type = /obj/item/weapon/stock_parts/cell/bluespace

/obj/item/weapon/gun/energy/laser/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/weapon/gun
	chameleon.chameleon_name = "Gun"
	chameleon.chameleon_blacklist = typesof(/obj/item/weapon/gun/magic)
	chameleon.initialize_disguises()

/obj/item/weapon/storage/backpack/chameleon
	name = "chameleon backpack"

/obj/item/weapon/storage/backpack/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.include_basetype = 1
	chameleon.chameleon_type = /obj/item/weapon/storage/backpack
	chameleon.chameleon_name = "Backpack"
	chameleon.initialize_disguises()

/obj/item/device/radio/headset/chameleon
	name = "chameleon headset"

/obj/item/device/radio/headset/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.include_basetype = 1
	chameleon.chameleon_type = /obj/item/device/radio/headset
	chameleon.chameleon_name = "Headset"
	chameleon.initialize_disguises()

/obj/item/device/pda/chameleon
	name = "chameleon PDA"

/obj/item/device/pda/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.include_basetype = 1
	chameleon.chameleon_type = /obj/item/device/pda
	chameleon.chameleon_name = "PDA"
	chameleon.chameleon_blacklist = list(/obj/item/device/pda/ai)
	chameleon.initialize_disguises()

/obj/item/weapon/storage/belt/military/chameleon
	name = "military belt"
	desc = "A syndicate belt designed to be used by boarding parties. Its style is modeled after the hardsuits they wear."
	icon_state = "militarybelt"
	item_state = "military"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/belt/military/chameleon/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.chameleon_type = /obj/item/weapon/storage/belt
	chameleon.chameleon_name = "Belt"
	chameleon.chameleon_blacklist = list()
	chameleon.initialize_disguises()
