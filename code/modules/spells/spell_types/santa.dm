//Santa spells!
/obj/effect/proc_holder/spell/aoe_turf/conjure/presents
	name = "Conjure Presents!"
	desc = "This spell lets you reach into S-space and retrieve presents! Yay!"
	school = "santa"
	charge_max = 600
	clothes_req = 0
	invocation = "HO HO HO"
	invocation_type = "shout"
	range = 3
	cooldown_min = 50

	summon_type = list("/obj/item/weapon/a_gift")
	summon_lifespan = 0
	summon_amt = 5


/obj/effect/proc_holder/spell/targeted/coal
	name = "Add to Naughty List"
	desc = "Assigns someone to the naughty list."
	school = "santa"
	clothes_req = 0
	invocation = "I'm sorry..."
	invocation_type = "whisper"
	charge_max = 1
	cooldown_min = 1

/obj/effect/proc_holder/spell/targeted/coal/cast(list/targets, mob/user)
	var/obj/item/trash/coal/C = new(get_turf(user))
	user.put_in_active_hand(C)
	to_chat(user, "<span class='warning'>Put someone's name into this coal, and they will be assigned to the naughty list. There is no turning back.</span>")