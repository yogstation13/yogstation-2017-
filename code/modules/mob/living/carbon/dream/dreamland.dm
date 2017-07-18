/*
This file handles dream areas, spawn points and decor
If you want to add a spawnpoint, add an object like /obj/effect/dream_eye, the code will then pick a random one of that kind, based on the area
To add a new dream area:
1. Create a new spawnpoint. Like /obj/effect/dream/fartland
2. Set a dreamtype. dreamtype = "fartland"
3. Go to _globalvars > lists > mapping  and add var/list/fartdream = list()
4. In the list at line 12, add a new thing. "fartland" = fartdream (See step 3)
5. Go to an area in the non-dream world and do: dreamtype = "fartland
6. Profit
*/


var/list/dream_index = list(
	"dreamland" = dreamland,
	"legion"    = legiondream,
	"shuttle"   = shuttledream
	)

/obj/effect/dream_eye
	name = "dreamland"
	var/dreamtype = "dreamland"

/obj/effect/dream_eye/legion
	name = "legion dream"
	dreamtype = "legion"

/obj/effect/dream_eye/shuttle
	name = "startrek dream"
	dreamtype = "shuttle"


/obj/effect/dream_eye/New()
	..()
	var/dreaming_type = get_dream(dreamtype)
	dreaming_type += src


/proc/get_dream(var/string)
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

/area/dream/grassland
	name = "Grassland"
	ambientsounds = list('sound/ambience/dream1.ogg')

/area/dream/legion
	name = "Lavaland"

/area/dream/startrek
	name = "Shuttle"


/turf/closed/indestructible/mist
	name = "mist"
	desc = "A thick wall of mist."
	icon = 'icons/obj/dream/dream.dmi'
	icon_state = "mist"


/obj/structure/flora/tree/dream
	name = "tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_4"


/obj/effect/forcefield/invisible
	name = null
	desc = null
	icon_state = null

/obj/effect/dream
	icon = 'icons/obj/dream/dream.dmi'

/obj/effect/dream/hyperdrive
	name = "hyperdrive"
	desc = "An experimental drive that allows ships to bend space-time to accelerate, it has only seen use in a few select ships due to the magnitude \
	of what it offers."
	icon = 'icons/obj/dream/startrek.dmi'
	icon_state = "ftl_drive_trek_on"

/obj/effect/dream/trekscreen
	name = "viewscreen"
	desc = "A screen with the layout of the ship, and a few other readouts on it."
	icon = 'icons/obj/dream/startrek.dmi'
	icon_state = "trekscreen"
