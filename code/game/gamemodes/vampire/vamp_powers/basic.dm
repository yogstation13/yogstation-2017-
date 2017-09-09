/////////////////////////
/////BASIC ABILITIES/////
/////////////////////////


/////////////////////
////	BITE 	/////
/////////////////////

/obj/effect/proc_holder/vampire/bite
	name = "Bite"
	desc = "Sink your teeth into an adjacent target."
	human_req = TRUE
	action_icon_state = "bite"
	cooldownlen = 25

/obj/effect/proc_holder/vampire/bite/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/vampire = H.mind.vampire
	if(!H.pulling)
		H << "<span class='alertvampire'>To use this technique you will need to grab your victim!</span>"
		return
	if(!ishuman(H.pulling))
		H << "<span class='alertvampire'>This technique can only be used on human life forms!</span>"
		return

	if(vampire.isDraining)
		return

	var/mob/living/carbon/human/target = H.pulling

	if(H.zone_selected == "head" || H.zone_selected == "eyes" || H.zone_selected == "mouth")
		if(istype(target.head, /obj/item/clothing/head/helmet/space/hardsuit))
			H << "<span class='alertvampire>[target] has their helmet engaged!</span>"
			return
	else
		if(istype(target.wear_suit, /obj/item/clothing/suit/space/hardsuit))
			H << "<span class='alertvampire'>[target] has a hardsuit on!</span>"
			return

	if(NOBLOOD in target.dna.species.specflags || !target.blood_volume)
		H << "<span class='alertvampire'>They have no blood!</span>"
		return


	target << "<span class='notice'>[H] is getting pretty close...</span>"
	H << "<span class='alertvampire'>You start leaning close to [target]'s neck.</span>"

	if(!(do_after(H, 15, H.pulling)))
		return

	var/drainrate = 30
	var/drainpayoff = 10

	if(target.stat == DEAD)
		drainrate = 30
		drainpayoff = 1
		H << "<span class='alertvampire'>It's always harder to collect old blood from corpses.</span>"

	playsound(H.loc,'sound/magic/Demon_consume.ogg', rand(10,30), 1)
	H.visible_message("<span class='warning'>[H] sinks their fangs into [target]!.", \
	"<span class='noticevampire'>You sink your fangs into [target]!</span>")
	vampire.isDraining = TRUE
	flash_color(H, color = "#FF0000", time = 25)
	flash_color(vampire, color = "#FF0000", time = 3)

	while(vampire.isDraining)
		if(target.stat == DEAD)
			drainrate = 30
			drainpayoff = 1
		if(check_status(H, vampire, target, drainrate))
			target.blood_volume -= drainrate
			vampire.add_blood(drainpayoff)
			H << "<span class='noticevampire'>You have drained [drainrate] units of blood from [target]. They have [target.blood_volume] units remaining. You now have [vampire.bloodcount] units to use.</span>"
			playsound(H.loc,'sound/items/drink.ogg', 10, 1)
		if(target.job == "Chaplain")
			H.visible_message("<span class='warning'>[H] hacks and coughs from draining [target]'s blood.</span>",\
				"<span class='userdanger'>[target]'s blood is holy! It burns!</span>")
			H.reagents.add_reagent("sacid", 10)

		vampire.check_for_new_ability()
		sleep(20)

	H << "<span class='noticevampire'>You have finished draining [target]</span>"
	feedback_add_details("vampire_powers","bite")
	return 1


/obj/effect/proc_holder/vampire/bite/proc/check_status(mob/living/L, datum/vampire/V, mob/living/carbon/human/T, rate)
	if(L.incapacitated() && L.stat == CONSCIOUS || L.stat == DEAD || L.stat == UNCONSCIOUS || get_dist(L, T) > 1 || !L.pulling)
		V.isDraining = FALSE
		L << "<span class='alertvampire'>You've been interrupted!</span>"
		return 0
	if(!T.blood_volume || T.blood_volume < rate)
		L << "<span class='noticevampire'>[T] has run out of blood.</span>"
		V.isDraining = FALSE
		T.reagents.clear_reagents()
		return 0
	return 1


/////////////////////
////	GAZE 	/////
/////////////////////

/obj/effect/proc_holder/vampire/gaze
	name = "Vampiric Gaze"
	desc = "Paralyze your target with fear. (Use the middle mouse button after activating)"
	cooldownlen = 300
	pay_blood_immediately = FALSE
	cooldown_immediately = FALSE
	action_icon_state = "gaze"

/obj/effect/proc_holder/vampire/gaze/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/V = H.mind.vampire

	if(!checkout_click_attack(H, V))
		return

	V.chosen_click_attack = src
	H << "<span class='alertvampire'>[src] is now active. (Use your middle mouse button on anyone to activate.)"
	return 1

/obj/effect/proc_holder/vampire/gaze/action_on_click(mob/living/carbon/human/H, datum/vampire/V, atom/target)
	if(!..())
		return
	if(target)
		if(!(ishuman(target)))
			return
	else
		return

	var/mob/living/carbon/human/T = target

	if(T.stat == DEAD)
		H << "<span class='alertvampire'>You cannot gaze at corpses... \
			or maybe you could if you really wanted to.</span>"
		return

	H.visible_message("<span class='warning'>[H]'s eyes flash red.</span>",\
					"<span class='warning'>[H]'s eyes flash red.</span>")
	if(ishuman(target))
		var/obj/item/clothing/glasses/G = T.glasses
		if(G)
			if(G.flash_protect)
				if(V && !(V.eighthundred_unlocked))
					H << "<span class='alertvampire'>[T] has protective sunglasses on!</span>"
					target << "<span class='warning'>[H]'s paralyzing gaze is blocked by your [G]!</span>"
					return
		var/obj/item/clothing/mask/M = T.wear_mask
		if(M)
			if(M.flags_cover & MASKCOVERSEYES)
				if(V && !(V.eighthundred_unlocked))
					H << "<span class='alertvampire'>[T]'s mask is covering their eyes!</span>"
					target << "<span class='warning'>[H]'s paralyzing gaze is blocked by your [M]!</span>"
					return

		T << "<span class='warning'>You are paralyzed with fear!</span>"
		H << "<span class='noticevampire'>You paralyze [T].</span>"
		T.Stun(5)

	feedback_add_details("vampire_powers","gaze")


/////////////////////////////
////	BLOOD TRACKING	/////
/////////////////////////////

/obj/effect/proc_holder/vampire/bloodtracking
	name = "Blood Tracking"
	desc = "Use this by clicking on blood drips or splatters, and track who it belongs too. (Use the middle mouse button on blood)"
	pay_blood_immediately = FALSE
	cooldown_immediately = FALSE
	action_icon_state = "bloodtrack"

/obj/effect/proc_holder/vampire/bloodtracking/fire(mob/living/carbon/human/H)
	if(!..())
		return
	var/datum/vampire/V = H.mind.vampire
	if(!checkout_click_attack(H, V))
		return
	V.chosen_click_attack = src

	H << "<span class='noticevampire'>[src] is now active. Clicking on blood spills or trails will allow you to determine who they belong too. (Use your middle mouse button on blood)</span>"
	return 1

/obj/effect/proc_holder/vampire/bloodtracking/action_on_click(mob/living/carbon/human/H, datum/vampire/V, atom/target)
	if(!..())
		return
	var/list/object_bloodDNA = list()
	if(istype(target, /obj/effect/decal/cleanable/blood))
		var/obj/effect/decal/cleanable/blood/B = target
		object_bloodDNA = B.blood_DNA.Copy()
	if(istype(target, /obj/effect/decal/cleanable/trail_holder))
		var/obj/effect/decal/cleanable/trail_holder/TH = target
		object_bloodDNA = TH.blood_DNA.Copy()

	if(!(object_bloodDNA.len))
		H << "<span class='alertvampire'>That's not blood. [src] is now deactivated.</span>"
		return

	var/list/humanscaught = list()
	var/list/locatedblood_DNA = list()
	var/stopsearching = FALSE
	for(var/mob/living/carbon/human/L in mob_list)
		locatedblood_DNA = L.get_blood_dna_list()
		if(locatedblood_DNA)
			if(locatedblood_DNA.len)
				for(var/a in locatedblood_DNA, stopsearching != TRUE)
					for(var/b in object_bloodDNA)
						if(a == b)
							stopsearching = TRUE
							humanscaught += L
							break
		else
			continue
		stopsearching = FALSE
		locatedblood_DNA = null

	if(humanscaught.len)
		H << "<span class='alertvampire'>You search for who the blood belongs too.</span>"
		for(var/mob/living/carbon/human/caughthuman in humanscaught)
			H << "<span class='noticevampire'>[caughthuman] is in the [get_area(caughthuman)], just [dir2text(get_dir(get_turf(caughthuman), get_turf(H)))] from your location.</span>"
	else
		H << "<span class='alertvampire'>You couldn't find who the blood belonged too.</span>"
	feedback_add_details("vampire_powers","blood track")

////////////////////////////////////
////////	TRACKING		////////
////////////////////////////////////

/obj/effect/proc_holder/vampire/digitaltracking
	name = "Digital Tracking"
	desc = "Toggle whether the AI can track you or not."
	req_bloodcount = 10
	blood_cost = 5
	action_icon_state = "digital_anti_track"

/obj/effect/proc_holder/vampire/digitaltracking/fire(mob/living/carbon/human/H)
	if(!..())
		return

	H.digitalcamo = !H.digitalcamo
	H << "<span class='alertvampire'>You toggle [H.digitalcamo ? "on" : "off"] on your digital cloak, and the AI can no longer \
			track you.</span>"
	feedback_add_details("vampire_powers","digital tracking")
	return 1


/obj/effect/proc_holder/vampire/digitalvisbility
	name = "Digital Visibility"
	desc = "Toggle whether cameras can see you or not."
	req_bloodcount = 10
	blood_cost = 5
	action_icon_state = "digital_invs"

/obj/effect/proc_holder/vampire/digitalvisbility/fire(mob/living/carbon/human/H)
	if(!..())
		return

	H.digitalinvis = !H.digitalinvis

	H << "<span class='alertvampire'>You toggle [H.digitalinvis ? "on" : "off"] on your digital cloak, and the AI can no longer \
			see you.</span>"
	feedback_add_details("vampire_powers","digital visibility")
	return 1

