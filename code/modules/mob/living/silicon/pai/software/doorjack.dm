/datum/pai/software/doorjack
	name = "Airlock Security Cipherneut Mechanism"
	description = "Clandestine brute-forcing tool for subverting airlock authorization locks. Definitely not legal in most stations. RAM intensive."
	category = "Advanced"
	sid = "doorjack"
	ram = 30

/datum/pai/software/doorjack/action_use(mob/living/silicon/pai/user, var/args)
	if(args["jack"])
		if(user.cable && user.cable.machine)
			user.hackdoor = user.cable.machine
			hackloop(user)
	if(args["cancel"])
		user.hackdoor = null
	if(args["cable"])
		var/turf/T = get_turf(user.loc)
		user.cable = new /obj/item/weapon/pai_cable(T)
		T.visible_message("<span class='warning'>A port on [user] opens to reveal [user.cable], which promptly falls to the floor.</span>",
			"<span class='italics'>You hear the soft click of something light and hard falling to the ground.</span>")

/datum/pai/software/doorjack/proc/hackloop(mob/living/silicon/pai/user)
	var/turf/T = get_turf(user.loc)
	for(var/mob/living/silicon/ai/AI in player_list)
		if(T.loc)
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>")
		else
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>")
	while(user.hackprogress < 100)
		if(user.cable && user.cable.machine && istype(user.cable.machine, /obj/machinery/door) && user.cable.machine == user.hackdoor && get_dist(user, user.hackdoor) <= 1)
			user.hackprogress += rand(1, 10)
		else
			user.temp = "Door Jack: Connection to airlock has been lost. Hack aborted."
			user.hackprogress = 0
			user.hackdoor = null
			return
		if(user.hackprogress >= 100)		// This is clunky, but works. We need to make sure we don't ever display a progress greater than 100,
			user.hackprogress = 100		// but we also need to reset the progress AFTER it's been displayed
		if(user.screen == "doorjack" && user.subscreen == 0) // Update our view, if appropriate
			user.paiInterface()
		if(user.hackprogress >= 100)
			user.hackprogress = 0
			user.cable.machine:open()
		sleep(50)			// Update every 5 seconds

/datum/pai/software/doorjack/action_menu(mob/living/silicon/pai/user)
	var/dat = "<h3>Airlock Jack</h3>"
	dat += "Cable status : "
	if(!user.cable)
		dat += "<font color=#FF5555>Retracted</font> <br>"
		dat += "<a href='byond://?src=\ref[user];software=[sid];cable=1;sub=0'>Extend Cable</a> <br>"
		return dat
	if(!user.cable.machine)
		dat += "<font color=#FFFF55>Extended</font> <br>"
		return dat

	var/obj/machinery/machine = user.cable.machine
	dat += "<font color=#55FF55>Connected</font> <br>"
	if(!istype(machine, /obj/machinery/door))
		dat += "Connected device's firmware does not appear to be compatible with Airlock Jack protocols.<br>"
		return dat

	if(!user.hackdoor)
		dat += "<a href='byond://?src=\ref[user];software=[sid];jack=1;sub=0'>Begin Airlock Jacking</a> <br>"
	else
		dat += "Jack in progress... [user.hackprogress]% complete.<br>"
		dat += "<a href='byond://?src=\ref[user];software=[sid];cancel=1;sub=0'>Cancel Airlock Jack</a> <br>"
	return dat