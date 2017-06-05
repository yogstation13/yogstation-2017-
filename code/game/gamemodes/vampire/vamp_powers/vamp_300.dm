/////////////////////
/////////300/////////
/////////////////////

/obj/effect/proc_holder/vampire/battrans
	name = "Bat Transformation"
	desc = "Become a bat, able to slip under doors "
	pay_blood_immediately = FALSE
	cooldown_immediately = FALSE
	cooldownlen = 0
	var/mob/living/simple_animal/hostile/bat/vampire/vbat = null
	var/transformed = FALSE
	action_icon_state = "batcrowd"

/obj/effect/proc_holder/vampire/battrans/fire(mob/living/carbon/human/H, datum/vampire/V)
	if(transformed)
		return
	else
		H << "<span class='noticevampire'>You take the form of a bat. (Check the vampire tab to trasnform back)</span>"
		if(V)
			force_drainage(25, V)
		if(!vbat)
			vbat = new /mob/living/simple_animal/hostile/bat/vampire(H.loc)
			vbat.vamp = H
			vbat.S = src
		H.forceMove(vbat)
		H.status_flags |= GODMODE
		vbat.verbs += /mob/living/simple_animal/hostile/bat/vampire/verb/humanform
		H.mind.transfer_to(vbat)
		vbat.adjustBruteLoss(H.maxHealth - H.health)
	feedback_add_details("vampire_powers","bat transformation")

/obj/effect/proc_holder/vampire/radiomalf
	name = "Radio Malfunction"
	desc = "Disable all nearby radios including intercoms, headsets, and handheld."
	blood_cost = 70
	cooldownlen = 200 // wasn't specified in doc, but after testing it's not good spammable.
	action_icon_state = "malfradio"

/obj/effect/proc_holder/vampire/radiomalf/fire(mob/living/carbon/human/H)
	if(!..())
		return

	H.visible_message("<span class='notice'>[H] starts clapping....</span>",\
		"<span class='notice'>[H] starts clapping...</span>")


	for(var/obj/item/device/radio/R in view(5,H))
		if(get_dist(H, get_turf(H)) > 5)
			continue
		R.listening = 0
		R.broadcasting = 0

	for(var/mob/living in view(5,H))
		if(get_dist(H, get_turf(H)) > 5)
			continue
		var/turf/T = get_turf(living)
		if(T && T.flags & NOJAUNT) // aka blessed.
			continue
		if(ishuman(living))
			for(var/obj/item/device/radio/radio in living.contents)
				living << "<span class='warning'>[radio] begins to malfunction!</span>"
				radio.listening = 0
				radio.broadcasting = 0

	playsound(loc, 'sound/effects/EMPulse.ogg', 75, 1)

	feedback_add_details("vampire_powers","radio-malf")


/obj/effect/proc_holder/vampire/coffin
	name = "Designate Coffin"
	desc = "Choose a coffin."
	blood_cost = 250
	action_icon_state = "coffin"

/obj/effect/proc_holder/vampire/coffin/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/V = H.mind.vampire
	if(V.coffin)
		if(!qdeleted(V.coffin))
			H << "<span class='vampirealert'>You already have a coffin.</span>"
			return

	var/obj/structure/closet/coffin/found = FALSE
	for(var/obj/structure/closet/coffin/C in view(7, H))
		if(found)
			break
		if(istype(C, /obj/structure/closet/coffin/vampiric))
			continue
		found = C

	if(!found)
		return

	var/obj/structure/closet/coffin/vampiric/vcoffin = new(get_turf(found))

	vcoffin.vdatum = V
	V.coffin = vcoffin
	qdel(found)

	H << "<span class='vampirealert'>You have sucessfully designated your coffin. While you are in \
		the coffin you will slowly regenerate health and blood. Once you become strong enough you will \
		be able to regenerate limbs while inside.</span>"

	feedback_add_details("vampire_powers","coffin")
	return 1