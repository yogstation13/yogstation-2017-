/**********************Light************************/

//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light-emtter"
	anchored = 1
	unacidable = 1
	luminosity = 8

/**********************Miner Lockers**************************/

/obj/structure/closet/wardrobe/miner
	name = "mining wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/miner/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/dufflebag/engineering(src)
	new /obj/item/weapon/storage/backpack/industrial(src)
	new /obj/item/weapon/storage/backpack/satchel_eng(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "mining"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	new /obj/item/weapon/storage/box/emptysandbags(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/device/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/weapon/storage/bag/ore(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe/mini(src)
	new /obj/item/weapon/gun/energy/kinetic_accelerator(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/weapon/survivalcapsule(src)
	new /obj/item/stack/sheet/mineral/sandbags(src, 5)


/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon_state = "miningcar"


// ************************* Barometer! ******************************
// attack_self() is in weather.dm

/obj/item/device/barometer
	name = "barometer"
	desc = "A persistent device used for tracking weather and storm patterns. IN SPACE!"
	icon_state = "barometer"
	var/obj/machinery/lavaland_controller/controller // used to update the weather and such
	var/cooldown
	var/accuracy // 0 is the best accuracy.

/obj/item/device/barometer/New()
	..()
	barometers += src

/obj/item/device/barometer/Destroy()
	barometers -= src
	return ..()

/obj/item/device/barometer/proc/ping(time)
	spawn(time)
		if(isliving(loc))
			var/mob/living/L = loc
			L << "<span class='notice'>[src] is ready!</span>"
		playsound(get_turf(src), 'sound/machines/click.ogg', 100)

/obj/item/device/barometer/mining
	desc = "A special device used for tracking ash storms."

/obj/item/device/barometer/tribal
	desc = "A device handed down from ashwalker to ashwalker. This tool is used to speak with the wind, translate it's whispers, and figure out when a storm will hit."
	accuracy = 20

//Computer
/obj/item/device/gps/computer
	name = "pod computer"
	icon_state = "pod_computer"
	icon = 'icons/obj/lavaland/pod_computer.dmi'
	anchored = 1
	density = 1
	pixel_y = -32
	channel = "lavaland"

/obj/item/device/gps/computer/New()
	..()
	visible_message("[src] activates their tracking mechanism.")
	tracking = TRUE

/obj/item/device/gps/computer/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench) && !(flags&NODECONSTRUCT))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] disassembles the gps.</span>", \
						"<span class='notice'>You start to disassemble the gps...</span>", "You hear clanking and banging noises.")
		if(do_after(user, 20/W.toolspeed, target = src))
			new /obj/item/device/gps(src.loc)
			qdel(src)
			return ..()

/obj/item/device/gps/computer/attack_hand(mob/user)
	attack_self(user)

//Survival Storage Unit
/obj/machinery/smartfridge/survival_pod
	name = "survival pod storage"
	desc = "A heated storage unit."
	icon = 'icons/obj/lavaland/donkvendor.dmi'
	icon_on = "smartfridge"
	icon_off = "smartfridge"
	luminosity = 8
	max_n_of_items = 10
	pixel_y = -4

/obj/machinery/smartfridge/survival_pod/empty
	name = "dusty survival pod storage"
	desc = "A heated storage unit. This ones seen better days."

/obj/machinery/smartfridge/survival_pod/empty/New()
	return()

/obj/machinery/smartfridge/survival_pod/accept_check(obj/item/O)
	if(istype(O, /obj/item))
		return 1
	return 0

/obj/machinery/smartfridge/survival_pod/New()
	..()
	for(var/i in 1 to 5)
		var/obj/item/weapon/reagent_containers/food/snacks/donkpocket/warm/W = new(src)
		load(W)
	if(prob(50))
		var/obj/item/weapon/storage/pill_bottle/dice/D = new(src)
		load(D)
	else
		var/obj/item/device/instrument/guitar/G = new(src)
		load(G)