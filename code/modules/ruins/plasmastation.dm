/turf/open/floor/plasteel/plasma
	name = "plasma floor"
	initial_gas_mix = "plasma=1840;TEMP=293.15"

//Basic plasmaman
/obj/effect/mob_spawn/human/plasmaman
	name = "plasma man"
	radio = /obj/item/device/radio/headset
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/plasmaman
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper"

//Plasmastation Plasmaman
/obj/effect/mob_spawn/human/plasmaman/radium
	name = "Radium Plasmaman"
	uniform = /obj/item/clothing/under/plasmaman/radium
	shoes = /obj/item/clothing/shoes/sneakers/black
	back = /obj/item/weapon/storage/backpack/satchel
	has_id = 1
	id_job = "Radium"
	mob_name = "RADIUM I"
	flavour_text = ""
	assigned_role = "Synthetic Plasmaman"

//Synthetic Plasmamans
/obj/effect/mob_spawn/human/plasmaman/primum
	name = "Synthetic Plasmaman"
	helmet = /obj/item/clothing/head/helmet/space/plasmaman
	uniform = /obj/item/clothing/under/golem
	suit = /obj/item/clothing/suit/space/eva/plasmaman
	shoes = /obj/item/clothing/shoes/sneakers/black
	back = /obj/item/weapon/storage/backpack/dufflebag
	has_id = 1
	id_job = "Primaris Clone"
	mob_name = "PRIMUM"
	flavour_text = "You are one of the first clones of the great settler. Follow your leader and claim this station for your dying race. Feed plasma sheets to the plasmaman fabricator and eject new clones to aid on your journey."
	assigned_role = "Synthetic Plasmaman"

/obj/effect/mob_spawn/human/plasmaman/original
	name = "Original Plasmaman"
	helmet = /obj/item/clothing/head/helmet/space/plasmaman
	uniform = /obj/item/clothing/under/golem
	suit = /obj/item/clothing/suit/space/eva/plasmaman
	shoes = /obj/item/clothing/shoes/sneakers/black
	back = /obj/item/weapon/storage/backpack/dufflebag
	has_id = 1
	id_job = "Settler"
	mob_name = "PLASMANIUM XIV"
	flavour_text = "You are the great settler, a plasmaman who decided to save your race through the use of carbons tech, you made a synthetic plasmaman builder. Feed plasma to said machine for new plasmamans and claim this abandoned station as the first for your kind"
	assigned_role = "Synthetic Plasmaman Leader"

//Plasmaman Spawner
/obj/item/weapon/antag_spawner/synthplasmaman
    name = "plasmama body"
    desc = "A egg shaped inert plasma skeleton"
    icon = 'icons/obj/device.dmi'
    icon_state = "locator"
    var/polling

/obj/item/weapon/antag_spawner/synthplasmaman/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] Has already been awakened!</span>"
		return 0
	return 1

//Synthetic Plasma Eggs
/obj/item/weapon/antag_spawner/synthplasmaman/attack_self(mob/user)
	if(!(check_usability(user)))
		return
	if(polling)
		return
	user << "<span class='notice'>You start awakening a new body...</span>"
	polling = TRUE
	var/list/lizard_candidates = pollCandidates("Do you want to play as a plasmaman?")
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
		user << "<span class='warning'>You fail to awaken this body</span>"

/obj/item/weapon/antag_spawner/synthplasmaman/spawn_antag(client/C, turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	M.key = C.key
	M.mind.name = "CLONIUM"
	M.real_name = "CLONIUM"
	M.name = "CLONIUM"
	M.set_species(/datum/species/plasmaman)
	M.equip_to_slot_or_del(new /obj/item/clothing/under/golem(M), slot_w_uniform)

//Plasmaman jumpsuits
/obj/item/clothing/under/plasmaman/radium
	name = "radium oxysuit"
	desc = "A orange oxyprotection suit for operation on oxygen rich atmospheres. This one was made for the Radium"
	icon = 'icons/ruins/psuit.dmi'
	icon_state = "radium"
	item_state = "radium"
	item_color = "radium"
	slowdown = 0

/obj/item/clothing/under/plasmaman/radium/cuprum
	name = "cuprum oxysuit"
	desc = "A yellow oxyprotection suit for operation on oxygen rich atmospheres. This one was made for the Cuprum"
	icon_state = "cuprum"
	item_state = "cuprum"
	item_color = "cuprum"

/obj/item/clothing/under/plasmaman/radium/ferrum
	name = "ferrum oxysuit"
	desc = "A yellow oxyprotection suit for operation on oxygen rich atmospheres. This one was made for the Ferrum"
	icon_state = "ferrum"
	item_state = "ferrum"
	item_color = "ferrum"

/obj/item/clothing/under/plasmaman/radium/clonium
	name = "clonium oxysuit"
	desc = "A yellow oxyprotection suit for operation on oxygen rich atmospheres. This one was made for a Clonium"
	icon_state = "clonium"
	item_state = "clonium"
	item_color = "clonium"

/obj/item/clothing/head/helmet/space/plasmaman/radium
	name = "radium helmet"
	desc = "A special containment helmet designed to protect a plasmaman's volatile body from outside exposure and quickly extinguish it in emergencies. This one was made for the Radium"
	icon = 'icons/ruins/psuit.dmi'
	item_state = "radium-helm"
	icon_state = "radium-helm"

/obj/item/clothing/head/helmet/space/plasmaman/radium/cuprum
	name = "cuprum helmet"
	desc = "A special containment helmet designed to protect a plasmaman's volatile body from outside exposure and quickly extinguish it in emergencies. This one was made for the Cuprum"
	icon = 'icons/ruins/psuit.dmi'
	item_state = "cuprum-helm"
	icon_state = "cuprum-helm"

/obj/item/clothing/head/helmet/space/plasmaman/radium/ferrum
	name = "ferrum helmet"
	desc = "A special containment helmet designed to protect a plasmaman's volatile body from outside exposure and quickly extinguish it in emergencies. This one was made for the Ferrum"
	icon = 'icons/ruins/psuit.dmi'
	item_state = "cerrum-helm"
	icon_state = "ferrum-helm"

/obj/item/clothing/head/helmet/space/plasmaman/radium/clonium
	name = "clonium helmet"
	desc = "A special containment helmet designed to protect a plasmaman's volatile body from outside exposure and quickly extinguish it in emergencies. This one was made for a Clonium"
	icon = 'icons/ruins/psuit.dmi'
	item_state = "clonium-helm"
	icon_state = "clonium-helm"

/obj/item/clothing/shoes/oxysuit
	name = "oxyproof shoes"
	desc = "Shoes complementary to the oxysuit for protecting your body from a oxygen rich atmosphere. This one was made for the Radium."
	icon = 'icons/ruins/psuit.dmi'
	icon_state = "radboots"
	item_state = "radboots"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/oxysuit/cuprum
	name = "oxyproof shoes"
	desc = "Shoes complementary to the oxysuit for protecting your body from a oxygen rich atmosphere. This one was made for the Cuprum."
	icon_state = "cuboots"
	item_state = "cuboots"

/obj/item/clothing/shoes/oxysuit/ferrum
	name = "oxyproof shoes"
	desc = "Shoes complementary to the oxysuit for protecting your body from a oxygen rich atmosphere. This one was made for the Ferrum."
	icon_state = "feboots"
	item_state = "feboots"

/obj/item/clothing/shoes/oxysuit/clonium
	name = "oxyproof shoes"
	desc = "Shoes complementary to the oxysuit for protecting your body from a oxygen rich atmosphere. This one was made for a Clonium."
	icon_state = "cloboots"
	item_state = "cloboots"

/obj/item/clothing/gloves/oxy
	name = "oxyproof gloves"
	desc = "These gloves are fire-resistant."
	icon = 'icons/ruins/psuit.dmi'
	item_state = "oxygloves"
	icon_state = "oxygloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = FIRE_PROOF
	var/can_be_cut = 1

/obj/item/clothing/gloves/oxy/radium
	name = "radium gloves"
	desc = "These are fire-resistant oxyproof gloves made for the Radium."
	item_state = "radgloves"
	icon_state = "radgloves"

//Spacesuis
	//Baseline hardsuits helmet
/obj/item/clothing/head/helmet/space/plasmaman/hardplasma
	name = "hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon = 'icons/ruins/psuit.dmi'
	icon_state = "plasmaman_helmet0-plasma"
	item_state = "plasmaman_helmet0-plasma"
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 10, bomb = 10, bio = 100, rad = 75)
	var/basestate = "plasmaman_helmet"
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	var/obj/item/clothing/suit/space/hardsuit/suit
	item_color = "plasma" //Determines used sprites: hardsuit[on]-[color] and hardsuit[on]-[color]2 (lying down sprite)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)


/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot turn the light on while in this [user.loc]!</span>" //To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "[basestate][on]-[item_color]"
	item_state = "[basestate][on]-[item_color]"
	user.update_inv_head()	//so our mob-overlays update

	if(on)
		user.AddLuminosity(brightness_on)
	else
		user.AddLuminosity(-brightness_on)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()


/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/pickup(mob/user)
	if(on)
		user.AddLuminosity(brightness_on)
		SetLuminosity(0)
/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/dropped(mob/user)
	..()
	if(on)
		user.AddLuminosity(-brightness_on)
		SetLuminosity(brightness_on)
	if(suit)
		suit.RemoveHelmet()

/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/item_action_slot_check(slot)
	if(slot == slot_head)
		return 1

/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/equipped(mob/user, slot)
	..()
	if(slot != slot_head)
		if(suit)
			suit.RemoveHelmet()
		else
			qdel(src)

/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/proc/display_visor_message(var/msg)
	var/mob/wearer = loc
	if(msg && ishuman(wearer))
		wearer.show_message("\icon[src]<b><span class='robot'>[msg]</span></b>", 1)

/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/hardsuit/rad_act(severity)
	..()
	display_visor_message("Radiation pulse detected! Magnitude: <span class='green'>[severity]</span> RADs.")

/obj/item/clothing/head/helmet/space/plasmaman/hardplasma/hardsuit/emp_act(severity)
	..()
	display_visor_message("[severity > 1 ? "Light" : "Strong"] electromagnetic pulse detected!")

//Hardsuit
/obj/item/clothing/suit/space/hardsuit/plasmaman
	name = "plasmaman hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon = 'icons/ruins/psuit.dmi'
	icon_state = "psuit_icon"
	item_state = "psuit_icon"
	armor = list(melee = 30, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)
	helmettype = /obj/item/clothing/head/helmet/space/plasmaman/hardplasma

/obj/item/clothing/suit/space/hardsuit/plasmaman/New()
	jetpack = new /obj/item/weapon/tank/jetpack/suit(src)
	..()