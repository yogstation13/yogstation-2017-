/obj/structure/guillotine
	name = "guillotine"
	desc = "A primitive wooden lattice with a blade suspended in mid-air, alt click it to activate it and use a screwdriver on it to target other limbs, or wrench it to deconstruct it."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "guillotine"
	anchored = 1
	can_buckle = 1
	buckle_lying = 1
	var/mob/living/carbon/restrained_mob
	var/chopsound = 'sound/effects/guillotineslice.ogg'
	var/upgrade_chop_sound = null
	var/escapeTime = 200 //20 seconds to wiggle out of it
	var/strapTime = 150 // 15 seconds to strap someone in properly. This is an instakill after all!
	layer = 4.5
	var/upgraded = FALSE
	var/target_mode = "head"

/obj/structure/guillotine/user_buckle_mob(mob/living/M, mob/user)
	src.visible_message("[user] is strapping [M] into [src]!")
	icon_state = initial(icon_state)
	if(M.loc == loc)
		if(!restrained_mob)
			restrained_mob = null
			if(do_after(user, strapTime, target = src))
				. = ..()
				restrained_mob = M
		//	else
		//		to_chat(user, "Lay [M] on the guillotine to fasten their shackles.")
		else
			to_chat(user, "[restrained_mob] is already fastened in to [src]! unbuckle them first.")
	else
		to_chat(user, "Lay [M] on the guillotine to fasten their shackles.")

/obj/structure/guillotine/relaymove(mob/living/restrained, direction)
	TryEscape(restrained, restrained)


/obj/structure/guillotine/attackby(obj/item/I, mob/living/user, proximity)
	if(!upgraded)
		if(istype(I, /obj/item/stack/cable_coil))
			to_chat(user, "You haphazardly wind [I] around [src], increasing its revolutions per minute as well as the time that it will take to free someone from it.")
			desc += "-it seems to have some cables woven around the stocks. It'll take extra time to escape from it."
			escapeTime += 30
			upgraded = TRUE
			return 1
	if(istype(I, /obj/item/weapon/screwdriver))
		switch(target_mode)
			if("head")
				to_chat(user, "You start adjusting [src] to chop off tails instead!")
				if(do_after(user,100, target = src))
					target_mode = "tail"
					dir = 8
			if("tail")
				to_chat(user, "You start adjusting [src] to chop off heads instead!")
				if(do_after(user,100, target = src))
					target_mode = "head"
					dir = 1
	if(istype(I, /obj/item/weapon/wrench))
		to_chat(user, "You are deconstructing [src]")
		if(do_after(user,100, target = src))
			var/obj/item/stack/sheet/mineral/wood/thewood = new /obj/item/stack/sheet/mineral/wood(src.loc)
			thewood.amount = 5
			new /obj/item/weapon/kitchen/knife/butcher(src.loc)
			var/obj/item/stack/cable_coil/thecable = new /obj/item/stack/sheet/mineral/wood(src.loc)
			thecable.amount = 3
			qdel(src)
	if(istype(I, /obj/item/weapon/crowbar))
		if(do_after(user,100, target = src))
			if(anchored)
				to_chat(user, "You unanchor [src]")
				anchored = 0
			else
				to_chat(user, "You anchor [src]")
				anchored = 1

/obj/structure/guillotine/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(restrained_mob)
		if(user != restrained_mob)
			src.visible_message("[user] is freeing [buckled_mob] from [src]!")
			if(do_after(user,escapeTime, target = buckled_mob))
				restrained_mob = null
				return ..()
		else
			if(TryEscape(buckled_mob, buckled_mob))
				restrained_mob = null
				return ..()

/obj/structure/guillotine/proc/TryEscape(mob/living/restrained,mob/user)
	if(user == restrained_mob)
		src.visible_message("[restrained] shakes around wildly, trying to break free of [src]!")
		restrained_mob.do_jitter_animation(70)
		if(do_after(user,escapeTime, target = src))
			return 1
		return 0
	else
		return 0

/obj/structure/guillotine/AltClick(mob/living/user)
	if(restrained_mob)
		if(user == restrained_mob)
			to_chat(user, "You knock the guillotine with your hand, causing its blade to fall")
			Kill()
		else
			to_chat(user, "You knock [src], causing its blade to fall down on [restrained_mob]!")
			Kill()
	else
		to_chat(user, "Put your victim in first")


/obj/structure/guillotine/proc/Kill(mob/living/user)
	if(restrained_mob)
		icon_state = initial(icon_state)
		icon_state += "-drop"
		switch(target_mode)
			if("head")
				var/mob/living/carbon/human/H = restrained_mob
				var/obj/item/bodypart/B = H.get_bodypart(target_mode)
				if(B)
					playsound(loc, chopsound, 50, 1)
					B.dismember()
					icon_state = initial(icon_state)
					restrained_mob.unbuckle_mob(src,force=1)
					return 1
			if("tail")
				var/mob/living/carbon/human/L = restrained_mob
				if(("tail_lizard" in L.dna.species.mutant_bodyparts) || ("waggingtail_lizard" in L.dna.species.mutant_bodyparts))
					if("tail_lizard" in L.dna.species.mutant_bodyparts)
						L.dna.species.mutant_bodyparts -= "tail_lizard"
					else if("waggingtail_lizard" in L.dna.species.mutant_bodyparts)
						L.dna.species.mutant_bodyparts -= "waggingtail_lizard"
					if("spines" in L.dna.features)
						L.dna.features -= "spines"
					var/obj/item/severedtail/S = new(get_turf(restrained_mob))
					S.color = "#[L.dna.features["mcolor"]]"
					S.markings = "[L.dna.features["tail_lizard"]]"
					L.update_body()
					var/obj/item/bodypart/B = L.get_bodypart("l_leg")
					var/obj/item/bodypart/C = L.get_bodypart("r_leg")
					B.dismember()
					C.dismember()
					return 1
			else
				src.visible_message("The blade slides past [restrained_mob], whizzing past their non-existent [target_mode]!.")
	else
		icon_state += "-drop"
		icon_state = initial(icon_state)
		return 0

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 5,
		/obj/item/weapon/kitchen/knife/butcher = 1,
		/obj/item/stack/cable_coil = 3,
	)
	result = /obj/structure/guillotine
	category = CAT_MISC