
////////////////////////////
////////////400/////////////
////////////////////////////

/obj/effect/proc_holder/vampire/shriek
	name = "Agonizing Shriek"
	desc = "Scream at incredibly high levels causing confusion and chaos. \
		At close range, will briefly stun someone."
	human_req = TRUE
	blood_cost = 25
	cooldownlen = 150
	action_icon_state = "vamp_scream"

/obj/effect/proc_holder/vampire/shriek/fire(mob/living/carbon/human/H)
	if(!..())
		return

	playsound(get_turf(H), 'sound/effects/creepyshriek.ogg', 100, extrarange = 21)
	H.visible_message("<span class='warning'>[H] releases a horrifying screech!</span>",\
		"<span class='warning'>[H] releases a horrifying screech!</span>")

	for(var/turf/T in view(7,H))
		for(var/mob/living/L in T)
			if(L == H)
				continue
			L.confused += 20
			if(get_dist(L, H) == (rand(1,2)))
				L.Stun(2)
				L.Weaken(2)
			if(ishuman(L))
				var/mob/living/carbon/human/human = L
				human.setEarDamage(human.ear_damage + (10 / max(min(get_dist(L, H), 5), 1)))
			if(issilicon(L))
				L.Weaken(4)
				playsound(L, 'sound/machines/warning-buzzer.ogg', 50, 1)

	for(var/obj/structure/window/R in view(7, H))
		R.take_damage(100)
	for(var/obj/structure/grille/G in view(7, H))
		if(prob(60))
			G.Break()
		else
			G.visible_message("<span class='warning'>[src] whips back and forth repelling the scream!</span>",\
					"<span class='warning'>[src] whips back and forth repelling the scream!</span>")
	for(var/obj/machinery/computer/C in view(7, H))
		C.take_damage(100)

	feedback_add_details("vampire_powers","vampire_scream")
	return 1


/obj/effect/proc_holder/vampire/batswarm
	name = "Bat Swarm"
	desc = "Summon a swarm of hostile bats to delay pursuers or cause chaos."
	human_req = TRUE
	blood_cost = 150
	cooldownlen = 400
	action_icon_state = "batswarm"

/obj/effect/proc_holder/vampire/batswarm/fire(mob/living/carbon/human/H)
	if(!..())
		return
	H.visible_message("<span class='warning'>[H] summons a swarm of bats!</span>")
	playsound(get_turf(H), 'sound/magic/Ethereal_Enter.ogg', 50, 1, -1)
	var/amount_to_spawn = 6
	for(var/i = 1, i <= amount_to_spawn, i++)
		var/mob/living/simple_animal/hostile/bat/B
		B = new /mob/living/simple_animal/hostile/bat(get_turf(B))
		B.faction |= "Vampire"
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(B, pick(NORTH,SOUTH,EAST,WEST))
	feedback_add_details("vampire_powers","bat swarm")