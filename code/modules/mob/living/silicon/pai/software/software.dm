/datum/pai/software
	var/name = "Prototype Software"
	var/description = "The basic software upon which all else is based."
	var/category = "" //for listing categories in pAI interface
	var/sid = "software" //marker used inside Topic, set to a single word based on the software
	var/hrefline = 0 //signal that the software uses an overwritten href line for right-side menu display (see action_hrefline)

	var/ram = 0 //amount of ram resource required by the pAI to use this

/datum/pai/software/proc/action_use(mob/user, var/args)
	//thrown when the user accesses the software via the side menu once they've purchased it
	return

/datum/pai/software/proc/action_installed(mob/user)
	//thrown when the user purchases the software for the first time
	//use this to add things like verbs, hud displays, etc
	return

/datum/pai/software/proc/action_menu(mob/user)
	//return the required HTML that will be shown in the menu for the user
	return

/datum/pai/software/proc/action_hrefline(mob/user)
	//populate with code that gives a custom href line format (for HUDs with On/Off displays etc, see medical_hud and security_hud)
	return