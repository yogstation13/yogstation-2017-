/obj/item/scope
	name = "scope"
	actions_types = list(/datum/action/item_action/toggle_scope_zoom)
	//icon_state = "game_kit"
	var/zoom_amt = 7
	var/zoomed
	var/mob/living/L

/obj/item/scope/New()
	..()
	for(var/datum/action/item_action/toggle_scope_zoom/zoom in src.actions)
		zoom.scope = src

/obj/item/scope/Destroy()
	zoom(L, FALSE)
	..()

/obj/item/scope/attack_self(mob/user)
	..()
	zoom(user)

/obj/item/scope/proc/zoom(mob/living/user, forced_zoom)
	if(!user || !user.client)
		return

	switch(forced_zoom)
		if(FALSE)
			zoomed = FALSE
		if(TRUE)
			zoomed = TRUE
		else
			zoomed = !zoomed

	if(zoomed)
		L = user
		var/_x = 0
		var/_y = 0
		switch(user.dir)
			if(NORTH)
				_y = zoom_amt
			if(EAST)
				_x = zoom_amt
			if(SOUTH)
				_y = -zoom_amt
			if(WEST)
				_x = -zoom_amt

		user.client.pixel_x = world.icon_size*_x
		user.client.pixel_y = world.icon_size*_y
	else
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		L = 0

/obj/item/scope/security
	name = "security binoculars"
	desc = "Recon-prone binoculars useful for scouting areas before contact, and other thoughtful means. It starts with a 7x lens that can be adjusted."
	var/max_zoom = 15
	var/min_zoom = 5
	icon_state = "binocular"
	item_state = "binocular"

/obj/item/scope/security/examine(mob/user)
	..()
	user << "<span class='notice'>You can adjust this item by using CTRL+click to increase the zoom range, and ALT+click to decrease it.</span>"

/obj/item/scope/security/CtrlClick()
	if(!Adjacent(usr))
		return

	var/increase = CheckLength("max")
	var/mob/living/owner = usr
	if(increase)
		zoom(owner, FALSE)
		zoom_amt++
		usr << "<span class='warning'>You push the dial on [src] forward increasing the zoom range to [zoom_amt]</span>"
	else
		usr << "<span class='warning'>You cannot adjust this anyway further.</span>"

/obj/item/scope/security/AltClick()
	if(!Adjacent(usr))
		return

	var/decrease = CheckLength("min")
	var/mob/living/owner = usr
	if(decrease)
		zoom(owner, FALSE)
		zoom_amt--
		usr << "<span class='warning'>You pull the dial on [src] backwards decreasing the zoom range to [zoom_amt]</span>"
	else
		usr << "<span class='warning'>You cannot adjust this any further.</span>"


/obj/item/scope/security/proc/CheckLength(type) // grabbing whether we can adjust the max or min. make sure they don't touch cap.
	if(!type)
		return

	if(type == "max")
		if(zoom_amt < max_zoom)
			return TRUE

	if(type == "min")
		if(zoom_amt > min_zoom)
			return TRUE

	return FALSE

/datum/action/item_action/toggle_scope_zoom
	name = "Toggle Scope"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING
	button_icon_state = "sniper_zoom"
	var/obj/item/scope/scope = null

/datum/action/item_action/toggle_scope_zoom/Trigger()
	scope.zoom(owner)

/datum/action/item_action/toggle_scope_zoom/IsAvailable()
	. = ..()
	if(!.)
		scope.zoom(owner, FALSE)

/datum/action/item_action/toggle_scope_zoom/Remove(mob/living/L)
	scope.zoom(L, FALSE)
	..()

/obj/item/scope/security/toy
	desc = "Use your binoculars to recon the area, Snake!"
	zoom_amt = 1
	max_zoom = 5
	min_zoom = 1