//Make sure to adjust line 25 in powercell.dm when making a new reaction thing

/datum/powercell_reagents
	var/name = "admins broke reality"
	var/uses = -1 //Amount of times it does stuff. -1 for infinite
	var/special_borg = FALSE //Wether we're constantly making a reaction happen in the borg, or have it do something special instead
	var/special_preternis = FALSE //Whetever it's going to do the normal reaction once he eats it, or we give him something special
	var/also_borg = FALSE //Calls bove the cyborg and the normal proc if inside a cyborg
	var/also_preternis = FALSE //Calls both the cyborg and the normal proc if inside a borg
	var/timer = 0 //Timer before it can be used again
	var/last_time = 0
	var/obj/item/weapon/stock_parts/cell/cell

/datum/powercell_reagents/New()
	last_time = timer + 1

/datum/powercell_reagents/proc/start(var/amount, var/obj/item/weapon/stock_parts/cell/O)
	cell = O
	if(!timer)
	else if(world.time - last_time >= timer)
		last_time = world.time
	else
		return 0
	if(!use())
		qdel(src)
	if(check_borg())
		on_borg(check_borg(), amount)
		if(!also_borg)
			return
	if(check_preternis())
		on_preternis(check_preternis(), amount)
		if(!also_preternis)
			return
	on_normal(amount)

/datum/powercell_reagents/proc/check_borg()
	if(!special_borg)return 0
	if(isrobot(cell.loc))
		var/mob/living/silicon/robot/S = cell.loc
		return S
	return 0

/datum/powercell_reagents/proc/check_preternis()
	if(!special_preternis && !cell.ischarging)return 0
	if(ispreternis(cell.loc))
		var/mob/living/carbon/human/H = cell.loc
		return H
	return 0

/datum/powercell_reagents/proc/on_borg(var/mob/living/silicon/robot/S, var/amount)
	return

/datum/powercell_reagents/proc/on_preternis(var/mob/living/carbon/human/H, var/amount)
	return

/datum/powercell_reagents/proc/on_normal(var/amount)
	return

/datum/powercell_reagents/proc/use()
	if(uses < 0 )
		return 1
	else if(!uses)
		cell.special = 0
		return 0
	else
		uses--
		return 1

/datum/powercell_reagents/plasma
	name = "Boom"
	uses = 1

/datum/powercell_reagents/plasma/on_normal()
	cell.explode()
	qdel(cell)

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
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)
	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

/datum/powercell_reagents/banana
	name = "HONK"
	timer = 50

/datum/powercell_reagents/banana/on_normal(var/amount)
	playsound(get_turf(cell.loc), 'sound/items/bikehorn.ogg', 50, 0)

/datum/powercell_reagents/uranium
	name = "radiation"
	timer = 50
	also_borg = TRUE

/datum/powercell_reagents/uranium/on_normal(var/amount)
	var/radiation_power = 1
	if(amount >= 1000)
		radiation_power = 3
	else if(amount >= 500)
		radiation_power = 2
	radiation_pulse(get_turf(cell.loc), 2, 4, radiation_power, 0)
	cell.charge -= 50

/datum/powercell_reagents/uranium/on_borg(mob/living/silicon/robot/S, var/amount)
	if(prob(50))
		S.Stun(3)