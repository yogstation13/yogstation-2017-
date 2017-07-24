//lizard handheld spawner

/obj/item/weapon/antag_spawner/lizard
	name = "lizard spawner"
	desc = "spawns a lizard"
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/polling
	var/lizname
	lizname = "name goes here"

/obj/item/weapon/antag_spawner/lizard/deputy
	name = "deputy teleporter"
	desc = "calls a deputy"
	lizname = "Bullies-The-Peeps"

/obj/item/weapon/antag_spawner/lizard/deputy/deputy2
	name = "deputy teleporter"
	desc = "calls a deputy"
	lizname = "Harms-The-Baton"

/obj/item/weapon/antag_spawner/lizard/cheff
	name = "cheff teleporter"
	desc = "calls a cheff"
	lizname = "Roasts-The-Rat"

/obj/item/weapon/antag_spawner/lizard/brewer
	name = "brewer teleporter"
	desc = "calls a brewer"
	lizname = "Brews-The-Ale"

/obj/item/weapon/antag_spawner/lizard/digger
	name = "digger teleporter"
	desc = "calls a digger"
	lizname = "Mines-The-Ore"

/obj/item/weapon/antag_spawner/lizard/digger/digger2
	name = "digger teleporter"
	desc = "calls a digger"
	lizname = "Digs-The-Floor"

/obj/item/weapon/antag_spawner/lizard/thinkerer
	name = "thinkerer teleporter"
	desc = "calls a thinkerer"
	lizname = "Thinks-New-Stuff"

////////////////procs
//Deputy
/obj/item/weapon/antag_spawner/lizard/deputy/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	return 1

/obj/item/weapon/antag_spawner/lizard/deputy/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You begin searching for the signal...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a deputy?")
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
		user << "<span class='warning'>Unable to find a signal.</span>"

/obj/item/weapon/antag_spawner/lizard/deputy/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = lizname
	M.real_name = lizname
	M.name = lizname
	M.set_species(/datum/species/lizard)
    // Add equipment code here if needed
	var/obj/item/weapon/card/id/I = new(M)
	I.registered_name = lizname
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

//Cheff
/obj/item/weapon/antag_spawner/lizard/cheff/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	return 1

/obj/item/weapon/antag_spawner/lizard/cheff/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You begin searching for the signal...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a cheff?")
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
		user << "<span class='warning'>Unable to find a signal.</span>"

/obj/item/weapon/antag_spawner/lizard/cheff/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = lizname
	M.real_name = lizname
	M.name = lizname
	M.set_species(/datum/species/lizard)
    // Add equipment code here if needed
	var/obj/item/weapon/card/id/I = new(M)
	I.registered_name = lizname
	I.access = list() //Ill figure this out in a sec for custom access
	I.icon_state = "data"
	M.wear_id = I
	M.equip_to_slot_or_del(I, slot_wear_id)
	M.equip_to_slot_or_del(new /obj/item/clothing/suit/apron/chef(M), slot_wear_suit)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/white(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/white(M), slot_gloves)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
	M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/dufflebag(M), slot_back)
	M.equip_to_slot_or_del(new /obj/item/clothing/under/pants/jeans(M), slot_w_uniform)

//brewer
/obj/item/weapon/antag_spawner/lizard/brewer/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	return 1

/obj/item/weapon/antag_spawner/lizard/brewer/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You begin searching for the signal...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a brewer?")
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
		user << "<span class='warning'>Unable to find a signal.</span>"

/obj/item/weapon/antag_spawner/lizard/brewer/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = lizname
	M.real_name = lizname
	M.name = lizname
	M.set_species(/datum/species/lizard)
    // Add equipment code here if needed
	var/obj/item/weapon/card/id/I = new(M)
	I.registered_name = lizname
	I.access = list() //Ill figure this out in a sec for custom access
	I.icon_state = "data"
	M.wear_id = I
	M.equip_to_slot_or_del(I, slot_wear_id)
	M.equip_to_slot_or_del(new /obj/item/clothing/suit/jacket(M), slot_wear_suit)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
	M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/dufflebag(M), slot_back)
	M.equip_to_slot_or_del(new /obj/item/clothing/under/pants/jeans(M), slot_w_uniform)

//digger
/obj/item/weapon/antag_spawner/lizard/digger/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	return 1

/obj/item/weapon/antag_spawner/lizard/digger/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You begin searching for the signal...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a brewer?")
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
		user << "<span class='warning'>Unable to find a signal.</span>"

/obj/item/weapon/antag_spawner/lizard/digger/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = lizname
	M.real_name = lizname
	M.name = lizname
	M.set_species(/datum/species/lizard)
    // Add equipment code here if needed
	var/obj/item/weapon/card/id/I = new(M)
	I.registered_name = lizname
	I.access = list() //Ill figure this out in a sec for custom access
	I.icon_state = "data"
	M.wear_id = I
	M.equip_to_slot_or_del(I, slot_wear_id)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/purple(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
	M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/dufflebag(M), slot_back)
	M.equip_to_slot_or_del(new /obj/item/clothing/under/pants/jeans(M), slot_w_uniform)

//thinkerer
/obj/item/weapon/antag_spawner/lizard/thinkerer/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	return 1

/obj/item/weapon/antag_spawner/lizard/thinkerer/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You begin searching for the signal...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a thinkerer?")
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
		user << "<span class='warning'>Unable to find a signal.</span>"

/obj/item/weapon/antag_spawner/lizard/thinkerer/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = lizname
	M.real_name = lizname
	M.name = lizname
	M.set_species(/datum/species/lizard)
    // Add equipment code here if needed
	var/obj/item/weapon/card/id/I = new(M)
	I.registered_name = lizname
	I.access = list() //Ill figure this out in a sec for custom access
	I.icon_state = "data"
	M.wear_id = I
	M.equip_to_slot_or_del(I, slot_wear_id)
	M.equip_to_slot_or_del(new /obj/item/clothing/suit/toggle/labcoat/science(M), slot_wear_suit)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/purple(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
	M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/dufflebag(M), slot_back)
	M.equip_to_slot_or_del(new /obj/item/clothing/under/pants/khaki(M), slot_w_uniform)