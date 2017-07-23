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
	var/holds_charge = FALSE
	var/unique_frequency = FALSE // modified by KA modkits
	var/overheat = FALSE
	var/list/parts = list(
	"barrel" = new /obj/item/kinetic_part/barrel(),
	"barrel_end" = new /obj/item/kinetic_part/barrel_end(),
	"core" = new /obj/item/kinetic_part/core(),
	"charger" = new /obj/item/kinetic_part/charger(),
	"grip" = new /obj/item/kinetic_part/grip()
	)

/obj/item/weapon/gun/energy/kinetic_accelerator/New()
	..()
	update_icons()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/updateParts()
	overheat_time = getPartsCooldown()
	update_icons()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/update_icons()
	overlays.Cut()
	var/list/part_obj = list()
	for(var/a in parts)
		if(parts[a])
			part_obj += parts[a]
	for(var/obj/item/kinetic_part/KP in part_obj)
		var/image/KI = image(icon_state = KP.icon_state, icon = KP.icon)
		if(istype(KP, /obj/item/kinetic_part/barrel_end))
			var/obj/item/kinetic_part/barrel/B = parts["barrel"]
			KI.pixel_x = B.pixel_x_extra
			KI.pixel_y = B.pixel_y_extra
		overlays += KI

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/prepare_projectile(obj/item/projectile/kinetic/K)
	K.damage = getPartsDamage()
	K.range = getPartsRange()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/getPartsDamage()
	var/totalDamage = 0
	for(var/obj/item/kinetic_part/KP in parts)
		totalDamage += KP.damageBonus
	return totalDamage

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/getPartsRange()
	var/totalRange = 0
	for(var/obj/item/kinetic_part/KP in parts)
		totalRange += KP.rangeBonus
	return totalRange

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/getPartsCooldown()
	var/totalCooldown = 0
	for(var/obj/item/kinetic_part/KP in parts)
		totalCooldown += KP.cooldownBonus
	return totalCooldown

/obj/item/kinetic_part
	name = "kinetic part"
	icon_state = ""
	icon = 'icons/obj/guns/kinetic.dmi'
	var/rank = "standard"
	var/part              //"barrel","barrel_end","core","charger","grip"
	var/pixel_x_extra = 0  //If you make a part thats longer then the original, please write down how much pixels longer. Mainly for use in barrel and
	var/pixel_y_extra = 0           //barell end

	var/damageBonus = 0  //All parts' damageBonus combined will be the actual damage.
	var/rangeBonus = 0
	var/cooldownBonus = 0 //Normal KA is 16, the lower the better

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
	icon_state = "core_standard"
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

/obj/item/kinetic_part/grip
	name = "standard grip"
	icon_state = "grip_standard"
	rank = "standard"
	part = "charger"
	rangeBonus = 1
	cooldownBonus = 2
	damageBonus = 3


/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 10
	damage_type = BRUTE
	flag = "bomb"
	range = 3
	var/splash = 0

/obj/item/projectile/kinetic/on_range()

	new /obj/effect/kinetic_blast(src.loc)
	..()

/obj/item/projectile/kinetic/prehit()
	var/turf/proj_turf = get_turf(src)
	if(!istype(proj_turf, /turf))
		return
	var/datum/gas_mixture/environment = proj_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure > 49)
		name = "weakened kinetic force"
		damage *= 0.25

/obj/item/projectile/kinetic/on_hit(atom/target)
	. = ..()
	var/turf/target_turf= get_turf(target)
	if(istype(target_turf, /turf/closed/mineral))
		var/turf/closed/mineral/M = target_turf
		M.gets_drilled(firer)
	new /obj/effect/kinetic_blast(target_turf)
	if(src.splash)
		for(var/turf/T in range(splash, target_turf))
			if(istype(T, /turf/closed/mineral))
				var/turf/closed/mineral/M = T
				M.gets_drilled(firer)


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
		KA.prepare_projectile(BB)


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
	attempt_reload()

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
	power_supply.use(500)
	update_icon()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/attempt_reload()
	if(overheat)
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
	power_supply.give(500)
	if(!suppressed)
		playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	else
		loc << "<span class='warning'>[src] silently charges up.<span>"
	update_icon()
	overheat = FALSE

/obj/item/weapon/gun/energy/kinetic_accelerator/update_icon()
	if(!can_shoot())
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = initial(icon_state)
	if(F && can_flashlight)
		var/iconF = "flight"
		if(F.on)
			iconF = "flight_on"
		add_overlay(image(icon = icon, icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset))