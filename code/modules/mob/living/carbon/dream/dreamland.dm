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
	"shuttle"   = shuttledream,
	"bar"       = bardream
	)

/obj/effect/dream_eye
	name = "dreamland"
	var/dreamtype = "dreamland"
	var/dream_message = "<span class='notice'>As your conciousness fades, you find yourself in a dreamworld.</span>" //What you get when u go to sleep

/obj/effect/dream_eye/legion
	name = "legion dream"
	dreamtype = "legion"
	dream_message = "<span class='notice'>When you fall asleep in the wastes, it appears even your dreams are hostile.</span>"

/obj/effect/dream_eye/shuttle
	name = "startrek dream"
	dreamtype = "shuttle"
	dream_message = "<span class='notice'>As you go unconscious, you see what might or will be.</span>"

/obj/effect/dream_eye/bar
	name = "bar"
	dreamtype = "bar"
	dream_message = "<span class='notice'>As your consciousness fades, you find yourself in a place only the librarian could dream of..</span>"


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
	name = "Grass dream"
	ambientsounds = list('sound/ambience/dream1.ogg')

/area/dream/legion
	name = "Lavaland dream "

/area/dream/startrek
	name = "Shuttle dream"

/area/dream/bar
	name = "Bar dream"


//Dream props

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


//Lustyxenoadminbusbar

/obj/effect/dream/adminbus
	name = "adminbus"
	desc = "Where only the shittiest of shits reside."

/obj/effect/dream/adminbus/backwall
	icon_state = "backwall"

/obj/effect/dream/adminbus/frontwalltop
	icon_state = "frontwalltop"

/obj/effect/dream/adminbus/frontwallbottom
	icon_state = "frontwallbottom"

/obj/effect/dream/adminbus/frontwallbottomrear
	icon_state = "frontwallbottomrear"

/obj/effect/dream/adminbus/reartire
	icon_state = "reartire"

/obj/effect/dream/adminbus/topdoor
	icon_state = "topdoor"

/obj/effect/dream/adminbus/bottomdoor
	icon_state = "bottomdoor"

/obj/effect/dream/adminbus/fronttire
	icon_state = "fronttire"

/obj/effect/dream/adminbus/hoodbottom
	icon_state = "hoodbottom"

/obj/effect/dream/adminbus/hoodtop
	icon_state = "hoodtop"

/obj/effect/dream/adminbus/wheredahoodat
	icon_state = "wheredahoodat"

/obj/effect/dream/adminbus/backseat
	icon_state = "backseat"

/obj/effect/dream/adminbus/driverseat
	icon_state = "driverseat"

//Startrek shuttle

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
