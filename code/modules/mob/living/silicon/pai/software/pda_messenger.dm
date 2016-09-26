/datum/pai/software/pda_messenger
	name = "PDA Messenging Uplink"
	description = "Provides access to the station PDA telecommunications network for standard delivery and receival of NT-standard PDA messages."
	category = "Basic"
	sid = "pdamessenger"
	ram = 5

/datum/pai/software/pda_messenger/action_menu(mob/living/silicon/pai/user)
	var/dat = "<h3>Digital Messenger</h3>"
	dat += {"<b>Signal/Receiver Status:</b> <A href='byond://?src=\ref[user];software=[sid];toggler=1'>[(user.pda.toff) ? "<font color='red'>\[Off\]</font>" : "<font color='green'>\[On\]</font>"]</a><br>
	<b>Ringer Status:</b> <A href='byond://?src=\ref[user];software=[sid];ringer=1'>[(user.pda.silent) ? "<font color='red'>\[Off\]</font>" : "<font color='green'>\[On\]</font>"]</a><br><br>"}
	dat += "<ul>"
	if(!user.pda.toff)
		for (var/obj/item/device/pda/P in sortNames(get_viewable_pdas()))
			if (P == user.pda)
				continue
			dat += "<li><a href='byond://?src=\ref[user];software=[sid];target=\ref[P]'>[P]</a>"
			dat += "</li>"
	dat += "</ul>"
	dat += "<br><br>"
	dat += "Messages: <hr> [user.pda.tnote]"
	return dat

/datum/pai/software/pda_messenger/action_use(mob/living/silicon/pai/user, var/args)
	if(!isnull(user.pda))
		if(args["toggler"])
			user.pda.toff = !user.pda.toff
		else if(args["ringer"])
			user.pda.silent = !user.pda.silent
		else if(args["target"])
			if(user.silence_time)
				return alert("Communications circuits remain unitialized.")
			var/target = locate(args["target"])
			user.pda.create_message(user, target)