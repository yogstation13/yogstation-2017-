/*
	TODO

	* Break glass instead of knocking [DONE]
	* Venting slower
	* Drop clothes [DONE]
	* Give icon

	* Level up zombies
	* Multiple zombies working together to open doors and break down structures
*/

/mob/living/carbon/human/zombie
	name = "zombie"
	voice_name = "zombie"
	verb_say = "moans"
//	icon = 'icons/mob/zombie.dmi'
//	icon_state = "zombie1"
	gender = NEUTER
	pass_flags = PASSTABLE
	ventcrawler = 1

/mob/living/carbon/human/zombie/New()
	create_reagents(1000)
	name = text("zombie ([rand(1, 1000)])")
	real_name = name
	gender = pick(MALE, FEMALE)
	disabilities |= CLUMSY
	internal_organs += new /obj/item/organ/body_egg/zombie_infection/non_infectious
	..()
	set_species(/datum/species/zombie)

/proc/is_infected(mob/M)
	for(var/datum/disease/D in M.viruses)
		if(istype(D, /datum/disease/transformation/rage_virus))
			return 1
	return 0

/mob/living/carbon/human/zombie/prepare_data_huds()
	..()
	for(var/datum/atom_hud/data/human/medical/hud in huds)
		hud.add_hud_to(src)

/mob/living/carbon/human/zombie/Move(NewLoc, direct)
	..(NewLoc, direct)

	if(stat != DEAD && rand(1,20) == 1)
		say("This message will be turned into urrs.")

/mob/living/carbon/human/zombie/attack_larva(mob/living/carbon/alien/larva/L as mob)
	switch(L.a_intent)
		if("help")
			visible_message("<span class='notice'>[L] rubs its head against [src].</span>")
		else
			var/damage = rand(1, 3)
			visible_message("<span class='danger'>[L] bites [src]!</span>", \
					"<span class='userdanger'>[L] bites [src]!</span>")
			playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)

			if(stat != DEAD)
				L.amount_grown = min(L.amount_grown + damage, L.max_grown)
				adjustBruteLoss(damage)

/mob/living/carbon/human/zombie/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	if(..())	//To allow surgery to return properly.
		return

	if (M.a_intent == "help")
		help_shake_act(M)

	else
		if (M.a_intent == "harm")
			if (prob(75))
				visible_message("<span class='danger'>[M] has punched [name]!</span>", \
						"<span class='userdanger'>[M] has punched [name]!</span>")

				playsound(loc, "punch", 25, 1, -1)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if ( (paralysis < 5)  && (health > 0) )
						Paralyse(rand(10, 15))
						visible_message("<span class='danger'>[M] has knocked out [name]!</span>", \
									"<span class='userdanger'>[M] has knocked out [name]!</span>")
						return
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>[M] has attempted to punch [name]!</span>", \
						"<span class='userdanger'>[M] has attempted to punch [name]!</span>")
		else
			if (M.a_intent == "grab")
				if (M == src || anchored)
					return
				grabbedby(M)
				LAssailant = M
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("<span class='warning'>[M] has grabbed [name] passively!</span>")
			else
				if (!( paralysis ))
					if (prob(25))
						Paralyse(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						visible_message("<span class='danger'>[M] has pushed down [src]!</span>", \
								"<span class='userdanger'>[M] has pushed down [src]!</span>")
					else
						if(drop_item())
							playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
							visible_message("<span class='danger'>[M] has disarmed [src]!</span>", \
									"<span class='userdanger'>[M] has disarmed [src]!</span>")

/mob/living/carbon/human/zombie/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	switch(M.a_intent)
		if ("help")
			visible_message("<span class='notice'> [M] caresses [src] with its scythe like arm.</span>")

		if ("harm")
			if ((prob(95) && health > 0))
				playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				var/damage = rand(15, 30)
				if (damage >= 25)
					damage = rand(20, 40)
					if (paralysis < 15)
						Paralyse(rand(10, 15))
					visible_message("<span class='danger'>[M] has wounded [name]!</span>", \
							"<span class='userdanger'>[M] has wounded [name]!</span>")
				else
					visible_message("<span class='danger'>[M] has slashed [name]!</span>", \
							"<span class='userdanger'>[M] has slashed [name]!</span>")
				if (stat != DEAD)
					adjustBruteLoss(damage)
					updatehealth()
			else
				playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>[M] has attempted to lunge at [name]!</span>", \
						"<span class='userdanger'>[M] has attempted to lunge at [name]!</span>")

		if ("grab")
			if (M == src || anchored)
				return
			grabbedby(M)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] has grabbed [name] passively!</span>")

		if ("disarm")
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
			var/damage = 5
			if(prob(95))
				Weaken(10)
				visible_message("<span class='danger'>[M] has tackled down [name]!</span>", \
						"<span class='userdanger'>[M] has tackled down [name]!</span>")
			else
				if(drop_item())
					visible_message("<span class='danger'>[M] has disarmed [name]!</span>", \
							"<span class='userdanger'>[M] has disarmed [name]!</span>")
			adjustBruteLoss(damage)
			updatehealth()

/mob/living/carbon/human/zombie/attack_slime(mob/living/simple_animal/slime/M as mob)
	if(..()) //successful slime attack
		var/damage = rand(5, 35)
		if(M.is_adult)
			damage = rand(20, 40)
		adjustBruteLoss(damage)
		updatehealth()

/mob/living/carbon/human/zombie/ex_act(severity)
	..()
	switch(severity)
		if(1.0)
			gib()
			return
		if(2.0)
			adjustBruteLoss(60)
			adjustFireLoss(60)
		if(3.0)
			adjustBruteLoss(30)
			if (prob(50))
				Paralyse(10)

/mob/living/carbon/human/zombie/blob_act()
	if (stat != 2)
		show_message("<span class='userdanger'>The blob attacks you!</span>")
		adjustFireLoss(60)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	if (prob(50))
		Paralyse(10)
	if (stat == DEAD && client)
		gib()
		return
	if (stat == DEAD && !client)
		gibs(loc, viruses)
		qdel(src)
		return

/mob/living/carbon/human/zombie/put_in_hand_check(obj/item/W)
	if(istype(W, /obj/item/weapon/card))
		return 1
	if(istype(W, /obj/item/weapon) || istype(W, /obj/item/clothing/suit/armor) || istype(W, /obj/item/clothing/suit/bio_suit) || istype(W, /obj/item/clothing/head/helmet))
		src << "You brain struggles to comprehend picking up the [W]. Somehow it is just too complicated to operate."
		return 0
	return ..(W)

/mob/living/carbon/human/zombie/IsAdvancedToolUser()
	return 0

/mob/living/carbon/human/zombie/canBeHandcuffed()
	return 1

/mob/living/carbon/human/zombie/assess_threat(obj/machinery/bot/secbot/judgebot, lasercolor)
	return 0

/mob/living/carbon/human/zombie/proc/urrizeText(var/message)
	var/len = (length(message) / 10) + 1
	message = ""
	for(var/i = 0; i < len; i++)
		message += pick("urrrrr", "Urrrhh", "URRR!", "URRRRR?", "Urrrrhhhhhhh", "uuuuuuuur", "uuhhhhhh", "uuuh", "urrrh")+" "
	return message

/mob/living/carbon/human/zombie/say(message, bubble_type)
	if(src.stat != DEAD)
		message = urrizeText(message)

	playsound(loc, "zombie", 25, 1, 1)

	return ..(message, bubble_type)

/mob/living/carbon/human/zombie/say_quote(var/text)
	return "[verb_say], \"[text]\"";

/mob/living/carbon/human/zombie/check_breath(datum/gas_mixture/breath)
	return

/mob/living/carbon/human/zombie/adjustBruteLoss(amount)
	if(GODMODE in status_flags)	return 0
	amount = amount / 3
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))
//	if(updating_health)
//		updatehealth()

/mob/living/carbon/human/zombie/adjustOxyLoss(amount)
	return 0

/mob/living/carbon/human/zombie/setOxyLoss(amount)
	return 0

/mob/living/carbon/human/zombie/adjustToxLoss(amount)
	return 0

/mob/living/carbon/human/zombie/setToxLoss(amount)
	return 0

/mob/living/carbon/human/zombie/adjustFireLoss(amount)
	if(GODMODE in status_flags)	return 0
	amount = amount * 2
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))
//	if(updating_health)
//		updatehealth()

/mob/living/carbon/human/zombie/adjustCloneLoss(amount)
	if(GODMODE in status_flags)	return 0
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))
//	if(updating_health)
//		updatehealth()

/mob/living/carbon/human/zombie/setCloneLoss(amount)
	if(GODMODE in status_flags)	return 0
	cloneloss = amount
	//if(updating_health)
	//	updatehealth()

/mob/living/carbon/human/zombie/adjustBrainLoss(amount)
	if(GODMODE in status_flags)	return 0
	amount = amount * 2
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))
//	if(updating_health)
	//	updatehealth()

/mob/living/carbon/human/zombie/setBrainLoss(amount)
	if(GODMODE in status_flags)	return 0
	brainloss = amount
//	if(updating_health)
	//	updatehealth()

/mob/living/carbon/human/zombie/adjustStaminaLoss(amount)
	if(GODMODE in status_flags)	return 0
	amount = amount / 5
	staminaloss = min(max(staminaloss + amount, 0),(maxHealth*2))

/mob/living/carbon/human/zombie/setStaminaLoss(amount)
	if(GODMODE in status_flags)	return 0
	amount = amount / 5
	staminaloss = amount

/mob/living/carbon/human/zombie/Jitter(amount)
	amount = amount / 7
	..(amount)

/mob/living/carbon/human/zombie/Dizzy(amount)
	amount = amount / 7
	..(amount)

/mob/living/carbon/human/zombie/Stun(amount)
	amount = amount / 3
	..(amount)
	return

/mob/living/carbon/human/zombie/SetStunned(amount)
	amount = amount / 3
	..(amount)
	return

/mob/living/carbon/human/zombie/AdjustStunned(amount)
	amount = amount / 3
	..(amount)
	return

/mob/living/carbon/human/zombie/Weaken(amount, ignore_canweaken = 0)
	return 0
//	amount = amount / 10
//	..(amount, ignore_canweaken)
//	return

/mob/living/carbon/human/zombie/SetWeakened(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/AdjustWeakened(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/Paralyse(amount)
	amount = amount / 2
	..(amount)
	return

/mob/living/carbon/human/zombie/SetParalysis(amount)
	amount = amount / 2
	..(amount)
	return

/mob/living/carbon/human/zombie/AdjustParalysis(amount)
	amount = amount / 2
	..(amount)
	return

/mob/living/carbon/human/zombie/Sleeping(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/SetSleeping(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/AdjustSleeping(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/Resting(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/SetResting(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/AdjustResting(amount)
	amount = amount / 10
	..(amount)
	return

/mob/living/carbon/human/zombie/bullet_act(obj/item/projectile/P, def_zone)
	if(P)
		if(P.def_zone)
			if(P.def_zone == "head")
				if(check_shields(P.damage, "the [P.name]", P, PROJECTILE_ATTACK, P.armour_penetration))
					P.on_hit(src, 100, def_zone)
					return 2
				P.damage = P.damage * 1.5 // damage to head is 1.5x stronger
			else
				if(!stunned)
					Stun(P.damage)
				visible_message("<span class='warning'>[P] smacks against [src]'s [def_zone], but doesn't do any \
								damage!</span>",\
								"<span class='warning'>[P] smacks against [src]'s [def_zone], but doesn't do any \
								damage!</span>")
				return 2
		return (..(P , def_zone))

/mob/living/carbon/human/zombie/check_shields(damage, attack_text, atom/movable/AM, attack_type, armour_penetration, targpart)
	if(targpart)
		damage = damage * 1.5
		..(damage, attack_text, AM, attack_type, armour_penetration, targpart)
	else
		if(!stunned)
			Stun(damage)
			var/hittext = "smacks"
			if(istype(AM, /obj/item))
				var/obj/item/I = AM
				hittext = pick(I.attack_verb)
			visible_message("<span class='warning'>[AM] [hittext] [src], but doesn't do any \
								damage!</span>",\
								"<span class='warning'>[AM] [hittext] [src], but doesn't do any \
								damage!</span>")