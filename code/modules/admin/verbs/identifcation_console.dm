/client/proc/reset_idconsole_msg()
	set category = "Special Verbs"
	set name = "reset arrival message"
	if(!check_rights(0))
		return

	message_admins("[usr.ckey] has reset the identification console message. Previous message: [ticker.identification_console_message]")
	log_admin("[usr.ckey] has reset the identification console message. Previous message: [ticker.identification_console_message]")
	ticker.identification_console_message = null

/client/proc/lock_idconsole()
	set category = "Special Verbs"
	set name = "lock/unlock arrival message system"
	if(!check_rights(0))
		return

	message_admins("[usr.ckey] is [ticker.id_console_msg_lock ? "unlocking" : "locking"] the identification console's message system.")
	log_admin("[usr.ckey] is [ticker.id_console_msg_lock ? "unlocking" : "locking"] the identification console's message system.")
	ticker.id_console_msg_lock = !ticker.id_console_msg_lock