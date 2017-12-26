/obj/machinery/sleep_console
	name = "sleeper console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "console"
	density = FALSE
	anchored = TRUE

/obj/machinery/sleeper
	name = "sleeper"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper"
	density = FALSE
	anchored = TRUE
	state_open = TRUE
	var/emag_effect
	var/datum/effect_system/spark_spread/spark_system
	var/efficiency = 1
	var/min_health = -25
	var/list/available_chems
	var/controls_inside = FALSE
	var/list/possible_chems = list(
		list("epinephrine", "morphine", "salbutamol", "bicaridine", "kelotane"),
		list("oculine"),
		list("antitoxin", "mutadone", "mannitol", "pen_acid"),
		list("omnizine")
	)

/obj/machinery/sleeper/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/sleeper(null)
	B.apply_default_parts(src)
	update_icon()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/circuitboard/machine/sleeper
	name = "circuit board (Sleeper)"
	build_path = /obj/machinery/sleeper
	origin_tech = "programming=3;biotech=2;engineering=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/sheet/glass = 1)

/obj/machinery/sleeper/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		E += B.rating
	var/I
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		I += M.rating

	efficiency = initial(efficiency)* E
	min_health = initial(min_health) * E
	available_chems = list()
	for(var/i in 1 to I)
		available_chems |= possible_chems[i]

/obj/machinery/sleeper/update_icon()
	icon_state = initial(icon_state)
	if(state_open)
		icon_state += "-open"

/obj/machinery/sleeper/container_resist()
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/sleeper/relaymove(mob/user)
	container_resist()

/obj/machinery/sleeper/open_machine()
	if(!state_open && !panel_open)
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		..()

/obj/machinery/sleeper/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		..(user)
		if(occupant && occupant.stat != DEAD)
			to_chat(occupant, "<span class='notice'><b>You feel cool air surround you. You go numb as your senses turn inward.</b></span>")

/obj/machinery/sleeper/attack_animal(mob/living/simple_animal/M)
	if(M.environment_smash)
		M.do_attack_animation(src)
		visible_message("<span class='danger'>[M.name] smashes [src] apart!</span>")
		qdel(src)

/obj/machinery/sleeper/emp_act(severity)
	if(is_operational() && occupant)
		open_machine()
	..(severity)

/obj/machinery/sleeper/blob_act(obj/effect/blob/B)
	if(prob(75))
		var/turf/T = get_turf(src)
		for(var/atom/movable/A in src)
			A.forceMove(T)
			A.blob_act(B)
		qdel(src)

/obj/machinery/sleeper/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)

/obj/machinery/sleeper/attackby(obj/item/I, mob/user, params)
	if(!state_open && !occupant)
		if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
			return
	if(default_change_direction_wrench(user, I))
		return
	if(exchange_parts(user, I))
		return
	if(default_pry_open(I))
		return
	if(default_deconstruction_crowbar(I))
		return
	if(istype(I, /obj/item/weapon/wirecutters) && emag_effect)
		to_chat(user, "<span class='alert'>You begin mending seperated wires and cutting the useless ones...</span>")
		spark_system.start()
		playsound(user, "sparks", 50, 1)
		if(do_after(user, 80/I.toolspeed, target = src))
			to_chat(user, "<span class='notice'>You mend some of the wires together and cut off the burnt out ones, allowing the sleeper to function properly.</span>")
			emag_effect = !emag_effect
			emagged = !emagged
			return
		else
			return
	return ..()

/obj/machinery/sleeper/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
									datum/tgui/master_ui = null, datum/ui_state/state = notcontained_state)

	if(emag_effect)
		to_chat(user, "<span class='danger'>You see a small line of smoke coming from inside of the sleeper and wires ripped apart creating brief electric sparks making you hesitate from touching it.</span>")
		if(ui)
			ui.close()
		return

	if(controls_inside && state == notcontained_state)
		state = default_state // If it has a set of controls on the inside, make it actually controllable by the mob in it.

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper", name, 375, 550, master_ui, state)
		ui.open()

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = chemical_reagents_list[chem]
		data["chems"] += list(list("name" = R.name, "id" = R.id, "allowed" = chem_allowed(chem)))

	data["occupant"] = list()
	if(occupant)
		data["occupant"]["name"] = occupant.name
		data["occupant"]["stat"] = occupant.stat
		data["occupant"]["health"] = occupant.health
		data["occupant"]["maxHealth"] = occupant.maxHealth
		data["occupant"]["minHealth"] = config.health_threshold_dead
		data["occupant"]["bruteLoss"] = occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = occupant.getToxLoss()
		data["occupant"]["fireLoss"] = occupant.getFireLoss()
		data["occupant"]["cloneLoss"] = occupant.getCloneLoss()
		data["occupant"]["brainLoss"] = occupant.getBrainLoss()
		data["occupant"]["reagents"] = list()
		if(occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in occupant.reagents.reagent_list)
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = R.volume))
	return data

/obj/machinery/sleeper/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("inject")
			var/chem = params["chem"]
			if(!is_operational() || !occupant)
				return
			if(occupant.health < min_health && chem != "epinephrine")
				return
			if(emagged)
				for(var/reagent_id in available_chems)
					occupant.reagents.add_reagent(reagent_id, 30)
					occupant.attack_log += text("\[[time_stamp()]\] <font color='orange'>[occupant]/[occupant.ckey] has been injected by [usr]/[usr.ckey] with 30 [reagent_id] using an EMAGGED sleeper</font>")
					log_attack("[usr]/[usr.ckey] injected [occupant]/[occupant.ckey] with 30 [reagent_id] using an EMAGGED sleeper")
					usr.attack_log += text("\[[time_stamp()]\] <font color='red'>[usr]/[usr.ckey] has injected [occupant]/[occupant.ckey] with 30 [reagent_id] using an EMAGGED sleeper</font>")
				audible_message("<span class='alert'>[src] buzzes and beeps madly!</span>")
				emag_effect = 1
				open_machine()
				return
			if(inject_chem(chem))
				. = TRUE

/obj/machinery/sleeper/proc/inject_chem(chem)
	if((chem in available_chems) && chem_allowed(chem))
		occupant.reagents.add_reagent(chem, 10)
		occupant.attack_log += text("\[[time_stamp()]\] <font color='orange'>[occupant]/[occupant.ckey] has been injected by [usr]/[usr.ckey] with 10 [chem] using a sleeper</font>")
		usr.attack_log += text("\[[time_stamp()]\] <font color='red'>[usr]/[usr.ckey] has injected [occupant]/[occupant.ckey] with 10 [chem] using a sleeper</font>")
		log_attack("[usr]/[usr.ckey] injected [occupant]/[occupant.ckey] with 10 [chem] using a sleeper")
		return TRUE

/obj/machinery/sleeper/proc/chem_allowed(chem)
	if(!occupant)
		return
	var/amount = occupant.reagents.get_reagent_amount(chem) + 10 <= 20 * efficiency
	var/health = occupant.health > min_health || chem == "epinephrine"
	return amount && health

/obj/machinery/sleeper/emag_act(mob/user)
	if(!emagged)
		src.emagged = 1
		to_chat(user, "You breach the safety mechanics..")


/obj/machinery/sleeper/syndie
	icon_state = "sleeper_s"
	controls_inside = TRUE

/obj/machinery/sleeper/syndie/emag_act(mob/user)
	return


/obj/machinery/sleeper/old
	icon_state = "oldpod"
