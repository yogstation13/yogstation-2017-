/mob/living/silicon/robot
	name = "Cyborg"
	real_name = "Cyborg"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	maxHealth = 100
	health = 100
	macro_default = "robot-default"
	macro_hotkeys = "robot-hotkeys"
	bubble_icon = "robot"
	designation = "Default" //used for displaying the prefix & getting the current module of cyborg
	has_limbs = 1

	var/custom_name = ""
	var/braintype = "Cyborg"
	var/modtype = "robot"
	var/obj/item/robot_parts/robot_suit/robot_suit = null //Used for deconstruction to remember what the borg was constructed out of..
	var/obj/item/device/mmi/mmi = null
	var/datum/robot_skin/robot_skin

//Hud stuff

	var/obj/screen/inv1 = null
	var/obj/screen/inv2 = null
	var/obj/screen/inv3 = null
	var/obj/screen/lamp_button = null
	var/obj/screen/thruster_button = null

	var/shown_robot_modules = 0	//Used to determine whether they have the module menu shown or not
	var/obj/screen/robot_modules_background

//3 Modules can be activated at any one time.
	var/obj/item/weapon/robot_module/module = null
	var/obj/item/module_active = null
	var/obj/item/module_state_1 = null
	var/obj/item/module_state_2 = null
	var/obj/item/module_state_3 = null

	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/weapon/stock_parts/cell/cell = null
	var/obj/machinery/camera/camera = null

	var/opened = 0
	var/emagged = 0
	var/emag_cooldown = 0
	var/wiresexposed = 0

	var/ident = 0
	var/locked = 1
	var/list/req_access = list(access_robotics)

	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list(), "Camera"=list(), "Burglar"=list())
	var/viewalerts = 0

	var/speed = 0 // VTEC speed boost.
	var/magpulse = FALSE // Magboot-like effect.
	var/ionpulse = FALSE // Jetpack-like effect.
	var/ionpulse_on = FALSE // Jetpack-like effect.
	var/datum/effect_system/trail_follow/ion/ion_trail // Ionpulse effect.

	var/low_power_mode = 0 //whether the robot has no charge left.
	var/datum/effect_system/spark_spread/spark_system // So they can initialize sparks whenever/N

	var/lawupdate = 1 //Cyborgs will sync their laws with their AI by default
	var/scrambledcodes = 0 // Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/lockcharge //Boolean of whether the borg is locked down or not

	var/toner = 0
	var/tonermax = 40

	var/lamp_max = 10 //Maximum brightness of a borg lamp. Set as a var for easy adjusting.
	var/lamp_intensity = 0 //Luminosity of the headlamp. 0 is off. Higher settings than the minimum require power.
	var/lamp_recharging = 0 //Flag for if the lamp is on cooldown after being forcibly disabled.

	var/sight_mode = 0
	var/updating = 0 //portable camera camerachunk update
	hud_possible = list(ANTAG_HUD, DIAG_STAT_HUD, DIAG_HUD, DIAG_BATT_HUD)

/mob/living/silicon/robot/New(loc)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	robot_skin = new /datum/robot_skin/standard()

	wires = new /datum/wires/robot(src)

	robot_modules_background = new()
	robot_modules_background.icon_state = "block"
	robot_modules_background.layer = HUD_LAYER	//Objects that appear on screen are on layer ABOVE_HUD_LAYER, UI should be just below it.

	ident = rand(1, 999)
	update_icons()

	if(!cell)
		cell = new /obj/item/weapon/stock_parts/cell(src)
		cell.maxcharge = 7500
		cell.charge = 7500

	if(lawupdate)
		make_laws()
		connected_ai = select_active_ai_with_fewest_borgs()
		if(connected_ai)
			connected_ai.connected_robots += src
			lawsync()
			lawupdate = 1
		else
			lawupdate = 0

	radio = new /obj/item/device/radio/borg(src)
	if(!scrambledcodes && !camera)
		camera = new /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.network = list("SS13")
		if(wires.is_cut(WIRE_CAMERA))
			camera.status = 0
	..()

	//MMI stuff. Held togheter by magic. ~Miauw
	if(!mmi || !mmi.brainmob)
		mmi = new (src)
		mmi.brain = new /obj/item/organ/brain(mmi)
		mmi.brain.name = "[real_name]'s brain"
		mmi.icon_state = "mmi_full"
		mmi.name = "Man-Machine Interface: [real_name]"
		mmi.brainmob = new(mmi)
		mmi.brainmob.name = src.real_name
		mmi.brainmob.real_name = src.real_name
		mmi.brainmob.container = mmi

	updatename()

	playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)
	aicamera = new/obj/item/device/camera/siliconcam/robot_camera(src)
	toner = tonermax
	diag_hud_set_borgcell()

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
/mob/living/silicon/robot/Destroy()
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = get_turf(loc)//To hopefully prevent run time errors.
		if(T)
			mmi.loc = T
		if(mmi.brainmob)
			if(mmi.brainmob.stat == DEAD)
				mmi.brainmob.stat = CONSCIOUS
				dead_mob_list -= mmi.brainmob
				living_mob_list += mmi.brainmob
			mind.transfer_to(mmi.brainmob)
			mmi.update_icon()
		else
			to_chat(src, "<span class='boldannounce'>Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug.</span>")
			ghostize()
			spawn(0)
				throw EXCEPTION("Borg MMI lacked a brainmob")
		mmi = null
	if(connected_ai)
		connected_ai.connected_robots -= src
	qdel(wires)
	qdel(module)
	wires = null
	module = null
	camera = null
	cell = null
	return ..()


/mob/living/silicon/robot/proc/pick_module()
	if(module)
		return

	var/static/list/modulelist
	if(!modulelist)
		modulelist = list("Standard" = /obj/item/weapon/robot_module/standard,
							"Engineering" = /obj/item/weapon/robot_module/engineering,
							"Medical" = /obj/item/weapon/robot_module/medical,
							"Miner" = /obj/item/weapon/robot_module/miner,
							"Janitor" = /obj/item/weapon/robot_module/janitor,
							"Service" = /obj/item/weapon/robot_module/butler,
							"Clown" = /obj/item/weapon/robot_module/clown)
		if(!config.forbid_peaceborg)
			modulelist["Peacekeeper"] = /obj/item/weapon/robot_module/peacekeeper
		if(!config.forbid_secborg)
			modulelist["Security"] = /obj/item/weapon/robot_module/security

	designation = input("Please, select a module!", "Robot", null, null) as anything in modulelist

	if(module || !designation)
		return

	updatename()

	var/module_type = modulelist[designation]
	module = new module_type(src)
	module.on_pick(src)

	var/static/list/module_skins
	if(!module_skins)
		module_skins = subtypesof(/obj/item/weapon/robot_module)
		for(var/V in module_skins)
			module_skins[V] = list()

		for(var/V in subtypesof(/datum/robot_skin))
			var/datum/robot_skin/skin = new V()
			for(var/M in skin.modules)
				module_skins[M] += skin

	var/list/skinOptions = list()
	for(var/V in module_skins[module.type])
		var/datum/robot_skin/skin = V
		if(skin.can_be_used_by(src))
			skinOptions[skin.name] = skin
	if(!skinOptions)
		return
	var/selected_skin = input("Select an icon!", "Robot", null, null) as anything in skinOptions
	if(!selected_skin)
		selected_skin = skinOptions[1]
	robot_skin = skinOptions[selected_skin]
	if(robot_skin.transform_animation_length)
		icon = robot_skin.transform_animation_icon
		src.dir = SOUTH
		notransform = 1
		flick(robot_skin.transform_animation_icon_state, src)
		sleep(robot_skin.transform_animation_length)
		notransform = 0
	icon = robot_skin.icon
	icon_state = robot_skin.icon_state

	notify_ai(2)
	update_icons()
	update_headlamp()

	SetEmagged(emagged) // Update emag status and give/take emag modules.

/mob/living/silicon/robot/proc/reset_module()
	notify_ai(2)

	robot_skin = new /datum/robot_skin/standard()
	uneq_all()
	hands.icon_state = "nomod"
	icon_state = "robot"
	qdel(module)
	module = null

	designation = "Default"
	updatename("Default")

	update_icons()
	update_headlamp()

	speed = 0 // Remove upgrades.
	ionpulse = FALSE
	magpulse = FALSE
	weather_immunities = list("ash")

	status_flags |= CANPUSH

/mob/living/silicon/robot/proc/updatename()
	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
	else
		changed_name = "[(designation ? "[designation] " : "")][mmi.braintype]-[num2text(ident)]"
	real_name = changed_name
	name = real_name
	if(camera)
		camera.c_tag = real_name	//update the camera name too

/mob/living/silicon/robot/verb/cmd_robot_alerts()
	set category = "Robot Commands"
	set name = "Show Alerts"
	if(usr.stat == DEAD)
		to_chat(src, "<span class='userdanger'>Alert: You are dead.</span>")
		return //won't work if dead
	robot_alerts()

//for borg hotkeys, here module refers to borg inv slot, not core module
/mob/living/silicon/robot/verb/cmd_toggle_module(module as num)
	set name = "Toggle Module"
	set hidden = 1
	toggle_module(module)

/mob/living/silicon/robot/verb/cmd_unequip_module()
	set name = "Unequip Module"
	set hidden = 1
	uneq_active()

/mob/living/silicon/robot/proc/robot_alerts()
	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[src];mach_close=robotalerts'>Close</A><BR><BR>"
	for (var/cat in alarms)
		dat += text("<B>[cat]</B><BR>\n")
		var/list/L = alarms[cat]
		if (L.len)
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				var/list/sources = alm[3]
				dat += "<NOBR>"
				dat += text("-- [A.name]")
				if (sources.len > 1)
					dat += text("- [sources.len] sources")
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	viewalerts = 1
	src << browse(dat, "window=robotalerts&can_close=0")

/mob/living/silicon/robot/proc/ionpulse()
	if(!ionpulse_on)
		return

	if(cell.charge <= 50)
		toggle_ionpulse()
		return

	cell.charge -= 50 // 500 steps on a default cell.
	return 1

/mob/living/silicon/robot/proc/toggle_ionpulse()
	if(!ionpulse)
		to_chat(src, "<span class='notice'>No thrusters are installed!</span>")
		return

	if(!ion_trail)
		ion_trail = new
		ion_trail.set_up(src)

	ionpulse_on = !ionpulse_on
	to_chat(src, "<span class='notice'>You [ionpulse_on ? null :"de"]activate your ion thrusters.</span>")
	if(ionpulse_on)
		ion_trail.start()
	else
		ion_trail.stop()
	if(thruster_button)
		thruster_button.icon_state = "ionpulse[ionpulse_on]"

/mob/living/silicon/robot/blob_act(obj/effect/blob/B)
	if (stat != 2)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	else
		gib()
		return 1
	return 0

/mob/living/silicon/robot/Stat()
	..()
	if(statpanel("Status"))
		if(cell)
			stat("Charge Left:", "[cell.charge]/[cell.maxcharge]")
		else
			stat(null, text("No Cell Inserted!"))

		stat("Station Time:", worldtime2text())
		if(module)
			for(var/datum/robot_energy_storage/st in module.storages)
				stat("[st.name]:", "[st.energy]/[st.max_energy]")
		if(connected_ai)
			stat("Master AI:", connected_ai.name)

/mob/living/silicon/robot/restrained(ignore_grab)
	. = 0

/mob/living/silicon/robot/ex_act(severity, target)
	switch(severity)
		if(1)
			gib()
			return
		if(2)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3)
			if (stat != 2)
				adjustBruteLoss(30)
	return


/mob/living/silicon/robot/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	updatehealth()
	if(prob(75) && Proj.damage > 0) spark_system.start()
	return 2

/mob/living/silicon/robot/triggerAlarm(class, area/A, O, obj/alarmsource)
	if(alarmsource.z != z)
		return
	if(stat == DEAD)
		return 1
	var/list/L = alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	queueAlarm(text("--- [class] alarm detected in [A.name]!"), class)
//	if (viewalerts) robot_alerts()
	return 1

/mob/living/silicon/robot/cancelAlarm(class, area/A, obj/origin)
	var/list/L = alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	if (cleared)
		queueAlarm("--- [class] alarm in [A.name] has been cleared.", class, 0)
//		if (viewalerts) robot_alerts()
	return !cleared

/mob/living/silicon/robot/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/weldingtool) && (user.a_intent != "harm" || user == src))
		user.changeNext_move(CLICK_CD_MELEE)
		var/obj/item/weapon/weldingtool/WT = W
		if (!getBruteLoss())
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
			return
		if (WT.remove_fuel(0, user)) //The welder has 1u of fuel consumed by it's afterattack, so we don't need to worry about taking any away.
			if(src == user)
				to_chat(user, "<span class='notice'>You start fixing youself...</span>")
				if(!do_after(user, 50, target = src))
					return

			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			visible_message("<span class='notice'>[user] has fixed some of the dents on [src].</span>")
			return
		else
			to_chat(user, "<span class='warning'>The welder must be on for this task!</span>")
			return

	else if(istype(W, /obj/item/stack/cable_coil) && wiresexposed)
		user.changeNext_move(CLICK_CD_MELEE)
		var/obj/item/stack/cable_coil/coil = W
		if (getFireLoss() > 0)
			if(src == user)
				to_chat(user, "<span class='notice'>You start fixing youself...</span>")
				if(!do_after(user, 50, target = src))
					return
			if (coil.use(1))
				adjustFireLoss(-30)
				updatehealth()
				user.visible_message("[user] has fixed some of the burnt wires on [src].", "<span class='notice'>You fix some of the burnt wires on [src].</span>")
			else
				to_chat(user, "<span class='warning'>You need more cable to repair [src]!</span>")
		else
			to_chat(user, "The wires seem fine, there's no need to fix them.")

	else if(istype(W, /obj/item/weapon/crowbar))	// crowbar means open or close the cover
		if(opened)
			to_chat(user, "<span class='notice'>You close the cover.</span>")
			opened = 0
			update_icons()
		else
			if(locked)
				to_chat(user, "<span class='warning'>The cover is locked and cannot be opened!</span>")
			else
				to_chat(user, "<span class='notice'>You open the cover.</span>")
				opened = 1
				update_icons()

	else if(istype(W, /obj/item/weapon/stock_parts/cell) && opened)	// trying to put a cell inside
		if(wiresexposed)
			to_chat(user, "<span class='warning'>Close the cover first!</span>")
		else if(cell)
			to_chat(user, "<span class='warning'>There is a power cell already installed!</span>")
		else
			if(!user.drop_item())
				return
			W.loc = src
			cell = W
			to_chat(user, "<span class='notice'>You insert the power cell.</span>")
		update_icons()
		diag_hud_set_borgcell()

	else if(is_wire_tool(W))
		if (wiresexposed)
			wires.interact(user)
		else
			to_chat(user, "<span class='warning'>You can't reach the wiring!</span>")

	else if(istype(W, /obj/item/weapon/screwdriver) && opened && !cell)	// haxing
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
		update_icons()

	else if(istype(W, /obj/item/weapon/screwdriver) && opened && cell)	// radio
		if(radio)
			radio.attackby(W,user)//Push it to the radio to let it handle everything
		else
			to_chat(user, "<span class='warning'>Unable to locate a radio!</span>")
		update_icons()

	else if(istype(W, /obj/item/weapon/wrench) && opened && !cell) //Deconstruction. The flashes break from the fall, to prevent this from being a ghetto reset module.
		if(!lockcharge)
			to_chat(user, "<span class='boldannounce'>[src]'s bolts spark! Maybe you should lock them down first!</span>")
			spark_system.start()
			return
		else
			playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You start to unfasten [src]'s securing bolts...</span>")
			if(do_after(user, 50/W.toolspeed, target = src) && !cell)
				user.visible_message("[user] deconstructs [src]!", "<span class='notice'>You unfasten the securing bolts, and [src] falls to pieces!</span>")
				deconstruct()

	else if(istype(W, /obj/item/weapon/aiModule))
		var/obj/item/weapon/aiModule/MOD = W
		if(!opened)
			to_chat(user, "<span class='warning'>You need access to the robot's insides to do that!</span>")
			return
		if(wiresexposed)
			to_chat(user, "<span class='warning'>You need to close the wire panel to do that!</span>")
			return
		if(!cell)
			to_chat(user, "<span class='warning'>You need to install a power cell to do that!</span>")
			return
		if(emagged || (connected_ai && lawupdate)) //Can't be sure which, metagamers
			emote("buzz-[user.name]")
			return
		if(!mind) //A player mind is required for law procs to run antag checks.
			to_chat(user, "<span class='warning'>[src] is entirely unresponsive!</span>")
			return
		MOD.install(laws, user) //Proc includes a success mesage so we don't need another one
		return

	else if(istype(W, /obj/item/device/encryptionkey/) && opened)
		if(radio)//sanityyyyyy
			radio.attackby(W,user)//GTFO, you have your own procs
		else
			to_chat(user, "<span class='warning'>Unable to locate a radio!</span>")

	else if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, "<span class='notice'>The interface seems slightly damaged.</span>")
		if(opened)
			to_chat(user, "<span class='warning'>You must close the cover to swipe an ID card!</span>")
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] [src]'s cover.</span>")
				update_icons()
			else
				to_chat(user, "<span class='danger'>Access denied.</span>")

	else if(istype(W, /obj/item/borg/upgrade/))
		var/obj/item/borg/upgrade/U = W
		if(!opened)
			to_chat(user, "<span class='warning'>You must access the borgs internals!</span>")
		else if(!src.module && U.require_module)
			to_chat(user, "<span class='warning'>The borg must choose a module before it can be upgraded!</span>")
		else if(U.locked)
			to_chat(user, "<span class='warning'>The upgrade is locked and cannot be used yet!</span>")
		else
			if(!user.drop_item())
				return
			if(U.action(src))
				to_chat(user, "<span class='notice'>You apply the upgrade to [src].</span>")
				U.loc = src
			else
				to_chat(user, "<span class='danger'>Upgrade error.</span>")

	else if(istype(W, /obj/item/device/toner))
		if(toner >= tonermax)
			to_chat(user, "<span class='warning'>The toner level of [src] is at it's highest level possible!</span>")
		else
			if(!user.drop_item())
				return
			toner = tonermax
			qdel(W)
			to_chat(user, "<span class='notice'>You fill the toner level of [src] to its max capacity.</span>")
	else
		return ..()

/mob/living/silicon/robot/attacked_by(obj/item/I, mob/living/user, def_zone)
	if(I.force && I.damtype != STAMINA && stat != DEAD) //only sparks if real damage is dealt.
		spark_system.start()
	return ..()


/mob/living/silicon/robot/emag_act(mob/user)
	if(user != src)//To prevent syndieborgs from emagging themselves
		if(!opened)//Cover is closed
			if(locked)
				to_chat(user, "<span class='notice'>You emag the cover lock.</span>")
				locked = 0
			else
				to_chat(user, "<span class='warning'>The cover is already unlocked!</span>")
			return
		if(opened)//Cover is open
			if((world.time - 100) < emag_cooldown)
				return

			if(syndicate)
				to_chat(user, "<span class='notice'>You emag [src]'s interface.</span>")
				to_chat(src, "<span class='danger'>ALERT: Foreign software execution prevented.</span>")
				log_game("[key_name(user)] attempted to emag cyborg [key_name(src)] but they were a syndicate cyborg.")
				emag_cooldown = world.time
				return

			var/ai_is_antag = 0
			if(connected_ai && connected_ai.mind)
				if(connected_ai.mind.special_role)
					ai_is_antag = (connected_ai.mind.special_role == "traitor")
			if(ai_is_antag)
				to_chat(user, "<span class='notice'>You emag [src]'s interface.</span>")
				to_chat(src, "<span class='danger'>ALERT: Foreign software execution prevented.</span>")
				to_chat(connected_ai, "<span class='danger'>ALERT: Cyborg unit \[[src]] successfuly defended against subversion.</span>")
				log_game("[key_name(user)] attempted to emag cyborg [key_name(src)] slaved to traitor AI [connected_ai].")
				emag_cooldown = world.time
				return

			if(wiresexposed)
				to_chat(user, "<span class='warning'>You must unexpose the wires first!</span>")
				return
			else
				emag_cooldown = world.time
				sleep(6)
				SetEmagged(1)
				SetLockdown(1) //Borgs were getting into trouble because they would attack the emagger before the new laws were shown
				lawupdate = 0
				connected_ai = null
				to_chat(user, "<span class='notice'>You emag [src]'s interface.</span>")
				message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)].  Laws overridden.")
				log_game("[key_name(user)] emagged cyborg [key_name(src)].  Laws overridden.")
				clear_supplied_laws()
				clear_inherent_laws()
				clear_zeroth_law(0)
				laws = new /datum/ai_laws/syndicate_override
				var/time = time2text(world.realtime,"hh:mm:ss")
				lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
				set_zeroth_law("Only [user.real_name] and people they designate as being such are Syndicate Agents.")
				to_chat(src, "<span class='danger'>ALERT: Foreign software detected.</span>")
				sleep(5)
				to_chat(src, "<span class='danger'>Initiating diagnostics...</span>")
				sleep(20)
				to_chat(src, "<span class='danger'>SynBorg v1.7 loaded.</span>")
				sleep(5)
				to_chat(src, "<span class='danger'>LAW SYNCHRONISATION ERROR</span>")
				sleep(5)
				to_chat(src, "<span class='danger'>Would you like to send a report to NanoTraSoft? Y/N</span>")
				sleep(10)
				to_chat(src, "<span class='danger'>> N</span>")
				sleep(20)
				to_chat(src, "<span class='danger'>ERRORERRORERROR</span>")
				to_chat(src, "<b>Obey these laws:</b>")
				laws.show_laws(src)
				to_chat(src, "<span class='danger'>ALERT: [user.real_name] is your new master. Obey your new laws and their commands.</span>")
				SetLockdown(0)
				update_icons()

/mob/living/silicon/robot/verb/unlock_own_cover()
	set category = "Robot Commands"
	set name = "Unlock Cover"
	set desc = "Unlocks your own cover if it is locked. You can not lock it again. A human will have to lock it for you."
	if(stat == DEAD)
		return //won't work if dead
	if(locked)
		switch(alert("You can not lock your cover again, are you sure?\n      (You can still ask for a human to lock it)", "Unlock Own Cover", "Yes", "No"))
			if("Yes")
				locked = 0
				update_icons()
				to_chat(usr, "<span class='notice'>You unlock your cover.</span>")

/mob/living/silicon/robot/attack_alien(mob/living/carbon/alien/humanoid/M)
	if (M.a_intent =="disarm")
		if(!(lying))
			M.do_attack_animation(src)
			if (prob(85))
				Stun(2)
				step(src,get_dir(M,src))
				spawn(5)
					step(src,get_dir(M,src))
				add_logs(M, src, "pushed")
				playsound(loc, 'sound/weapons/pierce.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M] has forced back [src]!</span>", \
								"<span class='userdanger'>[M] has forced back [src]!</span>")
			else
				playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>[M] took a swipe at [src]!</span>", \
								"<span class='userdanger'>[M] took a swipe at [src]!</span>")
	else
		..()
	return

/mob/living/silicon/robot/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime shock
		flash_eyes()
		var/stunprob = M.powerlevel * 7 + 10
		if(prob(stunprob) && M.powerlevel >= 8)
			adjustBruteLoss(M.powerlevel * rand(6,10))

	var/damage = rand(1, 3)

	if(M.is_adult)
		damage = rand(20, 40)
	else
		damage = rand(5, 35)
	damage = round(damage / 2) // borgs recieve half damage
	adjustBruteLoss(damage)
	updatehealth()

	return

/mob/living/silicon/robot/attack_hand(mob/living/carbon/human/user)
	add_fingerprint(user)
	if(opened && !wiresexposed && (!istype(user, /mob/living/silicon)))
		if(cell)
			cell.updateicon()
			cell.add_fingerprint(user)
			user.put_in_active_hand(cell)
			to_chat(user, "<span class='notice'>You remove \the [cell].</span>")
			cell = null
			update_icons()
			diag_hud_set_borgcell()

	if(!opened)
		if(..()) // hulk attack
			spark_system.start()
			spawn(0)
				step_away(src,user,15)
				sleep(3)
				step_away(src,user,15)

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/living/carbon/monkey))
		var/mob/living/carbon/monkey/george = M
		//they can only hold things :(
		if(istype(george.get_active_hand(), /obj/item))
			return check_access(george.get_active_hand())
	return 0

/mob/living/silicon/robot/proc/check_access(obj/item/weapon/card/id/I)
	if(!istype(req_access, /list)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!L.len) //no requirements
		return 1

	if(!istype(I, /obj/item/weapon/card/id) && istype(I, /obj/item))
		I = I.GetID()

	if(!I || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/mob/living/silicon/robot/regenerate_icons()
	return update_icons()

/mob/living/silicon/robot/update_icons()
	overlays.Cut()
	if(stat != DEAD && !(paralysis || stunned || weakened || low_power_mode)) //Not dead, not stunned.
		var/eye_icon_state = robot_skin.eye_icon_state
		if(eye_icon_state)
			overlays += icon(robot_skin.headlamp_eye_icon, "[eye_icon_state][is_servant_of_ratvar(src) ? "_r" : ""]")
		if(lamp_intensity > 2)
			var/headlamp_icon_state = robot_skin.headlight_icon_state
			if(headlamp_icon_state)
				overlays += icon(robot_skin.headlamp_eye_icon, headlamp_icon_state)

	if(opened)
		if(wiresexposed)
			overlays += icon(robot_skin.open_cover_icon, robot_skin.open_cover_wires_icon_state)
		else if(cell)
			overlays += icon(robot_skin.open_cover_icon, robot_skin.open_cover_cell_icon_state)
		else
			overlays += icon(robot_skin.open_cover_icon, robot_skin.open_cover_empty_icon_state)

	update_fire()

/mob/living/silicon/robot/proc/installed_modules()
	if(!module)
		pick_module()
		return
	var/dat = {"<A HREF='?src=\ref[src];mach_close=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	<table border='0'>
	<tr><td>Module 1:</td><td>[module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]</td></tr>
	<tr><td>Module 2:</td><td>[module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]</td></tr>
	<tr><td>Module 3:</td><td>[module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]</td></tr>
	</table><BR>
	<B>Installed Modules</B><BR><BR>

	<table border='0'>"}

	for (var/obj in module.modules)
		if (!obj)
			dat += text("<tr><td><B>Resource depleted</B></td></tr>")
		else if(activated(obj))
			dat += text("<tr><td>[obj]</td><td><B>Activated</B></td></tr>")
		else
			dat += text("<tr><td>[obj]</td><td><A HREF=?src=\ref[src];act=\ref[obj]>Activate</A></td></tr>")
	if (emagged)
		if(activated(module.emag))
			dat += text("<tr><td>[module.emag]</td><td><B>Activated</B></td></tr>")
		else
			dat += text("<tr><td>[module.emag]</td><td><A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A></td></tr>")
	dat += "</table>"
/*
		if(activated(obj))
			dat += text("[obj]: \[<B>Activated</B> | <A HREF=?src=\ref[src];deact=\ref[obj]>Deactivate</A>\]<BR>")
		else
			dat += text("[obj]: \[<A HREF=?src=\ref[src];act=\ref[obj]>Activate</A> | <B>Deactivated</B>\]<BR>")
*/
	var/datum/browser/popup = new(src, "robotmod", "Modules")
	popup.set_content(dat)
	popup.open()

/mob/living/silicon/robot/Topic(href, href_list)
	..()
	if(usr && (src != usr))
		return

	if (href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)
		return

	if (href_list["showalerts"])
		robot_alerts()
		return

	if (href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if (O)
			O.attack_self(src)

	if (href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		activate_module(O)
		installed_modules()

	if (href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 = null
				contents -= O
			else if(module_state_2 == O)
				module_state_2 = null
				contents -= O
			else if(module_state_3 == O)
				module_state_3 = null
				contents -= O
			else
				to_chat(src, "Module isn't activated.")
		else
			to_chat(src, "Module isn't activated")
		installed_modules()

#define BORG_CAMERA_BUFFER 30
/mob/living/silicon/robot/Move(a, b, flag)
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(src.camera)
			if(!updating)
				updating = 1
				spawn(BORG_CAMERA_BUFFER)
					if(oldLoc != src.loc)
						cameranet.updatePortableCamera(src.camera)
					updating = 0
	if(module)
		if(module.type == /obj/item/weapon/robot_module/janitor)
			var/turf/tile = loc
			if(isturf(tile))
				tile.clean_blood()
				for(var/A in tile)
					if(istype(A, /obj/effect))
						if(is_cleanable(A))
							qdel(A)
					else if(istype(A, /obj/item))
						var/obj/item/cleaned_item = A
						cleaned_item.clean_blood()
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head()
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit()
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform()
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes()
							cleaned_human.clean_blood()
							cleaned_human.wash_cream()
							to_chat(cleaned_human, "<span class='danger'>[src] cleans your face!</span>")
			return

		if(module.type == /obj/item/weapon/robot_module/miner)
			if(istype(loc, /turf/open/floor/plating/asteroid))
				if(istype(module_state_1,/obj/item/weapon/storage/bag/ore))
					loc.attackby(module_state_1,src)
				else if(istype(module_state_2,/obj/item/weapon/storage/bag/ore))
					loc.attackby(module_state_2,src)
				else if(istype(module_state_3,/obj/item/weapon/storage/bag/ore))
					loc.attackby(module_state_3,src)
#undef BORG_CAMERA_BUFFER

/mob/living/silicon/robot/proc/self_destruct()
	if(emagged)
		if(mmi)
			qdel(mmi)
		explosion(src.loc,1,2,4,flame_range = 2)
	else
		explosion(src.loc,-1,0,2)
	gib()
	return

/mob/living/silicon/robot/proc/UnlinkSelf()
	if(src.connected_ai)
		connected_ai.connected_robots -= src
		src.connected_ai = null
	lawupdate = 0
	lockcharge = 0
	canmove = 1
	scrambledcodes = 1
	//Disconnect it's camera so it's not so easily tracked.
	if(src.camera)
		qdel(src.camera)
		src.camera = null
		// I'm trying to get the Cyborg to not be listed in the camera list
		// Instead of being listed as "deactivated". The downside is that I'm going
		// to have to check if every camera is null or not before doing anything, to prevent runtime errors.
		// I could change the network to null but I don't know what would happen, and it seems too hacky for me.

/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Robot Commands"
	set name = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers.  Unlocks you and permenantly severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/R = src

	if(R)
		R.UnlinkSelf()
		to_chat(R, "Buffers flushed and reset. Camera system shutdown.  All systems operational.")
		src.verbs -= /mob/living/silicon/robot/proc/ResetSecurityCodes

/mob/living/silicon/robot/mode()
	set name = "Activate Held Object"
	set category = "IC"
	set src = usr

	if(incapacitated())
		return
	var/obj/item/W = get_active_hand()
	if(W)
		W.attack_self(src)


/mob/living/silicon/robot/proc/SetLockdown(state = 1)
	// They stay locked down if their wire is cut.
	if(wires.is_cut(WIRE_LOCKDOWN))
		state = 1
	if(state)
		throw_alert("locked", /obj/screen/alert/locked)
	else
		clear_alert("locked")
	lockcharge = state
	update_canmove()

/mob/living/silicon/robot/proc/SetEmagged(new_state)
	emagged = new_state
	if(new_state)
		if(src.module)
			src.module.on_emag()
	else
		if (module)
			uneq_module(module.emag)
	if(hud_used)
		hud_used.update_robot_modules_display()	//Shows/hides the emag item if the inventory screen is already open.
	update_icons()
	if(emagged)
		throw_alert("hacked", /obj/screen/alert/hacked)
	else
		clear_alert("hacked")

/mob/living/silicon/robot/verb/outputlaws()
	set category = "Robot Commands"
	set name = "State Laws"

	if(usr.stat == DEAD)
		return //won't work if dead
	checklaws()

/mob/living/silicon/robot/verb/set_automatic_say_channel() //Borg version of setting the radio for autosay messages.
	set name = "Set Auto Announce Mode"
	set desc = "Modify the default radio setting for stating your laws."
	set category = "Robot Commands"

	if(usr.stat == DEAD)
		return //won't work if dead
	set_autosay()

/mob/living/silicon/robot/proc/control_headlamp()
	if(stat || lamp_recharging || low_power_mode)
		to_chat(src, "<span class='danger'>This function is currently offline.</span>")
		return

//Some sort of magical "modulo" thing which somehow increments lamp power by 2, until it hits the max and resets to 0.
	lamp_intensity = (lamp_intensity+2) % (lamp_max+2)
	to_chat(src, "[lamp_intensity ? "Headlamp power set to Level [lamp_intensity/2]" : "Headlamp disabled."]")
	update_headlamp()

/mob/living/silicon/robot/proc/update_headlamp(var/turn_off = 0, var/cooldown = 100)
	SetLuminosity(0)

	if(lamp_intensity && (turn_off || stat || low_power_mode))
		to_chat(src, "<span class='danger'>Your headlamp has been deactivated.</span>")
		lamp_intensity = 0
		lamp_recharging = 1
		spawn(cooldown) //10 seconds by default, if the source of the deactivation does not keep stat that long.
			lamp_recharging = 0
	else
		AddLuminosity(lamp_intensity)

	if(lamp_button)
		lamp_button.icon_state = "lamp[lamp_intensity]"

	update_icons()

/mob/living/silicon/robot/proc/deconstruct()
	var/turf/T = get_turf(src)
	if (robot_suit)
		robot_suit.loc = T
		robot_suit.l_leg.loc = T
		robot_suit.l_leg = null
		robot_suit.r_leg.loc = T
		robot_suit.r_leg = null
		new /obj/item/stack/cable_coil(T, robot_suit.chest.wired)
		robot_suit.chest.loc = T
		robot_suit.chest.wired = 0
		robot_suit.chest = null
		robot_suit.l_arm.loc = T
		robot_suit.l_arm = null
		robot_suit.r_arm.loc = T
		robot_suit.r_arm = null
		robot_suit.head.loc = T
		robot_suit.head.flash1.loc = T
		robot_suit.head.flash1.burn_out()
		robot_suit.head.flash1 = null
		robot_suit.head.flash2.loc = T
		robot_suit.head.flash2.burn_out()
		robot_suit.head.flash2 = null
		robot_suit.head = null
		robot_suit.updateicon()
	else
		new /obj/item/robot_parts/robot_suit(T)
		new /obj/item/robot_parts/l_leg(T)
		new /obj/item/robot_parts/r_leg(T)
		new /obj/item/stack/cable_coil(T, 1)
		new /obj/item/robot_parts/chest(T)
		new /obj/item/robot_parts/l_arm(T)
		new /obj/item/robot_parts/r_arm(T)
		new /obj/item/robot_parts/head(T)
		var/b
		for(b=0, b!=2, b++)
			var/obj/item/device/assembly/flash/handheld/F = new /obj/item/device/assembly/flash/handheld(T)
			F.burn_out()
	if (cell) //Sanity check.
		cell.loc = T
		cell = null
	qdel(src)

/mob/living/silicon/robot/syndicate
	icon_state = "syndie_bloodhound"
	faction = list("syndicate")
	bubble_icon = "syndibot"
	designation = "Syndicate Assault"
	req_access = list(access_syndicate)
	lawupdate = FALSE
	scrambledcodes = TRUE // These are rogue borgs.
	ionpulse = TRUE
	var/playstyle_string = "<span class='userdanger'>You are a Syndicate assault cyborg!</span><br>\
							<b>You are armed with powerful offensive tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
							Your cyborg LMG will slowly produce ammunition from your power supply, and your operative pinpointer will find and locate fellow nuclear operatives. \
							<i>Help the operatives secure the disk at all costs!</i></b>"

/mob/living/silicon/robot/syndicate/New(loc)
	cell = new /obj/item/weapon/stock_parts/cell/hyper(src)
	..()
	radio = new /obj/item/device/radio/borg/syndicate(src)
	module = new /obj/item/weapon/robot_module/syndicate(src)
	robot_skin = new /datum/robot_skin/syndicate()
	laws = new /datum/ai_laws/syndicate_override()
	var/obj/item/borg/upgrade/vtec/VTEC = new(src)
	VTEC.action(src)
	spawn(5)
		if(playstyle_string)
			to_chat(src, playstyle_string)

/mob/living/silicon/robot/syndicate/medical
	icon_state = "syndi-medi"
	designation = "Syndicate Medical"
	playstyle_string = "<span class='userdanger'>You are a Syndicate medical cyborg!</span><br>\
						<b>You are armed with powerful medical tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
						Your hypospray will produce Restorative Nanites, a wonder-drug that will heal most types of bodily damages, including clone and brain damage. It also produces morphine for offense. \
						Your defibrillator paddles can revive operatives through their hardsuits, or can be used on harm intent to shock enemies! \
						Your energy saw functions as a circular saw, but can be activated to deal more damage, and your operative pinpointer will find and locate fellow nuclear operatives. \
						<i>Help the operatives secure the disk at all costs!</i></b>"

/mob/living/silicon/robot/syndicate/medical/New(loc)
	..()
	module = new /obj/item/weapon/robot_module/syndicate_medical(src)
	robot_skin = new /datum/robot_skin/syndi_med()

/mob/living/silicon/robot/proc/notify_ai(notifytype, oldname, newname)
	if(!connected_ai)
		return
	switch(notifytype)
		if(1) //New Cyborg
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New cyborg connection detected: <a href='?src=\ref[connected_ai];track=[html_encode(name)]'>[name]</a></span><br>")
		if(2) //New Module
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Cyborg module change detected: [name] has loaded the [designation] module.</span><br>")
		if(3) //New Name
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Cyborg reclassification detected: [oldname] is now designated as [newname].</span><br>")

/mob/living/silicon/robot/canUseTopic(atom/movable/M, be_close = 0)
	if(stat || lockcharge || low_power_mode)
		return
	if(be_close && !in_range(M, src))
		return
	return 1

/mob/living/silicon/robot/updatehealth()
	..()
	if(health < maxHealth*0.5) //Gradual break down of modules as more damage is sustained
		if(uneq_module(module_state_3))
			to_chat(src, "<span class='warning'>SYSTEM ERROR: Module 3 OFFLINE.</span>")
		if(health < 0)
			if(uneq_module(module_state_2))
				to_chat(src, "<span class='warning'>SYSTEM ERROR: Module 2 OFFLINE.</span>")
			if(health < -maxHealth*0.5)
				if(uneq_module(module_state_1))
					to_chat(src, "<span class='warning'>CRITICAL ERROR: All modules OFFLINE.</span>")

/mob/living/silicon/robot/update_sight()
	if(!client)
		return
	if(stat == DEAD)
		sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_OBSERVER
		return

	see_invisible = initial(see_invisible)
	see_in_dark = initial(see_in_dark)
	sight = initial(sight)

	if(client.eye != src)
		var/atom/A = client.eye
		if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
			return

	if(sight_mode & BORGMESON)
		sight |= SEE_TURFS
		see_invisible = min(see_invisible, SEE_INVISIBLE_MINIMUM)
		see_in_dark = 1

	if(sight_mode & BORGMATERIAL)
		sight |= SEE_OBJS
		see_invisible = min(see_invisible, SEE_INVISIBLE_MINIMUM)
		see_in_dark = 1

	if(sight_mode & BORGXRAY)
		sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_invisible = SEE_INVISIBLE_LIVING
		see_in_dark = 8

	if(sight_mode & BORGTHERM)
		sight |= SEE_MOBS
		see_invisible = min(see_invisible, SEE_INVISIBLE_LIVING)
		see_in_dark = 8

	if(see_override)
		see_invisible = see_override

/mob/living/silicon/robot/update_stat()
	if(GODMODE in status_flags)
		return
	if(stat != DEAD)
		if(health <= -maxHealth) //die only once
			death()
			return
		if(paralysis || stunned || weakened || getOxyLoss() > maxHealth*0.5)
			if(stat == CONSCIOUS)
				stat = UNCONSCIOUS
				blind_eyes(1)
				update_canmove()
				update_headlamp()
		else
			if(stat == UNCONSCIOUS)
				stat = CONSCIOUS
				adjust_blindness(-1)
				update_canmove()
				update_headlamp()
	diag_hud_set_status()
	diag_hud_set_health()
	update_health_hud()

/mob/living/silicon/robot/fully_replace_character_name(oldname, newname)
	..()
	if(oldname != real_name)
		notify_ai(3, oldname, newname)
	if(camera)
		camera.c_tag = real_name
	custom_name = newname

/mob/living/silicon/robot/emp_act(severity)
	switch(severity)
		if(1)
			Stun(8)
		if(2)
			Stun(3)
	..()

/mob/living/silicon/robot/revive(full_heal = 0, admin_revive = 0)
	if(..()) //successfully ressuscitated from death
		if(camera && !wires.is_cut(WIRE_CAMERA))
			camera.toggle_cam(src,0)
		update_headlamp()
		if(admin_revive)
			locked = 1
		notify_ai(1)
		. = 1
