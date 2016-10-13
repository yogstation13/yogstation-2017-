/datum/round_event_control/mouse_hunger
	name = "Mice Hunger For Wires"
	typepath = /datum/round_event/mouse_hunger
	min_players = 30
	max_occurrences = 1
	weight = 20
	earliest_start = 10000 //About 16 minutes. Enough time for engi's to start everything up

/datum/round_event/mouse_hunger

/datum/round_event/mouse_hunger/start()
	for(var/mob/living/simple_animal/mouse/M in mob_list)
		M.hungry = 1 //Don't need a stat check, mice get replaced with a dead mouse obj anyway.
