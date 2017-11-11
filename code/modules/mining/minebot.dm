/**********************Mining drone**********************/

#define MINEDRONE_COLLECT 1
#define MINEDRONE_ATTACK 2
#define MINEDRONE_IDLE 3
#define MINEDRONE_EMAGGED 4

/mob/living/simple_animal/hostile/mining_drone
	name = "nanotrasen minebot"
	desc = "The instructions printed on the side read: This is a small robot used to support miners, can be set to search and collect loose ore, or to help fend off wildlife. A mining scanner can instruct it to drop loose ore. Field repairs can be done with a welder."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "mining_drone"
	icon_living = "mining_drone"
	status_flags = list(CANSTUN, CANWEAKEN, CANPUSH)
	stop_automated_movement_when_pulled = 1
	mouse_opacity = 1
	faction = list("neutral")
	a_intent = "harm"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	wander = 0
	stop_automated_movement_when_pulled = 1
	idle_vision_range = 5
	move_to_delay = 10
	retreat_distance = 1
	minimum_distance = 2
	health = 125
	maxHealth = 125
	melee_damage_lower = 15
	melee_damage_upper = 15
	environment_smash = 0
	check_friendly_fire = 1
	attacktext = "drills"
	attack_sound = 'sound/weapons/circsawhit.ogg'
	ranged = 1
	sentience_type = SENTIENCE_MINEBOT
	ranged_message = "shoots"
	ranged_cooldown_time = 30
	projectiletype = /obj/item/projectile/kinetic
	projectilesound = 'sound/weapons/Gunshot4.ogg'
	speak_emote = list("states")
	wanted_objects = list(/obj/item/weapon/ore/diamond, /obj/item/weapon/ore/gold, /obj/item/weapon/ore/silver,
						  /obj/item/weapon/ore/plasma,  /obj/item/weapon/ore/uranium,    /obj/item/weapon/ore/iron,
						  /obj/item/weapon/ore/bananium, /obj/item/weapon/ore/glass)
	healable = 0
	unique_name = 1
	var/mode = MINEDRONE_COLLECT
	var/light_on = 0
	var/obj/item/device/radio/radio

	var/datum/action/innate/minedrone/toggle_light/toggle_light_action
	var/datum/action/innate/minedrone/toggle_meson_vision/toggle_meson_vision_action
	var/datum/action/innate/minedrone/toggle_mode/toggle_mode_action
	var/datum/action/innate/minedrone/dump_ore/dump_ore_action
	var/datum/action/innate/minedrone/give_up_sentience/give_up_sentience_action

/mob/living/simple_animal/hostile/mining_drone/New()
	..()
	toggle_light_action = new()
	toggle_light_action.Grant(src)
	toggle_meson_vision_action = new()
	toggle_meson_vision_action.Grant(src)
	toggle_mode_action = new()
	toggle_mode_action.Grant(src)
	dump_ore_action = new()
	dump_ore_action.Grant(src)
	give_up_sentience_action = new()
	give_up_sentience_action.Grant(src)

	radio = new /obj/item/device/radio(src)
	radio.keyslot = new /obj/item/device/encryptionkey/headset_cargo()
	radio.subspace_transmission = 1
	radio.canhear_range = 0 // anything greater will have the bot broadcast the channel as if it were saying it out loud.
	radio.recalculateChannels()

	toggle_light()
	SetCollectBehavior()

/mob/living/simple_animal/hostile/mining_drone/Life()
	if(!radio.on && !radio.emped)
		radio.on = 1
	..()

/mob/living/simple_animal/hostile/mining_drone/Moved(atom/OldLoc, Dir)
	..()
	if(ckey || mode == MINEDRONE_COLLECT)
		for(var/obj/item/weapon/ore/O in src.loc)
			O.loc = src

/mob/living/simple_animal/hostile/mining_drone/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/W = I
		if(W.welding && !stat && user.a_intent == "help")
			if(mode != MINEDRONE_IDLE)
				user << "<span class='info'>[src] is moving around too much to repair!</span>"
				return
			if(maxHealth == health)
				user << "<span class='info'>[src] is at full integrity.</span>"
			else
				adjustBruteLoss(-10)
				user << "<span class='info'>You repair some of the armor on [src].</span>"
			return
	if(is_mining_scanner(I))
		user << "<span class='info'>You instruct [src] to drop any collected ore.</span>"
		DropOre()
		return
	..()

/mob/living/simple_animal/hostile/mining_drone/death()
	..()
	visible_message("<span class='danger'>[src] is destroyed!</span>")
	new /obj/effect/decal/cleanable/robot_debris(src.loc)
	DropOre(0)
	qdel(src)
	return

/mob/living/simple_animal/hostile/mining_drone/New()
	..()
	SetCollectBehavior()

/mob/living/simple_animal/hostile/mining_drone/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent == "help")
		toggle_mode()
		switch(mode)
			if(MINEDRONE_IDLE)
				M << "<span class='info'>[src] has been set to idle. It can now be easily repaired.</span>"
			if(MINEDRONE_COLLECT)
				M << "<span class='info'>[src] has been set to search and store loose ore.</span>"
			if(MINEDRONE_ATTACK)
				M << "<span class='info'>[src] has been set to attack hostile wildlife.</span>"
			else
				M << "<span class='warning'>[src] does not seem to be responding!</span>"
		return
	..()

/mob/living/simple_animal/hostile/mining_drone/proc/SetCollectBehavior()
	if(mode == MINEDRONE_EMAGGED)
		return
	mode = MINEDRONE_COLLECT
	LoseTarget()
	AIStatus = ckey ? AI_OFF : AI_ON
	idle_vision_range = 9
	search_objects = 2
	wander = 1
	ranged = 0
	minimum_distance = 1
	retreat_distance = null
	melee_damage_lower = 15
	melee_damage_upper = 15
	a_intent = "harm"
	icon_state = "mining_drone"
	src << "<span class='info'>You are set to collect mode. You can now collect loose ore.</span>"

/mob/living/simple_animal/hostile/mining_drone/proc/SetOffenseBehavior()
	if(mode == MINEDRONE_EMAGGED)
		return
	mode = MINEDRONE_ATTACK
	LoseTarget()
	AIStatus = ckey ? AI_OFF : AI_ON
	idle_vision_range = 7
	search_objects = 0
	wander = 1
	ranged = 1
	retreat_distance = 1
	minimum_distance = 2
	melee_damage_lower = 15
	melee_damage_upper = 15
	a_intent = "harm"
	icon_state = "mining_drone_offense"
	src << "<span class='info'>You are set to attack mode. You can now attack from range.</span>"

/mob/living/simple_animal/hostile/mining_drone/proc/SetInactiveBehavior()
	if(mode == MINEDRONE_EMAGGED)
		return
	mode = MINEDRONE_IDLE
	LoseTarget()
	AIStatus = AI_OFF
	idle_vision_range = 3
	search_objects = 0
	wander = 0
	ranged = 0
	minimum_distance = 0
	retreat_distance = null
	melee_damage_lower = 0
	melee_damage_upper = 0
	a_intent = "help"
	icon_state = "mining_drone_idle"
	src << "<span class='info'>You are set to idle mode. You can now be repaired.</span>"

/mob/living/simple_animal/hostile/mining_drone/proc/SetEmagBehavior()
	mode = MINEDRONE_EMAGGED
	AIStatus = AI_ON
	idle_vision_range = 9
	search_objects = 0
	wander = 1
	ranged = 1
	stat_attack = 1
	retreat_distance = 1
	minimum_distance = 2
	environment_smash = 1
	melee_damage_lower = 15
	melee_damage_upper = 15
	a_intent = "harm"
	stop_automated_movement_when_pulled = 0
	icon_state = "mining_drone_emag"

/mob/living/simple_animal/hostile/mining_drone/emag_act(mob/user)
	if(mode == MINEDRONE_EMAGGED)
		return
	if(ckey)
		src << "<span class='danger'>ALERT: Foreign software execution prevented.</span>"
		return
	if(user)
		user << "<span class='notice'>The [src] buzzes and beeps.</span>"
		faction |= user.faction
	faction -= "neutral"
	faction += "mining_drone" //No drone on drone violence.
	SetEmagBehavior()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
	s.set_up(5, 1, src)
	s.start()
	Stun(5)
	icon_state = "mining_drone_emag"
	return

/mob/living/simple_animal/hostile/mining_drone/AttackingTarget()
	if(istype(target, /obj/item/weapon/ore) && mode == MINEDRONE_COLLECT)
		CollectOre()
		return
	..()

/mob/living/simple_animal/hostile/mining_drone/proc/CollectOre()
	var/obj/item/weapon/ore/O
	for(O in src.loc)
		O.loc = src
	for(var/dir in alldirs)
		var/turf/T = get_step(src,dir)
		for(O in T)
			O.loc = src
	return

/mob/living/simple_animal/hostile/mining_drone/proc/DropOre(message = 1)
	if(!contents.len)
		if(message)
			src << "<span class='notice'>You attempt to dump your stored ore, but you have none.</span>"
		return
	if(message)
		src << "<span class='notice'>You dump your stored ore.</span>"
	for(var/obj/item/weapon/ore/O in contents)
		contents -= O
		O.loc = src.loc
	return

/mob/living/simple_animal/hostile/mining_drone/adjustHealth(amount)
	if(mode != MINEDRONE_EMAGGED && mode != MINEDRONE_ATTACK && amount > 0)
		SetOffenseBehavior()
	. = ..()

/mob/living/simple_animal/hostile/mining_drone/sentience_act()
	check_friendly_fire = 0
	AIStatus = AI_OFF

/mob/living/simple_animal/hostile/mining_drone/proc/fix_light()
	light_on = 0

/mob/living/simple_animal/hostile/mining_drone/proc/toggle_mode()
	switch(mode)
		if(MINEDRONE_IDLE)
			SetCollectBehavior()
		if(MINEDRONE_COLLECT)
			SetOffenseBehavior()
		if(MINEDRONE_ATTACK)
			SetInactiveBehavior()
		else //This should never happen.
			mode = MINEDRONE_COLLECT
			SetCollectBehavior()

/mob/living/simple_animal/hostile/mining_drone/proc/toggle_light()
	if(light_on == 2)
		return

	if(light_on)
		AddLuminosity(-6)
	else
		AddLuminosity(6)
	light_on = !light_on
	src << "<span class='notice'>You toggle your light [light_on ? "on" : "off"].</span>"

/mob/living/simple_animal/hostile/mining_drone/radio(message, message_mode, list/spans)
	. = ..()
	if(. != 0)
		return .

	switch(message_mode)
		if(MODE_HEADSET)
			if(radio)
				radio.talk_into(src, message, , spans)
			return REDUCE_RANGE

		if(MODE_DEPARTMENT)
			if (radio)
				radio.talk_into(src, message, message_mode, spans)
			return REDUCE_RANGE

	if(message_mode in radiochannels)
		if(radio)
			radio.talk_into(src, message, message_mode, spans)
			return REDUCE_RANGE

//Actions

/datum/action/innate/minedrone
	check_flags = AB_CHECK_CONSCIOUS
	background_icon_state = "bg_default"

/datum/action/innate/minedrone/toggle_light
	name = "Toggle Light"
	button_icon_state = "mech_lights_off"

/datum/action/innate/minedrone/toggle_light/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner

	user.toggle_light()

/datum/action/innate/minedrone/toggle_meson_vision
	name = "Toggle Meson Vision"
	button_icon_state = "meson"

/datum/action/innate/minedrone/toggle_meson_vision/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner

	if(user.sight & SEE_TURFS)
		user.sight &= ~SEE_TURFS
		user.see_invisible = SEE_INVISIBLE_LIVING
	else
		user.sight |= SEE_TURFS
		user.see_invisible = SEE_INVISIBLE_MINIMUM

	user << "<span class='notice'>You toggle your meson vision [(user.sight & SEE_TURFS) ? "on" : "off"].</span>"

/datum/action/innate/minedrone/toggle_mode
	name = "Toggle Mode"
	button_icon_state = "mech_cycle_equip_off"

/datum/action/innate/minedrone/toggle_mode/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	user.toggle_mode()

/datum/action/innate/minedrone/dump_ore
	name = "Dump Ore"
	button_icon_state = "mech_eject"

/datum/action/innate/minedrone/dump_ore/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	user.DropOre()

/datum/action/innate/minedrone/give_up_sentience
	name = "Give up Sentience"
	button_icon_state = "sentience_loss"

/datum/action/innate/minedrone/give_up_sentience/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	if(alert(user, "Are you sure you wish to give up your sentience? This cannot be undone.",, "Yes", "No") != "Yes")
		return
	var/obj/item/slimepotion/sentience/mining/upgrade = new(user.loc)
	user.visible_message("<span class='notice'>\The [upgrade] pops out of a slot on [user], and its gaze becomes dim and lifeless once again.</span>")
	user.ghostize(0)

/**********************Minebot Upgrades**********************/

//Melee

/obj/item/device/mine_bot_upgrade
	name = "minebot melee upgrade"
	desc = "A minebot upgrade."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'

/obj/item/device/mine_bot_upgrade/afterattack(mob/living/simple_animal/hostile/mining_drone/M, mob/user, proximity)
	if(!istype(M) || !proximity)
		return
	upgrade_bot(M, user)

/obj/item/device/mine_bot_upgrade/proc/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(M.melee_damage_upper != initial(M.melee_damage_upper))
		user << "[src] already has a combat upgrade installed!"
		return
	M.melee_damage_lower = 22
	M.melee_damage_upper = 22
	qdel(src)

//Health

/obj/item/device/mine_bot_upgrade/health
	name = "minebot chassis upgrade"

/obj/item/device/mine_bot_upgrade/health/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(M.maxHealth != initial(M.maxHealth))
		user << "[src] already has a reinforced chassis!"
		return
	M.maxHealth = 170
	qdel(src)


//Cooldown

/obj/item/device/mine_bot_upgrade/cooldown
	name = "minebot cooldown upgrade"

/obj/item/device/mine_bot_upgrade/cooldown/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	name = "minebot cooldown upgrade"
	if(M.ranged_cooldown_time != initial(M.ranged_cooldown_time))
		user << "[src] already has a decreased weapon cooldown!"
		return
	M.ranged_cooldown_time = 10
	qdel(src)


//AI
/obj/item/slimepotion/sentience/mining
	name = "minebot AI upgrade"
	desc = "Can be used to grant sentience to minebots."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'
	sentience_type = SENTIENCE_MINEBOT
	origin_tech = "programming=6"

/obj/item/slimepotion/sentience/mining/do_checks(mob/living/M, mob/user)
	if(!..())
		return 0
	var/mob/living/simple_animal/hostile/mining_drone/drone = M
	if(istype(drone) && drone.mode == MINEDRONE_EMAGGED)
		user << "<span class='warning'>[M] is not responding to [src]!</span>"
		return 0
	return 1

#undef MINEDRONE_COLLECT
#undef MINEDRONE_ATTACK
#undef MINEDRONE_IDLE
#undef MINEDRONE_EMAGGED