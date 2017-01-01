/obj/item/weapon/stock_parts/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	var/ratingdesc
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = "powerstorage=1"
	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = 2
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	materials = list(MAT_METAL=700, MAT_GLASS=50)
	var/rigged = 0		// true if rigged to explode
	var/chargerate = 100 //how much power is given every tick in a recharger
	var/self_recharge = 0 //does it self recharge, over time, or not?

/obj/item/weapon/stock_parts/cell/New()
	..()
	START_PROCESSING(SSobj, src)
	charge = maxcharge
	ratingdesc = " This one has a power rating of [maxcharge], and you should not swallow it."
	desc = desc + ratingdesc
	updateicon()

/obj/item/weapon/stock_parts/cell/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/stock_parts/cell/on_varedit(modified_var)
	if(modified_var == "self_recharge")
		if(self_recharge)
			START_PROCESSING(SSobj, src)
		else
			STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/stock_parts/cell/process()
	if(self_recharge)
		give(chargerate * 0.25)
	else
		return PROCESS_KILL

/obj/item/weapon/stock_parts/cell/proc/updateicon()
	overlays.Cut()
	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		overlays += image('icons/obj/power.dmi', "cell-o2")
	else
		overlays += image('icons/obj/power.dmi', "cell-o1")

/obj/item/weapon/stock_parts/cell/proc/percent()		// return % charge of cell
	return 100*charge/maxcharge

// use power from a cell
/obj/item/weapon/stock_parts/cell/proc/use(amount)
	if(rigged && amount > 0)
		explode()
		return 0
	if(charge < amount)
		return 0
	charge = (charge - amount)
	if(!istype(loc, /obj/machinery/power/apc))
		feedback_add_details("cell_used","[src.type]")
	return 1

// recharge the cell
/obj/item/weapon/stock_parts/cell/proc/give(amount)
	if(rigged && amount > 0)
		explode()
		return 0
	if(maxcharge < amount)
		amount = maxcharge
	var/power_used = min(maxcharge-charge,amount)
	charge += power_used
	return power_used


/obj/item/weapon/stock_parts/cell/attack_self(mob/user)
	if (istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/maybedroid = user
		if (maybedroid.dna.species.id == "android" || maybedroid.dna.species.id == "flyternis")
			//BEGIN THE NUTRITION RECHARGEEEE
			if (charge)
				if (rigged)
					//oh, shit.
					explode()

				if (maybedroid.nutrition > NUTRITION_LEVEL_FED)
					maybedroid << "<span class='notice'>CONSUME protocol reports no need for additional power at this time.</span>"
					return

				var/drain = maxcharge/40
				var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
				var/ischarging = 1
				spark_system.set_up(5, 0, maybedroid.loc)
				spark_system.attach(maybedroid)
				maybedroid.visible_message("[maybedroid] deftly inserts [src] into a slot within their torso. A low hum begins to fill the air.", "<span class='info'>Extracutaneous implants detect viable power source in location: HANDS. Activating CONSUME protocol..</span>")
				while (ischarging)
					if (drain > charge)
						drain = charge

					if (prob(35))
						var/nutpercents
						nutpercents = (maybedroid.nutrition / NUTRITION_LEVEL_WELL_FED)*100

						maybedroid << "<span class='info'>CONSUME protocol continues. Current satiety level: [nutpercents]%."
					if (do_after(maybedroid, 10, target = src))
						spark_system.start()
						playsound(maybedroid.loc, "sparks", 35, 1)

					charge -= drain
					src.update_icon()
					maybedroid.nutrition += drain/22

					if (maybedroid.nutrition >= NUTRITION_LEVEL_WELL_FED || maybedroid.get_active_hand() != src || !charge)
						maybedroid.visible_message("A slight hiss emanates from [maybedroid] as [src] pops free from a slot in their torso.", "<span class='info>CONSUME protocol complete. Physical nourishment refreshed. Advise cell recharging.</span>")
						ischarging = 0
			else
				user << "<span class='info'>You currently surmise via ocular sensors that this cell does not possess enough charge to be of use to you.</span>"
				return
		else
			user << "<span class='info'>You turn the cell about in your hands, carefully avoiding the terminals on either end. Cyborgs and androids could probably use this.</span>"

/obj/item/weapon/stock_parts/cell/examine(mob/user)
	..()
	if(rigged)
		user << "<span class='danger'>This power cell seems to be faulty!</span>"
	else
		user << "The charge meter reads [round(src.percent() )]%."

/obj/item/weapon/stock_parts/cell/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is licking the electrodes of the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/weapon/stock_parts/cell/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W
		user << "<span class='notice'>You inject the solution into the power cell.</span>"
		if(S.reagents.has_reagent("plasma", 5))
			rigged = 1
		S.reagents.clear_reagents()


/obj/item/weapon/stock_parts/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)
	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	qdel(src)

/obj/item/weapon/stock_parts/cell/proc/corrupt()
	charge /= 2
	maxcharge = max(maxcharge/2, chargerate)
	if (prob(10))
		rigged = 1 //broken batterys are dangerous

/obj/item/weapon/stock_parts/cell/emp_act(severity)
	charge -= 1000 / severity
	if (charge < 0)
		charge = 0
	..()

/obj/item/weapon/stock_parts/cell/ex_act(severity, target)
	..()
	if(!qdeleted(src))
		switch(severity)
			if(2)
				if(prob(50))
					corrupt()
			if(3)
				if(prob(25))
					corrupt()


/obj/item/weapon/stock_parts/cell/blob_act(obj/effect/blob/B)
	ex_act(1)

/obj/item/weapon/stock_parts/cell/proc/get_electrocute_damage()
	if(charge >= 1000)
		return Clamp(round(charge/10000), 10, 90) + rand(-5,5)
	else
		return 0

/* Cell variants*/
/obj/item/weapon/stock_parts/cell/crap
	name = "\improper Nanotrasen brand rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	maxcharge = 500
	materials = list(MAT_GLASS=40)
	rating = 2

/obj/item/weapon/stock_parts/cell/crap/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = null
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	materials = list(MAT_GLASS=40)
	rating = 2.5

/obj/item/weapon/stock_parts/cell/secborg/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/pulse //200 pulse shots
	name = "pulse rifle power cell"
	maxcharge = 40000
	rating = 3
	chargerate = 1500

/obj/item/weapon/stock_parts/cell/pulse/carbine //25 pulse shots
	name = "pulse carbine power cell"
	maxcharge = 5000

/obj/item/weapon/stock_parts/cell/pulse/pistol //10 pulse shots
	name = "pulse pistol power cell"
	maxcharge = 2000

/obj/item/weapon/stock_parts/cell/high
	name = "high-capacity power cell"
	origin_tech = "powerstorage=2"
	icon_state = "hcell"
	maxcharge = 10000
	materials = list(MAT_GLASS=60)
	rating = 3
	chargerate = 1500

/obj/item/weapon/stock_parts/cell/high/plus
	name = "high-capacity power cell+"
	desc = "Where did these come from?"
	icon_state = "h+cell"
	maxcharge = 15000
	chargerate = 2250

/obj/item/weapon/stock_parts/cell/high/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/super
	name = "super-capacity power cell"
	origin_tech = "powerstorage=3;materials=3"
	icon_state = "scell"
	maxcharge = 20000
	materials = list(MAT_GLASS=300)
	rating = 4
	chargerate = 2000

/obj/item/weapon/stock_parts/cell/super/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = "powerstorage=4;engineering=4;materials=4"
	icon_state = "hpcell"
	maxcharge = 30000
	materials = list(MAT_GLASS=400)
	rating = 5
	chargerate = 3000

/obj/item/weapon/stock_parts/cell/hyper/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/bluespace
	name = "bluespace power cell"
	desc = "A rechargable transdimensional power cell."
	origin_tech = "powerstorage=5;bluespace=4;materials=4;engineering=4"
	icon_state = "bscell"
	maxcharge = 40000
	materials = list(MAT_GLASS=600)
	rating = 6
	chargerate = 4000

/obj/item/weapon/stock_parts/cell/bluespace/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  "powerstorage=7"
	maxcharge = 30000
	materials = list(MAT_GLASS=1000)
	rating = 6
	chargerate = 30000

/obj/item/weapon/stock_parts/cell/infinite/use()
	return 1

/obj/item/weapon/stock_parts/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	icon = 'icons/obj/power.dmi' //'icons/obj/hydroponics/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	origin_tech = "powerstorage=1;biotech=1"
	charge = 100
	maxcharge = 300
	materials = list()
	rating = 1

/obj/item/weapon/stock_parts/cell/high/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	origin_tech = "powerstorage=5;biotech=4"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "yellow slime extract"
	materials = list()
	self_recharge = 1 // Infused slime cores self-recharge, over time

/obj/item/weapon/stock_parts/cell/emproof
	name = "\improper EMP-proof cell"
	desc = "An EMP-proof cell."
	maxcharge = 500
	rating = 2

/obj/item/weapon/stock_parts/cell/emproof/empty/New()
	..()
	charge = 0

/obj/item/weapon/stock_parts/cell/emproof/emp_act(severity)
	return

/obj/item/weapon/stock_parts/cell/emproof/corrupt()
	return
