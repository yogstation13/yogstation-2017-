/datum/map_template/ruin/space
	prefix = "_maps/RandomRuins/SpaceRuins/"
	cost = 1

/datum/map_template/ruin/space/zoo
	id = "zoo"
	suffix = "abandonedzoo.dmm"
	name = "Biological Storage Facility"
	description = "In case society crumbles, we will be able to restore our \
		zoos to working order with the breeding stock kept in these 100% \
		secure and unbreachable storage facilities. At no point has anything \
		escaped. That's our story, and we're sticking to it."

/datum/map_template/ruin/space/asteroid1
	id = "asteroid1"
	suffix = "asteroid1.dmm"
	name = "Asteroid 1"
	description = "I-spy with my little eye, something beginning with R."

/datum/map_template/ruin/space/asteroid2
	id = "asteroid2"
	suffix = "asteroid2.dmm"
	name = "Asteroid 2"
	description = "Oh my god, a giant rock!"

/datum/map_template/ruin/space/asteroid3
	id = "asteroid3"
	suffix = "asteroid3.dmm"
	name = "Asteroid 3"
	description = "This asteroid floating in space has no official \
		designation, because the scientist that discovered it deemed it \
		'super dull'."

/datum/map_template/ruin/space/asteroid4
	id = "asteroid4"
	suffix = "asteroid4.dmm"
	name = "Asteroid 4"
	description = "Nanotrasen Escape Pods have a 100%* success rate, and a \
		99%* customer satisfaction rate. *Please note that these statistics, \
		are taken from pods that have successfully docked with a recovery \
		vessel."

/datum/map_template/ruin/space/asteroid5
	id = "asteroid5"
	suffix = "asteroid5.dmm"
	name = "Asteroid 5"
	description = "Oh my god, another giant rock!"

/datum/map_template/ruin/space/freeminer_asteroid
	id = "freeminer_asteroid"
	suffix = "freeminer_asteroid.dmm"
	name = "Free Miner Asteroid"
	description = "Some space miners still cling to the old way of getting that \
		sweet, sweet plasma - painstakingly digging it out of free-floating asteroids\
		instead of flying down to the hellscape of lavaland."
	allow_duplicates = FALSE
	allow_duplicates_global = FALSE

/datum/map_template/ruin/space/freeminer_asteroid/load(turf/T, centered = FALSE)
	. = ..()
	if(.)
		var/datum/map_template/shuttle/S = shuttle_templates["whiteship_miner"]
		if(S)
			for(var/obj/machinery/shuttle_manipulator/M in machines)
				M.existing_shuttle = SSshuttle.getShuttle(S.port_id)
				addtimer(M, "action_load", 1, TIMER_UNIQUE, S)//we have to wait until the world is initialized to avoid runtimes
				break

/datum/map_template/ruin/space/deep_storage
	id = "deep-storage"
	suffix = "deepstorage.dmm"
	name = "Survivalist Bunker"
	description = "Assume the best, prepare for the worst. Generally, you \
		should do so by digging a three man heavily fortified bunker into \
		a giant unused asteroid. Then make it self sufficient, mask any \
		evidence of construction, hook it covertly into the \
		telecommunications network and hope for the best."

/datum/map_template/ruin/space/derelict1
	id = "derelict1"
	suffix = "derelict1.dmm"
	name = "Derelict 1"
	description = "Nothing to see here citizen, move along, certainly no \
		xeno outbreaks on this piece of station debris. That purple stuff? \
		It's uh... station nectar. It's a top secret research installation."

/datum/map_template/ruin/space/derelict2
	id = "derelict2"
	suffix = "derelict2.dmm"
	name = "Dinner for Two"
	description = "Oh this is the night\n\
		It's a beautiful night\n\
		And we call it bella notte"

/datum/map_template/ruin/space/derelict3
	id = "derelict3"
	suffix = "derelict3.dmm"
	name = "Derelict 3"
	description = "These hulks were once part of a larger structure, where \
		the three great \[REDACTED\] were forged."

/datum/map_template/ruin/space/derelict4
	id = "derelict4"
	suffix = "derelict4.dmm"
	name = "Derelict 4"
	description = "Centcom ferries have never crashed, will never crash, \
		there is no current investigation into a crashed ferry, and we \
		will not let Internal Affairs trample over high security information \
		in the name of this baseless witchhunt."

/datum/map_template/ruin/space/derelict5
	id = "derelict5"
	suffix = "derelict5.dmm"
	name = "Derelict 5"
	description = "The plan is, we put a whole bunch of crates full of \
		treasure in this disused warehouse, launch it into space, and then \
		ignore it. Forever."

/datum/map_template/ruin/space/empty_shell
	id = "empty-shell"
	suffix = "emptyshell.dmm"
	name = "Empty Shell"
	description = "Cosy, rural property availible for young professional \
		couple. Only twelve parsecs from the nearest hyperspace lane!"

/datum/map_template/ruin/space/gas_the_lizards
	id = "gas-the-lizards"
	suffix = "gasthelizards.dmm"
	name = "Disposal Facility 17"
	description = "Gas efficiency at 95.6%, fluid elimination at 96.2%. \
		Will require renewed supplies of 'carpet' before the end of the \
		quarter."

/datum/map_template/ruin/space/intact_empty_ship
	id = "intact-empty-ship"
	suffix = "intactemptyship.dmm"
	name = "Authorship"
	description = "Just somewhere quiet, where I can focus on my work with \
		no interruptions."

/datum/map_template/ruin/space/mech_transport
	id = "mech-transport"
	suffix = "mechtransport.dmm"
	name = "CF Corsair"
	description = "Well, when is it getting here? I have bills to pay; very \
		well-armed clients who want their shipments as soon as possible! I \
		don't care, just find it!"

/datum/map_template/ruin/space/onehalf
	id = "onehalf"
	suffix = "onehalf.dmm"
	name = "DK Excavator 453"
	description = "Based on the trace elements we've detected on the \
		gutted asteroids, we suspect that a mining ship using a restricted \
		engine is somewhere in the area. We'd like to request a patrol vessel \
		to investigate."

/datum/map_template/ruin/space/spacebar
	id = "spacebar"
	suffix = "spacebar.dmm"
	name = "The Rampant Golem and Yellow Hound"
	description = "No questions asked. No shoes/foot protection, no service. \
		No tabs. No violence in the inside areas. That's it. Welcome to the \
		Rampant Golem and Yellow Hound. Can I take your order?"

/datum/map_template/ruin/space/turreted_outpost
	id = "turreted-outpost"
	suffix = "turretedoutpost.dmm"
	name = "Unnamed Turreted Outpost"
	description = "We'd ask them to stop blaring that ruskiepop music, but \
		none of us are brave enough to go near those death turrets they have."

/datum/map_template/ruin/space/way_home
	id = "way-home"
	suffix = "way_home.dmm"
	name = "Salvation"
	description = "In the darkest times, we will find our way home."


/datum/map_template/ruin/space/wizard_academy
	id = "wizard-academy"
	suffix = "Academy.dmm"
	name = "Wizard Academy"
	description = "The Wizard Federation has desginated a hectic but \
		well-isolated space station to house wizards in training. \
		Given the plethora of valuable, magical equipment hidden within, \
		it is incredibly well-hidden, to the point where no documentation \
		of the area exists in any record. After all, it's not like \
		some doofus with an EVA suit and jetpack can just waltz around \
		in space and find it..."

/datum/map_template/ruin/space/hippie_shuttle
	id = "hippie_shuttle"
	suffix = "hippie_shuttle"
	name= "Hippie Shuttle"
	description = "These hippies went a little too far out..."

/datum/map_template/ruin/space/colony
	id = "colony"
	suffix = "colony.dmm"
	name= "colony"
	description = "A station forgotten by time filled with cryopods."

/datum/map_template/ruin/space/wreckedship
	id = "wreckedship"
	suffix = "wreckedship.dmm"
	name= "Wrecked Ship"
	description = "A crashed ship wrecked beyond repair."

/datum/map_template/ruin/space/powerstation
	id = "powerstation"
	suffix = "powerstation.dmm"
	name= "power station"
	description = "A old power station forgotten by the original corp who built it."

/datum/map_template/ruin/space/orionship
	id = "orionship"
	suffix = "orionship.dmm"
	name= "orion ship"
	description = "Man, i don't have the slightest idea, ask kmc who this is supposed to be."

/datum/map_template/ruin/space/colonistship
	id = "colonistship"
	suffix = "colonistship.dmm"
	name= "colonist ship"
	description = "A ship full of colonists ready to start a colony."

/datum/map_template/ruin/space/abandonedteleporter
	id = "abandonedteleporter"
	suffix = "abandonedteleporter.dmm"
	name= "abandoned teleporter"
	description = "Its a abandoned teleporter, duh."

/datum/map_template/ruin/space/djstation
	id = "djstation"
	suffix = "djstation.dmm"
	name= "djstation"
	description = "Some bullshit from the old derelict station."

/datum/map_template/ruin/space/derelictbig
	id = "derelictbig"
	suffix = "derelictbig.dmm"
	name= "derelict station"
	description = "Its the old KSS13, but now random."

/datum/map_template/ruin/space/derelicttcom
	id = "derelicttcom"
	suffix = "derelicttcom.dmm"
	name= "derelict telecoms"
	description = "Its the tcoms minisat from z3 but now random."

/datum/map_template/ruin/space/derelictteleroom
	id = "derelictteleroom"
	suffix = "derelictteleroom.dmm"
	name= "derelict teleroom"
	description = "Its the teleporter station from z3 but now random."

/datum/map_template/ruin/space/wreckedclownship
	id = "wreckedclownship"
	suffix = "wreckedclownship.dmm"
	name= "wrecked clown ship"
	description = "A ship trying to get back to the clown planet crashed into a asteroid."

/datum/map_template/ruin/space/lostshuttle
	id = "lostshuttle"
	suffix = "lostshuttle.dmm"
	name= "long lost ship"
	description = "A ship lost long ago during crew transfer."

/datum/map_template/ruin/space/ambush
	id = "ambush"
	suffix = "ambush.dmm"
	name= "ambush ship"
	description = "A pirate ship sending a false distress signal to ambush space merchants."

/datum/map_template/ruin/space/destroyedstationpiece
	id = "destroyedstationpiece"
	suffix = "destroyedstationpiece.dmm"
	name= "Destroyed Station Part"
	description = "A piece of a destroyed station."

/datum/map_template/ruin/space/destroyedstationpiece2
	id = "destroyedstationpiece2"
	suffix = "destroyedstationpiece2.dmm"
	name= "Destroyed Station Part"
	description = "A piece of a destroyed station."

/datum/map_template/ruin/space/corgiland
	id = "corgiland"
	suffix = "corgiland.dmm"
	name= "Corgiland"
	description = "A hollow asteroid filled with corgis."

/datum/map_template/ruin/space/crashedseedshuttle
	id = "crashedseedshuttle"
	suffix = "crashedseedshuttle.dmm"
	name= "crashed seed shuttle"
	description = "I don't even know anymore, some of these ruins they sent me doesn't make much sense."

/datum/map_template/ruin/space/alienshuttle
	id = "alienshuttle"
	suffix = "alienshuttle.dmm"
	name= "Syndie-Alien Shuttle"
	description = "A syndicate shuttle filled with xenomorphs."

/datum/map_template/ruin/space/asteroidsurvivor
	id = "asteroidsurvivor"
	suffix = "asteroidsurvivor.dmm"
	name= "crashland survivor"
	description = "A lone survivor stuck to a asteroid awaiting response to his distress signal."