/************************************** NET GUN **************************************************/

/obj/item/weapon/gun/netgun
	name = "net gun"
	desc = "A rigid gun with a circular mouth that fires deployed nets."
	icon_state = "net_gun"
	item_state = "net_gun"
	force = 15
	throw_range = 1
	var/list/nets = list()

/obj/item/weapon/gun/netgun/loaded/New() // LOADED VERSION
	..()
	var/obj/item/weapon/restraints/legcuffs/bola/net/N
	for(var/i, i<10, i++)
		N = new(src)
		nets += N

/obj/item/weapon/gun/netgun/afterattack(obj/target, mob/user , flag)
	if(target == user)
		..()
		return
	if(nets.len)
		if(iscarbon(target))
			var/obj/item/weapon/restraints/legcuffs/bola/net/N = nets[1]
			N.loc = user.loc
			N.throw_at_fast(target, 30, 2,user)
			nets -= N
		else
			user << "<span class='warning'>[src] cannot fire without a humanoid target.</span>"
	else
		user << "<span class='warning'>[src] is out of nets!</span>"
	..()

/obj/item/weapon/restraints/legcuffs/bola/net
	name = "yautija net"
	desc = "A specialized net that entangles it's target, and slowly crushes them to their death."
	var/activated = TRUE

/obj/item/weapon/restraints/legcuffs/bola/net/process()
	if(istype(loc, /mob/living/carbon))
		if(prob(25))
			var/mob/living/carbon/C = loc
			C << "<span class='warning'>[src] slowly squeezes on you!</span>"
			C.apply_damage(5, BRUTE)

/obj/item/weapon/restraints/legcuffs/bola/net/throw_impact(atom/hit_atom)
	if(!activated)
		return
	return ..()

/obj/item/weapon/restraints/legcuffs/bola/net/cuff_act(mob/user)
	user << "<span class='warning'>[src] becomes tighter!</span>"
	if(prob(30))
		user.Weaken(3)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.apply_damage(2, BRUTE)