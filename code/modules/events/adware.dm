/datum/round_event_control/adware
	name = "Adware"
	typepath = /datum/round_event/adware
	weight = 20
	max_occurrences = 2
	earliest_start = 6000

/datum/round_event/adware/start()
	var/list/PDAs = get_viewable_pdas()
	for(var/i in 1 to 3)
		if(!PDAs.len)
			break
		var/obj/item/device/pda/PDA = pick(PDAs)
		if(istype(PDA))
			var/datum/software/malware/adware/A = new /datum/software/malware/adware()
			A.infect(PDA)
			PDAs -= PDA