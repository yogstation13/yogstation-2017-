/obj/item/hardsuit_jetpack
	name = "hardsuit jetpack upgrade"
	icon_state = "jetpack_upgrade"
	desc = "A modular, compact set of thrusters designed to integrate with a hardsuit. It is fueled by a tank inserted into the suit's storage compartment."


/obj/item/hardsuit_jetpack/afterattack(var/obj/item/clothing/suit/space/hardsuit/S, mob/user)
	..()
	if(!istype(S))
		user << "<span class='warning'>This upgrade can only be applied to a hardsuit.</span>"
	else if(S.jetpack)
		user << "<span class='warning'>[S] already has a jetpack installed.</span>"
	else if(S == user.get_item_by_slot(slot_wear_suit)) //Make sure the player is not wearing the suit before applying the upgrade.
		user << "<span class='warning'>You cannot install the upgrade to [S] while wearing it.</span>"
	else
		S.jetpack = new /obj/item/weapon/tank/jetpack/suit(S)
		user << "<span class='notice'>You successfully install the jetpack into [S].</span>"
		qdel(src)