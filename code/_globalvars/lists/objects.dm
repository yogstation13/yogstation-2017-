GLOBAL_LIST_EMPTY(cable_list)					    //Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_LIST_EMPTY(portals)					        //list of all /obj/effect/portal
GLOBAL_LIST_EMPTY(airlocks)					        //list of all airlocks
GLOBAL_LIST_EMPTY(mechas_list)				        //list of all mechs. Used by hostile mobs target tracking.
GLOBAL_LIST_EMPTY(shuttle_caller_list)  		    //list of all communication consoles and AIs, for automatic shuttle calls when there are none.
GLOBAL_LIST_EMPTY(machines)					        //NOTE: this is a list of ALL machines now. The processing machines list is SSmachine.processing !
GLOBAL_LIST_EMPTY(syndicate_shuttle_boards)	        //important to keep track of for managing nukeops war declarations.
GLOBAL_LIST_EMPTY(navbeacons)					    //list of all bot nagivation beacons, used for patrolling.
GLOBAL_LIST_EMPTY(teleportbeacons)			        //list of all tracking beacons used by teleporters
GLOBAL_LIST_EMPTY(deliverybeacons)			        //list of all MULEbot delivery beacons.
GLOBAL_LIST_EMPTY(deliverybeacontags)			    //list of all tags associated with delivery beacons.
GLOBAL_LIST_EMPTY(nuke_list)
GLOBAL_LIST_EMPTY(alarmdisplay)				        //list of all machines or programs that can display station alerts
GLOBAL_LIST_EMPTY(singularities)				    //list of all singularities on the station (actually technically all engines)

<<<<<<< HEAD
var/global/list/chemical_reactions_list				//list of all /datum/chemical_reaction datums. Used during chemical reactions
var/global/list/chemical_reagents_list				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/materials_list = list()				//list of all /datum/material datums indexed by material id.
var/global/list/tech_list = list()					//list of all /datum/tech datums indexed by id.
var/global/list/surgeries_list = list()				//list of all surgeries by name, associated with their path.
var/global/list/crafting_recipes = list()				//list of all table craft recipes
var/global/list/rcd_list = list()					//list of Rapid Construction Devices.
var/global/list/apcs_list = list()					//list of all Area Power Controller machines, seperate from machines for powernet speeeeeeed.
var/global/list/antag_objective_items = list() //all items that could be antag objecives.
var/global/list/tracked_implants = list()			//list of all current implants that are tracked to work out what sort of trek everyone is on. Sadly not on lavaworld not implemented...
var/global/list/tracked_chem_implants = list()			//list of implants the prisoner console can track and send inject commands too
var/global/list/poi_list = list()					//list of points of interest for observe/follow
var/global/list/pinpointer_list = list()			//list of all pinpointers. Used to change stuff they are pointing to all at once.
<<<<<<< HEAD
var/global/list/zombie_infection_list = list() 		// A list of all zombie_infection organs, for any mass "animation"
var/global/list/meteor_list = list()				// List of all meteors.
=======
GLOBAL_LIST(chemical_reactions_list)				//list of all /datum/chemical_reaction datums. Used during chemical reactions
GLOBAL_LIST(chemical_reagents_list)				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST_EMPTY(materials_list)				//list of all /datum/material datums indexed by material id.
GLOBAL_LIST_EMPTY(tech_list)					//list of all /datum/tech datums indexed by id.
GLOBAL_LIST_EMPTY(surgeries_list)				//list of all surgeries by name, associated with their path.
GLOBAL_LIST_EMPTY(crafting_recipes)				//list of all table craft recipes
GLOBAL_LIST_EMPTY(rcd_list)					//list of Rapid Construction Devices.
GLOBAL_LIST_EMPTY(apcs_list)					//list of all Area Power Controller machines, seperate from machines for powernet speeeeeeed.
GLOBAL_LIST_EMPTY(tracked_implants)			//list of all current implants that are tracked to work out what sort of trek everyone is on. Sadly not on lavaworld not implemented...
GLOBAL_LIST_EMPTY(tracked_chem_implants)			//list of implants the prisoner console can track and send inject commands too
GLOBAL_LIST_EMPTY(poi_list)					//list of points of interest for observe/follow
GLOBAL_LIST_EMPTY(pinpointer_list)			//list of all pinpointers. Used to change stuff they are pointing to all at once.
GLOBAL_LIST_EMPTY(zombie_infection_list) 		// A list of all zombie_infection organs, for any mass "animation"
GLOBAL_LIST_EMPTY(meteor_list)				// List of all meteors.
GLOBAL_LIST_EMPTY(active_jammers)             // List of active radio jammers
GLOBAL_LIST_EMPTY(ladders)

GLOBAL_LIST_EMPTY(wire_color_directory)
GLOBAL_LIST_EMPTY(wire_name_directory)
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
=======
// A list of all zombie_infection organs, for any mass "animation"
var/global/list/zombie_infection_list = list()
var/global/list/meteor_list = list() //list of all meteors
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee
