/mob/living/carbon/death(gibbed)
	silent = 0
	losebreath = 0
	if(istype(LAssailant, /mob/living))
		var/mob/living/L = LAssailant
		if(mind && L.mind && LAssailant != src)
			L.mind.killstreak++
			L.mind.killstreak_act()
		
	..()

/mob/living/carbon/gib(no_brain, no_organs)
	for(var/mob/M in src)
		if(M in stomach_contents)
			stomach_contents.Remove(M)
		M.loc = loc
		visible_message("<span class='danger'>[M] bursts out of [src]!</span>")
	..()

/mob/living/carbon/spill_organs(no_brain)
	for(var/obj/item/organ/I in internal_organs)
		if(no_brain && istype(I, /obj/item/organ/brain))
			continue
		if(I)
			I.Remove(src)
			I.loc = get_turf(src)
			I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)