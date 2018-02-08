//node2, air2, network2 correspond to input
//node1, air1, network1 correspond to output


/obj/machinery/atmospherics/components/binary/circulator
	name = "circulator/heat exchanger"
	desc = "A gas circulator pump and heat exchanger."
	icon_state = "circ1-off"

	var/side = CIRC_LEFT
	var/circ = null
	var/status = 0

	var/last_pressure_delta = 0

	anchored = 0
	density = 1

	var/global/const/CIRC_LEFT = 1
	var/global/const/CIRC_RIGHT = 2

	var/obj/machinery/power/generator/generator = null


/obj/machinery/atmospherics/components/binary/circulator/proc/return_transfer_air()

	var/datum/gas_mixture/air1 = AIR1
	var/datum/gas_mixture/air2 = AIR2

	var/output_starting_pressure = air1.return_pressure()
	var/input_starting_pressure = air2.return_pressure()

	if(output_starting_pressure >= input_starting_pressure-10)
		//Need at least 10 KPa difference to overcome friction in the mechanism
		last_pressure_delta = 0
		return null

	//Calculate necessary moles to transfer using PV = nRT
	if(air2.temperature>0)
		var/pressure_delta = (input_starting_pressure - output_starting_pressure)/2

		var/transfer_moles = pressure_delta*air1.volume/(air2.temperature * R_IDEAL_GAS_EQUATION)

		last_pressure_delta = pressure_delta

		//to_chat(world, "pressure_delta = [pressure_delta]; transfer_moles = [transfer_moles];")

		//Actually transfer the gas
		var/datum/gas_mixture/removed = air2.remove(transfer_moles)

		update_parents()

		return removed

	else
		last_pressure_delta = 0

/obj/machinery/atmospherics/components/binary/circulator/process_atmos()
	..()
	update_icon()

/obj/machinery/atmospherics/components/binary/circulator/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "circ[side]-p"
	else if(last_pressure_delta > 0)
		if(last_pressure_delta > ONE_ATMOSPHERE)
			icon_state = "circ[side]-run"
		else
			icon_state = "circ[side]-slow"
	else
		icon_state = "circ[side]-off"

	return 1

/obj/machinery/atmospherics/components/binary/circulator/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
		if(!anchored)
			to_chat(user, "<span class='notice'>You wrench [src] into place.</span>")
			anchored = 1
		else if(anchored)
			if(do_after(user, 20/I.toolspeed, target = src))
				to_chat(user, "<span class='notice'>You unwrench [src].")
				anchored = 0
				if(generator)
					if(circ == "hot")
						generator.hot_circ = null
					else if(circ == "cold")
						generator.cold_circ = null
					generator = null

	else
		return ..()
