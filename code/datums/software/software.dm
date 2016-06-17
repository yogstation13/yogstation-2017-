var/list/datum/software/active_software = list()

/proc/get_software_list(atom/target)
	if(!target)
		return null
	if(istype(target, /obj/item/device/pda))
		var/obj/item/device/pda/PDA = target
		if(!PDA.software)
			PDA.software = list()
		return PDA.software
	if(istype(target, /obj/machinery))
		var/obj/machinery/M = target
		if(!M.software)
			M.software = list()
		return M.software
	if(istype(target, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = target
		if(!M.software)
			M.software = list()
		return M.software
	if(istype(target, /obj/item/weapon/electronics))
		var/obj/item/weapon/electronics/E = target
		if(!E.software)
			E.software = list()
		return E.software
	return null

/proc/swap_software(var/atom/first, var/atom/second)
	var/list/firstSoftware = get_software_list(first)
	var/list/secondSoftware = get_software_list(second)
	for(var/V in firstSoftware)
		var/datum/software/S = V
		V.attempt_infect(second)
	for(var/V in secondSoftware)
		var/datum/software/S = V
		V.attempt_infect(first)

/proc/transfer_software(var/atom/first, var/atom/second)
	var/list/firstSoftware = get_software_list(first)
	var/list/secondSoftware = get_software_list(second)
	for(var/V in firstSoftware)
		var/datum/software/S = V
		V.infect(second)

/datum/software
	var/name = "malware"
	var/flags = 0
	var/atom/host = null
	var/infect_chance = 0
	var/mutate_on_copy_chance = 0
	var/list/can_infect = null
	var/list/cannot_infect = null

/datum/software/New()
	active_software += src
	..()

/datum/software/Destroy()
	active_software -= src
	if(host)
		uninfect(0)
	return ..()

/datum/software/proc/attempt_infect(atom/target)
	if(!target)
		return 0
	if(flags & SOFTWARE_NOSPREAD)
		return 0
	if(!prob(infect_chance))
		return 0
	if(can_infect && !is_type_in_list(target, can_infect))
		return 0
	if(cannot_infect && is_type_in_list(target, cannot_infect))
		return 0
	var/datum/software/new_copy = copy()
	return new_copy.infect(target)

/datum/software/proc/on_join(datum/software/other)//when a new piece of malware joins your host.
	if((other.type == src.type) && !(other.flags & SOFTWARE_NOCOPY) )//prevents massive spam of duplicate viruses on the same machine.
		return 1
	return 0

/datum/software/proc/copy(do_not_mutate = 0)
	if(flags & SOFTWARE_NOCOPY)
		return src
	var/datum/software/the_copy = new src.type()
	the_copy.name = src.name
	the_copy.flags = src.flags
	the_copy.infect_chance = src.infect_chance
	the_copy.mutate_on_copy_chance = src.mutate_on_copy_chance
	if(can_infect)
		the_copy.can_infect = src.can_infect.Copy()
	if(cannot_infect)
		the_copy.cannot_infect = src.cannot_infect.Copy()

	if(!do_not_mutate && prob(mutate_on_copy_chance))
		mutate()
	return the_copy

/datum/software/proc/mutate()
	if(flags & SOFTWARE_NOMUTATE)
		return 0
	infect_chance = Clamp(infect_chance + rand(-2, 2), 0, 100)
	mutate_on_copy_chance = Clamp(infect_chance + rand(-2, 2), 0, 100)
	if(prob(2))
		flags ^= SOFTWARE_EMPIMMUNE
	if(prob(5))
		flags ^= SOFTWARE_SPREAD_POWERNET
	return 1

/datum/software/proc/uninfect(delete = 1)
	if(host)
		var/list/host_malware_list = get_software_list(host)
		if(host_malware_list)
			host_malware_list -= src
	host = null
	if(delete)
		qdel(src)

/datum/software/proc/infect(atom/target)
	var/target_software_list = get_software_list(target)
	if(target_software_list)
		for(var/V in target_software_list)
			var/datum/software/other = V
			if(other.on_join(src))
				qdel(src)
				return 1
		uninfect(0)// leave our old host if we already have one
		host = target
		target_software_list += src
		return 1
	if(!host)
		qdel(src)
	return 0

/datum/software/proc/onTopicCall(href, href_list)
	return 0 //returning 1 makes the topic fail.

/datum/software/proc/onEMP()
	if(!(flags & SOFTWARE_EMPIMMUNE))
		uninfect()

/datum/software/proc/onMachineTick()
	return

/datum/software/proc/onActivate(mob/user)
	return 0 //returning 1 usually makes the activation fail.
