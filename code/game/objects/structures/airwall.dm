/obj/structure/destructible/airwall
	name = "inflated membrane wall"
	desc = "An easily fabricated emergency airtight membrane. Looks really weak..."
	density = 1
	anchored = 1
	opacity = 0
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"
	var/obj_integrity = 10
	var/max_integrity = 10

/obj/structure/destructible/airwall/attackby(obj/item/weapon, mob/user)
	. = ..()
	obj_integrity -= weapon.force
	if(obj_integrity <= 0)
		pop()

/obj/structure/destructible/airwall/proc/pop()
	visible_message("<span class='warning'>[src] breaks with a loud bang!</span>")
	playsound(src, 'sound/weapons/flashbang.ogg', 40, 1)
	qdel(src)
