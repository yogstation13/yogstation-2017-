/obj/item/weapon/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 8
	throwforce = 10
	w_class = 4
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	burn_state = FLAMMABLE
	var/janiLocate = TRUE
	var/mopcap = 5
	var/mopspeed = 30

/obj/item/weapon/mop/New()
	..()
	if(janiLocate)
		janitorial_items += src
	create_reagents(mopcap)

/obj/item/weapon/mop/Destroy()
	. = ..()
	if(janiLocate)
		janitorial_items -= src

/obj/item/weapon/mop/attack(mob/living/M, mob/living/user)
	if(user.a_intent == "help") //if we are on help intent, we clean them instead of whacking them
		return
	return ..()

/obj/item/weapon/mop/attack_obj(obj/O, mob/living/user)
	if(user.a_intent == "help") //if we are on help intent, we clean things instead of whacking them
		return
	return ..()

/obj/item/weapon/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(reagents.total_volume < 1)
		user << "<span class='warning'>Your [name] is dry!</span>"
		return

	if(is_cleanable(A))
		A = A.loc

	if((user.a_intent == "help") && ishuman(A))
		var/mob/living/carbon/human/H = A
		H.visible_message("<span class=notice>[user] begins to cleaning [H] with [src]...</span>", "<span class='danger'>[user] begins to cleaning you with [src]...</span>")
		if(!do_after(user, mopspeed, target = H))
			return
		if(reagents.total_volume < 1)
			user << "<span class='warning'>Your [name] is dry!</span>"
			return
		user.visible_message("<span class=notice>[user] finishes cleaning [H] with [src].</span>", "<span class='notice'>You finish cleaning [H] with [src].</span>")
		if(reagents_do_clean())
			H.wash_cream()
			H.clean_blood()
		reagents.reaction(A, TOUCH)
		reagents.remove_all(1) //reaction() doesn't use up the reagents
	else if(isturf(A))
		var/turf/T = A
		user.visible_message("<span class=notice>[user] begins to clean \the [T] with [src]...</span>", "<span class='notice'>You begin to clean \the [T] with [src]...</span>")
		if(!do_after(user, mopspeed, target = T))
			return
		if(reagents.total_volume < 1)
			user << "<span class='warning'>Your [name] is dry!</span>"
			return
		user << "<span class='notice'>You finish mopping.</span>"
		clean_turf(T)
	else if(user.a_intent != "harm")
		A.visible_message("[user] starts to wipe down [A] with [src]!", "<span class='notice'>You start to wipe down [A] with [src]...</span>")
		if(!do_after(user,mopspeed, target = A))
			return
		if(reagents.total_volume < 1)
			user << "<span class='warning'>Your [name] is dry!</span>"
			return
		user.visible_message("[user] finishes wiping off the [A]!", "<span class='notice'>You finish wiping off the [A].</span>")
		if(reagents_do_clean())
			A.clean_blood()
		reagents.reaction(A, TOUCH)
		reagents.remove_all(1) //reaction() doesn't use up the reagents

/obj/item/weapon/mop/proc/reagents_do_clean()
	if(!reagents.total_volume)
		return FALSE
	var/cleaner_vol = 0
	for(var/V in reagents.reagent_list)
		var/datum/reagent/R = V
		if(R.cleans)
			cleaner_vol += R.volume
	return ((cleaner_vol / reagents.total_volume) >= 0.5)

/obj/effect/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/soap))
		return
	else
		return ..()

/obj/item/weapon/mop/proc/janicart_insert(mob/user, obj/structure/mopbucket/janitorialcart/J)
	J.put_in_cart(src, user)
	J.mymop=src
	J.update_icon()

/obj/item/weapon/mop/proc/clean_turf(turf/T)
	if(reagents_do_clean())
		T.clean_blood()
		for(var/obj/effect/O in T)
			if(is_cleanable(O))
				qdel(O)
		if(istype(T, /turf/closed))
			var/turf/closed/C = T
			if(C.thermite)
				C.thermite = 0
				C.overlays.Cut()
	reagents.reaction(T, TOUCH, 5)	//Needed for proper floor wetting
	reagents.remove_all(1)			//reaction() doesn't use up the reagents

/obj/item/weapon/mop/advanced
	name = "advanced mop"
	desc = "The most advanced tool in a custodian's arsenal, ergonomic, collapsible, and complete with a condenser for self-wetting! Just think of all the viscera you will clean up with this!"
	icon_state = "advmop"
	item_state = "mop"
	origin_tech = "materials=3;engineering=3"
	force = 10
	throwforce = 12
	w_class = 3
	mopspeed = 20
	mopcap = 10
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 1 //Rate per process() tick mop refills itself
	var/refill_reagent = "water" //Determines what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/weapon/mop/advanced/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	user << "<span class='notice'>You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position.</span>"
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/weapon/mop/advanced/process()
	if(reagents.total_volume < mopcap)
		reagents.add_reagent(refill_reagent, refill_rate)

/obj/item/weapon/mop/advanced/examine(mob/user)
	..()
	user << "<span class='notice'>The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>.</span>"

/obj/item/weapon/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/mop/advanced/cyborg
	janiLocate = FALSE

/obj/item/weapon/mop/advanced/cyborg/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	return 0

/obj/item/weapon/mop/advanced/holy
	name = "holy mop of purging"
	desc = "Legends say that this mop was created by a great janitor-chaplain to ward off evil spirits and space wizards. Everyone thought he was crazy until they actually started showing up."
	refill_reagent = "holywater"
	mopspeed = 10