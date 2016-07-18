/*
			J.				E.				X.				P.

	This is a new system which is being put into place to ensure only well-suited people are able to have the ability to play head roles, which objective was originally to replace the way the age system works.
	The creator of this system is Super3222, and idea brought up by them.

	The age system had some easy exploits like this:
			* log in one afternoon
			* play assistant
			* log off, go onto a grief server, return a month
			* play as captain or any other head role.

	The way it works:
	- In preferences DM, it does a check to see whether the client can have a certain role
	- These roles are usually:
			* Captain
			* Head Roles: HoP, CMO, RD, CE, and HoS
			* Warden
			* Standard Security Officer

	- The check works by looking inside of the database at an SQL table, and extracting the data of what is believed to be the amount of times a person has played a role
	- If that role meets up to the specific expectations, then it'll pass. Otherwise, it will fail and that job will not be avaliable to them.

	- Sometimes, the client can be exempted from a certain job. If their name is found on one of the "exemption" lists.
	- There is an exemption list for each of the roles written above.
	- There is also an "exempt all" list which is preferablly for testing only.

	After a round ends, data is gained from the client. It will only work if they aren't dead, ghosted, or commit suicide.
	That data is then sent to the database, to be stored for later use.
	gain_jexp() is called in /datum/game_mode/declare_completion() inside of game_mode.dm

	JEXP is technically not a datum, but it's a concept and fabricated idea.
	In the future, it is planned that users will be able to see their "progress" onto achieving roles.
	As well as an accessible datum to see everyones progress for admins.


*/

var/global/list/learnerjobs = list ("Head of Security", "Chief Medical Officer", "Research Director", "Chief Engineer", "Head of Personnel", "Warden", "Security Officer", "Lawyer", "Scientist", "Roboticist", "Cargo Technician", "Quartermaster", "Medical Doctor", "Chemist", "Virologist", "Geneticist", "Paramedic", "Station Engineer", "Atmospheric Technician")

// learnerjobs are jobs that are cataloged inside of the database, and are used to unlock more jobs

/client/proc/gain_jexp(mob/M)
	if(!M.job)
		return

	if(dbcon.IsConnected())
		var/ckeygained = sanitizeSQL(get_ckey(M))

		var/assigned_job = M.job

		if(!assigned_job)
			return

		// so it first checks for whether the job is good.
		var/learnjob

		if(learnerjobs.Find(assigned_job))
			learnjob = TRUE

		if(!learnjob)
			return

		// we look int our SQL table.
		var/DBQuery/query_jexp = dbcon.NewQuery("SELECT `[assigned_job]` FROM [format_table_name("jobreq")] WHERE `ckey` = '[ckeygained]'")

		if(!query_jexp.Execute())
			return 0

		var/newcount = 0

		while(query_jexp.NextRow())
			var/jobcount
			jobcount = text2num(query_jexp.item[1])
			newcount += jobcount

		if(!M || !M.key || !M.client || M.stat == DEAD || M.mind.special_role || (M.client.is_afk(INACTIVITY_KICK)) || !ishuman(M))
			return

		newcount++

		var/DBQuery/query = dbcon.NewQuery("UPDATE [format_table_name("jobreq")] SET `[assigned_job]` = [newcount] WHERE `ckey` = '[ckeygained]'")
		query.Execute()

		M << "<span class='boldnotice'>Congratulations! You've gained a bit of JEXP by surviving as a [assigned_job].</span>"
		M << "<span class='boldnotice'>Enough JEXP will allow you to play head roles concerning the division your job is from!</span>"

	else
		return


// exempting people by each role

#define EXPEMPTEDFILE "data/expexempted.txt"
#define ALL_EXP_HOS "data/experience_exempted_saves/hos.txt"
#define ALL_EXP_HOP "data/experience_exempted_saves/hop.txt"
#define ALL_EXP_CMO "data/experience_exempted_saves/cmo.txt"
#define ALL_EXP_RD "data/experience_exempted_saves/rd.txt"
#define ALL_EXP_CAP "data/experience_exempted_saves/captain.txt"
#define ALL_EXP_CE "data/experience_exempted_saves/ce.txt"

#define ALL_EXP_SEC "data/experience_exempted_saves/warden.txt"
#define ALL_EXP_WARDEN "data/experience_exempted_saves/security.txt"

var/list/exp_exempted_all // shouldn't ever be used
var/list/exempt_captain
var/list/exempt_hos
var/list/exempt_cmo
var/list/exempt_rd
var/list/exempt_ce
var/list/exempt_hop

var/list/exempt_sec
var/list/exempt_warden



/proc/check_if_expempted(client, rank)

	var/client/C = client
	if(!exp_exempted_all && !exempt_captain && !exempt_hos && !exempt_cmo && !exempt_cmo && !exempt_rd && !exempt_ce && !exempt_hop)
		return 0

	if(C.ckey in exp_exempted_all)
		return 1

	if(rank == "Head of Security")
		if(C.ckey in exempt_hos)
			return 1
		else
			return 0

	if(rank == "Chief Medical Officer")
		if(C.ckey in exempt_cmo)
			return 1
		else
			return 0

	if(rank == "Research Director")
		if(C.ckey in exempt_rd)
			return 1
		else
			return 0

	if(rank == "Head of Personnel")
		if(C.ckey in exempt_hop)
			return 1
		else
			return 0

	if(rank == "Chief Engineer")
		if(C.ckey in exempt_ce)
			return 1
		else
			return 0

	if(rank == "Captain")
		if(C.ckey in exempt_captain)
			return 1
		else
			return 0


	// it hurts me a little inside, the fact that I have to make this. - Super
	if(rank == "Security Officer")
		if(C.key in exempt_sec)
			return 1
		else
			return 0

	if(rank == "Warden")
		if(C.key in exempt_warden)
			return 1
		else
			return 0


/proc/load_all_exp_lists()
	exempt_captain = file2list(ALL_EXP_CAP)
	if(!exempt_captain.len)
		exempt_captain = null

	exempt_hos = file2list(ALL_EXP_HOS)
	if(!exempt_hos.len)
		exempt_hos.len = null


	exempt_hop = file2list(ALL_EXP_HOP)
	if(!exempt_hop.len)
		exempt_hop.len = null

	exempt_cmo = file2list(ALL_EXP_CMO)
	if(!exempt_cmo.len)
		exempt_cmo.len = null

	exempt_rd = file2list(ALL_EXP_RD)
	if(!exempt_rd.len)
		exempt_rd.len = null

	exempt_ce = file2list(ALL_EXP_CE)
	if(!exempt_ce.len)
		exempt_ce.len = null

	exempt_sec = file2list(ALL_EXP_SEC)
	if(!exempt_sec.len)
		exempt_sec.len = null

	exempt_warden = file2list(ALL_EXP_WARDEN)
	if(!exempt_warden.len)
		exempt_warden.len = null

/proc/load_expempted()
	exp_exempted_all = file2list(EXPEMPTEDFILE)
	if(!exp_exempted_all.len)
		exp_exempted_all = null

