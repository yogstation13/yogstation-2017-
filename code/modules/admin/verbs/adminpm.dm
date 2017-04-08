#define IRCREPLYCOUNT 2


//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M in GLOB.mob_list)
	set category = null
	set name = "Admin PM Mob"
<<<<<<< HEAD
	if(!check_rights(R_BASIC))
		src << "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>"
=======
	if(!holder)
		to_chat(src, "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
		return
	if( !ismob(M) || !M.client )
		return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","APMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
<<<<<<< HEAD
	if(!check_rights(R_BASIC))
		src << "<font color='red'>Error: Admin-PM-Panel: Only administrators may use this command.</font>"
=======
	if(!holder)
		to_chat(src, "<font color='red'>Error: Admin-PM-Panel: Only administrators may use this command.</font>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
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
		to_chat(src, "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>")
		return
	if(!check_rights(R_BASIC))
		src << "<font color='red'>Error: Admin-PM: Only administrators may use this command.</font>"
		return
	var/client/C
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		C = GLOB.directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)
			to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
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
		to_chat(src, "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>")
		return
	var/client/C
	var/irc = 0
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			irc = 1
		else
			C = GLOB.directory[whom]
	else if(istype(whom,/client))
		C = whom
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
	if(irc)
		if(!ircreplyamount)	//to prevent people from spamming irc
			return
		if(!msg)
			msg = input(src,"Message:", "Private message to Administrator") as text|null

		if(!msg)
			// If the user was the user that started PM replying initially, then
			// if the user cancels the reply, we should reset it. So others can reply.
			if(wasAlreadyClicked)
				wasAlreadyClicked.pm_started_user = null
				wasAlreadyClicked.pm_started_flag = 0
			return
		if(holder)
			to_chat(src, "<font color='red'>Error: Use the admin IRC channel, nerd.</font>")
			return


	else
		if(!C)
			if(holder)
				to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
			else
				admin_ticket(msg)	//admin we are replying to has vanished, adminhelp instead
			return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null

			if(!msg)
				return

			if(prefs.muted & MUTE_ADMINHELP)
				to_chat(src, "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>")
				return

			if(!C)
				if(holder)
					to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
				else
					adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
				return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return

	msg = emoji_parse(msg)

<<<<<<< HEAD

	var/has_resolved_ticket = 0
=======
	if(irc)
		to_chat(src, "<font color='blue'>PM to-<b>Admins</b>: [rawmsg]</font>")
		ircreplyamount--
		send2irc("Reply: [ckey]",rawmsg)
	else
		if(C.holder)
			if(holder)	//both are admins
				to_chat(C, "<font color='red'>Admin PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg]</font>")
				to_chat(src, "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [keywordparsedmsg]</font>")

			else		//recipient is an admin but sender is not
				to_chat(C, "<font color='red'>Reply PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg]</font>")
				to_chat(src, "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

	// Search current tickets, is this user the owner or primary admin of a ticket
	for(var/datum/admin_ticket/T in tickets_list)
		if((!T.handling_admin && compare_ckey(T.owner, C)) || ((compare_ckey(T.owner, get_client(src)) || compare_ckey(T.handling_admin, get_client(src))) && (compare_ckey(T.owner, C) || compare_ckey(T.handling_admin, C))))
			// Hijack this PM!
			if(T.resolved && !holder)
				has_resolved_ticket = 1

<<<<<<< HEAD
			if(T.handling_admin && !compare_ckey(get_client(src), T.handling_admin) && !compare_ckey(get_client(src), T.owner))
				if(!holder)
					usr << "<span class='boldnotice'>You are not the owner or primary admin of this users ticket. You may not reply to it.</span>"
				return
=======
		else
			if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
				to_chat(C, "<font color='red' size='4'><b>-- Administrator private message --</b></font>")
				to_chat(C, "<font color='red'>Admin PM from-<b>[key_name(src, C, 0)]</b>: [msg]</font>")
				to_chat(C, "<font color='red'><i>Click on the administrator's name to reply.</i></font>")
				to_chat(src, "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

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

<<<<<<< HEAD
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
=======
			else		//neither are admins
				to_chat(src, "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>")
				return

	if(irc)
		log_admin_private("PM: [key_name(src)]->IRC: [rawmsg]")
		for(var/client/X in GLOB.admins)
			to_chat(X, "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;IRC:</B> \blue [keywordparsedmsg]</font>" )
	else
		window_flash(C, ignorepref = TRUE)
		log_admin_private("PM: [key_name(src)]->[key_name(C)]: [rawmsg]")
		//we don't use message_admins here because the sender/receiver might get it too
		for(var/client/X in GLOB.admins)
			if(X.key!=key && X.key!=C.key)	//check client/X is an admin and isn't the sender or recipient
				to_chat(X, "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> \blue [keywordparsedmsg]</font>" )
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

	return //This ticket system. Wow.



/proc/IrcPm(target,msg,sender)

	var/client/C = GLOB.directory[target]

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
	log_admin_private("IRC PM: [sender] -> [key_name(C)] : [msg]")
	msg = emoji_parse(msg)

	to_chat(C, "<font color='red' size='4'><b>-- Administrator private message --</b></font>")
	to_chat(C, "<font color='red'>Admin PM from-<b><a href='?priv_msg=[stealthkey]'>[adminname]</A></b>: [msg]</font>")
	to_chat(C, "<font color='red'><i>Click on the administrator's name to reply.</i></font>")
	window_flash(C, ignorepref = TRUE)
	//always play non-admin recipients the adminhelp sound
	C << 'sound/effects/adminhelp.ogg'

	C.ircreplyamount = IRCREPLYCOUNT

	return "Message Successful"



/proc/GenIrcStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	var/stealth = "@[num2text(num)]"
	GLOB.stealthminID["IRCKEY"] = stealth
	return	stealth

#undef IRCREPLYCOUNT
