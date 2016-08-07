/*
	Antag Tokens helper by Kn0ss0s

	This system requires a new column `antag_tokens` in the table `player` of the datatype INT length 2

	There can be a maximum of 99 antag tokens per user.

	antag_token_reload_from_db(mob): Returns the number of antag tokens for the given `mob`
	antag_token_add(mob): Add an antag token to `mob`
	antag_token_use(mob): Remove an antag token from `mob`
	antag_token_set(mob, num): Sets `mob` antag token to `num`
*/

/client
	// Give all clients default antag tokens of 0
	var/antag_tokens = 0

/*
	Returns the number of antag tokens that the user has stored in the DB.
	If the returned number is less than 0, then it was an error.

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with tokens for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
*/
/proc/antag_token_reload_from_db(mob/M)
	if(!config.use_antag_tokens)
		return 0
	var/client/C = get_client(M)
	if(!C || !istype(C, /client))
		return BAD_CLIENT

	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	var ckey = get_ckey(C)
	if(!ckey)
		return BAD_CLIENT

	var/DBQuery/query_tokens = dbcon.NewQuery("SELECT `antag_tokens` FROM [format_table_name("player")] WHERE `ckey`='[ckey]' LIMIT 1")

	if(!query_tokens.Execute())
		return FAILED_QUERY

	if(query_tokens.NextRow())
		C.antag_tokens = text2num(query_tokens.item[1])
		return C.antag_tokens

	return NO_RESULT

/*
	Increase the clients antag tokens in the database
	The return value is the new number of antag tokens (or less than 0 for an error)

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with antag tokens for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
*/
/proc/antag_token_add(mob/M)
	if(!config.use_antag_tokens)
		return 0
	var/currentTokens = antag_token_reload_from_db(M)

	// If the current value is a negative, then there was a proper error we need to forward
	if(currentTokens < 0)
		return currentTokens

	var/client/C = get_client(M)
	C.antag_tokens = currentTokens + 1

	// Not necessary to prove this is safe, as it was already checked in antag_token_reload_from_db
	var ckey = get_ckey(C)

	var/DBQuery/query_tokens = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `antag_tokens`=[C.antag_tokens] WHERE `ckey`='[ckey]'")

	if(!query_tokens.Execute())
		return FAILED_QUERY

	return C.antag_tokens

/*
	Reduce the clients antag tokens in the database
	The return value is the new number of antag tokens (or less than 0 for an error)

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with antag tokens for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
*/
/proc/antag_token_use(mob/M)
	if(!config.use_antag_tokens)
		return 0
	var/currentTokens = antag_token_reload_from_db(M)

	// If the current value is a negative, then there was a proper error we need to forward
	if(currentTokens < 0)
		return currentTokens

	// Reduce the number of tokens the user has, if it is negative, we don't have enough tokens
	currentTokens = currentTokens - 1
	if(currentTokens < 0)
		return 0

	var/client/C = get_client(M)
	C.antag_tokens = currentTokens

	// Not necessary to prove this is safe, as it was already checked in antag_token_reload_from_db
	var ckey = get_ckey(C)

	var/DBQuery/query_tokens = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `antag_tokens`=[C.antag_tokens] WHERE `ckey`='[ckey]'")

	if(!query_tokens.Execute())
		return FAILED_QUERY

	return C.antag_tokens

/*
	Set the clients antag tokens in the database

	Possible values
		NO_DB_CONNECTION: No MySQL connection - do not work with antag tokens for the current round - disable functions
		BAD_CLIENT: A badly passed mob that is either non-existant or has no client
		FAILED_QUERY: A bad query, usually should not happen - results from columns or the table missing from the DB
		NO_RESULT: No result, likely due to the current mob client key not having a row in the player database
		QUERY_OK:
*/
/proc/antag_token_set(mob/M, var/tokens)
	if(!config.use_antag_tokens)
		return NO_DB_CONNECTION
	var/client/C = get_client(M)
	if(!C || !istype(C, /client))
		return BAD_CLIENT

	if(!dbcon.IsConnected())
		return NO_DB_CONNECTION

	var ckey = get_ckey(C)
	if(!ckey)
		return BAD_CLIENT

	C.antag_tokens = tokens

	var/DBQuery/query_tokens = dbcon.NewQuery("UPDATE [format_table_name("player")] SET `antag_tokens`=[C.antag_tokens] WHERE `ckey`='[ckey]'")

	if(!query_tokens.Execute())
		return FAILED_QUERY

	return QUERY_OK

