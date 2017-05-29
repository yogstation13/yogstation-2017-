
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
		animals += SA

	var/mob/living/simple_animal/charm = input(H,"Charm","Charm",null) as anything in animals
	if(!charm)
		H << "<span class='noticevampire'>You decide not to charm any creatures.</span>"
		return

	if(!(istype(charm, /mob/living/simple_animal/hostile)))
		var/mob/living/simple_animal/hostile/mimic/copy/C
		C.check_obj = FALSE
		C = new(get_turf(H), charm, H, destroy_original = TRUE, eyes = FALSE)
		C.faction += "Vampire"
	else
		charm.faction += "Vampire"

	H << "<span class='noticevampire'>[charm] suddenly likes you more.</span>"