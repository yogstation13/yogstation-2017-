
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


	// jexp. presents the last cached values. database is used to count your jexp, not this.
	var/cachedjexp_captain = 0
	var/cachedjexp_hos = 0
	var/cachedjexp_hop = 0
	var/cachedjexp_ce = 0
	var/cachedjexp_cmo = 0
	var/cachedjexp_rd = 0
	var/cachedjexp_cargot = 0
	var/cachedjexp_qm = 0
	var/cachedjexp_securityo = 0
	var/cachedjexp_lawyer = 0
	var/cachedjexp_warden = 0
	var/cachedjexp_statione = 0
	var/cachedjexp_atmost = 0
	var/cachedjexp_medicald = 0
	var/cachedjexp_chem = 0
	var/cachedjexp_viro = 0
	var/cachedjexp_gene = 0
	var/cachedjexp_para = 0
	var/cachedjexp_science = 0
	var/cachedjexp_robotics = 0
	var/cachedjexp_deputy = 0

	var/jexpworthy = TRUE

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