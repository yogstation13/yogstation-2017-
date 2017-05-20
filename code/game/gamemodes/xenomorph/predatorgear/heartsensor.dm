
/************************** HEART SENSOR ********************************/

#define HEARTSENSORCD 500

/datum/action/item_action/heartsensor
	name = "Toggle HeartSensor"
	button_icon_state = "heartsensor-off"

/obj/item/heartsensor
	name = "persistent heart sensor"
	desc = "Rapidly searches for, and reports back heartbeats."
	var/status = FALSE
	var/cooldown
	var/sensing
	var/mob/living/owner
	actions_types = list(/datum/action/item_action/heartsensor)

/obj/item/heartsensor/New()
	..()
	SSobj.processing |= src
	//START_PROCESSING(SSobj, src)

/obj/item/heartsensor/Destroy()
	..()
	SSobj.processing.Remove(src)
	//STOP_PROCESSING(SSobj, src)

/obj/item/heartsensor/examine(mob/user)
	..()
	user << "<span class='warning'>[src] is [cooldown == TRUE ? "on a cooldown" : "operating at top effieincy"].</span>"

/obj/item/heartsensor/attack_self(mob/user)
	status = !status
	user << "<span class='warning'>You [status ? "enable" : "disable"] [src].</span>"
	owner = user
	for(var/datum/action/item_action/heartsensor/H in actions)
		H.button_icon_state = "heartsensor-[status ? "on" : "off"]"
		H.UpdateButtonIcon()

/obj/item/heartsensor/process()
	if(!status)
		return

	if(!cooldown)
		if(owner)
			scan(owner)

/obj/item/heartsensor/proc/scan(mob/user)
	var/range = 7
	var/list/discovered = list()
	var/turf/T = get_turf(user)
	user << "<span class='warning'>Scanning...</span>"

	var/start_range = 7
	var/range_increment = 7
	var/max_range = 21
	for (var/i = start_range, i <= max_range, i += range_increment)
		for(var/mob/living/carbon/human/H in orange(range, T))
			if(H.stat == DEAD)
				continue
			if((H in discovered))
				continue
			if(H == user)
				continue
			discovered += H
			playsound(user, 'sound/items/predatorheartbeat.ogg', 50+i*4, 1)
			user << "<span class='warning'>You sense [H] within [range] tiles [dir2text(get_dir(get_turf(user), get_turf(H)))].</span>"
			sleep(15) // take a breather! that heartbeat.ogg plays for like 2 seconds
	cooldown = TRUE
	addtimer(src, "revertcooldown", HEARTSENSORCD)

/obj/item/heartsensor/proc/revertcooldown()
	cooldown = FALSE

#undef HEARTSENSORCD