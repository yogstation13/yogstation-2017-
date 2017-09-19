/obj/item/device/deadringer
	name = "strange device"
	icon_state = "motion0"
	var/ready = TRUE
	var/mob/living/carbon/human/dummy

/obj/item/device/deadringer/proc/trigger(mob/living/carbon/human/user)
	// Called in /mob/proc/check_deadringer,
	if(dummy)
		return dummy
	if(!istype(user) || !ready)
		return FALSE

	// Create a copy of our original human
	dummy = new(user.loc)
	dummy.real_name = user.real_name
	dummy.name = user.name
	dummy.underwear = user.underwear
	dummy.undershirt = user.undershirt
	dummy.socks = user.socks
	user.dna.transfer_identity(dummy, TRUE)
	dummy.updateappearance(mutcolor_update=1)
	dummy.update_body()
	dummy.domutcheck()
	dummy.setBruteLoss(user.getBruteLoss())
	dummy.setOxyLoss(user.getOxyLoss())
	dummy.setToxLoss(user.getToxLoss())
	dummy.setFireLoss(user.getFireLoss())
	dummy.setCloneLoss(user.getCloneLoss())
	dummy.setStaminaLoss(user.getStaminaLoss())

	for(var/slot in list(slot_w_uniform, slot_back, slot_wear_mask, slot_handcuffed, slot_legcuffed, slot_l_hand, slot_r_hand, slot_belt, slot_wear_id, slot_ears, slot_glasses, slot_gloves, slot_head, slot_shoes, slot_wear_suit, slot_l_store, slot_r_store, slot_s_store))
		dummy.equip_to_slot(create_dummy_item(user.get_item_by_slot(slot)), slot)

	dummy.regenerate_icons()

	var/old_invis = user.invisibility
	user.invisibility = INVISIBILITY_OBSERVER
	var/revoke_sight = !(user.sight & SEE_SELF)
	user.sight |= SEE_SELF
	user.alpha = 50
	ready = FALSE
	flags |= NODROP
	user.next_move = world.time + 50 // Prevent the user from clicking on anything for the next 5 seconds.
	icon_state = "motion1"
	addtimer(src, "lose_invuln", 20)
	addtimer(src, "lose_invis", 50, FALSE, user, old_invis, revoke_sight)
	return dummy

/obj/item/device/deadringer/proc/lose_invuln()
	dummy = null
/obj/item/device/deadringer/proc/lose_invis(mob/user, old_invis, revoke_sight)
	user.invisibility = old_invis
	animate(user, alpha = 255, time = 20)
	if(revoke_sight)
		user.sight &= ~SEE_SELF
	playsound(user.loc, 'sound/effects/spy_uncloak_feigndeath.ogg', 100, FALSE)
	flags &= ~NODROP
	icon_state = "motion2"
	addtimer(src, "recharge", 600)

/obj/item/device/deadringer/proc/recharge()
	ready = TRUE
	icon_state = "motion0"

/obj/item/device/deadringer/proc/create_dummy_item(obj/item/I)
	if(!I || I == src)
		return
	var dummytype = /obj/item
	if(istype(I, /obj/item/clothing/cloak))
		dummytype = /obj/item/clothing/cloak
	if(istype(I, /obj/item/clothing/ears))
		dummytype = /obj/item/clothing/ears
	if(istype(I, /obj/item/clothing/glasses))
		dummytype = /obj/item/clothing/glasses
	if(istype(I, /obj/item/clothing/gloves))
		dummytype = /obj/item/clothing/gloves
	if(istype(I, /obj/item/clothing/head))
		dummytype = /obj/item/clothing/head
	if(istype(I, /obj/item/clothing/mask))
		dummytype = /obj/item/clothing/mask
	if(istype(I, /obj/item/clothing/shoes))
		dummytype = /obj/item/clothing/shoes
	if(istype(I, /obj/item/clothing/suit))
		dummytype = /obj/item/clothing/suit
	if(istype(I, /obj/item/clothing/tie))
		dummytype = /obj/item/clothing/tie
	if(istype(I, /obj/item/clothing/under))
		dummytype = /obj/item/clothing/under
	var/obj/item/dummy_item = new dummytype
	dummy_item.flags |= DROPDEL
	dummy_item.appearance = I.appearance
	dummy_item.item_state = I.item_state
	dummy_item.lefthand_file = I.lefthand_file
	dummy_item.righthand_file = I.righthand_file
	dummy_item.w_class = I.w_class
	dummy_item.flags_cover = I.flags_cover
	dummy_item.flags_inv = I.flags_inv
	dummy_item.alternate_worn_icon = I.alternate_worn_icon
	return dummy_item
