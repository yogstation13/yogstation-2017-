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

	if(L.handcuffed || L.legcuffed) // Cuffing larvas ? Eh ?
		user << "<span class='danger'>You cannot evolve when you are cuffed.</span>"

	if(L.amount_grown >= L.max_grown)	//TODO ~Carn
		L << "<span class='name'>You are growing into a beautiful alien! It is time to choose a caste.</span>"
		L << "<span class='info'>There are three to choose from:"
		L << "<span class='name'>Hunters</span> <span class='info'>are the most agile caste tasked with hunting for hosts. They are faster than a human and can even pounce, but are not much tougher than a drone.</span>"
		L << "<span class='name'>Sentinels</span> <span class='info'>are tasked with protecting the hive. With their ranged spit, invisibility, and high health, they make formidable guardians and acceptable secondhand hunters.</span>"
		L << "<span class='name'>Drones</span> <span class='info'>are the weakest and slowest of the castes, but can grow into the queen if there is none, and are vital to maintaining a hive with their resin secretion abilities.</span>"
		var/alien_caste = alert(L, "Please choose which alien caste you shall belong to.",,"Hunter","Sentinel","Drone")

		if(user.incapacitated()) //something happened to us while we were choosing.
			return

		if(!alien_caste)
			return

		var/registerAntag // whether we'll register this into the xenomorph mode or not.

		if(!L.HD)
			L.HD = new(L)

		if(L.HD.colony_suffix) // dirty checks, but hey what can you do
			message_admins("1")
			if(ticker && istype(ticker.mode, /datum/game_mode/xenomorph))
				message_admins("2")
				if(compareAlienSuffix(L, col2 = ticker.mode.queensuffix))
					message_admins("3")
					registerAntag = TRUE
					var/decision = ticker.mode.checkHive()

					if(decision) // passing 0 equates to all
						message_admins("4")
						user << "<span class='alertalien'>The hive has too many [alien_caste]'s!"
						switch(decision)
							if("drone")
								user << "<span class='alertalien'>You rapidly mutate into a drone!</span>"
								alien_caste = "Drone"

							if("senitel")
								user << "<span class='alertalien'>You rapidly mutate into a senitel!</span>"
								alien_caste = "Sentinel"

							if("hunter")
								user << "<span class='alertalien'>You rapidly mutate into a hunter!</span>"
								alien_caste = "Hunter"

		var/mob/living/carbon/alien/humanoid/new_xeno
		switch(alien_caste)
			if("Hunter")
				new_xeno = new /mob/living/carbon/alien/humanoid/hunter(L.loc)
			if("Sentinel")
				new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(L.loc)
			if("Drone")
				new_xeno = new /mob/living/carbon/alien/humanoid/drone(L.loc)

		L.alien_evolve(new_xeno)
		if(registerAntag)
			var/datum/game_mode/xenomorph/X = ticker.mode
			X.AddXenomorph(new_xeno.mind)

		var/obj/item/organ/alien/hivenode/H = new_xeno.getorganslot("hivenode")
		if(H)
			H.csuffix = new_xeno.HD.colony_suffix
		return 0
	else
		user << "<span class='danger'>You are not fully grown.</span>"
		return 0