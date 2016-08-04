var/datum/subsystem/jexp/SSjexp

/datum/subsystem/jexp
	name = "JEXP"
	priority = -6
	flags = SS_NO_FIRE

	var/jexpstatus = FALSE // for the first week and a half, it will be tuned off
	var/list/jexpjobs = list ("Warden", "Security Officer", "Security Deputy", "Scientist", "Roboticist", "Cargo Technician", "Quartermaster", "Medical Doctor", "Chemist", "Geneticist", "Station Engineer", "Atmospheric Technician")



/datum/subsystem/jexp/New()
	NEW_SS_GLOBAL(SSjexp)
/*
/datum/subsystem/jexp/Initialize()
	load_jexp_values() - already called in configuration.dm
	..()
*/


/datum/subsystem/proc/load_jexp_values(only_one, client/CO)

	if(!dbcon.IsConnected())
		return

	var/list/used_clients = list ()

	if(only_one)
		if(CO)
			used_clients += CO

	else
		for(var/client/client in clients)
			used_clients += client



	for(var/client/C in used_clients)
		var/ckeygained = sanitizeSQL(get_ckey(C))

		for(var/t in SSjexp.jexpjobs)
			var/DBQuery/jexp_insert = dbcon.NewQuery("INSERT INTO [format_table_name("jexp")] (ckey, job) VALUES ('[ckeygained]', '[t]') ON DUPLICATE KEY IGNORE")
			jexp_insert.Execute()

			var/DBQuery/query_jexp = dbcon.NewQuery("SELECT `count` FROM [format_table_name("jexp")] WHERE `ckey` = '[ckeygained]' AND `job` = '[t]'")
			query_jexp.Execute()

			var/counts
			while(query_jexp.NextRow())
				counts = text2num(query_jexp.item[1])
			C.cachedjexp["[t]"] = counts