//HOW DOES THIS WORK KMC?!
//Make your bar ruin in _maps/BarTypes
//Make your map 24 long (X axis)
//Make your map 14 tall (Y axis)

/*
------------------------------------------------------------------	<- 24 ->


^                          Normal Bar Areas
14                    Your shitty map will load
v                          Inside this box


X------------------------------------------------------------------
^ Spawner landmark


*/
//IF YOU DON'T DO THAT, IT'LL BREAK HORRIBLY//
//If you're adding a bar landmark to your station, ensure that the landmark is at the BOTTOM LEFTMOST part of the box! Look at where the X is on the diagram above
//If you get stuck, copypaste TEMPLATE.dmm and map away!
/* MAPPING TIPS

You only need the TURF passthroughs IF you want the maploader to ignore those parts of the map and merge them on, I.E

Imagine the X's are themed walls you've put down (Like on the diner map), the O's would be turf passthroughs, which then correspond to the map, so in this example those O's become doors!

 X X X X X X X X X X X
 X
 X
 X
 X
 X
 X X O O O X X X X X X

*/

//Have fun! ~~ Kmc//

var/global/list/bar_choosers = list()
var/global/bar_chosen = FALSE

//Spawner, ADD YOUR MAPS HERE TOO, WHERE IT SAYS!

/obj/effect/landmark/bar_spawner
	var/list/template_names = list("default","diner","disco","casino","ragecage","spacious","conveyorbar","space_ship_bar","do_it_yourself_bar")//	Mappers, add your bar name here, or it won't spawn!
	var/chosen_template = null

/obj/effect/landmark/bar_spawner/New()
	..()
	bar_landmarks += src

/obj/effect/landmark/bar_spawner/Destroy()
	bar_landmarks -= src
	return ..()


/obj/effect/landmark/bar_spawner/proc/load(template_name)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(!template_name)
		chosen_template = "default"
	var/datum/map_template/template = SSmapping.bar_room_templates[template_name]
	if(!template)
		return FALSE
	world.log << "This station was equipped with the \"[template_name]\" bar, placed at ([T.x], [T.y], [T.z])"
	template.load(T, centered = FALSE)
	template.loaded++
	return TRUE

//Template defines!

/datum/map_template/ruin/bar
	prefix = "_maps/templates/BarTypes/"
	cost = 0


/datum/map_template/ruin/bar/default	//Copy paste this, suffix is the name of your map + the .dmm extension bit!
	id = "default"
	suffix = "default.dmm"
	name = "default" //ENSURE YOUR BAR NAME IS WHAT YOURE GONNA PUT IN THE PREFERENCE! THE MAPLOADING CALLS BAR TEMPLATES BY NAME ONLY!!!!!!
	description = "Remember the old NT-x04 generation bar, faithful and trusted? -Pepperidge farm remembers \
	many folks have had many experiences in this place over the course of Ss13's operational existence, some folks prefer the simple old ways, it makes us unique..."//Now give it a nice meme description

/datum/map_template/ruin/bar/diner
	id = "diner"
	suffix = "diner.dmm"
	name = "diner"
	description = "Freedom, liberty! the open road! AMERICA FUCK YEAH! \
	Bring a sweet taste of home back to the station and steam some good hams! (gun control not included)."

/datum/map_template/ruin/bar/disco
	id = "disco"
	suffix = "disco.dmm"
	name = "disco"
	description = "When I say disco, you say party! DISCO DISCO PARTY PARTY \
	Comes equipped with a dancefloor, booze and lots of PARTY!."

/datum/map_template/ruin/bar/casino
	id = "casino"
	suffix = "casino.dmm"
	name = "casino"
	description = "Running a Casino's easy, see? \
	Like taking candy from a baby, just make sure to set up some way of purchasing chips!."

/datum/map_template/ruin/bar/ragecage
	id = "ragecage"
	suffix = "ragecage.dmm"
	name = "ragecage"
	description = "RAGE CAGE \
	ENTER THE SHITPIT AT YOUR OWN RISK BROTHAAAA!."

/datum/map_template/ruin/bar/spacious
	id = "spacious"
	suffix = "spacious.dmm"
	name = "spacious"
	description = "This is a really nice bar, open and warm \
	it's a slightly modified version of the normal bar that was inspired by a design done by one of your local crewmembers."

/datum/map_template/ruin/bar/conveyorbar
	id = "conveyorbar"
	suffix = "conveyorbar.dmm"
	name = "conveyorbar"
	description = "You just had to didn't you... \
	can you guess what this one does?."

/datum/map_template/ruin/bar/space_ship_bar
	id = "space_ship_bar"
	suffix = "space_ship.dmm"
	name = "space_ship_bar"
	description = "Engines to maximum, SHIELDS MR SCOTT. \
	the USS Callister is there for all your LARPING needs.."

/datum/map_template/ruin/bar/doityourself
	id = "do_it_yourself_bar"
	suffix = "doityourself.dmm"
	name = "do_it_yourself_bar"
	description = "A blank slate, build something great- \
	let the creativity flow through you...do it!"

//Bar specific decor!


/obj/structure/chair/americandiner
	name = "leather chair"
	desc = "It looks comfy, it is styled after 1950's old earth diners.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon_state = "americhair"
	color = null
	burn_state = FLAMMABLE
	burntime = 30
	buildstackamount = 2
	item_chair = null
	creates_scraping_noise = FALSE
	anchored = 1

/obj/structure/chair/americandiner/black
	name = "leather chair"
	icon_state = "americhair_black"

turf/open/floor/plasteel/blackwhite
	name = "ameritard floor"
	icon_state = "blackwhite"

turf/open/floor/plasteel/ameridiner
	name = "diner floor"
	icon_state = "ameridiner_kitchen"

/obj/structure/chair/americandiner/booth
	name = "booth seat"
	icon_state = "ameribooth"
	color = "#FF0000"

/obj/structure/chair/americandiner/booth/end_left
	icon_state = "ameribooth-end1"

/obj/structure/chair/americandiner/booth/end_right
	icon_state = "ameribooth-end2"


/obj/structure/chair/americandiner/booth/single
	icon_state = "ameribooth_single"
	desc = "A booth seat for one person? how sad...."


/obj/structure/chair/americandiner/booth/spin()
	return 0 //Spinning a booth oh lord no

/obj/structure/table/american
	name = "bar counter"
	desc = "A counter with a red and black motif."
	icon = 'icons/obj/smooth_structures/ameritable.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE
	canSmoothWith = null

/obj/structure/table/american/end
	name = "bar counter"
	desc = "A counter with a red and black motif."
	icon = 'icons/obj/smooth_structures/ameritable.dmi'
	icon_state = "table-end"


/mob/living/simple_animal/hostile/retaliate/dolphin/bouncer
	name = "Bouncer"
	icon_state = "bouncer"
	icon_living = "bouncer"
	icon_dead = "bouncer_dead"
	emote_taunt = list("glares")
	pass_flags = null
	speak_emote = list("Gruffs", "Murmurs", "Growls")



/obj/machinery/computer/slot_machine/casino
	name = "slot machine"
	desc = "Gambling for the antisocial."
	icon = 'icons/obj/special_slot_machine.dmi'
	icon_state = "slots1"