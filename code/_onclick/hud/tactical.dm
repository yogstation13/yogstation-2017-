/datum/hud/tactical
	var/obj/screen/tac_harness/toggle_emag/toggle_emag_button
	var/obj/screen/tac_harness/open_inv/inv_button
	var/obj/screen/tac_harness/toggle_nightvision/toggle_nv_button

/datum/hud/tactical/New(mob/owner)
	..()

	toggle_emag_button = new /obj/screen/tac_harness/toggle_emag()

	inv_button = new /obj/screen/tac_harness/open_inv()

	toggle_nv_button = new /obj/screen/tac_harness/toggle_nightvision()

	//hud_elements += animal.pullin
	//animal.pullin.update_icon(animal)

/datum/hud/tactical/show_hud(version = 0)
	var/mob/living/simple_animal/SA = mymob
	if(!istype(SA) || !SA.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/harness = SA.harness

	toggle_emag_button.update_button_icon(harness)
	static_inventory += toggle_emag_button

	inv_button.update_button_icon(harness)
	static_inventory += inv_button

	toggle_nv_button.update_button_icon(harness)
	static_inventory += toggle_nv_button
	..()

/datum/hud/tactical/syndicate
	var/obj/screen/tac_harness/toggle_safety/toggle_safety_button

/datum/hud/tactical/syndicate/New(mob/living/simple_animal/owner)
	..()
	toggle_safety_button = new /obj/screen/tac_harness/toggle_safety()

/datum/hud/tactical/syndicate/show_hud(version = 0)
	var/mob/living/simple_animal/SA = mymob
	if(!istype(SA) || !SA.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/harness = SA.harness

	toggle_safety_button.update_button_icon(harness)
	static_inventory += toggle_safety_button

	..()

/datum/hud/tactical/corgi
	var/obj/screen/tac_harness/toggle_stun/toggle_stun_button

/datum/hud/tactical/corgi/New(mob/owner)
	..()
	toggle_stun_button = new /obj/screen/tac_harness/toggle_stun()

/datum/hud/tactical/corgi/show_hud(version = 0)
	var/mob/living/simple_animal/SA = mymob
	if(!istype(SA) || !SA.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/harness = SA.harness

	toggle_stun_button.update_button_icon(harness)
	static_inventory += toggle_stun_button
	..()

//SCREEN OBJECTS

/obj/screen/tac_harness/
	icon = 'icons/mob/screen_tactical.dmi'

/obj/screen/tac_harness/proc/update_button_icon(var/obj/item/weapon/storage/dolphin_harness/harness)
	return

/obj/screen/tac_harness/toggle_weapon
	icon_state = "swap_weapon_button"
	name = "Toggle Weapon"
	desc = "Toggle your dorsal-mounted weapon's fire mode."
	screen_loc = "SOUTH:6,CENTER:16"

/obj/screen/tac_harness/toggle_weapon/Click()
	var/mob/living/simple_animal/hostile/animal = usr
	var/obj/item/weapon/storage/tactical_harness/ranged/harness = animal.harness
	if(!istype(animal) || !animal.harness)
		return
	harness.cycle_weapon()
	if(harness.selected_weapon)
		to_chat(usr, "<span class='notice'>You toggle your dorsal weapon to fire [harness.ranged_attacks[harness.selected_weapon][0]] rounds.</span>")
	else
		to_chat(usr, "<span class='notice'>Your dorsal weapon does not have any modules loaded.</span>")

/obj/screen/tac_harness/toggle_safety
	name = "Toggle Safety"
	desc = "Toggle the safety on your dorsal-mounted weapon"
	screen_loc = "SOUTH:6,CENTER-2:16"

/obj/screen/tac_harness/toggle_safety/update_button_icon(var/obj/item/weapon/storage/tactical_harness/ranged/harness)
	if(harness)
		icon_state = harness.weapon_safety ? "safety_on" : "safety_off"

/obj/screen/tac_harness/toggle_safety/Click()
	var/mob/living/simple_animal/hostile/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/ranged/harness = animal.harness
	harness.toggle_safety()
	to_chat(usr, "<span class='notice'>You [harness.weapon_safety ? "enable" : "disable"] the safety on your dorsal weapon.</span>")

/obj/screen/tac_harness/toggle_emag
	var/on_icon = "emag_button_on"
	var/off_icon = "emag_button_off"
	name = "Toggle Emag"
	desc = "Toggle your build-in cryptographic sequencer"
	screen_loc = "SOUTH:6,CENTER:16"

/obj/screen/tac_harness/toggle_emag/update_button_icon(var/obj/item/weapon/storage/tactical_harness/harness)
	if(harness)
		icon_state = harness.emag_active ? "emag_button_on" : "emag_button_off"

/obj/screen/tac_harness/toggle_emag/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	animal.harness.toggle_emag()
	to_chat(usr, "<span class='notice'>You [animal.harness.emag_active ? "enable" : "disable"] your harness's built-in emag.</span>")

/obj/screen/pull/tac_harness
	icon = 'icons/mob/screen_tactical.dmi'
	screen_loc = "SOUTH:6,CENTER+2:16"

/obj/screen/tac_harness/open_inv
	icon_state = "inv"
	name = "Open Inventory"
	desc = "Open your harness's inventory"
	screen_loc = "SOUTH:6,CENTER+1:16"

/obj/screen/tac_harness/open_inv/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	if(animal.harness)
		animal.harness.open_inventory(usr)

/obj/screen/tac_harness/toggle_nightvision
	name = "Toggle Night-Vision"
	desc = "Toggle your harness's night-vision filter."
	screen_loc = "SOUTH:6,CENTER-1:16"

/obj/screen/tac_harness/toggle_nightvision/update_button_icon(var/obj/item/weapon/storage/tactical_harness/harness)
	if(harness)
		icon_state = harness.night_vision_on ? "nightvision_on" : "nightvision_off"

/obj/screen/tac_harness/toggle_nightvision/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	if(animal.harness)
		animal.harness.toggle_night_vision()

/obj/screen/tac_harness/toggle_stun
	name = "Toggle Stun"
	desc = "Toggle your muzzle stun device."
	screen_loc = "SOUTH:6,CENTER-2:16"

/obj/screen/tac_harness/toggle_stun/update_button_icon(var/obj/item/weapon/storage/tactical_harness/corgi/harness)
	if(harness)
		icon_state = harness.stun_on ? "baton_on" : "baton_off"

/obj/screen/tac_harness/toggle_stun/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/corgi/harness = animal.harness
	harness.stun_on = !harness.stun_on
	update_button_icon(harness)
