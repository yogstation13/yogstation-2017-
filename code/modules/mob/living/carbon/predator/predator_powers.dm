///////////////////////////////
///		SKULL REMOVAL 		///
///////////////////////////////

/datum/action/innate/predator_remove_skull
	name = "Remove Skull"
	button_icon_state = "godspeak"
	check_flags = AB_CHECK_CONSCIOUS
	var/busy

/datum/action/innate/predator_remove_skull/Activate()
	if(!ispredator(usr))
		Remove(usr)

	if(busy)
		return
	var/mob/living/carbon/human/predator/P = usr
	P.remove_skull()


/mob/living/carbon/human/predator/verb/remove_skull()
	set name = "Remove Skull"
	set desc = "Digs the Predator's fingers into the eye sockets of their target, and attempts to yank out their skull from their head."
	set category = "Predator"

	for(var/datum/action/innate/predator_remove_skull/dat_skull in src)
		if(dat_skull.busy)
			return
		else
			dat_skull.busy = 1 // o shit waddup

	if(!ispredator(src))
		qdel(src)
		return
	if(!src.pulling || !iscarbon(src.pulling))
		src << "<span class='warning'>You must hold the target in a head-lock to remove their skull!</span>"
		return
	if(src.grab_state <= GRAB_NECK)
		src << "<span class='warning'>You have to carry a tighter grip on the target to remove their skull!</span>"
		return

	var/mob/living/carbon/ptarget = src.pulling

	visible_message("<span class='danger'>[src] has plunged their sharp, dagger-like fingers into [ptarget]'s eyes!</span>", \
		"<span class='danger'>You plunge your sharp, dagger-like fingers into [ptarget]'s eyes!</span>")
	if(!iszombie(ptarget))
		ptarget.visible_message("<span class='danger'>OH GOD!!! THE PAIN!</span>")
		ptarget.adjust_eye_damage(25)
		ptarget.blind_eyes(1)
		ptarget.Weaken(20)
	if(do_after(src, 200, target = ptarget))
		ptarget.visible_message("<span class='danger'>[src] furthers his grip around [ptarget]'s skull!</span>",\
			"<span class='danger'>You can feel fingers wrapping around the inside of your skull!</span>")
		src << "<span class='danger'>Now it's time to collect your trophy...</span>"
		ptarget.Weaken(10)
		if(do_after(src, 50, target = ptarget))
			if(ptarget.stat != DEAD)
				ptarget.visible_message("<span class='danger'>In an instant, [src] tears out [ptarget]'s skull along with their spinal cord whipping back and forth above their body now torn open.</span>",\
					"<span class='danger'>In an instant, after feeling all sorts of tremendous pain you are left with a feeling of numbness as your skull is torn from your head.</span>")
				ptarget.death()
			ptarget.adjustBruteLoss(200)
			ptarget.visible_message("<span class='danger'>[ptarget]'s brain and spinal cord get ripped out of their body along with their skull clutched by [src]!</span>")
			ptarget.spill_organs()
			new /obj/item/trophy_skull(get_turf(ptarget))


/obj/item/trophy_skull
	name = "human skull"
	desc = "No matter the score, I'm always a-head!"
	icon = 'icons/mob/predators.dmi'
	icon_state = "skull"