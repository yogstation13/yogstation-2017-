//Floorbot assemblies
/obj/item/weapon/honkbox
	desc = "It's a medkit with a bikehorn crudely glued to the side. Why would someone make this?"
	name = "bikehorn and medkit"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "honkbox1"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Honkbot"

/obj/item/weapon/honkbox_mask
	desc = "It's a medkit with a bike horn glued to the side and a clown mask stapled on top. Truly a work of art."
	name = "bikehorn, medkit and clown mask arrangement"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "honkbox2"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Honkbot"

//Honkbot Definition
/mob/living/simple_animal/hostile/honkbot
	name = "honkbot"
	desc = "A fusion of clown magic and science. An object of personified annoyance."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "honkbot"
	icon_living = "honkbot"
	status_flags = list(CANSTUN, CANWEAKEN, CANPUSH)
	stop_automated_movement_when_pulled = 0
	mouse_opacity = 1
	faction = list("honkbot")
	a_intent = "harm"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0) //Leaving something at 0 means it's off - has no maximum
	minbodytemp = 0
	wander = 1
	idle_vision_range = 9
	move_to_delay = 5
	retreat_distance = 5
	minimum_distance = 5
	health = 100
	maxHealth = 100
	melee_damage_lower = 0
	melee_damage_upper = 0
	environment_smash = 0
	var/emagged = 0 //Allow drones to be emagged.
	attacktext = "honks"
	projectiletype = /obj/item/projectile/clownblast
	attack_sound = 'sound/items/bikehorn.ogg'
	ranged = 1
	ranged_message = "honks at"
	var/last_honk = 6
	var/honk_rate = 6
	var/last_banana = 10
	var/banana_rate = 10


/obj/item/weapon/storage/firstaid/attackby(var/obj/item/device/assembly/bikehorn/S, mob/user as mob)

	if (!istype(S, /obj/item/device/assembly/bikehorn))
		..()
		return

	//Making a honkbox.
	if(src.contents.len >= 1)
		user << "<span class='notice'>You need to empty the [src] out first if you want to attach the bike horn.</span>"
		..()
		return

	var/obj/item/weapon/honkbox/A = new /obj/item/weapon/honkbox

	qdel(S)
	user.put_in_hands(A)
	user << "<span class='notice'>You crudely attach the bikehorn to the side of the [src].</span>"
	user.unEquip(src, 1)
	qdel(src)


/obj/item/weapon/honkbox/attackby(var/obj/item/clothing/mask/gas/clown_hat/W, mob/user as mob)
	if (!istype(W, /obj/item/clothing/mask/gas/clown_hat))
		..()
		return

	//Making a honkbox steo 2

	var/obj/item/weapon/honkbox_mask/A = new /obj/item/weapon/honkbox_mask

	qdel(W)
	user.put_in_hands(A)
	user << "<span class='notice'>You crudely staple the mask to the top of the [src].</span>"
	user.unEquip(src, 1)
	qdel(src)


/obj/item/weapon/honkbox_mask/attackby(var/obj/item/W, mob/user as mob)

	..()
	if(istype(W, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t
	else
		if(isprox(W))
			user.drop_item()
			qdel(W)
			user << "<span class='notice'>You complete the Honkbot! Beep boop.</span>"
			var/mob/living/simple_animal/hostile/honkbot/S = new /mob/living/simple_animal/hostile/honkbot/(user.loc)
			S.name = src.created_name
			user.unEquip(src, 1)
			qdel(src)

/obj/item/projectile/clownblast
	name = "honk"
	icon_state = ""
	hitsound = 'sound/items/bikehorn.ogg'
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


/mob/living/simple_animal/hostile/honkbot/proc/Emag(mob/user as mob)
	if(user) user << "<span class='notice'>The [src] honks excitedly!</span>"
	emagged = 2
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	icon_state = "honkbot_emag"
	honk_rate = 3
	return


/mob/living/simple_animal/hostile/honkbot/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/weapon/card/emag) && emagged < 2)
		Emag(user)

/mob/living/simple_animal/hostile/honkbot/Life()
	..()
	last_honk--
	if(last_honk <= 0)
		last_honk = honk_rate
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		visible_message("<span>[src] honks his horn.</span>")
	if(emagged == 2)
		last_banana--
		if(last_banana <= 0)
			new /obj/item/weapon/grown/bananapeel(src.loc,65)
			last_banana = banana_rate

/mob/living/simple_animal/hostile/honkbot/death(gibbed)
 	visible_message("<span class='danger'>[src] is destroyed!</span>")
 	new /obj/effect/decal/cleanable/robot_debris(src.loc)
 	qdel(src)
 	..()
