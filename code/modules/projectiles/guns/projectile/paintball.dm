/obj/item/weapon/gun/projectile/automatic/paintball
	name = "paintball gun (blue)"
	desc = "An entry level paintball gun. This one comes in blue."
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/paintball
	fire_sound = 'sound/weapons/paintball.ogg'
	pin = /obj/item/device/firing_pin/paintball //paintball only, can't be removed nor added.
	var/emagged = 0
	burst_size = 2
	needs_permit = 0 //it's a toy
	clumsy_check = 0 //clown can terrorize people with paint

/obj/item/weapon/gun/projectile/automatic/paintball/emag_act(mob/user)
	user << "<span class='warning'>You override the safety on the [src]'s gas regulator, removing its firing limiter.</span>"
	playsound(loc, 'sound/machines/warning-buzzer.ogg', 10, 0)
	burst_size = 7
	emagged = 1

/obj/item/weapon/gun/projectile/automatic/paintball/red
	name = "paintball gun (red)"
	desc = "An entry level paintball gun. This one comes in red."
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball_red"
	item_state = "gun"

/obj/item/weapon/gun/projectile/automatic/paintball/super
	name = "XT-01 accelerated paintball gun"
	desc = "A sleek paintball gun, it looks similar to what the elite nanotrasen forces use, it can fire up to 4 balls at once!"
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball_super"
	item_state = "gun"
	burst_size = 4

/obj/item/weapon/gun/projectile/automatic/paintball/realism
	name = "ZX DOMINATOR realism series paintball gun"
	desc = "A worryingly realistic paintball gun, I wouldn't be surprised if beepsky thought you were a terrorist..."
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball_realism"
	item_state = "gun"
	burst_size = 6
	needs_permit = 1 //super realistic gun :^)

//Ammo, and paintball colouring code

/obj/item/ammo_casing/paintball
	name = "paintball"
	desc = "A red coloured plastic ball filled with paint."
	projectile_type = /obj/item/projectile/bullet/paintball
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball1"
	color = "#C73232"

/obj/item/projectile/bullet/paintball //red paintball
	damage = 0 //needs to be set from the default of 60
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball1"
	color = "#C73232"

/obj/item/ammo_casing/paintball/blue
	name = "paintball"
	desc = "A blue coloured plastic ball filled with paint."
	projectile_type = /obj/item/projectile/bullet/paintball/blue
	icon = 'icons/obj/guns/paintball.dmi'
	color = "#5998FF"

/obj/item/projectile/bullet/paintball/blue //blue paintball
	icon = 'icons/obj/guns/paintball.dmi'
	color = "#5998FF"

/obj/item/ammo_casing/paintball/yellow
	name = "paintball"
	desc = "A yellow coloured plastic ball filled with paint."
	projectile_type = /obj/item/projectile/bullet/paintball/yellow
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball1"
	color = "#CFB52B"

/obj/item/projectile/bullet/paintball/yellow
	icon = 'icons/obj/guns/paintball.dmi'
	color = "#CFB52B"

/obj/item/ammo_casing/paintball/violet
	name = "paintball"
	desc = "A violet coloured plastic ball filled with paint."
	projectile_type = /obj/item/projectile/bullet/paintball/violet
	icon = 'icons/obj/guns/paintball.dmi'
	color = "#AE4CCD"

/obj/item/projectile/bullet/paintball/violet
	icon = 'icons/obj/guns/paintball.dmi'
	color = "#AE4CCD"

/obj/item/ammo_box/magazine/paintball
	name = "paintball ammo cartridge (red)"
	ammo_type = /obj/item/ammo_casing/paintball
	caliber = "paintball"
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintballmag"
	max_ammo = 20


/obj/item/ammo_casing/paintball/Crossed(atom/movable/mover)
	to_chat(mover, "SPLAT!")
	var/spreadem = rand(1,100)
	var/turf/theturf = get_turf(src)
	theturf.color = src.color
	if(spreadem < 2 || spreadem == 1)
		src.visible_message("[src] explodes in a shower of paint! covering everything around it in sticky horridness.")
		for(var/atom/movable/T in orange(3, src))
			T.color = src.color //ohhhhh you're gonna hate me after this Enka ;)
	qdel(src)

/obj/item/ammo_box/magazine/paintball/blue
	name = "paintball ammo cartridge (blue)"
	ammo_type = /obj/item/ammo_casing/paintball/blue

/obj/item/ammo_box/magazine/paintball/yellow
	name = "paintball ammo cartridge (yellow)"
	ammo_type = /obj/item/ammo_casing/paintball/yellow

/obj/item/ammo_box/magazine/paintball/violet
	name = "paintball ammo cartridge (violet)"
	ammo_type = /obj/item/ammo_casing/paintball/violet

/obj/item/projectile/bullet/paintball/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/human/H = target
		if(prob(10))
			H.color = color
		if(H.wear_suit)
			H.wear_suit.add_blood(H)
			H.update_inv_wear_suit(1)    //updates mob overlays to show the new blood (no refresh)
		else if(H.w_uniform)
			H.w_uniform.add_blood(H)
			H.update_inv_w_uniform(1)    //updates mob overlays to show the new blood (no refresh)
		H << "<span class='warning'>Your feel a sharp sting.</span>"
	else
		target.color = color //paints EVERYTHING THAT IT HITS WITH FUCKING PAINT

/obj/effect/decal/cleanable/paintball_splat
	name = "paintball splat"
	icon = 'icons/effects/paintball.dmi'
	icon_state = "1"

//Colour list reference, in case you wanna make more ammo types
	//		if("red")
	//			item_color = "C73232"
	//		if("blue")
	//			item_color = "5998FF"
	//		if("green")
		//		item_color = "2A9C3B"
	//		if("yellow")
		//		item_color = "CFB52B"
	///		if("violet")
	///			item_color = "AE4CCD"
	///		if("white")
//				item_color = "FFFFFF"
//			if("black")
//				item_color = "333333"
