/datum/round_event_control/wizard/zombies //avast!
	name = "Zombie Outbreak"
	weight = 3
	typepath = /datum/round_event/wizard/zombies/
	max_occurrences = 3
	earliest_start = 12000 // 20 minutes (Allow the crew to get ready)

/datum/round_event/wizard/zombies/start()
	var/zombieAmount = rand(2, 6)
	var/list/zombies = list()

	for(var/mob/living/carbon/human/H in living_mob_list)
		if(!H.mind || H.mind in ticker.mode.wizards)
			continue
		zombies += H

	for(var/i in 1 to zombieAmount)
		var/zombie = pick_n_take(zombies)

		var/obj/item/organ/body_egg/zombie_infection/Z = new(zombie)
		Z.Insert(zombie)
		Z.reanimation_timer = world.time + 1200 // flat out 2 minutes, ready set GO.
		to_chat(zombie, "<font style = 3><b><span class = 'notice'>You are patient zero!</span></b></font>")
		to_chat(zombie, "<b>You have contracted a strange infection from your visit aboard a <span class='warning'>quarantined space station</span>.</b>")
		to_chat(zombie, "<b>It is only a matter of time before you transform into a <span class='warning'>flesh eating zombie</span>.</b>")
		to_chat(zombie, "<b>Your sole purpose is to hunt crew members to infect them and consume their <span class='warning'>brains</span>.</b>")
		to_chat(zombie, "<b>Eating <span class='warning'>brains</span> will make you stronger, so make sure you <span class='warning'>crack open some skulls</span> for some delicious treats.</b>")
