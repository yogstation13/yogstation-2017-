// Special objects for shuttle templates go here if nowhere else
// Bar staff, GODMODE mobs that just want to make sure people have drinks
// and a good time.

/mob/living/simple_animal/drone/snowflake/bardrone
	name = "Bardrone"
	desc = "A barkeeping drone, an indestructible robot built to tend bars."
	seeStatic = FALSE
	laws = "1. Serve drinks.\n\
		2. Talk to patrons.\n\
		3. Don't get messed up in their affairs."
	status_flags = list(GODMODE) // Please don't punch the barkeeper
	unique_name = FALSE // disables the (123) number suffix

/mob/living/simple_animal/drone/snowflake/bardrone/Initialize()
	. = ..()
	access_card.access |= GLOB.access_cent_bar
	grant_all_languages(omnitongue=TRUE)

/mob/living/simple_animal/hostile/alien/maid/barmaid
	gold_core_spawnable = 0
	name = "Barmaid"
	desc = "A barmaid, a maiden found in a bar."
	pass_flags = PASSTABLE
	status_flags = list(GODMODE)
	unique_name = FALSE
	AIStatus = AI_OFF
	stop_automated_movement = TRUE

/mob/living/simple_animal/hostile/alien/maid/barmaid/Initialize()
	. = ..()
	access_card = new /obj/item/weapon/card/id(src)
	var/datum/job/captain/C = new /datum/job/captain
	access_card.access = C.get_access()
	access_card.access |= GLOB.access_cent_bar
	access_card.flags |= NODROP

	grant_all_languages(omnitongue=TRUE)

/mob/living/simple_animal/hostile/alien/maid/barmaid/Destroy()
	qdel(access_card)
	. = ..()

// Bar table, a wooden table that kicks you in a direction if you're not
// barstaff (defined as someone who was a roundstart bartender or someone
// with CENTCOM_BARSTAFF)

/obj/structure/table/wood/bar
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags = NODECONSTRUCT
	obj_integrity = 1000
	max_integrity = 1000
	var/boot_dir = 1

/obj/structure/table/wood/bar/Crossed(atom/movable/AM)
	if(isliving(AM) && !is_barstaff(AM))
		// No climbing on the bar please
		var/mob/living/M = AM
		var/throwtarget = get_edge_target_turf(src, boot_dir)
		M.Weaken(2)
		M.throw_at(throwtarget, 5, 1,src)
		to_chat(M, "<span class='notice'>No climbing on the bar please.</span>")
	else
		. = ..()

/obj/structure/table/wood/bar/shuttleRotate(rotation)
	. = ..()
	boot_dir = angle2dir(rotation + dir2angle(boot_dir))

/obj/structure/table/wood/bar/proc/is_barstaff(mob/living/user)
	. = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind && H.mind.assigned_role == "Bartender")
			return TRUE

	var/obj/item/weapon/card/id/ID = user.get_idcard()
	if(ID && (GLOB.access_cent_bar in ID.access))
		return TRUE

//Luxury Shuttle Blockers

/obj/effect/forcefield/luxury_shuttle
	var/threshold = 500
	var/static/list/approved_passengers = list()

/obj/effect/forcefield/luxury_shuttle/CanPass(atom/movable/mover, turf/target, height=0)
	if(mover in approved_passengers)
		return 1

	if(!isliving(mover)) //No stowaways
		return 0

	var/total_cash = 0
	var/list/counted_money = list()

	for(var/obj/item/weapon/coin/C in mover.GetAllContents())
		total_cash += C.value
		counted_money += C
		if(total_cash >= threshold)
			break
	for(var/obj/item/stack/spacecash/S in mover.GetAllContents())
		total_cash += S.value * S.amount
		counted_money += S
		if(total_cash >= threshold)
			break

	if(total_cash >= threshold)
		for(var/obj/I in counted_money)
			qdel(I)

		to_chat(mover, "Thank you for your payment! Please enjoy your flight.")
		approved_passengers += mover
		return 1
	else
		to_chat(mover, "You don't have enough money to enter the main shuttle. You'll have to fly coach.")
		return 0

/mob/living/simple_animal/hostile/bear/fightpit
	name = "fight pit bear"
	desc = "This bear's trained through ancient Russian secrets to fear the walls of its glass prison."
	environment_smash = 0

/obj/effect/decal/hammerandsickle
	name = "hammer and sickle"
	desc = "Communism powerful force."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "communist"
	layer = ABOVE_OPEN_TURF_LAYER
	pixel_x = -32
	pixel_y = -32

/obj/effect/decal/hammerandsickle/shuttleRotate(rotation)
	setDir(angle2dir(rotation+dir2angle(dir))) // No parentcall, rest of the rotate code breaks the pixel offset.
