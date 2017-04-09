/var/yog_round_number = 0

/world
	mob = /mob/dead/new_player
	turf = /turf/open/space/basic
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "/tg/ Station 13"
	fps = 20
	visibility = 0
#ifdef GC_FAILURE_HARD_LOOKUP
	loop_checks = FALSE
#endif

/world/New()
	log_world("World loaded at [time_stamp()]")

#if (PRELOAD_RSC == 0)
	external_rsc_urls = file2list("config/external_rsc_urls.txt","\n")
	var/i=1
	while(i<=external_rsc_urls.len)
		if(external_rsc_urls[i])
			i++
		else
			external_rsc_urls.Cut(i,i+1)
#endif
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	GLOB.href_logfile = file("data/logs/[date_string] hrefs.htm")
	GLOB.diary = file("data/logs/[date_string].log")
	GLOB.diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	GLOB.diary << "\n\nStarting up. [time_stamp()]\n---------------------"
	GLOB.diaryofmeanpeople << "\n\nStarting up. [time_stamp()]\n---------------------"
	GLOB.changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	var/roundfile = file("data/roundcount.txt")
	yog_round_number = text2num(file2text(roundfile))
	if(yog_round_number == null || yog_round_number == "" || yog_round_number == 0)
		yog_round_number = 1
	else
		yog_round_number++
	fdel(roundfile)
	text2file(num2text(yog_round_number), roundfile)

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)
	load_configuration()
	GLOB.revdata.DownloadPRDetails()
	load_mode()
	load_motd()
	refresh_admin_files()
	load_admins()
	if(config.usewhitelist)
		load_whitelist()
	jobban_loadbanfile()
	appearance_loadbanfile()
	jobban_updatelegacybans()
	LoadBans()
	load_donators()
	investigate_reset()

	setup_pretty_filter()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		config.server_name += " #[(world.port % 1000) / 100]"

	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	if(config.sql_enabled)
		if(!GLOB.dbcon.Connect())
			log_world("Your server failed to establish a connection with the database.")
		else
			log_world("Database connection established.")


	GLOB.data_core = new /datum/datacore()

<<<<<<< HEAD
	#ifdef MAP_NAME
	map_name = "[MAP_NAME]"
	#else
	map_name = "Unknown"
	#endif

	send_discord_message("public", "A new round is about to begin! Join with this address https://yogstation.net/play.php ! The current round number is **[yog_round_number]** and the chosen map is **[map_name]** <@&213375106888499200>")

	config.Tickcomp = 0
	world.fps = 20

	return
=======
	Master.Initialize(10, FALSE)
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

#define IRC_STATUS_THROTTLE 50
/world/Topic(T, addr, master, key)
	if(config && config.log_world_topic)
		GLOB.diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	var/list/input = params2list(T)
	var/key_valid = (GLOB.comms_allowed && input["key"] == GLOB.comms_key)
	var/static/last_irc_status = 0

	if("ping" in input)
		var/x = 1
		for (var/client/C in GLOB.clients)
			x++
		return x

	else if("players" in input)
		var/n = 0
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				n++
		return n

	else if("ircstatus" in input)
		if(world.time - last_irc_status < IRC_STATUS_THROTTLE)
			return
		var/list/adm = get_admin_counts()
		var/list/allmins = adm["total"]
		var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
		status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(0,1,0)]). Mode: [SSticker.mode.name]."
		send2irc("Status", status)
		last_irc_status = world.time

	else if("status" in input)
		var/list/s = list()
		s["version"] = GLOB.game_version
		s["mode"] = GLOB.master_mode
		s["respawn"] = config ? GLOB.abandon_allowed : 0
		s["enter"] = GLOB.enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["active_players"] = get_active_player_count()
		s["players"] = GLOB.clients.len
		s["revision"] = GLOB.revdata.commit
		s["revision_date"] = GLOB.revdata.date

		var/list/adm = get_admin_counts()
		var/list/presentmins = adm["present"]
		var/list/afkmins = adm["afk"]
		s["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
		s["gamestate"] = 1
		if(SSticker)
			s["gamestate"] = SSticker.current_state

		s["map_name"] = SSmapping.config.map_name

		if(key_valid && SSticker && SSticker.mode)
			s["real_mode"] = SSticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

		s["security_level"] = get_security_level()
		s["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0
		// Amount of world's ticks in seconds, useful for calculating round duration

		if(SSshuttle && SSshuttle.emergency)
			s["shuttle_mode"] = SSshuttle.emergency.mode
			// Shuttle status, see /__DEFINES/stat.dm
			s["shuttle_timer"] = SSshuttle.emergency.timeLeft()
			// Shuttle timer, in seconds

		return list2params(s)

	else if("adminwho" in input)
		var/msg = "Current Admins:\n"
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"
			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
		return msg

	else if(copytext(T,1,9) == "announce")
		if(!key_valid)
			return "Bad Key"
		else
#define CHAT_PULLR	64 //defined in preferences.dm, but not available here at compilation time
			for(var/client/C in GLOB.clients)
				if(C.prefs && (C.prefs.chat_toggles & CHAT_PULLR))
					to_chat(C, "<span class='announce'>PR: [input["announce"]]</span>")
#undef CHAT_PULLR
	else if (copytext(T,1,5) == "asay")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				var/msg = "<span class='adminobserver'><span class='prefix'>DISCORD ADMIN:</span> <EM>[input["admin"]]</EM>: <span class='message'>[input["asay"]]</span></span>"
				admins << msg
	else if (copytext(T,1,4) == "ooc")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				for(var/client/C in clients)
					//if(C.prefs.chat_toggles & CHAT_OOC) // Discord OOC should bypass preferences.
					C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>DISCORD OOC:</span> <EM>[input["admin"]]:</EM> <span class='message'>[input["ooc"]]</span></span></font>"
	else if (copytext(T,1,7) == "reboot")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				Reboot(null, null, null, null, 1)
	else if (copytext(T,1,7) == "ticket")
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				var/action = input["action"]
				var/msg = "Theres [total_unresolved_tickets()] unresolved tickets out of [tickets_list.len] tickets."
				if(action == "list")
					msg += "\nCurrent unresolved tickets:"
					for(var/i = tickets_list.len, i >= 1, i--)
						var/datum/admin_ticket/ticket = tickets_list[i]
						if(!ticket.resolved)
							msg += "\n    #[ticket.ticket_id]. Opened by: [ticket.owner_ckey] Title: \"[ticket.title]\""
				if(action == "log")
					var/datum/admin_ticket/ticket
					for(var/i = tickets_list.len, i >= 1, i--)
						var/datum/admin_ticket/ticket2 = tickets_list[i]
						if(ticket2.ticket_id == text2num(input["id"]))
							ticket = ticket2
					if(!ticket)
						return "Ticket not found"
					msg += "\n Ticket #[ticket.ticket_id] log:"
					if(ticket.ticket_id == text2num(input["id"]))
						for(var/i = 1; i <= ticket.log.len; i++)
							var/datum/ticket_log/item = ticket.log[i]
							msg += "\n    [item.toSanitizedString()]"
				if(action == "reply")
					for(var/i = tickets_list.len, i >= 1, i--)
						var/datum/admin_ticket/ticket = tickets_list[i]
						if(ticket.ticket_id == text2num(input["id"]))
							var/datum/ticket_log/log_item = null
							log_item = new /datum/ticket_log(ticket, input["admin"], input["response"], 0)
							ticket.log += log_item
							ticket.owner << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
							ticket.owner << "<span class='ticket-text-received'>-- [input["admin"]] -> [key_name_params(ticket.owner, 0, 0, null, src)]: [log_item.text]</span>"
				return msg

	else if("crossmessage" in input)
		if(!key_valid)
			return
		else
			if(input["crossmessage"] == "Ahelp")
				relay_msg_admins("<span class='adminnotice'><b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b></span>")
			if(input["crossmessage"] == "Comms_Console")
				minor_announce(input["message"], "Incoming message from [input["message_sender"]]")
				for(var/obj/machinery/computer/communications/CM in GLOB.machines)
					CM.overrideCooldown()
			if(input["crossmessage"] == "News_Report")
				minor_announce(input["message"], "Breaking Update From [input["message_sender"]]")

	else if("adminmsg" in input)
		if(!key_valid)
			return "Bad Key"
		else
			return IrcPm(input["adminmsg"],input["msg"],input["sender"])

	else if("namecheck" in input)
		if(!key_valid)
			return "Bad Key"
		else
			log_admin("IRC Name Check: [input["sender"]] on [input["namecheck"]]")
			message_admins("IRC name checking on [input["namecheck"]] from [input["sender"]]")
			return keywords_lookup(input["namecheck"],1)
	else if("adminwho" in input)
		if(!key_valid)
			return "Bad Key"
		else
			return ircadminwho()
	else if("server_hop" in input)
		show_server_hop_transfer_screen(input["server_hop"])

<<<<<<< HEAD
=======
#define WORLD_REBOOT(X) log_world("World rebooted at [time_stamp()]"); ..(X); return;
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
/world/Reboot(var/reason, var/feedback_c, var/feedback_r, var/time)
	if (reason == 1) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
<<<<<<< HEAD
		world << "<span class='boldannounce'>Rebooting World immediately due to host request</span>"
		ticker.server_reboot_in_progress = 1
		return ..(1)
=======
		to_chat(world, "<span class='boldannounce'>Rebooting World immediately due to host request</span>")
		WORLD_REBOOT(1)
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
	var/delay
	if(time)
		delay = time
	else
		delay = config.round_end_countdown * 10
	if(SSticker.delay_end)
		to_chat(world, "<span class='boldannounce'>An admin has delayed the round end.</span>")
		return
	to_chat(world, "<span class='boldannounce'>Rebooting World in [delay/10] [(delay >= 10 && delay < 20) ? "second" : "seconds"]. [reason]</span>")
	var/round_end_sound_sent = FALSE
	if(SSticker.round_end_sound)
		round_end_sound_sent = TRUE
		for(var/thing in GLOB.clients)
			var/client/C = thing
			if (!C)
				continue
			C.Export("##action=load_rsc", SSticker.round_end_sound)
	sleep(delay)
<<<<<<< HEAD
	if(blackbox)
		blackbox.save_all_data_to_sql()
	if(ticker.delay_end)
		world << "<span class='boldannounce'>Reboot was cancelled by an admin.</span>"
		ticker.server_reboot_in_progress = 0
		return
	if(mapchanging)
		world << "<span class='boldannounce'>Map change operation detected, delaying reboot.</span>"
		rebootingpendingmapchange = 1
		spawn(1200)
			if(mapchanging)
				mapchanging = 0 //map rotation can in some cases be finished but never exit, this is a failsafe
				Reboot("Map change timed out", time = 10)
=======
	if(SSticker.delay_end)
		to_chat(world, "<span class='boldannounce'>Reboot was cancelled by an admin.</span>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
		return
	OnReboot(reason, feedback_c, feedback_r, round_end_sound_sent)
	WORLD_REBOOT(0)
#undef WORLD_REBOOT

/world/proc/OnReboot(reason, feedback_c, feedback_r, round_end_sound_sent)
	feedback_set_details("[feedback_c]","[feedback_r]")
	log_game("<span class='boldannounce'>Rebooting World. [reason]</span>")
#ifdef dellogging
	var/log = file("data/logs/del.log")
	log << time2text(world.realtime)
	for(var/index in del_counter)
		var/count = del_counter[index]
		if(count > 10)
			log << "#[count]\t[index]"
#endif
	if(GLOB.blackbox)
		GLOB.blackbox.save_all_data_to_sql()
	Master.Shutdown()	//run SS shutdowns
	RoundEndAnimation(round_end_sound_sent)
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", 1) //second parameter ensures only afk clients are kicked
	to_chat(world, "<span class='boldannounce'>Rebooting world...</span>")
	for(var/thing in GLOB.clients)
		var/client/C = thing
		if(C && config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

/world/proc/RoundEndAnimation(round_end_sound_sent)
	set waitfor = FALSE
	var/round_end_sound
	if(!SSticker && SSticker.round_end_sound)
		round_end_sound = SSticker.round_end_sound
		if (!round_end_sound_sent)
			for(var/thing in GLOB.clients)
				var/client/C = thing
				if (!C)
					continue
				C.Export("##action=load_rsc", round_end_sound)
	else
		round_end_sound = pick(\
		'sound/roundend/newroundsexy.ogg',
		'sound/roundend/apcdestroyed.ogg',
		'sound/roundend/bangindonk.ogg',
		'sound/roundend/leavingtg.ogg',
		'sound/roundend/its_only_game.ogg',
		'sound/roundend/yeehaw.ogg',
		'sound/roundend/disappointed.ogg'\
		)

	for(var/thing in GLOB.clients)
		var/obj/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

	world << sound(round_end_sound)

/world/proc/manage_fps()
	var/count = player_list.len

	var/oldTC = config.Tickcomp
	var/oldFPS = world.fps

	if(count < 50)
		config.Tickcomp = 0
		world.fps = 22
	else if(count < 60)
		config.Tickcomp = 0
		world.fps = 21
	else if(count < 70)
		config.Tickcomp = 0
		world.fps = 20
	else if(count < 80)
		config.Tickcomp = 0
		world.fps = 19
	else if(count < 90)
		config.Tickcomp = 0
		world.fps = 18
	else
		config.Tickcomp = 1
		world.fps = 16

	if(world.fps != oldFPS || config.Tickcomp != oldTC)
		var/msg = "WORLD has modified world.fps to [world.fps] and config.Tickcomp to [config.Tickcomp] (player count reached [count])"
		log_admin(msg, 0)
		message_admins(msg, 0)

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			GLOB.master_mode = Lines[1]
			GLOB.diary << "Saved mode is '[GLOB.master_mode]'"

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	GLOB.join_motd = file2text("config/motd.txt") + "<br>" + GLOB.revdata.GetTestMergeInfo()

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.load("config/discord.txt","discord")
	config.loadsql("config/dbconfig.txt")
	if (config.maprotation)
		config.loadmaplist("config/maps.txt")

	// apply some settings from config..
	GLOB.abandon_allowed = config.respawn

var/list/donators = list()

/world/proc/load_donators()
	var/ckey
	var/datum/preferences/P
	for(var/key in donators)
		ckey = ckey(key)
		P = preferences_datums[ckey]
		if(P)
			P.unlock_content &= 1
	donators = list()
	var/list/donatorskeys = list()
	if(config.donator_legacy_system)
		donatorskeys = file2list("config/donators.txt")
	else
		establish_db_connection()
		if(!dbcon.IsConnected())
			world.log << "Failed to connect to database in load_donators(). Reverting to legacy system."
			diary << "Failed to connect to database in load_donators(). Reverting to legacy system."
			config.donator_legacy_system = 1
			load_donators()
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM [format_table_name("donors")] WHERE (expiration_time > Now()) AND (revoked IS NULL)")
		query.Execute()
		while(query.NextRow())
			ckey = query.item[1]
			if(ckey)
				donatorskeys |= ckey
	for(var/key in donatorskeys)
		ckey = ckey(key)
		donators += ckey
		P = preferences_datums[ckey]
		if(P)
			P.unlock_content |= 2

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"https://www.yogstation.net\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Yogstation.net"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(SSticker)
		if(GLOB.master_mode)
			features += GLOB.master_mode
	else
		features += "<b>STARTING</b>"

	if (!GLOB.enter_allowed)
		features += "closed"

	features += GLOB.abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in GLOB.player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	status = s
