/obj/machinery/computer/shuttle/white_ship
	name = "White Ship Console"
	desc = "Used to control the White Ship."
	circuit = /obj/item/weapon/circuitboard/computer/white_ship
	shuttleId = "whiteship"
	possible_destinations = "whiteship_away;whiteship_home;whiteship_z4;whiteship_lavaland"

/obj/machinery/computer/shuttle/white_ship/miner
	name = "Free Miner Ship Console"
	desc = "Used to control the Free Miner Ship."
	circuit = /obj/item/weapon/circuitboard/computer/white_ship/miner
	shuttleId = "whiteship"
	possible_destinations = "whiteship_away;whiteship_home;whiteship_z4;whiteship_mining"
	req_access = list(access_freeminercap)

/obj/effect/mob_spawn/human/free_miner
	name = "Free Miner"
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	radio = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack/industrial
	pocket1 = /obj/item/weapon/mining_voucher
	pocket2 = /obj/item/weapon/storage/bag/ore
	belt = /obj/item/weapon/pickaxe
	has_id = 1
	id_job = "Free Miner"
	roundstart = FALSE
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper"
	flavour_text = "You are a free miner, making a living mining the asteroids that were left behind when Nanotrasen moved from asteroid mining to lavaland. Try to make a profit and show those corporates who the real miners are!"
	assigned_role = "Free Miner"
	var/special_access = list(access_mineral_storeroom, access_freeminer)

/obj/effect/mob_spawn/human/free_miner/equip(mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/ID = locate(/obj/item/weapon/card/id) in H
	if(ID)
		ID.access = special_access

/obj/effect/mob_spawn/human/free_miner/engi
	name = "Free Miner Engineer"
	assigned_role = "Free Miner Engineer"
	id_job = "Free Miner Engineer"
	flavour_text = "You are a free miner, making a living mining the asteroids that were left behind when Nanotrasen moved from asteroid mining to lavaland. Try to make a profit and show those corporates who the real miners are!"
	pocket1 = null
	pocket2 = null
	gloves = /obj/item/clothing/gloves/color/yellow
	belt = /obj/item/weapon/storage/belt/utility/full
	special_access = list(access_mineral_storeroom, access_freeminer)

/obj/effect/mob_spawn/human/free_miner/captain
	name = "Free Miner Captain"
	assigned_role = "Free Miner Captain"
	id_job = "Free Miner Captain"
	flavour_text = "You are a free miner, making a living mining the asteroids that were left behind when Nanotrasen moved from asteroid mining to lavaland. Try to make a profit and show those corporates who the real miners are! Try not to lose your ID, as it is the only way to make your ship move."
	uniform = /obj/item/clothing/under/rank/vice
	pocket1 = /obj/item/weapon/melee/classic_baton/telescopic
	special_access = list(access_mineral_storeroom, access_freeminer, access_freeminercap)

//for admins who are not experts with varedit
/obj/item/weapon/card/id/freeminer_captain
	name = "Free Miner Ship Captain ID"
	access = list(access_mineral_storeroom, access_freeminer, access_freeminercap)