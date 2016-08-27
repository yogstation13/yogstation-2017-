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
	icon = 'icons/mob/zombie.dmi'
	icon_state = "zombie1"
	gender = NEUTER
	pass_flags = PASSTABLE
	//languages_spoken = ZOMBIE
	//languages_understood = ZOMBIE
	ventcrawler = 1

/mob/living/carbon/human/zombie/New()
	create_reagents(1000)
	verbs += /mob/living/proc/mob_sleep
	verbs += /mob/living/proc/lay_down

	internal_organs += new /obj/item/organ/internal/appendix
	internal_organs += new /obj/item/organ/internal/heart
	internal_organs += new /obj/item/organ/internal/brain

	if(name == "zombie")
		name = text("zombie ([rand(1, 1000)])")
	real_name = name
	gender = pick(MALE, FEMALE)

	disabilities |= CLUMSY

	..()

/proc/is_zombie(mob/user)
	if(istype(user, /mob/living/carbon/human/zombie))
		return 1
	else
		return 0

/proc/is_infected(mob/M)
	for(var/datum/disease/D in M.viruses)
		if(istype(D, /datum/disease/transformation/rage_virus))
			return 1
	return 0

/mob/living/carbon/human/zombie/prepare_data_huds()
	//Prepare our med HUD...
	..()
	//...and display it.
	for(var/datum/atom_hud/data/medical/hud in huds)
		hud.add_to_hud(src)

/mob/living/carbon/human/zombie/Move(NewLoc, direct)
	..(NewLoc, direct)

	if(stat != DEAD && rand(1,20) == 1)
		say("This message will be turned into urrs.")

/mob/living/carbon/human/zombie/movement_delay()
	var/tally = 0
	if(reagents)
		if(reagents.has_reagent("hyperzine")) return -1

		if(reagents.has_reagent("nuka_cola")) return -1

	// Health will be ignored, zombies feel no pain
	//var/health_deficiency = (100 - health)
	//if(health_deficiency >= 45) tally += (health_deficiency / 25)

	// Zombies will not feel the cold
	//if (bodytemperature < 283.222)
	//	tally += (283.222 - bodytemperature) / 10 * 1.75

	// Add generic slowness for zombie
	return tally+config.zombie_delay+(rand(1, 3))

/mob/living/carbon/human/zombie/Bump(atom/movable/AM as mob|obj, yes)
	if ((!( yes ) || now_pushing))
		return
	now_pushing = 1
	if(ismob(AM))
		var/mob/tmob = AM
		if(!(CANPUSH in tmob.status_flags))
			now_pushing = 0
			return

		tmob.LAssailant = src
	now_pushing = 0
	..()
	if (!istype(AM, /atom/movable))
		return
	if (!( now_pushing ))
		now_pushing = 1
		if (!( AM.anchored ))
			var/t = get_dir(src, AM)
			if (istype(AM, /obj/structure/window))
				if(AM:ini_dir == NORTHWEST || AM:ini_dir == NORTHEAST || AM:ini_dir == SOUTHWEST || AM:ini_dir == SOUTHEAST)
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
			step(AM, t)
		now_pushing = null


/mob/living/carbon/human/zombie/attack_paw(mob/M as mob)
	//..()

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if (M.a_intent == "harm" && !M.is_muzzled())
			if (prob(50))
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)

				var/isZombie = is_zombie(src)
				var/isInfected = is_infected(src)
				//var/isDead = (src.stat == DEAD ? 1 : 0)
				var/isUnconcious = (src.stat == UNCONSCIOUS ? 1 : 0)
				var/isCritical = src.InCritical()

				var/allowDamage = 1
				var/selfMessage = ""
				var/localMessage = ""
				if(isZombie)
					selfMessage = "Your zombified brain doesn't let you really bite into another zombie, instead you just nibble the flesh."
					localMessage = "[M.name] nibbles [name]."
					allowDamage = 0
				else if(isInfected)
					selfMessage = "Your zombified brain doesn't let you really bite into an infected, instead you just nibble the flesh."
					localMessage = "[M.name] nibbles [name]."
					allowDamage = 0
				else if(isCritical)
					selfMessage = "You struggle to find any meat on [name], he twitches a little! This body seems to not have much left to eat."
					localMessage = "[M.name] eats [name], he twitches a little!"
					allowDamage = 0
				else if(isUnconcious)
					selfMessage = "You eat a chunk out of [name], he twitches a lot! It would be tasty, if that part of your brain still worked."
					localMessage = "[M.name] eats [name], he twitches a lot!"
				else //if(isDead)
					selfMessage = "You bite a chunk out of [name]! It would be tasty, if that part of your brain still worked."
					localMessage = "[M.name] bites [name] ferociously!"

				visible_message("<span class='userdanger'>[localMessage]</span>", \
						"<span class='danger'>[selfMessage]</span>")

				if(allowDamage)
					var/damage = rand(20, 30)
					if (health > -100)
						adjustBruteLoss(damage)
						health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()

				for(var/datum/disease/D in M.viruses)
					//contract_disease(D,1,0)
					src.ForceContractDisease(D)
			else
				visible_message("<span class='danger'>[M.name] has attempted to bite [name] ferociously!</span>", \
					"<span class='userdanger'>[M.name] has attempted to bite [name] ferociously!</span>")
	return

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
						spawn( 0 )
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

				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src )

				M.put_in_active_hand(G)

				G.synch()

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
	return

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
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src )

			M.put_in_active_hand(G)

			G.synch()

			LAssailant = M

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
	return

/*/mob/living/carbon/zombie/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message("<span class='danger'>[M] [M.attacktext] [src]!</span>", \
				"<span class='userdanger'>[M] [M.attacktext] [src]!</span>")
		add_logs(M, src, "attacked", admin=0)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()*/


/mob/living/carbon/human/zombie/attack_slime(mob/living/simple_animal/slime/M as mob)
	if(..()) //successful slime attack
		var/damage = rand(5, 35)
		if(M.is_adult)
			damage = rand(20, 40)
		adjustBruteLoss(damage)
		updatehealth()

/mob/living/carbon/human/zombie/Stat()
	..()
	statpanel("Status")
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))
	if(client && mind)
		if (client.statpanel == "Status")
			if(mind.changeling)
				stat("Chemical Storage", "[mind.changeling.chem_charges]/[mind.changeling.chem_storage]")
				stat("Absorbed DNA", mind.changeling.absorbedcount)
	return


/mob/living/carbon/human/zombie/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return

///mob/living/carbon/human/zombie/var/co2overloadtime = null
///mob/living/carbon/human/zombie/var/temperature_resistance = T0C+75

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
	return

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
		src << "You Zombified brain struggles to comprehend picking up the [W]. Somehow it is just too complicated to operate."
		return 0
	return ..(W)

/mob/living/carbon/human/zombie/IsAdvancedToolUser()
	return 0

/mob/living/carbon/human/zombie/canBeHandcuffed()
	return 1

/mob/living/carbon/human/zombie/assess_threat(var/obj/machinery/bot/secbot/judgebot, var/lasercolor)
	if(judgebot.emagged == 2)
		return 10 //Everyone is a criminal!
	var/threatcount = 0

	//Securitrons can't identify zombies
	if(!lasercolor && judgebot.idcheck )
		threatcount += 4

	//Lasertag bullshit
	if(lasercolor)
		if(lasercolor == "b")//Lasertag turrets target the opposing team, how great is that? -Sieve
			if((istype(r_hand,/obj/item/weapon/gun/energy/laser/redtag)) || (istype(l_hand,/obj/item/weapon/gun/energy/laser/redtag)))
				threatcount += 4

		if(lasercolor == "r")
			if((istype(r_hand,/obj/item/weapon/gun/energy/laser/bluetag)) || (istype(l_hand,/obj/item/weapon/gun/energy/laser/bluetag)))
				threatcount += 4

		return threatcount

	//Check for weapons
	if(judgebot.weaponscheck)
		if(judgebot.check_for_weapons(l_hand))
			threatcount += 4
		if(judgebot.check_for_weapons(r_hand))
			threatcount += 4

	//Loyalty implants imply trustworthyness
	if(isloyal(src))
		threatcount -= 1

	return threatcount

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
	handle_regular_status_updates() //we update our health right away.

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
	handle_regular_status_updates() //we update our health right away.

/mob/living/carbon/human/zombie/adjustCloneLoss(amount)
	if(GODMODE in status_flags)	return 0
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))
	handle_regular_status_updates()

/mob/living/carbon/human/zombie/setCloneLoss(amount)
	if(GODMODE in status_flags)	return 0
	cloneloss = amount
	handle_regular_status_updates()

/mob/living/carbon/human/zombie/adjustBrainLoss(amount)
	if(GODMODE in status_flags)	return 0
	amount = amount * 2
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))
	handle_regular_status_updates()

/mob/living/carbon/human/zombie/setBrainLoss(amount)
	if(GODMODE in status_flags)	return 0
	brainloss = amount
	handle_regular_status_updates() //we update our health right away.

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
	amount = amount / 10
	..(amount, ignore_canweaken)
	return

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