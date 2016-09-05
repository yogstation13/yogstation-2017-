/obj/effect/proc_holder/spell/proc/abomination_check(mob/usr)
	if(!ishuman(usr))
		return 0
	var/mob/living/carbon/human/H = usr
	if(H.dna.species.id == "abomination")
		return 1
	else
		usr << "You can't use this in your current form."
		return 0



/obj/effect/proc_holder/spell/aoe_turf/abomination/screech //Stuns anyone in view range.
	name = "Screech"
	desc = "Releases a terrifying screech, freezing those who hear."
	panel = "Abomination"
	range = 7
	charge_max = 150
	clothes_req = 0
	sound = 'sound/effects/creepyshriek.ogg'

/obj/effect/proc_holder/spell/aoe_turf/abomination/screech/cast(list/targets,mob/user = usr)
	if(!abomination_check(user))
		revert_cast()
		return
	playMagSound()
	user.visible_message("<span class='warning'><b>[usr] opens their maw and releases a horrifying shriek!</span>")
	for(var/turf/T in targets)
		for(var/mob/living/carbon/M in T.contents)
			if(M == user) //No message for the user, of course
				continue
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))//only the true power of earmuffs may block the power of the screech
				continue
			M << "<span class='userdanger'>You freeze in terror, your blood turning cold from the sound of the scream!</span>"
			M.Stun(5)
		for(var/mob/living/silicon/M in T.contents)
			M.Weaken(10)
	for(var/obj/machinery/light/L in range(7, user))
		L.on = 1
		L.broken()


/obj/effect/proc_holder/spell/targeted/abomination/abom_fleshmend
	name = "Fleshmend"
	desc = "Rapidly replaces damaged flesh, healing any physical damage sustained."
	panel = "Abomination"
	charge_max = 300
	clothes_req = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/targeted/abomination/abom_fleshmend/cast(mob/living/carbon/human/user)
	if(!abomination_check(user))
		return
	user.visible_message("<span class='warning'>[usr]'s skin shifts and pulses, any damage rapidly vanishing!</span>")
	spawn(0)
		if(ishuman(usr))
			var/mob/living/carbon/human/H = user
			H.restore_blood()
			H.remove_all_embedded_objects()
	var/mob/living/carbon/human/H = user
	for(var/i = 0, i<10,i++) // old fleshmend, can be spammed, but it has a cooldown because spell
		H.adjustBruteLoss(-10)
		H.adjustOxyLoss(-10)
		H.adjustFireLoss(-10)
		H.adjustToxLoss(-10)//no cyaniding the horrifying monster
		sleep(10)




/obj/effect/proc_holder/spell/targeted/abomination/devour
	name = "Devour"
	desc = "Eat a target, absorbing their genetic structure and completely destroying their body."
	panel = "Abomination"
	charge_max = 0
	clothes_req = 0
	range = 1


/obj/effect/proc_holder/spell/targeted/abomination/devour/cast(list/targets,mob/user)
	if(!abomination_check(user))
		return
	var/datum/changeling/changeling = user.mind.changeling
	if(changeling.isabsorbing)
		user << "<span class='warning'>We are already absorbing!</span>"
		return
	if(!user.pulling || !iscarbon(user.pulling))
		user << "<span class='warning'>We must be grabbing a valid creature to devour them!</span>"
		return
	if(user.grab_state < GRAB_AGGRESSIVE)
		user << "<span class='warning'>We must have a tighter grip to devour this creature!</span>"
		return
	var/mob/living/carbon/target = user.pulling
	changeling.can_absorb_dna(user,target)

	changeling.isabsorbing = 1
	user << "<span class='notice'>This creature is compatible. We must hold still...</span>"
	user.visible_message("<span class='warning'><b>[user] opens their mouth wide, lifting up [target]!</span>", "<span class='notice'>We prepare to devour [target].</span>")

	if(!do_mob(user, target, 30))
		user << "<span class='warning'>Our devouring of [target] has been interrupted!</span>"
		changeling.isabsorbing = 0
		return

	user.visible_message("<span class='danger'>[user] devours [target], vomiting up some things!</span>", "<span class='notice'>We have devoured [target].</span>")
	target << "<span class='userdanger'>You are devoured by the abomination!</span>"

	if(changeling.has_dna(target.dna))
		changeling.remove_profile(target)
		changeling.absorbedcount--
	changeling.add_profile(target, user)

	if(user.nutrition < NUTRITION_LEVEL_WELL_FED)
		user.nutrition = min((user.nutrition + target.nutrition), NUTRITION_LEVEL_WELL_FED)

	if(target.mind)//if the victim has got a mind

		target.mind.show_memory(src, 0) //I can read your mind, kekeke. Output all their notes.

	//Some of target's recent speech, so the changeling can attempt to imitate them better.
	//Recent as opposed to all because rounds tend to have a LOT of text.
		var/list/recent_speech = list()

		if(target.say_log.len > LING_ABSORB_RECENT_SPEECH)
			recent_speech = target.say_log.Copy(target.say_log.len-LING_ABSORB_RECENT_SPEECH+1,0) //0 so len-LING_ARS+1 to end of list
		else
			for(var/spoken_memory in target.say_log)
				if(recent_speech.len >= LING_ABSORB_RECENT_SPEECH)
					break
				recent_speech += spoken_memory

		if(recent_speech.len)
			user.mind.store_memory("<B>Some of [target]'s speech patterns, we should study these to better impersonate them!</B>")
			user << "<span class='boldnotice'>Some of [target]'s speech patterns, we should study these to better impersonate them!</span>"
			for(var/spoken_memory in recent_speech)
				user.mind.store_memory("\"[spoken_memory]\"")
				user << "<span class='notice'>\"[spoken_memory]\"</span>"
			user.mind.store_memory("<B>We have no more knowledge of [target]'s speech patterns.</B>")
			user << "<span class='boldnotice'>We have no more knowledge of [target]'s speech patterns.</span>"

		if(target.mind.changeling)//If the target was a changeling, suck out their extra juice and objective points!
			changeling.chem_charges += min(target.mind.changeling.chem_charges, changeling.chem_storage)
			changeling.absorbedcount += (target.mind.changeling.absorbedcount)

			target.mind.changeling.stored_profiles.len = 1
			target.mind.changeling.absorbedcount = 0


	changeling.chem_charges=min(changeling.chem_charges+50, changeling.chem_storage)

	changeling.isabsorbing = 0
	changeling.canrespec = 1
	for(var/obj/item/I in target) //drops all items
		target.unEquip(I)
	new /obj/effect/decal/remains/human(target.loc)
	qdel(target)




/obj/effect/proc_holder/spell/targeted/abomination/abom_revert
	name = "Revert"
	desc = "Returns you to a normal, human form."
	panel = "Abomination"
	charge_max = 0
	clothes_req = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/targeted/abomination/abom_revert/cast(list/targets,mob/user = usr)
	var/mob/living/carbon/human/H = user
	var/datum/changeling/changeling = user.mind.changeling
	var/transform_or_no=alert(user,"Are you sure you want to revert?",,"Yes","No")
	switch(transform_or_no)
		if("No")
			user << "<span class='warning'>You decide not to revert."
			return
		if("Yes")
			if(!abomination_check(usr))
				user << "<span class='warning'>You're already reverted!</span>"
				for(var/spell in user.mind.spell_list)
					if(istype(spell, /obj/effect/proc_holder/spell/targeted/abomination)|| istype(spell, /obj/effect/proc_holder/spell/aoe_turf/abomination))
						user.mind.RemoveSpell(spell)
						qdel(spell)
				return
			user <<"<span class='notice'>You transform back into a humanoid form.</span>"
			var/datum/mutation/human/HM = mutations_list[HULK]
			if(H.dna && H.dna.mutations)
				HM.force_lose(H)
			changeling.reverting = 1
			changeling.geneticdamage += 10


