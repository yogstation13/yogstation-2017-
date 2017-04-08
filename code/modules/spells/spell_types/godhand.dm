/obj/item/weapon/melee/touch_attack
	name = "\improper outstretched hand"
	desc = "High Five?"
	var/catchphrase = "High Five!"
	var/on_use_sound = null
	var/obj/effect/proc_holder/spell/targeted/touch/attached_spell
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	item_state = null
	flags = ABSTRACT | NODROP | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0

/obj/item/weapon/melee/touch_attack/New(var/spell)
	attached_spell = spell
	..()

/obj/item/weapon/melee/touch_attack/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(user.lying || user.handcuffed)
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	..()

/obj/item/weapon/melee/touch_attack/afterattack(atom/target, mob/user, proximity)
	user.say(catchphrase)
	playsound(get_turf(user), on_use_sound,50,1)
	if(attached_spell)
		attached_spell.attached_hand = null
	qdel(src)

/obj/item/weapon/melee/touch_attack/Destroy()
	if(attached_spell)
		attached_spell.attached_hand = null
	return ..()

/obj/item/weapon/melee/touch_attack/disintegrate
	name = "\improper disintegrating touch"
	desc = "This hand of mine glows with an awesome power!"
	catchphrase = "EI NATH!!"
	on_use_sound = 'sound/magic/Disintegrate.ogg'
	icon_state = "disintegrate"
	item_state = "disintegrate"

/obj/item/weapon/melee/touch_attack/disintegrate/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !ismob(target) || !iscarbon(user) || user.lying || user.handcuffed) //exploding after touching yourself would be bad
		return
	var/mob/living/M = target
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(4, 0, M.loc) //no idea what the 0 is
	sparks.start()
	if(M.stat == DEAD)
		M.gib()
	else
		M.death()
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/bodypart/B in H.bodyparts)
				if(B.body_zone != "head" && B.body_zone != "chest")
					B.dismember()
	..()

/obj/item/weapon/melee/touch_attack/fleshtostone
	name = "\improper petrifying touch"
	desc = "That's the bottom line, because flesh to stone said so!"
	catchphrase = "STAUN EI!!"
	on_use_sound = 'sound/magic/FleshToStone.ogg'
	icon_state = "fleshtostone"
	item_state = "fleshtostone"

/obj/item/weapon/melee/touch_attack/fleshtostone/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user) || user.lying || user.handcuffed) //getting hard after touching yourself would also be bad
		return
	if(user.lying || user.handcuffed)
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	var/mob/living/M = target
	M.Stun(2)
	M.petrify()
	..()

/obj/item/weapon/melee/touch_attack/bless
	name = "\improper bless"
	desc = "Hallelujah!"
	catchphrase = ""
	on_use_sound = "sound/effects/pray.ogg"
	icon_state = "bless"
	item_state = "bless"

/obj/item/weapon/melee/touch_attack/bless/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(user.lying || user.handcuffed)
		return
	if(isitem(target))
		PoolOrNew(/obj/effect/overlay/temp/bless, target.loc)
		user.visible_message("<span class='notice'>[user] blesses [target]!</span>")
		if(!cmptext("blessed",copytext(target.name,1,8)))
			target.name = "blessed [target.name]"
			..()
			return
		..()
		return
	if(iscarbon(target))
		PoolOrNew(/obj/effect/overlay/temp/bless, target.loc)
		user.visible_message("<span class= 'notice'>[user] blesses [target]!</span>")
		..()
		return

/obj/item/weapon/melee/touch_attack/nothing
	name = "nothing"
	catchphrase = "..."
	desc = "There's nothing there"
	icon_state = "nothing"
	item_state = "nothing"
	var/uses = 3
	var/list/things = list()
	var/list/blacklist = list (
						/obj/item/weapon/bombcore,
						/obj/item/weapon/reagent_containers/food/snacks/grown/cherry_bomb,
						/obj/item/weapon/grenade,
						/obj/machinery/nuclearbomb/selfdestruct,
						/obj/item/weapon/gun/,
						/obj/item/weapon/disk/nuclear,
						/obj/item/weapon/storage,
						/obj/structure/closet,
						/obj/item/device/transfer_valve
						)
	var/useblacklist = FALSE

/obj/item/weapon/melee/touch_attack/nothing/Destroy()
	for(var/obj/O in things)
		if(!O.alpha)
			reverttarget(O)
	..()

/obj/item/weapon/melee/touch_attack/nothing/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(user.lying || user.handcuffed)
		return
	if(!uses)
		user << "<span class='warning'>Whatever was attached to your hand has faded away. All of it's charges extinguished.</span>"
		qdel(src)
		return
	if(useblacklist)
		if(target in blacklist)
			user << "<span class='warning'>[target] is too dangerous to mess with!</span>"
			return
	if(iscarbon(target))
		if(target == user)
			if(user.job == "Mime")
				if(uses < 3)
					user << "<span class='warning'>You've got to have more charges than that!</span>"
					return
				uses = 0 // we sacrifice all of our uses!
				var/passes = 5
				while(passes > 0)
					if(!user)
						break
					passes--
					user.alpha = 0
					sleep(3)
					user.alpha = initial(user.alpha)
					sleep(2)
			else
				user << "<span class='warning'>You have to be a mime to use this trick!</span>"
		else
			user << "<span class='warning'>It doesn't work on other people!</span>"

	if(isobj(target))
		if(istype(target, /obj/structure/chair))
			target.visible_message("[target] [target.alpha == 0 ? "reappears" : "vanishes"]!</span>")
			if(target.alpha)
				target.alpha = 0
			else
				target.alpha = initial(target.alpha)
			if(!(target in things))// to be restored later
				things += target
			return
		if((target in things))
			user << "<span class='warning'>You can't use this on the same thing more than once!</span>"
			return
		if(!target.alpha)
			return
		things += target
		user << "<span class='warning'>You poke [target] extinguishing one of your charges.</span>"
		uses--
		target.alpha = 0
		addtimer(src, "reverttarget",80, FALSE, target)

/obj/item/weapon/melee/touch_attack/proc/reverttarget(atom/A)
	if(A)
		A.alpha = initial(A.alpha)

/obj/item/weapon/melee/touch_attack/nothing/roundstart
	useblacklist = TRUE
