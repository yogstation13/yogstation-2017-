/obj/item/organ/alien
	origin_tech = "biotech=5"
	icon_state = "xgibmid2"
	var/list/alien_powers = list()
	var/hive_faction

/obj/item/organ/alien/New()
	for(var/A in alien_powers)
		if(ispath(A))
			alien_powers -= A
			alien_powers += new A(src)
	..()

/obj/item/organ/alien/Insert(mob/living/carbon/M, special = 0)
	if(..())
		for(var/obj/effect/proc_holder/alien/P in alien_powers)
			M.AddAbility(P)
		if(isalien(M))
			var/mob/living/carbon/alien/A = M
			hive_faction = A.hive_faction
		return 1

/obj/item/organ/alien/Remove(mob/living/carbon/M, special = 0, del_after = 0)
	for(var/obj/effect/proc_holder/alien/P in alien_powers)
		M.RemoveAbility(P)
	..()

/obj/item/organ/alien/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 10)
	return S


/obj/item/organ/alien/plasmavessel
	name = "plasma vessel"
	icon_state = "plasma"
	origin_tech = "biotech=5;plasmatech=4"
	w_class = 3
	zone = "neck"
	slot = "plasmavessel"
	alien_powers = list(/obj/effect/proc_holder/alien/plant, /obj/effect/proc_holder/alien/transfer)

	var/storedPlasma = 100
	var/max_plasma = 250
	var/heal_rate = 5
	var/plasma_rate = 10
	var/regen_rate

/obj/effect/proc_holder/alien/plant
	name = "Plant Weeds"
	desc = "Plants some alien weeds"
	plasma_cost = 50
	check_turf = 1
	action_icon_state = "alien_plant"

/obj/effect/proc_holder/alien/plant/fire(mob/living/carbon/user)
	if(locate(/obj/structure/alien/weeds) in get_turf(user))
		src << "There's already a weed node here."
		return 0
	user.visible_message("<span class='alertalien'>[user] has planted some alien weeds!</span>")
	new/obj/structure/alien/weeds/node(user.loc, null, 1)
	return 1




/obj/item/organ/alien/plasmavessel/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("plasma", storedPlasma/10)
	return S

/obj/item/organ/alien/plasmavessel/large
	name = "large plasma vessel"
	icon_state = "plasma_large"
	w_class = 4
	storedPlasma = 200
	max_plasma = 500
	plasma_rate = 15

/obj/item/organ/alien/plasmavessel/large/queen
	origin_tech = "biotech=6;plasmatech=4"
	plasma_rate = 20
	regen_rate = 2

/obj/item/organ/alien/plasmavessel/small
	name = "small plasma vessel"
	icon_state = "plasma_small"
	w_class = 2
	storedPlasma = 100
	max_plasma = 150
	plasma_rate = 5

/obj/item/organ/alien/plasmavessel/small/tiny
	name = "tiny plasma vessel"
	icon_state = "plasma_tiny"
	w_class = 1
	max_plasma = 100
	alien_powers = list(/obj/effect/proc_holder/alien/transfer)

/obj/item/organ/alien/plasmavessel/on_life()
	//If there are alien weeds on the ground then heal if needed or give some plasma
	if(locate(/obj/structure/alien/weeds) in owner.loc)
		if(owner.health >= owner.maxHealth)
			owner.adjustPlasma(plasma_rate)
		else
			var/heal_amt = heal_rate
			if(!isalien(owner))
				heal_amt *= 0.2
			owner.adjustPlasma(plasma_rate*0.5)
			owner.adjustBruteLoss(-heal_amt)
			owner.adjustFireLoss(-heal_amt)
			owner.adjustOxyLoss(-heal_amt)
			owner.adjustCloneLoss(-heal_amt)
			owner.adjust_eye_damage(-heal_amt)

	if(regen_rate)
		owner.adjustPlasma(regen_rate)

/obj/item/organ/alien/plasmavessel/Insert(mob/living/carbon/M, special = 0)
	if(..())
		if(isalien(M))
			var/mob/living/carbon/alien/A = M
			A.updatePlasmaDisplay()
		return 1

/obj/item/organ/alien/plasmavessel/Remove(mob/living/carbon/M, special = 0)
	..()
	if(isalien(M))
		var/mob/living/carbon/alien/A = M
		A.updatePlasmaDisplay()


/obj/item/organ/alien/hivenode
	name = "hive node"
	icon_state = "hivenode"
	zone = "head"
	slot = "hivenode"
	origin_tech = "biotech=5;magnets=4;bluespace=3"
	w_class = 1
	var/recent_queen_death = 0 //Indicates if the queen died recently, aliens are heavily weakened while this is active.
	alien_powers = list(/obj/effect/proc_holder/alien/whisper)
	var/csuffix

/obj/item/organ/alien/hivenode/Insert(mob/living/carbon/M, special = 0)
	if(..())
		M.faction |= "alien"
		return 1

/obj/item/organ/alien/hivenode/Remove(mob/living/carbon/M, special = 0)
	M.faction -= "alien"
	..()

//When the alien queen dies, all aliens suffer a penalty as punishment for failing to protect her.
/obj/item/organ/alien/hivenode/proc/queen_death()
	if(!owner|| owner.stat == DEAD)
		return
	if(isalien(owner)) //Different effects for aliens than humans
		owner << "<span class='userdanger'>Your Queen has been struck down!</span>"
		owner << "<span class='danger'>You are struck with overwhelming agony! You feel confused, and your connection to the hivemind is severed."
		owner.emote("roar")
		owner.Stun(10) //Actually just slows them down a bit.

	else if(ishuman(owner)) //Humans, being more fragile, are more overwhelmed by the mental backlash.
		owner << "<span class='danger'>You feel a splitting pain in your head, and are struck with a wave of nausea. You cannot hear the hivemind anymore!"
		owner.emote("scream")
		owner.Weaken(5)

	owner.jitteriness += 30
	owner.confused += 30
	owner.stuttering += 30

	recent_queen_death = 1
	owner.throw_alert("alien_noqueen", /obj/screen/alert/alien_vulnerable)
	spawn(2400) //four minutes
		if(qdeleted(src)) //In case the node is deleted
			return
		recent_queen_death = 0
		if(!owner) //In case the xeno is butchered or subjected to surgery after death.
			return
		owner << "<span class='noticealien'>The pain of the queen's death is easing. You begin to hear the hivemind again.</span>"
		owner.clear_alert("alien_noqueen")


/obj/item/organ/alien/resinspinner
	name = "resin spinner"
	icon_state = "stomach-x"
	zone = "mouth"
	slot = "resinspinner"
	origin_tech = "biotech=5;materials=4"
	alien_powers = list(/obj/effect/proc_holder/alien/resin)

/obj/item/organ/alien/eggsac
	name = "egg sac"
	icon_state = "eggsac"
	zone = "groin"
	slot = "eggsac"
	w_class = 4
	origin_tech = "biotech=6"
	alien_powers = list(/obj/effect/proc_holder/alien/lay_egg)

/obj/item/organ/alien/neurotoxinthroat
	name = "xenomorphic throat canal"
	icon_state = "plasma"
	origin_tech = "biotech=6;plasmatech=5"
	w_class = 5
	zone = "neck"
	slot = "throatcanal"
	alien_powers = list(/obj/effect/proc_holder/alien/coughneuro, /obj/effect/proc_holder/alien/neurotoxin)
	var/neurotoxinStorage = 0
	var/neurotoxinStorageLimit
	var/ache

/obj/item/organ/alien/neurotoxinthroat/process()
	if(!owner)
		return

	if(neurotoxinStorage)
		if(prob(25))
			drool()
		if(neurotoxinStorage == neurotoxinStorageLimit)
			drool()

/obj/item/organ/alien/neurotoxinthroat/proc/drool()
	if(!owner)
		return

	new /obj/effect/decal/cleanable/xenodrool(get_turf(owner))

/obj/item/organ/alien/neurotoxinthroat/proc/start_ache()
	ache = TRUE
	addtimer(src.loc, "stop_ache", 1000)

/obj/item/organ/alien/neurotoxinthroat/proc/stop_ache()
	ache = FALSE

///obj/item/organ/alien/neurotoxinthroat/Insert(mob/living/carbon/M)
//	..()
//	stat("Throat Canal Storage:", "[neurotoxinStorage]/[neurotoxinStorageLimit]")

/obj/item/organ/alien/neurotoxinthroat/frail
	name = "weak xenomorphic throat canal"
	origin_tech = "biotech=3;plasmatech=5"
	neurotoxinStorageLimit = 5

/obj/item/organ/alien/neurotoxinthroat/normal
	origin_tech = "biotech=3;plasmatech=5"
	neurotoxinStorageLimit = 15

/obj/item/organ/alien/neurotoxinthroat/strong
	name = "strong xenomorphic throat canal"
	origin_tech = "biotech=7;plasmatech=8"
	neurotoxinStorageLimit = 25