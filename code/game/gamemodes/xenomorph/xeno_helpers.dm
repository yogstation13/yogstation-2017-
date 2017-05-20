/datum/game_mode/xenomorph/proc/calculateXenos(var/justqueen) // is the hive alive? 0 - yes, 1 - no
	var/hive
	var/datum/mind/M = findQueen(1)

	if(M)
		if(justqueen)
			return M.current
		if(M.current)
			if(M.current.stat != DEAD)
				return FALSE // false if queens alive. however, if not than it's up to whether there's even 1 xenomorph alive
	else
		return TRUE

	for(var/datum/mind/minds in xenomorphs)
		if(minds.assigned_role != "xeno queen")
			if(minds.current.stat != DEAD && minds.current.stat > DEAD)
				hive++
	if(!hive)
		return TRUE
	else
		return FALSE

/datum/game_mode/proc/findQueen(var/mind) // 1 yes i found her, 0 no shes out with another hive again
	var/queen
	for(var/datum/mind/M in xenomorphs["QUEEN"])
		if(mind)
			queen = M
		else
			queen = M.current
	return queen


/datum/game_mode/xenomorph/proc/update_queen_suffix()
	if(queensuffix)
		return

	var/mob/living/carbon/alien/A

	for(var/datum/mind/M in xenomorphs["QUEEN"])
		if(istype(M.current, /mob/living/carbon/alien))
			A = M.current
	queensuffix = A.HD.colony_suffix

/datum/game_mode/proc/message_xenomorphs(string, deadXenos, spans1, spans2)
	if(!string)
		return

	var/xenLEN = length(xenomorphs)
	if(!xenLEN)
		return

	for(var/datum/mind/M in xenomorphs)
		if(!deadXenos)
			if(M.current.stat == DEAD)
				continue
		M.current << "<span class = '[spans1]'><span class = '[spans2]'>[string]</span></span>"

/proc/compareAlienSuffix(mob/living/carbon/alien/A1, mob/living/carbon/alien/A2, col1, col2)
	if(!A1)
		if(!col1)
			return
	if(!A2)
		if(!col2)
			return

	if(A1)
		if(!istype(A1))
			return
	if(A2)
		if(!istype(A2))
			return
//	if(!(istype(A1)) | !(istype(A2)))
//		return

	var/colonyblank1
	var/colonyblank2

	if(A1)
		colonyblank1 = A1.HD.colony_suffix
	else
		if(col1)
			colonyblank1 = col1

	if(A2)
		colonyblank2 = A2.HD.colony_suffix
	else
		if(col2)
			colonyblank2 = col2

	if(colonyblank1 == colonyblank2)
		return TRUE
	else
		return FALSE


/datum/game_mode/xenomorph/proc/getQueen()
	if(length(xenomorphs["QUEEN"]) > 1)
		message_admins("ALERT! There is more than one queen alive. Check this gamemodes xenomorph list for more information. \
			Report to a Coder if you can.")
		return
	for(var/datum/mind/M in xenomorphs["QUEEN"])
		if(M.special_role == "xeno queen")
			return M