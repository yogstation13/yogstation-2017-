
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

/proc/is_rcd(obj/O)
	if(istype(O, /obj/item/weapon/rcd))
		return 1
	var/obj/item/weapon/rapid_engineering_device/special_device = O
	return istype(special_device) && special_device.mode == RED_RCD_MODE

/proc/is_pipe_device(obj/O)
	if(istype(O, /obj/item/weapon/pipe_dispenser) || istype(O, /obj/item/device/pipe_painter) )
		return 1
	var/obj/item/weapon/rapid_engineering_device/special_device = O
	return istype(special_device) && special_device.mode == RED_RPD_MODE

/proc/get_airlock_painter(obj/O)
	if(istype(O, /obj/item/weapon/airlock_painter))
		return O
	var/obj/item/weapon/rapid_engineering_device/special_device = O
	if(istype(special_device) && special_device.mode == RED_AIRLOCK_PAINTER_MODE)
		return special_device.painter
	return null

/proc/is_mining_scanner(obj/O)
	return istype(O, /obj/item/device/mining_scanner) || istype(O, /obj/item/device/t_scanner/adv_mining_scanner)