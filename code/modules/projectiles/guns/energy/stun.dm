/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "A low-capacity, energy-based stun gun used by security teams to subdue targets at range."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	origin_tech = "combat=3"
	ammo_x_offset = 3

/obj/item/weapon/gun/energy/tesla_revolver
	name = "tesla gun"
	desc = "An experimental gun based on an experimental engine, it's about as likely to kill its operator as it is the target."
	icon_state = "tesla"
	item_state = "tesla"
	ammo_type = list(/obj/item/ammo_casing/energy/tesla_revolver)
	origin_tech = "combat=4;materials=4;powerstorage=4"
	can_flashlight = 0
	pin = null
	shaded_charge = 1

/obj/item/weapon/gun/energy/e_gun/advtaser
	name = "hybrid taser"
	desc = "A dual-mode taser designed to fire both short-range high-power electrodes and long-range disabler beams."
	icon_state = "advtaser"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	origin_tech = "combat=4"
	ammo_x_offset = 2

/obj/item/weapon/gun/energy/e_gun/advtaser/cyborg
	name = "cyborg taser"
	desc = "An integrated hybrid taser that draws directly from a cyborg's power cell. The weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_flashlight = 0
	can_charge = 0
	use_cyborg_cell = 1
	var/recharge_time = 10

/obj/item/weapon/gun/energy/gun/advtaser/cyborg/New()
	..()
	START_PROCESSING(SSobj, src)


/obj/item/weapon/gun/energy/gun/advtaser/cyborg/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/gun/energy/gun/advtaser/cyborg/process() //Every [recharge_time] ticks, recharge a shot for the cyborg
	charge_tick++
	if(charge_tick < recharge_time) return 0
	charge_tick = 0

	if(!power_supply) return 0 //sanity
	robocharge()

	update_icon()

/obj/item/weapon/gun/energy/disabler
	name = "disabler"
	desc = "A self-defense weapon that exhausts organic targets, weakening them until they collapse."
	icon_state = "disabler"
	item_state = "combat=3"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 3

/obj/item/weapon/gun/energy/disabler/cyborg
	name = "cyborg disabler"
	desc = "An integrated disabler that draws from a cyborg's power cell. This weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_charge = 0
	use_cyborg_cell = 1
	var/recharge_time = 4


/obj/item/weapon/gun/energy/disabler/cyborg/New()
	..()
	START_PROCESSING(SSobj, src)


/obj/item/weapon/gun/energy/disabler/cyborg/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/gun/energy/disabler/cyborg/process() //Every [recharge_time] ticks, recharge a shot for the cyborg
	charge_tick++
	if(charge_tick < recharge_time) return 0
	charge_tick = 0

	if(!power_supply) return 0 //sanity
	robocharge()

	update_icon()


