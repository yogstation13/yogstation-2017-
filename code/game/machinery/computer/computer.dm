/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300
	var/obj/item/weapon/circuitboard/computer/circuit = null // if circuit==null, computer can't disassembly
	var/processing = 0
	var/brightness_on = 2
	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/computer_health = 25
	var/clockwork = FALSE
	var/screen_crack = "crack"
	var/image/crack_overlay
	paiAllowed = 1

/obj/machinery/computer/New(location, obj/item/weapon/circuitboard/C)
	..(location)
	if(C && istype(C))
		circuit = C
	else if(circuit)
		circuit = new circuit(null)
	power_change()
	update_icon()

/obj/machinery/computer/initialize()
	power_change()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	if(software)
		for(var/V in software)
			var/datum/software/M = V
			M.onMachineTick()
	return 1

/obj/machinery/computer/emp_act(severity)
	if(severity == 1)
		take_damage(rand(15,30), BRUTE, 0)
	else
		take_damage(rand(15,25), BRUTE, 0)
	..()

/obj/machinery/computer/ex_act(severity, target)
	if(target == src)
		qdel(src)
		return
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(25))
				qdel(src)
			else
				take_damage(rand(20,30), BRUTE, 0)
		if(3)
			take_damage(rand(10,30), BRUTE, 0)

/obj/machinery/computer/ratvar_act()
	if(!clockwork)
		clockwork = TRUE
		icon_screen = "ratvar[rand(1, 4)]"
		icon_keyboard = "ratvar_key[rand(1, 6)]"
		icon_state = "ratvarcomputer[rand(1, 4)]"
		update_icon()

/obj/machinery/computer/narsie_act()
	if(clockwork && clockwork != initial(clockwork) && prob(20)) //if it's clockwork but isn't normally clockwork
		clockwork = FALSE
		icon_screen = initial(icon_screen)
		icon_keyboard = initial(icon_keyboard)
		icon_state = initial(icon_state)
		update_icon()

/obj/machinery/computer/bullet_act(obj/item/projectile/P)
	take_damage(P.damage, P.damage_type, 0)
	..()

/obj/machinery/computer/update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		overlays += "[icon_keyboard]_off"
		return
	overlays += icon_keyboard
	if(stat & BROKEN)
		overlays += "[icon_state]_broken"
	else
		overlays += icon_screen
	if(paired)
		overlays += "paipaired"
	update_crack()

/obj/machinery/computer/power_change()
	..()
	if(stat & NOPOWER)
		SetLuminosity(0)
	else
		SetLuminosity(brightness_on)
	update_icon()
	return

/obj/machinery/computer/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/weapon/screwdriver/I)
	if(circuit && !(flags & NODECONSTRUCT))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You start to disconnect the monitor...</span>")
		if(do_after(user, 20/I.toolspeed, target = src))
			deconstruction()
			var/obj/structure/frame/computer/A = new /obj/structure/frame/computer(src.loc)
			A.circuit = circuit
			A.anchored = 1
			circuit = null
			erase_data()
			for (var/obj/C in src)
				C.loc = src.loc
			if ((stat & BROKEN) || computer_health != initial(src.computer_health))
				to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
				new /obj/item/weapon/shard(src.loc)
				new /obj/item/weapon/shard(src.loc)
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
				A.state = 4
				A.icon_state = "4"
			qdel(src)
		return TRUE
	return FALSE

/obj/machinery/computer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(!default_deconstruction_screwdriver(user, null, null, I))
			return ..()
	else if(istype(I, /obj/item/weapon/weldingtool) && user.a_intent == "help")
		var/obj/item/weapon/weldingtool/W = I
		if(!W.isOn())
			return ..()
		else if(computer_health == initial(src.computer_health)) //This doesn't like |'s for some reason
			to_chat(user, "<span class='notice'>No point in welding a pristine looking computer.</span>")
			return 0
		else if(!computer_health)
			return 0
		else
			computer_health = initial(src.computer_health)
			update_crack()
			W.remove_fuel(1, user)


	else
		return ..()

/obj/machinery/computer/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(stat & BROKEN)
					playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
				else
					playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(BURN)
			if(sound_effect)
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		else
			return
	computer_health = max(computer_health - damage, 0)
	if(circuit) //no circuit, no breaking
		if(!computer_health && !(stat & BROKEN))
			playsound(loc, 'sound/effects/Glassbr3.ogg', 100, 1)
			if(paired)
				paired.unpair(0)
			stat |= BROKEN
			update_icon()
	update_crack()



/obj/machinery/computer/proc/erase_data()
	return 0

/obj/machinery/computer/proc/update_crack()
	overlays -= crack_overlay
	if(!(screen_crack && computer_health) || (computer_health == initial(src.computer_health)))
		return 0
	var/crack = round(computer_health / 5)
	crack_overlay = image(icon = 'icons/obj/computer.dmi', icon_state = "[screen_crack]_[crack]")
	overlays += crack_overlay

/obj/machinery/computer/Topic(href, href_list)
	if(..())
		return 1
	if (issilicon(usr))
		return 0
	if(ishuman(usr))
		var/list/keyboardclicks = list('sound/effects/keyboard1.ogg','sound/effects/keyboard2.ogg','sound/effects/keyboard3.ogg','sound/effects/keyboard4.ogg')
		playsound(src, pick(keyboardclicks), 25, 1, 0)
		return 0
	return 0
