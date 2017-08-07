
////////////////////
////////600/////////
////////////////////

/obj/effect/proc_holder/vampire/strongclearstuns
	name = "Upgraded Clear Stuns"
	desc = "Remove all stuns and stamina damage from yourself, become stun resistant for a short period of time, and slightly heal yourself."
	req_bloodcount = 250
	action_icon_state = "cancelstuns_2"

/obj/effect/proc_holder/vampire/strongclearstuns/fire(mob/living/carbon/human/H)
	if(!..())
		return

	H << "<span class='noticevampire'>You feel a sudden burst of energy overcome you.</span>"
	H.SetSleeping(0)
	H.SetParalysis(0)
	H.SetStunned(0)
	H.SetWeakened(0)
	H.adjustStaminaLoss(-(H.getStaminaLoss()))
	if(H.reagents.get_reagent_amount("stimulants") < 60 && H.reagents.get_reagent_amount("stimulants") + 30 <= 60)
		H.reagents.add_reagent("stimulants", 30)
	if(H.reagents.get_reagent_amount("omnizine") < 30 && H.reagents.get_reagent_amount("omnizine") + 10 <= 30)
		H.reagents.add_reagent("omnizine", 10) // while stimulants do heal, I want to make sure that they're getting something out of this 100%

	feedback_add_details("vampire_powers","clear stuns 2")
	return 1

/obj/effect/proc_holder/vampire/cloakofdarkness
	name = "Cloak of Darkness"
	desc = "Blend into the darkness. You become less visible the darker the area you are in."
	req_bloodcount = 250
	human_req = TRUE

/obj/effect/proc_holder/vampire/cloakofdarkness/fire(mob/living/carbon/human/H)
	if(!..())
		return
	var/datum/mutation/human/HM = mutations_list[STEALTH]
	if(HM in H.dna.mutations)
		HM.force_lose(H)
	else
		HM.force_give(H)

	feedback_add_details("vampire_powers","cloak_of_dark")
	return 1


#define RENDGHOST_MONEYCOUNT 20

/obj/effect/proc_holder/vampire/rendghost
	name = "Rend Ghost"
	desc = "Devour a ghost, claim their soul, and regenerate lost blood."
	cooldownlen = 1200
	req_bloodcount = 250
	action_icon_state = "biteghost"

/obj/effect/proc_holder/vampire/rendghost/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/mob/dead/observer/chosenone

	for(var/mob/dead/observer/O in view(1, get_turf(H)))
		if(chosenone)
			break
		if(O.real_name == "lost soul")
			continue
		if(!chosenone)
			O << "<span class='warning'>[H] scratches at your floating waist, reeling you in!</span>"
			chosenone = O
			var/oldtransform = transform
			animate(H, transform = matrix()*2, alpha = 0, time = 5) // rune invoke. this'll make it pop out.
			animate(transform = oldtransform, alpha = 255, time = 0)

	H.visible_message("<span class='notice'>[H] reaches his hand into the air and grabs something.</span>",\
		"<span class='notice'>[H] reaches his hand into the air and grabs something.</span>")

	H << "<span class='noticevampire'>You suck away [chosenone]'s soul!</span>"
	chosenone.real_name = "lost soul"
	chosenone.name = "lost soul [rand(1,1000)]"
	chosenone.can_reenter_corpse = 0 // admins can hit aghost or edit their vars

	chosenone.say("I'M LOST! THE VAMPIRE [H.real_name] HAS TAKEN MY SOUL!!!")
	flash_color(chosenone, color = "#FF0000", time = 10)

	if(H.mind)
		if(H.mind.vampire)
			if(H.mind.vampire.bloodcount < H.mind.vampire.get_limit())
				H.mind.vampire.bloodcount += min(H.mind.vampire.bloodcount + RENDGHOST_MONEYCOUNT, H.mind.vampire.get_limit())
	feedback_add_details("vampire_powers","rend ghost")
	return 1

#undef RENDGHOST_MONEYCOUNT