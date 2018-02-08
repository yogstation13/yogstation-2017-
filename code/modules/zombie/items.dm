/obj/item/zombie_hand
	name = "zombie claw"
	desc = "A zombie's claw is its primary tool, capable of infecting \
		unconcious or dead humans, butchering all other living things to \
		sustain the zombie, forcing open airlock doors and opening \
		child-safe caps on bottles."
	flags = NODROP|ABSTRACT|DROPDEL
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodhand_left"
	var/icon_left = "bloodhand_left"
	var/icon_right = "bloodhand_right"
	hitsound = 'sound/hallucinations/growl1.ogg'
	force = 20
	damtype = "brute"

	var/removing_airlock = FALSE

/obj/item/zombie_hand/equipped(mob/user, slot)
	. = ..()
	switch(slot)
		// Yes, these intentionally don't match
		if(slot_l_hand)
			icon_state = icon_right
		if(slot_r_hand)
			icon_state = icon_left

/obj/item/zombie_hand/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	if(istype(target, /obj/machinery/door/airlock) && !removing_airlock)
		tear_airlock(target, user)

	if(istype(target, /obj/machinery/door/firedoor))
		var/obj/machinery/door/firedoor/F = target
		F.visible_message("<span class='danger'>[user] tears open [F]!</span>",\
							"<span class='danger'>[user] tears open [F]!</span>")
		F.open()

	else if(isliving(target))
		if(ishuman(target))
			check_infection(target, user)
		check_feast(target, user)

/obj/item/zombie_hand/proc/check_infection(mob/living/carbon/human/target, mob/user)
	CHECK_DNA_AND_SPECIES(target)

	if(NOZOMBIE in target.dna.species.specflags)
		// cannot infect any NOZOMBIE subspecies (such as high functioning
		// zombies)
		return

	var/infectionresult = tear_clothes(user, target) // true for block, false for hit
	if(infectionresult)
		user.visible_message("<span class='warning'>[target] managed to block [user]'s claw!</span>",\
								"<span class='warning'>[target] managed to block [user]'s claw!</span>")
		return

	var/obj/item/organ/body_egg/zombie_infection/infection
	infection = target.getorganslot("zombie_infection")
	if(!infection)
		infection = new(target)



/obj/item/zombie_hand/proc/tear_clothes(mob/user, mob/living/carbon/target)
	if(user.zone_selected == "head" || user.zone_selected == "eyes" || user.zone_selected == "mouth")
		if(!target.head)
			return FALSE
		if(target.unEquip(target.head))
			if(istype(target.head, /obj/item/clothing/head/helmet/space/hardsuit)) // NODROP hardsuit has 45% chance.
				if(prob(45))
					target.head.attack_self(target) // technically hit, but they got off lucky.
			return TRUE
		else
			return FALSE
	else
		if(!ishuman(target))
			return FALSE
		var/mob/living/carbon/human/target_h = target
		if(!target_h.wear_suit)
			if(!target_h.w_uniform)
				return FALSE
		if(target_h.wear_suit)
			target_h.wear_suit.visible_message("<span class='danger'>[user] tears through [target]'s [target_h.wear_suit.name].</span>",\
									"<span class='danger'>[user] tears through [target]'s [target_h.wear_suit.name].</span>")
			if(target_h.unEquip(target_h.wear_suit))
				return FALSE
			else
				return TRUE
		else
			if(target_h.w_uniform)
				if(istype(target_h.w_uniform, /obj/item/clothing/under))
					var/obj/item/clothing/under/U = target_h.w_uniform
					U.handle_tear(user, 4) // tearhealth is usually 100. this means it takes 2 tears to break this layer.
					var/verbose = pick("shreds", "tears", "rips through", "slices", "breaks", "bites into")
					target_h.w_uniform.visible_message("<span class='danger'>[user] [verbose] [target]'s [target_h.w_uniform.name].<span>",\
								"<span class='danger'>[user] [verbose] [target]'s [target_h.w_uniform.name].<span>")
					if(target_h.w_uniform)
						return TRUE
					else
						return FALSE
				return FALSE


/obj/item/zombie_hand/proc/check_feast(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		if(target.health > -200)
			var/hp_gained = rand(5, 10)
			target.adjustBruteLoss(force*2)
			user.adjustBruteLoss(-hp_gained)
			user.adjustToxLoss(-hp_gained)
			user.adjustFireLoss(-hp_gained)
			user.adjustCloneLoss(-hp_gained)
			user.adjustBrainLoss(-hp_gained)
			target.visible_message("<span class='danger'>[user] digs their claws into [target] pulling out bloody chunks of \
								meat, and devouring them.</span>",\
								"<span class='danger'>[user] digs their claws into [target] pulling out bloody chunks of \
								meat, and devouring them.</span>")
			if(!ishuman(target))
				if(target.stat == DEAD)
					target.gib()
				else if(target.stat != DEAD && iscarbon(target)) // so we can tear off something.
					tear_clothes(user, target)

/obj/item/zombie_hand/proc/tear_airlock(obj/machinery/door/airlock/A, mob/user)
	removing_airlock = TRUE
	to_chat(user, "<span class='notice'>You start tearing apart the airlock...</span>")

	playsound(src.loc, 'sound/machines/airlock_alien_prying.ogg', 100, 1)
	A.audible_message("<span class='italics'>You hear a loud metallic \
		grinding sound.</span>")

	addtimer(src, "growl", 20, unique=FALSE, user)

	if(do_after(user, delay=160, needhand=FALSE, target=A, progress=TRUE))
		playsound(src.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
		A.audible_message("<span class='danger'>With a screech, [A] is torn \
			apart!</span>")
		var/obj/structure/door_assembly/door = new A.doortype(get_turf(A))
		door.density = 0
		door.anchored = 1
		door.name = "ravaged [door]"
		door.desc = "An airlock that has been torn apart. Looks like it \
			won't be keeping much out now."
		qdel(A)
	removing_airlock = FALSE

/obj/item/zombie_hand/proc/growl(mob/user)
	if(removing_airlock)
		playsound(src.loc, 'sound/hallucinations/growl3.ogg', 50, 1)
		user.audible_message("<span class='warning'>[user] growls as \
			their claws dig into the metal frame...</span>")

/obj/item/zombie_hand/suicide_act(mob/living/carbon/user)
	// Suiciding as a zombie brings someone else in to play it
	user.visible_message("<span class='suicide'>[user] is lying down.</span>")
	if(!istype(user))
		return

	user.Weaken(30)
	var/success = offer_control(user)
	if(success)
		user.visible_message("<span class='suicide'>[user] appears to have \
			found new spirit.</span>")
		return SHAME
	else
		user.visible_message("<span class='suicide'>[user] stops moving.\
			</span>")
		return OXYLOSS