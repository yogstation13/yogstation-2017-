// This is to replace the previous datum/disease/alien_embryo for slightly improved handling and maintainability
// It functions almost identically (see code/datums/diseases/alien_embryo.dm)
/obj/item/organ/body_egg/alien_embryo
	name = "alien embryo"
	icon = 'icons/mob/alien.dmi'
	icon_state = "larva0_dead"
	var/stage = 0
<<<<<<< HEAD
	var/growing = FALSE
	var/hive_faction
=======
	var/bursting = FALSE
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

/obj/item/organ/body_egg/alien_embryo/on_find(mob/living/finder)
	..()
	if(stage < 4)
		to_chat(finder, "It's small and weak, barely the size of a foetus.")
	else
		to_chat(finder, "It's grown quite large, and writhes slightly as you look at it.")
		if(prob(10))
			AttemptGrow(0)

/obj/item/organ/body_egg/alien_embryo/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 10)
	return S

/obj/item/organ/body_egg/alien_embryo/on_life()
	switch(stage)
		if(2, 3)
			if(prob(2))
				owner.emote("sneeze")
			if(prob(2))
				owner.emote("cough")
			if(prob(2))
				to_chat(owner, "<span class='danger'>Your throat feels sore.</span>")
			if(prob(2))
				to_chat(owner, "<span class='danger'>Mucous runs down the back of your throat.</span>")
		if(4)
			if(prob(2))
				owner.emote("sneeze")
			if(prob(2))
				owner.emote("cough")
			if(prob(4))
				to_chat(owner, "<span class='danger'>Your muscles ache.</span>")
				if(prob(20))
					owner.take_bodypart_damage(1)
			if(prob(4))
				to_chat(owner, "<span class='danger'>Your stomach hurts.</span>")
				if(prob(20))
					owner.adjustToxLoss(1)
		if(5)
			to_chat(owner, "<span class='danger'>You feel something tearing its way out of your stomach...</span>")
			owner.adjustToxLoss(10)

/obj/item/organ/body_egg/alien_embryo/egg_process()
	if(stage < 5 && prob(3))
		stage++
		INVOKE_ASYNC(src, .proc/RefreshInfectionImage)

	if(stage == 5 && prob(50))
		for(var/datum/surgery/S in owner.surgeries)
			if(S.location == "chest" && istype(S.get_surgery_step(), /datum/surgery_step/manipulate_organs))
				AttemptGrow(0)
				return
		AttemptGrow()



<<<<<<< HEAD
/obj/item/organ/body_egg/alien_embryo/proc/AttemptGrow(gib_on_success = 1)
	if(growing)
		return
	if(!owner)
		return
	growing = TRUE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [hive_faction ? " [hive_faction]" : ""] alien larva?", ROLE_ALIEN, null, ROLE_ALIEN, 200, src)
	growing = FALSE
	if(!owner)
		return
	var/client/C = null
=======
/obj/item/organ/body_egg/alien_embryo/proc/AttemptGrow(gib_on_success=TRUE)
	if(!owner || bursting)
		return

	bursting = TRUE
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

	var/list/candidates = pollCandidates("Do you want to play as an alien larva that will burst out of [owner]?", ROLE_ALIEN, null, ROLE_ALIEN, 100, POLL_IGNORE_ALIEN_LARVA)

<<<<<<< HEAD
	if(candidates.len)
		var/mob/dead/observer/O = pick(candidates)
		C = O.client
	else if(owner.client && !(jobban_isbanned(owner, "alien candidate") || jobban_isbanned(owner, "Syndicate")))
		C = owner.client
	else
		stage = 4 // Let's try again later.
=======
	if(QDELETED(src) || QDELETED(owner))
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
		return

	if(!candidates.len || !owner)
		bursting = FALSE
		stage = 4
		return

	var/mob/dead/observer/ghost = pick(candidates)

	var/overlay = image('icons/mob/alien.dmi', loc = owner, icon_state = "burst_lie")
	owner.add_overlay(overlay)

	var/atom/xeno_loc = get_turf(owner)
	var/mob/living/carbon/alien/larva/new_xeno = new(xeno_loc)
	new_xeno.key = ghost.key
	new_xeno << sound('sound/voice/hiss5.ogg',0,0,0,100)	//To get the player's attention
	new_xeno.canmove = 0 //so we don't move during the bursting animation
	new_xeno.notransform = 1
	new_xeno.invisibility = INVISIBILITY_MAXIMUM
<<<<<<< HEAD
	new_xeno.set_hive_faction(hive_faction)
	growing = TRUE
	spawn(6)
		if(new_xeno)
			new_xeno.canmove = 1
			new_xeno.notransform = 0
			new_xeno.invisibility = 0
		if(gib_on_success)
			owner.gib(TRUE)
		else
			owner.adjustBruteLoss(40)
			owner.overlays -= overlay
		qdel(src)
=======

	sleep(6)

	if(QDELETED(src) || QDELETED(owner))
		return

	if(new_xeno)
		new_xeno.canmove = 1
		new_xeno.notransform = 0
		new_xeno.invisibility = 0

	if(gib_on_success)
		new_xeno.visible_message("<span class='danger'>[new_xeno] bursts out of [owner] in a shower of gore!</span>", "<span class='userdanger'>You exit [owner], your previous host.</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
		owner.gib(TRUE)
	else
		new_xeno.visible_message("<span class='danger'>[new_xeno] wriggles out of [owner]!</span>", "<span class='userdanger'>You exit [owner], your previous host.</span>")
		owner.adjustBruteLoss(40)
		owner.cut_overlay(overlay)
	qdel(src)
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc


/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Adds the infection image to all aliens for this embryo
----------------------------------------*/
/obj/item/organ/body_egg/alien_embryo/AddInfectionImages()
	for(var/mob/living/carbon/alien/alien in GLOB.player_list)
		if(alien.client)
			var/I = image('icons/mob/alien.dmi', loc = owner, icon_state = "infected[stage]")
			alien.client.images += I

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes all images from the mob infected by this embryo
----------------------------------------*/
/obj/item/organ/body_egg/alien_embryo/RemoveInfectionImages()
	for(var/mob/living/carbon/alien/alien in GLOB.player_list)
		if(alien.client)
			for(var/image/I in alien.client.images)
				if(dd_hasprefix_case(I.icon_state, "infected") && I.loc == owner)
					qdel(I)
