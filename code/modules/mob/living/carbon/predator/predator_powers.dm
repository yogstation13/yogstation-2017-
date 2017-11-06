///////////////////////////////
///		SKULL REMOVAL 		///
///////////////////////////////

/obj/item/trophy_skull
	name = "human skull"
	desc = "No matter the score, I'm always a-head!"
	icon = 'icons/mob/predators.dmi'
	icon_state = "skull"


/obj/effect/proc_holder/spell/self/remove_skull
	name = "Skull Removal"
	desc = "Rips the skull out of your target's head and claims your trophy."
	clothes_req = 0
	charge_max = 15
	cooldown_min = 10
	invocation = null
	invocation_type = "none"
	school = "evocation"
	action_icon_state = "alien_transfer"

/obj/effect/proc_holder/spell/self/remove_skull/cast(mob/living/carbon/human/user)
	if(!ispredator(user))
		to_chat(user, "<span class='danger'>You're too weak!</span>")
		qdel(user)
		return

	if(!user.pulling || !iscarbon(user.pulling))
		to_chat(user, "<span class='warning'>You must hold the target in a head-lock to remove their skull!</span>")
		return
	if(user.grab_state <= GRAB_NECK)
		to_chat(user, "<span class='warning'>You have to carry a tighter grip on the target to remove their skull!</span>")
		return

	var/mob/living/carbon/ptarget = user.pulling

	visible_message("<span class='danger'>[user] has plunged their sharp, dagger-like fingers into [ptarget]'s eyes!</span>", \
		"<span class='danger'>You plunge your sharp, dagger-like fingers into [ptarget]'s eyes!</span>")
	if(!iszombie(ptarget))
		to_chat(ptarget, "<span class='danger'>OH GOD!!! THE PAIN!</span>")
		ptarget.adjust_eye_damage(50)
		ptarget.blind_eyes(1)
		ptarget.Weaken(20)
	if(do_after(user, 200, target = ptarget))
		ptarget.visible_message("<span class='danger'>[user] furthers his grip around [ptarget]'s skull!</span>",\
			"<span class='danger'>You can feel fingers wrapping around the inside of your skull!</span>")
		to_chat(user, "<span class='danger'>Now it's time to collect your trophy...</span>")
		ptarget.Weaken(10)
		if(do_after(user, 50, target = ptarget))
			if(ptarget.stat != DEAD)
				ptarget.visible_message("<span class='danger'>In an instant, [user] tears out [ptarget]'s skull along with their spinal cord whipping back and forth above their body now torn open.</span>",\
					"<span class='danger'>In an instant, after feeling all sorts of tremendous pain you are left with a feeling of numbness as your skull is torn from your head.</span>")
				ptarget.death()
			ptarget.adjustBruteLoss(200)
			ptarget.visible_message("<span class='danger'>[ptarget]'s brain and spinal cord get ripped out of their body along with their skull clutched by [user]!</span>")
			ptarget.spill_organs()
			new /obj/item/trophy_skull(get_turf(ptarget))