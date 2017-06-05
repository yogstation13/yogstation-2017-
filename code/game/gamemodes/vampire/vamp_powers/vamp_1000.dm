/////////////////////
////////1000/////////
/////////////////////

/obj/effect/proc_holder/vampire/summon
	name = "Summon Coffin"
	desc = "Summon your coffin."
	req_bloodcount = 250
	cooldownlen = 900
	action_icon_state = "summoncoffin"

/obj/effect/proc_holder/vampire/summon/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/V = H.mind.vampire
	if(!V.coffin)
		H << "<span class='warning'>You need to create a vampiric coffin first...</span>"
		return

	var/turf/flyingcoffintarget = V.hometurf
	if(!flyingcoffintarget)
		H << "<span class='noticevampire'>You haven't set a home turf yet, so your coffin will teleport directly to you.</span>"
		flyingcoffintarget = get_turf(H)

	V.coffin.forceMove(flyingcoffintarget)
	H.visible_message("<span class='warning'>[H] points at the ground beneath them!</span>",\
		"<span class='warning'>You focus your energy towards the ground.</span>")

	feedback_add_details("vampire_powers","summon coffin")
	return 1

/obj/effect/proc_holder/vampire/setsummonturf
	name = "Set Summon Turf"
	desc = "Activating this will set the turf below you as a hometurf."
	req_bloodcount = 0
	cooldownlen = 0
	action_icon_state = "hometurf"

/obj/effect/proc_holder/vampire/setsummonturf/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/V = H.mind.vampire
	if(!V.coffin)
		H << "<span class='warning'>You need to create a vampiric coffin first...</span>"
		return

	if(!get_turf(H))
		return

	V.hometurf = get_turf(H)
	H << "<span class='vampirealert'>Home turf updated.</span>"
	feedback_add_details("vampire_powers","hometurf")

	return 1