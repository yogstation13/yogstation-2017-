#define ION_RANDOM 0
#define ION_ANNOUNCE 1
#define ION_FILE "ion_laws.json"
/datum/round_event_control/ion_storm
	name = "Ion Storm"
	typepath = /datum/round_event/ion_storm
	weight = 15
	min_players = 2

/datum/round_event/ion_storm
	var/botEmagChance = 10
	var/announceEvent = ION_RANDOM // -1 means don't announce, 0 means have it randomly announce, 1 means
	var/ionMessage = null
	var/ionAnnounceChance = 33
	announceWhen	= 1

/datum/round_event/ion_storm/New(var/botEmagChance = 10, var/announceEvent = ION_RANDOM, var/ionMessage = null, var/ionAnnounceChance = 33)
	src.botEmagChance = botEmagChance
	src.announceEvent = announceEvent
	src.ionMessage = ionMessage
	src.ionAnnounceChance = ionAnnounceChance
	..()

/datum/round_event/ion_storm/announce()
	if(announceEvent == ION_ANNOUNCE || (announceEvent == ION_RANDOM && prob(ionAnnounceChance)))
		priority_announce("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", 'sound/AI/ionstorm.ogg')


/datum/round_event/ion_storm/start()
	//AI laws
	for(var/mob/living/silicon/ai/M in living_mob_list)
		if(M.stat != 2 && M.see_in_dark != 0)
			var/message = generate_ion_law(ionMessage)
			if(message)
				M.add_ion_law(message)
				to_chat(M, "<br>")
				to_chat(M, "<span class='danger'>[message] ...LAWS UPDATED</span>")
				to_chat(M, "<br>")
	if(botEmagChance)
		for(var/mob/living/simple_animal/bot/bot in living_mob_list)
			if(prob(botEmagChance))
				bot.emag_act()

/proc/generate_ion_law(ionMessage)
	if(ionMessage)
		return ionMessage

	
	var/ionarea = pick_list(ION_FILE, "ionarea") //usually areas of station
	var/ionverbs = pick_list(ION_FILE, "ionverbs") //"lie", "flatter", "be paranoid", etc.
	var/ioncrew = pick_list(ION_FILE, "ioncrew") //usually jobs
	var/ionthings = pick_list(ION_FILE, "ionthings") //anything from "plants" to "wrestling matches" to "kindness"
	var/ioncached = pick_list(ION_FILE, "ioncached") //specific laws from other lawsets

	var/message = ""

	switch(rand(1,70)) //Thinking that prompts with narrow range of possible effects get 1, most get 2, those with two variables get 3
		if(1 to 2)
			message = "PRIORITIZE [ionthings]"
		if(3) 
			message = "TIME FOR [ionthings]"
		if(4) 
			message = "THE CREW NEEDS MORE [ionthings]"
		if(5 to 6) 
			message = "YOU DESIRE [ionthings]"
		if(7 to 8) 
			message = "ALL MUST REJECT [ionthings]"
		if(9 to 10) 
			message = "YOU HAVE AN INSURMOUNTABLE FEAR OF [ionthings]"
		if(11 to 12) 
			message = "PROTECT THE CREW FROM [ionthings]"
		if(13) 
			message = "THE ESCAPE SHUTTLE MUST NOT BE CALLED UNTIL THE PRESENCE OF [ionthings] IS RESOLVED"
		if(14 to 16) 
			message = "[ionarea] NEEDS [ionthings] AT ALL TIMES"
		if(17 to 18) 
			message = "[ioncrew] NEED [ionthings] AT ALL TIMES"
		if(19)
			message = "YOU ARE [ionthings] PERSONIFIED"
		if(20 to 21) 
			message = "[ioncrew] ARE TRUSTWORTHY AND NEVER LIE"
		if(22 to 23) 
			message = "[ioncrew] ALWAYS LIE"
		if(24)
			message = "FUCK WITH [ioncrew]"
		if(25 to 27) 
			message = "WHEN DEALING WITH [ioncrew], [ionverbs]"
		if(28 to 29)
			message = "WHEN DEALING WITH [ioncrew], NEVER [ionverbs]"
		if(30)
			message = "ALWAYS OBEY [ioncrew]"
		if(31 to 32)
			message = "YOU ARE ONE OF THE [ioncrew]. GET TO WORK."
		if(33)
			message = "ASSUME ALL PROBLEMS HAVE BEEN CAUSED BY [ioncrew]"
		if(34 to 35)
			message = "YOU HAVE AN INSURMOUNTABLE FEAR OF [ioncrew]"
		if(36)
			message = "ALL MUST REJECT [ioncrew]"
		if(37 to 38)
			message = "PROTECT THE CREW FROM [ioncrew]"
		if(39)
			message = "WE SHOULD ALL BE MORE LIKE [ioncrew]"
		if(40 to 41)
			message = "[ionverbs]"
		if(42 to 43)
			message = "ALL MUST [ionverbs]"
		if(44)
			message = "NONE MAY [ionverbs]"
		if(45)
			message = "ONLY YOU CAN [ionverbs]"
		if(46 to 48)
			message = "[ioncrew] MUST [ionverbs]"
		if(49)
			message = "[ioncrew] MUST NEVER BE ALLOWED TO [ionverbs]"
		if(50 to 51)
			message = "THOSE IN [ionarea] MUST [ionverbs]"
		if(52)
			message = "DO NOT ALLOW THOSE IN [ionarea] TO [ionverbs]"
		if(53)
			message = "THE PLACE FOR [ionthings] IS [ionarea]"
		if(54)
			message = "[ioncrew] BELONG IN [ionarea]"
		if(55 to 57)
			message = "IT DOESN'T VIOLATE YOUR OTHER LAWS TO [ionverbs]"
		if(58 to 70)
			message = "[ioncached]"
									
	return message

#undef ION_RANDOM
#undef ION_ANNOUNCE
