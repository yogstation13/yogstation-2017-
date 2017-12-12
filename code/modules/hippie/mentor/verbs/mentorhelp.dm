/client/verb/mentorhelp(msg as text)
	set category = "Mentor"
	set name = "Mentorhelp"

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)
		return
	if(!mob) //this doesn't happen
		return
	if(src.prefs.muted & MUTE_MENTORHELP)
		to_chat(src, "<font color='red'>You are unable to use mentorhelp (muted).</font>")
		return
	var/show_char = config.mentors_mobname_only
	var/mentor_msg = ""
	log_mentor("MENTORHELP: [key_name_mentor(src, 0, 0, 0, 0)]: [msg]")

	for(var/client/X in mentors)
		if(X.mob && (istype(X.mob, /mob/new_player) || isobserver(X.mob)))
			X << 'sound/items/bikehorn.ogg'
			mentor_msg = "<span class='mentornotice'><b><font color='#3280ff'>MENTORHELP:</b> <b>"
			mentor_msg += FOLLOW_LINK(X, src)
			mentor_msg += " [key_name_mentor(src, 1, 0, show_char)]</b>:</font> [msg]</span>"
			to_chat(X, mentor_msg)

	for(var/client/A in admins)
		A << 'sound/items/bikehorn.ogg'
		mentor_msg = "<span class='mentornotice'><b><font color='#3280ff'>MENTORHELP:</b> <b>"
		mentor_msg += FOLLOW_LINK(A, src)
		mentor_msg += " [key_name_mentor(src, 1, 0, show_char)]</b>:</font> [msg]</span>"
		to_chat(A, mentor_msg)

	to_chat(src, "<span class='mentornotice'><font color='purple'>PM to-<b>Mentors</b>: [msg]</font></span>")
	return

/proc/get_mentor_counts()
	. = list("total" = 0, "afk" = 0, "present" = 0)
	for(var/client/X in mentors)
		.["total"]++
		if(X.is_afk())
			.["afk"]++
		else
			.["present"]++

/proc/key_name_mentor(var/whom, var/include_link = null, var/include_name = 0, var/char_name_only = 0)
	var/mob/M
	var/client/C
	var/key
	var/ckey

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
		ckey = C.ckey
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
		ckey = M.ckey
	else if(istext(whom))
		key = whom
		ckey = ckey(whom)
		C = directory[ckey]
		if(C)
			M = C.mob
	else
		return "*invalid*"

	. = ""

	if(!ckey)
		include_link = 0

	if(key)
		if(include_link)
			if(config.mentors_mobname_only)
				. += "<a href='?mentor_msg=\ref[M]'>"
			else
				. += "<a href='?mentor_msg=[ckey]'>"

		if(C && C.holder && C.holder.fakekey)
			. += "Administrator"
		else if (char_name_only && config.mentors_mobname_only)
			if(istype(C.mob,/mob/new_player) || istype(C.mob, /mob/dead/observer)) //If they're in the lobby or observing, display their ckey
				. += key
			else if(C && C.mob) //If they're playing/in the round, only show the mob name
				. += C.mob.name
			else //If for some reason neither of those are applicable and they're mentorhelping, show ckey
				. += key
		else
			. += key
		if(!C)
			. += "\[DC\]"

		if(include_link)
			. += "</a>"
	else
		. += "*no key*"

	return .