/obj/effect/proc_holder/alien/hide
	name = "Hide"
	desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	plasma_cost = 0

	action_icon_state = "alien_hide"

/obj/effect/proc_holder/alien/hide/fire(mob/living/carbon/alien/user)
	if(user.stat != CONSCIOUS)
		return

	if (user.layer != ABOVE_NORMAL_TURF_LAYER)
		user.layer = ABOVE_NORMAL_TURF_LAYER
		user.visible_message("<span class='name'>[user] scurries to the ground!</span>", \
						"<span class='noticealien'>You are now hiding.</span>")
	else
		user.layer = MOB_LAYER
		user.visible_message("[user.] slowly peaks up from the ground...", \
					"<span class='noticealien'>You stop hiding.</span>")
	return 1


/obj/effect/proc_holder/alien/larva_evolve
	name = "Evolve"
	desc = "Evolve into a fully grown Alien."
	plasma_cost = 0

	action_icon_state = "alien_evolve_larva"

/obj/effect/proc_holder/alien/larva_evolve/fire(mob/living/carbon/alien/user)
	if(!islarva(user))
		return
	var/mob/living/carbon/alien/larva/L = user

	if(L.handcuffed || L.legcuffed)
		user << "<span class='danger'>You cannot evolve when you are cuffed.</span>"
		return

	if(L.amount_grown >= L.max_grown)
		L << "<span class='name'>You are growing into a beautiful alien! It is time to choose a caste.</span>"
		L << "<span class='info'>There are two to choose from:"
		L << "<span class='name'>Hunters</span> <span class='info'>are the most agile caste tasked with hunting for hosts. They are faster than a human and can even pounce, but are not much tougher than a drone.</span>"
		L << "<span class='name'>Workers</span> <span class='info'>are the support class of the hive. They are tasked with not only working to guarantee the hive sucess, but also guarding and holding off opponents.</span>"
		var/alien_caste = alert(L, "Please choose which alien caste you shall belong to.",,"Hunter","Worker")

		if(user.incapacitated()) //something happened to us while we were choosing.
			return

		if(!alien_caste)
			return

		var/registerAntag // whether we'll register this into the xenomorph mode or not.

		if(!L.HD)
			L.HD = new(L)

		if(L.HD.colony_suffix) // dirty checks, but hey what can you do
			var/mob/living/carbon/alien/humanoid/royal/queen/queen = ticker.mode.findQueen()
			if(queen)
				var/datum/huggerdatum/hd = queen.HD
				if(hd.hivebalance)
					registerAntag = TRUE
					var/decision = ticker.mode.checkHive()
					if(decision) // passing 0 equates to all
						user << "<span class='alertalien'>The hive has too many [alien_caste]'s!"
						switch(decision)
							if("worker")
								user << "<span class='alertalien'>You rapidly mutate into a worker!</span>"
								alien_caste = "Worker"
							if("hunter")
								user << "<span class='alertalien'>You rapidly mutate into a hunter!</span>"
								alien_caste = "Hunter"

		var/mob/living/carbon/alien/humanoid/new_xeno
		switch(alien_caste)
			if("Hunter")
				new_xeno = new /mob/living/carbon/alien/humanoid/hunter(L.loc)
			if("Worker")
				new_xeno = new /mob/living/carbon/alien/humanoid/worker(L.loc)

		if(registerAntag)
			var/datum/game_mode/xenomorph/X = ticker.mode
			X.AddXenomorph(new_xeno.mind)

		var/colonysuffix
		if(L.HD)
			if(L.HD.colony_suffix)
				colonysuffix = L.HD.colony_suffix

		new_xeno.HD = new/datum/huggerdatum()
		new_xeno.HD.colony_suffix = colonysuffix

		L.alien_evolve(new_xeno)
		var/obj/item/organ/alien/hivenode/H = new_xeno.getorganslot("hivenode")
		if(H)
			if(new_xeno)
				if(new_xeno.HD)
					if(new_xeno.HD.colony_suffix)
						H.csuffix = new_xeno.HD.colony_suffix
		return 0
	else
		user << "<span class='danger'>You are not fully grown.</span>"
		return 0