#define PRESHOT "preShot"
#define PREDAMAGE "preDamage"
#define AFTERDAMAGE "afterDamage"
/obj/item/weapon/gun/energy/kinetic_accelerator
	name = "kinetic accelerator"
	desc = "A self recharging, ranged mining tool that does increased damage in low pressure."
	icon_state = ""
	item_state = "kineticgun"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic)
	cell_type = /obj/item/weapon/stock_parts/cell/emproof
	// Apparently these are safe to carry? I'm sure goliaths would disagree.
	needs_permit = 0
	var/overheat_time = 16
	unique_rename = 1
	can_flashlight = 1
	origin_tech = "combat=3;powerstorage=3;engineering=3"
	weapon_weight = WEAPON_LIGHT
	var/hasPS //preShot
	var/hasPD //preDamage
	var/hasAD //afterDamage
	var/holds_charge = FALSE
	var/unique_frequency = FALSE // modified by KA modkits
	var/overheat = FALSE
	var/core_icon_state
	var/image/core_overlay
	var/shots = 1
	var/list/parts = list(
	"barrel" = /obj/item/kinetic_part/barrel,
	"barrel_end" = /obj/item/kinetic_part/barrel_end,
	"core" = /obj/item/kinetic_part/core,
	"charger" = /obj/item/kinetic_part/charger,
	"grip" = /obj/item/kinetic_part/grip
	)

/obj/item/weapon/gun/energy/kinetic_accelerator/New()
	..()
	buildParts()
	update_icons()
	updateParts()


/obj/item/weapon/gun/energy/kinetic_accelerator/proc/buildParts()
	for(var/A in parts)
		var/obj/item/kinetic_part/KP = parts[A]
		if(KP)
			parts[A] = new KP(src)

/obj/item/kinetic_part/afterattack(obj/item/weapon/gun/energy/kinetic_accelerator/KA,mob/user)
	if(istype(KA, /obj/item/weapon/gun/energy/kinetic_accelerator))
		playsound(user, 'sound/machines/click.ogg', 60, 1)
		user.changeNext_move(CLICK_CD_MELEE)
		KA.switchPart(src,user)
	else
		..()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/switchPart(obj/item/kinetic_part/KP, mob/user)
	if(!KP)
		return
	var/obj/item/kinetic_part/KPOLD = parts[KP.part]
	KPOLD.forceMove(get_turf(src))
	parts[KP.part] = KP
	if(user)
		user.unEquip(KP)
	KP.forceMove(src)
	update_icons()
	updateParts()
	if(user)
		user.put_in_active_hand(KPOLD)
		user << "<span class='notice'>You switch the [KPOLD.name] out with the [KP.name].</span>"
	KPOLD.detach(src,user)
	KP.attach(src,user)
	empty()
	attempt_reload()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/updateParts()
	overheat_time = getPartsCooldown()
	update_icons()
	var/image/off = image('icons/obj/guns/kinetic.dmi',"[core_icon_state]_off")
	core_overlay = off
	hasPS = FALSE
	hasPD = FALSE
	hasAD = FALSE
	var/obj/item/kinetic_part/charger/charger = parts["charger"]
	shots = charger.shots
	power_supply.maxcharge = 500*shots
	for(var/obj/item/kinetic_part/KP in contents)
		if(KP.PS)
			hasPS = TRUE
		if(KP.PD)
			hasPD = TRUE
		if(KP.AD)
			hasAD = TRUE

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/update_icons()
	overlays.Cut()
	var/list/part_obj = list()
	for(var/a in parts)
		if(parts[a])
			part_obj += parts[a]
	for(var/obj/item/kinetic_part/KP in part_obj)
		var/image/KI = image(icon_state = KP.icon_state, icon = KP.icon)
		if(istype(KP, /obj/item/kinetic_part/core))
			core_overlay = KI
			core_icon_state = KI.icon_state
		else if(istype(KP, /obj/item/kinetic_part/barrel_end))
			var/obj/item/kinetic_part/barrel/B = parts["barrel"]
			KI.pixel_x = B.pixel_x_extra
			KI.pixel_y = B.pixel_y_extra
		overlays += KI

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/prepare_projectile(obj/item/projectile/kinetic/K,mob/user)
	K.gun = src
	K.damage = getPartsDamage()
	K.range = getPartsRange()
	var/turf/proj_turf = get_turf(K)
	if(!istype(proj_turf, /turf))
		return
	var/datum/gas_mixture/environment = proj_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure > 49)
		K.name = "weakened kinetic force"
		K.damage *= 0.25
	K.specialShot(PRESHOT,src,user)

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/getPartsDamage()
	var/totalDamage = 0
	for(var/obj/item/kinetic_part/KP in contents)
		totalDamage += KP.damageBonus
	return totalDamage

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/getPartsRange()
	var/totalRange = 0
	for(var/obj/item/kinetic_part/KP in contents)
		totalRange += KP.rangeBonus
	return totalRange

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/getPartsCooldown()
	var/totalCooldown = 0
	for(var/obj/item/kinetic_part/KP in contents)
		totalCooldown += KP.cooldownBonus
	return totalCooldown

/obj/item/kinetic_part
	name = "kinetic part"
	icon_state = ""
	icon = 'icons/obj/guns/kinetic.dmi'
	var/rank = "standard"
	var/part              //"barrel","barrel_end","core","charger","grip"
	var/pixel_x_extra = 0  //If you make a part thats longer then the original, please write down how much pixels longer. Mainly for use in barrel and
	var/pixel_y_extra = 0           //barel end

	var/damageBonus = 0  //All parts' damageBonus combined will be the actual damage.
	var/rangeBonus = 0
	var/cooldownBonus = 0 //Normal KA is 16, the lower the better

	var/datum/kinetic/preShot/PS //Right after we give the projectile its damage, it hasnt left the gun yet.
	var/datum/kinetic/preDamage/PD //The projectile hit our target, but hasnt done any damage yet
	var/datum/kinetic/afterDamage/AD //The damage has been done

/obj/item/kinetic_part/proc/attach(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	return

/obj/item/kinetic_part/proc/detach(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	return


//Standard
/obj/item/kinetic_part/barrel
	name = "standard barrel"
	icon_state = "barrel_standard"
	rank = "standard"
	part = "barrel"
	damageBonus = 10
	rangeBonus = 2
	cooldownBonus = 2

/obj/item/kinetic_part/barrel_end
	name = "standard barrel end"
	icon_state = "barrel_end_standard"
	rank = "standard"
	part = "barrel_end"
	damageBonus = 25

/obj/item/kinetic_part/core
	name = "kinetic core"
	icon_state = "core_kinetic"
	rank = "standard"
	part = "core"
	damageBonus = 2
	cooldownBonus = 2

/obj/item/kinetic_part/charger
	name = "standard charger"
	icon_state = "charger_standard"
	rank = "standard"
	part = "charger"
	cooldownBonus = 10
	var/shots = 1

/obj/item/kinetic_part/grip
	name = "standard grip"
	icon_state = "grip_standard"
	rank = "standard"
	part = "grip"
	rangeBonus = 1
	cooldownBonus = 2
	damageBonus = 3

//Super

/obj/item/kinetic_part/barrel/super
	name = "super barrel"
	icon_state = "barrel_super"
	rank = "super"
	part = "barrel"
	damageBonus = 12
	rangeBonus = 3
	cooldownBonus = 2

/obj/item/kinetic_part/barrel_end/super
	name = "super barrel end"
	icon_state = "barrel_end_super"
	rank = "super"
	part = "barrel_end"
	damageBonus = 30

/obj/item/kinetic_part/charger/super
	name = "super charger"
	icon_state = "charger_super"
	rank = "super"
	part = "charger"
	cooldownBonus = 8

/obj/item/kinetic_part/grip/super
	name = "super grip"
	icon_state = "grip_super"
	rank = "super"
	part = "grip"
	rangeBonus = 1
	cooldownBonus = 1
	damageBonus = 4

//Special

/obj/item/kinetic_part/barrel/splash
	name = "spread barrel"
	desc = "Destroys rocks in a 3x3 area. The perfect tool for mining."
	icon_state = "barrel_spread"
	rank = "special"
	part = "barrel"
	damageBonus = 12
	rangeBonus = 3
	cooldownBonus = 4
	pixel_x_extra = 1
	AD = new /datum/kinetic/afterDamage/splash()

/obj/item/kinetic_part/barrel_end/shotgun
	name = "shotgun barrel end"
	icon_state = "barrel_end_shotgun"
	desc = "Extremely powerful, but comes at the cost of range."
	rank = "special"
	part = "barrel_end"
	damageBonus = 50
	rangeBonus = -2

/obj/item/kinetic_part/grip/wide
	name = "wide grip"
	desc = "Has a wider grip for people with big hands."
	icon_state = "grip_wide"
	rank = "special"

/obj/item/kinetic_part/grip/wide/attach(obj/item/weapon/gun/energy/kinetic_accelerator/KA,mob/user)
	KA.weapon_weight = WEAPON_MEDIUM
	KA.trigger_guard = TRIGGER_GUARD_ALLOW_ALL

/obj/item/kinetic_part/grip/wide/detach(obj/item/weapon/gun/energy/kinetic_accelerator/KA,mob/user)
	KA.weapon_weight = WEAPON_LIGHT
	KA.trigger_guard = TRIGGER_GUARD_NORMAL

/obj/item/kinetic_part/charger/double_shot
	name = "double charger"
	icon_state = "charger_double"
	rank = "special"
	part = "charger"
	cooldownBonus = 25
	shots = 2

//Ancient

/obj/item/kinetic_part/core/vampiric
	name = "vampiric core"
	desc = "An ancient cursed core."
	icon_state = "core_vampiric"
	rank = "ancient"
	var/leach = 1  //Amount we heal the user for every shot
	AD = new/datum/kinetic/afterDamage/vampiric()

/obj/item/kinetic_part/charger/triple_shot
	name = "triple charger"
	desc = "An ancient charger"
	icon_state = "charger_triple"
	rank = "ancient"
	part = "charger"
	cooldownBonus = 35
	shots = 3



/datum/kinetic/proc/Trigger()

/datum/kinetic/preShot/Trigger(obj/item/weapon/gun/energy/kinetic_accelerator/KA,obj/item/projectile/kinetic/K,mob/user,obj/item/kinetic_part/KP)

/datum/kinetic/preDamage/Trigger(obj/item/weapon/gun/energy/kinetic_accelerator/KA,obj/item/projectile/kinetic/K,mob/firer,turf/T,obj/item/kinetic_part/KP)

/datum/kinetic/afterDamage/Trigger(obj/item/weapon/gun/energy/kinetic_accelerator/KA,obj/item/projectile/kinetic/K,mob/firer,atom/target,obj/item/kinetic_part/KP)

/datum/kinetic/afterDamage/splash/Trigger(obj/item/weapon/gun/energy/kinetic_accelerator/KA,obj/item/projectile/kinetic/K,mob/firer,atom/target)
	for(var/turf/T in range(1, get_turf(target)))
		if(istype(T, /turf/closed/mineral))
			var/turf/closed/mineral/M = T
			M.gets_drilled(firer)


/datum/kinetic/afterDamage/vampiric/Trigger(obj/item/weapon/gun/energy/kinetic_accelerator/KA,obj/item/projectile/kinetic/K,mob/firer,atom/target,obj/item/kinetic_part/core/vampiric/KP)
	if(isliving(firer) && isliving(target))
		var/mob/living/L = firer
		L.heal_overall_damage(KP.leach,KP.leach)


/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 10
	damage_type = BRUTE
	flag = "bomb"
	range = 3
	var/gun

/obj/item/projectile/kinetic/proc/specialShot(var/when,obj/item/weapon/gun/energy/kinetic_accelerator/KA,mob/user,atom/target)
	if(!KA.hasPS && !KA.hasPD && !KA.hasAD)
		return 0
	switch(when)
		if(PRESHOT)
			if(KA.hasPS)
				for(var/obj/item/kinetic_part/KP in KA.contents)
					if(!KP.PS)
						continue
					var/datum/kinetic/preShot/D = KP.PS
					D.Trigger(KA,src,user,KP) //No way of knowing what it will hit, so no target
		if(PREDAMAGE)
			if(KA.hasPD)
				for(var/obj/item/kinetic_part/KP in KA.contents)
					if(!KP.PD)
						continue
					var/datum/kinetic/preDamage/D = KP.PD
					D.Trigger(KA,src,user,target,KP)
		if(AFTERDAMAGE)
			if(KA.hasAD)
				for(var/obj/item/kinetic_part/KP in KA.contents)
					if(!KP.AD)
						continue
					var/datum/kinetic/afterDamage/D = KP.AD
					D.Trigger(KA,src,user,target,KP)


/obj/item/projectile/kinetic/on_range()
	new /obj/effect/kinetic_blast(src.loc)
	..()

/obj/item/projectile/kinetic/prehit()
	specialShot(PREDAMAGE,gun,firer,get_turf(src))

/obj/item/projectile/kinetic/on_hit(atom/target)
	. = ..()
	var/turf/target_turf= get_turf(target)
	if(istype(target_turf, /turf/closed/mineral))
		var/turf/closed/mineral/M = target_turf
		M.gets_drilled(firer)
	new /obj/effect/kinetic_blast(target_turf)
	specialShot(AFTERDAMAGE,gun,firer,target)

/obj/effect/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/kinetic_blast/New()
	spawn(4)
		qdel(src)


/obj/item/ammo_casing/energy/kinetic
	projectile_type = /obj/item/projectile/kinetic
	select_name = "kinetic"
	e_cost = 500
	fire_sound = 'sound/weapons/Kenetic_accel.ogg' // fine spelling there chap

/obj/item/ammo_casing/energy/kinetic/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	..()
	if(loc && istype(loc, /obj/item/weapon/gun/energy/kinetic_accelerator))
		var/obj/item/weapon/gun/energy/kinetic_accelerator/KA = loc
		KA.prepare_projectile(BB,user)


/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg
	holds_charge = TRUE
	unique_frequency = TRUE

/obj/item/weapon/gun/energy/kinetic_accelerator/hyper/cyborg
	holds_charge = TRUE
	unique_frequency = TRUE

/obj/item/weapon/gun/energy/kinetic_accelerator/New()
	. = ..()
	if(!holds_charge)
		empty()

/obj/item/weapon/gun/energy/kinetic_accelerator/shoot_live_shot()
	. = ..()
	addtimer(src,"attempt_reload",1)

/obj/item/weapon/gun/energy/kinetic_accelerator/equipped(mob/user)
	. = ..()
	if(!can_shoot())
		attempt_reload()

/obj/item/weapon/gun/energy/kinetic_accelerator/dropped()
	. = ..()
	if(!holds_charge)
		// Put it on a delay because moving item from slot to hand
		// calls dropped()
		addtimer(src, "empty_if_not_held", 2)

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/empty_if_not_held()
	if(!ismob(loc))
		empty()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/empty()
	power_supply.use(power_supply.charge)
	update_icon()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/attempt_reload()
	if(overheat || power_supply.charge)
		return
	overheat = TRUE

	var/carried = 0
	if(!unique_frequency)
		for(var/obj/item/weapon/gun/energy/kinetic_accelerator/K in \
			loc.GetAllContents())

			carried++

		carried = max(carried, 1)
	else
		carried = 1

	addtimer(src, "reload", overheat_time * carried)

/obj/item/weapon/gun/energy/kinetic_accelerator/emp_act(severity)
	return

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/reload()
	power_supply.give(power_supply.maxcharge)
	if(!suppressed)
		playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	else
		loc << "<span class='warning'>[src] silently charges up.<span>"
	update_icon()
	overheat = FALSE

/obj/item/weapon/gun/energy/kinetic_accelerator/suicide_act(mob/user)
	if(!suppressed)
		playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	user.visible_message("<span class='suicide'>[user] cocks the [src.name] and pretends to blow \his brains out! It looks like \he's trying to commit suicide!</b></span>")
	shoot_live_shot()
	return (OXYLOSS)


/obj/item/weapon/gun/energy/kinetic_accelerator/update_icon()
	if(!can_shoot())
		overlays.Add(core_overlay)
	else
		overlays.Remove(core_overlay)


#undef PRESHOT
#undef PREDAMAGE
#undef AFTERDDAMAGE
