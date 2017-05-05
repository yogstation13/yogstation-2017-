/*
	Items, Structures, Machines
*/


//
// Items
//

/obj/item/weapon/holo
	damtype = STAMINA

/obj/item/weapon/holo/esword
	name = "holographic energy sword"
	desc = "May the force be with you. Sorta"
	icon_state = "sword0"
	force = 3.0
	throw_speed = 2
	throw_range = 5
	throwforce = 0
	w_class = 2.0
	hitsound = "swing_hit"
	armour_penetration = 50
	var/active = 0

/obj/item/weapon/holo/esword/green/New()
	item_color = "green"

/obj/item/weapon/holo/esword/red/New()
	item_color = "red"

/obj/item/weapon/holo/esword/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	if(active)
		return ..()
	return 0

/obj/item/weapon/holo/esword/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/holo/esword/New()
	item_color = pick("red","blue","green","purple")

/obj/item/weapon/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if (active)
		force = 30
		icon_state = "sword[item_color]"
		w_class = 4
		hitsound = 'sound/weapons/blade1.ogg'
		playsound(user, 'sound/weapons/saberon.ogg', 20, 1)
		user << "<span class='warning'>[src] is now active.</span>"
	else
		force = 3
		icon_state = "sword0"
		w_class = 2
		hitsound = "swing_hit"
		playsound(user, 'sound/weapons/saberoff.ogg', 20, 1)
		user << "<span class='warning'>[src] can now be concealed.</span>"
	return

//BASKETBALL OBJECTS

/obj/item/toy/beach_ball/holoball
	name = "basketball"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = 4 //Stops people from hiding it in their bags/pockets

/obj/item/toy/beach_ball/holoball/dodgeball
	name = "dodgeball"
	icon_state = "dodgeball"
	item_state = "dodgeball"
	desc = "Used for playing the most violent and degrading of childhood games."

/obj/item/toy/beach_ball/holoball/dodgeball/throw_impact(atom/hit_atom)
	..()
	if((ishuman(hit_atom)))
		var/mob/living/carbon/M = hit_atom
		playsound(src, 'sound/items/dodgeball.ogg', 50, 1)
		M.apply_damage(10, STAMINA)
		if(prob(5))
			M.Weaken(3)
			visible_message("<span class='danger'>[M] is knocked right off \his feet!</span>")

/datum/action/item_action/chaos_dunk
	name = "Chaos Dunk"

/obj/item/toy/beach_ball/holoball/chaos
	desc = "Come on and SLAM!"
	color = "green"
	actions_types = list(/datum/action/item_action/chaos_dunk)
	var/fail = FALSE
	var/instant_dunk = FALSE //If an admin wants to dunk without the whole warmup portion
	var/jamming = FALSE
	var/dunking = FALSE
	var/mob/living/carbon/human/jammer = null
	var/obj/structure/holohoop/spirit/hoop = null

/obj/item/toy/beach_ball/holoball/chaos/New()
	..()
	notify_ghosts("Everybody get up, it's time to slam now!", source = src, action = NOTIFY_ORBIT)
	poi_list |= src

/obj/item/toy/beach_ball/holoball/chaos/Destroy()
	poi_list -= src
	..()

/obj/item/toy/beach_ball/holoball/chaos/attack(atom/T, mob/user)
	if(!jamming || fail)
		return
	if(isliving(T))
		var/mob/living/M = T
		M.Weaken(2)
		user.do_attack_animation(M)
		playsound(get_turf(user), 'sound/effects/hit_kick.ogg', 100, 0)
		user.visible_message("<span class='danger'>[user] slams [M] onto the ground!</span>")
		user.changeNext_move(CLICK_CD_MELEE) //Who the fuck mixed camelcase with snakecase?

/obj/item/toy/beach_ball/holoball/chaos/afterattack(atom/target as mob|obj|turf|area, mob/user)
	return

/obj/item/toy/beach_ball/holoball/chaos/dropped(mob/living/user as mob)
	unequipped(user) //Better safe than sorry?
	..()

/obj/item/toy/beach_ball/holoball/chaos/unequipped(mob/living/user as mob)
	if(!dunking && jamming)
		user << "<span class='danger'>Better luck next season, ball hog!</span>"
		fail = TRUE
		jamming = FALSE
		STOP_PROCESSING(SSobj, src)
	..()

/obj/item/toy/beach_ball/holoball/chaos/process()
	if(fail)
		jammer << "<span class='userdanger'>You trip over your feet!</span>"
		jammer.Weaken(5)
		playsound(get_turf(jammer), 'sound/misc/sadtrombone.ogg', 100, 0)
	if(prob(10))
		jammer << "<span class='warning'><b>You hear the Space Jam theme coming from the [dir2text(get_dir(get_turf(jammer), get_turf(hoop)))]...</span>"
		if(prob(25))
			for(var/mob/M in player_list)
				if(jammer != M)
					M << "<span class='warning'><b>You hear the Space Jam theme coming from the [dir2text(get_dir(get_turf(jammer), get_turf(hoop)))]...</span>"

/obj/item/toy/beach_ball/holoball/chaos/ui_action_click(mob/user, actiontype)
	if(actiontype != /datum/action/item_action/chaos_dunk)
		..()
		return
	if(fail)
		user << "<span class='warning'>This ball is battered and burnt - it will not be able to handle a chaos slam.</span>"
		return
	if(!ishuman(user))
		user << "<span class='warning'>You are not rad enough to perform this sick trick!</span>"
		return
	var/mob/living/carbon/human/H = user

	if(src != H.get_active_hand())
		H << "<span class='warning'>You need to be holding the basketball in your active hand!</span>"
		return
	var/turf/T = user.loc
	if(!T)
		H << "<span class='warning'>You can't dunk here!</span>"
		return

	if(!instant_dunk)
		if(alert("Are you ready to jam?",,"Let's slam!","Let's not!") != "Let's slam!")
			return
		if(blobstart.len > 0)
			var/turf/targetturf = get_turf(pick(blobstart))
			hoop = new /obj/structure/holohoop/spirit(targetturf)
		else
			H << "bit of a fuckup here"
			return
		jamming = TRUE
		jammer = H
		
		if(T.z == ZLEVEL_STATION)
			priority_announce("[user] is attempting a Chaos Dunk in [get_area(user)]. Steal the ball at all costs!","Nanotrasen Basketball Association","sound/misc/notice1.ogg")
		for(var/obj/item/I in H)
			if(istype(I, /obj/item/toy/beach_ball/holoball/chaos))
				continue
			qdel(I)

		var/obj/item/clothing/under/shorts/purple/barkleys_shorts = new
		barkleys_shorts.name = "barkley's shorts"
		barkleys_shorts.flags = NODROP
		H.equip_to_appropriate_slot(barkleys_shorts)
		var/obj/item/clothing/shoes/sneakers/yeezy/orange/jordans = new
		jordans.flags = NODROP
		H.equip_to_appropriate_slot(jordans)
		H << "<span class='danger'>You call forth the spirit of Barkley and begin channeling his power...</span>"
		H << "<span class='danger'>Show off your dribbling skills and evade your opponents!<span>"
		H << "<span class='warning'><b>You hear the Space Jam theme coming from the [dir2text(get_dir(get_turf(H), get_turf(hoop)))]...</span>"
		message_admins("[key_name_admin(user)] is warming up to a chaos dunk at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>(JMP)</a> <A href='?src=\ref[src];badmin_block=1'>\[TRIP UP\]</a>")
		START_PROCESSING(SSobj, src)
		return
	else
		jammer = H
		dunk()

/obj/item/toy/beach_ball/holoball/chaos/proc/dunk()
	dunking = TRUE
	STOP_PROCESSING(SSobj, src)
	var/turf/T = jammer.loc
	message_admins("[key_name_admin(jammer)] is about to dunk at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>(JMP)</a> <A href='?src=\ref[src];badmin_block=1'>\[PREVENT\]</a>")
	jammer.visible_message("<span class='userdanger'>[jammer] leaps into the air!</span>")
	flags = NODROP
	jammer.stunned = INFINITY
	jammer.status_flags |= GODMODE //So you can't get killed mid dunk
	jammer.update_canmove()

	spawn(0)
		jammer.SpinAnimation(10, 3, 1, 3)
	for(var/i = 0, i < 50, i++)
		jammer.pixel_y += 8
		sleep(1)

	jammer.alpha = 0

	sleep(20)
	if(T.z == ZLEVEL_STATION)
		priority_announce("A measured 19.7 MJs of negative b-ball protons has been detected in [get_area(jammer)]. A Chaos Dunk is imminent. All personnel currently on [station_name()] have 10 seconds to reach minimum safe distance. This is not a test.")
		for(var/mob/M in player_list)
			M << 'sound/machines/Alarm.ogg'
		sleep(40)
		for(var/mob/M in player_list)
			M << 'sound/misc/bloblarm.ogg' //drama
		sleep(60)
	else
		sleep(100)
	if(hoop)
		jammer.loc = hoop.loc
	jammer.alpha = 255
	jammer.adjust_fire_stacks(20)
	jammer.IgniteMob()

	spawn(0)
		jammer.SpinAnimation(3, 6, 1, 3)
	for(var/i = 0, i < 20, i++)
		jammer.pixel_y -= 20
		sleep(1)

	jammer.status_flags &= ~GODMODE
	if(fail)
		flags &= ~NODROP
		if(hoop)
			jammer.visible_message("<span clas='danger'>[jammer] misses the hoop and lands on his face!</span>")
		else
			jammer.visible_message("<span clas='danger'>[jammer] loses grip of the ball and lands on his face!</span>")
		jammer.adjustBruteLoss(200)
		jammer.death()
		jammer.stunned = 0
		playsound(get_turf(jammer), 'sound/misc/sadtrombone.ogg', 100, 0)
	else
		jammer.visible_message("<span class='userdanger'>[jammer] ascends into godhood!</span>")
		explosion(get_turf(jammer), 25, 60, 150, 250, 1, 1)
		jammer.gib() //In case they are wearing a bomb suit
	jamming = FALSE
	imminent = FALSE
	if(hoop)
		qdel(hoop)

/obj/item/toy/beach_ball/holoball/chaos/Topic(href, list/href_list)
	if(..())
		return TRUE
	if(!check_rights())
		return
	if(!fail && href_list["badmin_block"])
		fail = TRUE
		message_admins("[key_name_admin(usr)] prevented a chaos slam")
		return TRUE

/obj/item/toy/beach_ball/holoball/chaos/instant
	desc = "Come on and SLAM immediately!"
	instant_dunk = TRUE

//
// Structures
//

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, shakalaka!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1

/obj/structure/holohoop/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(get_dist(src,user)<2)
		if(user.drop_item(src))
			visible_message("<span class='warning'> [user] dunks [W] into \the [src]!</span>")

/obj/structure/holohoop/attack_hand(mob/user)
	if(user.pulling && user.a_intent == "grab" && isliving(user.pulling))
		var/mob/living/L = user.pulling
		if(user.grab_state < GRAB_AGGRESSIVE)
			user << "<span class='warning'>You need a better grip to do that!</span>"
			return
		L.loc = src.loc
		L.Weaken(5)
		visible_message("<span class='danger'>[user] dunks [L] into \the [src]!</span>")
		user.stop_pulling()
	else
		..()

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.loc = src.loc
			visible_message("<span class='warning'> Swish! \the [I] lands in \the [src].</span>")
		else
			visible_message("<span class='danger'> \the [I] bounces off of \the [src]'s rim!</span>")
		return 0
	else
		return ..()

/obj/structure/holohoop/spirit
	name = "spirit basketball hoop"
	desc = "Hey, you, whatcha gonna do?"
	density = 0
	luminosity = 1
	color = "blue"

/obj/structure/holohoop/spirit/New()
	..()
	notify_ghosts("Here's your chance, do your dance at the Space Jam, alright...", source = src, action = NOTIFY_ORBIT)
	poi_list |= src

/obj/structure/holohoop/spirit/Destroy()
	poi_list -= src
	..()

/obj/structure/holohoop/spirit/attackby(obj/item/toy/beach_ball/holoball/chaos/bball, mob/user, params)
	if(!istype(bball))
		return
	if(get_dist(src,user)<2)
		bball.dunk()

//
// Machines
//

/obj/machinery/readybutton
	name = "ready declaration device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user as mob)
	user << "The station AI is not to interact with these devices"
	return

/obj/machinery/readybutton/attack_paw(mob/user as mob)
	user << "<span class='warning'>You are too primitive to use this device!</span>"
	return

/obj/machinery/readybutton/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	user << "The device is a solid button, there's nothing you can do with it!"

/obj/machinery/readybutton/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		user << "<span class='warning'>This device is not powered!</span>"
		return

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		usr << "<span class='warning'>The event has already begun!</span>"
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/W in currentarea)
		if(W.flags&NODECONSTRUCT) // Just in case: only holo-windows
			qdel(W)

	for(var/mob/M in currentarea)
		M << "FIGHT!"
