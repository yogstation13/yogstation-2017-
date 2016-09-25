/datum/pai/software/atmospherics_scanner
	name = "ATMS Gaseous Detection Matrix"
	description = "Allows access to basic atmospherics data of surrounding environment through use of optical-sensory approximation."
	category = "Basic"
	sid = "atmosphericsscanner"
	ram = 5

/datum/pai/software/atmospherics_scanner/action_menu(mob/living/silicon/pai/user)
	var/dat = "<h3>Atmospheric Sensor</h4>"

	var/turf/T = get_turf(user.loc)
	if (isnull(T))
		dat += "Unable to obtain a reading.<br>"
	else
		var/datum/gas_mixture/environment = T.return_air()
		var/list/env_gases = environment.gases

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles()

		dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

		if (total_moles)
			for(var/id in env_gases)
				var/gas_level = env_gases[id][MOLES]/total_moles
				if(gas_level > 0.01)
					dat += "[env_gases[id][GAS_META][META_GAS_NAME]]: [round(gas_level*100)]%<br>"
		dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
	dat += "<a href='byond://?src=\ref[user];software=[sid];sub=0'>Refresh Reading</a> <br>"
	dat += "<br>"
	return dat

/datum/pai/software/atmospherics_scanner/action_use(mob/living/silicon/pai/user, var/args)
	return