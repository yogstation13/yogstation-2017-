
/obj/item/weapon/gun/projectile/automatic/paintball
	name = "DEAFCON Series 1 paintball gun"
	desc = "An entry level paintball gun, this one comes in blue."
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/paintball
	fire_sound = 'sound/weapons/paintball.ogg'
	pin = /obj/item/device/firing_pin //may wanna change this idk
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
	name = "DEAFCON Series 1 red paintball gun"
	desc = "An entry level paintball gun, this one comes in red."
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball_red"
	item_state = "gun"

/obj/item/weapon/gun/projectile/automatic/paintball/super
	name = "M.I.L.I.T.A.N.T series XT-01 accelerated paintball gun"
	desc = "A sleek paintball gun, it looks similar to what the military use, it can fire up to 4 balls at once!"
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball_super"
	item_state = "gun"
	burst_size = 4

/obj/item/weapon/gun/projectile/automatic/paintball/realism
	name = "ZX DOMINATOR realism series paintball gun"
	desc = "A paintball gun, it looks scarily realistic, it is not clearly marked with an orange tip, and it looks so real that I wouldn't be surprised if beepsky thought you were a terrorist..."
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball_realism"
	item_state = "gun"
	burst_size = 6
	needs_permit = 1 //super realistic gun :^)

//Ammo, and paintball colouring code

/obj/item/ammo_casing/paintball
	name = "paintball"
	desc = "A red coloured plastic ball."
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

/obj/item/projectile/bullet/paintball/yellow
	icon = 'icons/obj/guns/paintball.dmi'
	color = "#CFB52B"

/obj/item/ammo_casing/paintball/yellow
	name = "paintball"
	desc = "A yellow coloured plastic ball filled with paint."
	projectile_type = /obj/item/projectile/bullet/paintball/yellow
	icon = 'icons/obj/guns/paintball.dmi'
	icon_state = "paintball1"
	color = "#CFB52B"

/obj/item/ammo_casing/paintball/violet
	name = "paintball"
	desc = "A violet coloured plastic ball."
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
		var/image/paintoverlay = image('icons/effects/paintball.dmi')
		paintoverlay.color = color //colour the paint splats in
		paintoverlay.icon_state = pick("1","2","3","4","5","6","7")
		H.overlays += paintoverlay
		H << "<span class='warning'>Your feel a sharp sting as you're hit by the [src].</span>"
	else if(isturf(target))
		target.color = color //paints walls that it hits with paint

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