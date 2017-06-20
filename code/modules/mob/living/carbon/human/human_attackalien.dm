/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/humanoid/M)
	if(check_shields(0, M.name))
		visible_message("<span class='danger'>[M] attempted to touch [src]!</span>")
		return 0

	if(..())
		if(M.a_intent == "harm")
			if (w_uniform)
				w_uniform.add_fingerprint(M)
			var/damage = prob(90) ? 20 : 0
			if(!damage)
				playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M] has lunged at [src]!</span>", \
					"<span class='userdanger'>[M] has lunged at [src]!</span>")
				return 0
			var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
			var/armor_block = run_armor_check(affecting, "melee","","",10)

			playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
			visible_message("<span class='danger'>[M] has slashed at [src]!</span>", \
				"<span class='userdanger'>[M] has slashed at [src]!</span>")

			if(check_shields(damage, "[M.name]'s slash"))
				visible_message("<span class='danger'>[src] blocks [M]'s slash!</span>")
				return 0
			apply_damage(damage, BRUTE, affecting, armor_block)
			if (prob(5))
				visible_message("<span class='danger'>[M] has wounded [src]!</span>", \
					"<span class='userdanger'>[M] has wounded [src]!</span>")
				apply_effect(4, WEAKEN, armor_block)
				add_logs(M, src, "attacked")
			updatehealth()

		if(M.a_intent == "disarm")
			var/randn = rand(1, 100)
			if (randn <= 60)
				playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
				var/successfultackle = M.tackle_chance
				if(weakened < 2)
					successfultackle = round(successfultackle / 2)
				Weaken(successfultackle)
				add_logs(M, src, "tackled")
				visible_message("<span class='danger'>[M] has tackled down [src]!</span>", \
					"<span class='userdanger'>[M] has tackled down [src]!</span>")
			else
				if (randn <= 99)
					playsound(loc, 'sound/weapons/slash.ogg', 25, 1, -1)
					drop_item()
					visible_message("<span class='danger'>[M] disarmed [src]!</span>", \
						"<span class='userdanger'>[M] disarmed [src]!</span>")
				else
					playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1, -1)
					visible_message("<span class='danger'>[M] has tried to disarm [src]!</span>", \
						"<span class='userdanger'>[M] has tried to disarm [src]!</span>")
		if(M.a_intent == "sting")
			if(M.tail)
				visible_message("<span class='danger'>[M]'s tail swoops down and punctures [src]!</span>", \
				"<span class='userdanger'>[M] punctures [src] with it's tail!</span>")
				if(check_shields(M.tail.force, "[M]'s tail", M.tail))
					visible_message("<span class='danger'>[M]'s tail rickashays away from [src]!</span>", \
						"<span class='danger'[M]'s tail is blocked!</span>")
				else
					M.tail.attack(src, M)
			else
				M << "<span class='aliennotice'>You cannot use this intent.</span>"
	return
