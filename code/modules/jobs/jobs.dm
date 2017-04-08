<<<<<<< HEAD

var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/BRIG				=(1<<5)
var/const/CHIEF				=(1<<6)
var/const/ENGINEER			=(1<<7)
var/const/ATMOSTECH			=(1<<8)
var/const/SIGNALTECH		=(1<<9)
var/const/AI				=(1<<10)
var/const/CYBORG			=(1<<11)


var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/ROBOTICIST		=(1<<2)
var/const/CHEMIST			=(1<<3)
var/const/CMO				=(1<<4)
var/const/DOCTOR			=(1<<5)
var/const/MMEDIC			=(1<<6)
var/const/GENETICIST		=(1<<7)
var/const/VIROLOGIST		=(1<<8)
var/const/PARAMEDIC			=(1<<9)
var/const/PSYCH				=(1<<10)
var/const/TOUR				=(1<<11)
var/const/WAITER			=(1<<12)
var/const/CLERK				=(1<<13)



var/const/CIVILIAN			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/COOK				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/CLOWN				=(1<<11)
var/const/MIME				=(1<<12)
var/const/ASSISTANT			=(1<<13)


var/list/assistant_occupations = list(
	"Assistant",
	"Atmospheric Technician",
	"Cargo Technician",
	"Chaplain",
	"Lawyer",
	"Librarian",
	"Psychiatrist"
)


var/list/command_positions = list(
=======
GLOBAL_LIST_INIT(command_positions, list(
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Station Engineer",
<<<<<<< HEAD
	"Atmospheric Technician",
	"Signal Technician"
)
=======
	"Atmospheric Technician"))
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc


GLOBAL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",
	"Virologist",
<<<<<<< HEAD
	"Chemist",
	"Paramedic",
	"Psychiatrist"
)
=======
	"Chemist"))
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc


GLOBAL_LIST_INIT(science_positions, list(
	"Research Director",
	"Scientist",
	"Roboticist"))


GLOBAL_LIST_INIT(supply_positions, list(
	"Head of Personnel",
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner"))


GLOBAL_LIST_INIT(civilian_positions, list(
	"Bartender",
	"Botanist",
	"Cook",
	"Janitor",
	"Librarian",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Mime",
<<<<<<< HEAD
	"Assistant",
	"Clerk",
	"Tourist"
)
=======
	"Assistant"))
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc


GLOBAL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer"))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	"AI",
	"Cyborg",
	"pAI"))

var/list/yog_positions = list(
	"Waiter",
	"Tourist",
	"Mining Medic",
	"Clerk",
	"Paramedic",
	"Psychiatrist"
)


/proc/guest_jobbans(job)
	return ((job in GLOB.command_positions) || (job in GLOB.nonhuman_positions) || (job in GLOB.security_positions))



//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(var/job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job
