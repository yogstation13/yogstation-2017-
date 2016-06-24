//almost exactly the same as de-thralling, with the final step slightly different.

/datum/surgery/remove_cyberman
	name = "remove illegal implants"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/de_cybermanize)
	possible_locs = list("head")
	requires_organic_bodypart = 0

/datum/surgery/remove_cyberman/can_start(mob/user, mob/living/carbon/target)
	return target && ticker.mode.is_cyberman(target.mind)

/datum/surgery_step/de_cybermanize
	name = "remove implants"
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/melee/energy/sword = 75, /obj/item/weapon/kitchen/knife = 65, /obj/item/weapon/shard = 45)//currently the same implements as the incise step
	time = 30

/datum/surgery_step/de_cybermanize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] reaches into [target]'s head with [tool].", "<span class='notice'>You begin cutting the illegal implants out of [target]'s brain with the [tool]...</span>")

/datum/surgery_step/de_cybermanize/success(mob/user, mob/living/carbon/target, target_zone, datum/surgery/surgery)
	user.visible_message("[user] pulls the implants from [target]'s head!", "<span class='notice'>You remove the implants from [target]'s brain!</span>")
	user.visible_message("The implants disintegrate into dust in [user]'s hands!", "<span class='notice'>The implants disintegrate to dust in your hands!</span>")
	spawn(30)//person gets a short time to revel in their non-cyberman freedom.
		target.adjustBrainLoss(100)//massive brain damage.
	ticker.mode.remove_cyberman(target.mind)
	return 1

