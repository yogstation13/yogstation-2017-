/*
Note from Super3222:

Vampires are upcoming antagonists for Yogstation.
Most of the systems are meant to be less-advanced or hard on the player to encourage flexibility during gameplay.

Vampires have a lot of passives such as:
- Being able to see peoples organs, blood liters, and viruses through examining them.
- Having NOCRIT

Vampires also carry a few handy techniques.
- Having special abilities such as: Draining Blood, Transforming into a Bat, Jaunting


		- Draining Blood is simple. Requires an aggressive grab, and will slowly suck the life out
		of someone about five times. Intents are important while performing this technique because they will determine
		how much blood is going to be sucked, and in what time.

		HELP intent sucks a little blood, but does it fast.
		DISARM and GRAB intent are more mild, and will cause the target to sleep even further.
		HARM intent sucks out a lot of blood, but does it for a long time.

		- Transforming into a Bat: This will turn a vampires physical form into the shape of a bat. The ideal situation
		for this varies. There are drawbacks towards this technique, like how damage is collected into a variable and
		multiplied by 1/3. The outcome will be throwing all of the collected damage in the vampires face when they
		shapeshift back through force or their own will.

		Bats are naturally fast, do 10 brute damage, and have a 100 health.

		- Jaunting: Similar to a wizards jaunting, this will turn them invisible for a period of time. Howeve, a swarm of
		bats will also spawn during the jaunting, and will only dissapear when it ends. These bats will follow the user
		wherever he goes. However, they will retaliate if someone decides to upset one.


There are also some extra techniques that will probably not be added to regular Vampires, but will still be installed into
	the game.

	- Flitting: Instantenous jaunting which is EXTREMELY FAST, and has no bats. The downside is, you'll only be able to
	move while in the dark while flitting. Walking over a blessed turf will however, knock you down and set you on fire.
	Regardless, by the end of the flitting the vampire is knocked down.

	- Anything else that comes to mind, that doesn't fit the game, but could be added in for adminbuse.



Along with so many techniques and passive abilities, the vampires do have limits. Their main enemy is the Chaplain, and
	holy water.

	While Vampires are practically immortal, they cannot survive a cremation or regenerate back to life with holy water
		inside of their body.

	In fact, holy water will consistently recreate it'self while it's inside of the system of a dead vampire. Constantly
	setting the vampire on fire at the same time.

*/
#define GOOD_BLOOD_GAUGE 30
#define WEAK_BLOOD_GAUGE 15
#define BAD_BLOOD_GAUGE 0

/datum/vampire
	var/mob/living/carbon/human/vampire
	var/bloodcount = 100
	var/maxLumo = 6.1
	var/safeLumo = 3
	var/safestLumo = 0.1

	var/regenerationCost = 100

	var/isDraining
	var/mob/living/simple_animal/hostile/retaliate/bat/vampire/vampire_bat


/datum/vampire/New(var/mob/M)
	..()
	if(!M)
		return
	if(!ishuman(M))
		return
	vampire = M
	vampire.faction |= "spooky"
	vampire.status_flags |= NOCRIT
	welcomevampire()
	Life()


/datum/vampire/proc/welcomevampire()
	vampire << "<span class='alien'>You are a newborn vampire, creature of the night, watcher in the shadows, \
			remember that overtime you will occasionally grow a blood lust. If you do not take care of this \
			than the consequences can become dire.</span>"

	vampire << "<span class='alien'>You have three special abilities.</span>"

	vampire << "<span class='alien'>Your first ability is your Blood Drain: An innate skill for all vampires, \
			it allows us to feast on what we love the most. The most important thing to know is that your \
			intents do matter while using this move. At first it will require an aggressive grab, but while \
			it's preparing you can always change your intent to something else.</span>"

	vampire << "<span class='alien'>Your second ability is your Vampiric Transformation: You will shapeshift \
		into the form of an obviously vampiric bat. You will not only gain incredible speeds, but while in this state \
		you'll be very durable. Be careful because sustaining too much damage will backfire when you are later converted \
		back.</span>"

	vampire << "<span class='alien'>Your third ability is the Phantom Jaunt: When you have all of your rage and anger \
		pinpointed into one area, a storm of bats will follow you. Remember that while jaunting you will be moving at slow \
		speeds.</span>"


	vampire.AddAbility(new /obj/effect/proc_holder/vampire/blooddrain())
	vampire.AddAbility(new /obj/effect/proc_holder/vampire/transform())
	vampire.AddAbility(new /obj/effect/proc_holder/vampire/phantomjaunt())


/datum/vampire/proc/Life()
	if(vampire.stat == DEAD)
		begin_regneration_cycle()
		message_admins("0")
		return

	message_admins("1")

	var/cooldown = 50
	var/blooddrain = 1

	if(isturf(vampire.loc))
		var/turf/T = vampire.loc
		if(T.lighting_lumcount)
			message_admins("2")
			switch(T.lighting_lumcount)
				if(safestLumo to safeLumo)
					blooddrain -= 1
					message_admins("3")
				if(maxLumo to INFINITY)
					blooddrain += 3
					cooldown -= 15
					message_admins("4")
		else
			blooddrain -= 1
			message_admins("5")

	bloodcount -= blooddrain
	addtimer(src, "Life", cooldown, FALSE)
	message_admins("6")


/datum/vampire/proc/begin_regneration_cycle()
	if(vampire.reagents.has_reagent("holywater"))
		vampire.IgniteMob()
		vampire.adjust_fire_stacks(3)
		vampire.reagents.add_reagent("holywater", 5)
		vampire << "<span class='alien>THEEE IS HOLY WATER CIRCULATING IN YOUR BLOOD! IT BURNS!!!</span>"
		message_admins("waat")
		return

	var/cooldown = 1000

	if(regenerationCost)
		if(bloodcount - 10 > 0)
			regenerationCost -= 10
			bloodcount -= 10
			vampire << "<span class='alien>You are heading towards a speedy recovery.</span>"

		else
			regenerationCost -= 10
			cooldown += 1000
			vampire << "<span class='alien'>You drift slowly towards recovery, but your body tears away because it's too \
					weak from blood loss!</span>"


	if(!regenerationCost)
		regenerate()
		return

	addtimer(src, "begin_regeneration_cycle", cooldown)


/datum/vampire/proc/regenerate()
	vampire.setToxLoss(0)
	vampire.setOxyLoss(0)
	vampire.setCloneLoss(0)
	vampire.SetParalysis(0)
	vampire.SetStunned(0)
	vampire.SetWeakened(0)
	vampire.radiation = 0
	vampire.heal_overall_damage(vampire.getBruteLoss(), vampire.getFireLoss())
	vampire.reagents.clear_reagents()
	vampire.restore_blood()
	vampire.remove_all_embedded_objects()
	vampire.grab_ghost(force = TRUE)

	vampire << "<span class='alien'>You have awoken from your slumber as strong as before. Your thirst reawakens excitedly. \
				You crave for more blood!</span>"
	bloodcount = 50
	regenerationCost = 100
	Life()

/datum/vampire/proc/gain_blood(amt, overlimit = FALSE)
	if(!overlimit)
		var/cap = 100
		if(bloodcount + amt > cap)
			return 1
	bloodcount += amt

/datum/vampire/proc/shapeshift()
	if(ishuman(vampire))
		var/turf/T = get_turf(vampire)
		var/mob/living/simple_animal/hostile/retaliate/bat/vampire/bat = new(T.loc)
		vampire.status_flags |= GODMODE
		vampire.loc = bat
		vampire.mind.transfer_to(bat)

	if(isvampirebat(vampire))
		var/mob/living/simple_animal/hostile/retaliate/bat/vampire/V = vampire
		var/mob/living/carbon/C

		for(var/mob/living/carbon/M in V)
			if(M.mind.vampire)
				C = M
				break

		C.loc = vampire.loc
		vampire.status_flags -= GODMODE
		vampire.mind.transfer_to(C)
		C.adjustBruteLoss(V.collectedDamage)
		qdel(V)


/mob/living/carbon/human/verb/vampire()
	if(mind)
		mind.vampire = new(src)

	src << "<span class='warning'.It worked!!!!</span>"