#define TOOL "Tools" // tool that miners can actively use.
#define WEAPON "Weapons" // may be along the lines of a tool, but may as well do a lot in combat.
#define MEDS "Meds" // self explanatory. our miners need to patch themselves.
#define MININGDRONE "Mining Drone" // drones are coming in.
#define MISC "Miscellaneous" // random crap that nobody buys
#define EQUIP "Equipment" // equipment that miners can wear.

/**********************Mining Equipment Vendor**************************/

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = 1
	anchored = 1
	var/obj/item/weapon/card/id/inserted_id
<<<<<<< HEAD
	var/list/prize_list = list(
		new /datum/data/mining_equipment("Advanced Scanner",	/obj/item/device/t_scanner/adv_mining_scanner,                     		800, TOOL),
		new /datum/data/mining_equipment("Hivelord Stabilizer",	/obj/item/weapon/hivelordstabilizer			 ,                     		400, TOOL),
		new /datum/data/mining_equipment("Shelter Capsule",		/obj/item/weapon/survivalcapsule			 ,                     		400, TOOL),
		new /datum/data/mining_equipment("Barometer",			/obj/item/device/barometer/mining,										300, TOOL),
		new /datum/data/mining_equipment("Jaunter",             /obj/item/device/wormhole_jaunter,										750, TOOL),
		new /datum/data/mining_equipment("Orebox Capsule",	/obj/item/orecapsule,													100, TOOL),
		new /datum/data/mining_equipment("Survival Medipen",	/obj/item/weapon/reagent_containers/hypospray/medipen/survival,			500, MEDS),
		new /datum/data/mining_equipment("Brute First-Aid Kit",	/obj/item/weapon/storage/firstaid/brute,						   		600, MEDS),
		new /datum/data/mining_equipment("Fire First-Aid Kit",	/obj/item/weapon/storage/firstaid/fire,									600, MEDS),
		new /datum/data/mining_equipment("Toxin First-Aid Kit",	/obj/item/weapon/storage/firstaid/toxin,								600, MEDS),
		new /datum/data/mining_equipment("Stimpack",			/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack,	    	50, MEDS),
		new /datum/data/mining_equipment("Stimpack Bundle",		/obj/item/weapon/storage/box/medipens/utility,	 				  		200, MEDS),
		new /datum/data/mining_equipment("Explorer's Webbing",	/obj/item/weapon/storage/belt/mining/alt,								500, EQUIP),
		new /datum/data/mining_equipment("Tracking Implant Kit",/obj/item/weapon/storage/box/minertracker,                              600, EQUIP),
		new /datum/data/mining_equipment("Mining Hardsuit",		/obj/item/clothing/suit/space/hardsuit/mining,				            2500, EQUIP),
		new /datum/data/mining_equipment("Jetpack Upgrade",		/obj/item/hardsuit_jetpack,	              								1000, EQUIP),
		new /datum/data/mining_equipment("Kinetic Accelerator", /obj/item/weapon/gun/energy/kinetic_accelerator,               	   		750, WEAPON),
		new /datum/data/mining_equipment("Resonator",           /obj/item/weapon/resonator,                                    	   		750, WEAPON),
		new /datum/data/mining_equipment("Silver Pickaxe",		/obj/item/weapon/pickaxe/silver,				                  		750, WEAPON),
		new /datum/data/mining_equipment("Diamond Pickaxe",		/obj/item/weapon/pickaxe/diamond,				                  		750, WEAPON),
		new /datum/data/mining_equipment("Super Resonator",     /obj/item/weapon/resonator/upgraded,                              		1500, WEAPON),
		new /datum/data/mining_equipment("Plasma Cutter" ,		/obj/item/weapon/gun/energy/plasmacutter,								1500, WEAPON),
		new /datum/data/mining_equipment("Super Accelerator",	/obj/item/weapon/gun/energy/kinetic_accelerator/super,			  		2000, WEAPON),
		new /datum/data/mining_equipment("Mining Drone",        /mob/living/simple_animal/hostile/mining_drone,                   		500, MININGDRONE),
		new /datum/data/mining_equipment("Drone Melee Upgrade", /obj/item/device/mine_bot_upgrade,      			   			   		400, MININGDRONE),
		new /datum/data/mining_equipment("Drone Health Upgrade",/obj/item/device/mine_bot_upgrade/health,      			   	       		400, MININGDRONE),
		new /datum/data/mining_equipment("Drone Ranged Upgrade",/obj/item/device/mine_bot_upgrade/cooldown,      			   	   		600, MININGDRONE),
		new /datum/data/mining_equipment("Drone AI Upgrade",    /obj/item/slimepotion/sentience/mining,      			   	      		1000, MININGDRONE),
		new /datum/data/mining_equipment("Lazarus Injector",    /obj/item/weapon/lazarus_injector,                                		800, MISC),
		new /datum/data/mining_equipment("Space Cash",    		/obj/item/stack/spacecash/c1000,                    			  		2000, MISC),
		new /datum/data/mining_equipment("Point Transfer Card", /obj/item/weapon/card/mining_point_card,               			   		500, MISC),
		new /datum/data/mining_equipment("GAR scanners",		/obj/item/clothing/glasses/meson/gar,					  		   		200, MISC),
		new /datum/data/mining_equipment("Whiskey",             /obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,    		100, MISC),
		new /datum/data/mining_equipment("Absinthe",            /obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe/premium,100, MISC),
		new /datum/data/mining_equipment("Cigar",               /obj/item/clothing/mask/cigarette/cigar/havana,                    		150, MISC),
		new /datum/data/mining_equipment("Soap",                /obj/item/weapon/soap/nanotrasen, 						          		200, MISC),
		new /datum/data/mining_equipment("Laser Pointer",       /obj/item/device/laser_pointer, 				                   		300, MISC),
		new /datum/data/mining_equipment("Alien Toy",           /obj/item/clothing/mask/facehugger/toy, 		                   		300, MISC),
=======
	var/list/prize_list = list( //if you add something to this, please, for the love of god, use tabs and not spaces.
		new /datum/data/mining_equipment("Stimpack",			/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack,			50),
		new /datum/data/mining_equipment("Stimpack Bundle",		/obj/item/weapon/storage/box/medipens/utility,							200),
		new /datum/data/mining_equipment("Whiskey",				/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,			100),
		new /datum/data/mining_equipment("Absinthe",			/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe/premium,100),
		new /datum/data/mining_equipment("Cigar",				/obj/item/clothing/mask/cigarette/cigar/havana,							150),
		new /datum/data/mining_equipment("Soap",				/obj/item/weapon/soap/nanotrasen,										200),
		new /datum/data/mining_equipment("Laser Pointer",		/obj/item/device/laser_pointer,											300),
		new /datum/data/mining_equipment("Alien Toy",			/obj/item/clothing/mask/facehugger/toy,									300),
		new /datum/data/mining_equipment("Advanced Scanner",	/obj/item/device/t_scanner/adv_mining_scanner,							800),
		new /datum/data/mining_equipment("Stabilizing Serum",	/obj/item/weapon/hivelordstabilizer,									400),
		new /datum/data/mining_equipment("Fulton Beacon",		/obj/item/fulton_core,													400),
		new /datum/data/mining_equipment("Shelter Capsule",		/obj/item/weapon/survivalcapsule,										400),
		new /datum/data/mining_equipment("GAR scanners",		/obj/item/clothing/glasses/meson/gar,									500),
		new /datum/data/mining_equipment("Explorer's Webbing",	/obj/item/weapon/storage/belt/mining,									500),
		new /datum/data/mining_equipment("Survival Medipen",	/obj/item/weapon/reagent_containers/hypospray/medipen/survival,			500),
		new /datum/data/mining_equipment("Brute First-Aid Kit",	/obj/item/weapon/storage/firstaid/brute,								600),
		new /datum/data/mining_equipment("Tracking Implant Kit",/obj/item/weapon/storage/box/minertracker,								600),
		new /datum/data/mining_equipment("Jaunter",				/obj/item/device/wormhole_jaunter,										750),
		new /datum/data/mining_equipment("Kinetic Crusher",		/obj/item/weapon/twohanded/required/mining_hammer,						750),
		new /datum/data/mining_equipment("Kinetic Accelerator",	/obj/item/weapon/gun/energy/kinetic_accelerator,						750),
		new /datum/data/mining_equipment("Resonator",			/obj/item/weapon/resonator,												800),
		new /datum/data/mining_equipment("Fulton Pack",			/obj/item/weapon/extraction_pack,										1000),
		new /datum/data/mining_equipment("Lazarus Injector",	/obj/item/weapon/lazarus_injector,										1000),
		new /datum/data/mining_equipment("Silver Pickaxe",		/obj/item/weapon/pickaxe/silver,										1000),
		new /datum/data/mining_equipment("Jetpack Upgrade",		/obj/item/weapon/tank/jetpack/suit,										2000),
		new /datum/data/mining_equipment("Space Cash",			/obj/item/stack/spacecash/c1000,										2000),
		new /datum/data/mining_equipment("Mining Hardsuit",		/obj/item/clothing/suit/space/hardsuit/mining,							2000),
		new /datum/data/mining_equipment("Diamond Pickaxe",		/obj/item/weapon/pickaxe/diamond,										2000),
		new /datum/data/mining_equipment("Super Resonator",		/obj/item/weapon/resonator/upgraded,									2500),
		new /datum/data/mining_equipment("KA White Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer,								100),
		new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,				150),
		new /datum/data/mining_equipment("KA Super Chassis",	/obj/item/borg/upgrade/modkit/chassis_mod,								250),
		new /datum/data/mining_equipment("KA Hyper Chassis",	/obj/item/borg/upgrade/modkit/chassis_mod/orange,						300),
		new /datum/data/mining_equipment("KA Range Increase",	/obj/item/borg/upgrade/modkit/range,									1000),
		new /datum/data/mining_equipment("KA Damage Increase",	/obj/item/borg/upgrade/modkit/damage,									1000),
		new /datum/data/mining_equipment("KA Cooldown Decrease",/obj/item/borg/upgrade/modkit/cooldown,									1000),
		new /datum/data/mining_equipment("KA AoE Damage",		/obj/item/borg/upgrade/modkit/aoe/mobs,									2000),
		new /datum/data/mining_equipment("Point Transfer Card",	/obj/item/weapon/card/mining_point_card,								500),
		new /datum/data/mining_equipment("Mining Drone",		/mob/living/simple_animal/hostile/mining_drone,							800),
		new /datum/data/mining_equipment("Drone Melee Upgrade",	/obj/item/device/mine_bot_ugprade,										400),
		new /datum/data/mining_equipment("Drone Health Upgrade",/obj/item/device/mine_bot_ugprade/health,								400),
		new /datum/data/mining_equipment("Drone Ranged Upgrade",/obj/item/device/mine_bot_ugprade/cooldown,								600),
		new /datum/data/mining_equipment("Drone AI Upgrade",	/obj/item/slimepotion/sentience/mining,									1000),
		new /datum/data/mining_equipment("Jump Boots",			/obj/item/clothing/shoes/bhop,											2500),
>>>>>>> masterTGbranch
		)

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0
	var/category

/datum/data/mining_equipment/New(name, path, pcost, cat)
	equipment_name = name
	equipment_path = path
	cost = pcost
	category = cat

/obj/machinery/mineral/equipment_vendor/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/mining_equipment_vendor(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/mining_equipment_vendor
	name = "circuit board (Mining Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor
	origin_tech = "programming=1;engineering=3"
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 3)

/obj/machinery/mineral/equipment_vendor/power_change()
	..()
	update_icon()

/obj/machinery/mineral/equipment_vendor/update_icon()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"
	return

/obj/machinery/mineral/equipment_vendor/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/mineral/equipment_vendor/interact(mob/user)
	var/dat
	var/list/categories = list()
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
<<<<<<< HEAD
	dat += "<br><b>Equipment point cost list:</b><BR>"//<table border='0' width='200'>
=======
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='300'>"
>>>>>>> masterTGbranch
	for(var/datum/data/mining_equipment/prize in prize_list)
		var/list/L = categories[prize.category]
		if(L)
			L += prize
		else
			categories[prize.category] = list(prize)

	for(var/a in categories)
		dat += "<h3>[a]</h3>"
		dat += "<div class='statusDisplay'><ul>" // use to be commented out
		for(var/datum/data/mining_equipment/prize in categories[a])
			dat += "<li><tr><td>[prize.equipment_name]</td>          \
					<td>[prize.cost]</td>          	\
					<td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr></li>"
		dat += "</ul></div>"
		dat += "<br>" //</table> went before that br

	var/datum/browser/popup = new(user, "miningvendor", "Mining Equipment Vendor", 400, 350)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/mineral/equipment_vendor/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				inserted_id.loc = loc
				inserted_id.verb_pickup()
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_held_item()
			if(istype(I))
				if(!usr.drop_item())
					return
				I.loc = src
				inserted_id = I
			else usr << "<span class='danger'>No valid ID.</span>"
	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				return
			if(prize.cost > inserted_id.mining_points)
			else
				inserted_id.mining_points -= prize.cost
				new prize.equipment_path(src.loc)
				feedback_add_details("mining_equipment_bought",
					"[src.type]|[prize.equipment_path]")
				// Add src.type to keep track of free golem purchases
				// seperately.
	updateUsrDialog()
	return

/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/mining_voucher))
		RedeemVoucher(I, user)
		return
	if(istype(I,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = usr.get_active_held_item()
		if(istype(C) && !istype(inserted_id))
			if(!usr.drop_item())
				return
			C.loc = src
			inserted_id = C
			interact(user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/mineral/equipment_vendor/proc/RedeemVoucher(obj/item/weapon/mining_voucher/voucher, mob/redeemer)
<<<<<<< HEAD
	var/selection = input(redeemer, "Pick your equipment", "Mining Voucher Redemption") as null|anything in list("Survival Capsule", "Resonator", "Mining Drone", "Advanced Scanner", "Weather Detector")
	if(!selection || !Adjacent(redeemer) || qdeleted(voucher) || voucher.loc != redeemer)
		return
	switch(selection)
		if("Survival Capsule")
			new /obj/item/weapon/survivalcapsule(src.loc)
		if("Resonator")
=======
	var/items = list("Survival Capsule and Explorer's Webbing", "Resonator and Advanced Scanner", "Mining Drone", "Extraction and Rescue Kit", "Crusher Kit", "Mining Conscription Kit")

	var/selection = input(redeemer, "Pick your equipment", "Mining Voucher Redemption") as null|anything in items
	if(!selection || !Adjacent(redeemer) || qdeleted(voucher) || voucher.loc != redeemer)
		return
	switch(selection)
		if("Survival Capsule and Explorer's Webbing")
			new /obj/item/weapon/storage/belt/mining/vendor(src.loc)
		if("Resonator and Advanced Scanner")
>>>>>>> masterTGbranch
			new /obj/item/weapon/resonator(src.loc)
			new /obj/item/device/t_scanner/adv_mining_scanner(src.loc)
		if("Mining Drone")
			new /mob/living/simple_animal/hostile/mining_drone(src.loc)
			new /obj/item/weapon/weldingtool/hugetank(src.loc)
<<<<<<< HEAD
		if("Advanced Scanner")
			new /obj/item/device/t_scanner/adv_mining_scanner(src.loc)
		if("Weather Detector")
			new /obj/item/device/barometer(src.loc)
=======
		if("Extraction and Rescue Kit")
			new /obj/item/weapon/extraction_pack(loc)
			new /obj/item/fulton_core(loc)
		if("Crusher Kit")
			new /obj/item/weapon/twohanded/required/mining_hammer(loc)
			new /obj/item/weapon/storage/belt/mining/alt(loc)
			new /obj/item/weapon/extinguisher/mini(loc)
		if("Mining Conscription Kit")
			new /obj/item/weapon/storage/backpack/dufflebag/mining_conscript(loc)
>>>>>>> masterTGbranch

	feedback_add_details("mining_voucher_redeemed", selection)
	qdel(voucher)

/obj/machinery/mineral/equipment_vendor/ex_act(severity, target)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(prob(50 / severity) && severity < 3)
		qdel(src)


/****************Golem Point Vendor**************************/

/obj/machinery/mineral/equipment_vendor/golem
	name = "golem ship equipment vendor"

/obj/machinery/mineral/equipment_vendor/golem/New()
	..()
	desc += "\nIt seems a few selections have been added."
	prize_list += list(
		new /datum/data/mining_equipment("Science Goggles",       	/obj/item/clothing/glasses/science, 				                   	250),
		new /datum/data/mining_equipment("Monkey Cube",				/obj/item/weapon/reagent_containers/food/snacks/monkeycube,        		300),
		new /datum/data/mining_equipment("Toolbelt",				/obj/item/weapon/storage/belt/utility,	    							350),
		new /datum/data/mining_equipment("Sulphuric Acid",			/obj/item/weapon/reagent_containers/glass/beaker/sulphuric,        		500),
		new /datum/data/mining_equipment("Brute First-Aid Kit",		/obj/item/weapon/storage/firstaid/brute,						   		600),
		new /datum/data/mining_equipment("Grey Slime Extract",		/obj/item/slime_extract/grey,				       		           		1000),
		new /datum/data/mining_equipment("Modification Kit",    	/obj/item/borg/upgrade/modkit/trigger_guard, 		                	1700),
		new /datum/data/mining_equipment("The Liberator's Legacy",  /obj/item/weapon/storage/box/rndboards,      			      			2000),

		)

	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/mining_equipment_vendor/golem(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/mining_equipment_vendor/golem
	name = "circuit board (Golem Ship Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor/golem


/**********************Mining Equipment Vendor Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/weapon/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY

/**********************Mining Point Card**********************/

/obj/item/weapon/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/points = 500

/obj/item/weapon/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id))
		if(points)
			var/obj/item/weapon/card/id/C = I
			C.mining_points += points
			user << "<span class='info'>You transfer [points] points to [C].</span>"
			points = 0
		else
			user << "<span class='info'>There's no points left on [src].</span>"
	..()

/obj/item/weapon/card/mining_point_card/examine(mob/user)
	..()
<<<<<<< HEAD
	user << "There's [points] point\s on the card."
=======
	user << "There's [points] point\s on the card."

///Conscript kit
/obj/item/weapon/card/mining_access_card
	name = "mining access card"
	desc = "A small card, that when used on any ID, will add mining access."
	icon_state = "data"

/obj/item/weapon/card/mining_access_card/afterattack(atom/movable/AM, mob/user, proximity)
	if(istype(AM, /obj/item/weapon/card/id) && proximity)
		var/obj/item/weapon/card/id/I = AM
		I.access |=	access_mining
		I.access |= access_mining_station
		I.access |= access_mineral_storeroom
		I.access |= access_cargo
		user  << "You upgrade [I] with mining access."
		qdel(src)
	..()

/obj/item/weapon/storage/backpack/dufflebag/mining_conscript
	name = "mining conscription kit"
	desc = "A kit containing everything a crewmember needs to support a shaft miner in the field."

/obj/item/weapon/storage/backpack/dufflebag/mining_conscript/New()
	..()
	new /obj/item/weapon/pickaxe/mini(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/device/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/weapon/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/device/encryptionkey/headset_cargo(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/weapon/card/mining_access_card(src)
>>>>>>> masterTGbranch
