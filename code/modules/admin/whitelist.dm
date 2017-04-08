<<<<<<< HEAD
#define WHITELISTFILE "config/whitelist.txt"

var/list/whitelist

/proc/load_whitelist()
	whitelist = list()
	for(var/line in file2list(WHITELISTFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		whitelist += line

	if(!whitelist.len)
		whitelist = null

/proc/check_whitelist(var/ckey)
	if(!whitelist)
		return FALSE
	. = (ckey in whitelist)

#undef WHITELISTFILE
=======
#define WHITELISTFILE "config/whitelist.txt"

GLOBAL_LIST(whitelist)
GLOBAL_PROTECT(whitelist)

/proc/load_whitelist()
	GLOB.whitelist = list()
	for(var/line in file2list(WHITELISTFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.whitelist += line

	if(!GLOB.whitelist.len)
		GLOB.whitelist = null

/proc/check_whitelist(var/ckey)
	if(!GLOB.whitelist)
		return FALSE
	. = (ckey in GLOB.whitelist)

#undef WHITELISTFILE
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
