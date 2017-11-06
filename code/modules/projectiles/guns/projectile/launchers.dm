//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/weapon/gun/projectile/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "A break-operated grenade launcher."
	name = "grenade launcher"
	icon_state = "dshotgun-sawn"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	w_class = 3
	pin = /obj/item/device/firing_pin/implant/pindicate

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/unrestricted
	pin = /obj/item/device/firing_pin

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/cyborg
	desc = "A 6-shot grenade launcher."
	name = "multi grenade launcher"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_grenadelnchr"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	pin = /obj/item/device/firing_pin
	actions_types = list(/datum/action/item_action/replicate_ammo)

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/cyborg/attack_self(mob/user)
	replicate_ammo(user)

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/cyborg/proc/replicate_ammo(mob/living/silicon/robot/syndicate/SR)
	if(magazine)
		if(!istype(SR))
			return
		var/ammo_count = get_ammo(0,0)
		if(ammo_count < magazine.max_ammo && SR && SR.cell)
			var/left_to_replicate = magazine.max_ammo-ammo_count
			to_chat(SR, "<span class='notice'>You start fabricating [left_to_replicate] [left_to_replicate > 1 ? "shells" : "shell"], you will need to stay still for this.</span>")
			for(var/i in 1 to magazine.max_ammo-ammo_count)
				if(do_after(SR, 60, target = SR))
					if(SR.cell.use(500))
						var/shell_to_load = new magazine.ammo_type()
						magazine.give_round(shell_to_load, 1)
						if(!chambered || !chambered.BB)
							chamber_round(0)
						left_to_replicate = magazine.max_ammo-ammo_count-i
						to_chat(SR, "<span class='notice'>[left_to_replicate > 0 ? "Grenade replicated, [left_to_replicate] more to go." : "Replication complete."]")
				else
					to_chat(SR, "<span class='notice'>Fabrication interrupted.")
					break
	else
		to_chat(SR, "<span class='notice'>You should never see this message.</span>")

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/cyborg/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/replicate_ammo)
		replicate_ammo(user)

/datum/action/item_action/replicate_ammo
	name = "Replicate Ammo"

/obj/item/weapon/gun/projectile/automatic/gyropistol
	name = "gyrojet pistol"
	desc = "A prototype pistol designed to fire self propelled rockets."
	icon_state = "gyropistol"
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	origin_tech = "combat=5"
	mag_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/weapon/gun/projectile/automatic/gyropistol/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/gyropistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "loaded" : ""]"

/obj/item/weapon/gun/projectile/automatic/speargun
	name = "kinetic speargun"
	desc = "A weapon favored by carp hunters. Fires specialized spears using kinetic energy."
	icon_state = "speargun"
	item_state = "speargun"
	w_class = 4
	origin_tech = "combat=4;engineering=4"
	force = 10
	can_suppress = 0
	mag_type = /obj/item/ammo_box/magazine/internal/speargun
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	burst_size = 1
	fire_delay = 0
	select = 0
	actions_types = list()

/obj/item/weapon/gun/projectile/automatic/speargun/update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/speargun/attack_self()
	return

/obj/item/weapon/gun/projectile/automatic/speargun/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/speargun/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] spear\s into \the [src].</span>")
		update_icon()
		chamber_round()