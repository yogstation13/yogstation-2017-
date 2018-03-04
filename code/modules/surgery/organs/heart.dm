/obj/item/organ/heart
	name = "heart"
	icon_state = "heart-on"
	zone = "chest"
	slot = "heart"
	origin_tech = "biotech=5"
	var/beating = 1
	var/icon_base = "heart"
	attack_verb = list("beat", "thumped")
	decay_time = DEFIB_TIME_LIMIT

/obj/item/organ/heart/update_icon()
	if(beating)
		icon_state = "[icon_base]-on"
	else
		icon_state = "[icon_base]-off"

/obj/item/organ/heart/Remove(mob/living/carbon/M, special = 0)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat == DEAD || H.heart_attack)
			Stop()
			return
		if(!special)
			H.heart_attack = 1

	addtimer(src, "stop_if_unowned", 120)

/obj/item/organ/heart/proc/stop_if_unowned()
	if(!owner)
		Stop()

/obj/item/organ/heart/attack_self(mob/user)
	..()
	if(!beating)
		if(Restart())
			user.visible_message("<span class='notice'>[user] squeezes [src] to make it beat again!</span>")
			addtimer(src, "stop_if_unowned", 80)
		else
			user.visible_message("<span class='warning'>[user] squeezes [src], but it does not start to beat.</span>")

/obj/item/organ/heart/Insert(mob/living/carbon/M, special = 0)
	if(..())
		if(ishuman(M) && beating)
			var/mob/living/carbon/human/H = M
			if(H.heart_attack)
				H.heart_attack = 0
		return 1

/obj/item/organ/heart/proc/Stop()
	beating = 0
	update_icon()
	return 1

/obj/item/organ/heart/proc/Restart()
	if(decay_time && decay >= decay_time)
		return 0
	beating = 1
	update_icon()
	return 1

/obj/item/organ/heart/handle_decay()
	..()
	if(decay_time && decay >= decay_time)
		Stop()

/obj/item/organ/heart/prepare_eat()
	var/obj/S = ..()
	S.icon_state = "heart-off"
	return S


/obj/item/organ/heart/cursed
	name = "cursed heart"
	desc = "it needs to be pumped..."
	icon_state = "cursedheart-off"
	icon_base = "cursedheart"
	origin_tech = "biotech=6"
	actions_types = list(/datum/action/item_action/organ_action/cursed_heart)
	decay_time = 0
	var/last_pump = 0
	var/add_colour = TRUE //So we're not constantly recreating colour datums
	var/pump_delay = 30 //you can pump 1 second early, for lag, but no more (otherwise you could spam heal)
	var/blood_loss = 100 //600 blood is human default, so 5 failures (below 122 blood is where humans die because reasons?)

	//How much to heal per pump, negative numbers would HURT the player
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_oxy = 0


/obj/item/organ/heart/cursed/attack(mob/living/carbon/human/H, mob/living/carbon/human/user, obj/target)
	if(H == user && istype(H))
		playsound(user,'sound/effects/singlebeat.ogg',40,1)
		user.drop_item()
		Insert(user, 1)
	else
		return ..()

/obj/item/organ/heart/cursed/on_life()
	if(world.time > (last_pump + pump_delay))
		if(ishuman(owner) && owner.client) //While this entire item exists to make people suffer, they can't control disconnects.
			var/mob/living/carbon/human/H = owner
			if(H.dna && !(NOBLOOD in H.dna.species.specflags))
				H.blood_volume = max(H.blood_volume - blood_loss, 0)
				H << "<span class = 'userdanger'>You have to keep pumping your blood!</span>"
				if(add_colour)
					H.add_client_colour(/datum/client_colour/cursed_heart_blood) //bloody screen so real
					add_colour = FALSE
		else
			last_pump = world.time //lets be extra fair *sigh*

/obj/item/organ/heart/cursed/Insert(mob/living/carbon/M, special = 0)
	if(..())
		if(owner)
			owner << "<span class ='userdanger'>Your heart has been replaced with a cursed one, you have to pump this one manually otherwise you'll die!</span>"
		return 1

/datum/action/item_action/organ_action/cursed_heart
	name = "pump your blood"

//You are now brea- pumping blood manually
/datum/action/item_action/organ_action/cursed_heart/Trigger()
	. = ..()
	if(. && istype(target,/obj/item/organ/heart/cursed))
		var/obj/item/organ/heart/cursed/cursed_heart = target

		if(world.time < (cursed_heart.last_pump + (cursed_heart.pump_delay-10))) //no spam
			owner << "<span class='userdanger'>Too soon!</span>"
			return

		cursed_heart.last_pump = world.time
		playsound(owner,'sound/effects/singlebeat.ogg',40,1)
		owner << "<span class = 'notice'>Your heart beats.</span>"

		var/mob/living/carbon/human/H = owner
		if(istype(H))
			if(H.dna && !(NOBLOOD in H.dna.species.specflags))
				H.blood_volume = min(H.blood_volume + cursed_heart.blood_loss*0.5, BLOOD_VOLUME_MAXIMUM)
				H.remove_client_colour(/datum/client_colour/cursed_heart_blood)
				cursed_heart.add_colour = TRUE
				H.adjustBruteLoss(-cursed_heart.heal_brute, 1, DAMAGE_MAGIC)
				H.adjustFireLoss(-cursed_heart.heal_burn, 1, DAMAGE_MAGIC)
				H.adjustOxyLoss(-cursed_heart.heal_oxy, 1, DAMAGE_MAGIC)


/datum/client_colour/cursed_heart_blood
	priority = 100 //it's an indicator you're dieing, so it's very high priority
	colour = "red"

/obj/item/organ/heart/cybernetic
	name = "cybernetic heart"
	desc = "An electronic device designed to mimic the functions of an organic human heart. Does not decay."
	icon_base = "heart-c"
	icon_state = "heart-c-on"
	origin_tech = "biotech=5"
	decay_time = 0
	decay = 0

/obj/item/organ/heart/cybernetic/emp_act()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(!H.heart_attack)
		H.heart_attack = TRUE
		if(H.stat == CONSCIOUS)
			H.visible_message("<span class='userdanger'>[H] clutches at their chest as if their heart stopped!</span>")
