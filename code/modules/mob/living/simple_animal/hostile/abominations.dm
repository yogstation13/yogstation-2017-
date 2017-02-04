/mob/living/simple_animal/hostile/abomination
	name = "abomination"
	desc = "A groveling, hulking beast. Another failed experiment from those terror ship abductors. What exactly were they trying to make?"
	speak_emote = list("haunts")
	icon = 'icons/mob/human.dmi'
	icon_state = "abomination_s"
	icon_living = "abomination_s"
	icon_dead = "husk_plant_dead"
	health = 300
	maxHealth = 300
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = list("abomination")
	speak_emote = list("screams")
	gold_core_spawnable = FALSE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	weather_immunities = list("ash")

/mob/living/simple_animal/hostile/abomination/super
	desc = "A groveling, hulking beast. This one seems agile."
	health = 250
	maxHealth = 250
	var/obj/effect/proc_holder/spell/aoe_turf/abomination/screech/scream = null
	var/screamCD

/mob/living/simple_animal/hostile/abomination/super/New()
	..()
	scream = new /obj/effect/proc_holder/spell/aoe_turf/abomination/screech
	scream.human_req = 0
	AddSpell(scream)

/mob/living/simple_animal/hostile/abomination/super/handle_automated_action()
	. = ..()
	if(target)
		if(screamCD < world.time)
			visible_message("[src] grows a wicked smile before dropping their jaw and inhaling.")
			scream.choose_targets(src)
			screamCD = world.time + 1000