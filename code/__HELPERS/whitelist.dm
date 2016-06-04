/*
	Job Whitelist helper by Kn0ss0s

	This system requires a new column `job_whitelisted` in the table `player` of the datatype TINYINT length 1
	For security and future expansion it also uses a view with the implementation of:
		SELECT `ckey` FROM `erro_player` WHERE `job_whitelisted` = 1

	credits_reload_from_db(mob): Returns the number of credits for the given `mob`
	credits_top(num): Gives you the top `num` of players by credits earnt
	credits_earn(mob, num): Gives `num` credits to `mob`
	credits_spend(mob, num): Takes `num` credits from `mob`
	credits_set(mob, num): Sets `mob` credits to `num`
*/

/proc/is_job_whitelisted(var/V)
	if(istype(V, /mob))
		return is_job_whitelisted_mob(V)
	else if(istype(V, /client))
		return is_job_whitelisted_mob(V)
	else if(istype(V, /list))
		return is_job_whitelisted_list(V)
	return 0

/*
	Returns a list of the players with the most credits (limited to a certain number)
	The return value is in the form of a list of /datum/credit

	Possible values
		1: The user is whitelisted
		0: The user is NOT whitelisted (or an error happened - just disable whitelisting
*/
/proc/is_job_whitelisted_mob(mob/M)
	var/client/C = get_client(M)
	if(!C || !istype(C, /client))
		return 0

	if(!dbcon.IsConnected())
		return 0

	var ckey = get_ckey(C)
	if(!ckey)
		return 0

	var/DBQuery/query_whitelist = dbcon.NewQuery("SELECT `ckey` FROM `job_whitelist` WHERE `ckey`='[ckey]' LIMIT 1")

	if(!query_whitelist.Execute())
		return 0

	if(query_whitelist.NextRow())
		return 1
	else
		return 0

/*
	Returns a list of ckeys that are accepted for whitelist (others are removed)

	Possible values
		NO_DB_CONNECTION: No MySQL connection - disable functions
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		list('ckey', ...)
*/
/proc/is_job_whitelisted_list(list/L)
	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	var/list/ckeys_to_join = list()
	var/ckeys_joined = ""

	for (var/I in L)
		// Test we actually have mobs in the list
		if(istype(I, /mob))
			var/mob/M = I

			var/client/C = get_client(M)
			if(!C || !istype(C, /client))
				continue

			var ckey = get_ckey(C)
			if(!ckey)
				continue

			ckeys_to_join += ckey

	ckeys_joined = list2string(ckeys_to_join, "', '")

	var/DBQuery/query_whitelist = dbcon.NewQuery("SELECT `ckey` FROM `job_whitelist` WHERE `ckey` IN ('[ckeys_joined]')")

	if(!query_whitelist.Execute())
		return 0

	var/list/output = list()

	while(query_whitelist.NextRow())
		var/ckey = query_whitelist.item[1]
		output += ckey

	return output

/*
	Set the clients credits in the database

	Possible values
		NO_DB_CONNECTION: No MySQL connection - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
		QUERY_OK:
*/
/proc/set_job_whitelisted(mob/M, var/whitelisted)
	if(whitelisted != 0 && whitelisted != 1)
		// You trying to break shit?
		return 0

	var/client/C = get_client(M)
	if(!C || !istype(C, /client))
		return BAD_CLIENT

	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	var ckey = get_ckey(C)
	if(!ckey)
		return BAD_CLIENT

	var/DBQuery/query_whitelist = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `job_whitelisted`=[whitelisted] WHERE `ckey`='[ckey]'")

	if(!query_whitelist.Execute())
		return FAILED_QUERY

	return QUERY_OK

