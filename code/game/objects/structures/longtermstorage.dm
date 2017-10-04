/obj/structure/cryptosleep_casket
	name = "cryptosleep casket"
	desc = "A self-powered sarcophagus designed to keep a person in a state of suspended animation for many years."
	icon = 'icons/obj/machines/cryptosleep_casket.dmi'
	icon_state = "casket"
	density = TRUE
	anchored = TRUE
	verb_say = "beeps"

	var/obj/item/device/radio/announcement_radio
	var/list/forbidden_items = list(/obj/item/weapon/gun/energy/laser/captain,
									/obj/item/weapon/gun/energy/gun/hos,
									/obj/item/weapon/hand_tele,
									/obj/item/weapon/tank/jetpack/oxygen/captain,
									/obj/item/clothing/tie/medal/gold/captain,
									/obj/item/weapon/reagent_containers/hypospray/CMO,
									/obj/item/weapon/disk/nuclear,
									/obj/item/clothing/suit/armor/laserproof,
									/obj/item/clothing/suit/armor/reactive,
									/obj/item/documents,
									/obj/item/nuke_core,
									/obj/item/weapon/tank/internals/royalp,
									/obj/item/areaeditor/blueprints,
									/obj/item/weapon/rapid_engineering_device,
									/obj/item/weapon/pinpointer)

/obj/structure/cryptosleep_casket/New()
	..()
	announcement_radio = new(src)
	announcement_radio.set_frequency(1459)
	announcement_radio.listening = FALSE

/obj/structure/cryptosleep_casket/interact(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.stat)
		return
	store(user)

/obj/structure/cryptosleep_casket/proc/store(mob/user)
	var/mob/living/carbon/human/target = locate() in get_step(src, EAST)
	if(!target)
		say("Please step in front of the machine before starting the cryptosleep process.")
		return
	if(target != user) return //no forceful storage
	var/list/found = list()
	var/list/all_items = target.GetAllContents()
	for(var/I in forbidden_items)
		var/obj/item/FI = locate(I) in all_items
		if(FI) found += FI
	if(found.len)
		say("The following items have been found on your person:")
		for(var/obj/item/I in found)
			say("[I].")
		say("Please remove those items before proceeding.")
		return
	if(alert(user, "Are you sure you want to enter storage? This action cannot be undone!", , "Yes", "No") == "No") return
	target.loc = src
	icon_state = "casket-storing"
	sleep(10)
	playsound(src.loc, 'sound/machines/juicer.ogg', 100, 1)

	var/datum/job/j = SSjob.GetJob(target.mind.assigned_role)
	if(j) j.current_positions--

	var/msg = "[target]"
	if(j) msg += ", [target.mind.assigned_role], "
	msg += "has entered long-term storage."
	announcement_radio.talk_into(src, msg, 1459)
	sleep(30)
	qdel(target)
	sleep(50)
	icon_state = "casket"