#define IRCREPLYCOUNT 2


//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M in mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!check_rights(R_BASIC))
		src << "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>"
		return
	if( !ismob(M) || !M.client )
		return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","APMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!check_rights(R_BASIC))
		src << "<font color='red'>Error: Admin-PM-Panel: Only administrators may use this command.</font>"
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets["(New Player) - [T]"] = T
			else if(isobserver(T.mob))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/target = input(src,"To whom shall we send a message?","Admin PM",null) as null|anything in sortList(targets)
	cmd_admin_pm(targets[target],null)
	feedback_add_details("admin_verb","APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_ahelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
		return
	if(!check_rights(R_BASIC))
		src << "<font color='red'>Error: Admin-PM: Only administrators may use this command.</font>"
		return
	var/client/C
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		C = directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)
			src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
		return
	message_admins("[key_name_admin(src)] has started replying to [key_name(C, 0, 0)]'s admin help.")
	var/msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null
	if (!msg)
		message_admins("[key_name_admin(src)] has cancelled their reply to [key_name(C, 0, 0)]'s admin help.")
		return
	cmd_admin_pm(whom, msg)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_admin_pm(whom, msg)
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
		return
	var/client/C
	var/irc = 0
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			irc = 1
		else
			C = directory[whom]
	else if(istype(whom,/client))
		C = whom
<<<<<<< HEAD
	if(!C)
		if(holder)
			src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
		else
			admin_ticket(msg)	//admin we are replying to left. adminhelp instead
		return

	// Search current tickets, is this user the owner or primary admin of a ticket
	// We are searching initially, to avoid wasting the users time. We will add more
	// information to the input dialog. Check to see if an admin has already started
	// to reply to this ticket
	var/clickedId = 0
	var/datum/admin_ticket/wasAlreadyClicked = null
	for(var/datum/admin_ticket/T in tickets_list)
		if(!T.resolved && T.pm_started_user && compare_ckey(T.owner, C.mob) && !compare_ckey(T.handling_admin, src))
			if(T.pm_started_flag)
				clickedId = T.ticket_id

			wasAlreadyClicked = T

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		var/instructions = {"[clickedId ? "* Someone already started to reply to this ticket. If you reply, you may start a new ticket! " : ""]Message:"}

		if(wasAlreadyClicked)
			wasAlreadyClicked.pm_started_flag = 1

		msg = input(src, instructions, "Reply to ticket") as text|null
=======
	if(irc)
		if(!ircreplyamount)	//to prevent people from spamming irc
			return
		if(!msg)
			msg = input(src,"Message:", "Private message to Administrator") as text|null
>>>>>>> masterTGbranch

		if(!msg)
			// If the user was the user that started PM replying initially, then
			// if the user cancels the reply, we should reset it. So others can reply.
			if(wasAlreadyClicked)
				wasAlreadyClicked.pm_started_user = null
				wasAlreadyClicked.pm_started_flag = 0
			return
		if(holder)
			src << "<font color='red'>Error: Use the admin IRC channel, nerd.</font>"
			return


	else
		if(!C)
			if(holder)
				src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
			else
<<<<<<< HEAD
				admin_ticket(msg)	//admin we are replying to has vanished, adminhelp instead
=======
				adminhelp(msg)	//admin we are replying to left. adminhelp instead
>>>>>>> masterTGbranch
			return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null

			if(!msg)
				return
			if(!C)
				if(holder)
					src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
				else
					adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
				return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

<<<<<<< HEAD
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return

	msg = emoji_parse(msg)


	var/has_resolved_ticket = 0

	// Search current tickets, is this user the owner or primary admin of a ticket
	for(var/datum/admin_ticket/T in tickets_list)
		if((!T.handling_admin && compare_ckey(T.owner, C)) || ((compare_ckey(T.owner, get_client(src)) || compare_ckey(T.handling_admin, get_client(src))) && (compare_ckey(T.owner, C) || compare_ckey(T.handling_admin, C))))
			// Hijack this PM!
			if(T.resolved && !holder)
				has_resolved_ticket = 1

			if(T.handling_admin && !compare_ckey(get_client(src), T.handling_admin) && !compare_ckey(get_client(src), T.owner))
				if(!holder)
					usr << "<span class='boldnotice'>You are not the owner or primary admin of this users ticket. You may not reply to it.</span>"
				return

			if(!T.resolved)
				msg = replacetext(msg, "'", "�")
				msg = replacetext(msg, "&#39;", "�")
				T.add_log(msg, get_client(src))

				if(holder && !C.holder && T.force_popup)
					spawn()	//so we don't hold the caller proc up
						var/sender = src
						var/sendername = key
						var/reply = input(C, msg,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
						reply = replacetext(reply, "'", "�")
						reply = replacetext(reply, "&#39;", "�")
						if(C && reply)
							if(sender)
								C.cmd_admin_pm(src,reply)										//sender is still about, let's reply to them
							else
								admin_ticket(reply)													//sender has left, adminhelp instead
						return

				return

	if(has_resolved_ticket)
		src << "<span class='boldnotice'>Your ticket was closed. Only admins can add finishing comments to it.</span>"
		return

	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
		return

	// If we didn't find a ticket, we should make one. This bypasses the rest of the original PM system
	var/datum/admin_ticket/T = new /datum/admin_ticket(src, msg, C)
	if(!T.error)
		tickets_list.Add(T)
	else
		T = null

	return //This ticket system. Wow.
=======
	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0)||irc)//no sending html to the poor bots
		msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
		if(!msg)
			return

	var/rawmsg = msg

	if(holder)
		msg = emoji_parse(msg)

	var/keywordparsedmsg = keywords_lookup(msg)

	if(irc)
		src << "<font color='blue'>PM to-<b>Admins</b>: [rawmsg]</font>"
		ircreplyamount--
		send2irc("Reply: [ckey]",rawmsg)
	else
		if(C.holder)
			if(holder)	//both are admins
				C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg]</font>"
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [keywordparsedmsg]</font>"

			else		//recipient is an admin but sender is not
				C << "<font color='red'>Reply PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg]</font>"
				src << "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>"

			//play the recieving admin the adminhelp sound (if they have them enabled)
			if(C.prefs.toggles & SOUND_ADMINHELP)
				C << 'sound/effects/adminhelp.ogg'

		else
			if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
				C << "<font color='red' size='4'><b>-- Administrator private message --</b></font>"
				C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 0)]</b>: [msg]</font>"
				C << "<font color='red'><i>Click on the administrator's name to reply.</i></font>"
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"

				//always play non-admin recipients the adminhelp sound
				C << 'sound/effects/adminhelp.ogg'

				//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
				if(config.popup_admin_pm)
					spawn()	//so we don't hold the caller proc up
						var/sender = src
						var/sendername = key
						var/reply = input(C, msg,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
						if(C && reply)
							if(sender)
								C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
							else
								adminhelp(reply)													//sender has left, adminhelp instead
						return

			else		//neither are admins
				src << "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>"
				return

	if(irc)
		log_admin("PM: [key_name(src)]->IRC: [rawmsg]")
		for(var/client/X in admins)
			X << "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;IRC:</B> \blue [keywordparsedmsg]</font>" //inform X
	else
		window_flash(C)
		log_admin("PM: [key_name(src)]->[key_name(C)]: [rawmsg]")
		//we don't use message_admins here because the sender/receiver might get it too
		for(var/client/X in admins)
			if(X.key!=key && X.key!=C.key)	//check client/X is an admin and isn't the sender or recipient
				X << "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> \blue [keywordparsedmsg]</font>" //inform X




/proc/IrcPm(target,msg,sender)

	var/client/C = directory[target]

	var/static/stealthkey
	var/adminname = config.showircname ? "[sender](IRC)" : "Administrator"

	if(!C)
		return "No client"

	if(!stealthkey)
		stealthkey = GenIrcStealthKey()

	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)
		return "No message"

	message_admins("IRC message from [sender] to [key_name_admin(C)] : [msg]")
	log_admin("IRC PM: [sender] -> [key_name(C)] : [msg]")
	msg = emoji_parse(msg)

	C << "<font color='red' size='4'><b>-- Administrator private message --</b></font>"
	C << "<font color='red'>Admin PM from-<b><a href='?priv_msg=[stealthkey]'>[adminname]</A></b>: [msg]</font>"
	C << "<font color='red'><i>Click on the administrator's name to reply.</i></font>"
	window_flash(C)
	//always play non-admin recipients the adminhelp sound
	C << 'sound/effects/adminhelp.ogg'

	C.ircreplyamount = IRCREPLYCOUNT

	return "Message Successful"



/proc/GenIrcStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in stealthminID)
			if(num == stealthminID[P])
				num++
				i = 0
	var/stealth = "@[num2text(num)]"
	stealthminID["IRCKEY"] = stealth
	return	stealth

#undef IRCREPLYCOUNT
>>>>>>> masterTGbranch
