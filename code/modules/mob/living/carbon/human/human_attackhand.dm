/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(zone_selected))
	var/armor_block = run_armor_check(affecting, "melee")
	if(user.a_intent == "harm")
		..(user, 1)
		playsound(loc, user.dna.species.attack_sound, 25, 1, -1)
		if(isabomination(user))//snowflake abomination hulk damage
			if(stat == DEAD)
				to_chat(user, "<span class='notice'>You dig your claws into [name]...</span>")
				playsound(loc, 'sound/weapons/slice.ogg', 100, 1, -1)
				if(do_mob(user, src, 100))
					visible_message("<span class='danger'>[user] rips apart [name]!</span>", \
									"<span class='warning'>You rip [name] apart!</span>")
					gib()
					return 1
			visible_message("<span class='danger'>[user] has torn into [src]!</span>", \
							"<span class='userdanger'>[user] has torn into [src]!</span>")
			apply_damage(40, BRUTE, affecting, armor_block)
			apply_effect(1, WEAKEN, armor_block)
			return 1
		var/hulk_verb = pick("smash","pummel")
		visible_message("<span class='danger'>[user] has [hulk_verb]ed [src]!</span>", \
								"<span class='userdanger'>[user] has [hulk_verb]ed [src]!</span>")
		apply_damage(15, BRUTE, affecting, armor_block)
		return 1

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	if(..())	//to allow surgery to return properly.
		return
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
	if(resolve_defense_modules(null, M, affecting, UNARMED_ATTACK))
		return
	dna.species.spec_attack_hand(M, src, affecting)
