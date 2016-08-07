/obj/item/weapon/pokeball
	name = "Pokeball"
	desc = "An advanced capsule made to capture pokemon, or your colleges"
	var/pokemon = null
	var/pokemon_out = null
	var/capturing = null
	var/captures_humans = 0

/obj/item/weapon/pokeball/attack(mob/living/M, mob/living/user)
	if (src.pokemon = null)
		if (src.captures_humans = 1 && M.has_dna())
			capturing(mob/living/M, mob/living/user)
		else if (M.has_dna())
			user << "The [src] seems to reject [M]"
		else
			capturing(mob/living/M, mob/living/user)


/obj/item/weapon/pokeball/proc/capturing(mob/living/carbon/human/user)
	if (M.stat = DEAD)
		user << "[M] is dead and cannot be caught"
			return
	if (M.caught = 1)
		user << "[M] has already been caught"
	else
		M = pokemon
		pokemon.loc = src







