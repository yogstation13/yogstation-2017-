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
	
	var/chaotic = FALSE

/obj/item/toy/beach_ball/holoball/attackby(obj/item/nuke_core/core, mob/user, params)
	if(istype(core))
		qdel(core) //baseballs are made of lead so no radiation
		chaotic = TRUE
		user.verbs += /mob/living/carbon/human/proc/chaos_dunk
		desc += " It seems to be glowing slightly."
		user << "<span class='danger'>As you insert the plutonium core into the basketball you feel a surge of newfound powers...</span>"

/mob/living/carbon/human/proc/chaos_dunk()
	set category = "Spells"
	set name = "Chaos Dunk"

	var/mob/living/carbon/human/user = usr
	var/obj/item/toy/beach_ball/holoball/bball = user.get_active_hand()

	if(!istype(bball))
		user << "<span class='warning'>You need to be holding the basketball in your active hand!</span>"
		return

	if(!bball.chaotic)
		user << "<span class='warning'>This ball doesn't feel quite right.</span>"
		return
		
	user.verbs -= /mob/living/carbon/human/proc/chaos_dunk

	bball.flags = NODROP
	user.stunned = INFINITY

	for(var/i = 0, i < 50, i++)
		user.pixel_y += 8
		if(i%8 == 0)
			user.emote("flip")
		sleep(1)
		
	user.alpha = 0

	sleep(20)
	priority_announce("A massive influx of negative b-ball protons has been detected in [get_area(user)]. A Chaos Dunk is imminent. All personnel currently on [station_name()] have 10 seconds to reach minimum safe distance. This is not a test.")
	for(var/mob/M in player_list)
		M << 'sound/machines/Alarm.ogg'
	sleep(100)

	user.alpha = 255
	user.adjust_fire_stacks(20)
	user.IgniteMob()

	for(var/i = 0, i < 20, i++)
		user.pixel_y -= 20
		if(i%6 == 0)
			user.emote("flip")
		sleep(1)

	explosion(get_turf(user), 14, 28, 56, 112)
	user.gib() //In case they are wearing a bomb suit

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
