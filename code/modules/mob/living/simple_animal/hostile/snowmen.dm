mob/living/simple_animal/snowman // changed to hostile by random event
	name = "snowman"
	desc = "It's made from snow! It must eat snowflakes for breakfast!"
	icon_state = "snowman"
	icon_living = "snowman"
	icon_dead = "snowman_dead"
	speak_chance = 0
	turns_per_move = 1
	maxHealth = 100
	health = 100
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	harm_intent_damage = 5
	melee_damage_lower = 3
	melee_damage_upper = 3
	//faction = list("snowman")
	attacktext = "thumps"
	attack_sound = 'sound/weapons/genhit.ogg'
	environment_smash = 0
	mouse_opacity = 1
	speed = 1
	ventcrawler = 2
	unique_name = 1
	speak_emote = list("bellows")
	deathmessage = "melts into the ground. A final smile glimishes from it's remains."


/mob/living/simple_animal/hostile/retaliate/snowman
	name = "snowman"
	desc = "It's made from snow! It must eat snowflakes for breakfast! It doesn't look impressed."
	icon_state = "snowman"
	icon_living = "snowman"
	icon_dead = "snowman_dead"
	turns_per_move = 5
	maxHealth = 30
	health = 30
	response_help = "sinks their finger into"
	response_disarm = "swats"
	response_harm = "whacks"
	melee_damage_lower = 1
	melee_damage_upper = 1
	faction = list("snowman")
	// and than all the stuff from the normal snow man
	attacktext = "thumps"
	attack_sound = 'sound/weapons/genhit.ogg'
	environment_smash = 0
	mouse_opacity = 1
	speed = 1
	ventcrawler = 2
	unique_name = 1
	speak_emote = list("bellows")
	deathmessage = "melts into the ground. Their frown officially upside down."