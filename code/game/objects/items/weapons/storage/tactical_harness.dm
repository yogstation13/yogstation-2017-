/obj/item/weapon/storage/tactical_harness
	name = "tactical harness"
	desc = "A harness for a Syndicate tactical animal."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "armoralt"//this needs a real sprite.
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 21
	storage_slots = 21
	cant_hold = list(/obj/item/weapon/storage/tactical_harness) //muh recursive backpacks.

	var/list/wearable_by = list()//types of animals that can wear it. Their subtypes can also wear it. Should be a /mob/living/simple_animal.
	var/list/wearable_by_exact = list()//types of aninals that can wear it, but their subtypes can't (i.e. carps, but not megacarps or magicarps). Should be a /mob/living/simple_animal.
	var/icon_state_alive
	var/icon_state_dead
	var/new_health = 100
	var/obj/item/weapon/stock_parts/cell/cell
	var/charge_rate = 10
	var/list/newVars = list()
	var/emag_active = 0
	var/night_vision_on = 0
	var/datum/hud/tactical/hud
	var/id_type
	var/headset_type
	var/hud_type

/obj/item/weapon/storage/tactical_harness/proc/create_hud(mob/living/simple_animal/wearer)
	if(hud_type && wearer.harness == src && wearer.client && !istype(wearer.hud_used, hud_type))
		hud = new hud_type(wearer)
		wearer.hud_used = hud

/obj/item/weapon/storage/tactical_harness/New()
	cell = new /obj/item/weapon/stock_parts/cell()
	SSobj.processing += src
	..()

/obj/item/weapon/storage/tactical_harness/Destroy()
	SSobj.processing -= src
	return ..()

/obj/item/weapon/storage/tactical_harness/process()
	if(cell)
		cell.give(charge_rate)

/obj/item/weapon/storage/tactical_harness/allowed(mob/M)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(check_access(H.get_active_hand()) || (istype(H) && check_access(H.wear_id)) )
			return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/canWear(mob/living/simple_animal/animal)//true if the animal could possibly wear it, even if it is already wearing one.
	if(!animal || !istype(animal))
		return 0
	for(var/type in wearable_by)
		if(istype(animal, type))
			return 1
	if(animal.type in wearable_by_exact)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/add_harness(var/mob/living/simple_animal/animal, var/mob/user = usr)
	if(!animal || animal.harness || !canWear(animal))
		return 0

	if(istype(loc, /mob))
		var/mob/holder = loc
		holder.unEquip(src)

	animal.harness	= src
	animal.icon_living = icon_state_alive
	animal.icon_dead = icon_state_dead
	animal.icon_state = (animal.stat & DEAD) ? animal.icon_dead : animal.icon_living
	animal.maxHealth =  new_health
	animal.health = (animal.health/animal.maxHealth)*new_health //same percent health.
	animal.pulling = new /obj/screen/pull/tac_harness()

	loc = animal
	set_night_vision(night_vision_on)
	if(id_type)
		animal.access_card = new id_type(animal)
	if(headset_type)
		animal.headset = new headset_type(animal)
	for(var/V in newVars)
		animal.vars[V] = newVars[V]
	qdel(animal.hud_used)
	animal.create_mob_hud()
	if(animal.hud_used)
		animal.hud_used.show_hud(HUD_STYLE_STANDARD)
	return 1

/obj/item/weapon/storage/tactical_harness/proc/remove_harness(var/unequip = 1)
	if(!istype(loc, /mob/living/simple_animal))
		return 0
	var/mob/living/simple_animal/wearer = loc
	if(wearer.harness != src)
		return 0
	wearer.icon_living = initial(wearer.icon_living)
	wearer.icon_dead = initial(wearer.icon_dead)
	wearer.icon_state = (wearer.stat & DEAD) ? wearer.icon_dead : wearer.icon_living
	wearer.maxHealth = initial(wearer.maxHealth)
	wearer.health = (wearer.health/wearer.maxHealth)*initial(wearer.health)//same percent health.
	qdel(wearer.access_card)
	qdel(wearer.headset)
	qdel(wearer.pulling)

	for(var/V in newVars)
		wearer.vars[V] = initial(wearer.vars[V])

	set_night_vision(0)

	if(unequip)
		wearer.unEquip(src)

	wearer.harness = null

	qdel(wearer.hud_used)
	wearer.create_mob_hud()
	if(wearer.hud_used)
		wearer.hud_used.show_hud(HUD_STYLE_STANDARD)
	return 1

/obj/item/weapon/storage/tactical_harness/proc/attempt_remove_harness(mob/user)
	if(!istype(loc, /mob/living/simple_animal))
		return 0
	var/mob/living/simple_animal/wearer = loc
	if(wearer.harness != src)
		return 0
	user.visible_message("<span class='danger'>[user] attempts to remove \the [src] from \the [wearer]!</span>", "<span class='warning'>You attempt to remove \the [src] from \the [wearer].</span>")
	if(do_after(user, 60, target = wearer))
		if(remove_harness())
			user.visible_message("<span class='danger'>[user] removes \the [src] from \the [wearer]!</span>", "<span class='warning'>You remove \the [src] from \the [wearer].</span>")
			return 1
	user.visible_message("<span class='danger'>[user] fails to remove \the [src] from \the [wearer]!</span>", "<span class='warning'>You fail to remove \the [src] from \the [wearer].</span>")
	return 0

/obj/item/weapon/storage/tactical_harness/proc/toggle_night_vision()
	if(hud)
		hud.toggle_nv_button.update_button_icon(src)
	set_night_vision(!night_vision_on)

/obj/item/weapon/storage/tactical_harness/proc/set_night_vision(var/on)
	night_vision_on = on
	if(hud)
		hud.toggle_nv_button.update_button_icon(src)
	if(istype(loc, /mob/living/simple_animal/))
		var/mob/living/simple_animal/animal = loc
		if(night_vision_on)
			animal.see_in_dark = 8
			animal.see_invisible = SEE_INVISIBLE_MINIMUM
		else
			animal.see_in_dark = initial(animal.see_in_dark)
			animal.see_invisible = initial(animal.see_invisible)

/obj/item/weapon/storage/tactical_harness/proc/toggle_emag()
	emag_active = !emag_active
	if(hud)
		hud.toggle_emag_button.update_button_icon(src)

/obj/item/weapon/storage/tactical_harness/proc/open_inventory(mob/user)
	if(user != loc)
		to_chat(user, "<span class='notice'>You view \the [src]'s storage pouch. You can add items, but only \the [loc] can remove them while \the [src] is being worn.</span>")
	orient2hud(user)
	if(user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/weapon/storage/tactical_harness/proc/on_melee_attack(mob/living/simple_animal/wearer, atom/target, proximity_flag)
	if(emag_active && proximity_flag)
		target.emag_act(src)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/on_ranged_attack(mob/living/simple_animal/wearer, atom/target, params)
	return 0

/*
//This code is for making the dolphin's harness un-openable except by people with syndie access. Leaving it here just in case.
/obj/item/weapon/storage/tactical_harness/content_can_dump(atom/dest_object, mob/user)//don't want to accidentaly dump all your weapons on the ground.
	return 0

/obj/item/weapon/storage/tactical_harness/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
	return 0

/obj/item/weapon/storage/tactical_harness/MouseDrop(over_object)
	if(over_object != usr)
		return
	if(!allowed(usr))
		to_chat(usr, "<span class='warning'>Access Denied</span>")
		return 0
	return ..()

/obj/item/weapon/storage/tactical_harness/attack_hand(mob/usr)
	if(!allowed(usr))
		to_chat(usr, "<span class='warning'>Access Denied</span>")
		return 0
	return ..()

/obj/item/weapon/storage/tactical_harness/can_be_inserted(obj/item/W, stop_messages = 0)
	if(!allowed(usr))
		return 0
	return ..()

/obj/item/weapon/storage/tactical_harness/remove_from_storage(obj/item/W, atom/new_location)
	if(!allowed(usr))
		return 0
	return ..()
*/

/////////// Ranged /////////////

/obj/item/weapon/storage/tactical_harness/ranged
	var/weapon_safety = 1
	var/selected_weapon = 0
	var/lastShot = 0
	var/list/obj/item/projectile/ranged_attacks = list()//each element = list(name, projectile, shot_cost, cooldown, sound, num_shots)

/obj/item/weapon/storage/tactical_harness/ranged/New()
	..()
	if(ranged_attacks.len)
		selected_weapon = 1


/obj/item/weapon/storage/tactical_harness/ranged/on_ranged_attack(mob/living/simple_animal/hostile/wearer, atom/target, params)
	if(!weapon_safety && ranged_attacks.len && (world.time > (lastShot + ranged_attacks[selected_weapon][4])) )
		lastShot = world.time
		var/i = ranged_attacks[selected_weapon][6]
		while(i > 0 && cell && cell.charge >= ranged_attacks[selected_weapon][3])
			cell.use(ranged_attacks[selected_weapon][3])
			wearer.FireProjectile(ranged_attacks[selected_weapon][2], ranged_attacks[selected_weapon][5], target, get_turf(wearer.targets_from))
			i--
			if(i > 0)
				sleep(2)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/ranged/proc/toggle_safety()
	weapon_safety = !weapon_safety
	var/datum/hud/tactical/syndicate/hud2 = hud
	hud2.toggle_safety_button.update_button_icon(src)

/obj/item/weapon/storage/tactical_harness/ranged/proc/cycle_weapon()
	selected_weapon = ranged_attacks.len ? selected_weapon % ranged_attacks.len + 1 : 0

///////////Syndicate/////////////

/obj/item/weapon/storage/tactical_harness/syndicate
	name = "tactical animal harness"
	desc = "A harness for a Syndicate tactical animal. This one will mold itself to the first valid animal it is placed on."
	wearable_by = list(/mob/living/simple_animal/hostile/retaliate/dolphin, /mob/living/simple_animal/hostile/carp/tactical)
	wearable_by_exact = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/carp/cayenne)
	var/refund_TC = 0
	var/failed_to_find_player = -1 //-1 means it hasn't tried to find a player yet, 1 means it has tried to find a player and failed, 0 means it has tried to find a player and succeeded. Here to prevent the creation of infinite sentient animals.

/obj/item/weapon/storage/tactical_harness/syndicate/add_harness(var/mob/living/simple_animal/hostile/animal, var/mob/user = usr)
	if(failed_to_find_player && !animal.ckey)
		var/list/carp_candidates = get_candidates(ROLE_OPERATIVE, 3000, ROLE_OPERATIVE)
		if(carp_candidates.len == 0)
			to_chat(user, "<span class='warning'>\The [animal] refuses to cooperate, it looks like it won't be helping you on this mission.</span>")
			failed_to_find_player = 1
			return

		if(istype(animal, /mob/living/simple_animal/hostile/retaliate/dolphin))
			to_chat(user, "<span class='notice'>\The [src] molds itself to the shape of \the [animal].</span>")
			qdel(src)
			var/obj/item/weapon/storage/tactical_harness/ranged/the_harness = new /obj/item/weapon/storage/tactical_harness/ranged/syndicate/dolphin()
			the_harness.add_harness(animal, user)
		else if(animal.type == /mob/living/simple_animal/hostile/carp)
			to_chat(user, "<span class='notice'>\The [src] molds itself to the shape of \the [animal].</span>")
			qdel(src)
			var/obj/item/weapon/storage/tactical_harness/ranged/the_harness = new /obj/item/weapon/storage/tactical_harness/ranged/syndicate/carp()
			the_harness.add_harness(animal, user)
		else
			to_chat(user, "<span class='notice'>\The [src] does nothing. It looks like it is not compatible with this type of creature.</span>")
			return

		var/client/C = pick(carp_candidates)
		animal.ckey = C.key
		failed_to_find_player = 0
		to_chat(animal, "<span class='notice'>You are a space [istype(animal, /mob/living/simple_animal/hostile/retaliate/dolphin) ? "dolphin" : "carp"] trained by the syndicate to assist their elite commando teams. Obey and assist your syndicate masters at all costs.</span>")
		animal.faction += "syndicate"

/obj/item/weapon/storage/tactical_harness/ranged/syndicate/New()
	..()
	for(var/i=0,i<5;i++)
		new /obj/item/weapon/reagent_containers/food/snacks/syndicake(src)

/obj/item/weapon/storage/tactical_harness/ranged/syndicate/add_harness(var/mob/living/simple_animal/animal, var/mob/user = usr)
	. = ..()
	if(.)
		if(!(/obj/item/weapon/reagent_containers/food/snacks/syndicake in animal.eats))
			animal.eats += /obj/item/weapon/reagent_containers/food/snacks/syndicake
			animal.eats[/obj/item/weapon/reagent_containers/food/snacks/syndicake] = 10

///////////Tactical Dolphin////////////////

/obj/item/weapon/storage/tactical_harness/ranged/syndicate/dolphin
	name = "tactical dolphin harness"
	desc = "A harness for a Syndicate tactical dolphin."
	wearable_by = list(/mob/living/simple_animal/hostile/retaliate/dolphin)
	icon_state_alive = "tactical_dolphin"
	icon_state_dead = "tactical_dolphin_dead"
	newVars = list("name" = "tactical dolphin", "desc" = "A highly trained space dolphin used by the syndicate to provide light fire support and space superiority for elite commando teams.", "speed" = -0.3, "melee_damage_lower" = 15, "melee_damage_upper" = 15)
	ranged_attacks = list(list("laser", /obj/item/projectile/beam, 90, 20, 'sound/weapons/sear.ogg', 2))
	req_access = list(access_syndicate)
	headset_type = /obj/item/device/radio/headset/syndicate
	id_type = /obj/item/weapon/card/id/syndicate
	hud_type = /datum/hud/tactical/syndicate

///////////Tactical Carp///////////////////
/obj/item/weapon/storage/tactical_harness/ranged/syndicate/carp
	name = "tactical carp harness"
	desc = "A harness for a Syndicate tactical carp."
	wearable_by = list(/mob/living/simple_animal/hostile/carp/tactical)
	wearable_by_exact = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/carp/cayenne)
	icon_state_alive = "tactical_carp"
	icon_state_dead = "tactical_carp_dead"
	newVars = list("name" = "tactical space carp", "desc" = "A highly trained space carp used by the syndicate to provide heavy fire support and space superiority for elite commando teams.", "melee_damage_lower" = 15, "melee_damage_upper" = 15)
	ranged_attacks = list(list("heavy laser", /obj/item/projectile/beam/laser/heavylaser, 150, 20, 'sound/weapons/sear.ogg', 1))
	new_health = 150
	req_access = list(access_syndicate)
	headset_type = /obj/item/device/radio/headset/syndicate
	id_type = /obj/item/weapon/card/id/syndicate
	hud_type = /datum/hud/tactical/syndicate

///////////Tactical Corgi///////////////////
/obj/item/weapon/storage/tactical_harness/corgi
	name = "tactical corgi harness"
	desc = "A harness for a Centcomm tactical corgi."
	wearable_by = list(/mob/living/simple_animal/pet/dog/corgi)
	icon_state_alive = "tactical_corgi"
	icon_state_dead = "tactical_corgi_dead"
	newVars = list("name" = "tactical corgi", "desc" = "A highly trained corgi used by centcomm for drug screening and as support for Emergency Response Teams.", "melee_damage_lower" = 15, "melee_damage_upper" = 15, "icon" = 'icons/mob/animal.dmi', "speed" = -0.2, "attack_sound" = 'sound/weapons/bite.ogg')
	new_health = 150
	headset_type = /obj/item/device/radio/headset/headset_cent
	id_type = /obj/item/weapon/card/id/ert
	hud_type = /datum/hud/tactical/corgi
	var/stun_on = 0
	var/stun_amount = 7
	var/hitcost = 100

/obj/item/weapon/storage/tactical_harness/corgi/on_melee_attack(mob/living/simple_animal/wearer, atom/target, proximity)
	if(..())
		return 1
	if(!proximity || !stun_on)
		return 0
	var/mob/living/carbon/C = target
	if(istype(C))
		if(cell.charge >= hitcost)
			wearer.do_attack_animation(target)
			cell.use(hitcost)
			C.visible_message("<span class='danger'>[wearer] has stunned [C]!</span>", "<span class='userdanger'>[wearer] has stunned you!</span>")
			playsound(wearer.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			C.Stun(stun_amount)
			C.Weaken(stun_amount)
			C.apply_effect(STUTTER, stun_amount)
		else
			to_chat(wearer, "<span class='warning'>Not enough charge to stun!</span>")
		return 1
	return 0
