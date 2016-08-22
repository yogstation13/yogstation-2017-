///////////////////////
//Antivirus
///////////////////////

/datum/software/antivirus
	name = "antivirus"
	flags = SOFTWARE_NOSPREAD|SOFTWARE_NOMUTATE
	var/antivirus_strength = 0

/datum/software/antivirus/on_join(datum/software/other)
	if(..())
		return 1
	if(antivirus_check(other))
		return 1
	return 0

/datum/software/antivirus/copy()
	var/datum/software/antivirus/the_copy = ..()
	if(the_copy)
		the_copy.antivirus_strength = src.antivirus_strength
	return the_copy

/datum/software/antivirus/proc/antivirus_check(datum/software/malware/M)
	if(!istype(M))
		return 0
	if(M.flags & SOFTWARE_ANTIVIRUS_IMMUNE)
		return 0
	if(prob(antivirus_strength - M.antivirus_resistance))
		return 1
	return 0

///////////////////////
//Standard Antivirus
///////////////////////
/datum/software/antivirus/nt_antivirus
	name = "\improper NT antivirus"
	antivirus_strength = 100
	var/wait_time = 100
	var/timerID = 0

/datum/software/antivirus/nt_antivirus/infect()
	if(..())
		antivirus_sweep()
		return 1
	return 0

/datum/software/antivirus/nt_antivirus/proc/antivirus_sweep()
	if(host)
		var/list/host_malware_list = host.get_software_list()
		if(host_malware_list)
			for(var/V in host_malware_list)
				var/datum/software/M = V
				if(antivirus_check(M))
					M.uninfect()
			timerID = addtimer(src, "antivirus_sweep", wait_time)

/datum/software/antivirus/nt_antivirus/uninfect()
	deltimer(timerID)
	timerID = 0
	..()

///////////////////////
//PC Cleaner
///////////////////////
//tries to clean the device once and then deletes itself.
/datum/software/antivirus/cleaner
	name = "\improper NT PC cleaner"
	antivirus_strength = 100

/datum/software/antivirus/cleaner/infect()
	if(..())
		if(host)
			var/list/host_malware_list = host.get_software_list()
			if(host_malware_list)
				for(var/V in host_malware_list)
					var/datum/software/M = V
					if(antivirus_check(M))
						M.uninfect()
		uninfect()
		return 1
	return 0
