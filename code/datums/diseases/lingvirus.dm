/datum/disease/lingvirus
	name = "Unknown Xenobiological Pathogen"
	max_stages = 4
	spread_flags = AIRBORNE | CONTACT_GENERAL
	cure_text = "Sedation required."
	cures = list("morphine")
	agent = "Possibilities: C-type hivemind xenobiological vector, consumption of restricted xeno-related foodstuffs, latent infection via carrier."
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	desc = "Level 7 viral pathogen of xenobiological origin. Known symptoms involve: intense hallucinations, foaming at the mouth. Appears to be limited in scope and potency. Physically nonlethal, but mental damage may linger."
	severity = MEDIUM
	var/increment = 5  //by how much we increase the hallucinations
	stage_prob = 3

/datum/disease/lingvirus/stage_act()
	..()
	if (affected_mob && affected_mob.mind && affected_mob.mind.changeling)
		cure()
		return
	switch (stage)
		if (1) //3% chance each tick to move to the next stage 2
			stage_prob = 3
			if (prob(3))
				affected_mob.hallucination = max(30, affected_mob.hallucination + increment)
			if (prob(4))
				to_chat(affected_mob, "<span class='info'>The world sways and warbles about you, as if caught in a desert heat.</span>")
				increment += 5
				affected_mob.emote("twitch")
		if (2) //2% chance to move to the next stage 3
			stage_prob = 2
			increment = max(increment, 10)
			if (prob(5))
				affected_mob.hallucination = max(40, affected_mob.hallucination + increment)
			if (prob(3))
				to_chat(affected_mob, "<span class='warning'>You feel gravely ill. Something is terribly wrong.</span>")
				increment += 8 //Get this disease fixed asap
				affected_mob.emote("moan")
		if (3) //1% chance to move to stage 4
			stage_prob = 1
			increment = max(increment, 20) //No, seriously, you going to get fucked up
			if (prob(7))
				affected_mob.hallucination = max(60, affected_mob.hallucination + increment)
			if (prob(5))
				increment += 15 //Silent increment
			if (prob(3))
				increment += 30
				to_chat(affected_mob, "<span class='info'>You feel like you're being hunted.</span>")
				affected_mob.emote("scream")
			if(affected_mob.hallucination > 500)
				to_chat(affected_mob, "<span class='boldwarning'>The stress begins to wear away at your sanity. Your mouth falls open, hung wide in a silent scream.</span>")
				affected_mob.emote("scream")
				affected_mob.visible_message("<span class='boldwarning'>[affected_mob] shrieks manically and begins to tear at their hair.</span>")
				affected_mob.hallucination = 400
				stage = 4
		if (4)
			if (prob(1))
				stage = 3
				increment = 20
			if (affected_mob.hallucination <= 20) //20 is when Hallucination processing actually ends in handle_hallucinations()
				to_chat(affected_mob, "<span class='info'>A wave of sudden, palpable relief washes over you as the feeling of intense discomfort fades, and the fog over your mind is lifted.</span>")
				cure()
				return