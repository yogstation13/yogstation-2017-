
////////////////////
////////800/////////
////////////////////


/obj/effect/proc_holder/vampire/charm
	name = "Charm Creature"
	desc = "Make a creature hostile and on your side."
	req_bloodcount = 250
	action_icon_state = "animal_love"

/obj/effect/proc_holder/vampire/charm/fire(mob/living/carbon/human/H)
	if(!..())
		return

	var/list/animals = list()

	for(var/mob/living/simple_animal/SA in view(7, H))
		if(!("Vampire" in SA.faction))
			animals += SA

	var/mob/living/simple_animal/charm = input(H,"Charm","Charm",null) as anything in animals
	if(!charm)
		H << "<span class='noticevampire'>You decide not to charm any creatures.</span>"
		return

	if(charm.mind)
		charm << "<span class='warning'>You are now the thrall of the vampire [H]! Do his bidding, seek havoc on the station, and make sure they stay alive! If your master ever dies, and his body is burnt, dropping blood on his ashes will revive him.</span>"
		charm.mind.special_role = "Vampire Thrall"
	else
		if(!(istype(charm, /mob/living/simple_animal/hostile)))
			var/mob/living/simple_animal/hostile/mimic/copy/C = new(get_turf(H), charm, H, destroy_original = TRUE, eyes = FALSE)
			C.check_obj = FALSE

	charm.faction |= "Vampire"

	H << "<span class='noticevampire'>[charm] suddenly likes you more.</span>"
	feedback_add_details("vampire_powers","charm")
	return 1