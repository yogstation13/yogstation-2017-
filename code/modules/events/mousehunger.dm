/datum/round_event_control/mouse_huner
	name = "Mice hunger for wires"
	typepath = /datum/round_event/mouse_hunger
	min_players = 30
	max_occurrences = 1
	weight = 20
	earliest_start = 10000

/datum/round_event/mouse_hunger
	var/list/mouse_territory = list(/area/maintenance)

/datum/round_event/mouse_hunger/start()
	for(var/mob/living/simple_animal/mouse/M in mob_list)
		M.hungry = 1 //Don't need a stat check, mice get replaced with a dead mouse obj anyway.




