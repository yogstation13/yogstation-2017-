#define _POWER_USAGE 10 // 10 is good for per lamp for now, hopefully..

/obj/machinery/flood_lamp
	name = "Flood Lamp"
	desc = "A huge and powerful lamp, great for illuminating spaces for mining."

	icon = 'icons/obj/floodlamp.dmi'
	icon_state = "flood000"

	density = 1

	var/list/flashlights = list();
	var/opened = 0
	var/obj/item/weapon/stock_parts/cell/cell
	var/on = 0

obj/machinery/flood_lamp/New()
	..()
	update_all()

obj/machinery/flood_lamp/proc/update_all()
	update_appearance()
	update_brightness()

obj/machinery/flood_lamp/proc/update_appearance()
	overlays.Cut()
	icon_state = "flood[opened][(opened && istype(cell)) ? 1 : 0][on]"
	if(flashlights.len < 3)
		overlays += image(icon,"empty[flashlights.len]")


obj/machinery/flood_lamp/proc/update_brightness()
	if(on)
		set_light(flashlights.len * 5)
	else
		set_light(0)

obj/machinery/flood_lamp/attack_hand(mob/living/carbon/user)
	if(opened && cell && istype(user))
		cell.loc = get_turf(src)
		user.put_in_active_hand(cell)
		cell.updateicon() // Ensure it has the correct sprite.
		cell = null
		on = 1 // Really stupid but also awesome way to force update the floodlamp. Toggle_light will then set the on to 0, and process.
	toggle_light()

obj/machinery/flood_lamp/process()
	if(istype(cell) && on)
		if(!cell.use(flashlights.len * _POWER_USAGE)) // If we run out of power, turn off. No Freebies bitches.
			on = 0
			update_all()

obj/machinery/flood_lamp/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/device/flashlight)&&flashlights.len<3)
		var/obj/item/device/flashlight/F = W
		if(F.on)
			F.attack_self(usr) // Ensure that the flashlight is off first.
		if(!usr.unEquip(W))
			return 0
		flashlights += W
		W.loc = src
		update_brightness()
	if(opened&&istype(W,/obj/item/weapon/stock_parts/cell)&&!istype(cell))
		if(!usr.unEquip(W))
			return 0
		cell = W
		W.loc = src
	if(istype(W,/obj/item/weapon/crowbar))
		opened = !opened
	if(istype(W,/obj/item/weapon/wirecutters))
		for(var/obj/item/device/flashlight/F in flashlights) // Other ways to just grab a random one and dump it?
			F.loc = loc
			flashlights -= F
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1, -1)
			update_all()
			return;
	update_appearance()

obj/machinery/flood_lamp/proc/toggle_light()
	if(on)
		on = 0
	else if (istype(cell) && cell.charge > flashlights.len * _POWER_USAGE) // We can't turn on if we don't have enough power.
		on = 1
	update_all()

//obj/machinery/flood_lamp/get_light_range(radius)
//		return radius // No cap on these things. Intentionally.

obj/machinery/flood_lamp/assembled
	New()
		cell = new/obj/item/weapon/stock_parts/cell/high(src)
		flashlights += new/obj/item/device/flashlight(src)
		flashlights += new/obj/item/device/flashlight(src)
		flashlights += new/obj/item/device/flashlight(src)
		..()


/obj/item/weapon/paper/flood_lamp
	name = "paper- 'Floodlamp Operation for Dummies'"
	info = "<b>How to Floodlamp</b><br><font size = '1'>A guide for dummies. That's you.</font><hr><ul><li>Crowbar open device.<li>Add power cell. Bigger is better.<li>Crowbar closed device.<li>Add up to 3 flashlights to device.<ul>"