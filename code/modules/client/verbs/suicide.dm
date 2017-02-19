/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
	var/oldkey = ckey
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(ckey != oldkey)
		return
=======
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		log_game("[key_name(src)] (job: [job ? "[job]" : "None"]) commited suicide at [get_area(src)].")
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		var/obj/item/held_item = get_active_hand()
=======
		var/obj/item/held_item = get_active_held_item()
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				if(damagetype & SHAME)
					adjustStaminaLoss(200)
					suiciding = 0
					return
				var/damage_mod = 0
				for(var/T in list(BRUTELOSS, FIRELOSS, TOXLOSS, OXYLOSS))
					damage_mod += (T & damagetype) ? 1 : 0
				damage_mod = max(1, damage_mod)

				//Do 200 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(200/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(200/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(200/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(200/damage_mod)

				//If something went wrong, just do normal oxyloss
				if(!(damagetype & (BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS) ))
					adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				death(0)
				return

<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		var/suicide_message = pick("[src] is attempting to bite \his tongue off! It looks like \he's trying to commit suicide.", \
							"[src] is jamming \his thumbs into \his eye sockets! It looks like \he's trying to commit suicide.", \
							"[src] is twisting \his own neck! It looks like \he's trying to commit suicide.", \
							"[src] is holding \his breath! It looks like \he's trying to commit suicide.")
=======
		var/suicide_message = pick("[src] is attempting to bite [p_their()] tongue off! It looks like [p_theyre()] trying to commit suicide.", \
							"[src] is jamming [p_their()] thumbs into [p_their()] eye sockets! It looks like [p_theyre()] trying to commit suicide.", \
							"[src] is twisting [p_their()] own neck! It looks like [p_theyre()] trying to commit suicide.", \
							"[src] is holding [p_their()] breath! It looks like [p_theyre()] trying to commit suicide.")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm

		visible_message("<span class='danger'>[suicide_message]</span>", "<span class='userdanger'>[suicide_message]</span>")

		adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
/mob/living/carbon/brain/verb/suicide()
=======
/mob/living/brain/verb/suicide()
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		visible_message("<span class='danger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>", \
						"<span class='userdanger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>")
		spawn(50)
			death(0)
=======
		visible_message("<span class='danger'>[src]'s brain is growing dull and lifeless. [p_they(TRUE)] look[p_s()] like [p_theyve()] lost the will to live.</span>", \
						"<span class='userdanger'>[src]'s brain is growing dull and lifeless. [p_they(TRUE)] look[p_s()] like [p_theyve()] lost the will to live.</span>")
		death(0)
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		visible_message("<span class='danger'>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</span>")
=======
		visible_message("<span class='danger'>[src] is attempting to bite [p_their()] tongue. It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is attempting to bite [p_their()] tongue. It looks like [p_theyre()] trying to commit suicide.</span>")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
		adjustOxyLoss(max(200- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		visible_message("<span class='danger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>")
=======
		visible_message("<span class='danger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		visible_message("<span class='danger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>")
=======
		visible_message("<span class='danger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
	var/answer = input("REALLY turn off your own life processes? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "Yes")
		card.removePersonality()
		did_suicide = 1
=======
	var/answer = input("REALLY kill yourself? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "Yes")
		var/turf/T = get_turf(src.loc)
		T.visible_message("<span class='notice'>[src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"</span>", null, \
		 "<span class='notice'>[src] bleeps electronically.</span>")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
		death(0)
	else
		src << "Aborting suicide attempt."

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		visible_message("<span class='danger'>[src] is thrashing wildly! It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is thrashing wildly! It looks like \he's trying to commit suicide.</span>", \
=======
		visible_message("<span class='danger'>[src] is thrashing wildly! It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is thrashing wildly! It looks like [p_theyre()] trying to commit suicide.</span>", \
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
				"<span class='italics'>You hear thrashing.</span>")
		//put em at -175
		adjustOxyLoss(max(200 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/simple_animal/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		visible_message("<span class='danger'>[src] begins to fall down. It looks like \he's lost the will to live.</span>", \
						"<span class='userdanger'>[src] begins to fall down. It looks like \he's lost the will to live.</span>")
=======
		visible_message("<span class='danger'>[src] begins to fall down. It looks like [p_theyve()] lost the will to live.</span>", \
						"<span class='userdanger'>[src] begins to fall down. It looks like [p_theyve()] lost the will to live.</span>")
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
		death(0)


/mob/living/proc/canSuicide()
	if(stat == CONSCIOUS)
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
		return 1
=======
		return TRUE
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
	else if(stat == DEAD)
		src << "You're already dead!"
	else if(stat == UNCONSCIOUS)
		src << "You need to be conscious to suicide!"
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		src << "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))"
		return
<<<<<<< HEAD:code/modules/client/verbs/suicide.dm
	if(borer && borer.controlling)
		src << "You can't commit suicide while you're controlling your host!"
	return 1
=======
	if(has_brain_worms())
		src << "You can't bring yourself to commit suicide!"
		return
	return TRUE
>>>>>>> masterTGbranch:code/modules/client/verbs/suicide.dm
