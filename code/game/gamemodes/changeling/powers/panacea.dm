/obj/effect/proc_holder/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing parasites, sobering us, treating hallucinations, ear, and eye damage, and waking us up, purging toxins and radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious."
	chemical_cost = 40
	dna_cost = 2
	req_stat = UNCONSCIOUS

//Heals the things that the other regenerative abilities don't.
/obj/effect/proc_holder/changeling/panacea/sting_action(mob/user)
	user << "<span class='notice'>We begin cleansing impurities from our form.</span>"

	var/obj/item/organ/body_egg/egg = user.getorgan(/obj/item/organ/body_egg)
	if(egg)
		egg.Remove(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.vomit(0)
		egg.loc = get_turf(user)

	user.reagents.add_reagent("mutadone", 10)
	user.reagents.add_reagent("pen_acid", 20)
	user.reagents.add_reagent("antihol", 10)
	user.reagents.add_reagent("mannitol", 25)
	user.hallucination = max(0, M.hallucination - 50)
	user.set_eye_damage(0,0)
	user.setEarDamage(0,0)
	
	if(user.ToxLoss > 40)
		user.setToxLoss(40)
	else
		return

	for(var/datum/disease/D in user.viruses)
		if(D.severity == NONTHREAT)
			continue
		else
			D.cure()
	feedback_add_details("changeling_powers","AP")
	return 1
