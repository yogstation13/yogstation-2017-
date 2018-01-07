/datum/votablemap
	var/name = ""
	var/friendlyname = ""
	var/minusers = 0
	var/maxusers = 0
	var/voteweight = 1

/datum/votablemap/New(name)
	name = name
	friendlyname = name