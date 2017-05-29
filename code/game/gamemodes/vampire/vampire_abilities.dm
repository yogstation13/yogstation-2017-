/mob/living/carbon/proc/AddVampireSpell(obj/effect/proc_holder/vampire/A)
	abilities.Add(A)
	if(A.has_action)
		A.action.Grant(src)

/mob/living/carbon/proc/RemoveVampireSpell(obj/effect/proc_holder/vampire/A)
	abilities.Remove(A)
	if(A.action)
		A.action.Remove(src)

/*
This is practically custom spell code like alien or changeling.
	USE THIS FOR ACTION BUTTONS:
	/datum/action/spell_action/vampire
*/

/obj/effect/proc_holder/vampire
	panel = "Vampire"
	name = "generic vampire"
	desc = "TALK TO A CODER IF YOU SEE THIS!"
	panel = "Vampire" // remove later after action buttons get added.
	var/blood_cost = 0
	var/pay_blood_immediately = TRUE // will we take blood from the spell immediately?
	var/cooldown_immediately = TRUE
	var/human_req = FALSE // does this spell require you to be human?
	var/onCD
	var/cooldownlen
	var/req_bloodcount

	var/clickdelay = 5 // delay after middle mouse button click.

	var/has_action = TRUE
	var/datum/action/spell_action/vampire/action = null
	var/action_icon = 'icons/mob/actions.dmi'
	var/action_icon_state = "animal_love"
	var/action_background_icon_state = "bg_default_on"

/obj/effect/proc_holder/vampire/New()
	. = ..()
	if(has_action)
		action = new(src)

/obj/effect/proc_holder/vampire/proc/force_drainage(amt, datum/vampire/V)
	if(!amt)
		return
	if(!V)
		return
	V.bloodcount -= amt

/obj/effect/proc_holder/vampire/proc/fire(mob/living/carbon/human/H)
	if(ishuman(H))
		if(!checkbloodcost(H))
			return FALSE
	else
		if(human_req)
			return FALSE
	if(cooldown_immediately)
		switchonCD(cooldownlen)
	if(action)
		action.UpdateButtonIcon()
	return TRUE

/obj/effect/proc_holder/vampire/proc/switchonCD(time) // alternative to turnOnCD which turns it on, but sets a timer to turn it off. might merge with other proc later.
	if(onCD)
		return
	turnOnCD()
	addtimer(src, "turnOffCD", time)

/obj/effect/proc_holder/vampire/proc/checkbloodcost(mob/living/carbon/human/H)
	if(blood_cost)
		if(H.mind.vampire)
			if(H.mind.vampire.bloodcount - blood_cost < 0)
				H << "<span class='alertvampire'>You lack the blood to perform this technique...</span>"
				return FALSE
			else
				if(req_bloodcount)
					if(H.mind.vampire.bloodcount < req_bloodcount)
						H << "<span class='alertvampire'>You need at least [req_bloodcount] to use this technique...</span>"
						return FALSE
				return TRUE
		else
			return FALSE
	else
		return TRUE

/obj/effect/proc_holder/vampire/Click()
	if(!ishuman(usr))
		return TRUE

	var/mob/living/carbon/human/H = usr

	if(!H.mind.vampire)
		H.RemoveVampireSpell(src)
		return 1

	if(H.mind.vampire.isDraining)
		usr << "<span class='alertvampire'>You can't use abilities while draining blood.</span>"
		return 1

	if(fire(H))
		if(pay_blood_immediately)
			force_drainage(blood_cost, H.mind.vampire)

/obj/effect/proc_holder/vampire/proc/turnOnCD()
	onCD = TRUE
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/vampire/proc/turnOffCD()
	onCD = FALSE
	if(action)
		action.UpdateButtonIcon()

// we are clicking the target during this. check click.dm for more. middle mouse button
/obj/effect/proc_holder/vampire/proc/action_on_click(mob/living/carbon/human/H, datum/vampire/V, atom/target)
	if(onCD)
		if(H)
			H << "<span class='noticevampire'>[src] is on a cooldown.</span>"
		return 0
	switchonCD(cooldownlen)
	return 1

/obj/effect/proc_holder/vampire/proc/checkout_click_attack(mob/M, datum/vampire/V)
	if(!V)
		return FALSE

	if(V.chosen_click_attack)
		if(src == V.chosen_click_attack)
			V.chosen_click_attack = null
			M << "<span class='noticevampire'>[src] has been deactivated.</span>"
			return FALSE
		else
			M << "<span class='alertvampire'>You already have another click-attack technique active ([V.chosen_click_attack.name])</span>"
			//turnOnCD()
			return FALSE
	else
		return TRUE