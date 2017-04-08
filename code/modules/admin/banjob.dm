//returns a reason if M is banned from rank, returns 0 otherwise

var/jobban_runonce			// Updates legacy bans with new info
var/jobban_keylist[0]		//to store the keys & ranks

/proc/jobban_fullban(mob/M, rank, reason)
	if (!M || !M.key) return
	jobban_keylist.Add(text("[M.ckey] - [rank] ## [reason]"))
	jobban_savebanfile()

/proc/jobban_client_fullban(ckey, rank)
	if (!ckey || !rank) return
	jobban_keylist.Add(text("[ckey] - [rank]"))
	jobban_savebanfile()

/proc/jobban_check_mob(mob/M, rank)
	if (!M || !rank) return 0

	/*var/list/tempList = jobban_list_for_mob(M)
	return jobban_job_in_list(tempList, rank)*/

	var/DBQuery/query = dbcon.NewQuery("SELECT job FROM [format_table_name("ban")] WHERE ckey = '[get_ckey(M)]' AND job = '[rank]' AND (bantype = 'JOB_PERMABAN' OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND unbanned != 1")
	query.Execute()

	if(query.NextRow())
		return 1

	return 0

/proc/jobban_job_in_list(jobList, rank)
	if (!jobList || !rank) return 0

	for (var/s in jobList)
		if(s == rank)
			return 1

	return 0

/proc/jobban_list_for_mob(mob/M)
	if (!M) return 0

	var/DBQuery/query = dbcon.NewQuery("SELECT job FROM [format_table_name("ban")] WHERE ckey = '[get_ckey(M)]' AND (bantype = 'JOB_PERMABAN' OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND unbanned != 1")
	query.Execute()

	var/list/ckey_job_bans = list()

	while(query.NextRow())
		var/job = query.item[1]
		ckey_job_bans.Add(job)

	return ckey_job_bans

/proc/jobban_isbanned(mob/M, rank)
	if(!M || !istype(M) || !M.ckey)
		return 0

	if(!M.client) //no cache. fallback to a DBQuery
<<<<<<< HEAD
		var/DBQuery/query = dbcon.NewQuery("SELECT reason FROM [format_table_name("ban")] WHERE ckey = '[sanitizeSQL(M.ckey)]' AND job = '[sanitizeSQL(rank)]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND unbanned = 1")
		if(!query.Execute())
			log_game("SQL ERROR obtaining jobbans. Error : \[[query.ErrorMsg()]\]\n")
=======
		var/DBQuery/query_jobban_check_ban = GLOB.dbcon.NewQuery("SELECT reason FROM [format_table_name("ban")] WHERE ckey = '[sanitizeSQL(M.ckey)]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned) AND job = '[sanitizeSQL(rank)]'")
		if(!query_jobban_check_ban.warn_execute())
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
			return
		if(query_jobban_check_ban.NextRow())
			var/reason = query_jobban_check_ban.item[1]
			return reason ? reason : 1 //we don't want to return "" if there is no ban reason, as that would evaluate to false
		else
			return 0

	if(!M.client.jobbancache)
		jobban_buildcache(M.client)

	if(rank in M.client.jobbancache)
		var/reason = M.client.jobbancache[rank]
		return (reason) ? reason : 1 //see above for why we need to do this
	return 0

/proc/jobban_buildcache(client/C)
	if(C && istype(C))
		C.jobbancache = list()
<<<<<<< HEAD
		var/DBQuery/query = dbcon.NewQuery("SELECT job, reason FROM [format_table_name("ban")] WHERE ckey = '[sanitizeSQL(C.ckey)]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND unbanned = 0")
		if(!query.Execute())
			log_game("SQL ERROR obtaining jobbans. Error : \[[query.ErrorMsg()]\]\n")
			return
		while(query.NextRow())
			C.jobbancache[query.item[1]] = query.item[2]
/proc/jobban_loadbanfile()
	if(config.ban_legacy_system)
		var/savefile/S=new("data/job_full.ban")
		S["keys[0]"] >> jobban_keylist
		log_admin("Loading jobban_rank")
		S["runonce"] >> jobban_runonce

		if (!length(jobban_keylist))
			jobban_keylist=list()
			log_admin("jobban_keylist was empty")
	else
		if(!establish_db_connection())
			world.log << "Database connection failed. Reverting to the legacy ban system."
			diary << "Database connection failed. Reverting to the legacy ban system."
			config.ban_legacy_system = 1
			jobban_loadbanfile()
			return

		//Job permabans
		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, job FROM [format_table_name("ban")] WHERE bantype = 'JOB_PERMABAN' AND unbanned = 0")
		query.Execute()

		while(query.NextRow())
			var/ckey = query.item[1]
			var/job = query.item[2]

			jobban_keylist.Add("[ckey] - [job]")

		//Job tempbans
		var/DBQuery/query1 = dbcon.NewQuery("SELECT ckey, job FROM [format_table_name("ban")] WHERE bantype = 'JOB_TEMPBAN' AND unbanned = 0 AND expiration_time > Now()")
		query1.Execute()

		while(query1.NextRow())
			var/ckey = query1.item[1]
			var/job = query1.item[2]

			jobban_keylist.Add("[ckey] - [job]")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S["keys[0]"] << jobban_keylist

/proc/jobban_unban(mob/M, rank)
	jobban_remove("[M.ckey] - [rank]")
	jobban_savebanfile()
=======
		var/DBQuery/query_jobban_build_cache = GLOB.dbcon.NewQuery("SELECT job, reason FROM [format_table_name("ban")] WHERE ckey = '[sanitizeSQL(C.ckey)]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")
		if(!query_jobban_build_cache.warn_execute())
			return
		while(query_jobban_build_cache.NextRow())
			C.jobbancache[query_jobban_build_cache.item[1]] = query_jobban_build_cache.item[2]
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log,"data/ban_unban_log.txt")

/proc/jobban_updatelegacybans()
	if(!jobban_runonce)
		log_admin("Updating jobbanfile!")
		// Updates bans.. Or fixes them. Either way.
		for(var/T in jobban_keylist)
			if(!T)	continue
		jobban_runonce++	//don't run this update again

/proc/jobban_remove(X)
	for (var/i = 1; i <= length(jobban_keylist); i++)
		if( findtext(jobban_keylist[i], "[X]") )
			jobban_keylist.Remove(jobban_keylist[i])
			jobban_savebanfile()
			return 1
	return 0
