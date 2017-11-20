/obj/effect/proc_holder/changeling/transform
	name = "Transform"
	desc = "We take on the appearance and voice of one we have absorbed."
	chemical_cost = 5
	dna_cost = 0
	req_dna = 1
	req_human = 1
	max_genetic_damage = 3

/obj/item/clothing/glasses/changeling
	name = "flesh"
	flags = NODROP | DROPDEL

/obj/item/clothing/glasses/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/clothing/under/changeling
	name = "flesh"
	flags = NODROP | DROPDEL

/obj/item/clothing/under/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/clothing/suit/changeling
	name = "flesh"
	flags = NODROP | DROPDEL
	allowed = list(/obj/item/changeling)

/obj/item/clothing/suit/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/clothing/head/changeling
	name = "flesh"
	flags = NODROP | DROPDEL

/obj/item/clothing/head/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/clothing/shoes/changeling
	name = "flesh"
	flags = NODROP | DROPDEL

/obj/item/clothing/shoes/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/clothing/gloves/changeling
	name = "flesh"
	flags = NODROP | DROPDEL

/obj/item/clothing/gloves/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/clothing/mask/changeling
	name = "flesh"
	flags = NODROP | DROPDEL

/obj/item/clothing/mask/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

/obj/item/changeling
	name = "flesh"
	flags = NODROP | DROPDEL
	slot_flags = ALL

/obj/item/changeling/attack_hand(mob/user)
	if(loc == user && user.mind && user.mind.changeling)
		flags &= ~NODROP
		to_chat(user, "<span class='notice'>You absorb [src] into your body.</span>")
		user.put_in_active_hand(src)
		user.visible_message("<span class='warning'>[src] crumbles into flakes of... something.</span>", , 3)
		user.drop_item()

//Change our DNA to that of somebody we've absorbed.
/obj/effect/proc_holder/changeling/transform/sting_action(mob/living/carbon/human/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/datum/changelingprofile/chosen_prof = changeling.select_dna("Select the target DNA: ", "Target DNA", user)

	if(!chosen_prof)
		return

	changeling_transform(user, chosen_prof)

	feedback_add_details("changeling_powers","TR")
	return 1

/datum/changeling/proc/select_dna(var/prompt, var/title, var/mob/living/carbon/user, drop_flesh_disguise = TRUE)
	var/list/names = drop_flesh_disguise ? list("Drop Flesh Disguise") : list()
	for(var/datum/changelingprofile/prof in stored_profiles)
		names += "[prof.name]"

	var/chosen_name = input(prompt, title, null) as null|anything in names
	if(!chosen_name)
		return

	if(chosen_name == "Drop Flesh Disguise")
		for(var/slot in slots)
			if(istype(user.vars[slot], slot2type[slot]))
				qdel(user.vars[slot])

	var/datum/changelingprofile/prof = get_dna(chosen_name)
	return prof
