/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "telecommunication relay"
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 30
	machinetype = 8
	//heatgen = 0
	netspeed = 5
	long_range_link = 1
	var/broadcasting = 1
	var/receiving = 1

/obj/machinery/telecomms/relay/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// Add our level and send it back
	if(can_send(signal))
		signal.data["level"] |= listening_level

// Checks to see if it can send/receive.

/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if(!on)
		return 0
	if(!is_freq_listening(signal))
		return 0
	return 1

/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return 0
	return broadcasting

/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return 0
	return receiving

/obj/machinery/telecomms/relay/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/telecomms/relay(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/telecomms/relay
	name = "Relay Mainframe (Machine Board)"
	build_path = /obj/machinery/telecomms/relay
	origin_tech = "programming=2;engineering=2;bluespace=2"
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

// Off-Site Relays
// You are able to send/receive signals from the station's z level if the relay is on the telecomm satellite

/obj/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(listening_level == ZLEVEL_STATION) // equals the station
		listening_level = position.z
		return 1
	else if(position.z == ZLEVEL_ABANDONNEDTSAT)
		listening_level = ZLEVEL_STATION
		return 1
	return 0


/obj/machinery/telecomms/relay/Options_Menu()
	var/dat = ""
	if(src.z == ZLEVEL_ABANDONNEDTSAT)
		dat += "<br>Signal Locked to Station: <A href='?src=\ref[src];change_listening=1'>[listening_level == ZLEVEL_STATION ? "TRUE" : "FALSE"]</a>"
	dat += "<br>Broadcasting: <A href='?src=\ref[src];broadcast=1'>[broadcasting ? "YES" : "NO"]</a>"
	dat += "<br>Receiving:    <A href='?src=\ref[src];receive=1'>[receiving ? "YES" : "NO"]</a>"
	return dat

/obj/machinery/telecomms/relay/Options_Topic(href, href_list)

	if(href_list["receive"])
		receiving = !receiving
		temp = "<font color = #666633>-% Receiving mode changed. %-</font color>"
	if(href_list["broadcast"])
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% Broadcasting mode changed. %-</font color>"
	if(href_list["change_listening"])
		//Lock to the station OR lock to the current position!
		var/result = toggle_level()
		if(result)
			temp = "<font color = #666633>-% [src]'s signal has been successfully changed.</font color>"
		else
			temp = "<font color = #666633>-% [src] could not lock it's signal onto the station.</font color>"


//Preset Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/machinery/telecomms/relay/preset/station
	id = "Station Relay"
	listening_level = 1
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = 0
	autolinkers = list("r_relay")
