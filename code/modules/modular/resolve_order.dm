//This allows us to control what gets resolved and in which order
// list/allowed - which slots are allowed to be inserted
// list/order   - the actual order of slots

// Datum uses clothing slot defines from code/_DEFINES/clothing.dm to define allowed slots/their order
/datum/resolve_order
	var/list/allowed
	var/list/order
	var/allow_repeat_slots = FALSE

/datum/resolve_order/human
	allowed = list(slot_head, slot_wear_mask, slot_wear_suit, slot_w_uniform, slot_gloves, slot_shoes, slot_l_store, slot_r_store, slot_belt, slot_back, slot_s_store, slot_wear_id, slot_r_hand, slot_l_hand)

/datum/resolve_order/mob
	allowed = list(slot_r_hand, slot_l_hand)

/datum/resolve_order/carbon
	allowed = list(slot_head, slot_wear_mask, slot_back, slot_r_hand, slot_l_hand)

/datum/resolve_order/New(list/order)
	append(order)

/datum/resolve_order/proc/append(list/order)
	if(!src.order)
		src.order = list()
	if(!islist(order))
		if((order in allowed) && (!(order in src.order) || allow_repeat_slots))
			src.order += order
	else
		for(var/v in order)
			if((v in allowed) && (!(v in src.order) || allow_repeat_slots))
				src.order += v

/datum/resolve_order/human/attack/default
	order = list(slot_head, slot_wear_suit, slot_w_uniform, slot_gloves)

//Try to resolve the currently held item first
/datum/resolve_order/proc/append_hands(active_hand)
	if(active_hand)
		append(slot_l_hand)
		append(slot_r_hand)
	else
		append(slot_r_hand)
		append(slot_l_hand)

/datum/resolve_order/human/defense/New(active_hand)
	append_hands(active_hand)

/datum/resolve_order/human/defense/head/New(active_hand)
	..()
	append(slot_head)

/datum/resolve_order/human/defense/body/New(active_hand)
	..()
	append(slot_wear_suit)
	append(slot_w_uniform)

/datum/resolve_order/human/defense/legs/New(active_hand)
	..()
	append(slot_wear_suit)
	append(slot_w_uniform)
	append(slot_shoes)