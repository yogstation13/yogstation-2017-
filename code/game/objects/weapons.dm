/obj/item/weapon/
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'

/obj/item/weapon/New()
	..()
	if(!hitsound)
		if(damtype == "fire")
			hitsound = 'sound/items/welder.ogg'
		if(damtype == "brute")
			hitsound = "swing_hit"

#define IMPROPERBLOCK 0
#define PROPERBLOCK 1
/*

The way blockcheck works is simple.

it checks for which position the attack/projectile is and where the user (holding the weapon/shield) is.

It compares the two, and based on the position of the user it will send information back for whether the hit
	will land on the user or not.

PROPERBLOCK returns 1. - it means that the attacker is in front or at the side of the user.
IMPROPERBLOCK returns 0. - it means that the attacker is behind the user, and has successfully attacked them.

You use check_for_postiions() to get this information back.

Have fun!
- Super3222

*/

var/global/list/blockcheck = list("[NORTH]" = list("[SOUTH]" = PROPERBLOCK, "[EAST]" = PROPERBLOCK, "[WEST]" = PROPERBLOCK, "[NORTH]" = IMPROPERBLOCK),
"[EAST]" = list("[SOUTH]" = PROPERBLOCK, "[WEST]" = PROPERBLOCK, "[EAST]" = IMPROPERBLOCK, "[NORTH]" = PROPERBLOCK),
"[SOUTH]" = list("[NORTH]" = PROPERBLOCK, "[WEST]" = PROPERBLOCK, "[EAST]" = PROPERBLOCK, "[SOUTH]" = IMPROPERBLOCK ),
"[WEST]" = list("[NORTH]" = PROPERBLOCK, "[EAST]" = PROPERBLOCK, "[SOUTH]" = PROPERBLOCK, "[WEST]" = IMPROPERBLOCK) )

/obj/item/weapon/proc/check_for_positions(mob/living/carbon/human/H, atom/movable/AM)
	var/facing_hit = blockcheck["[H.dir]"]["[AM.dir]"]
//	message_admins("This is [H] and his direction is [H.dir].") //break glass if needed -Super
//	message_admins("This is [AM] and his direction is [AM.dir].")
	return facing_hit