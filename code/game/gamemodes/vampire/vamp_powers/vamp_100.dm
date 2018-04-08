//////////////////////////////////////////////////
///////////////	100 ABILITIES ////////////////////
//////////////////////////////////////////////////


/obj/effect/proc_holder/vampire/clearstuns
	name = "Clear Stuns"
	desc = "Remove all stuns and stamina damage from yourself."
	blood_cost = 25
	cooldownlen = 150
	action_icon_state = "cancelstuns"

/obj/effect/proc_holder/vampire/clearstuns/fire(mob/living/carbon/human/H)
	if(!..())
		return

	H << "<span class='noticevampire'>You feel a rush of energy overcome you.</span>"
	H.SetSleeping(0)
	H.SetParalysis(0)
	H.SetStunned(0)
	H.SetWeakened(0)
	H.adjustStaminaLoss(-(H.getStaminaLoss()))

	feedback_add_details("vampire_powers","clear stuns")
	return 1


/obj/effect/proc_holder/vampire/hypno
	name = "Hypnotize"
	desc = "Knock out your target. (Use the middle mouse button after activating)"
	cooldownlen = 300
	blood_cost = 20
	action_icon_state = "hypnotize"
	pay_blood_immediately = FALSE
	cooldown_immediately = FALSE

/obj/effect/proc_holder/vampire/hypno/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/V = H.mind.vampire

	if(!checkout_click_attack(H, V))
		return

	V.chosen_click_attack = src
	H << "<span class='vampirealert'>[src] is now active. (Use your middle mouse button on anyone \
		to use.)"
	H.visible_message("<span class='warning'>[H] twirls their finger in a circlular motion.</span>",\
					"<span class='warning'>[H] twirls their finger in a circular motion.</span>")
	return 1

/obj/effect/proc_holder/vampire/hypno/action_on_click(mob/living/carbon/human/H, datum/vampire/V, atom/target)
	if(!..())
		return
	if(!isliving(target))
		return
	if(!ishuman(target))
		H << "<span class='vampirealert'>Hypnotize will not work on this being.</span>"
		return

	var/mob/living/carbon/human/T = target
	if(T.sleeping)
		H << "<span class='vampirewarning'>[T] is already asleep!.</span>"
		return

	H.visible_message("<span class='warning'>[H]'s eyes flash red.</span>",\
					"<span class='warning'>[H]'s eyes flash red.</span>")
	if(istype(target, /mob/living/carbon/human))
		var/obj/item/clothing/glasses/G = T.glasses
		if(G)
			if(G.flash_protect)
				if(V && !(V.eighthundred_unlocked))
					H << "<span class='vampirewarning'>[T] has protective sunglasses on!</span>"
					target << "<span class='warning'>[H]'s paralyzing gaze is blocked by [G]!</span>"
					return
		var/obj/item/clothing/mask/M = T.wear_mask
		if(M)
			if(M.flags_cover & MASKCOVERSEYES)
				if(V && !(V.eighthundred_unlocked))
					H << "<span class='vampirewarning'>[T]'s mask is covering their eyes!</span>"
					target << "<span class='warning'>[H]'s paralyzing gaze is blocked by [M]!</span>"
					return
	target << "<span class='warning'>Your knees suddenly feel heavy. Your body begins to sink to the floor.</span>"
	H << "<span class='alertvampire'>[target] is now under your spell. In four seconds they will be rendered unconscious as long as they are within close range.</span>"
	addtimer(src, "sleeptarget", 40, TRUE, target, H) // 4 seconds...

	feedback_add_details("vampire_powers","hypnotize")


/obj/effect/proc_holder/vampire/hypno/proc/sleeptarget(mob/living, mob/user) // in the future, make it check for a range so that the target can get away? or make it check for a garlic necklace.
	if (living)
		if(get_dist(user, living) <= 7) // 7 range
			flash_color(living, color = "#472040", time = 30) // it's the vampires color!
			living.AdjustSleeping(30)
			user << "<span class='alertvampire'>[living] has fallen asleep!</span>"
		else
			living << "<span class='notice'>You feel a whole lot better now.</span>"