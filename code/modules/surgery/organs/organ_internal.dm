/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/mob/living/carbon/owner = null
	var/status = ORGAN_ORGANIC
	origin_tech = "biotech=3"
	force = 1
	w_class = 2
	throwforce = 0
	var/zone = "chest"
	var/slot
	// DO NOT add slots with matching names to different zones - it will break internal_organs_slot list!
	var/vital = 0
	var/decay_time = 0
	var/decay = 0

/obj/item/organ/New()
	..()
	if(decay_time)
		START_PROCESSING(SSobj, src)

/obj/item/organ/process()
	handle_decay()

/obj/item/organ/proc/handle_decay()
	if(owner && !(owner.stat & DEAD))
		decay = max(0, decay-1)
	else
		var/temperature
		if(owner)
			temperature = owner.bodytemperature
		else
			var/datum/gas_mixture/air = return_air()
			if(!air)
				return
			temperature = air.temperature

		if(temperature > T0C - 10)
			decay = min(decay_time, decay + 1)
	if(decay >= decay_time)
		STOP_PROCESSING(SSobj, src)

/obj/item/organ/proc/Insert(mob/living/carbon/M, special = 0, del_replaced = 1)
	if(!iscarbon(M) || owner == M)
		return 0
	if(!special && ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.dna && H.dna.species)
			if(!H.dna.species.can_accept_organ(H, src))
				return 0

	var/obj/item/organ/replaced = M.getorganslot(slot)
	if(replaced)
		replaced.Remove(M, 1, del_replaced)

	owner = M
	M.internal_organs |= src
	M.internal_organs_slot[slot] = src
	if(ismob(loc))
		var/mob/Mloc = loc
		Mloc.unEquip(src, 1)
	forceMove(get_turf(M))
	loc = null
	for(var/X in actions)
		var/datum/action/A = X
		A.Grant(M)
	return 1


/obj/item/organ/proc/Remove(mob/living/carbon/M, special = 0, del_after = 0)
	owner = null
	if(M)
		M.internal_organs -= src
		if(M.internal_organs_slot[slot] == src)
			M.internal_organs_slot.Remove(slot)
		if(vital && !special)
			M.death()
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(M)
	if(del_after)
		qdel(src)
	else
		forceMove(M.loc)


/obj/item/organ/proc/on_find(mob/living/finder)
	return

/obj/item/organ/proc/on_life()
	return

/obj/item/organ/examine(mob/user)
	..()
	if(status == ORGAN_ROBOTIC && crit_fail)
		to_chat(user, "<span class='warning'>[src] seems to be broken!</span>")


/obj/item/organ/proc/prepare_eat()
	var/obj/item/weapon/reagent_containers/food/snacks/organ/S = new
	S.name = name
	S.desc = desc
	S.icon = icon
	S.icon_state = icon_state
	S.origin_tech = origin_tech
	S.w_class = w_class

	return S

/obj/item/weapon/reagent_containers/food/snacks/organ
	name = "appendix"
	icon_state = "appendix"
	icon = 'icons/obj/surgery.dmi'
	list_reagents = list("nutriment" = 5)
	foodtype = RAW | MEAT | GROSS


/obj/item/organ/Destroy()
	if(owner)
		Remove(owner, 1)
	return ..()

/obj/item/organ/attack(mob/living/carbon/M, mob/user)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(status == ORGAN_ORGANIC)
			var/obj/item/weapon/reagent_containers/food/snacks/S = prepare_eat()
			if(S)
				H.drop_item()
				H.put_in_active_hand(S)
				S.attack(H, H)
				qdel(src)
	else
		..()

/obj/item/organ/item_action_slot_check(slot,mob/user)
	return //so we don't grant the organ's action to mobs who pick up the organ.

/obj/item/organ/attackby(obj/item/I, mob/user, proximity_flag)
	if(!proximity_flag)
		return 0
	if(is_health_analyzer(I))
		if(decay_time)
			if(decay >= decay_time)
				to_chat(user, "<span class='notice'>\The [src] has decayed beyond the point of no return.</span>")
			else
				to_chat(user, "<span class='notice'>\The [src] is [round(decay / decay_time, 0.1)]% decayed.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] will not decay.</span>")
		return 1
	return 0

//Looking for brains?
//Try code/modules/mob/living/carbon/brain/brain_item.dm
/obj/item/organ/shadowtumor
	name = "black tumor"
	desc = "A tiny black mass with red tendrils trailing from it. It seems to shrivel in the light."
	icon_state = "blacktumor"
	origin_tech = "biotech=5"
	w_class = 1
	zone = "head"
	slot = "brain_tumor"
	var/health = 3

/obj/item/organ/shadowtumor/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/organ/shadowtumor/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/organ/shadowtumor/process()
	if(isturf(loc))
		var/turf/T = loc
		var/light_count = T.get_lumcount()
		if(light_count > LIGHT_DAM_THRESHOLD && health > 0) //Die in the light
			health--
		else if(light_count < LIGHT_HEAL_THRESHOLD && health < 3) //Heal in the dark
			health++
		if(health <= 0)
			visible_message("<span class='warning'>[src] collapses in on itself!</span>")
			qdel(src)
