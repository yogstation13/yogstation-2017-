
/proc/is_plant_analyzer(var/O)
	if(istype(O, /obj/item/device/plant_analyzer))
		return 1
	if(istype(O, /obj/item/device/pda))
		var/obj/item/device/pda/A = O
		if(A.scanmode == PDA_SCAN_FLORAL)
			return 1
	return 0

/proc/is_health_analyzer(var/O)
	if(istype(O, /obj/item/device/healthanalyzer))
		return 1
	if(istype(O, /obj/item/device/pda))
		var/obj/item/device/pda/A = O
		if(A.scanmode == PDA_SCAN_MEDICAL)
			return 1
	return 0

/proc/is_power_meter(var/O)
	if(istype(O, /obj/item/device/multitool))
		return 1
	if(istype(O, /obj/item/device/pda))
		var/obj/item/device/pda/A = O
		if(A.scanmode == PDA_SCAN_POWER)
			return 1
	return 0