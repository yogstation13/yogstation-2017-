#define SINGLE "single"
#define VERTICAL "vertical"
#define HORIZONTAL "horizontal"

#define METAL 1
#define WOOD 2
#define SAND 3

//Barricades/cover

/obj/structure/barricade
	name = "chest high wall"
	desc = "Looks like this would make good cover."
	anchored = 1
	density = 1
	var/health = 100
	var/maxhealth = 100
	var/proj_pass_rate = 50 //How many projectiles will pass the cover. Lower means stronger cover
	var/ranged_damage_modifier = 1 //Multiply for ranged damage
	var/material = METAL
	var/debris_type


/obj/structure/barricade/proc/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(damage)
					playsound(loc, 'sound/weapons/smash.ogg', 50, 1)
				else
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			if(sound_effect)
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		else
			damage = 0
	health -= damage
	if(health <= 0)
		if(debris_type)
			new debris_type(get_turf(src), 3)
		qdel(src)


/obj/structure/barricade/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(M.melee_damage_upper == 0 || (M.melee_damage_type != BRUTE && M.melee_damage_type != BURN))
		return
	visible_message("<span class='danger'>[M] [M.attacktext] [src]!</span>")
	add_logs(M, src, "attacked")
	take_damage(M.melee_damage_upper)

/obj/structure/barricade/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/weldingtool) && user.a_intent != "harm" && material == METAL)
		var/obj/item/weapon/weldingtool/WT = I
		if(health < maxhealth)
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin repairing [src]...</span>"
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
				if(do_after(user, 40/I.toolspeed, target = src))
					health = Clamp(health + 20, 0, maxhealth)
	else
		return ..()


/obj/structure/barricade/attacked_by(obj/item/I, mob/living/user)
	..()
	take_damage(I.force)

/obj/structure/barricade/bullet_act(obj/item/projectile/P)
	. = ..()
	visible_message("<span class='warning'>\The [src] is hit by [P]!</span>")
	take_damage(P.damage*ranged_damage_modifier)

/obj/structure/barricade/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			take_damage(25, BRUTE, 0)

/obj/structure/barricade/blob_act(obj/effect/blob/B)
	take_damage(25, BRUTE, 0)

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0)//So bullets will fly over and stuff.
	if(height==0)
		return 1
	if(locate(/obj/structure/barricade) in get_turf(mover))
		return 1
	else if(istype(mover, /obj/item/projectile))
		if(!anchored)
			return 1
		var/obj/item/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return 1
		if(prob(proj_pass_rate))
			return 1
		return 0
	else
		return !density



/////BARRICADE TYPES///////

/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "This space is blocked off by a wooden barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"
	material = WOOD
	debris_type = /obj/item/stack/sheet/mineral/wood


/obj/structure/barricade/sandbags
	name = "sandbags"
	desc = "Bags of sand. Self explanatory."
	icon = 'icons/obj/smooth_structures/sandbags.dmi'
	icon_state = "sandbags"
	health = 280
	maxhealth = 280
	proj_pass_rate = 20
	pass_flags = LETPASSTHROW
	material = null
	climbable = TRUE
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/barricade/sandbags, /turf/closed/wall, /turf/closed/wall/r_wall, /obj/structure/falsewall, /obj/structure/falsewall/reinforced, /turf/closed/wall/rust, /turf/closed/wall/r_wall/rust, /obj/structure/barricade/security)


/obj/structure/barricade/security
	name = "security barrier"
	desc = "A deployable barrier. Provides good cover in fire fights."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrier0"
	density = 0
	anchored = 0
	health = 180
	maxhealth = 180
	proj_pass_rate = 20
	ranged_damage_modifier = 0.5


/obj/structure/barricade/security/New()
	..()
	spawn(40)
		icon_state = "barrier1"
		density = 1
		anchored = 1
		visible_message("<span class='warning'>[src] deploys!</span>")


/obj/item/weapon/grenade/barrier
	name = "barrier grenade"
	desc = "Instant cover. Alt+click to toggle modes."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "flashbang"
	item_state = "flashbang"
	actions_types = list(/datum/action/item_action/toggle_barrier_spread)
	var/mode = SINGLE

/obj/item/weapon/grenade/barrier/AltClick(mob/living/user)
	if(!istype(user) || user.incapacitated())
		return
	toggle_mode(user)

/obj/item/weapon/grenade/barrier/proc/toggle_mode(mob/user)
	switch(mode)
		if(SINGLE)
			mode = VERTICAL
		if(VERTICAL)
			mode = HORIZONTAL
		if(HORIZONTAL)
			mode = SINGLE

	user << "[src] is now in [mode] mode."

/obj/item/weapon/grenade/barrier/prime()
	new /obj/structure/barricade/security(get_turf(src.loc))
	switch(mode)
		if(VERTICAL)
			var/target_turf = get_step(src, NORTH)
			if(!(is_blocked_turf(target_turf)))
				new /obj/structure/barricade/security(target_turf)

			var/target_turf2 = get_step(src, SOUTH)
			if(!(is_blocked_turf(target_turf2)))
				new /obj/structure/barricade/security(target_turf2)
		if(HORIZONTAL)
			var/target_turf = get_step(src, EAST)
			if(!(is_blocked_turf(target_turf)))
				new /obj/structure/barricade/security(target_turf)

			var/target_turf2 = get_step(src, WEST)
			if(!(is_blocked_turf(target_turf2)))
				new /obj/structure/barricade/security(target_turf2)
	qdel(src)

/obj/item/weapon/grenade/barrier/ui_action_click(mob/user)
	toggle_mode(user)




#undef SINGLE
#undef VERTICAL
#undef HORIZONTAL

#undef METAL
#undef WOOD
#undef SAND


/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = 0.0
	density = 1.0
	icon_state = "barrier0"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
	var/obj/item/device/radio/attachedradio = null
	var/obj/item/device/encryptionkey/installedkey = null
	var/radio_freq
	var/initialdesc
	var/healthreport
	var/round_start_intialize = 0

	var/obj/item/device/assembly/signaler/SIGNALLER = null

/obj/machinery/deployable/barrier/New()
	..()

	icon_state = "barrier[src.locked]"
	attachedradio = new /obj/item/device/radio(src)
	attachedradio.listening = 0
	initialdesc = desc
	installedkey = new /obj/item/device/encryptionkey/headset_sec

/obj/machinery/deployable/barrier/process()
	if(ticker && ticker.current_state == GAME_STATE_PREGAME)
		return
	if(!round_start_intialize)
		setup_round_start_intialize()
	return

/obj/machinery/deployable/barrier/proc/setup_round_start_intialize()
	if(ticker && ticker.current_state > GAME_STATE_PREGAME)
		attachedradio.set_frequency(SEC_FREQ)
		radio_freq = SEC_FREQ
		round_start_intialize = 1

/obj/machinery/deployable/barrier/attackby(obj/item/weapon/W, mob/user, params)
	if (W.GetID())
		if (allowed(user))
			if	(emagged < 2.0)
				switch(alert("Selection Prompt","Barrier Uplink", "Lock","Rename", "Toggle Functionality Report","Cancel"))
					if("Lock")
						locked = !locked
						anchored = !anchored
						icon_state = "barrier[src.locked]"
						if ((locked == 1.0) && (emagged < 2.0))
							user << "Barrier lock toggled on."
							return
						else if ((locked == 0.0) && (emagged < 2.0))
							user << "Barrier lock toggled off."
							return
					if("Rename")
						var/new_name = reject_bad_name(input(usr, "Enter the barriers new designated name", "Barrier Uplink", name),1)
						if(!in_range(src, usr) && loc != usr)
							return
						if(new_name)
							message_admins("[user] ([user.ckey]) is changing [name] to [new_name]. ([loc.x],[loc.y],[loc.z]) <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>(JMP)")
							log_game("[user] ([user.ckey]) has changed [name] to [new_name].")
							var/randomdigit = "([rand(50,1000)])"
							name = new_name
							name += " - Barrier [randomdigit]"
						else
							return
					if("Toggle Functionality Report")
						if(healthreport)
							healthreport = !healthreport
							user << "<span class='notice'>You toggle off the barrier's functionality report. It will no longer report how much health it is has remaining.</span>"
						else
							healthreport = 1
							user << "<span class='notice'>You toggle on the barrier's functionality report. It will now report how much health it is has remaining.</span>"
			else
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message("<span class='danger'>BZZzZZzZZzZT</span>")
				return
		return
	else if (istype(W, /obj/item/weapon/wrench))
		if (health < src.maxhealth)
			health = src.maxhealth
			emagged = 0
			req_access = list(access_security)
			visible_message("<span class='danger'>[user] repairs \the [src]!</span>")
			return
		else if (src.emagged > 0)
			src.emagged = 0
			src.req_access = list(access_security)
			visible_message("<span class='danger'>[user] repairs \the [src]!</span>")

		src.req_access = list(access_security)

	else if (istype(W, /obj/item/weapon/screwdriver))

		if (src.locked == 1.0)
			user << "<span class='danger'>You can't eject anything from the barrier while it's locked!</span>"
			return

		if (SIGNALLER)
			new /obj/item/device/assembly/signaler(src.loc)
			SIGNALLER = null
			desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
			initialdesc = desc
			desc_report() //puts the cherry ontop of our... codey sundae
			user.visible_message( \
						"[user] deattaches the signaler from the barrier.", \
						"<span class='notice'>You unscrew the signaler from the barrier.</span>")
			return

		if (installedkey)
			var/turf/T = get_turf(src.loc)
			if(T)
				installedkey.loc = T
				installedkey = null
			attachedradio.frequency = 0
			user.visible_message("[user] unscrews the encryption key from the barrier.")
			return


		if (!installedkey && !SIGNALLER)
			user << "<span class='danger'>[src] doesn't have anything to eject.</span>"
			return

	else if (istype(W, /obj/item/device/encryptionkey))

		if (src.locked == 1.0)
			user << "<span class='danger'>You can't install anything while the barrier is locked!</span>"
			return

		var/initialkey = installedkey

		if(installedkey)
			user << "[src] already has an encryption key installed!"
			return

		installedkey = W

		if(installedkey.channels.Find("Security"))
			visible_message("[src] swallows the encryption key and vibrates happily!")
			attachedradio.set_frequency(SEC_FREQ)
			radio_freq = SEC_FREQ
			user.unEquip(W)
			W.loc = src
			return

		else
			visible_message("[src] rejects the encryption key and vibrates angrily!")
			installedkey = initialkey
			return

	else if(issignaler(W))

		if(SIGNALLER)
			user << "<span class='notice'>There's a signaler attatched to the barrier!</span>"
			return

		SIGNALLER = W

		if(SIGNALLER.secured)
			user <<"<span class='danger'>The device is secured.</span>"
			SIGNALLER = null
			return

		if(!radio_freq)
			user << "<span class='danger'>There isn't an encryption key associated with the barrier to attach the signaler to!</span>"
			SIGNALLER = null
			return

		else
			user.visible_message( \
						"[user] attaches the signaler to the barrier.", \
						"<span class='notice'>You attach the signaler to the barrier.</span>")
			desc = "[src.desc] It also appears to have a remote signaling device attatched to it."
			initialdesc = desc
			qdel(W)
		return

	else
		user.changeNext_move(CLICK_CD_MELEE)
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 0.75
			if("brute")
				src.health -= W.force * 0.5
			else

		// examine damage notifiers.
		if (src.health <= 99)
			desc_report()


		if (src.health <= 0)
			attachedradio.talk_into(src, "Losing signal with the security channel!",radio_freq)
			src.explode()
		..()

		// This will send a message to the security channel if the barrier's radio is connected to it's frequency

		if (((attachedradio.frequency == SEC_FREQ || attachedradio.frequency == 1359)) && !src.emagged) // security currently. emagging will disable this.
			if(!W.force)
				return

			var/thebarrier = "A deployable barrier"

			if(SIGNALLER)
				var/detectedarea = get_area(src)
				thebarrier = thebarrier + " located in [detectedarea]"

			var/damagereport
			if(W.force <= 5 && W.force != 0) // less or equal to 5
				damagereport = "a small amount of damage"
			if(W.force > 5 && W.force <= 15) // in the 5-15 range, but greater than 5
				damagereport = "a moderate amount of damage"
			if(W.force > 15) //greater than 15
				damagereport = "a large amount of damage"
			else if (!damagereport)
				return

			if(src.health <= 95 && src.health > 50 || src.health <= 50 && src.health > 25 || src.health <= 25 && src.health > 0)
				var/attack_report = "Alert! This barrier's systems are suffering [damagereport]"
				if(healthreport)
					attack_report += ". The barriers rate of functionality is at [health]%"
				attachedradio.talk_into(src, "[attack_report]!!",radio_freq)

/obj/machinery/deployable/barrier/proc/desc_report() // something to update the description of the barrier.

	if (src.health >= 61)
		desc = "[initialdesc] <span class='danger'>The barrier is slightly damaged.</span>"
		return

	if (src.health <= 60 && src.health >= 31)
		desc = "[initialdesc] <span class='danger'>The barrier seems to have taken a multitude of strong blows.</span>"
		return

	if (src.health <= 30 && src.health > 1)
		desc = "[initialdesc] <span class='danger'>The barrier appears to be severely damanged and in need of repair. </span>"
		return


/obj/machinery/deployable/emag_act(mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access = null
		user << "<span class='notice'>You break the ID authentication lock on \the [src].</span>"
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='danger'>BZZzZZzZZzZT</span>")
		return
	else if (src.emagged == 1)
		src.emagged = 2
		user << "<span class='notice'>You short out the anchoring mechanism on \the [src].</span>"
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='danger'>BZZzZZzZZzZT</span>")
		return

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				src.explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/blob_act()
	src.health -= 25
	if (src.health <= 0)
		src.explode()
	return

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0)//So bullets will fly over and stuff.
	if(height==0)
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/proc/explode()

	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(Tsec)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	playsound(src.loc, 'sound/effects/Explosion1.ogg',100,1)
	if(src)
		qdel(src)