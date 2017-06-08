/obj/effect/proc_holder/vampire
	panel = "Vampire"
	name = "generic vampire"
	desc = "TALK TO A CODER IF YOU SEE THIS!"
	var/blood_cost = 0
	var/pay_blood_immediately = TRUE // will we take blood from the spell immediately?
	var/human_req = FALSE // does this spell require you to be human?


/obj/effect/proc_holder/vampire/proc/force_drainage(amt, var/datum/vampire/V)
	if(!amt)
		return

	if(!V)
		return

	V.bloodcount -= amt

/obj/effect/proc_holder/vampire/proc/fire(var/mob/living/carbon/human/H)
	if(ishuman(H))
		if(!checkbloodcost(H))
			return FALSE
	else
		if(human_req)
			return FALSE
	return TRUE

/obj/effect/proc_holder/vampire/proc/checkbloodcost(var/mob/living/carbon/human/H)
	if(blood_cost)
		if(H.mind.vampire)
			if(H.mind.vampire.bloodcount - blood_cost < 0)
				H << "<span class='alien'>You lack enough blood to perform this technique...</span>"
				return FALSE
			else
				return TRUE
		else
			return FALSE
	else
		return TRUE

/obj/effect/proc_holder/vampire/Click()
	if(!ishuman(usr))
		return TRUE

	var/mob/living/carbon/human/H = usr

	if(!H.mind.vampire)
		qdel(src)
		return 1

	if(!pay_blood_immediately)
		return 1

	if(H.mind.vampire.isDraining)
		return 1

	if(fire(H))
		force_drainage(blood_cost, H.mind.vampire)


/obj/effect/proc_holder/vampire/blooddrain
	name = "Blood Drainage"
	desc = "Retract your fangs, and stab them into your victims throat slowly draining the life out of them. Your intent controls the amount of blood and speed of the process."
	blood_cost = 5
	human_req = TRUE

/obj/effect/proc_holder/vampire/blooddrain/fire(var/mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/vampire = H.mind.vampire

	if(!H.pulling || !iscarbon(H.pulling))
		H << "<span class='alien'>To use this technique you will need to grab your victim!!</span>"
		return

	if(H.grab_state <= GRAB_NECK)
		H << "<span class='alien'>You must create a tighter grip on your victim!</span>"
		return

	var/mob/living/carbon/target = H.pulling
	var/delay
	var/drainamt
	var/draintime
	var/faint = FALSE
	var/drainstate

	for(var/v,v<6,v++)
		switch(v)
			if(1)
				H << "<span class='alien'>You draw close to [target] in prreperation.</span>"
				delay += 100
				if(!do_after(H, 100, target = src))
					H << "<span class='alien'>You draw back from [target].</span>"
					return

			if(2)
				H << "<span class='alien'>You plunge your fangs into [target]!</span>"
				delay = 50
				target.silent += 50
				vampire.isDraining = TRUE

			if(3)
				switch (H.a_intent)
					if(HELP)
						draintime += 50
						drainamt = 2

					if(DISARM || GRAB)
						faint = TRUE
						draintime += 100
						drainamt = 5

					if(HARM)
						draintime += 500
						drainamt = 10

				delay = draintime
				if(faint)
					target.Sleeping(100)
				H << "<span class='alien'>You feel the tricke of blood flow up your fangs...</span>"

			if(4)
				target.blood_volume -= drainamt
				vampire.gain_blood(drainamt)
				H << "<span class='warning'>You feel the craving of blood diminish as you suck more fluids out of the veins \
					of your target.</span>"

				if(drainstate != 5)
					v--
					drainstate++

			if(5)
				H << "<span class='warning'>You release [target] from your grip.</span>"
				delay = 0

		sleep(delay)


	return 1


/obj/effect/proc_holder/vampire/transform
	name = "Bat Transmutation"
	desc = "Shapeshift into a bat and fly at incredible speeds!"
	blood_cost = 30


/obj/effect/proc_holder/vampire/transform/fire(var/mob/living/carbon/human/H)
	if(!..())
		return

	var/datum/vampire/V = H.mind.vampire
	if(!V)
		return

	V.shapeshift()


/obj/effect/proc_holder/vampire/phantomjaunt
	name = "Phantom Jaunt"
	desc = "Transcend into the shadows while a swarm of bats sheilds you."
	blood_cost = 30


/obj/effect/proc_holder/vampire/phantomjaunt/fire(var/mob/living/carbon/H)
	if(!..())
		return
	playsound(H, 'sound/vampire/phantomjaunt.ogg', 100, 1)
	H.visible_message("<span class='alien'>[H] vanishes into the air!</span>")
	H.ExtinguishMob()
	var/list/nearbyturfs = list()

	for(var/turf/T in orange(8,H))
		nearbyturfs += T

	for(var/i = 0, i < 10, i++)
		var/turf/turf = pick(nearbyturfs)
		var/mob/living/simple_animal/hostile/retaliate/bat/ghoul/ghoul = new(turf)
		ghoul.loc = turf.loc

	var/turf/hturf = get_turf(H)
	var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt(hturf)
	H.loc = holder
	H.canmove = FALSE
	H.reset_perspective(holder)

	sleep(100)

	H.canmove = TRUE
	H.loc = holder.loc
	H.reset_perspective(null)
	qdel(holder)