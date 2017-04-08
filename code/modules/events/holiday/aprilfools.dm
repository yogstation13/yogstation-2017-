/datum/round_event_control/clownbugs
	name = "Clown Bugs"
	holidayID = APRIL_FOOLS
	typepath = /datum/round_event/clown_bugs
	weight = 40
	max_occurrences = 2
	min_players = 15

/datum/round_event/clown_bugs
	var/spawncount = 1

/datum/round_event/clown_bugs/setup()
	spawncount = rand(5, 8)

/datum/round_event/clown_bugs/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in world)
		if(temp_vent.loc.z == ZLEVEL_STATION && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.PARENT1
			if(temp_vent_parent.other_atmosmch.len > 20)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /mob/living/simple_animal/cockroach/clownbug(vent.loc)
		vents -= vent
		spawncount--
