/obj/effect/proc_holder/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing parasites, sobering us, treating ear damage, waking us up, purging toxins and radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious."
	chemical_cost = 40
	dna_cost = 2
	req_stat = UNCONSCIOUS

//Heals the things that the other regenerative abilities don't.
/obj/effect/proc_holder/changeling/panacea/sting_action(mob/user)
	to_chat(user, "<span class='notice'>We begin cleansing impurities from our form.</span>")

	var/obj/item/organ/body_egg/egg = user.getorgan(/obj/item/organ/body_egg)
	if(egg)
		egg.Remove(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.vomit(0)
		egg.loc = get_turf(user)


	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.borer)
			H.borer.leave_victim()

	for(var/datum/disease/D in user.viruses)
		if(D.severity == NONTHREAT)
			continue
		else
			D.cure()


	user.reagents.clear_reagents()
	sleep(1)
	user.reagents.add_reagent("antihol", 10)
	user.reagents.add_reagent("mannitol", 25)
	user.reagents.add_reagent("inacusiate", 10)
	user.reagents.add_reagent("antitoxin", 29)
	user.reagents.add_reagent("mutadone", 10)


	feedback_add_details("changeling_powers","AP")
	return 1
