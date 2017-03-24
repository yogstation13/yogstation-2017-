var/datum/subsystem/mobs/SSmob

/datum/subsystem/mobs
	name = "Mobs"
	init_order = 4
	display_order = 4
	priority = 100
	flags = SS_KEEP_TIMING|SS_NO_INIT

	var/list/currentrun = list()

/datum/subsystem/mobs/New()
	NEW_SS_GLOBAL(SSmob)


/datum/subsystem/mobs/stat_entry()
	..("P:[mob_list.len]")


/datum/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.currentrun = mob_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--
		if(M)
			M.Life(seconds)
			// Hijacking the mobs subsystem for parallax. It's less laggy this way.
			// I know this is a bit hacky, but all other options either break when
			// you have a situation like someone in a locker, or a drone in someone's
			// hand in a locker, or both. 
			if(M.client && M.hud_used)
				M.hud_used.update_parallax_movingmob()
		else
			mob_list.Remove(M)
		if (MC_TICK_CHECK)
			return