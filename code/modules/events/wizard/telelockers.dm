/datum/round_event_control/wizard/telelockers //fashion disasters
	name = "Telelockers"
	weight = 10
	typepath = /datum/round_event/wizard/telelockers
	max_occurrences = 5
	earliest_start = 0

/datum/round_event/wizard/telelockers/start()
	for(var/i in 1 to 10)
		for(var/i2 in 1 to 10)
			var/obj/structure/closet/C = pick(closet_list)
			if(C.z != 1)
				continue
			C.magic_teleport = TRUE
			break
