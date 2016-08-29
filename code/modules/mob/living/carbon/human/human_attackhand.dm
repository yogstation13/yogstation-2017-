/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(zone_selected))
	var/armor_block = run_armor_check(affecting, "melee")
	if(user.a_intent == "harm")
		..(user, 1)
		playsound(loc, user.dna.species.attack_sound, 25, 1, -1)
		if(user.dna.species.id == "abomination")//snowflake abomination hulk damage
			visible_message("<span class='danger'>[user] has torn into [src]!</span>", \
							"<span class='userdanger'>[user] has torn into [src]!</span>")
			apply_damage(40, BRUTE, affecting, armor_block)
			apply_effect(3, WEAKEN, armor_block)
			return 1
		var/hulk_verb = pick("smash","pummel")
		visible_message("<span class='danger'>[user] has [hulk_verb]ed [src]!</span>", \
								"<span class='userdanger'>[user] has [hulk_verb]ed [src]!</span>")
		apply_damage(15, BRUTE, affecting, armor_block)
		return 1

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	if(..())	//to allow surgery to return properly.
		return
	dna.species.spec_attack_hand(M, src)
