
/client
		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/datum/click_intercept = null // Needs to implement InterceptClickOn(user,params,atom) proc
	var/AI_Interact		= 0

	var/jobbancache = null //Used to cache this client's jobbans to save on DB queries
	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.

	var/last_message_time = 0 //contains the world.time that the last message was sent without triggering the fast message spam filter
	var/fast_message_count = 0 //how many messages have been sent since the last time the fast message spam filter was reset

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/move_delay		= 1
	var/moving			= null

	var/area			= null

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0
		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 1

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/is_whitelisted = "Requires database"	//Used to determine if the player is whitelisted - gives access to Ultra preference for command jobs + AI

	var/connection_number = 0

	preload_rsc = PRELOAD_RSC

	var/global/obj/screen/click_catcher/void

	// Used by html_interface module.
	var/hi_last_pos


	//datum that controls the displaying and hiding of tooltips
	var/datum/tooltip/tooltips

	//Used for var edit flagging, also defined in datums (clients are not a child of datums for some reason)
	var/var_edited = 0

	var/last_cached_weight //For weight checking, prevents query spam
	var/last_cached_total_weight //For weight checking, prevents query spam

	var/list/rejectedRoles = list() //Mid-round ghost roles they hit NEVER on