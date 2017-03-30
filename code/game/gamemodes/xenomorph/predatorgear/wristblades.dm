/datum/action/item_action/retractwristblades
	name = "Toggle Wristblades"
	button_icon_state = "wristblades"

/datum/action/item_action/retractwristblades/Trigger()
	var/mob/user = owner
	if(ishuman(user))
		var/mob/living/carbon/human/L = user
		var/obj/item/clothing/C = L.wear_suit
		if(!istype(C, /obj/item/clothing/suit/space/hardsuit/predator))
			L << "<span class='warning'>You need to equip the entire predator suit in order to retract the wristblades!</span>"
			return

		var/gethand = user.get_active_hand()

		if(!gethand)
			var/stealthed = get_turf(user.loc)
			var/obj/item/weapon/predator/PT = new /obj/item/weapon/predator(stealthed)
			PT.owner = src
			L.put_in_active_hand(PT)
			user << "<span class='notice'>You retract your wrist blade!</span>"

		else if(istype(gethand, /obj/item/weapon/predator))
			var/obj/item/weapon/predator/wristblade = gethand
			if(wristblade.owner == src)
				qdel(wristblade)
				user << "<span class='notice'>You retract your wristblade!</span>"
		else
			user << "<span class='danger'>There is something in your hand! You cannot extend your blade.</span>"

/obj/item/weapon/predator
	name = "wristblade"
	desc = "A unique alien blade that illuminates in the light."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "wristblade"
	item_state = "wristblade"
	flags = NODROP
	force = 24
	sharpness = IS_SHARP
	var/owner
	block_chance = 75

/obj/item/weapon/predator/examine(mob/user)
	..()
	if(ispredator(user))
		user << "<span class='alien'>The weapon of choice for many Predators. The most preferrable use is in close range combat fights. \
	Connected to their skinsuit, this weapon is regularly used to decapitate prey dead or alive. The weapon has a chance to block \
	most of your enemies meele attacks.</span>"

/obj/item/weapon/predator/attack_self(mob/user)
	if(owner)
		user << "<span class='notice'>You retract your wrist blades!</span>"
		qdel(src)

/obj/item/weapon/predator/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	if(damage && attack_type == MELEE_ATTACK && prob(final_block_chance))
		visible_message("<span class='danger'>[owner] deflects [attack_text] with [src] creating a resonating noise!</span>")
		return 1
	return 0

/obj/item/weapon/predator/dropped() // if we somehow drop it, maybe through explosion or torn off, whoever finds it earns it
	if(owner)
		owner = null
	if(flags & NODROP)
		flags &= ~NODROP
	..()

/obj/item/weapon/predator/afterattack(atom/target, mob/user, proximity_flag)
	..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(H.stat == DEAD)
			if(!H.get_bodypart(user.zone_selected))
				user << "<span class='warning'>[target]'s [user.zone_selected] is already dismembered...</span>"
			else
				var/obj/item/bodypart/B = H.get_bodypart(user.zone_selected)
				B.dismember()
				visible_message("[user] prys off [target]'s [B]!")
