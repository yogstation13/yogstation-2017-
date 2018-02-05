/obj/item/weapon/shard
	name = "shard"
	desc = "A nasty looking shard of glass."
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	w_class = 1
	force = 5
	throwforce = 10
	item_state = "shard-glass"
	materials = list(MAT_GLASS=MINERAL_MATERIAL_AMOUNT)
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/cooldown = 0
	sharpness = IS_SHARP

/obj/item/weapon/shard/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is slitting \his wrists with the shard! It looks like \he's trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is slitting \his throat with the shard! It looks like \he's trying to commit suicide.</span>"))
	return (BRUTELOSS)


/obj/item/weapon/shard/New()
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)

/obj/item/weapon/shard/afterattack(atom/A as mob|obj, mob/user, proximity)
	if(!proximity || !(src in user))
		return
	if(isturf(A))
		return
	if(istype(A, /obj/item/weapon/storage))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!istype(H.gloves, /obj/item/clothing) && !(PIERCEIMMUNE in H.dna.species.specflags)) // golems, etc
			to_chat(H, "<span class='warning'>[src] cuts into your hand!</span>")
			var/organ = (H.hand ? "l_" : "r_") + "arm"
			var/obj/item/bodypart/affecting = H.get_bodypart(organ)
			if(affecting && affecting.take_damage(force / 2))
				H.update_damage_overlays(0)
	else if(ismonkey(user))
		var/mob/living/carbon/monkey/M = user
		to_chat(M, "<span class='warning'>[src] cuts into your hand!</span>")
		M.adjustBruteLoss(force / 2)


/obj/item/weapon/shard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I
		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/glass/NG = new (user.loc)
			for(var/obj/item/stack/sheet/glass/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
			to_chat(user, "<span class='notice'>You add the newly-formed material to the stack. It now contains [NG.amount] sheet\s.</span>")
			qdel(src)
	else
		return ..()

/obj/item/weapon/shard/Crossed(mob/AM)
	if(istype(AM) && has_gravity(loc))
		playsound(loc, 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(PIERCEIMMUNE in H.dna.species.specflags)
				return
			var/picked_def_zone = pick("l_leg", "r_leg")
			var/obj/item/bodypart/O = H.get_bodypart(picked_def_zone)
			if(!istype(O))
				return
			if(!H.shoes)
				H.apply_damage(5, BRUTE, picked_def_zone)
				H.Weaken(3)
				if(cooldown < world.time - 10) //cooldown to avoid message spam.
					H.visible_message("<span class='danger'>[H] steps in the broken glass!</span>", \
							"<span class='userdanger'>You step in the broken glass!</span>")
					cooldown = world.time


/obj/item/weapon/shard/shrapnel
	name = "shrapnel"
	icon_state = "shrapnellarge"
	desc = "A bunch of tiny bits of shattered metal."
	materials = list(MAT_IRON=MINERAL_MATERIAL_AMOUNT)

/obj/item/weapon/shard/shrapnel/New()
	..()
	src.icon_state = pick("shrapnellarge", "shrapnelmedium", "shrapnelsmall")
	return

/obj/item/weapon/shard/shrapnel/attackby(obj/item/I, mob/user, params)
	return ..()