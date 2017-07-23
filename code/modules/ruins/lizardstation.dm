//Basic lizard
/obj/effect/mob_spawn/human/lizard
	name = "lizard"
	radio = /obj/item/device/radio/headset
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/lizard
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper"

//Lizard Commander
/obj/effect/mob_spawn/human/lizard/lizard_commander
	name = "Lizard Commander"
	helmet = /obj/item/clothing/head/beret/sec/commander
	uniform = /obj/item/clothing/under/pants/red
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/sneakers/red
	gloves = /obj/item/clothing/gloves/combat
	radio = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack/dufflebag/syndie
	pocket1 = /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	pocket2 = /obj/item/weapon/lighter
	belt = /obj/item/weapon/gun/projectile/automatic/pistol/m1911
	has_id = 1
	id_job = "Commander"
	mob_name = "Commands-The-Station"
	flavour_text = "You are the Commander of the Ssstation-That-Mines, a newly built station of lizocorp to which you just crash landed after a shuttle malfunction. Discover what happened to your promised station and guide it to greatness. But beware, nearby orbits a Nanotrasen station that won't be too happy about your corporation affiliation to the syndicate, but they are still the only source you have for the illegal EMP technology levels, be cautious during trade and suspicious of boarding parties. And remember that new tech levels and reinforcments can be bought from the Syndietech3000 vendor  at the cargo bay through inserting plasma sheets on the vendor."
	assigned_role = "Lizard Station Captain"
	var/special_access = list(access_free_command, access_free_engineering, access_free_medical, access_free_service, access_free_mine, access_free_security)

/obj/effect/mob_spawn/human/lizard/lizard_commander/equip(mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/ID = locate(/obj/item/weapon/card/id) in H
	if(ID)
		ID.access = special_access

//Lizard Peacekeeper
/obj/effect/mob_spawn/human/lizard/lizard_peacekeeper
	name = "Lizard Peacekeeper"
	helmet = /obj/item/clothing/head/HoS/beret/peacekeeper
	uniform = /obj/item/clothing/under/pants/black
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	radio = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack/dufflebag/syndie
	pocket1 = /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	pocket2 = /obj/item/weapon/lighter
	belt = /obj/item/weapon/melee/classic_baton
	has_id = 1
	id_job = "Peacekeeper"
	mob_name = "Shots-The-Face"
	flavour_text = "You are the Peacekeeper of the Ssstation-That-Mines, a newly built station of lizocorp to which you just crash landed after a shuttle malfunction. Keep peace among the crew and keep the station safe from exterior threats"
	assigned_role = "Lizard Station HoS"
	var/special_access = list(access_free_engineering, access_free_medical, access_free_service, access_free_mine, access_free_security)

/obj/effect/mob_spawn/human/lizard/lizard_peacekeeper/equip(mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/ID = locate(/obj/item/weapon/card/id) in H
	if(ID)
		ID.access = special_access

//Lizard Deputy
/obj/effect/mob_spawn/human/lizard/lizard_Deputy
	name = "Lizard Deputy"
	helmet = /obj/item/clothing/head/beret/sec/deputy
	uniform = /obj/item/clothing/under/pants/jeans
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/sneakers/blue
	gloves = /obj/item/clothing/gloves/color/blue
	radio = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack/dufflebag/syndie
	pocket1 = /obj/item/weapon/restraints/handcuffs
	has_id = 1
	id_job = "Deputy"
	flavour_text = "You are a Deputy of the Ssstation-That-Mines, a newly built station of lizocorp to which you just crash landed after a shuttle malfunction. The Peacekeeper is your direct head and the Commander the overall leader of the station. Keep the crew safe and maintain peace."
	assigned_role = "Lizard Station Security"
	mob_name = "aaaaa"
	var/special_access = list(access_free_engineering, access_free_medical, access_free_service, access_free_mine, access_free_security)

/obj/effect/mob_spawn/human/lizard/lizard_Deputy/equip(mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/ID = locate(/obj/item/weapon/card/id) in H
	if(ID)
		ID.access = special_access

//Lizard Engineer 1
/obj/effect/mob_spawn/human/lizard/lizard_Engineer1
	name = "Lizard Engineer 1"
	helmet = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/pants/tan
	suit = /obj/item/clothing/suit/hazardvest
	shoes = /obj/item/clothing/shoes/sneakers/yellow
	gloves = /obj/item/clothing/gloves/color/yellow
	radio = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack/dufflebag/engineering
	belt = /obj/item/weapon/storage/belt/utility/full
	has_id = 1
	id_job = "Repairer"
	flavour_text = "You are a repairer of the Ssstation-That-Mines, a newly built station of lizocorp to which you just crash landed after a shuttle malfunction. Your direct head is the Commander. Besides the crash malfunction looks like the station got raided before the crew arrived, repair it and bring the station back to its full glory"
	assigned_role = "Lizard Station Engineer"
	mob_name = "Fixes-The-Hull"
	var/special_access = list(access_free_engineering, access_free_medical, access_free_mine)

/obj/effect/mob_spawn/human/lizard/lizard_Engineer1/equip(mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/ID = locate(/obj/item/weapon/card/id) in H
	if(ID)
		ID.access = special_access

//Lizard Engineer 2
/obj/effect/mob_spawn/human/lizard/lizard_Engineer2
	name = "Lizard Engineer 2"
	helmet = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/pants/tan
	suit = /obj/item/clothing/suit/hazardvest
	shoes = /obj/item/clothing/shoes/sneakers/yellow
	gloves = /obj/item/clothing/gloves/color/yellow
	radio = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack/dufflebag/engineering
	belt = /obj/item/weapon/storage/belt/utility/full
	has_id = 1
	id_job = "Repairer"
	flavour_text = "You are a repairer of the Ssstation-That-Mines, a newly built station of lizocorp to which you just crash landed after a shuttle malfunction. Your direct head is the Commander. Besides the crash malfunction looks like the station got raided before the crew arrived, repair it and bring the station back to its full glory"
	assigned_role = "Lizard Station Engineer"
	mob_name = "Breaths-The-Air"
	var/special_access = list(access_free_engineering, access_free_medical, access_free_mine)

/obj/effect/mob_spawn/human/lizard/lizard_Engineer2/equip(mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/ID = locate(/obj/item/weapon/card/id) in H
	if(ID)
		ID.access = special_access

//Items
/obj/item/clothing/head/HoS/beret/peacekeeper
	name = "peacekeeper beret"
	desc = "A beret for asserting your power over all other lizards."
	icon_state = "hosberetblack"

/obj/item/clothing/head/beret/sec/commander
	name = "commander beret"
	desc = "A beret with the commanding insignia emblazoned on it."
	icon_state = "beret_badge"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 20
	dog_fashion = null

/obj/item/clothing/head/beret/sec/deputy
	name = "deputy beret"
	desc = "A special beret with the security insignia emblazoned on it. For deputies with class."
	icon_state = "officerberet"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 20
	dog_fashion = null

/obj/item/clothing/head/warden/policehat
	name = "Police hat"
	desc = "It's a police hat."
	icon_state = "policehelm"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 20
	dog_fashion = /datum/dog_fashion/head/warden


//lizard handheld spawner

/obj/item/weapon/antag_spawner/lizard
    name = "lizard spawner"
    desc = "spawns a lizard"
    icon = 'icons/obj/device.dmi'
    icon_state = "locator"
    var/polling

/obj/item/weapon/antag_spawner/lizard/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	return 1


/obj/item/weapon/antag_spawner/lizard/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You begin searching for a lizard...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a lizard?")
	polling = FALSE
	if(lizard_candidates.len > 0)
		used = 1
		var/mob/dead/observer/O = pick(lizard_candidates)
		var/client/C = O.client
		spawn_antag(C, get_turf(src.loc))
		var/datum/effect_system/spark_spread/S = new /datum/effect_system/spark_spread
		S.set_up(4, 1, src)
		S.start()
		qdel(src)
	else
		user << "<span class='warning'>Unable to spawn a lizard friend</span>"

/obj/item/weapon/antag_spawner/lizard/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = "codesss-the-lizard"
	M.real_name = "codesss-the-lizard"
	M.name = "codesss-the-lizard"
	M.set_species(/datum/species/lizard)
    // Add equipment code here if needed
	var/obj/item/weapon/card/id/I = new(M)
	I.registered_name = "codesss-the-lizard"
	I.access = list() //Ill figure this out in a sec for custom access
	I.icon_state = "data"
	M.wear_id = I
	M.equip_to_slot_or_del(I, slot_wear_id)
	M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/alt(M), slot_wear_suit)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/blue(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/blue(M), slot_gloves)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
	M.equip_to_slot_or_del(new /obj/item/weapon/restraints/handcuffs(M), slot_r_store)
	M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/dufflebag/syndie(M), slot_back)
	M.equip_to_slot_or_del(new /obj/item/clothing/under/pants/jeans(M), slot_w_uniform)
// /obj/item/weapon/storage/backpack/dufflebag/syndie

/obj/item/weapon/card/id/lizocorp
	desc = "A card used to provide access and identification across lizocorp settlements and stations."
	icon_state = "data"

/obj/item/weapon/card/id/lizocorp/bulliesthepeeps
	name = "Bullies-The-Peeps's data card (Deputy)"
	access = list(access_free_engineering, access_free_medical, access_free_service, access_free_mine, access_free_security)
	registered_name = "Bullies-The-Peeps"
	assignment = "Assistant"

/obj/item/weapon/card/id/lizocorp/harmsthebaton
	name = "Harms-The-Baton's data card (Deputy)"
	access = list(access_free_engineering, access_free_medical, access_free_service, access_free_mine, access_free_security)
	registered_name = "Harms-The-Baton"
	assignment = "Deputy"

/obj/item/weapon/card/id/lizocorp/brewstheale
	name = "Brews-The-Ale's data card (Brewer)"
	access = list(access_free_service)
	registered_name = "Brews-The-Ale"
	assignment = "Brewer"

/obj/item/weapon/card/id/lizocorp/roaststherat
	name = "Roasts-The-Rat's data card (Cheff)"
	access = list(access_free_medical, access_free_service)
	registered_name = "Roasts-The-Rat"
	assignment = "Cheff"

/obj/item/weapon/card/id/lizocorp/readsthelaw
	name = "Reads-The-Law's data card (Law)"
	access = list(access_free_service)
	registered_name = "Reads-The-Law"
	assignment = "Law"

/obj/item/weapon/card/id/lizocorp/minestheore
	name = "Mines-The-Ore's data card (Digger)"
	access = list(access_free_medical, access_free_service, access_free_mine)
	registered_name = "Mines-The-Ore"
	assignment = "Digger"

/obj/item/weapon/card/id/lizocorp/digsthefloor
	name = "Digs-The-Floor's data card (Digger)"
	access = list(access_free_medical, access_free_service, access_free_mine)
	registered_name= "Digs-The-Floor"
	assignment = "Digger"

/obj/item/weapon/card/id/lizocorp/thinksnewstuff
	name = "Thinks-New-Stuff's data card (Thinkerer)"
	access = list(access_free_engineering, access_free_medical, access_free_service)
	registered_name = "Thinks-New-Stuff"
	assignment = "Thinkerer"

/obj/item/weapon/card/id/lizocorp/helpsthepeeps
	name = "Helps-The-Peeps's data card (Helper)"
	access = list(access_free_engineering, access_free_medical, access_free_service)
	registered_name = "Helps-The-Peeps"
	assignment = "Helper"

/obj/item/weapon/card/id/lizocorp/buildsaspear
	name = "Builds-A-Spear's data card (Helper)"
	access = list(access_free_engineering, access_free_medical, access_free_service)
	registered_name = "Builds-A-Spear"
	assignment = "Helper"

/obj/item/weapon/card/id/lizocorp/breaksthewindow
	name = "Breaks-The-Window's data card (Helper)"
	access = list(access_free_engineering, access_free_medical, access_free_service)
	registered_name = "Breaks-The-Window"
	assignment = "Helper"

//Tinystation
/area/ruinstation
	name = "Ruin Stations"
	icon_state = "green"

/area/ruinstation/lstation
	name = "Lizard Station"
	icon_state = "green"
	sound_env = SMALL_ENCLOSED

/area/ruinstation/lstation/lprison
	name = "Place-To-Imprison"
	icon_state = "sec_prison"

/area/ruinstation/lstation/lcommand
	name = "Place-To-Command"
	icon_state = "bridge"

/area/ruinstation/lstation/lbrig
	name = "Place-To-Stand"
	icon_state = "brig"

/area/ruinstation/lstation/lsec
	name = "Place-To-Eat-Donut"
	icon_state = "security"

/area/ruinstation/lstation/lwarden
	name = "Place-To-Guard-Guns"
	icon_state = "Warden"

/area/ruinstation/lstation/larmory
	name = "Place-To-Store-Guns"
	icon_state = "armory"

/area/ruinstation/lstation/lhos
	name = "Place-To-Keep-Peace"
	icon_state = "sec_hos"

/area/ruinstation/lstation/linterrogation
	name = "Place-To-Torture-Peeps"
	icon_state = "security_sub"

/area/ruinstation/lstation/lhallway
	name = "Place-To-Walk"
	icon_state = "hallC"

/area/ruinstation/lstation/latmos
	name = "Place-To-Breath"
	icon_state = "atmos"

/area/ruinstation/lstation/lengineering
	name = "Place-Of-Repairer"
	icon_state = "engine"

/area/ruinstation/lstation/lminingwing
	name = "Place-Of-Miner"
	icon_state = "mining"

/area/ruinstation/lstation/lcargo
	name = "Place-To-Load-Crate"
	icon_state = "quartstorage"

/area/ruinstation/lstation/lrobotics
	name = "Place-To-Build-Bots"
	icon_state = "ass_line"

/area/ruinstation/lstation/lrd
	name = "Place-Of-Smart-Lizard"
	icon_state = "head_quarters"


/area/ruinstation/lstation/lmed
	name = "Place-To-Heal"
	icon_state = "medbay"

/area/ruinstation/lstation/lcloning
	name = "Place-To-Clone"
	icon_state = "cloning"


/area/ruinstation/lstation/lsurgery
	name = "Place-To-Surgery"
	icon_state = "surgery"


/area/ruinstation/lstation/lmorgue
	name = "Place-To-Die"
	icon_state = "morgue"

/area/ruinstation/lstation/lchem
	name = "Place-To-Alchemy"
	icon_state = "chem"

/area/ruinstation/lstation/lmedstorage
	name = "Place-To-Drink"
	icon_state = "medbay2"

/area/ruinstation/lstation/lhydro
	name = "Place-To-Farm"
	icon_state = "hydro"

/area/ruinstation/lstation/lkitchen
	name = "Place-To-Fry"
	icon_state = "kitchen"

/area/ruinstation/lstation/lbar
	name = "Place-To-Drink"
	icon_state = "bar"

/area/ruinstation/lstation/ljanitor
	name = "Place-Of-Cleaner"
	icon_state = "janitor"

/area/ruinstation/lstation/leva
	name = "Place-Thats-Secure"
	icon_state = "eva"

/area/ruinstation/lstation/lcrash
	name = "Shuttle-That-Crashed"
	icon_state = "storage"
	always_unpowered = 1

/area/ruinstation/lstation/lsolar
	name = "Collects-The-Energy"
	icon_state = "panelsA"

/area/shuttle/freebus
	name = "Freestation Mining Bus"

/area/shuttle/miningbus
	name = "Mining Bus"

/area/shuttle/miningasteroid
	name = "Asteroid Lander"

//Asteroid Field Zones

/area/mine/asteroidmine1
	name = "Asteroid 223B Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine2
	name = "Asteroid 224 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine3
	name = "Asteroid 225 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine4
	name = "Asteroid 225B Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine5
	name = "Asteroid 226 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine6
	name = "Asteroid 229 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine7
	name = "Asteroid 231 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine8
	name = "Asteroid 233 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine9
	name = "Asteroid 271 Mining Station"
	icon_state = "mining_living"

/area/mine/asteroidmine10
	name = "Asteroid 274 Mining Station"
	icon_state = "mining_living"

//New Mining Stuff
/obj/machinery/suit_storage_unit/mining/void
	suit_type = /obj/item/clothing/suit/space/orange
	helmet_type = /obj/item/clothing/head/helmet/space/orange
	mask_type = /obj/item/clothing/mask/breath

/obj/item/clothing/suit/space/hardsuit/mining/mmedic/New()
	jetpack = new /obj/item/weapon/tank/jetpack/suit(src)
	..()

//tinystation mining bus
/obj/machinery/computer/shuttle/freebus
	name = "Freestation Mining Bus Console"
	desc = "Used to call and send the mining bus."
	circuit = /obj/item/weapon/circuitboard/computer/freebus
	shuttleId = "freebus"
	possible_destinations = "freebus_home;freebus_away;freebus_storage;freebus_asteroid0;freebus_asteroid1;freebus_asteroid2;freebus_asteroid3;freebus_asteroid4;freebus_asteroid5"
	no_destination_swap = 1
	cooldownlen = 50

//mining bus computer
/obj/machinery/computer/shuttle/miningbus
	name = "Mining Bus Console"
	desc = "Used to call and send the mining bus."
	circuit = /obj/item/weapon/circuitboard/computer/miningbus
	shuttleId = "miningbus"
	possible_destinations = "mining_home;mining_djstation;;mining_gas;mining_distress;mining_distress2;mining_distress3;mining_distress4;mining_storage;mining_asteroid1;mining_asteroid2;mining_asteroid3;mining_asteroid4;mining_asteroid5;mining_field1;mining_field2;mining_field3;mining_field4;mining_field5;mining_field6;mining_field7;mining_field8;mining_field9;mining_field10;"
	no_destination_swap = 1
	notification = SUPP_FREQ
	cooldownlen = 50
	awayspeech = TRUE

/obj/machinery/computer/shuttle/miningbus/Topic(href, href_list)
    ..()
    if(href_list["move"])
        investigate_log("[key_name(usr)] has moved the mining shuttle", "cargo")

/obj/machinery/computer/shuttle/miningbus/awayspeech()
	return "The [shuttleId] shuttle is flying to [current_destination == "mining_home" ? "the station" : "deep space"]!"

//Asteroid Box Lander
/obj/machinery/computer/shuttle/miningasteroid
	name = "Asteroid Lander Console"
	desc = "Used to call and send the asteroid lander."
	circuit = /obj/item/weapon/circuitboard/computer/miningasteroid
	shuttleId = "miningasteroid"
	possible_destinations = "mining_home;mining_away;mining_djstation;mining_distress;mining_distress2;mining_corgi;mining_field3b"
	no_destination_swap = 1
	notification = SUPP_FREQ
	cooldownlen = 50
	awayspeech = TRUE

/obj/machinery/computer/shuttle/miningasteroid/Topic(href, href_list)
    ..()
    if(href_list["move"])
        investigate_log("[key_name(usr)] has moved the mining shuttle", "cargo")

/obj/machinery/computer/shuttle/miningasteroid/awayspeech()
	return "The [shuttleId] shuttle is flying to [current_destination == "mining_home" ? "the station" : "the asteroid"]!"

//circuits
/obj/item/weapon/circuitboard/computer/miningasteroid
	name = "circuit board (Asteroid Lander)"
	build_path = /obj/machinery/computer/shuttle/miningasteroid

/obj/item/weapon/circuitboard/computer/miningbus
	name = "circuit board (Mining Bus)"
	build_path = /obj/machinery/computer/shuttle/miningbus

/obj/item/weapon/circuitboard/computer/freebus
	name = "circuit board (Freestation Mining Bus)"
	build_path = /obj/machinery/computer/shuttle/freebus

//New Spawners and Creps
/mob/living/simple_animal/hostile/spawner/mining/carp
	name = "carp warping point"
	desc = "A hole dug btween dimensions from where space carps come swimming out."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	icon_living = "bluespace"
	mob_type = /mob/living/simple_animal/hostile/carp

