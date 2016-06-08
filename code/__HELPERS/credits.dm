/*
	Nanotrasen Credits helper by Kn0ss0s

	This system requires a new column `credits` in the table `player` of the datatype BIGINT length 20

	/datum/credit : Used only to return a list of players. Contains the player ckey and credits.

	credits_reload_from_db(mob): Returns the number of credits for the given `mob`
	credits_top(num): Gives you the top `num` of players by credits earnt
	credits_earn(mob, num): Gives `num` credits to `mob`
	credits_spend(mob, num): Takes `num` credits from `mob`
	credits_set(mob, num): Sets `mob` credits to `num`
*/

/client
	// Give all clients a corresponding credit line
	// This variable can be used as an "estimate" of a clients credit, but before making transactions, check with the database first!
	var/credits = 0

/datum/credit
	var/ckey
	var/credits

/datum/credit/New(var/ckey, var/credits)
	src.ckey = ckey
	src.credits = text2num(credits)

	if(!src.ckey)
		throw new /exception("InvalidParameterException: When creating a credits datum, a ckey is expected")
	if(src.credits < 0)
		throw new /exception("InvalidParameterException: When creating a credits datum, a negative credits value is not expected")

/*
	Returns the number of credits that the user has stored in the DB.
	Takes a mob as an argument
	If the returned number is less than 0, then it was an error.

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with credits for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
*/
/proc/credits_reload_from_db(mob/M)
	var/client/C = get_client(M)
	if(!C || !istype(C, /client))
		return BAD_CLIENT

	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	var ckey = get_ckey(C)
	if(!ckey)
		return BAD_CLIENT

	var/DBQuery/query_credits = dbcon.NewQuery("SELECT `credits` FROM [format_table_name("player")] WHERE `ckey`='[ckey]' LIMIT 1")

	if(!query_credits.Execute())
		return FAILED_QUERY

	if(query_credits.NextRow())
		C.credits = text2num(query_credits.item[1])
		return C.credits

	return NO_RESULT

/*
	Returns a list of the players with the most credits (limited to a certain number)
	The return value is in the form of a list of /datum/credit

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with credits for the current round - disable functions
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
*/
/proc/credits_top(var/limit)
	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	if(!limit)
		limit = 10

	var/DBQuery/query_credits = dbcon.NewQuery("SELECT `ckey`, `credits` FROM [format_table_name("player")] ORDER BY `credits` DESC LIMIT [limit]")

	if(!query_credits.Execute())
		return FAILED_QUERY

	var/list/L = list()

	while(query_credits.NextRow())
		L.Add(new /datum/credit(query_credits.item[1], text2num(query_credits.item[2])))

	return L

/*
	Increase the clients credits in the database
	The return value is the new number of credits after earning

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with credits for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
*/
/proc/credits_earn(mob/M, var/credits)
	var/currentCredits = credits_reload_from_db(M)

	// If the current value is a negative, then there was a proper error we need to forward
	if(currentCredits < 0)
		return currentCredits

	var/client/C = get_client(M)
	C.credits = currentCredits + text2num(credits)

	// Not necessary to prove this is safe, as it was already checked in credits_reload_from_db
	var ckey = get_ckey(M)

	var/DBQuery/query_credits = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `credits`=[C.credits] WHERE `ckey`='[ckey]'")

	if(!query_credits.Execute())
		return FAILED_QUERY

	return C.credits

/*
	Reduce the clients credits in the database
	The return value is the new number of credits after spending

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with credits for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
		INSUFFICIENT_CREDITS: Insufficient credits to complete this operation
*/
/proc/credits_spend(mob/M, var/credits)
	var/currentCredits = credits_reload_from_db(M)

	// If the current value is a negative, then there was a proper error we need to forward
	if(currentCredits < 0)
		return currentCredits

	// Reduce the number of credits the user has, if it is negative, we don't have enough credits
	currentCredits = currentCredits - text2num(credits)
	if(currentCredits < 0)
		return INSUFFICIENT_CREDITS

	var/client/C = get_client(M)
	C.credits = currentCredits

	// Not necessary to prove this is safe, as it was already checked in credits_reload_from_db
	var ckey = get_ckey(M)

	var/DBQuery/query_credits = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `credits`=[C.credits] WHERE `ckey`='[ckey]'")

	if(!query_credits.Execute())
		return FAILED_QUERY

	return C.credits

/*
	Set the clients credits in the database

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with credits for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
		QUERY_OK:
*/
/proc/credits_set(mob/M, var/credits)
	var/client/C = get_client(M)
	if(!C || !istype(C, /client))
		return BAD_CLIENT

	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	var ckey = get_ckey(C)
	if(!ckey)
		return BAD_CLIENT

	var/DBQuery/query_credits = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `credits`=[credits] WHERE `ckey`='[ckey]'")

	if(!query_credits.Execute())
		return FAILED_QUERY

	C.credits = credits

	return QUERY_OK

