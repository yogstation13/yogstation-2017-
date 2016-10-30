/*
Chief Medical Officer
*/
/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	department_head = list("Captain")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddf0"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/cmo

	access = list(access_medical, access_morgue, access_genetics, access_heads, access_mineral_storeroom,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_maint_tunnels, access_paramedic)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_heads, access_mineral_storeroom,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_maint_tunnels, access_paramedic)

/datum/outfit/job/cmo
	name = "Chief Medical Officer"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/pda/heads/cmo
	ears = /obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/weapon/storage/firstaid/regular
	r_hand = /obj/item/weapon/storage/spooky
	suit_store = /obj/item/device/flashlight/pen
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/datum/outfit/job/cmo/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Medical")) //tell underlings (medical radio) they have a head

/*
Medical Doctor
*/
/datum/job/doctor
	title = "Medical Doctor"
	flag = DOCTOR
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/doctor

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_morgue, access_surgery)

/datum/outfit/job/doctor
	name = "Medical Doctor"

	belt = /obj/item/device/pda/medical
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen
	r_hand = /obj/item/weapon/storage/spooky

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Chemist
*/
/datum/job/chemist
	title = "Chemist"
	flag = CHEMIST
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/chemist

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_chemistry, access_mineral_storeroom)

/datum/outfit/job/chemist
	name = "Chemist"

	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/device/pda/chemist
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist
	l_hand = /obj/item/weapon/storage/spooky

	backpack = /obj/item/weapon/storage/backpack/chemistry
	satchel = /obj/item/weapon/storage/backpack/satchel_chem
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Geneticist
*/
/datum/job/geneticist
	title = "Geneticist"
	flag = GENETICIST
	department_head = list("Chief Medical Officer", "Research Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer and research director"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/geneticist

	access = list(access_medical, access_morgue, access_chemistry, access_virology, access_genetics, access_research, access_xenobiology, access_robotics, access_mineral_storeroom, access_tech_storage)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)

/datum/outfit/job/geneticist
	name = "Geneticist"

	belt = /obj/item/device/pda/geneticist
	ears = /obj/item/device/radio/headset/headset_medsci
	uniform = /obj/item/clothing/under/rank/geneticist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/genetics
	suit_store =  /obj/item/device/flashlight/pen
	l_hand = /obj/item/weapon/storage/spooky

	backpack = /obj/item/weapon/storage/backpack/genetics
	satchel = /obj/item/weapon/storage/backpack/satchel_gen
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Virologist
*/
/datum/job/virologist
	title = "Virologist"
	flag = VIROLOGIST
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/virologist

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_virology, access_mineral_storeroom)

/datum/outfit/job/virologist
	name = "Virologist"

	belt = /obj/item/device/pda/viro
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/virologist
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/virologist
	suit_store =  /obj/item/device/flashlight/pen
	l_hand = /obj/item/weapon/storage/spooky

	backpack = /obj/item/weapon/storage/backpack/virology
	satchel = /obj/item/weapon/storage/backpack/satchel_vir
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Mining Medic
To be preserved for a remake suiting lavaland.

/datum/job/miningmedic
	title = "Mining Medic"
	flag = MMEDIC
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/miningmedic

	access = list(access_medical, access_morgue, access_surgery, access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station, access_mineral_storeroom)
	minimal_access = list(access_medical, access_mining, access_mint, access_mining_station, access_mailsorting, access_mineral_storeroom)

*/

/datum/outfit/job/miningmedic
	name = "Mining Medic"


	backpack_contents = list(/obj/item/weapon/storage/firstaid/o2)
	belt = /obj/item/device/pda/medical
	ears = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/sneakers/white
	uniform = /obj/item/clothing/under/rank/mmedical
	l_hand = /obj/item/weapon/storage/firstaid/regular
	l_pocket = /obj/item/device/flashlight/pen


/*
Paramedic
*/
/datum/job/paramedic
	title = "Paramedic"
	flag = PARAMEDIC
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"


	outfit = /datum/outfit/job/paramedic

	access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_paramedic)
	minimal_access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_paramedic)

/datum/outfit/job/paramedic
	name = "Paramedic"

	backpack_contents = list(/obj/item/weapon/storage/firstaid/regular)
	belt = /obj/item/device/pda/medical
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/toggle/labcoat/emt
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_hand = /obj/item/roller
	l_pocket = /obj/item/device/flashlight
	r_pocket = /obj/item/device/gps
	r_hand = /obj/item/weapon/storage/spooky


/*
Psychiatrist
*/
/datum/job/psych
	title = "Psychiatrist"
	flag = PSYCH
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/psych

	access = list(access_medical)
	minimal_access = list(access_medical)

/datum/outfit/job/psych
	name = "Psych"

	shoes = /obj/item/clothing/shoes/sneakers/brown
	uniform = /obj/item/clothing/under/suit_jacket/burgundy
	l_hand = /obj/item/weapon/storage/briefcase
	glasses = /obj/item/clothing/glasses/regular
	belt = /obj/item/device/pda
	ears = /obj/item/device/radio/headset/headset_med
	r_hand = /obj/item/weapon/storage/spooky

