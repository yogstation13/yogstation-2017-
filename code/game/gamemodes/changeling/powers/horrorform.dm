/obj/effect/proc_holder/changeling/horrorform
	name = "Horror Form"
	desc = "We transform into a greater lifeform. We cannot maintain this form forever, though, and will return to normal once we lose our chemicals or sustain enough damage."
	chemical_cost = 0
	dna_cost = 0
	genetic_damage = 0
	req_human = 1
	max_genetic_damage = 0


/obj/effect/proc_holder/changeling/horrorform/sting_action(mob/living/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/mob/living/carbon/human/H = user
	if(user.stat || !ishuman(user))
		return
	if(changeling.absorbedcount < 1)
		to_chat(user, "<span class='warning'>We require one absorbed lifeform to be able to do this.</span>")
		return
	if(changeling.chem_charges < 20)//no spamming it with 5 chems, you won't get anything done anyway
		to_chat(user, "<span class='warning'>We require sufficient chemicals to use this ability.</span>")
		return
	if(user.health < 35)//amount of health that makes you revert
		to_chat(user, "<span class='warning'>We are too hurt to sustain such power.</span>")
		return
	if(isabomination(H))//can't transform twice at once
		to_chat(user, "<span class='warning'>You're already transformed!</span>")
		return
	var/transform_or_no=alert(user,"Are you sure you want to transform?",,"Yes","No")
	switch(transform_or_no)
		if("No")
			to_chat(user, "<span class='warning'>You opt not to transform.")
			return
		if("Yes")
			if(changeling.transforming)
				to_chat(user, "<span class='warning'>You're transforming, hold on.</span>")
				return
			if(isabomination(H))
				to_chat(user, "<span class='warning'>You're already transformed!</span>")
				return
			if(changeling.geneticdamage > 15)
				to_chat(user, "<span class='warning'>Your genomes are too damaged to allow you to transform.</span>")
				return
			changeling.transforming = TRUE
			changeling.geneticdamage += 5
			user.Stun(INFINITY)
			for(var/obj/item/I in user) //drops all items
				user.unEquip(I)
			user.visible_message("<span class='warning'>[user]'s body contorts unnaturally and they slip out of their clothes!</span>")
			user <<"<span class='warning'>You contort your body and drop any restrictive clothing.</span>"
			sleep(30)

			playsound(user.loc, 'sound/effects/creepyshriek.ogg', 100, 1, extrarange = 30)
			user.visible_message("<span class='warning'><b>[user] lets out an abhorrent screech as their height suddenly increases, their body parts splitting and deforming horribly!</span>")
			user <<"<span class='notice'>You are a shambling abomination! You are amazingly powerful and have new abilities, but you cannot use any other changeling abilities and lose chemicals quickly. Remember, taking too much damage or running out of chemicals will revert you and leave you vulnerable. Check the 'Abomination' spell tab to use your abilities. Remember, you can maintain this form by using your 'Devour' ability whilst grabbing a humanoid to devour them and gain chemicals!</span>"
			user <<"<span class='notice'>You are amazingly powerful and have new abilities, but you cannot use any other changeling abilities and lose chemicals quickly.</span>"
			user <<"<span class='notice'>Remember, taking too much damage or running out of chemicals will revert you and leave you vulnerable.</span>"
			user <<"<span class='notice'>Check the 'Abomination' spell tab to use your abilities. The 'Devour' ability will allow you to eat a grabbed humanoid and gain chemicals from them!</span>"
			H.restore_blood()
			H.remove_all_embedded_objects()
			var/list/missing = H.get_missing_limbs()
			if(missing.len)
				H.regenerate_limbs(1)
			H.underwear = "Nude"
			H.undershirt = "Nude"
			H.socks = "Nude"
			var/newNameId = "Shambling Abomination"
			user.real_name = newNameId
			user.name = usr.real_name
			user.SetParalysis(0)
			user.SetStunned(0)
			user.SetWeakened(0)
			user.reagents.clear_reagents()
			for(var/obj/item/I in user) //cuffing while permastunned was a shit oversight
				user.unEquip(I)
			for(var/obj/item/I in user) //in case any weird stuff happens with flesh clothing
				qdel(I)
			user.equip_to_slot_or_del(new /obj/item/clothing/shoes/abomination(user), slot_shoes)
			user.equip_to_slot_or_del(new /obj/item/clothing/suit/space/abomination(user), slot_wear_suit)
			user.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/abomination(user), slot_head)
			user.equip_to_slot_or_del(new /obj/item/clothing/gloves/abomination(user), slot_gloves)
			user.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/abomination(user), slot_wear_mask)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/shadowling/abomination(user), slot_glasses)
			H.set_species(/datum/species/abomination)
			changeling.mimicing = ""
			changeling.chem_recharge_rate = 0
			changeling.chem_recharge_slowdown = (18/changeling.absorbedcount)
			if(changeling.chem_recharge_slowdown < 2)
				changeling.chem_recharge_slowdown = 2
			user.status_flags -= GOTTAGOFAST
			changeling.transforming = FALSE


//hulk
			var/datum/mutation/human/HM = mutations_list[HULK]
			if(H.dna && H.dna.mutations)
				H.dna.remove_all_mutations() //no TK or invisible horrorform
				HM.force_give(H)

//spells
				for(var/spell in user.mind.spell_list) //no duping spells if you manage to transform multiple times without reverting
					if(istype(spell, /obj/effect/proc_holder/spell/targeted/abomination)|| istype(spell, /obj/effect/proc_holder/spell/aoe_turf/abomination))
						user.mind.spell_list -= spell
						qdel(spell)
				user.mind.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/abomination/screech
				//user.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/abomination/abom_fleshmend //replaced with constant healing, hopefully not too op
				user.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/abomination/devour
				user.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/abomination/abom_revert

//forced reversion and healing

//abomination stuff
/datum/species/abomination
	name = "???"
	id = "abomination"
	specflags = list(NOBREATH,COLDRES,NOGUNS,VIRUSIMMUNE,PIERCEIMMUNE,RADIMMUNE,NODISMEMBER)
	sexes = 0
	speedmod = 3
	armor = 0//has horror armor instead
	punchdamagelow = 30
	punchdamagehigh = 30
	punchstunthreshold = 30 //100 % chance
	no_equip = list(slot_w_uniform, slot_back, slot_ears)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	heatmod = 1.5
	can_grab_items = FALSE //no picking stuff up grr
	blacklisted = 1

/datum/species/abomination/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	handle_body(C)

/datum/species/abomination/on_species_loss(mob/living/carbon/C)
	C.icon_state = initial(C.icon_state)

/datum/species/abomination/handle_body(mob/living/carbon/human/H)
	H.icon_state = "abomination_s"
	return

/datum/species/abomination/spec_life(mob/living/carbon/human/user)
	if(user.health < 100 && prob(40))
		var/mob/living/carbon/human/H = user
		H.adjustBruteLoss(-4)
		H.adjustFireLoss(-4)
		H.adjustOxyLoss(-10)
		H.adjustToxLoss(-10)
		H.adjustStaminaLoss(-10)
		if(prob(25))
			H.visible_message("<span class='warning'>[H]'s skin shifts around itself, some of its wounds vanishing.</span>")

	var/datum/changeling/changeling = user.mind.changeling
	if(user.health < 35)
		user.visible_message("<span class='warning'>[user] sustains too much damage to continue their transformation, and collapses!</span>")
		to_chat(user, "<span class='notice'>You could not transform back correctly, which disfigures you and scrambles your genetic code!</span>")
		var/mob/living/carbon/human/H = user
		var/datum/mutation/human/HM = mutations_list[HULK]
		if(H.dna && H.dna.mutations)
			HM.force_lose(H)
		changeling.reverting = 1
		changeling.geneticdamage += 30
		user.Weaken(15)
		user.apply_damage(30, CLONE)

	if(changeling.chem_charges == 0)
		user.visible_message("<span class='warning'>[user] suddenly shrinks back down to a normal size.</span>")
		to_chat(user, "<span class='notice'>You ran out of chemicals before you could revert properly, disfiguring you!</span>")
		var/mob/living/carbon/human/H = user
		var/datum/mutation/human/HM = mutations_list[HULK]
		if(H.dna && H.dna.mutations)
			HM.force_lose(H)
		changeling.reverting = 1
		changeling.geneticdamage += 10
		user.Weaken(5)


	if(changeling.reverting == 1)
		changeling.chem_recharge_rate = 1
		changeling.chem_recharge_slowdown = 0
		for(var/obj/item/I in user) // removes any item, the only thing I can think of is cuffs
			user.unEquip(I)
		for(var/obj/item/I in user) // removes the abomination armor
			qdel(I)
		var/mob/living/carbon/human/H = user
		H.set_species(/datum/species/deformed)//regular human doesn't work due to a bug with set_species, humans are invisible
		var/newNameId = "deformed humanoid" //makes it more obvious that they were an abomination
		user.real_name = newNameId
		for(var/spell in user.mind.spell_list)
			if(istype(spell, /obj/effect/proc_holder/spell/targeted/abomination)|| istype(spell, /obj/effect/proc_holder/spell/aoe_turf/abomination))
				user.mind.spell_list -= spell
				qdel(spell)
		user.dna.species.invis_sight = initial(user.dna.species.invis_sight)
		changeling.reverting = 0


	feedback_add_details("changeling_powers","HF")
	return 1