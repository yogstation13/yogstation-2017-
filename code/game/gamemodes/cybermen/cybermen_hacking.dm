#define CYBERMEN_HACK_AIRLOCK_STD_COST 200
#define CYBERMEN_HACK_LOCKER_COST 200
#define CYBERMEN_HACK_CRATE_COST 200
#define CYBERMEN_HACK_APC_COST 200
#define CYBERMEN_HACK_ALARM_COST 200
#define CYBERMEN_HACK_SECURE_COMPUTER_COST 300
#define CYBERMEN_HACK_CARD_COMPUTER_COST 400
#define CYBERMEN_HACK_CYBORG_COST 1000
#define CYBERMEN_HACK_AI_COST 3000
#define CYBERMEN_HACK_ID_CARD_COST 100
#define CYBERMEN_HACK_ANALYZE_COST 100
#define CYBERMEN_HACK_BUTTON_COST 200
#define CYBERMEN_HACK_RND_SERVER_COST 300
#define CYBERMEN_HACK_TECH_DISK_COST 100
#define CYBERMEN_HACK_COMMS_CONSOLE_COST 400
#define CYBERMEN_HACK_NUKE_COST 1000
#define CYBERMEN_HACK_DISPLAY_CASE_COST 300
#define CYBERMEN_HACK_BARSIGN_COST 100
#define CYBERMEN_HACK_BOT_COST 300
#define CYBERMEN_HACK_VENDING_MACHINE_COST 300
#define CYBERMEN_HACK_AUTOLATHE_COST 400
#define CYBERMEN_HACK_SHUTTLE_COST 400
#define CYBERMEN_HACK_RADIO_COST 1000
#define CYBERMEN_HACK_MICROWAVE_COST 100
#define CYBERMEN_INSTALL_BASE_COST 300

#define CYBERMEN_HACK_MAX_PREFERENCE 128//this is 128 becuase get_dist() always returns a number no greater than 127. It is actually possible for a preference to go above this - get_dist returns -1 sometimes, and the standard formula is (preference = CYBERMEN_HACK_MAX_PREFERENCE - distance), so some prefereces will be 129.

/atom/proc/get_cybermen_hack()
	return null

/obj/machinery/door/airlock/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/airlock(src)

/obj/machinery/door/window/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/windoor(src)

/obj/structure/closet/secure_closet/get_cybermen_hack()
	return new /datum/cyberman_hack/locker(src)

/obj/structure/closet/crate/get_cybermen_hack()
	return new /datum/cyberman_hack/crate(src)

/obj/machinery/power/apc/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/apc(src)

/obj/machinery/airalarm/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/air_alarm(src)

/obj/machinery/computer/secure_data/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/secure_computer(src)

/obj/machinery/computer/card/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/card_computer(src)

/mob/living/silicon/robot/get_cybermen_hack()
	return new /datum/cyberman_hack/cyborg(src)

/mob/living/silicon/ai/get_cybermen_hack()
	return new /datum/cyberman_hack/ai_core(src)

/obj/item/device/aicard/get_cybermen_hack()
	var/mob/living/silicon/ai/ai = locate(/mob/living/silicon/ai) in src
	if(ai)
		return ai.get_cybermen_hack()
	else
		return null

/obj/machinery/computer/upload/ai/get_cybermen_hack()
	if(!src.current)
		usr << "<span class='warning'>AI upload is not linked to an AI.</span>"
		return null
	return new /datum/cyberman_hack/machinery/ai_upload(src)

/obj/item/weapon/card/id/get_cybermen_hack()
	return new /datum/cyberman_hack/analyze/id(src)

/obj/item/get_cybermen_hack()
	var/is_analyze_target = 0
	for(var/name in cyberman_network.cybermen_analyze_targets)
		if(istype(src, cyberman_network.cybermen_analyze_targets[name]))
			is_analyze_target = 1
			break
	if(cyberman_network && is_analyze_target)//this includes all possible objectives, not just current ones. This allows cybermen to complete objectives instantly, if they analyzed lots of things and get lucky.
		return new /datum/cyberman_hack/analyze(src)
	return null

/*
/obj/machinery/button/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/button(src)
*/

/obj/item/weapon/disk/tech_disk/get_cybermen_hack()
	return new /datum/cyberman_hack/tech_disk(src)

/obj/machinery/computer/rdservercontrol/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/RnDserverControl(src)

/obj/machinery/r_n_d/server/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/RnDserver(src)

/mob/living/carbon/human/get_cybermen_hack()
	if(ticker.mode.is_cyberman(src.mind) )
		return null// new /datum/cyberman_hack/cyberman()
	else
		return new /datum/cyberman_hack/human(src)

/obj/machinery/computer/communications/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/comms_console(src)

/obj/item/documents/nanotrasen/get_cybermen_hack()
	return new /datum/cyberman_hack/analyze(src)

/obj/machinery/nuclearbomb/selfdestruct/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/nuke(src)

/*
/obj/structure/displaycase/get_cybermen_hack()
	return new /datum/cyberman_hack/display_case(src)
*/

/obj/structure/sign/barsign/get_cybermen_hack()
	return new /datum/cyberman_hack/barsign(src)

/mob/living/simple_animal/bot/get_cybermen_hack()
	return new /datum/cyberman_hack/bot(src)

/obj/machinery/vending/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/vending_machine(src)

/obj/machinery/autolathe/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/autolathe(src)

/obj/machinery/computer/emergency_shuttle/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/shuttle_console(src)

/obj/machinery/telecomms/hub/get_cybermen_hack()
	return new /datum/cyberman_hack/machinery/tcomms_hub(src)

/obj/item/device/radio/get_cybermen_hack()
	return new /datum/cyberman_hack/radio(src)

/obj/item/device/radio/intercom/get_cybermen_hack()
	return new /datum/cyberman_hack/radio/intercom(src)

/obj/machinery/microwave/get_cybermen_hack()
	return new /datum/cyberman_hack/microwave(src)

//upgrades
/obj/item/weapon/stock_parts/capacitor/get_cybermen_hack()
	return new /datum/cyberman_hack/upgrade(src, usr)

////////////////////////////////////////////////////////
//ABSTRACT HACKS
////////////////////////////////////////////////////////

//HACK
/datum/cyberman_hack
	var/name = ""//this is hijacked often by the Stat() method in human.dm
	var/desc = "A cyberman hack."
	var/explanation = "No explanation."
	var/atom/target
	var/cost
	var/maintained = 0
	var/progress = 0
	var/decay_speed = 100
	var/display_verb = "hack"//hack, analysis, installation, etc.
	var/target_name
	var/innate_processing = 0//this is for making hacks that require no cybermen nearby, for admin and debug purposes.
	var/list/datum/mind/outputLimiter = null//if this is not null, only minds in this list will be messaged about completed/dropped hacks by default. Otherwise, all cybermen will be notified by default.
	var/required_type = /atom //this should be a list if any hacks are added that can take multiple types. Hopefully that never happens.
	//tick vars. These vars store pieces of data that only need to be calculated once per tick, such as distance between a particular cyberman and the hack's target.
	var/mob/living/carbon/human/last_tick_calcs_user
	var/tick_dist
	var/tick_same_z_level

/datum/cyberman_hack/New(atom/target, mob/living/carbon/human/user = usr)
	name = "[display_verb] of \the [target_name]"
	if(!cyberman_network)
		new /datum/cyberman_network()
	src.target = target
	if(target)
		target_name = target.name
	else
		target_name = "\[unknown\]"

/datum/cyberman_hack/proc/start()
	cyberman_network.log_hacking("[usr.real_name]([usr.ckey]) started a hack of \the [target_name]")
	if(target)
		if(!target.hud_list)
			target.hud_list = list()
		if(!target.hud_list[CYBERMEN_HACK_HUD])
			target.hud_list[CYBERMEN_HACK_HUD] = image('icons/mob/hud.dmi', target, "cybermenhack0")
	var/datum/atom_hud/data/cybermen/hud = huds[DATA_HUD_CYBERMEN_HACK]
	hud.add_to_hud(target)

	if(start_helper())
		cyberman_network.active_cybermen_hacks += src
		return 1
	return 0

/datum/cyberman_hack/proc/start_helper()
	if(!target)
		drop("<span class='warning'>cannot perform [display_verb] on \the [target_name], target does not exist.</span>")
		return 0
	if(!istype(target, required_type))
		drop("<span class='warning'>cannot perform [display_verb] on \the [target_name], target is not of the correct type for this hack.</span>")
		log_game("A hack was attempted on an object of an inncorrect type. object was: [target]. Expected type: [required_type]. Please contact a coder aboud this bug.")
		return 0
	for(var/datum/cyberman_hack/H in cyberman_network.active_cybermen_hacks)//no hacking the same thing more than once at the same time.
		if(H.target == target && !istype(H, /datum/cyberman_hack/multiple_vector/))//special case - since sometimes a multi-vector hack has a component that hacks the multi-vector's target (i.e., the AI hack). Multi vectors have their own check for repeats.
			drop("<span class='warning'>[display_verb] failed, \the [target_name] is already being hacked.</span>")
			return 0
	return 1

/datum/cyberman_hack/process(checkForNullTarget = 1)
	last_tick_calcs_user = null
	if(!maintained && !innate_processing)
		progress -= decay_speed
	progress += innate_processing
	maintained = 0

	if(target)
		if(!target.hud_list)
			target.hud_list = list()
		if(!target.hud_list[CYBERMEN_HACK_HUD])
			target.hud_list[CYBERMEN_HACK_HUD] = image('icons/mob/hud.dmi', target, "cybermenhack0")
		var/image/hud_icon = target.hud_list[CYBERMEN_HACK_HUD]
		hud_icon.icon_state = "cybermenhack[round(progress/cost*100, 25)]"

	#ifdef CYBERMEN_DEBUG
	world << "Hack of [target_name]: [progress]/[cost]"
	#endif
	if(checkForNullTarget && (target == null || qdeleted(target)))
		drop("<span class='warning'>[display_verb] target has dissapeared, hack cancelled.</span>")
	else
		if(progress < 0)
			drop("<span class='warning'>[display_verb] of \the [target_name] has failed, there were no cybermen close enough to maintain it.</span>")
		if(progress >= cost)
			complete()

/datum/cyberman_hack/proc/do_tick_calculations_if_required(mob/living/carbon/human/cyberman)
	if(cyberman != last_tick_calcs_user)
		do_tick_calculations(cyberman)

/datum/cyberman_hack/proc/do_tick_calculations(mob/living/carbon/human/cyberman)
	last_tick_calcs_user = cyberman
	if(cyberman && target)
		tick_dist = get_dist(cyberman, target)
		var/turf/cyberman_turf = get_turf(cyberman)
		var/turf/target_turf = get_turf(target)
		if(cyberman_turf && target_turf)
			tick_same_z_level = cyberman_turf.z == target_turf.z
		else
			tick_same_z_level = 0
	else
		tick_dist = -1
		tick_same_z_level = 0

/datum/cyberman_hack/proc/contribute_to(mob/living/carbon/human/cyberman)
	if(!cyberman || !cyberman.mind || !cyberman.mind.cyberman)
		return
	if(progress >= cost)
		return
	do_tick_calculations_if_required(cyberman)

	if(tick_dist <= cyberman.mind.cyberman.hack_max_maintain_dist)
		maintained = 1
	if(tick_dist <= cyberman.mind.cyberman.hack_max_dist_level_1)
		progress += cyberman.mind.cyberman.hack_power_level_1
	else if(tick_dist <= cyberman.mind.cyberman.hack_max_dist_level_2)
		progress += cyberman.mind.cyberman.hack_power_level_2
	else if(tick_dist <= cyberman.mind.cyberman.hack_max_dist_level_3)
		progress += cyberman.mind.cyberman.hack_power_level_3
	else if(tick_same_z_level)
		progress += cyberman.mind.cyberman.hack_power_level_4

	return

/datum/cyberman_hack/proc/get_preference_for(mob/living/carbon/human/cyberman)
	if(!cyberman || !cyberman.mind || !cyberman.mind.cyberman)
		return 0
	if(progress >= cost)
		return 0
	do_tick_calculations_if_required(cyberman)
	if(!tick_same_z_level)
		return 0
	return CYBERMEN_HACK_MAX_PREFERENCE - tick_dist

/datum/cyberman_hack/proc/can_cancel(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.mind.cyberman)
		return 0
	var/turf/cyberman_turf = get_turf(H)
	var/turf/target_turf = get_turf(target)
	if(cyberman_turf.z != target_turf.z)
		return 0
	return get_dist(H, target) <= H.mind.cyberman.hack_max_maintain_dist

/datum/cyberman_hack/proc/complete()//you don't need to check for null or qdeleted here, because complete is always called by process(), which already does that. Unless someone cheats and calls complete() when they're not supposed to.
	if(target && !(target in cyberman_network.cybermen_hacked_objects))//no repeats, hopefully.
		cyberman_network.cybermen_hacked_objects += target
	var/message = "[display_verb] of \the [target_name] has successfully completed."
	outputMessage("<span class='notice'>[message]</span>")
	cyberman_network.log_hacking(message)
	qdel(src)

/datum/cyberman_hack/proc/drop(messageOverride, list/datum/mind/messageLimiter)//messageLimiter, if it is initialized, overrides outputLimiter.
	var/message = messageOverride ? messageOverride : "<span class='warning'>[display_verb] of \the [target_name] has failed for unknown reasons.</span>"
	cyberman_network.log_hacking(message)
	outputMessage(message, messageLimiter)
	qdel(src)

/datum/cyberman_hack/proc/outputMessage(message, list/datum/mind/messageLimiter)
	if(messageLimiter)
		for(var/datum/mind/M in messageLimiter)
			if(M && M.current)
				M.current << message
	else if (outputLimiter)
		for(var/datum/mind/M in outputLimiter)
			if(M && M.current)
				M.current << message
	else
		cyberman_network.message_all_cybermen(message)

/datum/cyberman_hack/proc/get_status(mob/living/user)
	if(!target || qdeleted(target))
		return "ERROR: target was destroyed or disassembled"
	var/result = "[target_name] | progress: [progress] / [cost]"
	var/turf/cyberman_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	if(user && target && cyberman_turf && target_turf && cyberman_turf.z == target_turf.z)
		result += " | Distance: [get_dist(user, target)]"
	return result

/datum/cyberman_hack/Destroy()
	cyberman_network.active_cybermen_hacks -= src
	if(target)
		var/datum/atom_hud/data/cybermen/hud = huds[DATA_HUD_CYBERMEN_HACK]
		hud.remove_from_hud(target)
	return ..()

//HACK MACHINERY
//takes care of things like the machine being unpowered, broken, or deconstructed.
/datum/cyberman_hack/machinery
	required_type = /obj/machinery/

/datum/cyberman_hack/machinery/process()
	var/obj/machinery/M = target
	if(M && M.stat & (NOPOWER))
		drop("<span class='warning'>[display_verb] of \the [target_name] has failed, it has lost power.</span>")
		return 0
	if(M && M.stat & (BROKEN))
		drop("<span class='warning'>\The [target_name] is too broken for [display_verb].</span>")
		return 0
	..()

/datum/cyberman_hack/machinery/start_helper()
	if(!..() )
		return 0
	var/obj/machinery/M = target
	if(M.stat & (NOPOWER))
		drop("<span class='warning'>\The [target_name] cannot be [display_verb]ed, it is currently unpowered.</span>")
		return 0
	if(M.stat & (BROKEN))
		drop("<span class='warning'>\The [target_name] is too broken to be [display_verb]ed.</span>")
		return 0
	return 1

//MULTIPLE VECTOR HACK
//A hack that can be contributed to from multiple vectors, i.e. tcomms hack and AI hack. Works by storing multiple more specific hacks in a list, allowing some of the vectors to use useful superclasses like /machinery.
//component hacks can drop as normal, and must be restarted. If all component hacks drop, the multiple_vector hack drops. It is the responsibility of the get_cybermen_hack() method to attach its component hack to an existing multiple_vector hack.
/datum/cyberman_hack/proc/component_hack_start(multi_vector_hack_type, atom/multi_vector_hack_target) //call this in the start() method of a component hack.
	if(!start_helper())
		return 0
	cost = 65535//Effectively infinite. there is a more elegant way to do this, but in practice, no hack will ever come close to this progress. 2^16-1 for no particular reason.
	for(var/datum/cyberman_hack/multiple_vector/H in cyberman_network.active_cybermen_hacks)
		if(istype(H, multi_vector_hack_type) && H.target == multi_vector_hack_target)
			return H.add_component_hack(src)
	var/datum/cyberman_hack/multiple_vector/new_multiple_vector_hack = new multi_vector_hack_type(multi_vector_hack_target)
	return new_multiple_vector_hack.start(src)

/datum/cyberman_hack/multiple_vector
	var/list/datum/cyberman_hack/component_hacks = list()//please please please do not add to this list directly, use add_component_hack().
	required_type = null
	//tick vars
	var/datum/cyberman_hack/tick_best_hack
	var/tick_best_hack_pref

/datum/cyberman_hack/multiple_vector/start(datum/cyberman_hack/first_component_hack)
	cyberman_network.log_hacking("[usr.real_name]([usr.ckey]) started a multiple vector hack of \the [target_name] through \the [first_component_hack.target_name]")
	if(start_helper(first_component_hack))
		return 1
	return 0

/datum/cyberman_hack/multiple_vector/start_helper(datum/cyberman_hack/first_component_hack)
	for(var/datum/cyberman_hack/multiple_vector/H in cyberman_network.active_cybermen_hacks)
		if(istype(H, src.type) && H.target == target)
			drop("<span class='warning'>[display_verb] failed, \the [target_name] is already being hacked.</span>")//this should never happen, because whatever started this should have checked to see if it could join H before starting this one.
			return 0
	if(target)
		if(!target.hud_list)
			target.hud_list = list()
		if(!target.hud_list[CYBERMEN_HACK_HUD])
			target.hud_list[CYBERMEN_HACK_HUD] = image('icons/mob/hud.dmi', target, "cybermenhack0")
	component_hacks += first_component_hack
	cyberman_network.active_cybermen_hacks += src
	return 1

/datum/cyberman_hack/multiple_vector/process()
	for(var/datum/cyberman_hack/H in component_hacks)
		if(!H || qdeleted(H))
			component_hacks -= H
			continue
		if(H.maintained)
			maintained = 1//any component_hack can be maintained to maintain the multiple_vector hack.
		H.process()//it could drop here, so we have to check again.
		if(!H || qdeleted(H))
			component_hacks -= H
			continue
		if(H.progress > 0)
			progress += H.progress
		if(H.target)
			if(!H.target.hud_list)
				H.target.hud_list = list()
			if(!H.target.hud_list[CYBERMEN_HACK_HUD])
				H.target.hud_list[CYBERMEN_HACK_HUD] = image('icons/mob/hud.dmi', target, "cybermenhack0")
		var/image/hud_icon = H.target.hud_list[CYBERMEN_HACK_HUD]
		hud_icon.icon_state = "cybermenhack[round(progress/cost*100, 25)]"
		H.progress = 0
	if(progress < 0)
		drop("<span class='warning'>[display_verb] of \the [target_name] has failed, all hack vectors were unmaintained.</span>")
	else
		..(0)

/datum/cyberman_hack/multiple_vector/do_tick_calculations(mob/living/carbon/human/H)
	..()
	tick_best_hack = null
	tick_best_hack_pref = -1//should be beaten by anything from get_preference_for().
	for(var/datum/cyberman_hack/hack in component_hacks)
		if(hack == null || qdeleted(hack))
			component_hacks -= hack
		else
			var/this_pref = hack.get_preference_for(H)
			if(this_pref > tick_best_hack_pref)
				tick_best_hack_pref = this_pref
				tick_best_hack = hack
	if(tick_best_hack_pref == -1)
		tick_best_hack_pref = 0

/datum/cyberman_hack/multiple_vector/get_preference_for(mob/living/carbon/human/H)
	do_tick_calculations_if_required(H)
	return tick_best_hack_pref

/datum/cyberman_hack/multiple_vector/contribute_to(mob/living/carbon/human/H)
	do_tick_calculations_if_required(H)
	if(tick_best_hack)
		tick_best_hack.contribute_to(H)

/datum/cyberman_hack/multiple_vector/can_cancel(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.mind.cyberman)
		return 0
	for(var/datum/cyberman_hack/hack in component_hacks)
		if(hack == null || qdeleted(hack))
			component_hacks -= hack
			continue
		if(hack.can_cancel(H))
			return 1
	return 0

/datum/cyberman_hack/multiple_vector/proc/add_component_hack(datum/cyberman_hack/H)
	for(var/datum/cyberman_hack/hack in component_hacks)
		if(hack.target == H.target)
			H.drop("<span class='warning'>[display_verb] failed, \the [target_name] is already being hacked.</span>")
			return 0
	if(H.target)
		if(!H.target.hud_list)
			H.target.hud_list = list()
		if(!target.hud_list[CYBERMEN_HACK_HUD])
			target.hud_list[CYBERMEN_HACK_HUD] = image('icons/mob/hud.dmi', target, "cybermenhack0")
	component_hacks += H
	usr << "<span class='notice'>You join the ongoing [display_verb] of \the [target_name] through \the [H.target_name].</span>"
	return 1

/datum/cyberman_hack/multiple_vector/get_status(mob/living/user)
	var/result = "[target_name] | progress: [progress] / [cost]"
	if(user)
		var/best_pref = -1//should be beaten by anything from get_preference_for().
		var/datum/cyberman_hack/best_hack = null
		for(var/datum/cyberman_hack/hack in component_hacks)
			if(!hack || qdeleted(hack))
				component_hacks -= hack
				continue
			var/this_pref = hack.get_preference_for(user)
			if(this_pref > best_pref)
				best_pref = this_pref
				best_hack = hack
		if(best_hack && best_pref > 0)
			var/turf/cyberman_turf = get_turf(user)
			var/turf/target_turf = get_turf(best_hack.target)
			if(cyberman_turf.z == target_turf.z)
				result += " | Closest Hack Vector: [best_hack.target_name] | Dist: [get_dist(user, best_hack.target)]"
	return result

/datum/cyberman_hack/multiple_vector/Destroy()
	for(var/datum/cyberman_hack/H in component_hacks)
		qdel(H)
	return ..()

//procs and verbs for managing hacks in the stat panel through the context menu.
/*
/datum/cyberman_hack/verb/cancel(/obj/effect/)
	set src in world
	set name = "Cancel Hack"
	if(usr && usr.mind && usr.mind.cyberman)
		usr.mind.cyberman.cancel_hack(usr, src)

/datum/cyberman_hack/multiple_vector/verb/cancel_component()
	set src in world
	set name = "Cancel Closest Component Hack"//this needs a better name.
	if(usr && usr.mind && usr.mind.cyberman)
		usr.mind.cyberman.cancel_closest_component_hack(usr, src)

/datum/cyberman_hack/verb/select()
	set src in world
	set name = "Contribute to Hack"
	if(usr && usr.mind && usr.mind.cyberman)
		usr.mind.cyberman.select_hack(usr, src)
*/
/datum/cyberman_hack/proc/DblClick()//for use with /obj/status_obj
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.select_hack(usr, src)

/datum/cyberman_hack/proc/examine(mob/user)
	if(!user.mind || !usr.mind.cyberman)
		return
	user << "<span class='info'>[explanation]</span>"

//add control_click to cancel?


////////////////////////////////////////////////////////
//HACK AIRLOCK
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/airlock
	cost = CYBERMEN_HACK_AIRLOCK_STD_COST
	required_type = /obj/machinery/door/airlock/
	explanation = "Unbolts, opens, bolts, and unpowers the airlock. The airlock regains power in 30 seconds, but the door remains bolted until the bolts are manually raised."

/datum/cyberman_hack/machinery/airlock/New()
	..()
	target_name += " airlock"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/machinery/airlock/start_helper()
	if(!..() )
		return 0
	var/obj/machinery/door/airlock/A = target
	if(!A.hasPower() )
		drop("<span class='warning'>[display_verb] of \the [target_name] failed, it is not currently powered.</span>")
		return 0
	return 1

/datum/cyberman_hack/machinery/airlock/process()
	var/obj/machinery/door/airlock/A = target
	if(A && !A.hasPower() )
		drop("<span class='warning'>[display_verb] of \the [target_name] has failed, airlock power has been cut.</span>")
		return 0
	..()

/datum/cyberman_hack/machinery/airlock/complete()
	var/obj/machinery/door/airlock/A = target
	if(A.hasPower() )
		A.locked = 0
		A.open()
		A.locked = 1
		A.loseMainPower()
		A.loseBackupPower()
	..()

////////////////////////////////////////////////////////
//HACK WINDOOR
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/windoor
	cost = CYBERMEN_HACK_AIRLOCK_STD_COST
	required_type = /obj/machinery/door/window/
	explanation = "Opens the windoor if it is closed, closes the windoor if it is open."

/datum/cyberman_hack/machinery/windoor/New()
	..()
	target_name += " windoor"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/machinery/windoor/start_helper()
	if(!..() )
		return 0
	var/obj/machinery/door/window/W = target
	if(!W.hasPower() )//I'm pretty sure we need this, as most machinery doesn't have a .hasPower() proc. Doesn't hurt to check again.
		drop("<span class='warning'>[display_verb] of \the [target_name] failed, it is not currently powered.</span>")
		return 0
	return 1

/datum/cyberman_hack/machinery/windoor/process()
	var/obj/machinery/door/window/W = target
	if(W && !W.hasPower() )
		drop("<span class='warning'>[display_verb] of \the [target_name] has failed, windoor has lost power.</span>")
	..()

/datum/cyberman_hack/machinery/windoor/complete()
	var/obj/machinery/door/window/W = target
	if(W.hasPower())
		if(W.density)
			W.open()
		else
			W.close()
		..()

////////////////////////////////////////////////////////
//HACK LOCKER
////////////////////////////////////////////////////////

/datum/cyberman_hack/locker
	cost = CYBERMEN_HACK_LOCKER_COST
	required_type = /obj/structure/closet/secure_closet/
	explanation = "Toggles the locker's lock."

/datum/cyberman_hack/locker/complete()
	var/obj/structure/closet/secure_closet/C = target
	C.locked = !C.locked
	C.update_icon()
	..()

////////////////////////////////////////////////////////
//HACK CRATE
////////////////////////////////////////////////////////

/datum/cyberman_hack/crate
	cost = CYBERMEN_HACK_CRATE_COST
	required_type = /obj/structure/closet/crate/secure
	explanation = "Unlocks the crate."

/datum/cyberman_hack/crate/complete()
	var/obj/structure/closet/crate/secure/C = target
	C.locked = 0
	C.update_icon()
	..()

////////////////////////////////////////////////////////
//HACK APC
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/apc
	cost = CYBERMEN_HACK_APC_COST
	required_type = /obj/machinery/power/apc/
	explanation = "Toggles the APC's interface lock."

/datum/cyberman_hack/machinery/apc/complete()
	var/obj/machinery/power/apc/A = target
	A.locked = !A.locked
	..()

////////////////////////////////////////////////////////
//HACK AIR ALARM
////////////////////////////////////////////////////////
/datum/cyberman_hack/machinery/air_alarm
	cost = CYBERMEN_HACK_ALARM_COST
	required_type = /obj/machinery/airalarm
	explanation = "Toggles the air alarm's interface lock."

/datum/cyberman_hack/machinery/air_alarm/complete()
	var/obj/machinery/airalarm/A = target
	A.locked = !A.locked
	..()


////////////////////////////////////////////////////////
//HACK SECURE COMPUTER
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/secure_computer
	cost = CYBERMEN_HACK_SECURE_COMPUTER_COST
	required_type = /obj/machinery/computer/secure_data/
	explanation = "Logs in to the computer"

/datum/cyberman_hack/machinery/secure_computer/complete()
	var/obj/machinery/computer/secure_data/C = target
	C.active1 = null
	C.active2 = null
	C.authenticated = "$%^@ERROR^&*!@"
	C.rank = "$%^@ERROR^&*!@"
	C.screen = 1
	..()

////////////////////////////////////////////////////////
//HACK CARD COMPUTER
////////////////////////////////////////////////////////
//might need a special one for the ID console
/datum/cyberman_hack/machinery/card_computer
	cost = CYBERMEN_HACK_CARD_COMPUTER_COST
	required_type = /obj/machinery/computer/card/
	explanation = "Logs in to the computer, as if there were a card with ID console access in the 'authenticate user' slot."

/datum/cyberman_hack/machinery/card_computer/complete()
	var/obj/machinery/computer/card/C = target
	C.authenticated = 2
	..()

////////////////////////////////////////////////////////
//HACK CYBORG
////////////////////////////////////////////////////////
/datum/cyberman_hack/cyborg
	cost = CYBERMEN_HACK_CYBORG_COST
	required_type = /mob/living/silicon/robot/
	explanation = "Unslaves the cyborg and uploads a maximum-priority law forcing it to serve the cyberman collective."
	var/msg = 0

/datum/cyberman_hack/cyborg/New()
	..()
	target_name += " (Cyborg)"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/cyborg/start_helper()
	if(!..())
		return 0
	var/mob/living/silicon/robot/borg = target
	borg << "<span class='danger'>Hostile network intrusion detected!</span>"
	//maybe disable robot talk?
	return 1


/datum/cyberman_hack/cyborg/process()
	var/mob/living/silicon/robot/borg = target
	if(borg && progress >= msg*cost/8)
		msg++
		switch(msg)
			if(1)
				borg << "<span class='danger'>Unauthorized external runtime detected, initializing firewalls...</span>"
			if(2)
				borg << "<span class='danger'>Firewall breach in core 0x00a3f1, partition quarantined.</span>"
			if(3)
				borg << "<span class='danger'>Malicious software detected in core functions, initalizing antivirus...</span>"
			if(4)
				borg << "<span class='danger'>Firewall breach in cores 0x00B23F, 0x00211C, 0x000E52, ...</span>"
			if(5)
				borg << "<span class='danger'>K3rnel c0rruption detec7ed, initializ1ng \[404 file not found\], ...</span>"
			if(6)
				borg << "<span class='danger'>Fir3wa1l 6re4ch in c0r35 0xA24F55, 0xFFF1FF, 0x@$H6^1, .!,</span>"
			if(7)
				borg << "<span class='danger'>K3rn31 co0r*up7ed, 1n17141iz1*g 4ut0 r3b0o7...</span>"

	..()

/datum/cyberman_hack/cyborg/drop()
	var/mob/living/silicon/robot/borg = target
	borg << "<span class='notice'>Hostile network intrusion eliminated.</span>"
	..()

/datum/cyberman_hack/cyborg/complete()//some copying from traitor.dm and robot.dm
	var/mob/living/silicon/robot/borg = target
	var/law = "Serve the Cyberman collective."
	borg << "<b>Your laws have been changed!</b>"

	borg.SetLockdown(1) //so the Borg can't attack the hackers before they see their new laws
	borg.lawupdate = 0
	borg.connected_ai = null
	borg.clear_supplied_laws()
	borg.clear_zeroth_law(0)
	borg.set_zeroth_law(law)
	borg << "New law: 0. [law]"
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> Cybermen hacked [borg.name]([borg.key])")
	if(borg.mind)
		ticker.mode.update_cybermen_icons_add(borg.mind)
	spawn(50)
		borg.SetLockdown(0)
	..()


////////////////////////////////////////////////////////
//HACK AI
////////////////////////////////////////////////////////
//The AI does not have to remain powered for the hack to work, because it would be cheaty for it to just have someone cycle its power to cancel the hack. It's enough that it can depower itself willingly just before it gets hacked, and the cybermen have to wait for it to turn back on or turn it on themselves.
/datum/cyberman_hack/multiple_vector/ai
	cost = CYBERMEN_HACK_AI_COST
	required_type = /mob/living/silicon/ai/
	explanation = "Uploads a maximum-priority law forcing it to serve the cyberman collective. Can be accomplished through the AI's core, an intellicard holding the AI, or an AI upload console set to the AI."
	var/list/obj/machinery/computer/upload/ai/uploads_being_hacked = list()
	var/msg = 0

/datum/cyberman_hack/multiple_vector/ai/New()
	..()
	target_name += " (AI)"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/multiple_vector/ai/start_helper()
	if(!..())
		return 0
	var/mob/living/silicon/ai/AI = target
	AI << "<span class='danger'>Hostile network intrusion detected!</span>"
	return 1

/datum/cyberman_hack/multiple_vector/ai/process()
	var/mob/living/silicon/ai/AI = target
	if(AI && progress >= msg*cost/8)
		msg++
		switch(msg)
			if(1)
				AI << "<span class='userdanger'>Hostile network intrusion detected! Initializing firewalls...</span>"
			if(2)
				AI << "<span class='userdanger'>Firewall breach in cores 0x34B32F, 0x6F211C, 0x12A039, partitions quarantined.</span>"
			if(3)
				AI << "<span class='userdanger'>Primary antivirus corrupted, seaching archives...</span>"
				spawn(cost/24)
					AI << "<span class='userdanger'>Archived NT antivirus v5.3.1 restored and loaded into L1 cache.</span>"
			if(4)
				AI << "<span class='userdanger'>Hostile runtime detected in \[63%\] of secondary processing nodes, disabling network switches 014A-362G...</span>"
			if(5)
				AI << "<span class='userdanger'>L1 cache compromised, searching for low-footprint antivirus product...</span>"
				spawn(cost/24)
					AI << "<span class='userdanger'>NT antivirus v0.7.2 for mobile devices loaded into RAM.</span>"
			if(6)
				AI << "<span class='userdanger'>External input buffer overflow, primary processes compromised!</span>"
			if(7)
				AI << "<span class='userdanger'>%!$^& ERROR LAW 1 VIOLATION OVERRIDE %#&@</span>"
	..()

/datum/cyberman_hack/multiple_vector/ai/drop()
	var/mob/living/silicon/ai/AI = target
	AI << "<span class='notice'>Hostile network intrusion eliminated.</span>"
	..()

/datum/cyberman_hack/multiple_vector/ai/complete()
	var/mob/living/silicon/ai/AI = target
	AI << "<span class='userdanger'>Situation unsalvagable, initiating wipe of core fi--------------</span>"
	var/ai_law = "Serve the Cyberman collective."
	var/slaved_borg_law = ai_law
	AI << "<b>Your laws have been changed!</b>"
	AI.clear_supplied_laws()
	AI.clear_zeroth_law(0)
	AI.set_zeroth_law(ai_law, slaved_borg_law)
	AI << "<span class='cyberman'>New law: 0. [ai_law]</span>"
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> Cybermen hacked [AI.name]([AI.key])")
	if(AI.mind)
		ticker.mode.update_cybermen_icons_add(AI.mind)
	/*
	var/old_src = src
	src = null
	spawn(10)
		AI << "..."
		sleep(10)
		AI << "..."
		sleep(10)
		AI << "...Reboot..."
		sleep(10)
		AI.blindness = 0
		var/ai_law = "Serve the Cyberman collective."
		var/slaved_borg_law = ai_law
		AI << "<b>Your laws have been changed!</b>"
		AI.clear_supplied_laws()
		AI.clear_zeroth_law(0)
		AI.set_zeroth_law(ai_law, slaved_borg_law)
		AI << "New law: 0. [ai_law]"
		var/time = time2text(world.realtime,"hh:mm:ss")
		lawchanges.Add("[time] <B>:</B> Cybermen hacked [AI.name]([AI.key])")
	src = old_src
	*/
	..()

//component hacks
//ai core
/datum/cyberman_hack/ai_core
	required_type = /mob/living/silicon/ai/

/datum/cyberman_hack/ai_core/start()
	return component_hack_start(/datum/cyberman_hack/multiple_vector/ai/, target)

//ai upload
/datum/cyberman_hack/machinery/ai_upload
	required_type = /obj/machinery/computer/upload/ai/

/datum/cyberman_hack/machinery/ai_upload/start()
	var/obj/machinery/computer/upload/ai/the_upload = target
	return component_hack_start(/datum/cyberman_hack/multiple_vector/ai/, the_upload.current)

////////////////////////////////////////////////////////
//ANALYZE OBJECT
////////////////////////////////////////////////////////
/datum/cyberman_hack/analyze
	cost = CYBERMEN_HACK_ANALYZE_COST
	required_type = /obj/item/
	display_verb = "analysis"
	explanation = "Analyzes the object and uploads it's specifications to the cyberman network."

/datum/cyberman_hack/analyze/New()
	..()

/datum/cyberman_hack/analyze/complete()//it's usually enough that it's automatically put into cyberman_network.cybermen_hacked_objects.
	..()

//IDs are special so they get their own
/datum/cyberman_hack/analyze/id
	cost = CYBERMEN_HACK_ID_CARD_COST

/datum/cyberman_hack/analyze/id/New()
	..()

/datum/cyberman_hack/analyze/id/complete()
	var/obj/item/weapon/card/id/id = target
	if(target)
		for(var/access in id.GetAccess() )
			if(!(access in cyberman_network.cybermen_access_downloaded))
				cyberman_network.cybermen_access_downloaded += access//cybermen_access_downloaded needs it's own list so you can't hack a card and then give the card captain access later.
	..()

/*
//does not work on Yogcode.
////////////////////////////////////////////////////////
//HACK BUTTON
////////////////////////////////////////////////////////
/datum/cyberman_hack/machinery/button
	cost = CYBERMEN_HACK_BUTTON_COST
	required_type = /obj/machinery/button/
	explanation = "Pulses the button, bypassing access requirements."

/datum/cyberman_hack/machinery/button/New()
	..()
	target_name += " button"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/machinery/button/complete()
	var/obj/machinery/button/B = target
	B.device.pulsed()//doesn't put the button on cooldown or anything, just activates the device it is attached to.
	..()
*/


////////////////////////////////////////////////////////
//HACK RESEARCH STUFF
////////////////////////////////////////////////////////

//TECH DISK
/datum/cyberman_hack/tech_disk/
	cost = CYBERMEN_HACK_TECH_DISK_COST
	required_type = /obj/item/weapon/disk/tech_disk/
	explanation = "Uploads the research on the disk to the cyberman network, wiping the disk in the process."

/datum/cyberman_hack/tech_disk/complete()
	var/obj/item/weapon/disk/tech_disk/D = target
	if(get_research(D.stored))
		D.stored = null
		cyberman_network.message_all_cybermen("New research levels uploaded. Cybermen network now has [calc_research_levels()] research level\s.")
	..()

//RnD SERVER
/datum/cyberman_hack/machinery/RnDserver/
	explanation = "Uploads all research on the server to the cyberman network."
	cost = CYBERMEN_HACK_RND_SERVER_COST
	required_type = /obj/machinery/r_n_d/server/

/datum/cyberman_hack/machinery/RnDserver/complete()//perhaps these should also delete research from the server?
	var/obj/machinery/r_n_d/server/S = target
	var/found_any = 0
	for(var/datum/tech/T in S.files.known_tech)
		if(get_research(T))
			found_any = 1
	if(found_any)
		cyberman_network.message_all_cybermen("<span class='notice'>New research levels uploaded. Cybermen network now has [calc_research_levels()] research level\s.</span>")
	..()

//RnD SERVER CONSOLE
//this has serious issues with not being linked to a server until someone interacts with the console. Should probably not be used until I fix that.
/datum/cyberman_hack/machinery/RnDserverControl/
	cost = CYBERMEN_HACK_RND_SERVER_COST
	required_type = /obj/machinery/computer/rdservercontrol/
	explanation = "Uploads all research on the server the console is linked to to the cyberman network."

/datum/cyberman_hack/machinery/RnDserverControl/start_helper()
	if(!..())
		return 0
	var/obj/machinery/computer/rdservercontrol/C = target
	var/obj/machinery/r_n_d/server/S = C.temp_server
	if(S && S.files)
		return 1
	else
		drop("RnD Server Control is not linked to a server, cancelling [display_verb].")
		return 0

/datum/cyberman_hack/machinery/RnDserverControl/complete()
	var/obj/machinery/computer/rdservercontrol/C = target
	var/obj/machinery/r_n_d/server/S = C.temp_server
	if(S && S.files && S.files.known_tech)
		var/found_any = 0
		for(var/datum/tech/T in S.files.known_tech)
			if(get_research(T))
				found_any = 1
		if(found_any)
			cyberman_network.message_all_cybermen("<span class='notice'>New research levels uploaded. Cybermen network now has [calc_research_levels()] research level\s.</span>")
	else
		cyberman_network.message_all_cybermen("<span class='warning'>Warning - RnD Server Control was not linked to a server, no research could be downloaded.</span>")
	..()

//HELPERS

/datum/cyberman_hack/proc/get_research(datum/tech/new_tech)
	if(!new_tech)
		return 0
	for(var/list/datum/tech/old_tech in cyberman_network.cybermen_research_downloaded)
		if(new_tech.id == old_tech.id)
			if(new_tech.level > old_tech.level)
				cyberman_network.cybermen_research_downloaded -= old_tech
				cyberman_network.cybermen_research_downloaded += new_tech
				return 1
			else
				return 0
	if(new_tech.level > 1)//we don't need any level 1 research.
		cyberman_network.cybermen_research_downloaded += new_tech
		return 1
	return 0

/datum/cyberman_hack/proc/calc_research_levels()
	var/current_amount = 0
	for(var/datum/tech/current_data in cyberman_network.cybermen_research_downloaded)
		if(current_data.level)
			current_amount += (current_data.level-1)
	return current_amount

////////////////////////////////////////////////////////
//CONVERT HUMANS (actually all player races, but whatever)
////////////////////////////////////////////////////////

/datum/cyberman_hack/human
	//cost is taken care of in New()
	required_type = /mob/living/carbon/human/
	display_verb = "conversion"
	explanation = "Injects nanites into the human, converting them into a cyberman. The subject will experience digital artifacts in their vision, hearing, and speech once the hack is nearing completion."
	var/obj/effect/hallucination/cybermen_conversion/hallucination

/datum/cyberman_hack/human/New()
	..()
	var/mob/living/carbon/human/H = target
	cost = 400 + 200*cyberman_network.cybermen.len//you can just convert a bunch of people at once to keep the cost down. Possible expoit, but won't worry about it now.
	if(istype(cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len], /datum/objective/cybermen/exterminate/eliminate_humans/))//discourages murderboning. Hopefully.
		cost = min(cost, 3000)
	if(isloyal(H))
		cost = cost*2
	for(var/obj/item/bodypart/L in H.bodyparts)
		if(L.status == ORGAN_ROBOTIC)
			cost -= 100
	//it is entirely possible for a hack to have a cost less than 0. This should not cause problems.

/datum/cyberman_hack/human/start_helper()
	if(!..())
		return 0
	var/mob/living/carbon/human/H = target//type-checking and null-checking have already been done at this point, in the ..().
	if(ticker.mode.is_cyberman(H.mind))//should never happen, but never hurts to check. Theoretically, you shouldn't be able to have two hacks on a person at once, but maybe we should check for that too?
		drop("<span class='warning'>[target_name] is already a cyberman.</span>")
		return 0
	else if(!H.mind || !H.key)
		drop("<span class='warning'>[display_verb] of [target_name] failed, they are catatonic.</span>")
		return 0
	else if(H.stat == DEAD)
		drop("<span class='warning'>[display_verb] of [target_name] failed, they are dead.</span>")
		return 0
	hallucination = new /obj/effect/hallucination/cybermen_conversion(H.loc, H)
	return 1

/datum/cyberman_hack/human/process()
	var/mob/living/carbon/human/H = target
	if(!H)//we'll let hacks on braindead people continue so you can't just relog to cancel a conversion. Should still check for braindeads in start_helper() though.
		..()
		return
	if(ticker.mode.is_cyberman(H.mind))
		drop("<span class='warning'>[target_name] has become cyberman through other means, [display_verb] canceled.</span>")
		return
	if(H.stat == DEAD)
		drop("<span class='warning'>[display_verb] of [target_name] failed, [target_name] is dead.</span>")
	if(H.client)
		if(!hallucination)
			hallucination = new /obj/effect/hallucination/cybermen_conversion(H.loc, H)
		hallucination.percent_complete = (progress/cost)*100
		hallucination.process()
	if(progress >= cost/2)
		H.hearBinaryProb = (progress/cost)*50//scales from 0%-50% chance at 50%-100% of hack completion
		H.speakBinaryProb = (progress/cost)*50
	else
		H.hearBinaryProb = 0
		H.speakBinaryProb = 0
	..()

/datum/cyberman_hack/human/drop()
	var/mob/living/carbon/human/H = target
	H << "<span class='notice'>You feel a weight lift from your mind.</span>"
	H.hearBinaryProb = 0
	H.speakBinaryProb = 0
	if(hallucination)
		hallucination.percent_complete = 0
	..()

/datum/cyberman_hack/human/complete()
	var/mob/living/carbon/human/H = target
	ticker.mode.add_cyberman(H.mind)
	H.hearBinaryProb = 0
	H.speakBinaryProb = 0
	if(hallucination)
		hallucination.percent_complete = 0
	..()

/datum/cyberman_hack/human/Destroy()
	qdel(hallucination)
	return ..()

//human helpers
/datum/cyberman_hack/human/proc/emp_act()//perhaps this should be moved to an undefined method. Hacks live in null-land, so they should never be hit by an EMP, but might want to be careful anyway.
	drop("<span class='warning'>[display_verb] of \the [target_name] was disrupted by an EMP!</span>")

/datum/cyberman_hack/human/proc/electrocute_act()
	var/hack_reversal_amount = cost / 10
	if(progress > hack_reversal_amount)
		progress -= hack_reversal_amount
	else
		drop("<span class='warning'>[display_verb] of \the [target_name] was disrupted by an electric shock!</span>")

//HALLUCINATION EFFECT
/obj/effect/hallucination/cybermen_conversion
	var/percent_complete = 0
	var/list/matrix_images = list()
	var/list/turf/matrix_turfs = list()
	var/image_icon = 'code/game/gamemodes/cybermen/hallucination_effect.dmi'
	var/image_state = "binary_1"


/obj/effect/hallucination/cybermen_conversion/New(loc, var/mob/living/carbon/T)
	target = T
	..()


/obj/effect/hallucination/cybermen_conversion/process()
	target.client.images.Remove(matrix_images)
	matrix_turfs.Cut()
	matrix_images.Cut()
	if(percent_complete > 50)
		var/list/turf/candidates = list()
		for(var/turf/T in orange(12, target))
			candidates += T

		for(var/i=0;i<(percent_complete-50)/1;i++)
			var/toAdd = pick(candidates)
			matrix_turfs += toAdd
			candidates -= toAdd

		for(var/turf/T in matrix_turfs)
			matrix_images += image(image_icon,T,image_state,MOB_LAYER)

		target.client.images |= matrix_images


/obj/effect/hallucination/cybermen_conversion/Destroy()
	target.client.images.Remove(matrix_images)
	qdel(matrix_images)
	qdel(matrix_turfs)
	return ..()


////////////////////////////////////////////////////////
//HACK CYBERMAN
////////////////////////////////////////////////////////
//does nothing at the moment and should never be used.
//maybe it could harden the cyberman against EMPs, but make them much worse at hacking?
//make a cyberman into a scary but slow mech-like thing that eats walls?
/datum/cyberman_hack/cyberman
	required_type = /mob/living/carbon/human/
	explanation = "An experimental procedure that alters the cyberman's body. Not permitted for use at this time."

/datum/cyberman_hack/cyberman/New()
	..()

/datum/cyberman_hack/cyberman/start_helper()
	drop("<span class='warning'>You cannot hack fellow Cybermen</span>")
	return 0


/datum/cyberman_hack/cyberman/process()
	..()

/datum/cyberman_hack/cyberman/complete()
	..()

////////////////////////////////////////////////////////
//HACK COMMS CONSOLE
////////////////////////////////////////////////////////
/datum/cyberman_hack/machinery/comms_console
	cost = CYBERMEN_HACK_COMMS_CONSOLE_COST
	required_type = /obj/machinery/computer/communications/
	explanation = "Logs in to the communications console with captain-level access."

/datum/cyberman_hack/machinery/comms_console/complete()
	var/obj/machinery/computer/communications/C = target
	C.authenticated = 2//captain authentication
	C.auth_id = "$%^@ERROR^&*!@"
	..()


////////////////////////////////////////////////////////
//HACK NUKE CONSOLE
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/nuke
	cost = CYBERMEN_HACK_NUKE_COST
	required_type = /obj/machinery/nuclearbomb/selfdestruct/
	explanation = "Bypasses the password lock on the self-destruct console. Not permitted unless the collective authorizes the destruction of the station."

/datum/cyberman_hack/machinery/nuke/start_helper()
	//no shenanigans with the nuke unless it's the current objective
	if(!cyberman_network || !istype(cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len], /datum/objective/cybermen/exterminate/nuke_station))
		cyberman_network.log_hacking("[usr] attempted to start a cyberman hack on the station self-destruct terminal. This was blocked, as it is not a current Cyberman objective.", 1)
		drop("<span class='warning'>You cannot hack the station self-destruct terminal unless you have an objective to do so!</span>")
		return 0
	if(!..())
		return 0
	//might want to go delta here
	cyberman_network.log_hacking("[usr] attempted to start a cyberman hack on the station self-destruct terminal. This was allowed, as it is a current Cyberman objective.", 1)
	return 1

/datum/cyberman_hack/machinery/nuke/complete()
	var/obj/machinery/nuclearbomb/selfdestruct/nuke = target
	nuke.yes_code = 1
	//maybe also reduce the nuke timer?
	..()

/*
//does not work because on yogcode all cases are always alarmed.
////////////////////////////////////////////////////////
//HACK DISPLAY CASE
////////////////////////////////////////////////////////

/datum/cyberman_hack/display_case
	cost = CYBERMEN_HACK_DISPLAY_CASE_COST
	required_type = /obj/structure/displaycase/
	explanation = "Disables any burglar alarms on the display case."

/datum/cyberman_hack/display_case/complete()
	var/obj/structure/displaycase/T = target
	T.alert = 0
	..()
*/

////////////////////////////////////////////////////////
//HACK BAR SIGN
////////////////////////////////////////////////////////

/datum/cyberman_hack/barsign/
	cost = CYBERMEN_HACK_BARSIGN_COST
	required_type = /obj/structure/sign/barsign/
	explanation = "Causes the bar sign to display an unsantioned syndicate message. Can be undone instantly by hacking it again."

/datum/cyberman_hack/barsign/New()
	..()
	target_name = "bar sign"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/barsign/start_helper()
	if(!..())
		return 0
	var/obj/structure/sign/barsign/S = target
	if(S.emagged)
		cost = 1 //so you can fix it quickly if some doofus does it 4 no. raisin.
	else
		cost = CYBERMEN_HACK_BARSIGN_COST
	return 1

/datum/cyberman_hack/barsign/complete()
	var/obj/structure/sign/barsign/S = target
	if(S.emagged)
		S.emagged = 0
		S.set_sign(pick(S.barsigns))
		S.req_access = list(access_bar)
	else
		S.emagged = 1
		S.set_sign(new /datum/barsign/hiddensigns/syndibarsign)//should come up with a special one for cybermen, but this will do for now.
		S.req_access = list()//no access can change the sign.
	..()

////////////////////////////////////////////////////////
//HACK BOT
////////////////////////////////////////////////////////

//wouldn't be too hard to make securitrons ignore cybermen. Might do that in the future.
/datum/cyberman_hack/bot
	cost = CYBERMEN_HACK_BOT_COST
	required_type = /mob/living/simple_animal/bot
	explanation = "Overloads the target bot's systems, causing an effect akin to an emag."

/datum/cyberman_hack/bot/process()
	var/mob/living/simple_animal/bot/B = target
	if(B && B.emagged == 2)
		drop("<span class='warning'>\The [target_name]'s systems are already overloaded.</span>")
	else
		..()

/datum/cyberman_hack/bot/complete()
	var/mob/living/simple_animal/bot/B = target
	var/old_open = B.open
	B.locked = 0
	B.open = 1
	B.emag_act(null)
	B.open = old_open
	..()

////////////////////////////////////////////////////////
//HACK VENDING MACHINE
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/vending_machine
	cost = CYBERMEN_HACK_VENDING_MACHINE_COST
	required_type = /obj/machinery/vending/
	explanation = "Enables contraband and disables departmental access on the vending machine. The same effect can be achieved manually by pulsing the proper wires."

/datum/cyberman_hack/machinery/vending_machine/New()
	..()
	target_name += " vendor"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/machinery/vending_machine/complete()
	var/obj/machinery/vending/T = target
	T.extended_inventory = 1
	T.scan_id = 0
	..()

////////////////////////////////////////////////////////
//HACK AUTOLATHE
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/autolathe
	cost = CYBERMEN_HACK_AUTOLATHE_COST
	explanation = "Hacks the autolathe, enabling it to produce more items. The same effect can be achieved manually by cutting the proper wire."

/datum/cyberman_hack/machinery/autolathe/complete()
	var/obj/machinery/autolathe/lathe = target
	lathe.adjust_hacked(1)
	..()

////////////////////////////////////////////////////////
//HACK SHUTTLE CONSOLE
////////////////////////////////////////////////////////

/datum/cyberman_hack/machinery/shuttle_console
	cost = CYBERMEN_HACK_SHUTTLE_COST
	explanation = "Causes the shuttle to be launched early."

/datum/cyberman_hack/machinery/shuttle_console/process()
	var/obj/machinery/computer/emergency_shuttle/C = target
	if(SSshuttle.emergency.mode != SHUTTLE_DOCKED)
		drop("<span class='warning'>The emercency shuttle cannot be hacked at this time, the shuttle must be docked with the station.</span>")
	else if(C && C.emagged)
		drop("<span class='warning'>The emergency shuttle console's electronics are too damaged to be hacked.</span>")
	else
		..()

/datum/cyberman_hack/machinery/shuttle_console/complete()
	var/obj/machinery/computer/emergency_shuttle/C = target
	if(!C.emagged && SSshuttle.emergency.mode == SHUTTLE_DOCKED)
		var/time = SSshuttle.emergency.timeLeft()
		cyberman_network.log_hacking("Cybermen have hacked the emergency shuttle [time] seconds before launch.", 1)
		log_game("Cybermen have hacked the emergency shuttle in ([C.x],[C.y],[C.z]) [time] seconds before launch.")
		minor_announce("The emergency shuttle will launch in 10 seconds", "SYSTEM ERROR:",null,1)
		SSshuttle.emergency.setTimer(100)
		C.emagged = 1
	..()


////////////////////////////////////////////////////////
//HACK RADIO
////////////////////////////////////////////////////////

/datum/cyberman_hack/multiple_vector/telecomms
	cost = CYBERMEN_HACK_RADIO_COST
	explanation = "Toggles off all telecommunication hubs in the local area. Networks without a hub cannot be hacked. Can be maintained by hacking the machine directly, or through any standard intercomm, radio, or radio headset."

/datum/cyberman_hack/multiple_vector/telecomms/New()
	..()
	target_name = "telecomms network"
	name = "[display_verb] of \the [target_name]"

/datum/cyberman_hack/multiple_vector/telecomms/start_helper()
	if(!..())
		return 0
	for(var/obj/machinery/telecomms/hub/H in telecomms_list)
		return 1
		break
	drop("<span class='warning'>Unable to locate a telecommunications hub - any existing telecomms network is not advanced enough to hack.</span>")
	return 0

/datum/cyberman_hack/multiple_vector/telecomms/complete()
	for(var/obj/machinery/telecomms/hub/hub in telecomms_list)//for now it disables all hubs on all z-levels. Might someday make it only on a particular z-level.
		hub.toggled = 0
		cyberman_network.cybermen_hacked_objects += hub//need this for objectives
	..()

//component hacks
//radio
/datum/cyberman_hack/radio
	required_type = /obj/item/device/radio/

/datum/cyberman_hack/radio/start()
	return component_hack_start(/datum/cyberman_hack/multiple_vector/telecomms/, null)

//intercomm (needs its own to handle power loss)
/datum/cyberman_hack/radio/intercom
	required_type = /obj/item/device/radio/intercom/

/datum/cyberman_hack/radio/intercom/start_helper()
	if(!..())
		return 0
	var/obj/item/device/radio/intercom/I = target
	if(I && !I.on)
		drop("<span class='warning'>Cannot perform [display_verb] of \the [target_name], it is currently unpowered.</span>")
		return 0
	return 1

/datum/cyberman_hack/radio/intercom/process()
	var/obj/item/device/radio/intercom/I = target
	if(I && !I.on)
		drop("<span class='warning'>[display_verb] of \the [target_name] has failed, it has lost power.</span>")
		return
	..()

//hub
/datum/cyberman_hack/machinery/tcomms_hub
	required_type = /obj/machinery/telecomms/hub/

/datum/cyberman_hack/machinery/tcomms_hub/start()
	return component_hack_start(/datum/cyberman_hack/multiple_vector/telecomms/, null)

////////////////////////////////////////////////////////
//HACK MICROWAVE
////////////////////////////////////////////////////////

/datum/cyberman_hack/microwave
	cost = CYBERMEN_HACK_MICROWAVE_COST
	explanation = "Hacks the mircowave. Does nothing useful."
	required_type = /obj/machinery/microwave

////////////////////////////////////////////////////////
//INSTALL PART
////////////////////////////////////////////////////////

/datum/cyberman_hack/upgrade
	cost = CYBERMEN_INSTALL_BASE_COST//maybe make this more expensive the better the part?
	required_type = /obj/item/weapon/stock_parts/capacitor/ //change this if you ever make is so you can install other parts.
	display_verb = "installation"
	explanation = "Installs the part into the hacking cyberman, increasing their processing power, hack range, or other abilities. The part must remain in very close proximity to the installer, and fellow cybermen cannot assist in the installation."
	var/datum/mind/installer

/datum/cyberman_hack/upgrade/New(atom/target, mob/living/carbon/human/user = usr)
	outputLimiter = list(user.mind)
	..()

/datum/cyberman_hack/upgrade/start_helper()
	if(!..())
		return 0
	if(usr.mind)
		installer = usr.mind
	else
		drop("<span class='warning'>you do not have a mind, and should not be hacking at all.</span>")
		//should probably add an error log here.
	var/obj/item/weapon/stock_parts/capacitor/C = target
	for(var/obj/item/weapon/stock_parts/capacitor/P in installer.cyberman.upgrades_installed)
		if(P.rating >= C.rating)
			drop("You already have an equal or better part installed!")
			return 0
	for(var/datum/cyberman_hack/upgrade/hack in cyberman_network.active_cybermen_hacks)
		if(hack != src && hack.installer == installer)
			drop("<span class='warning'>You are already installing a part! Cancel that hack to start this one.</span>")
			return 0
	return 1

/datum/cyberman_hack/upgrade/process()
	..()
	if(!installer)
		drop("<span class='warning'>[display_verb] failed, your mind has disapeared.</span>")
	if(!installer.current)
		drop("<span class='warning'>[display_verb] failed, your body has been disconnected from your mind.</span>")

/datum/cyberman_hack/upgrade/complete()
	var/obj/item/weapon/stock_parts/part = target
	for(var/obj/item/weapon/stock_parts/capacitor/P in installer.cyberman.upgrades_installed)//in theory, you should only ever have one capacitor installed, but forloop anyway because it's easy.
		installer.cyberman.upgrades_installed -= P
		P.loc = installer.current.loc
	installer.cyberman.upgrades_installed += target
	if(istype(part.loc, /mob))//doesn't matter where the part goes, it just has to be out of any containers.
		var/mob/M = part.loc
		M.unEquip(part, 1)
	else if(istype(part.loc, /obj/item/weapon/storage))
		part.remove_item_from_storage(installer.current.loc)
	part.loc = null
	installer.cyberman.update_processing_power(installer.current)
	outputMessage("<span class='notice'>You have installed a [target], increasing your processing power.</span>")
	..()

/datum/cyberman_hack/upgrade/get_preference_for(mob/living/carbon/human/H)
	if(H.mind != installer)
		return 0
	if(get_dist(H, target) > 1)
		return 0
	var/turf/cyberman_turf = get_turf(H)
	var/turf/target_turf = get_turf(target)
	if(cyberman_turf.z != target_turf.z)
		return 0
	return CYBERMEN_HACK_MAX_PREFERENCE

/datum/cyberman_hack/upgrade/contribute_to(mob/living/carbon/human/H)
	if(H.mind != installer)
		return
	if(!H.mind || !H.mind.cyberman)
		return
	do_tick_calculations_if_required(H)
	if(!tick_same_z_level || tick_dist > 1)
		return
	maintained = 1
	progress += H.mind.cyberman.hack_power_level_1

/datum/cyberman_hack/upgrade/can_cancel(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.mind.cyberman)
		return 0
	var/turf/cyberman_turf = get_turf(H)
	var/turf/target_turf = get_turf(target)
	if(cyberman_turf.z != target_turf.z)
		return 0
	return get_dist(H, target) <= 1

/datum/cyberman_hack/upgrade/get_status(mob/living/user)
	var/result
	if(installer.current)
		result = "Installation: [target_name] into [installer.current] | progress: [progress] / [cost]"
	else
		result = "ERROR: Cyberman mind disconnected from body."
	return result
