/obj/item/weapon/
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'

/obj/item/weapon/New()
	..()
	if(!hitsound)
		if(damtype == "fire")
			hitsound = 'sound/items/welder.ogg'
		if(damtype == "blunt")
			hitsound = "swing_hit"
