/**********************Shuttle Computer**************************/

/obj/machinery/computer/shuttle/mining
	name = "Mining Shuttle Console"
	desc = "Used to call and send the mining shuttle."
	circuit = /obj/item/weapon/circuitboard/computer/mining_shuttle
	shuttleId = "mining"
	possible_destinations = "mining_home;mining_away"
	no_destination_swap = 1
	notification = SUPP_FREQ
	cooldownlen = 50
	awayspeech = TRUE

/obj/machinery/computer/shuttle/mining/Topic(href, href_list)
    ..()
    if(href_list["move"])
        investigate_log("[key_name(usr)] has moved the mining shuttle", "cargo")

/obj/machinery/computer/shuttle/mining/awayspeech()
	return "The [shuttleId] shuttle is flying to [current_destination == "mining_home" ? "the station" : "lavaland"]!"