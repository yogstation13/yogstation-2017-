/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(var/atom/A, params)
	if(client.prefs.afreeze)
		client << "<span class='userdanger'>You are frozen by an administrator.</span>"
		return
	if(client.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, params, A))
			return

	if(control_disabled || stat) return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(var/atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1
	if(client.prefs.afreeze)
		client << "<span class='userdanger'>You are frozen by an administrator.</span>"
		return
	if(client.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, params, A))
			return

	if(control_disabled || stat)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["alt"])
		ShiftAltClickOn(A)
		return
	if(modifiers["alt"] && modifiers["ctrl"])
		CtrlAltClickOn(A)
		return

	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		if(controlled_mech) //Are we piloting a mech? Placed here so the modifiers are not overridden.
			controlled_mech.click_action(A, src, params) //Override AI normal click behavior.
		return

		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(world.time <= next_move)
		return

	if(aicamera.in_camera_mode)
		aicamera.camera_mode_off()
		aicamera.captureimage(A, usr)
		return
	if(waypoint_mode)
		set_waypoint(A)
		waypoint_mode = 0
		return

	/*
		AI restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
	else
	*/
	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)
/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/CtrlShiftClickOn(var/atom/A)
	A.AICtrlShiftClick(src)
/mob/living/silicon/ai/ShiftClickOn(var/atom/A)
	A.AIShiftClick(src)
/mob/living/silicon/ai/CtrlClickOn(var/atom/A)
	A.AICtrlClick(src)
/mob/living/silicon/ai/AltClickOn(var/atom/A)
	A.AIAltClick(src)
/mob/living/silicon/ai/ShiftAltClickOn(var/atom/A)
	A.AIShiftAltClick(src)

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/
/* Questions: Instead of an Emag check on every function, can we not add to airlocks onclick if emag return? */

/* Atom Procs */
/atom/proc/AICtrlClick()
	return
/atom/proc/AIAltClick(mob/living/silicon/ai/user)
	AltClick(user)
	return
/atom/proc/AIShiftClick()
	return
/atom/proc/AICtrlShiftClick()
	return
/atom/proc/AIShiftAltClick()
	return

/* Airlocks */
/obj/machinery/door/airlock/AICtrlClick() // Bolts doors
	if(emagged || wires.is_cut(WIRE_BOLTS) || !hasPower())
		return
	if(locked)
		unbolt()
	else
		bolt()
	return

/obj/machinery/door/airlock/AIAltClick() // Electrifies doors.
	if(emagged || wires.is_cut(WIRE_SHOCK) || !hasPower())
		return
	if(timeElectrified == 0)
		electrify(ELECTRIFY_ON, usr)
	else
		unelectrify()
	return

/obj/machinery/door/airlock/AIShiftClick()  // Opens and closes doors!
	if(emagged)
		return
	if(density)
		open()
	else
		close()
	return

/obj/machinery/door/airlock/AICtrlShiftClick()  // Sets/Unsets Emergency Access Override
	if(emagged || !hasPower())
		return
	if(!emergency)
		emergency = 1
	else
		emergency = 0
	update_icon()
	return

/obj/machinery/door/airlock/AIShiftAltClick() //toggles speed override
	if(emagged || wires.is_cut(WIRE_TIMING) || !hasPower())
		return
	if(!normalspeed)
		normalspeed = 1
	else
		normalspeed = 0
	return


/* APC */
/obj/machinery/power/apc/AICtrlClick() // turns off/on APCs.
	toggle_breaker()
	add_fingerprint(usr)

/* AI Turrets */
/obj/machinery/turretid/AIAltClick() //toggles lethal on turrets
	toggle_lethal()
	add_fingerprint(usr)

/obj/machinery/turretid/AICtrlClick() //turns off/on Turrets
	toggle_on()
	add_fingerprint(usr)

//
// Override TurfAdjacent for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(var/turf/T)
	return (cameranet && cameranet.checkTurfVis(T))
