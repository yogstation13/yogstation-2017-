//Dream datum
/datum/dream
	var/name = "Dream Controller"
	var/dreaming = FALSE
	var/mob/living/carbon/owner
	var/dream

/datum/dream/proc/Dream(mob/living/carbon/C)
	if(dreaming || !C)
		return 0
	owner = C
	var/area/current = get_area(owner)
	if(current && current.dream_type && prob(50))
		dream = pick(get_dream(current.dream_type))
	else
		dream = pick(dreamland)
	if(!dream || owner.stat != UNCONSCIOUS)
		return 0
	owner.reset_perspective(dream)
	owner.adjust_blindness(-1)
	owner.hud_used.show_hud(3)
	START_PROCESSING(SSobj, src)
	return 1

/datum/dream/process()
	if(owner.stat != UNCONSCIOUS)
		STOP_PROCESSING(SSobj, src)
		wake_up()
		return
	owner.reset_perspective(dream)


/datum/dream/proc/wake_up()
	STOP_PROCESSING(SSobj, src)
	owner.sleeping = 0
	owner.update_stat()
	dreaming = FALSE
	owner.hud_used.show_hud(1)
	owner.reset_perspective()

/*Dreaming landmarks. (Yes, you can add mobs to it)
var/list/dreamland = list()          //These are located in _globalvars > lists > mapping.dm
var/list/legiondream = list()
*/
/obj/effect/dream_eye
	name = "dreamland"
	var/dreamtype = "dreamland"

/obj/effect/dream_eye/legion
	name = "legion dream"
	dreamtype = "legion"


/obj/effect/dream_eye/New()
	..()
	var/dreaming_type = get_dream(dreamtype)
	dreaming_type += src


/proc/get_dream(var/string)
	var/list/dream_index = list(                        //Update this when adding new dream types
	"dreamland" = dreamland,
	"legion"    = legiondream
	)
	var/dreaming_type = dream_index[string]
	if(!dreaming_type)
		dreaming_type = "dreamland"
	return dreaming_type

//Areas
/area/dream
	name = "Dreamland"
	icon_state = "dream1"
	valid_territory = 0
	blob_allowed = 0
	requires_power = 0
	has_gravity = 1
