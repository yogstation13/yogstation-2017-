/mob/living/carbon/alien/humanoid/royal
	//Common stuffs for Praetorian and Queen
	icon = 'icons/mob/alienqueen.dmi'
	status_flags = list()
	ventcrawler = 0 //pull over that ass too fat
	unique_name = 0
	pixel_x = -16
	bubble_icon = "alienroyal"
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER //above most mobs, but below speechbubbles
	pressure_resistance = 200 //Because big, stompy xenos should not be blown around like paper.
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 20, /obj/item/stack/sheet/animalhide/xeno = 3)
	tackle_chance = 5

	var/alt_inhands_file = 'icons/mob/alienqueen.dmi'

/mob/living/carbon/alien/humanoid/royal/can_inject()
	return 0

/mob/living/carbon/alien/humanoid/royal/queen
	name = "alien queen"
	caste = "q"
	maxHealth = 400
	health = 400
	icon_state = "alienq"


/mob/living/carbon/alien/humanoid/royal/queen/New()
	//there should only be one queen
	for(var/mob/living/carbon/alien/humanoid/royal/queen/Q in living_mob_list)
		if(Q == src)
			continue
		if(Q.stat == DEAD)
			continue
		if(Q.client)
			name = "alien princess ([rand(1, 999)])"	//if this is too cutesy feel free to change it/remove it.
			break

	real_name = src.name
	HD = new /datum/huggerdatum/queen
	HD.assemble(src)

	internal_organs += new /obj/item/organ/alien/plasmavessel/large/queen
	internal_organs += new /obj/item/organ/alien/resinspinner
	internal_organs += new /obj/item/organ/alien/neurotoxinthroat/strong
	internal_organs += new /obj/item/organ/alien/eggsac
	AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/repulse/xeno(src))
	AddAbility(new/obj/effect/proc_holder/alien/royal/queen/promote())
	AddAbility(new/obj/effect/proc_holder/alien/royal/queen/directobjective())
	AddAbility(new/obj/effect/proc_holder/alien/royal/queen/globalobjective())
	..()

/mob/living/carbon/alien/humanoid/royal/queen/movement_delay()
	. = ..()
	. += 3

//Queen verbs
/obj/effect/proc_holder/alien/lay_egg
	name = "Lay Egg"
	desc = "Lay an egg to produce huggers to impregnate prey with."
	plasma_cost = 75
	check_turf = 1
	action_icon_state = "alien_egg"

/obj/effect/proc_holder/alien/lay_egg/fire(mob/living/carbon/user)
	if(locate(/obj/structure/alien/egg) in get_turf(user))
		user << "There's already an egg here."
		return 0
	user.visible_message("<span class='alertalien'>[user] has laid an egg!</span>")
	var/grabbedcosuff
	if(isalien(user))
		var/mob/living/carbon/alien/A = user
		grabbedcosuff = A.HD.colony_suffix

	new /obj/structure/alien/egg(user.loc, suffix = grabbedcosuff)
	return 1

//Button to let queen choose her praetorian.
/obj/effect/proc_holder/alien/royal/queen/promote
	name = "Create Royal Parasite"
	desc = "Produce a royal parasite to grant one of your children the honor of being your Praetorian."
	plasma_cost = 500 //Plasma cost used on promotion, not spawning the parasite.

	action_icon_state = "alien_queen_promote"



/obj/effect/proc_holder/alien/royal/queen/promote/fire(mob/living/carbon/alien/user)
	var/obj/item/queenpromote/prom
	if(alien_type_present(/mob/living/carbon/alien/humanoid/royal/praetorian/))
		user << "<span class='noticealien'>You already have a Praetorian!</span>"
		return 0
	else
		for(prom in user)
			user << "<span class='noticealien'>You discard [prom].</span>"
			qdel(prom)
			return 0

		prom = new (user.loc)
		if(!user.put_in_active_hand(prom, 1))
			user << "<span class='warning'>You must empty your hands before preparing the parasite.</span>"
			return 0
		else //Just in case telling the player only once is not enough!
			user << "<span class='noticealien'>Use the royal parasite on one of your children to promote her to Praetorian!</span>"
	return 0


/obj/item/queenpromote
	name = "\improper royal parasite"
	desc = "Inject this into one of your grown children to promote her to a Praetorian!"
	icon_state = "alien_medal"
	flags = ABSTRACT|NODROP
	icon = 'icons/mob/alien.dmi'

/obj/item/queenpromote/attack(mob/living/M, mob/living/carbon/alien/humanoid/user)
	if(!isalienadult(M) || istype(M, /mob/living/carbon/alien/humanoid/royal))
		user << "<span class='noticealien'>You may only use this with your adult, non-royal children!</span>"
		return
	if(alien_type_present(/mob/living/carbon/alien/humanoid/royal/praetorian/))
		user << "<span class='noticealien'>You already have a Praetorian!</span>"
		return

	var/mob/living/carbon/alien/humanoid/A = M
	if(A.stat == CONSCIOUS && A.mind && A.key)
		if(!user.usePlasma(500))
			user << "<span class='noticealien'>You must have 500 plasma stored to use this!</span>"
			return

		A << "<span class='noticealien'>The queen has granted you a promotion to Praetorian!</span>"
		user.visible_message("<span class='alertalien'>[A] begins to expand, twist and contort!</span>")
		var/mob/living/carbon/alien/humanoid/royal/praetorian/new_prae = new (A.loc)
		A.mind.transfer_to(new_prae)
		qdel(A)
		qdel(src)
		return
	else
		user << "<span class='warning'>This child must be alert and responsive to become a Praetorian!</span>"

/obj/item/queenpromote/attack_self(mob/user)
	user << "<span class='noticealien'>You discard [src].</span>"
	qdel(src)

/obj/effect/proc_holder/alien/royal/queen/directobjective
	name = "Direct Objective"
	desc = "Give a xenomorph nearbly an objective."
	plasma_cost = 0
	action_icon_state =  "direct-order"

/obj/effect/proc_holder/alien/royal/queen/directobjective/fire(mob/living/carbon/alien/user)
	var/list/xenomorphs = list()
	xenomorphs += "None"
	for(var/mob/living/carbon/alien/humanoid/H in viewers(7,user))
		if(compareAlienSuffix(user, H))
			xenomorphs += H

	var/mob/living/carbon/alien/humanoid/chosenxeno = input(user,"Choose a xenomorph",null) as anything in xenomorphs
	if(!chosenxeno || chosenxeno == "None")
		user << "<span class='warning'>You chose not to give out another objective.</span>"
		return
	var/objective = stripped_input(user, "Print out a message", "Create an objective")

	if(!objective)
		return

	user << "<span class='noticealien'>You give [chosenxeno.name] the objective <span class='alertalien'>[objective].</span></span>"
	chosenxeno << "<span class='alertalien'>Your queen has given you the objective:</span> <span class='alertalien'>[objective]</span> <span class='noticealien'>(Use the alert at the top right of your screen to see it as well.)</span>"
	var/obj/screen/alert/alien_objective/A = chosenxeno.alerts["alienobjective"]
	if(A)
		A.desc = objective
		playsound(chosenxeno.loc, 'sound/voice/hiss5.ogg', 50, 1, 1)
	return 1

/obj/effect/proc_holder/alien/royal/queen/globalobjective
	name = "Global Objective"
	desc = "Sends a new objective to every single xenomorph.."
	plasma_cost = 10
	action_icon_state = "global-order"

/obj/effect/proc_holder/alien/royal/queen/globalobjective/fire(mob/living/carbon/alien/user)
	var/objective = stripped_input(user, "What objective do you want to give to your xenomorphs?", "Choose a Global Objective")
	if(!objective)
		return

	for(var/mob/living/carbon/alien/humanoid/H in living_mob_list)
		if(compareAlienSuffix(user, H))
			var/obj/screen/alert/alien_objective/A = H.alerts["alienobjective"]
			if(A)
				A.desc = objective
				H << 'sound/voice/hiss5.ogg'
				H << "<span class='aliensmallannounce'>New Objective!</span><span class='notice'>(Check the alert at the top right corner)</span>"

	user << "<span class='alertalien'>Your Colony's Currrent Objective:</span> <span class='notice'>[objective]</span>"
	return 1