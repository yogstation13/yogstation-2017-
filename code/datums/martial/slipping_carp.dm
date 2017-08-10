/datum/martial_art/slipping_carp
	name = "Slipping Carp"
	//can_deflect_projectiles
	no_ranged_weapons = TRUE
	no_slip = TRUE
	help_verb = /mob/living/carbon/human/proc/slipping_carp_help

/datum/martial_art/slipping_carp/item_attack(mob/living/carbon/human/user, obj/item/I, atom/target)
	if(!istype(user) || !check_mop(I))
		return FALSE
	var/obj/item/weapon/mop/M = I
	if(isturf(target) && (user.a_intent != "help"))
		wetFloor(user, M, target)
		return TRUE
	if(isliving(target))
		var/mob/living/L = target
		if(user.a_intent == "harm")
			mopHarm(user, M, L)
			return TRUE
		else if(user.a_intent == "disarm")
			mopDisarm(user, M, L)
			return TRUE
		else if(user.a_intent == "grab")
			mopGrab(user, M, L)
			return TRUE
	return FALSE

/datum/martial_art/slipping_carp/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/obj/item/I = A.get_active_hand()
	if(check_mop(I))
		mopGrab(A, I, D)
		return TRUE
	return ..()

/datum/martial_art/slipping_carp/proc/wetFloor(mob/living/carbon/human/user, obj/item/weapon/mop/M, turf/T)
	if(M.reagents.total_volume < 1)
		user << "<span class='warning'>Your mop is dry!</span>"
		return TRUE
	user.changeNext_move(CLICK_CD_MELEE)
	M.clean_turf(T)
	for(var/mob/living/L in T)
		if(!L.lying && L.slip(5, 5, null, GALOSHES_DONT_HELP))
			L.visible_message("<span class='danger'>[user] sweeps [L]'s legs out from under them with [M]!</span>", \
									"<span class='userdanger'>[user] sweeps your legs out from under you with [M]!</span>")
			add_logs(user, L, "slipped with slipping carp")
		else
			add_logs(user, L, "attempted to slip with slipping carp")

/datum/martial_art/slipping_carp/proc/mopDisarm(mob/living/carbon/human/user, obj/item/weapon/mop/M, mob/living/L)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(L, null, M)
	var/obj/item/target_item = L.get_active_hand()
	if(target_item && prob(60))
		if(L.drop_item())
			if(!qdeleted(target_item) && (target_item.loc == get_turf(L)))
				var/throw_dir = pick(cardinal - list(get_dir(L, user), get_dir(user, L)) )
				var/turf/T = get_step(get_step(get_step(L, throw_dir), throw_dir), throw_dir)
				target_item.throw_at(T, 3, target_item.throw_speed, user)
			L.visible_message("<span class='danger'>[user] knocks [target_item] out of [L]'s hands with [M]!</span>", \
								"<span class='userdanger'>[user] knocks [target_item] out of your hand with [M]!</span>")
			playsound(L, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		else
			L.visible_message("<span class='danger'>[user] tries to knock [target_item] out of [L]'s hands with [M], but can't!</span>", \
								"<span class='userdanger'>[user] tries to knock [target_item] out of your hand with [M], but can't!</span>")
			playsound(L, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	else
		L.visible_message("<span class='danger'>[user] swings [M] at [L]'s hands!</span>", \
							"<span class='userdanger'>[user] swings [M] at your hands!</span>")
		playsound(L, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	add_logs(user, L, "disarmed with slipping carp", "[target_item ? " removing \the [target_item]" : ""]")

/datum/martial_art/slipping_carp/proc/mopHarm(mob/living/carbon/human/user, obj/item/weapon/mop/M, mob/living/L)
	var/oldforce = M.force
	var/oldpen = M.armour_penetration
	M.force = max(15, oldforce)
	M.armour_penetration = 100
	L.attackby(M, user)
	M.force = oldforce
	M.armour_penetration = oldpen

/datum/martial_art/slipping_carp/proc/mopGrab(mob/living/carbon/human/user, obj/item/weapon/mop/M, mob/living/L)
	if(user.grab_state >= GRAB_AGGRESSIVE)
		L.grabbedby(user, 1)
	else
		user.start_pulling(L, 1)
		if(user.pulling)
			L.drop_item()
			L.stop_pulling()
		if(user.a_intent == "grab")
			L.visible_message("<span class='danger'>[user] puts [L] in a chokehold with [M]!</span>", \
							"<span class='userdanger'>[user] puts you in a chokehold with [M]!</span>")
			add_logs(user, L, "grabbed", addition="aggressively")
			user.grab_state = GRAB_AGGRESSIVE //Instant aggressive grab
		else
			add_logs(user, L, "grabbed", addition="passively")
			user.grab_state = GRAB_PASSIVE

/datum/martial_art/slipping_carp/proc/check_mop(obj/item/weapon/mop/M)
	if(!istype(M) || (M.w_class < 3)) //the w_class check is to exclude rags
		return FALSE
	return TRUE

/datum/martial_art/slipping_carp/try_deflect_projectile(mob/living/carbon/human/user, obj/item/projectile/Proj, silent = FALSE)
	var/obj/item/weapon/mop/M = user.get_active_hand()
	if(check_mop(M))
		if(!silent)
			user.visible_message("<span class='danger'>[user] deflects the projectile with [M]; they can't be hit with ranged weapons while holding it!</span>", "<span class='userdanger'>You deflect the projectile with [M]!</span>")
			playsound(user, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/slipping_carp_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Slipping Carp clan."
	set category = "Slipping Carp"

	usr << "<b><i>You retreat inward and recall the teachings of the Slipping Carp...</i></b>"

	usr << "<span class='notice'>Mop (Harm): Deal more damage than normal and ignore armor.</span>"
	usr << "<span class='notice'>Mop (Grab): Instantly grab the target aggressively.</span>"
	usr << "<span class='notice'>Mop (Disarm): Attempt to knock the weapon out of your opponent's hands and fling it away.</span>"
	usr << "<span class='notice'>Mop (Floor, Non-Help): Instantly wet the floor and slip any person standing on it. Mop must be wet.</span>"

/obj/item/weapon/martial_arts_scroll/slipping_carp_scroll
	name = "mysterious scroll"
	desc = "A scroll filled with strange markings. It seems to be drawings of a purple-clad man swinging around a mop."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	marital_art_type = /datum/martial_art/slipping_carp
	learned_message = "<span class='sciradio'>You have learned the ancient martial art of the Slipping Carp! Your attacks using a mop are now much more powerful, and you are able to deflect any projectiles \
									directed toward you while holding one. You are also immune to all forms of slipping. However, you are also unable to use any ranged weaponry. You can learn more about your \
									newfound art by using the Recall Teachings verb in the Slipping Carp tab.</span>"
	visible_learned_message = "lights up in fire and quickly burns to ash."
