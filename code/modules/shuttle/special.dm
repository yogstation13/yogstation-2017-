// Special objects for shuttle templates go here if nowhere else

//Wabbajack statue has been moved to: code/game/gamemodes/wizard/artefact

// Bar staff, GODMODE mobs that just want to make sure people have drinks
// and a good time.

/mob/living/simple_animal/drone/snowflake/bardrone
	name = "Bardrone"
	desc = "A barkeeping drone, an indestructible robot built to tend bars."
	seeStatic = FALSE
	laws = "1. Serve drinks.\n\
		2. Talk to patrons.\n\
		3. Don't get messed up in their affairs."
	languages_spoken = ALL
	languages_understood = ALL
	status_flags = list(GODMODE) // Please don't punch the barkeeper
	unique_name = FALSE // disables the (123) number suffix

/mob/living/simple_animal/drone/snowflake/bardrone/New()
	. = ..()
	access_card.access |= access_cent_bar

/mob/living/simple_animal/hostile/alien/maid/barmaid
	gold_core_spawnable = 0
	name = "Barmaid"
	desc = "A barmaid, a maiden found in a bar."
	pass_flags = PASSTABLE
	status_flags = list(GODMODE)
	languages_spoken = ALL
	languages_understood = ALL
	unique_name = FALSE
	AIStatus = AI_OFF
	stop_automated_movement = TRUE

/mob/living/simple_animal/hostile/alien/maid/barmaid/New()
	. = ..()
	access_card = new /obj/item/weapon/card/id(src)
	var/datum/job/captain/C = new /datum/job/captain
	access_card.access = C.get_access()
	access_card.access |= access_cent_bar
	access_card.flags |= NODROP

/mob/living/simple_animal/hostile/alien/maid/barmaid/Destroy()
	qdel(access_card)
	. = ..()

// Bar table, a wooden table that kicks you in a direction if you're not
// barstaff (defined as someone who was a roundstart bartender or someone
// with CENTCOM_BARSTAFF)

/obj/structure/table/wood/bar
	burn_state = LAVA_PROOF
	flags = NODECONSTRUCT
	health = 1000
	var/boot_dir = 1

/obj/structure/table/wood/bar/Crossed(atom/movable/AM)
	if(isliving(AM) && !is_barstaff(AM))
		// No climbing on the bar please
		var/mob/living/M = AM
		var/throwtarget = get_edge_target_turf(src, boot_dir)
		M.Weaken(2)
		M.throw_at_fast(throwtarget, 5, 1,src)
		to_chat(M, "<span class='notice'>No climbing on the bar please.</span>")
	else
		. = ..()

/obj/structure/table/wood/bar/proc/is_barstaff(mob/living/user)
	. = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind && H.mind.assigned_role == "Bartender")
			return TRUE

	var/obj/item/weapon/card/id/ID = user.get_idcard()
	if(ID && (access_cent_bar in ID.access))
		return TRUE
