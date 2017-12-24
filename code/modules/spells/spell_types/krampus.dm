/obj/effect/proc_holder/spell/targeted/naughty
	name = "Naughty Stare"
	panel = "Krampus"
	charge_max = 300
	human_req = 1
	clothes_req = 0

/obj/effect/proc_holder/spell/targeted/naughty/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = targets[1]
	if(!ishuman(H))
		to_chat(user, "<span class='warning'>You may only glare at humans!</span>")
		revert_cast()
		return
	user.visible_message("<span class='warning'><b>[user]'s eyes lock with [H]'s, and a devilish grin spreads \
						across their face.</b></span>")

	H.silent += 10
	if((H in naughty_list))
		H.Stun(15)
		to_chat(H, "<span class='warning'>You hear [user.real_name]'s cackling in the back of your head. Everything grows silent \
					Santa has betrayed you. Krampus is here because you are on the naughty list.</span>")
	else
		to_chat(user, "<span class='notice'>[H] is on the nice list!</span>")
		H.Stun(1) // krampus get away!

/obj/effect/proc_holder/spell/self/krampustele
	name = "Teleport to Krampus Workshop"
	desc = "This will alert the crew of your presence as you get away."
	panel = "Krampus"
	charge_max = 1000
	cooldown_min = 950
	clothes_req = 0

/obj/effect/proc_holder/spell/self/krampustele/cast(list/targets, mob/user = usr)
	to_chat(user, "<span class='warning'>You begin to channel negative energy. The crew will be alerted of your location shortly..</span>")
	var/obj/item/toy/figure/cursed/C = locate() in user
	if(C)
		to_chat(user, "<span class='warning'>You can't travel with one of your cursed toys!</span>")
		return

	if (do_after(user, 80, target = user))
		if(user.z == ZLEVEL_CENTCOM)
			user.forceMove(get_turf((pick(blobstart))))
			return
		for(var/mob/mob in player_list)
			if(mob != user)
				to_chat(mob, "<span class='warning'>You hear the demonic screams of hell reign [dir2text(get_dir(get_turf(mob), get_turf(user)))] of your location! The ringing of unholy bells!</span>")
				mob << 'sound/hallucinations/im_here1.ogg'

		if(do_after(user, 1000, target = user))
			for(var/obj/effect/landmark/L in landmarks_list)
				if(L.name == "KrampShip")
					user.forceMove(get_turf(L))
	else
		to_chat(user, "<span class='warning'>You cancel your ability.</span>")

/obj/effect/proc_holder/spell/aoe_turf/conjure/unholybells
	name = "Conjure Unholy Bells!"
	desc = "May the naughty fear your presence!"
	charge_max = 50
	cooldown_min = 10
	clothes_req = 0
	range = 3

	summon_type = list("/obj/item/coalbell")
	summon_lifespan = 0
	summon_amt = 2