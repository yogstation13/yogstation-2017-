/datum/disease/anthrax
	name = "Anthrax"
	form = "Infection"
	max_stages = 5
	spread_flags = SPECIAL
	spread_text = "On contact with contaminated item"
	cure_text = "Charcoal, Spaceacilin and Perfluorodecalin."
	cures = list("charcoal", "spaceacilin", "perfluorodecalin")
	agent = "Bacillus anthracis"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "A dangerous disease often used in assassinations by terrorist organizations."
	severity = BIOHAZARD
	stage_prob = 8

/datum/disease/anthrax/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(2))
				to_chat(affected_mob, "<span class='warning'>Your [pick("arm", "hand", "neck", "cheek", "nose")] itches.</span>")
			else if(prob(2))
				to_chat(affected_mob, "<span class='warning'>You lightly cough.</span>")
			else if(prob(3))
				to_chat(affected_mob, "<span class='warning'>You feel slightly weak.</span>")

			if(prob(4))
				affected_mob.adjustToxLoss(1)
				affected_mob.adjustBruteLoss(1)
		if(3)
			if(prob(5))
				affected_mob.bodytemperature += 20
				to_chat(affected_mob, "<span class='warning'>You feel feverish.</span>")
			else if(prob(5))
				affected_mob.adjustOxyLoss(10)
				to_chat(affected_mob, "<span class='danger'>[pick("Your feel short of breath.","Your chest hurts.")]</span>")
			else if(prob(5))
				affected_mob.confused += rand(3,5)
				to_chat(affected_mob, "<span class='warning'>You stumble around.</span>")
			else if(prob(5))
				affected_mob.emote("cough")

			if(prob(4))
				affected_mob.adjustToxLoss(4)
				affected_mob.adjustBruteLoss(2)
		if(4)
			if(prob(6))
				affected_mob.bodytemperature += 30
				to_chat(affected_mob, "<span class='danger'>You feel hot.</span>")
			else if(prob(3))
				affected_mob.adjustOxyLoss(20)
				affected_mob.losebreath += 2
				to_chat(affected_mob, "<span class='danger'>You can't catch your breath!</span>")
			else if(prob(3))
				affected_mob.drowsyness += rand(4,6)
				affected_mob.confused += rand(4,6)
				to_chat(affected_mob, "<span class='danger'>You feel dead tired.</span>")
			else if(prob(4))
				affected_mob.vomit()

			if(prob(6))
				affected_mob.adjustToxLoss(5)
				affected_mob.adjustBruteLoss(4)
		if(5)
			if(prob(3))
				affected_mob.bodytemperature += 60
				to_chat(affected_mob, "<span class='danger'>You feel extremely hot.</span>")
			else if(prob(5))
				affected_mob.adjustOxyLoss(30)
				affected_mob.losebreath += 3
				to_chat(affected_mob, "<span class='userdanger'>[pick("You can't breathe!","Your lungs feel weak.","You gasp for air!")]</span>")
			else if(prob(4))
				affected_mob.vomit(blood=TRUE)
			else if(prob(4))
				affected_mob.visible_message("<span class='danger'>[affected_mob] coughs up blood!</span>", "<span class='userdanger'>You cough up blood!</span>")
				affected_mob.bleed(3)
			else if(prob(7))
				to_chat(affected_mob, "<span class='userdanger'>[pick("Your stomach hurts badly!","You feel nauseous.","Your insides are twisting and burning!")]</span>")
				affected_mob.Stun(4)
			else if(prob(9))
				affected_mob.confused += 8
				affected_mob.drowsyness += 10
				to_chat(affected_mob, "<span class='userdanger'>[pick("You can barely move!","Everything hurts!","Your body aches.")]</span>")
			else if(prob(6))
				to_chat(affected_mob, "<span class='userdanger'>You [pick("collapse","faint","lose consciousness")]...</span>")
				affected_mob.emote("collapse")

			if(prob(7))
				affected_mob.adjustToxLoss(7)
				affected_mob.adjustBruteLoss(5)