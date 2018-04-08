/obj/item/weapon/melee
	needs_permit = 1

/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=5"
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'sound/weapons/slash.ogg' //pls replace
	materials = list(MAT_METAL = 1000)

/obj/item/weapon/melee/chainofcommand/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
		return (OXYLOSS)



/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 12 //9 hit crit
	w_class = 3
	var/cooldown = 0
	var/on = 1

/obj/item/weapon/melee/classic_baton/attack(mob/target, mob/living/user)
	if(on)
		add_fingerprint(user)
		if((CLUMSY in user.disabilities) && prob(50))
			to_chat(user, "<span class ='danger'>You club yourself over the head.</span>")
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, "head")
			else
				user.take_organ_damage(2*force)
			return
		if(isrobot(target))
			..()
			return
		if(!isliving(target))
			return
		if (user.a_intent == "harm")
			if(!..()) return
			if(!isrobot(target)) return
		else
			if(cooldown <= 0)
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					if (H.check_shields(0, "[user]'s [name]", src, MELEE_ATTACK))
						return
				playsound(get_turf(src), 'sound/effects/woodhit.ogg', 75, 1, -1)
				target.Weaken(3)
				add_logs(user, target, "stunned", src)
				src.add_fingerprint(user)
				target.visible_message("<span class ='danger'>[user] has knocked down [target] with \the [src]!</span>", \
					"<span class ='userdanger'>[user] has knocked down [target] with \the [src]!</span>")
				if(!iscarbon(user))
					target.LAssailant = null
				else
					target.LAssailant = user
				cooldown = 1
				spawn(40)
					cooldown = 0
		return
	else
		return ..()



/obj/item/weapon/melee/classic_baton/telescopic
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = null
	slot_flags = SLOT_BELT
	w_class = 2
	needs_permit = 0
	force = 0
	on = 0

/obj/item/weapon/melee/classic_baton/telescopic/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)

	user.visible_message("<span class='suicide'>[user] stuffs the [src] up their nose and presses the 'extend' button! It looks like they're trying to clear their mind.</span>")
	if(!on)
		src.attack_self(user)
	else
		playsound(loc, 'sound/weapons/batonextend.ogg', 50, 1)
		add_fingerprint(user)
	sleep(3)
	if (H && !qdeleted(H))
		if (B && !qdeleted(B))
			H.internal_organs -= B
			qdel(B)
		gibs(H.loc, H.viruses, H.dna)
		return (BRUTELOSS)
	return

/obj/item/weapon/melee/classic_baton/telescopic/attack_self(mob/user)
	on = !on
	if(on)
		to_chat(user, "<span class ='warning'>You extend the baton.</span>")
		icon_state = "telebaton_1"
		item_state = "nullrod"
		w_class = 4 //doesnt fit in backpack when its on for balance
		force = 10 //stunbaton damage
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		to_chat(user, "<span class ='notice'>You collapse the baton.</span>")
		icon_state = "telebaton_0"
		item_state = null //no sprite for concealment even when in hand
		slot_flags = SLOT_BELT
		w_class = 2
		force = 0 //not so robust now
		attack_verb = list("hit", "poked")

	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)


/obj/item/weapon/twohanded/dual_telebaton
	name = "double ended telescopic baton"
	desc = "A huge fighting pike made of two telescopic batons bound together by wires, it has a switch in the middle."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dualbaton0"
	item_state = null
	slot_flags = SLOT_BELT
	w_class = 4
	needs_permit = 0
	force = 0
	force_wielded = 10
	force_unwielded = 5
	attack_verb = list("shoved","sweeped","punted")
	block_chance = 10
	var/current_target = null
	var/streak = 1
	var/max_streak_length = 4 //ULTIMATE COMBO
	hitsound = 'sound/effects/hit_punch.ogg'
	sharpness = null

/obj/item/weapon/twohanded/dual_telebaton/attack_self(mob/user)
	. = ..()
	playsound(loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)

/obj/item/weapon/twohanded/dual_telebaton/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>This item has a combo, to use this combo attack with the following intents in the following order (whilst the item is wielded in-hand): harm, harm, disarm, grab</span>")

/obj/item/weapon/twohanded/dual_telebaton/update_icon()
	if(wielded)
		icon_state = "dualbaton1"
	else
		icon_state = "dualbaton0"
	clean_blood()//blood overlays get weird otherwise, because the sprite changes.
	return

/obj/item/weapon/twohanded/dual_telebaton/attack(mob/target, mob/living/carbon/human/user)
	if(wielded)
		var/mob/living/carbon/H = target
		if(target != current_target || !current_target)
			streak = 0
			current_target = target
		if(user.has_dna())
			if(user.dna.check_mutation(HULK) || user.dna.check_mutation(ACTIVE_HULK) || (CLUMSY in user.disabilities))
				to_chat(user, "<span class='warning'>You grip [src] too hard and accidentally close it!</span>")
				unwield()
				return
		if(streak < max_streak_length)
			streak ++
			user.do_attack_animation(target)
			playsound(src.loc, hitsound, 50, 1)
			switch(streak)
				if(1)
					if(user.a_intent == "harm")
						H.visible_message("<span class='warning'>[user] punts their [src] into [H]'s stomach, winding them!</span>")
						H.adjustStaminaLoss(rand(5,10))
						return
					else
						reset_target()
				if(2)
					if(user.a_intent == "harm")
						H.visible_message("<span class='warning'>[user] thwacks [H] in the chin with their [src]!</span>")
						H.apply_damage(force, BRUTE, "head")
						H.Dizzy(2)
						return
					else
						reset_target()
				if(3)
					if(user.a_intent == "disarm")
						H.visible_message("<span class='warning'>[user] quickly slaps [H]'s hands with their [src] disarming them!</span>")
						H.apply_damage(force, BRUTE, "chest")
						H.drop_item()
						H.Stun(2)
						return
					else
						reset_target()
				if(4)
					if(user.a_intent == "grab")
						user.emote("flip")
						H.visible_message("<span class='warning'>[user] does a backflip!</span>")
						H.visible_message("<span class='warning'>As [user] lands, they ram [H] with [src] with all their might, sending [H] flying!</span>")
						var/atom/throw_target = get_edge_target_turf(target, get_dir(target, get_step_away(target, user)))
						H.throw_at(throw_target, 200, 4,user)
						H.visible_message("<span class='warning'>[H] slams into [throw_target.name], weakening them!.</span>")
						H.visible_message("<span class='warning'>[H] stumbles around!</span>")
						step_to(H,get_step(H,H.dir),1)
						H.Stun(4)
						playsound(H.loc,'sound/items/trayhit2.ogg',40,0)
						H.visible_message("<span class='warning'>With lightning-fast reflexes, [user] pounces towards [H]!</span>")
						user.emote("flip")
						user.throw_at(H, 200, 4,user)
						sleep(5) //Give it a bit to throw them at the target
						if(user in orange(2,H))
							H.visible_message("<span class='warning'>[user] rams [H] with [src] as they land!</span>")
							H.Stun(9)
							H.apply_damage(force, BRUTE, "head")
							playsound(H.loc,'sound/effects/knockout.ogg',40,0)
							H.Weaken(6)
							reset_target()
						else
							H.visible_message("<span class='warning'>[user] completely misses [H] and falls flat on their face!</span>")
							user.Weaken(5)
							reset_target()
						return
					else
						reset_target()
		..()
	else
		streak = 0
		current_target = null
		return ..()
/obj/item/weapon/twohanded/dual_telebaton/proc/reset_target()
	current_target = null
	streak = 0

/datum/crafting_recipe/dualbaton
	name = "Double ended telescopic baton"
	reqs = list(
		/obj/item/weapon/melee/classic_baton/telescopic = 2,
		/obj/item/weapon/restraints/handcuffs/cable = 1,
		/obj/item/stack/rods = 2
	)
	result = /obj/item/weapon/twohanded/dual_telebaton
	category = CAT_MISC

/obj/item/weapon/melee/supermatter_sword
	name = "supermatter sword"
	desc = "In a station full of bad ideas, this might just be the worst."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "supermatter_sword"
	item_state = "supermatter_sword"
	slot_flags = null
	w_class = 4
	force = 0.001
	armour_penetration = 1000
	var/obj/machinery/power/supermatter_shard/shard
	var/balanced = 1
	origin_tech = "combat=7;materials=6"

/obj/item/weapon/melee/supermatter_sword/New()
	..()
	shard = new /obj/machinery/power/supermatter_shard(src)
	START_PROCESSING(SSobj, src)
	visible_message("<span class='warning'>\The [src] appears, balanced ever so perfectly on its hilt. This isn't ominous at all.</span>")

/obj/item/weapon/melee/supermatter_sword/process()
	if(balanced || throwing || ismob(src.loc) || isnull(src.loc))
		return
	if(!isturf(src.loc))
		var/atom/target = src.loc
		loc = target.loc
		consume_everything(target)
	else
		var/turf/T = get_turf(src)
		if(!istype(T,/turf/open/space))
			consume_turf(T)

/obj/item/weapon/melee/supermatter_sword/afterattack(target, mob/user, proximity_flag)
	if(user && target == user)
		user.drop_item()
	if(proximity_flag)
		consume_everything(target)
	..()

/obj/item/weapon/melee/supermatter_sword/throw_impact(target)
	..()
	if(ismob(target))
		var/mob/M
		if(src.loc == M)
			M.drop_item()
	consume_everything(target)

/obj/item/weapon/melee/supermatter_sword/pickup(user)
	..()
	balanced = 0

/obj/item/weapon/melee/supermatter_sword/ex_act(severity, target)
	visible_message("<span class='danger'>\The blast wave smacks into \the [src] and rapidly flashes to ash.</span>",\
	"<span class='italics'>You hear a loud crack as you are washed with a wave of heat.</span>")
	consume_everything()

/obj/item/weapon/melee/supermatter_sword/acid_act()
	visible_message("<span class='danger'>\The acid smacks into \the [src] and rapidly flashes to ash.</span>",\
	"<span class='italics'>You hear a loud crack as you are washed with a wave of heat.</span>")
	consume_everything()

/obj/item/weapon/melee/supermatter_sword/bullet_act(obj/item/projectile/P)
	visible_message("<span class='danger'>[P] smacks into \the [src] and rapidly flashes to ash.</span>",\
	"<span class='italics'>You hear a loud crack as you are washed with a wave of heat.</span>")
	consume_everything()

/obj/item/weapon/melee/supermatter_sword/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] touches the [src]'s blade. It looks like they're tired of waiting for the radiation to kill them!</span>")
	user.drop_item()
	shard.Bumped(user)

/obj/item/weapon/melee/supermatter_sword/proc/consume_everything(target)
	if(isnull(target))
		shard.Consume()
	else if(!isturf(target))
		shard.Bumped(target)
	else
		consume_turf(target)

/obj/item/weapon/melee/supermatter_sword/proc/consume_turf(turf/T)
	if(istype(T, T.baseturf))
		return //Can't void the void, baby!
	playsound(T, 'sound/effects/supermatter.ogg', 50, 1)
	T.visible_message("<span class='danger'>\The [T] smacks into \the [src] and rapidly flashes to ash.</span>",\
	"<span class='italics'>You hear a loud crack as you are washed with a wave of heat.</span>")
	shard.Consume()
	T.ChangeTurf(T.baseturf)
	T.CalculateAdjacentTurfs()

/obj/item/weapon/melee/supermatter_sword/add_blood(list/blood_dna)
	return 0
