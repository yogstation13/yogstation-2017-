// hidden weapon defined inside of a xenomorph to mimic it's tail
// we don't exactly have a way to define mob bodyparts

/obj/item/weapon/xenomorphtail
	name = "their tail"
	desc = "A curious tail with a dagger sharp ail. It drags itself around the xenomorph picking up on anything that might be around it."
	force = 15
	hitsound = 'sound/xenomorph/xeno_tailwhip1.ogg'
	var/datum/reagent/chemical = null // will the tail inject a chemical into someone?
	var/chemregain // operates as a cooldown
	var/chemexcess = 15 // how many reagents are we going to pump into our target?
	var/chemcooldown = 500 // what's the cooldown

/obj/item/weapon/xenomorphtail/process()
	..()
	if(chemregain)
		if(world.time > chemregain)
			var/mob/living/L = loc
			L << "<span class='alien'>Your tail is ready to inject chemicals again...</span>"
			chemregain = 0

/obj/item/weapon/xenomorphtail/attack(mob/living/M, mob/user)
	..()
	if(M)
		if(ishuman(M))
			if(chemical)
				var/mob/living/carbon/human/H = M
				var/datum/reagent/tailreagent = new chemical
				H.reagents.add_reagent("[tailreagent.id]", chemexcess)
				user << "<span class='alien>You transfer [chemical] into [M].</span>"
				chemregain = world.time + chemcooldown
		hitsound = pick('sound/xenomorph/xeno_tailwhip1.ogg', 'sound/xenomorph/xeno_tailwhip2.ogg')

/obj/item/weapon/xenomorphtail/hunter
	force = 10
	chemical = /datum/reagent/toxin/xenotoxin

/obj/item/weapon/xenomorphtail/sentinel
	force = 20

/obj/item/weapon/xenomorphtail/drone
	force = 10
	chemical = /datum/reagent/toxin