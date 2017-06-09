//HIVEMIND COMMUNICATION (:g)
/obj/effect/proc_holder/changeling/hivemind_comms
	name = "Hivemind Communication"
	desc = "We tune our senses to the airwaves to allow us to discreetly communicate and exchange DNA with other changelings."
	helptext = "We will be able to talk with other changelings with :g. Exchanged DNA do not count towards absorb objectives."
	dna_cost = 0
	chemical_cost = -1

/obj/effect/proc_holder/changeling/hivemind_comms/on_purchase(var/mob/user)
	..()
	var/datum/changeling/changeling=user.mind.changeling
	changeling.changeling_speak = 1
	user << "<i><font color=#800080>Use say \":g message\" to communicate with the other changelings.</font></i>"
	var/obj/effect/proc_holder/changeling/hivemind_upload/S1 = new
	if(!changeling.has_sting(S1))
		changeling.purchasedpowers+=S1
	var/obj/effect/proc_holder/changeling/hivemind_download/S2 = new
	if(!changeling.has_sting(S2))
		changeling.purchasedpowers+=S2
	return

// HIVE MIND UPLOAD/DOWNLOAD DNA
var/list/datum/dna/hivemind_bank = list()

/obj/effect/proc_holder/changeling/hivemind_upload
	name = "Hive Channel DNA"
	desc = "Allows us to channel DNA in the airwaves to allow other changelings to absorb it."
	chemical_cost = 10
	dna_cost = -1

/obj/effect/proc_holder/changeling/hivemind_upload/sting_action(var/mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	if(changeling.stored_profiles.len < 2)
		user << "<span class = 'warning'>We do not have enough stored DNA for this.</span>"
		return

	var/datum/changelingprofile/chosen_prof = changeling.select_dna("Select a DNA to channel: ", "Channel DNA", user, FALSE, FALSE, TRUE)

	if(!chosen_prof)
		return

	var/datum/changelingprofile/uploaded_prof = new chosen_prof.type
	chosen_prof.copy_profile(uploaded_prof)
	hivemind_bank += uploaded_prof

	user.mind.changeling.stored_profiles -= chosen_prof
	user.mind.changeling.profilecount--

	user << "<span class='notice'>We channel the DNA of [chosen_prof] to the air.</span>"
	feedback_add_details("changeling_powers","HU")
	return 1

/obj/effect/proc_holder/changeling/hivemind_download
	name = "Hive Absorb DNA"
	desc = "Allows us to absorb DNA that has been channeled to the airwaves. Does not count towards absorb objectives."
	chemical_cost = 10
	dna_cost = -1

/obj/effect/proc_holder/changeling/hivemind_download/can_sting(mob/living/carbon/user)
	if(!..())
		return
	var/datum/changeling/changeling = user.mind.changeling
	var/datum/changelingprofile/first_prof = changeling.stored_profiles.len > 0 ? changeling.stored_profiles[1] : null
	if(!first_prof || (first_prof.name == user.real_name))//If our current DNA is the stalest, we gotta ditch it.
		user << "<span class='warning'>We have reached our capacity to store genetic information! We must transform before absorbing more.</span>"
		return
	return 1

/obj/effect/proc_holder/changeling/hivemind_download/sting_action(mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/list/names = list()
	for(var/datum/changelingprofile/prof in hivemind_bank)
		if(!(prof in changeling.stored_profiles))
			names[prof.name] = prof

	if(names.len <= 0)
		user << "<span class='notice'>There's no new DNA to absorb from the air.</span>"
		return

	var/S = input("Select a DNA absorb from the air: ", "Absorb DNA", null) as null|anything in names
	if(!S)
		return
	var/datum/changelingprofile/chosen_prof = names[S]
	if(!chosen_prof)
		return
	if(!(chosen_prof in hivemind_bank))
		user << "<span class='warning'>That DNA is no longer available.</span>"
		return

	hivemind_bank -= chosen_prof
	changeling.add_profile(chosen_prof)
	user << "<span class='notice'>We absorb the DNA of [S] from the air.</span>"
	feedback_add_details("changeling_powers","HD")
	return 1
