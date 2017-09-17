/obj/vehicle/car //Non-buckle vehicles in which you can't see the driver. More like a real vehicle.
	name = "car"
	icon_state = "car"
	vehicle_move_delay = 1
	anchored = 1
	layer = ABOVE_ALL_MOB_LAYER

	var/mob/living/carbon/driver
	var/driver_visible =	FALSE  //Driver visible uses buckling, driver not visible uses contents. Using contents is preferable
	var/on = FALSE //whether the car is started or not
	var/health = 200

	var/horn_sound = null //Leave empty to have no horn on the car
	var/horn_spam_time = 20 //Cooldown inbetween indiviudal honks

	var/last_enginesound_time //To prevent sound spam
	var/engine_sound_length = 20 //Set this to the length of the engine sound
	var/engine_sound = 'sound/effects/carrev.ogg'

	var/ramming = FALSE //Whether or not this car is ramming people.
	var/ram_damage = 0 //how much pain does this bring
	var/last_crash_time //to prevent double-crashing into walls.
	var/list/ramming_sounds = list() //Sounds for when you hit a person
	var/list/crash_sounds = list()  //Sounds for when you crash into a structure

	var/can_load_mobs = FALSE //Whether or not this car can have people in its trunk, for meme vehicles
	var/list/load_sounds = list() //Sounds for when you load people into your car
	var/mob/list/loaded_mobs = list() //Loaded people

	var/hacked = FALSE

	//Action datums
	var/datum/action/innate/car/car_eject/eject_action = new
	var/datum/action/innate/car/car_start/start_action = new
	var/datum/action/innate/car/car_horn/horn_action = new
	var/datum/action/innate/car/dump_load/dump_action = new
	var/datum/action/innate/car/kidnap_count/count_action = new

/obj/vehicle/car/Destroy()
	exit_car()
	dump_contents()
	explosion(get_turf(loc), 0, 0, 1, 3)
	.=..()

/obj/vehicle/car/examine(mob/user)
	..()
	if(driver)
		user << "It seems to be occupied"

/obj/vehicle/car/Bump(atom/movable/M)
	. = ..()
	if(auto_door_open && istype(M, /obj/machinery/door))
		M.Bumped(driver)
	if(ramming && world.time - last_crash_time > 2) //Prevents spam. I know its weird but I can't fix it any other way
		last_crash_time = world.time
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			src.visible_message("<span class='danger'>[src] rams into [C] and knocks them down!</span>")
			C.Weaken(3)
			if(C.buckled)
				C.buckled.unbuckle_mob(C,force=1)
			if(ram_damage)
				C.apply_damage(ram_damage, BRUTE)
			if(ramming_sounds.len)
				playsound(loc, pick(ramming_sounds), 75)
		else if(!istype(M, /obj/machinery/door) && (istype(M, /obj) || istype(M, /turf/closed)))
			src.visible_message("<span class='warning'>[src] rams into [M] and crashes!</span>")
			if(crash_sounds.len)
				playsound(loc, pick(crash_sounds), 75)
			if(driver) //avoid nasty runtimes
				driver.Weaken(2)
			exit_car()
			dump_contents()

/obj/vehicle/car/MouseDrop_T(mob/target, mob/user)
	if(user.incapacitated() || user.lying	|| !ishuman(user))
		return
	if(!istype(target) || target.buckled)
		return
	if(user == target)
		if(driver)
			user << "<span class='warning'>[name] is already occupied!</span>"
			return
		user.visible_message("<span class='danger'>[user] starts getting into [src]</span>")
		if(do_after(user, 20, target = src))
			if(driver)//inb4 someone got in sneaky peaky like
				return
			user.visible_message("<span class='danger'>[user] gets into [src]</span>")
			enter_car(user)
	else if(can_load_mobs && user == driver)
		user.visible_message("<span class='danger'>[user] starts stuffing [target] into [src]</span>")
		if(do_after(user, 20, target = src))
			if(load_sounds.len)
				playsound(loc, pick(load_sounds), 75)
			user.visible_message("<span class='danger'>[user] stuffs [target] into [src]</span>")
			load_mob(target)

/obj/vehicle/car/MouseDrop(atom/over_object)
	if(driver && usr != driver)
		usr.visible_message("<span class='danger'>[usr] starts dragging [driver] out of [src]</span>")
		if(do_after(usr, 20, target = src))
			usr.visible_message("<span class='danger'>[usr] drags [driver] out of [src]</span>")
			exit_car()
			dump_contents()

/obj/vehicle/car/relaymove(mob/user, direction)
	if(user != driver) //don't want our victims driving off now do we
		return 0
	if(!on)
		return 0
	if(world.time - last_enginesound_time > engine_sound_length && engine_sound)
		last_enginesound_time = world.time
		playsound(src, engine_sound, 75, TRUE)
	.=..()

/obj/vehicle/car/attack_hand(mob/living/user as mob)
	user.changeNext_move(CLICK_CD_MELEE) // Ugh. Ideally we shouldn't be setting cooldowns outside of click code.
	user.do_attack_animation(src)
	user.visible_message("<span class='danger'>[user] hits [name]. Nothing happens</span>","<span class='danger'>You hit [name] with no visible effect.</span>")
	return

/obj/vehicle/car/narsie_act()
	take_damage(120)

/obj/vehicle/car/ratvar_act()
	take_damage(120)

/obj/vehicle/car/hitby(atom/movable/A) //wrapper
	if(istype(A, /obj))
		var/obj/O = A
		if(O.throwforce)
			visible_message("<span class='danger'>[name] is hit by [A].</span>")
			take_damage(O.throwforce)

/obj/vehicle/car/bullet_act(var/obj/item/projectile/Proj) //wrapper
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		take_damage(Proj.damage) //to do: add damage absorption based on type flag
	Proj.on_hit(src)

/obj/vehicle/car/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(30))
				qdel(src)
			else
				take_damage(initial(health)/2)
		if(3)
			if(prob(5))
				qdel(src)
			else
				take_damage(initial(health)/5)

/obj/vehicle/car/emag_act(mob/user)
	if(hacked)
		return
	hacked = TRUE
	user << "<span class='notice'>You emag the [src] and turn off the safety systems.</span>"
	ramming = TRUE
	ram_damage = 10
	horn_spam_time = 1 //oh boi

/obj/vehicle/car/container_resist(mob/living/user)
	if(user == driver)
		exit_car()
	else
		user << "<span class='notice'>You push against the back of [src] trunk to try and get out.</span>"
		if(do_after(user, 200, target = src))
			user.visible_message("<span class='danger'>[user] gets out of [src]</span>")
			unload_mob(user)

/obj/vehicle/car/proc/take_damage(var/amount)
	if(amount)
		health -= amount
		update_health()

/obj/vehicle/car/proc/update_health()
	if(health < 0)
		qdel(src)

/obj/vehicle/car/proc/enter_car(mob/living/carbon/human/H)
	if(H && H.client && H.z == z && get_dist(H, src) <= 1 && ishuman(H))
		driver = H
		GrantActions(H)

		if(driver_visible) //Buckling
			user_buckle_mob(H, H, FALSE)
		else //Using contents
			H.forceMove(src)
			forceMove(loc)
			add_fingerprint(H)
		return 1
	else
		return 0

/obj/vehicle/car/proc/exit_car(var/forced, var/atom/newloc = loc)
	if(!driver)
		return
	if(!ishuman(driver))
		return
	RemoveActions(driver)
	if(driver_visible) //Buckling
		driver.unbuckle_mob(driver, forced)
	else //Using contents
		driver.forceMove(newloc)
	driver = null

/obj/vehicle/car/proc/load_mob(mob/M)
	if(!istype(M) && !isliving(M))
		return
	if(M && (M.z == z) && (get_dist(M, src) <= 1 ))
		loaded_mobs += M
		M.forceMove(src)
		count_action.update_counter()

/obj/vehicle/car/proc/unload_mob(mob/M)
	var/targetturf = get_turf(src)
	M.forceMove(targetturf)
	loaded_mobs -= M
	count_action.update_counter()

/obj/vehicle/car/proc/unload_all_mobs()
	for(var/mob/M in loaded_mobs)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			C.Weaken(2)
		unload_mob(M)

/obj/vehicle/car/proc/CanStart() //This exists if you want to add more conditions to starting up the car later on
	if(keycheck(driver))
		return 1
	else
		driver << "<span class='warning'>You need to hold the key to start [src]</span>"

/obj/vehicle/car/proc/dump_contents()
	if(loaded_mobs.len)
		unload_all_mobs()
	empty_object_contents()
