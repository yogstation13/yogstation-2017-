/mob/living/carbon/brain/alien
	languages_spoken = ALIEN
	languages_understood = ALIEN
	//stat = CONSCIOUS

// This is to replace the previous datum/disease/alien_embryo for slightly improved handling and maintainability
// It functions almost identically (see code/datums/diseases/alien_embryo.dm)
var/const/ALIEN_AFK_BRACKET = 450 // 45 seconds

/obj/item/organ/body_egg/alien_embryo
	name = "alien embryo"
	icon = 'icons/mob/alien.dmi'
	icon_state = "larva0_dead"
	var/stage = 0
	var/colony
	var/mob/living/carbon/brain/alien/embryo
	var/premature
	var/polling = FALSE
	var/attemptinggrow = FALSE

/obj/item/organ/body_egg/alien_embryo/on_find(mob/living/finder)
	..()
	if(stage < 4)
		finder << "It's small and weak, barely the size of a foetus."
	else
		finder << "It's grown quite large, and writhes slightly as you look at it."
		if(prob(10))
			AttemptGrow(0)

// To stop clientless larva, we will check that our host has a client
// if we find no ghosts to become the alien. If the host has a client
// he will become the alien but if he doesn't then we will set the stage
// to 4, so we don't do a process heavy check everytime.

/obj/item/organ/body_egg/alien_embryo/New()
	..()
	embryo = new /mob/living/carbon/brain/alien(src)
//	if(findClient())
//		premature = TRUE

/obj/item/organ/body_egg/alien_embryo/proc/findClient() // returns 1 if we can't find anything
	if(polling)
		return
	if(embryo.ckey)
		return
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as an embryo growing inside of [owner]?", ROLE_ALIEN, null, ROLE_ALIEN, 100, embryo)
	var/client/C = null
	polling = TRUE

	sleep(100)
	if(candidates.len)
		listclearnulls(candidates)
		C = pick(candidates)
	else
		polling = FALSE
		return 1
	if(!owner)
		return
	if(!C.key || !C)
		return

	if(!embryo.key)
		embryo.key = C.key
		embryo << "<span class='alertalien'>Darkness surrounds you, and you grow bigger as you drain the nutrients out of your host. In time you'll soon be a fully grown...</span>"
		embryo << "<span class='alertalien'>For now you are only a fetush slowly regenerating...</span>"

/obj/item/organ/body_egg/alien_embryo/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 10)
	return S

/obj/item/organ/body_egg/alien_embryo/on_life()
	switch(stage)
		if(2, 3)
			if(prob(15))
				owner.emote("sneeze")
			if(prob(5))
				owner.emote("cough")
			if(prob(5))
				owner << "<span class='danger'>Your throat feels sore.</span>"
			if(prob(2))
				owner << "<span class='danger'>Mucous runs down the back of your throat.</span>"
		if(4)
			if(prob(15))
				owner.emote("sneeze")
			if(prob(15))
				owner.emote("cough")
			if(prob(30))
				owner << "<span class='danger'>Your muscles ache.</span>"
				if(prob(30))
					owner.take_organ_damage(1)
			if(prob(4))
				owner << "<span class='danger'>Your stomach hurts.</span>"
				if(prob(20))
					owner.adjustToxLoss(1)
		if(5)
			owner << "<span class='danger'>You feel something tearing its way out of your stomach...</span>"
			owner.adjustToxLoss(10)

	if(embryo)
		embryo.Sleeping(50)

/obj/item/organ/body_egg/alien_embryo/egg_process()
	if(stage < 5 && prob(3))
		stage++
		spawn(0)
			RefreshInfectionImage()

	if(stage == 5 && prob(50))
		for(var/datum/surgery/S in owner.surgeries)
			if(S.location == "chest" && istype(S.get_surgery_step(), /datum/surgery_step/manipulate_organs))
				AttemptGrow(0)
				return
		AttemptGrow()
/obj/item/organ/body_egg/alien_embryo/proc/join_infest_count()
	if(ticker.mode.queensuffix == colony)
		if(owner in ticker.mode.living_alien_targets)
			ticker.mode.message_xenomorphs("Your hive has successfully transformed another targetted human!", FALSE, "alienannounce")
			ticker.mode.infested_count++

/obj/item/organ/body_egg/alien_embryo/proc/AttemptGrow(gib_on_success = 1)

	if(attemptinggrow)
		return

	attemptinggrow = TRUE
	if(owner.stat == DEAD)
		if(embryo)
			embryo << "<span class='warning'>You see the light... and it BURNS!!! Your host has died.</span>"
		owner.visible_message("<span class='danger'>[owner]'s belly begins to swell up to an enormous rate, and pops as a dead \
						immature larva falls to the ground. It seems like it didn't gather enough living \
						nutrients to become a living larva.",\
						"<span class='danger'>[owner]'s belly begins to grow swollen, and pops as a dead \
						immature larva falls to the ground. It seems like it didn't gather enough living \
						nutrients to become a living larva.")
		log_game("[owner] ([owner.ckey]) was gibbed while dead because their alien embryo tried to grow.")
		var/mob/living/carbon/alien/larva/dead_xeno = new(get_turf(owner))
		owner.gib()
		join_infest_count()
		dead_xeno.adjustBruteLoss(300)
		dead_xeno.desc = "It seems swollen up, and immature. It's host must've died before it was released."
		dead_xeno.color = "#0A0000"
		attemptinggrow = FALSE
		return

	if(premature == TRUE)
		if(findClient()) // this proc returns 1 if the spot hasn't been filled.
			stage = 4 // Let's try again later.
			attemptinggrow = FALSE
			return
		else
			premature = FALSE
	if(embryo)
		embryo.SetSleeping(0)

	join_infest_count()

	var/overlay = image('icons/mob/alien.dmi', loc = owner, icon_state = "burst_lie")
	if(owner)
		owner.overlays += overlay

	var/atom/xeno_loc = get_turf(owner)
	var/mob/living/carbon/alien/larva/new_xeno = new(xeno_loc)
	if(embryo)
		if(embryo.key)
			new_xeno.key = embryo.key
		else
			if(owner)
				if(owner.ckey)
					new_xeno.ckey = owner.ckey

	if(!new_xeno.ckey)
		if(!polling)
			offer_control(new_xeno) // last option, ping all of the ghosts

	new_xeno << sound('sound/voice/hiss5.ogg',0,0,0,100)	//To get the player's attention
	new_xeno.canmove = 0 //so we don't move during the bursting animation
	new_xeno.notransform = 1
	new_xeno.invisibility = INVISIBILITY_MAXIMUM
	qdel(embryo)

	spawn(6)
		if(new_xeno)
			new_xeno.canmove = 1
			new_xeno.notransform = 0
			new_xeno.invisibility = 0
			new_xeno.HD = new(new_xeno)
			new_xeno.HD.colony_suffix = colony
			contact_queen()
		if(gib_on_success)
			owner.overlays -= overlay
			var/overlay2 = image('icons/mob/alien.dmi', loc = owner, icon_state = "bursted_lie")
			owner << "<span class='genesisred'>Your bloated stomach starts shaking!</span>"
			owner.ghostize(1)
			if(istype(owner, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = owner
				var/obj/item/bodypart/B1 = H.get_bodypart("chest")
				B1.take_damage(200)
				H.dna.species.specflags |= NOCLONE
				var/obj/item/bodypart/B2 = H.get_bodypart("head")
				var/obj/item/organ/brain/brain = locate() in B2
				if(brain)
					qdel(brain)
			else
				owner.adjustBruteLoss(200)
				owner.updatehealth()
			playsound(xeno_loc, "sound/effects/splat.ogg", 100, 1)
			owner.overlays += overlay2
		else
			owner.adjustBruteLoss(40)
			owner.overlays -= overlay
		qdel(src)

/obj/item/organ/body_egg/alien_embryo/proc/contact_queen()
	for(var/mob/living/carbon/alien/humanoid/royal/queen/Q in living_mob_list)
		if(compareAlienSuffix(Q, col2 = colony))
			Q << "<span class='alienminiannounce'>A new xenomorph was born in [get_area(src)]</span>"

/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Adds the infection image to all aliens for this embryo
----------------------------------------*/
/obj/item/organ/body_egg/alien_embryo/AddInfectionImages()
	for(var/mob/living/carbon/alien/alien in player_list)
		if(alien.client)
			var/I = image('icons/mob/alien.dmi', loc = owner, icon_state = "infected[stage]")
			alien.client.images += I

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes all images from the mob infected by this embryo
----------------------------------------*/
/obj/item/organ/body_egg/alien_embryo/RemoveInfectionImages()
	for(var/mob/living/carbon/alien/alien in player_list)
		if(alien.client)
			for(var/image/I in alien.client.images)
				if(dd_hasprefix_case(I.icon_state, "infected") && I.loc == owner)
					qdel(I)
