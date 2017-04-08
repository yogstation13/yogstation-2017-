

/mob/dead/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/joining_forbidden = 0

	flags = NONE

	invisibility = INVISIBILITY_ABSTRACT

	density = 0
	stat = DEAD
	canmove = 0

	anchored = 1	//  don't get pushed around
	var/mob/living/new_character	//for instant transfer once the round is set up

/mob/dead/new_player/Initialize()
	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE
	tag = "mob_[next_mob_id++]"
	GLOB.mob_list += src

	if(client && SSticker.state == GAME_STATE_STARTUP)
		var/obj/screen/splash/S = new(client, TRUE, TRUE)
		S.Fade(TRUE)

	if(length(GLOB.newplayer_start))
		loc = pick(GLOB.newplayer_start)
	else
		loc = locate(1,1,1)

/mob/dead/new_player/proc/new_player_panel()

	var/output = "<center><p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

<<<<<<< HEAD:code/modules/mob/new_player/new_player.dm
	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(joining_forbidden)
			output += "<p><span class='linkOff'>Ready</span> <span class='linkOff'>X</span></p>"
		else if(ready)
			output += "<p><span class='linkOn'><b>Ready</b></span> <a href='byond://?src=\ref[src];ready=0'>X</a></p>"
=======
	if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <b>Ready</b> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc:code/modules/mob/dead/new_player/new_player.dm
		else
			output += "<p><a href='byond://?src=\ref[src];ready=1'>Ready</a> <span class='linkOff'>X</span></p>"

	else
		output += "<p><a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A></p>"
		if(joining_forbidden)
			output += "<p><span class='linkOff'>Join Game!</span></p>"
		else
			output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		if (GLOB.dbcon.Connect())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/DBQuery/query_get_new_polls = GLOB.dbcon.NewQuery("SELECT id FROM [format_table_name("poll_question")] WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM [format_table_name("poll_vote")] WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM [format_table_name("poll_textreply")] WHERE ckey = \"[ckey]\")")
			if(!query_get_new_polls.Execute())
				return
			var/newpoll = 0
			if(query_get_new_polls.NextRow())
				newpoll = 1

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	output += "</center>"

	//src << browse(output,"window=playersetup;size=210x240;can_close=0")
	var/datum/browser/popup = new(src, "playersetup", "<div align='center'>New Player Options</div>", 220, 265)
	popup.set_window_options("can_close=0")
	popup.set_content(output)
	popup.open(0)
	return

<<<<<<< HEAD:code/modules/mob/new_player/new_player.dm
/mob/new_player/proc/disclaimer()
	client.getFiles('html/rules.html')
	var/brandnew = 0
	var/window_height = 300 //So it's not mostly empty, in case there's no updates
	if(client.player_age == -1)
		brandnew = 1
		joining_forbidden = 1
		client.player_age = 0 // set it from -1 to 0 so the job selection code doesn't have a panic attack
	var/current_agree = client.prefs.agree
	var/output = ""
	output += "Welcome [brandnew ? "" : "back "]to Yogstation!<br>"
	if(brandnew)
		output += "This appears to be your first time here. Please take a moment to read the server rules.<br>You will not be able to join this round. Take this time to acknowledge yourself with the map, rules, and playstyle.<br>Don't forget to set up your character preferences!<br>"
	else if(current_agree == -1)
		output += "Please read the server rules carefully. To stop receiving this popup, contact an administrator using Adminhelp (F1).<br>"

	if(current_agree > 0)
		output += "Even though you've been here before, there's been an update to the rules, which is why you're seeing this message.<br>"
		output += "<br><b>There has been an update in the server rules:</b><br>"
		if(current_agree < 2)
			window_height += 30
			output += "Wizard added to murderboning exception list.<br>\
			Added rule 0.6 (Use proper IC language).<br>"
		if(current_agree < 3)
			window_height += 30
			output += "Added rule 0.8 (Use common sense).<br>\
			Added rule 1.3 (Do not act as antagonist when not).<br>\
			Expanded rule 0.7 (Listen to admins).<br>\
			Griefing and powergaming rules now mention critting as well as killing.<br>"
		if(current_agree < 4)
			window_height += 100
			output += "Expanded rule 0.7 (Listen to admins).<br>\
			Slightly expanded rules 1.3 (Do not act as antagonist when not), 1.4 (Do not powergame), and 1.5 (Do not metagame).<br>\
			Added specific metagaming rules related to various antagonists:<br>\
				1.5.1 (Nanotrasen standard procedure related to unknown alien organisms),<br>\
				1.5.2 (Nanotrasen standard procedure related to unauthorized religious activity),<br>\
				1.5.3 (Nanotrasen standard procedure related to widespread disregard for the chain of command).<br>\
			This section will be expanded in the future.<br>\
			Expanded rule 1.7 (Demonstrate clone memory disorder).<br>\
			Noticeably relaxed rule 2.1.1 (Do not murderbone).<br>\
			Updated rules 2.1.2 (Be active when playing a round defining antagonist) and 2.1.3 (Be a true revolutionary or gangster) to cover new gamemodes.<br>\
			Expanded rule 2.3.2 (Know who is human).<br>\
			Expanded rules 3.5.2 (Do not carry around harmful chemicals) and 3.5.3 (Do not misrepresent chemicals being given to people).<br>"
		//Jump to 6 to standartize the number to which you compare it to - before this, we compared it to number that's 1 less than the "current rule revision" (defined as MAXAGREE). This is now fixed and consistent - you compare the current_agree with the exact number of MAXAGREE that you set in _compile_options.dm
		if(current_agree < 6)
			window_height += 20
			output += "Reimplemented 2.1.1 (Do not murderbone), please read the full version of it via the Rules button on the top right panel.<br>"
	else
		output += "<br>Please familiarize yourself with the rules of our server before playing."
		output += "<br>Violation of server rules can lead to a ban from certain roles, a temporary ban, or a permanent ban.<br>"
		output += "If you have trouble understanding some of the game mechanics, check out the wiki.<br>"
		output += "Any remaining questions can be resolved by using Adminhelp (F1).<br>"

	output += "<p><center><a href='byond://?src=\ref[src];drules=1'>Server Rules</A>&nbsp\
		<a href='byond://?src=\ref[src];dtgwiki=1'>Wiki</A>&nbsp<a href='byond://?src=\ref[src];dismiss=1'>Dismiss</A></center></p>"

	window_height = min(window_height, 600) //Height still capped

	var/datum/browser/popup = new(src, "disclaimer", "<div align='center'>IMPORTANT</div>", 700, window_height)
	popup.set_window_options("can_close=0")
	popup.set_content(output)
	popup.open(0)
	return

/mob/new_player/Stat()
=======
/mob/dead/new_player/Stat()
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc:code/modules/mob/dead/new_player/new_player.dm
	..()

	if(statpanel("Lobby"))
		stat("Game Mode:", (SSticker.hide_mode) ? "Secret" : "[GLOB.master_mode]")
		stat("Map:", SSmapping.config.map_name)

		if(SSticker.current_state == GAME_STATE_PREGAME)
			var/time_remaining = SSticker.GetTimeLeft()
			if(time_remaining >= 0)
				time_remaining /= 10
			stat("Time To Start:", (time_remaining >= 0) ? "[round(time_remaining)]s" : "DELAYED")

			stat("Players:", "[SSticker.totalPlayers]")
			if(client.holder)
				stat("Players Ready:", "[SSticker.totalPlayersReady]")


/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr)
		return 0

	if(!client)
		return 0

	//Determines Relevent Population Cap
	var/relevant_cap
	if(config.hard_popcap && config.extreme_popcap)
		relevant_cap = min(config.hard_popcap, config.extreme_popcap)
	else
		relevant_cap = max(config.hard_popcap, config.extreme_popcap)

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
			if(!client)
				return 1
			var/mob/dead/observer/observer = new()

			spawning = 1

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			to_chat(src, "<span class='notice'>Now teleporting.</span>")
			if (O)
				observer.loc = O.loc
			else
				to_chat(src, "<span class='notice'>Teleporting failed. The map is probably still loading...</span>")
			observer.key = key
			observer.client = client
			observer.set_ghost_appearance()
			if(observer.client && observer.client.prefs)
				observer.real_name = observer.client.prefs.real_name
				observer.name = observer.real_name
			observer.update_icon()
			observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			qdel(mind)

			qdel(src)
			return 1

	if(href_list["drules"])
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
		return

	if(href_list["dtgwiki"])
		src << link("http://tgstation13.org/wiki/Main_Page")
		return

	if(href_list["dismiss"])
		var/eula = alert("I have read and understood the server rules and agree to abide by them.", "Security question", "Cancel", "Agree")
		if(eula == "Agree")
			if(!client)
				return
			if(client.prefs.agree == MAXAGREE)
				return
			if(client.prefs.agree != -1)
				client.prefs.agree = MAXAGREE
				client.prefs.save_preferences()
			src << browse(null, "window=disclaimer")
			if(joining_forbidden)
				src << "Please spend this round observing the game to familiarise yourself with the map, rules, and general playstyle."
			new_player_panel();
		return

	if(href_list["late_join"])
		if(!SSticker || SSticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "<span class='danger'>The round is either not ready, or has already finished...</span>")
			return

		if(href_list["late_join"] == "override")
			LateChoices()
			return

		if(SSticker.queued_players.len || (relevant_cap && living_player_count() >= relevant_cap && !(ckey(key) in GLOB.admin_datums)))
			to_chat(usr, "<span class='danger'>[config.hard_popcap_message]</span>")

			var/queue_position = SSticker.queued_players.Find(usr)
			if(queue_position == 1)
				to_chat(usr, "<span class='notice'>You are next in line to join the game. You will be notified when a slot opens up.</span>")
			else if(queue_position)
				to_chat(usr, "<span class='notice'>There are [queue_position-1] players in front of you in the queue to join the game.</span>")
			else
				SSticker.queued_players += usr
				to_chat(usr, "<span class='notice'>You have been added to the queue to join the game. Your position in queue is [SSticker.queued_players.len].</span>")
			return
		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])

		if(!GLOB.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return

		if(SSticker.queued_players.len && !(ckey(key) in GLOB.admin_datums))
			if((living_player_count() >= relevant_cap) || (src != SSticker.queued_players[1]))
				to_chat(usr, "<span class='warning'>Server is full.</span>")
				return

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])
		handle_player_polling()
		return

	if(href_list["pollid"])
		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid) && IsInteger(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		//lets take data from the user to decide what kind of poll this is, without validating it
		//what could go wrong
		switch(votetype)
			if(POLLTYPE_OPTION)
				var/optionid = text2num(href_list["voteoptionid"])
				if(vote_on_poll(pollid, optionid))
					to_chat(usr, "<span class='notice'>Vote successful.</span>")
				else
					to_chat(usr, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
			if(POLLTYPE_TEXT)
				var/replytext = href_list["replytext"]
				if(log_text_poll_reply(pollid, replytext))
					to_chat(usr, "<span class='notice'>Feedback logging successful.</span>")
				else
					to_chat(usr, "<span class='danger'>Feedback logging failed, please try again or contact an administrator.</span>")
			if(POLLTYPE_RATING)
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					                            //(protip, this stops no exploits)
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating) || !IsInteger(rating))
								return

						if(!vote_on_numval_poll(pollid, optionid, rating))
							to_chat(usr, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
							return
				to_chat(usr, "<span class='notice'>Vote successful.</span>")
			if(POLLTYPE_MULTI)
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						var/i = vote_on_multi_poll(pollid, optionid)
						switch(i)
							if(0)
								continue
							if(1)
								to_chat(usr, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
								return
							if(2)
								to_chat(usr, "<span class='danger'>Maximum replies reached.</span>")
								break
				to_chat(usr, "<span class='notice'>Vote successful.</span>")
			if(POLLTYPE_IRV)
				if (!href_list["IRVdata"])
					to_chat(src, "<span class='danger'>No ordering data found. Please try again or contact an administrator.</span>")
				var/list/votelist = splittext(href_list["IRVdata"], ",")
				if (!vote_on_irv_poll(pollid, votelist))
					to_chat(src, "<span class='danger'>Vote failed, please try again or contact an administrator.</span>")
					return
				to_chat(src, "<span class='notice'>Vote successful.</span>")

<<<<<<< HEAD:code/modules/mob/dead/new_player/new_player.dm
/mob/dead/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return 0
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(job.title == "Assistant")
			if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
				return 1
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return 0
		else
			return 0
	if(jobban_isbanned(src,rank))
		return 0
	if(!job.player_old_enough(src.client))
		return 0
	if(config.enforce_human_authority && !client.prefs.pref_species.qualifies_for_rank(rank, client.prefs.features))
		return 0
	return 1


/mob/dead/new_player/proc/AttemptLateSpawn(rank)
	if(!IsJobAvailable(rank))
		alert(src, "[rank] is not available. Please try another.")
=======
/mob/new_player/proc/AttemptLateSpawn(rank)
	if(!SSjob.IsJobAvailable(rank, src))
		src << alert("[rank] is not available. Please try another.")
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee:code/modules/mob/new_player/new_player.dm
		return 0
	
	if(SSticker.late_join_disabled)
		alert(src, "An administrator has disabled late join spawning.")
		return FALSE

	if(SSshuttle.arrivals)
		close_spawn_windows()	//In case we get held up
		if(SSshuttle.arrivals.damaged && config.arrivals_shuttle_require_safe_latejoin)
			src << alert("The arrivals shuttle is currently malfunctioning! You cannot join.")
			return FALSE

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	SSjob.AssignRole(src, rank, 1)

<<<<<<< HEAD:code/modules/mob/new_player/new_player.dm
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character.mind.quiet_round = character.client.prefs.toggles & QUIET_ROUND
=======
	var/mob/living/character = create_character(TRUE)	//creates the human and transfers vars and mind
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc:code/modules/mob/dead/new_player/new_player.dm
	var/equip = SSjob.EquipRank(character, rank, 1)
	if(isliving(equip))	//Borgs get borged in the equip, so we need to make sure we handle the new mob.
		character = equip

<<<<<<< HEAD:code/modules/mob/new_player/new_player.dm
	var/D = pick(latejoin)
=======
	var/D
	if(GLOB.latejoin.len)
		D = get_turf(pick(GLOB.latejoin))
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc:code/modules/mob/dead/new_player/new_player.dm
	if(!D)
		for(var/turf/T in get_area_turfs(/area/shuttle/arrival))
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					D = T
					continue

	character.loc = D
	character.update_parallax_teleport()

	var/atom/movable/chair = locate(/obj/structure/chair) in character.loc
	if(chair)
		chair.buckle_mob(character)

	SSticker.minds += character.mind

	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	if(humanc)	//These procs all expect humans
		GLOB.data_core.manifest_inject(humanc)
		if(SSshuttle.arrivals)
			SSshuttle.arrivals.QueueAnnounce(humanc, rank)
		else
			AnnounceArrival(humanc, rank)
		AddEmploymentContract(humanc)
		if(GLOB.highlander)
			to_chat(humanc, "<span class='userdanger'><i>THERE CAN BE ONLY ONE!!!</i></span>")
			humanc.make_scottish()

	GLOB.joined_player_list += character.ckey

	if(config.allow_latejoin_antagonists && humanc && !character.mind.quiet_round)	//Borgs aren't allowed to be antags. Will need to be tweaked if we get true latejoin ais.
		if(SSshuttle.emergency)
			switch(SSshuttle.emergency.mode)
				if(SHUTTLE_RECALL, SHUTTLE_IDLE)
					SSticker.mode.make_antag_chance(humanc)
				if(SHUTTLE_CALL)
					if(SSshuttle.emergency.timeLeft(1) > initial(SSshuttle.emergencyCallTime)*0.5)
						SSticker.mode.make_antag_chance(humanc)
	qdel(src)

/mob/dead/new_player/proc/AddEmploymentContract(mob/living/carbon/human/employee)
	//TODO:  figure out a way to exclude wizards/nukeops/demons from this.
	sleep(30)
	for(var/C in GLOB.employmentCabinets)
		var/obj/structure/filingcabinet/employment/employmentCabinet = C
		if(!employmentCabinet.virgin)
			employmentCabinet.addFile(employee)


/mob/dead/new_player/proc/LateChoices()
	var/mills = world.time - SSticker.round_start_time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<div class='notice'>Round Duration: [round(hours)]h [round(mins)]m</div>"

	if(SSshuttle.emergency)
		switch(SSshuttle.emergency.mode)
			if(SHUTTLE_ESCAPE)
				dat += "<div class='notice red'>The station has been evacuated.</div><br>"
			if(SHUTTLE_CALL)
				if(!SSshuttle.canRecall())
					dat += "<div class='notice red'>The station is currently undergoing evacuation procedures.</div><br>"

	if(ticker.identification_console_message)
		dat += "<div class='notice'>[station_name()] has delievered the following message, \"[ticker.identification_console_message]\"</div><br>"

	var/available_job_count = 0
	for(var/datum/job/job in SSjob.occupations)
		if(job && SSjob.IsJobAvailable(job.title, src))
			available_job_count++;

	if(length(SSjob.prioritized_jobs))
<<<<<<< HEAD:code/modules/mob/dead/new_player/new_player.dm
		dat += "<div class='notice red'>The station has flagged these jobs as high priority:<br>"
		var/amt = length(SSjob.prioritized_jobs)
		var/amt_count
		for(var/datum/job/a in SSjob.prioritized_jobs)
			amt_count++
			if(amt_count != amt) // checks for the last job added.
				dat += " [a.title], "
			else
				dat += " [a.title]. </div>"
=======
		dat += "<div class='notice'>The Head of Personnel has flagged these jobs as high priority:"
		var/amt = length(SSjob.prioritized_jobs)
		var/amt_count
		for(var/a in SSjob.prioritized_jobs)
			amt_count++
			if(amt_count == amt) // checks for the last job added.
				if(amt == 1) // we only have one prioritized job.
					dat += " [a]"
				else if(amt == 2)
					dat += " and [a]"
				else
					dat += ", and [a]"
			else
				dat += " [a][amt == 2 ? "" : ","]" // this is to prevent "Jaintor, and Medical Doctor" so it outputs "Jaintor and Medical Doctor"
		dat += "</div><br>"
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee:code/modules/mob/new_player/new_player.dm

	dat += "<div class='clearBoth'>Choose from the following open positions:</div><br>"
	dat += "<div class='jobs'><div class='jobsColumn'>"
	var/job_count = 0
	for(var/datum/job/job in SSjob.occupations)
		if(job && SSjob.IsJobAvailable(job.title, src))
			job_count++;
			var/prior
			if (job_count > round(available_job_count / 2))
				dat += "</div><div class='jobsColumn'>"
			var/position_class = "otherPosition"
<<<<<<< HEAD:code/modules/mob/dead/new_player/new_player.dm
			if (job.title in GLOB.command_positions)
				position_class = "commandPosition"
			dat += "<a class='[position_class]' href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions])</a><br>"
=======
			if (job.title in SSjob.prioritized_jobs)
				prior = TRUE

			dat += "<a class='[position_class]' href='byond://?src=\ref[src];SelectedJob=[job.title]'><span class='[prior ? "good" : ""]'>[prior ? "(!)" : ""][job.title]</span> ([job.current_positions])</a><br>"
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee:code/modules/mob/new_player/new_player.dm
	if(!job_count) //if there's nowhere to go, assistant opens up.
		for(var/datum/job/job in SSjob.occupations)
			if(job.title != "Assistant") continue
			dat += "<a class='otherPosition' href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions])</a><br>"
			break
	dat += "</div></div>"

	// Removing the old window method but leaving it here for reference
	//src << browse(dat, "window=latechoices;size=300x640;can_close=1")

	// Added the new browser window method
	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 440, 500)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(dat)
	popup.open(0) // 0 is passed to open so that it doesn't use the onclose() proc


/mob/dead/new_player/proc/create_character(transfer_after)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/H = new(loc)

	if(config.force_random_names || jobban_isbanned(src, "appearance"))
		client.prefs.random_character()
		client.prefs.real_name = client.prefs.pref_species.random_name(gender,1)
	client.prefs.copy_to(H)
	H.dna.update_dna_identity()
	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.transfer_to(H)					//won't transfer key since the mind is not active

	H.name = real_name

	. = H
	new_character = .
	if(transfer_after)
		transfer_character()

/mob/dead/new_player/proc/transfer_character()
	. = new_character
	if(.)
		new_character.key = key		//Manually transfer the key to log them in
		new_character.stop_sound_channel(CHANNEL_LOBBYMUSIC)

/mob/dead/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Crew Manifest</h4>"
	dat += GLOB.data_core.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=387x420;can_close=1")

/mob/dead/new_player/Move()
	return 0


/mob/dead/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=latechoices") //closes late job selection
