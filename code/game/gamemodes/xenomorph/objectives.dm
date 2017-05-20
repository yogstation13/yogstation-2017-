#define OBJECTIVE_CONQUER "conquer"
#define OBJECTIVE_INFESTATION "infestation"
//#define OBJECTIVE_WAR kill

/datum/game_mode/proc/gain_alien_targets()
	if(length(living_alien_targets))
		return

	for(var/mob/living/L in living_mob_list)
		if(L.mind)
			living_alien_targets += L.mind