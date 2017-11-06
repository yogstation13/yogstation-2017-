#define SYNDICATE_CHALLENGE_TIMER 12000 //20 minutes

/obj/machinery/computer/shuttle/syndicate
	name = "syndicate shuttle terminal"
	circuit = /obj/item/weapon/circuitboard/computer/syndicate_shuttle
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	req_access = list(access_syndicate)
	shuttleId = "syndicate"
	possible_destinations = "syndicate_away;syndicate_z5;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"

/obj/machinery/computer/shuttle/syndicate/recall
	name = "syndicate shuttle recall terminal"
	possible_destinations = "syndicate_away"


/obj/machinery/computer/shuttle/syndicate/Topic(href, href_list)
	if(href_list["move"])
		var/obj/item/weapon/circuitboard/computer/syndicate_shuttle/board = circuit
		if(board.challenge && world.time < SYNDICATE_CHALLENGE_TIMER)
			usr << "<span class='warning'>You've issued a combat challenge to the station! You've got to give them at least [round(((SYNDICATE_CHALLENGE_TIMER - world.time) / 10) / 60)] more minutes to allow them to prepare.</span>"
			return 0
		board.moved = TRUE
	..()

/obj/item/weapon/circuitboard/computer/syndicate_shuttle
	name = "circuit board (Syndicate Shuttle)"
	build_path = /obj/machinery/computer/shuttle/syndicate
	var/challenge = FALSE
	var/moved = FALSE

/obj/item/weapon/circuitboard/computer/syndicate_shuttle/New()
	syndicate_shuttle_boards += src
	..()

/obj/item/weapon/circuitboard/computer/syndicate_shuttle/Destroy()
	syndicate_shuttle_boards -= src
	return ..()

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate
	name = "syndicate shuttle navigation computer"
	desc = "Used to designate a precise transit location for the syndicate shuttle."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	z_lock = ZLEVEL_STATION
	shuttleId = "syndicate"
	shuttlePortId = "syndicate_custom"
	shuttlePortName = "custom location"
	jumpto_ports = list("syndicate_away", "syndicate_z5", "syndicate_ne", "syndicate_nw", "syndicate_n", "syndicate_se", "syndicate_sw", "syndicate_s")
	view_range = 13
	x_offset = -4
	y_offset = -2


/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/checkLandingTurf(turf/T)
	return ..() && isspaceturf(T)

#undef SYNDICATE_CHALLENGE_TIMER