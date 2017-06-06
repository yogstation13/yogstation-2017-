/mob/living/simple_animal/hostile/lizard/minispider
	name = "spider"
	desc = "A bit smaller than the ones you're used to."
	icon_state = "mspider"
	icon_living = "mspider"
	speak_emote = list("chitters")
	health = 15
	maxHealth = 15
	faction = list("spiders")
	response_help  = "pats"
	response_harm   = "squashes"
	edibles = list(/mob/living/simple_animal/butterfly, /mob/living/simple_animal/cockroach, /mob/living/simple_animal/hostile/poison/bees, /mob/living/simple_animal/hostile/lizard, /obj/effect/spider/spiderling)
	var/size = 1
	var/list/poisons = list("toxin")
	var/poison = null
	del_on_death = 1

/mob/living/simple_animal/hostile/lizard/minispider/New()
	..()
	if(prob(50))
		icon_state = "mspider2"
		icon_living = "mspider2"
	poison = pick(poisons)

/mob/living/simple_animal/hostile/lizard/minispider/Crossed(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/A = AM
		if(A.mob_size > MOB_SIZE_SMALL)
			visible_message("<span class='notice'>[src] nimbly scampers away from [AM].</span>")

/mob/living/simple_animal/hostile/lizard/minispider/AttackingTarget()
	if(can_eat_thing(target) && target != src)
		visible_message("<span class='notice'>[src] devours [target]!</span>", "<span class='notice'>You devour [target]!</span>")
		qdel(target)
		LoseTarget()
		maxHealth++
		adjustBruteLoss(-5)
		transform *= 1.1
		size++
	else
		..()
		if(isliving(target))
			var/mob/living/T = target
			if(T.reagents)
				T.reagents.add_reagent(poison,size * 0.2)//the bigger the spider's gotten, the more poison it will inject

/mob/living/simple_animal/hostile/lizard/minispider/verb/Web()
	set name = "Lay Web"
	set category = "Spider"
	set desc = "Spin a harmless cobweb."

	var/T = loc
	if(stat == CONSCIOUS)
		visible_message("<span class='notice'>[src] begins to create a small web.</span>")
		if(do_after(src, 50, target = T))
			if(loc == T)
				new /obj/effect/decal/cleanable/cobweb(T)
				visible_message("<span class='notice'>[src] finishes its web. It looks pretty happy with itself.</span>", "<span class='notice'>You finish spinning the web.</span>")
