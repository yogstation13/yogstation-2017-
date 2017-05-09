/datum/wires/emitter
	holder_type = /obj/machinery/power/emitter

/datum/wires/emitter/New(atom/holder)
	wires = list(
		WIRE_ACTIVATE, WIRE_DISABLE,
		WIRE_BOOM
	)
	add_duds(2)
	..()

/datum/wires/emitter/interactable(mob/user)
	var/obj/machinery/power/emitter/EM = holder
	if(EM.wires_exposed)
		return TRUE

/datum/wires/emitter/get_status()
	var/obj/machinery/power/emitter/EM = holder
	var/list/status = list()
	status += "The power light is [EM.active ? "on" : "off"]."
	return status

/datum/wires/emitter/on_pulse(wire)
	var/obj/machinery/power/emitter/EM = holder
	switch(wire)
		if(WIRE_ACTIVATE)
			EM.active = TRUE
			EM.shot_number = 0
			EM.fire_delay = EM.maximum_fire_delay
			EM.update_icon()
		if(WIRE_DISABLE)
			message_admins("[key_name(usr)] has turned off [holder.name] through the wiring")
			EM.active = FALSE
			EM.update_icon()
		if(WIRE_BOOM)
			EM.singleFire()

/datum/wires/emitter/on_cut(wire, mend)
	var/obj/machinery/power/emitter/EM = holder
	if(!mend)
		switch(wire)
			if(WIRE_ACTIVATE)
				EM.can_activate = FALSE
			if(WIRE_DISABLE)
				EM.can_deactivate = FALSE
			if(WIRE_BOOM)
				EM.can_fire = FALSE
	else
		switch(wire)
			if(WIRE_ACTIVATE)
				EM.can_activate = TRUE
			if(WIRE_DISABLE)
				EM.can_deactivate = TRUE
			if(WIRE_BOOM)
				EM.can_fire = TRUE
