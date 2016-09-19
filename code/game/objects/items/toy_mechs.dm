/*
 * Mech prizes
 */

/*
 * Remote
 */

/obj/item/device/toy_mech_remote
	name = "toy mecha remote"
	desc = "A remote for controlling toy mechs."
	icon_state = "locator"
	w_class = 2
	var/obj/item/toy/toy_mech/mecha = null
	var/range = 8
	var/datum/browser/popup = null

/obj/item/device/toy_mech_remote/Destroy()
	if(mecha)
		mecha.remote = null
		mecha = null
	return ..()

/obj/item/device/toy_mech_remote/attack_self(mob/user)
	update_dialogue(user)

/obj/item/device/toy_mech_remote/proc/can_use(mob/user)
	if(!user)
		return 0
	if(user.get_active_hand() != src && user.get_inactive_hand() != src)
		return 0
	return 1

/obj/item/device/toy_mech_remote/proc/rangecheck()
	if(!mecha)
		return 0
	var/turf/T1 = get_turf(src)
	var/turf/T2 = get_turf(mecha)
	if(T1.z != T2.z)
		return 0
	if(get_dist(mecha, src) > range)
		return 0
	return 1

/obj/item/device/toy_mech_remote/proc/update_dialogue(mob/user)
	if(!user && !popup)
		return

	if(!user && popup)
		user = popup.user

	if(!popup || (popup.user != user))
		if(popup)
			popup.close()
			qdel(popup)
		popup = new(user, "mech_remote", "Toy Mecha Remote", 200, 300, src)

	if(!can_use(popup.user))
		popup.close()
		return

	var/dat = ""
	if(mecha)
		dat += "Mech: [mecha]<br>"
		if(!rangecheck())
			dat += "<center><h2><font color=red>Signal Lost</font></center></h2><br>"
		else
			var/color = "green"
			if(mecha.health == 0)
				color = "red"
			else if(mecha.health < mecha.maxhealth * 0.7)
				color = "yellow"
			dat += "Armor: <font color=[color]>[mecha.health] / [mecha.maxhealth]</font><br>"
			dat += mecha.get_extra_controls(src)
			dat += "<br>"
	else
		dat += "No connected mech"
	dat += {"
	<center><table>
	<tr><td></td><td align='center'><A HREF='?src=\ref[src];input=up'>^</A></td><td></td></tr>
	<tr><td align='center'><A HREF='?src=\ref[src];input=left'>\<</A></td><td align='center'><A HREF='?src=\ref[src];input=center'>Fire</A></td><td><A HREF='?src=\ref[src];input=right'>\></A></td></tr>
	<tr><td></td><td align='center'><A HREF='?src=\ref[src];input=down'>v</A></td><td></td></tr>
	</table></center>
	"}
	popup.set_content(dat)
	popup.open()

/obj/item/device/toy_mech_remote/Topic(href, href_list)
	if(href_list["close"])
		qdel(popup)
		popup = null
		return
	if(!can_use(usr))
		if(popup && usr == popup.user)
			popup.close()
		return
	if(!mecha)
		update_dialogue()
		return
	if(!rangecheck())
		update_dialogue()
		return
	switch(href_list["input"])
		if("up")
			mecha.mech_move(NORTH)
		if("down")
			mecha.mech_move(SOUTH)
		if("left")
			mecha.mech_move(WEST)
		if("right")
			mecha.mech_move(EAST)
		if("center")
			mecha.mech_attack()
	if(href_list["special"])
		mecha.special_action(href_list["special"])
	update_dialogue()

/*
 * The Mechs
 */

/obj/item/toy/toy_mech
	icon = 'icons/obj/toy.dmi'
	icon_state = "ripleytoy"
	var/cooldown = 0
	var/quiet = 0
	var/move_delay = 5
	var/lastmove = 0
	var/lastattack = 0
	var/attack_cd = 10
	var/obj/item/device/toy_mech_remote/remote = null
	var/health = 25
	var/maxhealth = 25
	var/needs_reset = 0
	var/on = 1
	var/weapon_name = "none"

/obj/item/toy/toy_mech/equipped(mob/user, slot)
	..()
	dir = SOUTH

/obj/item/toy/toy_mech/attack_self(mob/user)
	if(needs_reset)
		user << "<span class='notice'>You press the reset button on [src].</span>"
		reset()
		return
	if(!cooldown)
		user << "<span class='notice'>You play with [src].</span>"
		cooldown = 1
		spawn(30) cooldown = 0
		if (!quiet)
			playsound(user, 'sound/mecha/mechstep.ogg', 20, 1)
		return
	..()

/obj/item/toy/toy_mech/attack_hand(mob/user)
	if(loc == user)
		if(!cooldown)
			user << "<span class='notice'>You play with [src].</span>"
			cooldown = 1
			spawn(30)
				cooldown = 0
			if (!quiet)
				playsound(user, 'sound/mecha/mechturn.ogg', 20, 1)
			return
	..()

/obj/item/toy/toy_mech/attackby(obj/item/W, mob/user, proximity)
	if(istype(W, /obj/item/device/toy_mech_remote))
		if(remote)
			remote.mecha = null
			remote.update_dialogue()
		remote = W
		if(remote.mecha)
			remote.mecha.remote = null
		remote.mecha = src
		remote.update_dialogue()
		user << "<span class='notice'>Remote linked to [src].</span>"
		return 1

/obj/item/toy/toy_mech/examine(mob/user)
	..()
	user << "The armor meter reads [health] / [maxhealth]"

/obj/item/toy/toy_mech/proc/mech_can_attack()
	if(!on)
		return 0
	if(!isturf(loc))
		return 0
	if(lastattack + attack_cd >= world.time)
		return 0
	lastattack = world.time
	return 1

/obj/item/toy/toy_mech/proc/mech_attack()
	if(!mech_can_attack())
		return 0
	visible_message("<span class='warning'>[src] waves threateningly at the air.</span>")

/obj/item/toy/toy_mech/proc/mech_move(dir)
	if(!on || !isturf(loc))
		return 0
	if(lastmove + move_delay >= world.time)
		return 0
	lastmove = world.time
	if(src.dir == dir)
		var/turf/going_to = get_step(src, dir)
		for(var/obj/item/toy/toy_mech/in_the_way in going_to)
			if(in_the_way.on)
				return 0
		if(!has_gravity(src))
			return 0
		if(!quiet)
			playsound(src, 'sound/mecha/mechstep.ogg', 20, 1)
		step(src, dir)
		return 1
	else
		if(!quiet)
			playsound(src, 'sound/mecha/mechturn.ogg', 20, 1)
		src.dir = dir
		return 2

/obj/item/toy/toy_mech/proc/special_action(action)
	return

/obj/item/toy/toy_mech/proc/get_extra_controls(topic_ref)
	return "Weapon: [weapon_name]"

/obj/item/toy/toy_mech/proc/mech_take_damage(amount)
	if(!on)
		return
	needs_reset = 1
	health = Clamp(health-amount, 0, maxhealth)
	if(health == 0)
		on = 0
		layer -= 0.01
		visible_message("<span class='boldwarning'>[src] lets out a defeated beep and slumps over.</span>")
	if(remote)
		remote.update_dialogue()

/obj/item/toy/toy_mech/proc/reset()
	on = 1
	needs_reset = 0
	lastmove = 0
	lastattack = 0
	health = maxhealth
	layer = initial(layer)
	if(remote)
		remote.update_dialogue()

/obj/item/toy/toy_mech/Destroy()
	if(remote)
		remote.mecha = null
		remote = null
	return ..()

//subtypes
/obj/item/toy/toy_mech/melee
	var/attacksound = null
	var/attackdamage = 0
	attack_cd = 15

/obj/item/toy/toy_mech/melee/mech_attack()
	var/obj/item/toy/toy_mech/target = get_living_toy_mech(get_step(src, dir))
	if(!target)
		return
	if(!mech_can_attack())
		return
	if(attacksound)
		playsound(src, attacksound, 40, 1)
	target.visible_message("<span class='warning'>[src] hits [target] with its [weapon_name]!</span>")
	target.mech_take_damage(attackdamage)


/obj/item/toy/toy_mech/ranged
	attack_cd = 20
	var/projectiletype = null
	var/shootsound = null
	var/shots_per_shoot = 1
	var/maxammo = 10
	var/ammo = 10
	var/chargeTime = 0

/obj/item/toy/toy_mech/ranged/New()
	..()
	if(chargeTime)
		SSobj.processing |= src

/obj/item/toy/toy_mech/ranged/process()
	if(!on || !chargeTime)
		return
	if(chargeTime <= 1)
		chargeTime = initial(chargeTime)
		if(ammo < maxammo)
			ammo++
			if(remote)
				remote.update_dialogue()
	else
		chargeTime--

/obj/item/toy/toy_mech/ranged/reset()
	ammo = maxammo
	chargeTime = initial(chargeTime)
	..()

/obj/item/toy/toy_mech/ranged/mech_attack(shot = 0)
	if(!on || (!shot && !mech_can_attack()) || !isturf(loc))
		return
	if(!projectiletype || ammo <= 0)
		return
	needs_reset = 1
	ammo --
	visible_message("<span class='warning'>[src] fires its [weapon_name]</span>")
	if(shootsound)
		playsound(src, shootsound, 40, 1)
	var/obj/item/projectile/P = new projectiletype(loc)
	P.current = loc
	P.starting = loc
	P.dumbfire(dir)
	newtonian_move(turn(dir, 180)) //I don't know why the toys are in space but hey realism
	if(remote)
		remote.update_dialogue()
	shot++
	if(shot < shots_per_shoot)
		addtimer(src, "mech_attack", 2, FALSE, shot)

/obj/item/toy/toy_mech/ranged/get_extra_controls(topic_ref)
	var/dat = ..()
	dat += " ([ammo]/[maxammo])"
	return dat

//////////////////////////////////////

/obj/item/toy/toy_mech/melee/ripley
	name = "toy Ripley"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 1/12."
	attackdamage = 15
	attacksound = 'sound/weapons/drill.ogg'
	weapon_name = "Mining Drill"

//////////////////////////////////////

/obj/item/toy/toy_mech/melee/deathripley
	name = "toy deathsquad Ripley"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 2/12."
	icon_state = "deathripleytoy"
	health = 35
	maxhealth = 35
	attackdamage = 20
	attacksound = 'sound/weapons/punch4.ogg'
	weapon_name = "KILL CLAMP"

//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/gygax
	name = "toy Gygax"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 3/12."
	icon_state = "gygaxtoy"
	health = 35
	maxhealth = 35
	weapon_name = "Solaris Laser Cannon"
	attack_cd = 15
	projectiletype = /obj/item/projectile/toy_mech/beam
	shootsound = 'sound/weapons/sear.ogg'
	maxammo = 10
	ammo = 10
	chargeTime = 4
	var/running = 0
	var/leg_damage_counter = 4

/obj/item/toy/toy_mech/ranged/gygax/get_extra_controls(topic_ref)
	var/dat = ..()
	dat += "<br>Leg Actuator Overload: <A HREF='?src=\ref[topic_ref];special=legs'>[running ? "on" : "off"]</A>"
	return dat

/obj/item/toy/toy_mech/ranged/gygax/mech_move(dir)
	if(..() && running)
		if(health <= 1)
			toggle_running()
		else
			if(leg_damage_counter <= 1)
				mech_take_damage(1)
				leg_damage_counter = initial(leg_damage_counter)
			else
				leg_damage_counter--

/obj/item/toy/toy_mech/ranged/gygax/special_action(action)
	..()
	if(action == "legs")
		toggle_running()

/obj/item/toy/toy_mech/ranged/gygax/reset()
	leg_damage_counter = initial(leg_damage_counter)
	if(running)
		toggle_running()
	..()

/obj/item/toy/toy_mech/ranged/gygax/proc/toggle_running()
	if(!on)
		return
	if(health <= 1 && !running)
		return
	needs_reset = 1
	running = !running
	move_delay = running ? 2 : 5
	if(remote)
		remote.update_dialogue()


//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/marauder
	name = "toy Marauder"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 4/12."
	icon_state = "marauderprize"
	health = 40
	maxhealth = 40
	weapon_name = "Ultra AC 2"
	attack_cd = 20
	projectiletype = /obj/item/projectile/toy_mech/bullet
	shootsound = 'sound/weapons/pierce.ogg'
	shots_per_shoot = 3
	maxammo = 50
	ammo = 50

//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/mauler
	name = "toy Mauler"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 5/12."
	icon_state = "maulerprize"
	health = 40
	maxhealth = 40
	weapon_name = "Ultra AC 2"
	attack_cd = 20
	projectiletype = /obj/item/projectile/toy_mech/bullet
	shootsound = 'sound/weapons/pierce.ogg'
	shots_per_shoot = 3
	maxammo = 50
	ammo = 50

//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/seraph
	name = "toy Seraph"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 6/12."
	icon_state = "seraphprize"
	health = 40
	maxhealth = 40
	weapon_name = "Ultra AC 2"
	attack_cd = 20
	projectiletype = /obj/item/projectile/toy_mech/bullet
	shootsound = 'sound/weapons/pierce.ogg'
	shots_per_shoot = 3
	maxammo = 50
	ammo = 50

//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/durand
	name = "toy Durand"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 7/12."
	icon_state = "durandprize"
	health = 50
	maxhealth = 50
	weapon_name = "Hades Carbine"
	move_delay = 7
	attack_cd = 10
	projectiletype = /obj/item/projectile/toy_mech/medbullet
	shootsound = 'sound/weapons/pierce.ogg'
	shots_per_shoot = 2
	maxammo = 40
	ammo = 40

//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/phazon
	name = "toy Phazon"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 8/12."
	icon_state = "phazonprize"
	health = 35
	maxhealth = 35
	weapon_name = "Solaris Laser Cannon"
	attack_cd = 15
	projectiletype = /obj/item/projectile/toy_mech/beam
	shootsound = 'sound/weapons/sear.ogg'
	maxammo = 10
	ammo = 10
	chargeTime = 4
	var/phasing = 0
	var/phasecharge = 5

/obj/item/toy/toy_mech/ranged/phazon/New()
	..()
	SSobj.processing |= src

/obj/item/toy/toy_mech/ranged/phazon/reset()
	phasecharge = initial(phasecharge)
	if(phasing)
		toggle_phasing()
	..()

/obj/item/toy/toy_mech/ranged/phazon/get_extra_controls(topic_ref)
	var/dat = ..()
	dat += "<br>Phase Module: <A HREF='?src=\ref[topic_ref];special=phase'>[phasing ? "on" : "off"]</A>([round(phasecharge, 1)]/[initial(phasecharge)])"
	return dat

/obj/item/toy/toy_mech/ranged/phazon/process()
	if(phasecharge < initial(phasecharge))
		phasecharge = min(phasecharge + 0.25, initial(phasecharge))
		if(remote)
			remote.update_dialogue()
	return ..()

/obj/item/toy/toy_mech/ranged/phazon/special_action(action)
	..()
	if(action == "phase")
		toggle_phasing()

/obj/item/toy/toy_mech/ranged/phazon/equipped(mob/user, slot)
	..()
	if(phasing)
		toggle_phasing()

/obj/item/toy/toy_mech/ranged/phazon/mech_move(dir)
	if((..() == 1) && phasing)
		if(phasecharge < 1)
			toggle_phasing()
		else
			phasecharge--

/obj/item/toy/toy_mech/ranged/phazon/mech_take_damage(amount)
	..()
	if(phasing && !on)
		toggle_phasing()

/obj/item/toy/toy_mech/ranged/phazon/proc/toggle_phasing()
	needs_reset = 1
	if(!phasing && (!on || phasecharge < 1 || !isturf(loc)) )
		return
	phasing = !phasing
	if(phasing)
		pass_flags |= (PASSGRILLE|PASSGLASS)
		alpha = 180
	else
		pass_flags &= ~(PASSGRILLE|PASSGLASS)
		alpha = 255

//////////////////////////////////////

/obj/item/toy/toy_mech/ranged/reticence
	name = "toy Reticence"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 9/12."
	icon_state = "reticenceprize"
	quiet = 1
	weapon_name = "Quietus Carbine"
	attack_cd = 30
	move_delay = 3
	projectiletype = /obj/item/projectile/toy_mech/bigbullet
	shootsound = 'sound/weapons/Gunshot_silenced.ogg'
	shots_per_shoot = 1
	maxammo = 15
	ammo = 15
	var/stealthed = 0
	var/stealthcharge = 10
	var/image/stealthSeeingImage = null
	var/list/stealthSeeingMobs = null

/obj/item/toy/toy_mech/ranged/reticence/New()
	..()
	SSobj.processing |= src

/obj/item/toy/toy_mech/ranged/reticence/reset()
	stealthcharge = initial(stealthcharge)
	if(stealthed)
		toggle_stealth()
	..()

/obj/item/toy/toy_mech/ranged/reticence/get_extra_controls(topic_ref)
	var/dat = ..()
	dat += "<br>Stealth: <A HREF='?src=\ref[topic_ref];special=stealth'>[stealthed ? "on" : "off"]</A>([round(stealthcharge, 1)]/[initial(stealthcharge)])"
	return dat

/obj/item/toy/toy_mech/ranged/reticence/process()
	if(on)
		if(stealthed)
			stealthcharge -= 0.5
			if(stealthcharge <= 0)
				toggle_stealth()
			if(remote)
				remote.update_dialogue()
		else if(stealthcharge < initial(stealthcharge))
			stealthcharge = min(stealthcharge + 0.25, initial(stealthcharge))
			if(remote)
				remote.update_dialogue()
	return ..()

/obj/item/toy/toy_mech/ranged/reticence/special_action(action)
	..()
	if(action == "stealth")
		toggle_stealth()

/obj/item/toy/toy_mech/ranged/reticence/equipped(mob/user, slot)
	..()
	if(stealthed)
		toggle_stealth()

/obj/item/toy/toy_mech/ranged/reticence/mech_take_damage(amount)
	..()
	if(stealthed && amount > 0)
		toggle_stealth()

/obj/item/toy/toy_mech/ranged/reticence/proc/toggle_stealth()
	needs_reset = 1
	if(!stealthed && (!on || stealthcharge <= 0 || !isturf(loc)) )
		return
	stealthed = !stealthed
	if(stealthed)
		stealthSeeingMobs = list()
		if(remote && remote.popup && remote.popup.user)
			stealthSeeingMobs += remote.popup.user
		stealthSeeingImage = image(icon, src, icon_state)
		stealthSeeingImage.override = 1
		stealthSeeingImage.appearance_flags = RESET_ALPHA
		for(var/V in stealthSeeingMobs)
			var/mob/M = V
			if(M.client)
				M.client.images += stealthSeeingImage
		animate(stealthSeeingImage, alpha = 128, time = 20)
		animate(src, alpha = 20, time = 20)
	else
		for(var/V in stealthSeeingMobs)
			var/mob/M = V
			if(M && M.client)
				M.client.images -= stealthSeeingImage
		stealthSeeingMobs = null
		animate(src, alpha = 255, time = 20)


//////////////////////////////////////

/obj/item/toy/toy_mech/odysseus
	name = "toy Odysseus"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 10/12."
	icon_state = "odysseusprize"
	weapon_name = "Health Scanner"
	attack_cd = 10

/obj/item/toy/toy_mech/odysseus/mech_attack()
	if(!mech_can_attack())
		return
	var/mob/living/target = locate(/mob/living) in get_step(src, dir)
	if(!target)
		return
	if(iscarbon(target))
		var/list/diagnosis = list()
		var/msg = "<span class='notice'>[target] is [round(target.health/target.maxHealth*100)]% healthy"
		if(target.getFireLoss())
			diagnosis += "[(target.getFireLoss() > target.maxHealth * 0.3) ? "heavy" : "light"] burns"
		if(target.getBruteLoss())
			diagnosis += "[(target.getBruteLoss() > target.maxHealth * 0.3) ? "heavy" : "light"] bruising"
		if(target.getToxLoss())
			diagnosis += "[(target.getToxLoss() > target.maxHealth * 0.3) ? "high" : "low"] toxin levels"
		if(target.getOxyLoss())
			diagnosis += "[(target.getOxyLoss() > target.maxHealth * 0.3) ? "severe" : "slight"] asphyxiation"

		if(diagnosis.len)
			msg += " and is suffering from [english_list(diagnosis)]"
		msg += ".</span>"
		say(msg)
	else
		if(target.maxHealth)
			say("<span class='notice'>[target] is [round(target.health/target.maxHealth*100)]% healthy.</span>")

//////////////////////////////////////

/obj/item/toy/toy_mech/fireripley
	name = "toy firefighting Ripley"
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 11/12."
	icon_state = "fireripleytoy"
	attack_cd = 30
	weapon_name = "Fire Extinguisher"
	var/obj/item/weapon/extinguisher/mini/toy_mech/extinguisher

/obj/item/toy/toy_mech/fireripley/New()
	..()
	extinguisher = new /obj/item/weapon/extinguisher/mini/toy_mech(src)
	extinguisher.name = name

/obj/item/toy/toy_mech/fireripley/Destroy()
	qdel(extinguisher)
	extinguisher = null
	return ..()

/obj/item/toy/toy_mech/fireripley/get_extra_controls(topic_ref)
	var/dat = ..()
	dat += " ([round(extinguisher.reagents.total_volume)] / [extinguisher.max_water])"
	return dat

/obj/item/toy/toy_mech/fireripley/mech_attack()
	if(!mech_can_attack())
		return
	if(extinguisher.reagents.total_volume >= 1)
		newtonian_move(turn(dir, 180))
	extinguisher.afterattack(get_step(src, dir), null, 1)
	if(remote)
		remote.update_dialogue()

/obj/item/toy/toy_mech/fireripley/afterattack(atom/target, mob/user, proximity)
	if(extinguisher)
		var/result = extinguisher.afterattack(target, user, proximity)
		if(remote)
			remote.update_dialogue()
		return result
	return ..()

/obj/item/toy/toy_mech/fireripley/examine(mob/user)
	..()
	if(extinguisher)
		user << "The water meter reads [round(extinguisher.reagents.total_volume)] / [extinguisher.max_water]"

/obj/item/weapon/extinguisher/mini/toy_mech
	name = "toy mech extinguisher"
	max_water = 10
	safety = 0
	power = 1
	wide = 0

//////////////////////////////////////
/obj/item/toy/toy_mech/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha remote-controlled action figure! Collect them all! 12/12."
	icon_state = "honkprize"
	weapon_name = "H.O.N.K.E.R. BLAST"
	health = 40
	maxhealth = 40
	attack_cd = 20

/obj/item/toy/toy_mech/honk/mech_attack()
	if(!mech_can_attack())
		return
	playsound(src, 'sound/items/bikehorn.ogg', 50, 1)

/*
 * Projectiles
 */

/obj/item/projectile/toy_mech
	range = 8

/obj/item/projectile/toy_mech/on_hit(atom/target, blocked = 0, hit_zone)
	qdel(src)

/obj/item/projectile/toy_mech/Bump()
	qdel(src)

/obj/item/projectile/toy_mech/Move()
	if(loc != starting)
		var/obj/item/toy/toy_mech/target = get_living_toy_mech(loc)
		if(target)
			target.visible_message("<span class='warning'>[target] is hit by \a [src]!</span>")
			target.mech_take_damage(damage)
			qdel(src)
			return
	..()

/obj/item/projectile/toy_mech/beam
	name = "toy laser beam"
	icon_state = "scatterlaser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 10

/obj/item/projectile/toy_mech/bullet
	name = "toy bullet"
	icon_state = "bullet"
	damage = 5

/obj/item/projectile/toy_mech/medbullet
	name = "toy bullet"
	icon_state = "bullet"
	damage = 10

/obj/item/projectile/toy_mech/bigbullet
	name = "toy bullet"
	icon_state = "bullet"
	damage = 25

/*
 * Helper procs
 */

/proc/get_living_toy_mech(turf/turf)
	if(!turf)
		return null
	var/obj/item/toy/toy_mech/highest = null
	for(var/obj/item/toy/toy_mech/mech in turf)
		if(mech.on)
			highest = mech
	return highest

/*
 * Spawner
 */

/obj/effect/spawner/lootdrop/toy_mech
	name = "random toy mech spawner"
	loot = list(
				/obj/item/toy/toy_mech/melee/ripley = 3,
				/obj/item/toy/toy_mech/melee/deathripley = 2,
				/obj/item/toy/toy_mech/ranged/gygax = 2,
				/obj/item/toy/toy_mech/ranged/marauder = 2,
				/obj/item/toy/toy_mech/ranged/mauler = 2,
				/obj/item/toy/toy_mech/ranged/seraph = 2,
				/obj/item/toy/toy_mech/ranged/durand = 2,
				/obj/item/toy/toy_mech/ranged/phazon = 1,
				/obj/item/toy/toy_mech/ranged/reticence = 1,
				/obj/item/toy/toy_mech/odysseus = 1,
				/obj/item/toy/toy_mech/fireripley = 1,
				/obj/item/toy/toy_mech/honk = 1
				)