/mob/living/simple_animal/hostile/bat
	name = "Space Bat"
	desc = "A rare breed of bat which roosts in spaceships, probably not vampiric."
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	response_help = "brushes aside"
	response_disarm = "flails at"
	response_harm = "hits"
	speak_chance = 0
	maxHealth = 15
	health = 15
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attacktext = "bites"
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 1)
	pass_flags = PASSTABLE | PASSDOOR
	faction = list("hostile")
	attack_sound = 'sound/weapons/bite.ogg'
	environment_smash = 0
	ventcrawler = 2
	mob_size = MOB_SIZE_TINY
	flying = 1
	speak_emote = list("squeaks")
	var/max_co2 = 0 //to be removed once metastation map no longer use those for Sgt Araneus
	var/min_oxy = 0
	var/max_tox = 0


	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/bat/vampire
	desc = "A rare breed of bat which preys in spaceships. This one seems pretty vampiric."
	maxHealth = 200
	gold_core_spawnable = 0
	var/mob/living/carbon/human/vamp = null
	var/obj/effect/proc_holder/vampire/battrans/S = null

/mob/living/simple_animal/hostile/bat/vampire/verb/humanform()
	set category = "Vampire"
	set name = "Human Form"

	src << "<span class='noticevampire'>You return to a humanoid form.</span>"
	vamp.forceMove(loc)
	vamp.status_flags &= ~GODMODE
	mind.transfer_to(vamp)
	vamp.adjustBruteLoss(maxHealth - health)
	S.turnOnCD()
	S.vbat = null
	for(var/obj/effect/proc_holder/vampire/battrans/B in vamp.abilities)
		B.switchonCD(150)
	qdel(src)