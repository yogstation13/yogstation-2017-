//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO
ASHTRAY

CIGARETTE PACKETS ARE IN FANCY.DM
*/

///////////
//MATCHES//
///////////
/obj/item/weapon/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = 0
	var/smoketime = 5
	w_class = 1
	origin_tech = "materials=1"
	heat = 1000

/obj/item/weapon/match/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		matchburnout()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/weapon/match/fire_act()
	matchignite()

/obj/item/weapon/match/proc/matchignite()
	if(lit == 0)
		playsound(loc, 'sound/effects/match_light.ogg', 50, 1, -1)
		lit = 1
		icon_state = "match_lit"
		damtype = "fire"
		force = 3
		hitsound = 'sound/items/welder.ogg'
		item_state = "cigon"
		name = "lit match"
		desc = "A match. This one is lit."
		attack_verb = list("burnt","singed")
		START_PROCESSING(SSobj, src)
		update_icon()
	return

/obj/item/weapon/match/proc/matchburnout()
	if(lit == 1)
		lit = -1
		damtype = "brute"
		force = initial(force)
		icon_state = "match_burnt"
		item_state = "cigoff"
		name = "burnt match"
		desc = "A match. This one has seen better days."
		attack_verb = list("attacked", "hit")
		STOP_PROCESSING(SSobj, src)

/obj/item/weapon/match/dropped(mob/user)
	matchburnout()
	return ..()

/obj/item/weapon/match/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return
	M.IgniteMob()
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M,user)
	if(lit && cig && user.a_intent == "help")
		if(cig.lit)
			to_chat(user, "<span class='notice'>The [cig.name] is already lit.</span>")
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/proc/help_light_cig(mob/living/carbon/M, mob/living/carbon/user)
	if(!iscarbon(M))
		return
	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		return cig

/obj/item/weapon/match/is_hot()
	return lit * heat

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	body_parts_covered = null
	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/weapon/cigbutt
	var/lastHolder = null
	var/smoketime = 300
	var/chem_volume = 30
	heat = 1000

/obj/item/clothing/mask/cigarette/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is huffing the [src.name] as quickly as they can! It looks like \he's trying to give \himself cancer.</span>")
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/cigarette/New()
	..()
	create_reagents(chem_volume) // making the cigarette a chemical holder with a maximum volume of 15
	reagents.set_reacting(FALSE) // so it doesn't react until you light it
	reagents.add_reagent("nicotine", 15)

/obj/item/clothing/mask/cigarette/Destroy()
	if(reagents)
		qdel(reagents)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/clothing/mask/cigarette/attackby(obj/item/weapon/W, mob/user, params)
	if(!lit && smoketime > 0 && W.is_hot())
		var/lighting_text = is_lighter(W,user)
		if(lighting_text)
			light(lighting_text)
	else
		return ..()

/obj/item/clothing/mask/cigarette/afterattack(obj/item/weapon/reagent_containers/glass/glass, mob/user, proximity)
	if(!proximity || lit) //can't dip if cigarette is lit (it will heat the reagents in the glass instead)
		return
	if(istype(glass))	//you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, "<span class='notice'>You dip \the [src] into \the [glass].</span>")
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, "<span class='notice'>[glass] is empty.</span>")
			else
				to_chat(user, "<span class='notice'>[src] is full.</span>")

/obj/item/clothing/mask/cigarette/proc/is_lighter(obj/item/O, mob/user)
	var/lighting_text = null
	if(istype(O, /obj/item/weapon/weldingtool))
		lighting_text = "<span class='notice'>[user] casually lights the [name] with [O], what a badass.</span>"
	else if(istype(O, /obj/item/weapon/lighter/greyscale)) // we have to check for this first -- zippo lighters are default
		lighting_text = "<span class='notice'>After some fiddling, [user] manages to light their [name] with [O].</span>"
	else if(istype(O, /obj/item/weapon/lighter))
		lighting_text = "<span class='rose'>With a single flick of their wrist, [user] smoothly lights their [name] with [O]. Damn they're cool.</span>"
	else if(istype(O, /obj/item/weapon/melee/energy))
		var/in_mouth = ""
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.wear_mask == src)
				in_mouth = ", barely missing their nose"
		lighting_text = "<span class='warning'>[user] swings their \
			[O][in_mouth]. They light their [name] in the process.</span>"
	else if(istype(O, /obj/item/device/assembly/igniter))
		lighting_text = "<span class='notice'>[user] fiddles with [O], and manages to light their [name].</span>"
	else if(istype(O, /obj/item/device/flashlight/flare))
		lighting_text = "<span class='notice'>[user] lights their [name] with [O] like a real badass.</span>"
	else if(O.is_hot())
		lighting_text = "<span class='notice'>[user] lights their [name] with [O].</span>"
	return lighting_text

/obj/item/clothing/mask/cigarette/proc/light(flavor_text = null)
	if(lit)
		return

	lit = TRUE
	name = "lit [name]"
	attack_verb = list("burnt", "singed")
	hitsound = 'sound/items/welder.ogg'
	damtype = "fire"
	force = 4
	if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		if(ismob(loc))
			var/mob/M = loc
			M.unEquip(src, 1)
		qdel(src)
		return
	if(reagents.get_reagent_amount("welding_fuel")) // the fuel explodes, too, but much less violently
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount("welding_fuel") / 5, 1), get_turf(src), 0, 0)
		e.start()
		if(ismob(loc))
			var/mob/M = loc
			M.unEquip(src, 1)
		qdel(src)
		return
	// allowing reagents to react after being lit
	reagents.set_reacting(TRUE)
	reagents.handle_reactions()
	icon_state = icon_on
	item_state = icon_on
	if(flavor_text)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
	START_PROCESSING(SSobj, src)

	//can't think of any other way to update the overlays :<
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_mask()
		M.update_inv_l_hand()
		M.update_inv_r_hand()


/obj/item/clothing/mask/cigarette/proc/handle_reagents()
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				if(prob(15)) // so it's not an instarape in case of acid
					var/fraction = min(REAGENTS_METABOLISM/reagents.total_volume, 1)
					reagents.reaction(C, INGEST, fraction)
				reagents.trans_to(C, REAGENTS_METABOLISM)
				return
		reagents.remove_any(REAGENTS_METABOLISM)


/obj/item/clothing/mask/cigarette/process()
	var/turf/location = get_turf(src)
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	smoketime--
	if(smoketime < 1)
		new type_butt(location)
		if(ismob(loc))
			to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
			M.unEquip(src, 1)	//un-equip it so the overlays can update //Force the un-equip so the overlays update
		qdel(src)
		return
	open_flame()
	if(reagents && reagents.total_volume)
		handle_reagents()

/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on \the [src], putting it out instantly.</span>")
		new type_butt(user.loc)
		new /obj/effect/decal/cleanable/ash(user.loc)
		qdel(src)
	return ..()

/obj/item/clothing/mask/cigarette/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()
	if(M.on_fire && !lit)
		light("<span class='notice'>[user] lights [src] with [M]'s burning body. What a cold-blooded badass.</span>")
		return
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M,user)
	if(lit && cig && user.a_intent == "help")
		if(cig.lit)
			to_chat(user, "<span class='notice'>The [cig.name] is already lit.</span>")
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		return ..()

/obj/item/clothing/mask/cigarette/fire_act()
	light()

/obj/item/clothing/mask/cigarette/is_hot()
	return lit * heat

/obj/item/clothing/mask/cigarette/rollie
	name = "rollie"
	desc = "A roll of dried plant matter wrapped in thin paper."
	icon_state = "spliffoff"
	icon_on = "spliffon"
	icon_off = "spliffoff"
	type_butt = /obj/item/weapon/cigbutt/roach
	throw_speed = 0.5
	item_state = "spliffoff"
	smoketime = 180
	chem_volume = 50

/obj/item/clothing/mask/cigarette/rollie/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

/obj/item/clothing/mask/cigarette/rollie/trippy/New()
	..()
	reagents.add_reagent("mushroomhallucinogen", 50)
	light()
	//for(var/mob/M in player_list)	M << 'sound/misc/Smoke_Weed_Everyday.ogg'


/obj/item/weapon/cigbutt/roach
	name = "roach"
	desc = "A manky old roach, or for non-stoners, a used rollup."
	icon_state = "roach"

/obj/item/weapon/cigbutt/roach/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	type_butt = /obj/item/weapon/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 40

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 2000
	chem_volume = 80


/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 50

/obj/item/weapon/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 0

/obj/item/weapon/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 0
	chem_volume = 100
	var/packeditem = 0

/obj/item/clothing/mask/cigarette/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/cigarette/pipe/Destroy()
	if(reagents)
		qdel(reagents)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/clothing/mask/cigarette/pipe/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask()
			packeditem = 0
			name = "empty [initial(name)]"
		STOP_PROCESSING(SSobj, src)
		return
	open_flame()
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		handle_reagents()
	return


/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = O
		if(!packeditem)
			if(G.dry == 1)
				to_chat(user, "<span class='notice'>You stuff [O] into [src].</span>")
				smoketime = 400
				packeditem = 1
				name = "[O.name]-packed [initial(name)]"
				if(O.reagents)
					O.reagents.trans_to(src, O.reagents.total_volume)
				qdel(O)
			else
				to_chat(user, "<span class='warning'>It has to be dried first!</span>")
		else
			to_chat(user, "<span class='warning'>It is already packed!</span>")
	else
		var/lighting_text = is_lighter(O,user)
		if(lighting_text)
			if(smoketime > 0)
				light(lighting_text)
			else
				to_chat(user, "<span class='warning'>There is nothing to smoke!</span>")
		else
			return ..()

/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user)
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>", "<span class='notice'>You put out [src].</span>")
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		STOP_PROCESSING(SSobj, src)
		return
	if(!lit && smoketime > 0)
		to_chat(user, "<span class='notice'>You empty [src] onto [location].</span>")
		new /obj/effect/decal/cleanable/ash(location)
		packeditem = 0
		smoketime = 0
		reagents.clear_reagents()
		name = "empty [initial(name)]"
	return

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen and kept popular in the modern age and beyond by space hipsters. Can be loaded with objects."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	smoketime = 0


/////////
//ZIPPO//
/////////
/obj/item/weapon/lighter
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "zippo"
	item_state = "zippo"
	w_class = 1
	flags = CONDUCT
	slot_flags = SLOT_BELT
	heat = 1500
	var/lit = 0
	var/stop_bleeding = 600


/obj/item/weapon/lighter/greyscale
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon_state = "lighter"
	stop_bleeding = 525

/obj/item/weapon/lighter/greyscale/New()
	var/image/I = image(icon,"lighter-overlay")
	I.color = color2hex(randomColor(1))
	overlays += I

/obj/item/weapon/lighter/update_icon()
	icon_state = lit ? "[icon_state]_on" : "[initial(icon_state)]"

/obj/item/weapon/lighter/attack_self(mob/living/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			update_icon()
			force = 5
			damtype = "fire"
			hitsound = 'sound/items/welder.ogg'
			attack_verb = list("burnt", "singed")
			if(!istype(src, /obj/item/weapon/lighter/greyscale))
				user.visible_message("Without even breaking stride, [user] flips open and lights [src] in one smooth movement.", "<span class='notice'>Without even breaking stride, you flip open and light [src] in one smooth movement.</span>")
			else
				var/mob/living/carbon/human/H = user
				var/prot = 0
				if(istype(user, /mob/living/carbon/human))
					var/obj/item/clothing/gloves/G = H.gloves
					if(istype(G) && G.max_heat_protection_temperature)
						prot = (G.max_heat_protection_temperature > 360) // lazy code. nothing else seemed to work as properly as this though

				if(!istype(src, /obj/item/weapon/lighter/greyscale))
					user.visible_message("Without even breaking stride, [user] flips open and lights [src] in one smooth movement.", "<span class='notice'>Without even breaking stride, you flip open and light [src] in one smooth movement.</span>")
				else
					if(prot > 0)
						user.visible_message("After a few attempts, [user] manages to light [src], without burning themself.", "<span class='notice'>After a few attempts, you manage to light [src]. Your fire-resistant gloves shield you from burning yourself.</span>")
						return
					else if(prob(75))
						user.visible_message("After a few attempts, [user] manages to light [src].", "<span class='notice'>After a few attempts, you manage to light [src].</span>")
					else
						var/hitzone = user.r_hand == src ? "r_hand" : "l_hand"
						user.apply_damage(5, BURN, hitzone)
						user.visible_message("<span class='warning'>After a few attempts, [user] manages to light [src] - they however burn their finger in the process.</span>", "<span class='warning'>You burn yourself while lighting the lighter!</span>")

			user.AddLuminosity(1)
			START_PROCESSING(SSobj, src)
		else
			lit = 0
			update_icon()
			hitsound = "swing_hit"
			force = 0
			attack_verb = list("attacked", "hit")
			if(!istype(src, /obj/item/weapon/lighter/greyscale))
				user.visible_message("You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing. Wow.", "<span class='notice'>You quietly shut off [src] without even looking at what you're doing. Wow.</span>")
			else
				user.visible_message("[user] quietly shuts off [src].", "<span class='notice'>You quietly shut off [src].")
			user.AddLuminosity(-1)
			STOP_PROCESSING(SSobj, src)
	else
		return ..()
	return

/obj/item/weapon/lighter/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(lit && user.a_intent == "help")
			if(H.bleed_rate && !H.bleedsuppress)	// Prioritize cauterizing over lighting a cig.
				var/hitzone = user.zone_selected
				H.suppress_bloodloss(stop_bleeding)
				H.apply_damage(rand(5,10), BURN, hitzone)
				if (H.bleed_rate >= 1.5) // a simple lighter won't fix your problems.
					to_chat(user, "<span class='alert'>There is too much blood coming out of the wound for you to fix it with [src] and you screw up!</span>")
					H.visible_message("<span class='alert'>[H]'s wounds are burned by [src], but are unable to be closed by it's flame!</span>")
					return

				if(H == user)
					to_chat(user, "<span class='notice'>You mend your bleeding wound with [src], sealing it completely. Also looking like a total badass.</span>")
					H.visible_message("<span class='alert'>[user] mends their bleeding wounds with a lighter! What a badass.</span>")
				else
					H.visible_message("<span class='alert'>[user] uses [src] to close some of [H]'s wounds by burning them fiercly!</span>")

				H.cauterized = 1
				return

			var/obj/item/clothing/mask/cigarette/cig = help_light_cig(H, user)
			if(cig)
				if(cig.lit)
					to_chat(user, "<span class='notice'>The [cig.name] is already lit.</span>")
					return

				if(H == user)
					cig.attackby(src, user)
				else
					if(!istype(src, /obj/item/weapon/lighter/greyscale))
						cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M]. Their arm is as steady as the unflickering flame they light \the [cig] with.</span>")
					else
						cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
				return
	else
		if(lit)
			M.IgniteMob()

	..()

/obj/item/weapon/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

/obj/item/weapon/lighter/pickup(mob/user)
	..()
	if(lit)
		SetLuminosity(0)
		user.AddLuminosity(1)
	return


/obj/item/weapon/lighter/dropped(mob/user)
	..()
	if(lit)
		if(user)
			user.AddLuminosity(-1)
		SetLuminosity(1)
	return

/obj/item/weapon/lighter/is_hot()
	return lit * heat

///////////
//ROLLING//
///////////
/obj/item/weapon/rollingpaper
	name = "rolling paper"
	desc = "A thin piece of paper used to make fine smokeables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper"
	w_class = 1

/obj/item/weapon/rollingpaper/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/O = target
		if(O.dry)
			user.unEquip(target, 1)
			user.unEquip(src, 1)
			var/obj/item/clothing/mask/cigarette/rollie/R = new /obj/item/clothing/mask/cigarette/rollie(user.loc)
			R.chem_volume = target.reagents.total_volume
			target.reagents.trans_to(R, R.chem_volume)
			user.put_in_active_hand(R)
			to_chat(user, "<span class='notice'>You roll the [target.name] into a rolling paper.</span>")
			R.desc = "Dried [target.name] rolled up in a thin piece of paper."
			qdel(target)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to dry this first!</span>")
	else
		..()

///////////
//ASHTRAY//
///////////
/obj/item/weapon/ashtray
	name = "ashtray"
	desc = "A small, plastic tray to stub your cigarettes in."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "ashtray0"
	w_class = 1
	var/amount_of_stubs = 0
	var/capacity = 5

/obj/item/weapon/ashtray/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] dumps the contents of [src] into his mouth!</span>")
	playsound(loc, 'sound/items/eatfood.ogg', 50, 1, -1)
	return (TOXLOSS)

/obj/item/weapon/ashtray/update_icon()
	if(amount_of_stubs <= 2)
		icon_state = "ashtray[amount_of_stubs]"
	else
		icon_state = "ashtray2"

/obj/item/weapon/ashtray/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/clothing/mask/cigarette))
		if(amount_of_stubs == capacity)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		else
			amount_of_stubs++
			update_icon()
			user.visible_message("[user] stubs [O] in [src].", "<span class='notice'>You stub [O] in [src].</span>")
			qdel(O)

/obj/item/weapon/ashtray/attack_self(mob/living/user)
	if(!amount_of_stubs)
		return
	else
		to_chat(user, "<span class='notice'>You empty [src] onto the ground.</span>")
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		amount_of_stubs = 0
		update_icon()


///////////////
//VAPE NATION//
///////////////
/obj/item/clothing/mask/vape
	name = "\improper E-Cigarette"
	desc = "A classy and highly sophisticated electronic cigarette, for classy and dignified gentlemen. A warning label reads \"Warning: Do not fill with flammable materials.\""//<<< i'd vape to that.
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = null
	item_state = null
	w_class = 1
	var/chem_volume = 100
	var/vapetime = 0 //this so it won't puff out clouds every tick
	var/screw = 0 // kinky
	var/super = 0 //for the fattest vapes dude.
	var/vapetype = null //only for tanks
	var/emagged = 0
	var/wattage = 1 //Shit tier clouds :(

/obj/item/clothing/mask/vape/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] starts sucking on [src] with extreme vigor!")//it doesn't give you cancer, it is cancer
	user.visible_message("<span class='suicide'>[user] is trying to hotbox the room!")
	if(do_after(user, 50, target=src))
		hotbox()
		user.visible_message("<span class='suicide'>[user] rips the fattest cloud in existence! their coil disintegrates into embers knowing its job to be done as smoke fills the room.")
	return (TOXLOSS|OXYLOSS)


/obj/item/clothing/mask/vape/proc/hotbox() //Fill an entire room with MIST
	var/datum/effect_system/smoke_spread/chem/s = new
	if(emagged)
		s.set_up(reagents, 20, loc, silent=TRUE)
	if(super)
		s.set_up(reagents, 8, loc, silent=TRUE)
	else
		s.set_up(reagents, 4, loc, silent=TRUE)
	s.start()
	vapetime = 0

/obj/item/clothing/mask/vape/Initialize(mapload, param_color)
	. = ..()
	create_reagents(chem_volume)
	reagents.set_reacting(FALSE) // so it doesn't react until you light it
	reagents.add_reagent("nicotine", (chem_volume/2)) //half tank to start
	if(!icon_state)
		if(!param_color)
			param_color = pick("red","blue","black","white","green","purple","yellow","orange")
		icon_state = "[param_color]_vape"
		item_state = "[param_color]_vape"

/obj/item/clothing/mask/vape/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/reagent_containers))
		if(reagents.total_volume < chem_volume)
			if(O.reagents.total_volume > 0)
				O.reagents.trans_to(src,25)
				to_chat(user, "<span class='notice'>You add the contents of [O] to [src].</span>")
			else
				to_chat(user, "<span class='warning'>[O] is empty!</span>")
		else
			to_chat(user, "<span class='warning'>[src] can't hold anymore reagents!</span>")

	if(istype(O, /obj/item/weapon/screwdriver))
		if(!screw)
			screw = 1
			to_chat(user, "<span class='notice'>You open the cap on [src].</span>")
			if(super)
				add_overlay("[vapetype]vapeopen_med")
			else
				add_overlay("[vapetype]vapeopen_low")
		else
			screw = 0
			to_chat(user, "<span class='notice'>You close the cap on [src].</span>")
			cut_overlays()

	if(istype(O, /obj/item/device/multitool))
		if(screw && !emagged)//also kinky
			if(!super)
				cut_overlays()
				super = 1
				to_chat(user, "<span class='notice'>You increase the voltage of [src].</span>")
				wattage += 1
				add_overlay("vapeopen_med")
			else
				cut_overlays()
				super = 0
				to_chat(user, "<span class='notice'>You decrease the voltage of [src].</span>")
				add_overlay("vapeopen_low")
				wattage -= 1

		if(screw && emagged)
			to_chat(user, "<span class='notice'>[src] can't be modified!</span>")


/obj/item/clothing/mask/vape/emag_act(mob/user)// I WON'T REGRET WRITTING THIS, SURLY.
	if(screw)
		if(!emagged)
			cut_overlays()
			emagged = TRUE
			super = 0
			to_chat(user, "<span class='warning'>You maximize the voltage of [src].</span>")
			add_overlay("[vapetype]vapeopen_high")
			wattage += 2
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread //for effect
			sp.set_up(5, 1, src)
			sp.start()
		else
			to_chat(user, "<span class='warning'>[src] is already emagged!</span>")
	else
		to_chat(user, "<span class='notice'>You need to open the cap to do that.</span>")

/obj/item/clothing/mask/vape/attack_self(mob/user)
	if(reagents.total_volume > 0)
		to_chat(user, "<span class='notice'>You empty [src] of all reagents.</span>")
		reagents.clear_reagents()
	return

/obj/item/clothing/mask/vape/equipped(mob/user, slot)
	if(slot == slot_wear_mask)
		if(!screw)
			to_chat(user, "<span class='notice'>You start puffing on the vape.</span>")
			reagents.set_reacting(TRUE)
			START_PROCESSING(SSobj, src)
		else //it will not start if the vape is opened.
			to_chat(user, "<span class='warning'>You need to close the cap first!</span>")

/obj/item/clothing/mask/vape/dropped(mob/user)
	var/mob/living/carbon/C = user
	if(C.get_item_by_slot(slot_wear_mask) == src)
		reagents.set_reacting(FALSE)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/vape/proc/hand_reagents()//had to rename to avoid duplicate error
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				var/fraction = min(REAGENTS_METABOLISM/reagents.total_volume, 1) //this will react instantly, making them a little more dangerous than cigarettes
				reagents.reaction(C, INGEST, fraction)
				if(!reagents.trans_to(C, REAGENTS_METABOLISM))
					reagents.remove_any(REAGENTS_METABOLISM)
				if(reagents.get_reagent_amount("welding_fuel"))
					//HOT STUFF
					C.fire_stacks = 2
					C.IgniteMob()

				if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
					var/datum/effect_system/reagents_explosion/e = new()
					e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
					e.start()
					qdel(src)
				return
		reagents.remove_any(REAGENTS_METABOLISM)

/obj/item/clothing/mask/vape/process()
	var/mob/living/M = loc

	if(isliving(loc))
		M.IgniteMob()

	vapetime++

	if(!reagents.total_volume)
		if(ismob(loc))
			to_chat(M, "<span class='notice'>[src] is empty!</span>")
			STOP_PROCESSING(SSobj, src)
			//it's reusable so it won't unequip when empty
		return
	//open flame removed because vapes are a closed system, they wont light anything on fire

	if(super && vapetime > 2)//Time to start puffing those fat vapes, yo.
		var/datum/effect_system/smoke_spread/chem/s = new
		s.set_up(reagents, wattage, loc, silent=TRUE)
		s.start()
		vapetime = 0

	if(emagged && vapetime > 2)
		var/datum/effect_system/smoke_spread/chem/s = new
		s.set_up(reagents, wattage*2, loc, silent=TRUE)
		s.start()
		vapetime = 0
		if(prob(5))//small chance for the vape to break and deal damage if it's emagged
			M.apply_damage(20, BURN, "head")
			M.Weaken(5)
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread
			sp.set_up(5, 1, src)
			sp.start()
			to_chat(M, "<span class='userdanger'>[src] suddenly explodes in your mouth!</span>")
			qdel(src)
			return

	if(reagents && reagents.total_volume)
		hand_reagents()



/////////////////////////////////////////////
//Tank vapes for ripping the FATTEST clouds//
/////////////////////////////////////////////
/obj/item/clothing/mask/vape/tank
	name = "\improper Tank Vape"
	desc = "A tank like box with a screen on it, it is basic but should be able to rip FAT clouds were you to try.."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "tank_vape"
	item_state = "tank_vape"
	w_class = 1
	chem_volume = 200 //it's a tank, fuck
	super = 1 //FAT CLOUDS
	vapetype = "tank"
	wattage = 2

/obj/item/clothing/mask/vape/tank/wood
	name = "\improper Wooden Tank Vape"
	desc = "A classy looking tank vape with a wooden veneer, extra classy and smooth but also perfectly able to RIP FAT CLOUDS."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "tank_vape_wood"
	item_state = "tank_vape_wood"
	w_class = 1
	chem_volume = 250 //it's a tank, fuck

/obj/item/clothing/mask/vape/tank/tpriv
	name = "\improper T-priv Tank Vape"
	desc = "A cloud machine capable of holding a ludicrous amount of juice, it comes preset on a high wattage."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "tank_vape_tpriv"
	item_state = "tank_vape_tpriv"
	w_class = 1
	chem_volume = 500 //FUCK

/obj/item/clothing/mask/vape/tank/syndie
	name = "\improper Gorlex Cloud Ripper 5,000,000"
	desc = "If your lungs survive this I will be thoroughly impressed."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "tank_vape_syndicate"
	item_state = "tank_vape_syndicate"
	w_class = 1
	chem_volume = 1000 //FUCK

/obj/item/clothing/mask/vape/tank/equipped(mob/user, slot)
	if(slot == slot_wear_mask)
		if(!screw)
			to_chat(user, "<span class='notice'>You feels your lungs melting as you rip MASSIVE clouds</span>")
			reagents.set_reacting(TRUE)
			START_PROCESSING(SSobj,src) //Vape = MAXIMUM PRIORITY
			icon_state += "_rip" //rip a fat one
		else //it will not start if the vape is opened.
			to_chat(user, "<span class='warning'>You need to close the cap first!</span>")

/obj/item/clothing/mask/vape/tank/dropped(mob/user)
	var/mob/living/carbon/C = user
	if(C.get_item_by_slot(slot_wear_mask) == src)
		reagents.set_reacting(FALSE)
		STOP_PROCESSING(SSobj, src)
		icon_state = initial(icon_state) //rip a fat one