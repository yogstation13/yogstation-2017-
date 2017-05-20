/mob/living/carbon/alien/humanoid/worker
	name = "alien worker"
	caste = "d"
	maxHealth = 150
	health = 150
	icon_state = "aliend_s"
	tackle_chance = 3
	has_fine_manipulation = TRUE


/mob/living/carbon/alien/humanoid/worker/New()
	internal_organs += new /obj/item/organ/alien/plasmavessel/large
	internal_organs += new /obj/item/organ/alien/resinspinner
	internal_organs += new /obj/item/organ/alien/neurotoxinthroat/normal
	tail = new /obj/item/weapon/xenomorphtail/worker(src)

	AddAbility(new/obj/effect/proc_holder/alien/evolve(null))
	AddAbility(new /obj/effect/proc_holder/alien/sneak)
	..()

/mob/living/carbon/alien/humanoid/worker/movement_delay()
	. = ..()

/obj/effect/proc_holder/alien/evolve
	name = "Evolve to Praetorian"
	desc = "Praetorian"
	plasma_cost = 500

	action_icon_state = "alien_evolve_worker"

/obj/effect/proc_holder/alien/evolve/fire(mob/living/carbon/alien/humanoid/user)
	var/obj/item/organ/alien/hivenode/node = user.getorgan(/obj/item/organ/alien/hivenode)
	if(!node) //Players are Murphy's Law. We may not expect there to ever be a living xeno with no hivenode, but they _WILL_ make it happen.
		user << "<span class='danger'>Without the hivemind, you can't possibly hold the responsibility of leadership!</span>"
		return 0
	if(node.recent_queen_death)
		user << "<span class='danger'>Your thoughts are still too scattered to take up the position of leadership.</span>"
		return 0

	if(!isturf(user.loc))
		user << "<span class='notice'>You can't evolve here!</span>"
		return 0
	if(!alien_type_present(/mob/living/carbon/alien/humanoid/royal, user.hive_faction))
		var/mob/living/carbon/alien/humanoid/royal/praetorian/new_xeno = new (user.loc)
		user.alien_evolve(new_xeno)
		return 1
	else
		user << "<span class='notice'>We already have a living royal!</span>"
		return 0