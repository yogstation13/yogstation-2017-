/datum/pai/software/camera_jack
	name = "Surveillance Networking Interdictor"
	description = "Intercepts camera connections from stationary units."
	category = "Advanced"
	sid = "camerajack"
	ram = 0 //not yet implemented

/datum/pai/software/camera_jack/action_menu(mob/living/silicon/pai/user)
	var/dat = "<h3>Camera Jack</h3>"
	dat += "Cable status : "

	if(!user.cable)
		dat += "<font color=#FF5555>Retracted</font> <br>"
		return dat
	if(!user.cable.machine)
		dat += "<font color=#FFFF55>Extended</font> <br>"
		return dat

	var/obj/machinery/machine = user.cable.machine
	dat += "<font color=#55FF55>Connected</font> <br>"

	if(!istype(machine, /obj/machinery/camera))
		to_chat(src, "DERP")
	return dat