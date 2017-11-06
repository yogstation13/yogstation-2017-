// later to be moved to the medical folder.
/obj/item/weapon/storage/handcooler
	name = "cooler"
	desc = "Could be useful in harvesting the kidneys you've stolen from your drugged date... or just keep your beer cold."
	w_class = 4
	force = 8
	throwforce = 4
	icon = 'icons/obj/organ_fridge.dmi'
	icon_state = "closed"
	item_state = "organ_fridge"
	burn_state = -1 // Won't burn. Yay!
	storage_slots = 2
	attack_verb = list("bashed", "smacked", "thrashed")
	hitsound = 'sound/weapons/smash.ogg'

/obj/item/weapon/storage/handcooler/cubicle // Possible researchable version.
	name = "cubicle"
	desc = "An advanced medical storage used for containing internal organs."
	can_hold = list(
		/obj/item/device/cubiclecooler,
		/obj/item/organ)

/obj/item/weapon/storage/handcooler/cubicle/proc/scancheck()
	for(var/obj/item/organ/O in src)
		if(O.loc == src)
			return 1
		else
			return 0 // this shouldn't ever happen. ever.

/obj/item/weapon/storage/handcooler/cubicle/content_can_dump(atom/dest_object, mob/user)
	return 0

/obj/item/weapon/storage/handcooler/cubicle/medi
	name = "medical cubicle"
	desc = "An advance medical storage used for containing and cooling internal organs, this one can only contain one organ at a time."

/obj/item/weapon/storage/handcooler/cubicle/medi/New()
	..()
	new /obj/item/device/cubiclecooler(src)

/obj/item/device/cubiclecooler
	name = "\improper Nanotrasen Cubicle Cooler"
	desc = "Keep it cool! This device keep organs from becoming spoiled. This is bolted quite tightly into the cubicle."
	icon = 'icons/obj/organ_fridge.dmi'
	icon_state = "cooler_off"
	item_state = "cooler_off"

	var/target_temp = T0C - 40
	var/cooling_power = 20
	var/process_cd = 150 // experimental value.


	var/obj/item/weapon/stock_parts/cell/high/ccell = null
	var/cellcost = 500
	var/obj/item/weapon/storage/handcooler/cubicle/container = null
	var/idle
	var/idlemsg
	var/chrgmsg

/obj/item/device/cubiclecooler/New()
	..()
	ccell = new(src)
	check_container()
	process()


/obj/item/device/cubiclecooler/proc/check_container()
	if(istype(src.loc, /obj/item/weapon/storage/handcooler/cubicle))
		container = src.loc

/obj/item/device/cubiclecooler/proc/UpdateIcon(seton, setoff)
	if(seton == 1)
		icon_state = "cooler_on"
		item_state = "cooler_on"
	else if (setoff == 1)
		icon_state = "cooler_off"
		item_state = "cooler_off"

/obj/item/device/cubiclecooler/process(iconchecked)
	if(!iconchecked)
		UpdateIcon(seton=1)
	if(src.loc == container)
		if(ccell.charge && !idle)
			var/processingorgans
			for(var/obj/item/organ/O in container)
				return_air()
				deductcharge(cellcost)
				container.audible_message("<span class='notice'>[container] slowly vibrates allowing a short and cold mist of air to creep out from it's lid.")
				playsound(src, 'sound/effects/space_wind.ogg', 50, 1)
				sleep(process_cd)
				processingorgans = 1
			if(!processingorgans)
				idleize()
				return
			process(iconchecked=1)
		else
			idleize()
	..()
/*
/obj/item/device/cubiclecooler/return_air()
	if(idle)	return idleize()
	var/datum/gas_mixture/gas = (..())
	if(!gas)	return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.oxygen = gas.oxygen
	newgas.carbon_dioxide = gas.carbon_dioxide
	newgas.nitrogen = gas.nitrogen
	newgas.toxins = gas.toxins
	newgas.volume = gas.volume
	newgas.temperature = gas.temperature
	if(newgas.temperature <= target_temp)	return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas */

/obj/item/device/cubiclecooler/proc/idleize()
	if(!idle) // so we don't go through this more than we have to.
		idle = 1
		UpdateIcon(setoff=1)
		container.audible_message("<span class='warning'>A small blinking light pierces out from the cubicle as a device makes a ping.</span>")
		playsound(loc, 'sound/machines/ping.ogg', 50, 0)
		idlemsg = "The [src] appears to be in an idle state."

	if(ccell)
		var/lowvalue = 1/3 * ccell.maxcharge
		if(ccell.charge <= lowvalue)
			chrgmsg = " There's a red bar indicating that the battery charge is low."

/obj/item/device/cubiclecooler/examine(mob/user)
	..()
	if(idle)
		to_chat(user, "[idlemsg]")
	if(chrgmsg)
		to_chat(user, "[chrgmsg]")

/obj/item/device/cubiclecooler/attack_hand(mob/user)
	to_chat(user, "<span class='warning'>It won't budge!</span>")
	return

/obj/item/device/cubiclecooler/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id))
		var/mob/living/carbon/human/M = user
		var/obj/item/weapon/card/id/ID = I
		I =  M.get_idcard()

		if((5 in ID.access))
			if(!idle)
				to_chat(usr, "<span class='notice'>You manually deactivate the cooler!</span>")
				idleize()
				return

			if(!ccell)
				to_chat(usr, "<span class='danger'>There isn't a cell inside of the cooler!</span>")
				return

			if(!ccell.charge)
				to_chat(usr, "span class='danger'>The cell inside of the cooler has ran out of power.</span>")
				idleize()
				return

			to_chat(usr, "<span class='notice'>You slide your ID in and out of the cooler, reactivating it.</span>")
			idle = !idle
			process()

		else
			to_chat(usr, "<span class='alert'>You do not have required levels to operate on the cooler.</span>")


	if(istype(I, /obj/item/weapon/screwdriver))
		if(ccell)
			ccell.loc = get_turf(src.loc)
			ccell = null
			to_chat(user, "<span class='notice'>You remove the cell from [src].</span>")
			return
		else
			to_chat(user, "<span class='danger'>There isn't a cell inside of the freezer</span>")

	else if(istype(I, /obj/item/weapon/stock_parts/cell))
		var/obj/item/weapon/stock_parts/cell/C = I
		if(ccell)
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else
			if(C.maxcharge < 1500) // number values. gross, how forced.
				to_chat(user, "<span class='notice'>[src] requires a higher capacity cell.</span>")
				return
			if(!user.unEquip(I))
				return
			I.loc = src
			ccell = I
			to_chat(user, "<span class='notice'>You install a cell in [src].</span>")

			if(!ccell.charge && !idlemsg)
				idlemsg = "The [src] appears to be in an idle state."
	..()


/obj/item/device/cubiclecooler/proc/deductcharge(chrgdeductamt) //copied from stunbaton.dm
	if(ccell)
		if(ccell.charge < (cellcost+chrgdeductamt)) // Turns off.
			playsound(loc, "sparks", 75, 1, -1)
			idleize()
		if(ccell.use(chrgdeductamt))
			return 1
		else
			return 0

/*
/obj/item/device/cubiclecooler/portable
	name = "\improper Portable Nanotrasen Cubicle Cooler"
	desc = "A more mobile model than the old one. This one is portable!"
	flags = null
	var/portable // tells whether or not it's inside of a cubicle
/obj/item/device/cubiclecooler/attackby(/obj/item/I, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/wrench))
		if(!portable)
			return
		flags = NODROP
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
*/

// Other variations:


/obj/item/weapon/storage/handcooler/cubicle/multi
	name = "multi-medi cubicle"
	desc = "An organ storage which is not so good for scanning, but it can keep organs from decaying."
	can_hold = list(
	/obj/item/organ)
	storage_slots = 7