#define OBJECTIVE_CONQUER "conquer"
#define OBJECTIVE_INFESTATION "infestation"
//#define OBJECTIVE_WAR kill

/datum/game_mode/proc/gain_alien_targets(admin=0)
	if(length(living_alien_targets) && !admin)
		return

	for(var/mob/living/L in living_mob_list)
		if(L.mind)
			if(L.z == ZLEVEL_STATION)
				living_alien_targets += L.mind