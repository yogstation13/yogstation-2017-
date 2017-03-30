/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/obj/effect/proc_holder/alien
	name = "Alien Power"
	panel = "Alien"
	var/plasma_cost = 0
	var/check_turf = 0
	var/usable = 1

	var/has_action = 1
	var/datum/action/spell_action/alien/action = null
	var/action_icon = 'icons/mob/actions.dmi'
	var/action_icon_state = "spell_default"
	var/action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/alien/New()
	..()
	action = new(src)

/obj/effect/proc_holder/alien/Click()
	if(!istype(usr,/mob/living/carbon))
		return 1
	if(!usable)
		usr << "<span class='warning'>[name] is currently on a cooldown.</span>"
		return 1
	var/mob/living/carbon/user = usr
	if(cost_check(check_turf,user))
		if(fire(user) && user) // Second check to prevent runtimes when evolving
			user.adjustPlasma(-plasma_cost)
	return 1

/obj/effect/proc_holder/alien/proc/on_gain(mob/living/carbon/user)
	return

/obj/effect/proc_holder/alien/proc/on_lose(mob/living/carbon/user)
	return

/obj/effect/proc_holder/alien/proc/fire(mob/living/carbon/user)
	return 1

/obj/effect/proc_holder/alien/proc/cost_check(check_turf=0,mob/living/carbon/user,silent = 0)
	if(user.stat)
		if(!silent)
			user << "<span class='noticealien'>You must be conscious to do this.</span>"
		return 0
	if(user.getPlasma() < plasma_cost)
		if(!silent)
			user << "<span class='noticealien'>Not enough plasma stored.</span>"
		return 0
	if(check_turf && (!isturf(user.loc) || istype(user.loc, /turf/open/space)))
		if(!silent)
			user << "<span class='noticealien'>Bad place for a garden!</span>"
		return 0
	return 1

/obj/effect/proc_holder/alien/proc/resetUsable()
	usable = !usable

/obj/effect/proc_holder/alien/plant
	name = "Plant Weeds"
	desc = "Plants some alien weeds"
	plasma_cost = 50
	check_turf = 1
	action_icon_state = "alien_plant"

/obj/effect/proc_holder/alien/plant/fire(mob/living/carbon/user)
	if(locate(/obj/structure/alien/weeds) in get_turf(user))
		src << "There's already a weed node here."
		return 0
	user.visible_message("<span class='alertalien'>[user] has planted some alien weeds!</span>")
	new/obj/structure/alien/weeds/node(user.loc, null, 1)
	return 1

/obj/effect/proc_holder/alien/whisper
	name = "Whisper"
	desc = "Whisper to someone"
	plasma_cost = 10
	action_icon_state = "alien_whisper"

/obj/effect/proc_holder/alien/whisper/fire(mob/living/carbon/user)
	var/list/options = list()
	for(var/mob/living/Ms in oview(user))
		options += Ms
	var/mob/living/M = input("Select who to whisper to:","Whisper to?",null) as null|mob in options
	if(!M)
		return 0
	var/msg = sanitize(input("Message:", "Alien Whisper") as text|null)
	if(msg)
		log_say("AlienWhisper: [key_name(user)]->[M.key] : [msg]")
		M << "<span class='noticealien'>You hear a strange, alien voice in your head...</span>[msg]"
		user << "<span class='noticealien'>You said: \"[msg]\" to [M]</span>"
		for(var/ded in dead_mob_list)
			if(!isobserver(ded))
				continue
			var/follow_link_user = FOLLOW_LINK(ded, user)
			var/follow_link_whispee = FOLLOW_LINK(ded, M)
			ded << "[follow_link_user] \
				<span class='name'>[user]</span> \
				<span class='alertalien'>Alien Whisper --> </span> \
				[follow_link_whispee] \
				<span class='name'>[M]</span> \
				<span class='noticealien'>[msg]</span>"
	else
		return 0
	return 1

/obj/effect/proc_holder/alien/transfer
	name = "Transfer Plasma"
	desc = "Transfer Plasma to another alien"
	plasma_cost = 0
	action_icon_state = "alien_transfer"

/obj/effect/proc_holder/alien/transfer/fire(mob/living/carbon/user)
	var/list/mob/living/carbon/aliens_around = list()
	for(var/mob/living/carbon/A  in oview(user))
		if(A.getorgan(/obj/item/organ/alien/plasmavessel))
			aliens_around.Add(A)
	var/mob/living/carbon/M = input("Select who to transfer to:","Transfer plasma to?",null) as mob in aliens_around
	if(!M)
		return 0
	var/amount = input("Amount:", "Transfer Plasma to [M]") as num
	if (amount)
		amount = min(abs(round(amount)), user.getPlasma())
		if (get_dist(user,M) <= 1)
			M.adjustPlasma(amount)
			user.adjustPlasma(-amount)
			M << "<span class='noticealien'>[user] has transfered [amount] plasma to you.</span>"
			user << "<span class='noticealien'>You trasfer [amount] plasma to [M]</span>"
		else
			user << "<span class='noticealien'>You need to be closer!</span>"
	return

/obj/effect/proc_holder/alien/resin
	name = "Secrete Resin"
	desc = "Secrete tough malleable resin."
	plasma_cost = 55
	check_turf = 1
	var/list/structures = list(
		"resin wall" = /obj/structure/alien/resin/wall,
		"resin membrane" = /obj/structure/alien/resin/membrane,
		"resin nest" = /obj/structure/bed/nest)

	action_icon_state = "alien_resin"

/obj/effect/proc_holder/alien/resin/fire(mob/living/carbon/user)
	if(locate(/obj/structure/alien/resin) in user.loc)
		user << "<span class='danger'>There is already a resin structure there.</span>"
		return 0
	var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in structures
	if(!choice)
		return 0
	if (!cost_check(check_turf,user))
		return 0
	user << "<span class='notice'>You shape a [choice].</span>"
	user.visible_message("<span class='notice'>[user] vomits up a thick purple substance and begins to shape it.</span>")

	choice = structures[choice]
	new choice(user.loc)
	return 1

/obj/effect/proc_holder/alien/regurgitate
	name = "Regurgitate"
	desc = "Empties the contents of your stomach"
	plasma_cost = 0
	action_icon_state = "alien_barf"

/obj/effect/proc_holder/alien/regurgitate/fire(mob/living/carbon/user)
	if(user.stomach_contents.len)
		for(var/atom/movable/A in user.stomach_contents)
			user.stomach_contents.Remove(A)
			A.loc = user.loc
			if(isliving(A))
				var/mob/M = A
				M.reset_perspective()
		user.visible_message("<span class='alertealien'>[user] hurls out the contents of their stomach!</span>")
	return

/obj/effect/proc_holder/alien/nightvisiontoggle
	name = "Toggle Night Vision"
	desc = "Toggles Night Vision"
	plasma_cost = 0
	has_action = 0 // Has dedicated GUI button already

/obj/effect/proc_holder/alien/nightvisiontoggle/fire(mob/living/carbon/alien/user)
	if(!user.nightvision)
		user.see_in_dark = 8
		user.see_invisible = SEE_INVISIBLE_MINIMUM
		user.nightvision = 1
		user.hud_used.nightvisionicon.icon_state = "nightvision1"
	else if(user.nightvision == 1)
		user.see_in_dark = 4
		user.see_invisible = 45
		user.nightvision = 0
		user.hud_used.nightvisionicon.icon_state = "nightvision0"

	return 1

/obj/effect/proc_holder/alien/sneak
	name = "Sneak"
	desc = "Blend into the shadows to stalk your prey."
	var/active = 0

	action_icon_state = "alien_sneak"

/obj/effect/proc_holder/alien/sneak/fire(mob/living/carbon/alien/humanoid/user)
	if(!active)
		user.alpha = 75 //Still easy to see in lit areas with bright tiles, almost invisible on resin.
		user.sneaking = 1
		active = 1
		user << "<span class='noticealien'>You blend into the shadows...</span>"
	else
		user.alpha = initial(user.alpha)
		user.sneaking = 0
		active = 0
		user << "<span class='noticealien'>You reveal yourself!</span>"


/mob/living/carbon/proc/getPlasma()
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(!vessel) return 0
	return vessel.storedPlasma


/mob/living/carbon/proc/adjustPlasma(amount)
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(!vessel) return 0
	vessel.storedPlasma = max(vessel.storedPlasma + amount,0)
	vessel.storedPlasma = min(vessel.storedPlasma, vessel.max_plasma) //upper limit of max_plasma, lower limit of 0
	for(var/X in abilities)
		var/obj/effect/proc_holder/alien/APH = X
		if(APH.has_action)
			APH.action.UpdateButtonIcon()
	return 1

/mob/living/carbon/alien/adjustPlasma(amount)
	. = ..()
	updatePlasmaDisplay()

/mob/living/carbon/proc/usePlasma(amount)
	if(getPlasma() >= amount)
		adjustPlasma(-amount)
		return 1

	return 0


/proc/cmp_abilities_cost(obj/effect/proc_holder/alien/a, obj/effect/proc_holder/alien/b)
	return b.plasma_cost - a.plasma_cost


/obj/effect/proc_holder/alien/coughneuro
	name = "Cough Up Neurotoxin"
	desc = "Coughs up a blob of neurotoxin which can be used as projectile spit."
	action_icon_state = "alien_coughneuro"

/obj/effect/proc_holder/alien/coughneuro/fire(mob/living/carbon/user)
	var/obj/item/organ/alien/neurotoxinthroat/throat = user.getorganslot("throatcanal")
	if(!throat)
		user << "<span class='warning'>You don't have the gland for this...</span>"
		return

	user.visible_message("<span class='warning'>[user] begins to start cough up something, and than swallows it into another organ!</span>", "<span class='warning'>You \
	hear something or someone coughing up a monstrous blob of spit.</span>", 15)
	throat.start_ache()
	//throat.addtimer(throat, "stop_ache", 1000)

	if((throat.neurotoxinStorage + 5) > throat.neurotoxinStorageLimit)
		user.visible_message("<span class='danger'>[user] starts choking up!</span>", "<span class='danger'>[user] is choking!</span>", 15)
		user.confused += 20
		user.stuttering += 30
		return

	throat.neurotoxinStorage += 5
	if(throat.neurotoxinStorage == throat.neurotoxinStorageLimit)
		user << "<span class='noticealien'>You feel a buldge coming from your neurotoxin throat sac. It's at it's max capacity of neurotoxin. Anymore could harm you.</span>"
	return 1

/obj/effect/proc_holder/alien/neurotoxin
	name = "Spit Neurotoxin"
	desc = "Spits neurotoxin at someone, burning them. Can be used to destroy machinery as well.  Ten units of neurotoxin spit will mute humans."
	action_icon_state = "alien_neurotoxin_0"
	var/active = 0

/obj/effect/proc_holder/alien/neurotoxin/fire(mob/living/carbon/user)
	if(active)
		user.ranged_ability = null
		user << "<span class='notice'>You swallow back the neurotoxin.</span>"
		active = 0
	else if(user.ranged_ability && user.ranged_ability != src)
		user << "<span class='warning'>You already have another aimed ability readied! Cancel it first."
		return
	else
		var/obj/item/organ/alien/neurotoxinthroat/throat = user.getorganslot("throatcanal")
		if(!throat)
			user << "<span class='warning'>You don't have the gland for this...</span>"
			return
		if(!throat.neurotoxinStorage)
			user << "<span class='warning'>You need to cough up some neurotoxin into your throat!"
			return
		user.ranged_ability = src
		active = 1
		user << "<span class='notice'>You prepare your neurotoxin gland. <B>Left-click to fire at a target!</B></span>"

	user.client.click_intercept = user.ranged_ability
	action.button_icon_state = "alien_neurotoxin_[active]"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/alien/neurotoxin/InterceptClickOn(mob/living/carbon/user, params, atom/target)
	var/p_cost = 60
	if(!iscarbon(user) || user.lying || user.stat)
		return
	user.next_click = world.time + 6
	user.face_atom(target)
	if(user.getPlasma() < p_cost*2)
		user << "<span class='warning'>You need at least [p_cost*2] plasma to spit.</span>"
		return

	var/obj/item/organ/alien/neurotoxinthroat/throat = user.getorganslot("throatcanal")
	if(!throat)
		return

	if(!throat.neurotoxinStorage)
		user << "<span class='warning'>You need to cough up some neurotoxin into your throat to use this ability!"
		return

	var/turf/T = user.loc
	var/turf/U = get_step(user, user.dir) // Get the tile infront of the move, based on their direction
	if(!isturf(U) || !isturf(T))
		return 0

	user.visible_message("<span class='danger'>[user] spits neurotoxin!", "<span class='alertalien'>You spit neurotoxin.</span>")
	var/obj/item/projectile/bullet/neurospit/A

	switch(throat.neurotoxinStorage)
		if(5)
			A = new /obj/item/projectile/bullet/neurospit(user.loc)
		if(10)
			A = new /obj/item/projectile/bullet/neurospit/average(user.loc)
		if(15)
			A = new /obj/item/projectile/bullet/neurospit/moderate(user.loc)
		if(20)
			A = new /obj/item/projectile/bullet/neurospit/strong(user.loc)
		if(25)
			A = new /obj/item/projectile/bullet/neurospit/bulky(user.loc)

	if(!A)
		message_admins("ERROR: (1) [user] ([user.ckey]) failed to fire '[src]' because their xenomorphic throat had [throat.neurotoxinStorage]. Report to a coder immediately.")
		message_admins("ERROR: (2) Canceling [user] ([user.ckey])'s shot right now.")
		return

	A.current = U
	A.preparePixelProjectile(target, get_turf(target), user, params)
	A.fire()

	if(istype(target, /turf/) || istype(target, /obj))
		if(target in view(1, user))
			if(!(istype(target, /turf/closed))) // walls
				A.splashAcid(target)

	user.newtonian_move(get_dir(U, T))
	user.adjustPlasma(-p_cost*5)
	throat.neurotoxinStorage = 0
	return 1

/obj/effect/proc_holder/alien/neurotoxin/on_lose(mob/living/carbon/user)
	if(user.ranged_ability == src)
		user.ranged_ability = null


/obj/effect/proc_holder/alien/boil
	name = "Boil Stomach"
	desc = "Lets you digest humans in your stomach, slowly burning them"
	plasma_cost = 50
	check_turf = 1
	panel = "Alien"
	action_icon_state = "dissolve"
	var/staminadamage = 5
	var/burndamage = 3

/obj/effect/proc_holder/alien/boil/fire(mob/living/carbon/user)
	if(usable)
		resetUsable(user) // we will turn it off during this.

	var/list/phrases = list("More off then getting stuck in a xenomorphs stomach..",
							"This is NOT the type of station you wanted to be on!",
							"The pain is digging into your bones!!",
							"Your skin is melting!!",
							"Is this xenomorph somehow enjoying this?!")
	var/chosen

	user << "<span class='warning'>You begin to digest the residue in your stomach..</span>"

	for(var/i,i<7,i++)
		chosen = pick(phrases)
		for(var/mob/living/L in user.stomach_contents)
			L << "<span class='warning'>Your body becomes heavier! Somethings off here! [chosen]</span>"
			L.adjustStaminaLoss(staminadamage)
			L.adjustFireLoss(burndamage)
		sleep(30)
	addtimer(src, "resetUsable", 210)
	return 1

/obj/effect/proc_holder/alien/boil/resetUsable(mob/living/L)
	if(!usable)
		L << "<span class='notice'>Your digestive systems deplete to normal...</span>"
	..()

/obj/effect/proc_holder/spell/targeted/headbite
	name = "Headbite"
	clothes_req = 0
	max_targets = 1
	range = 1
	charge_max = 800
	invocation_type = "none"
	action_icon_state = "headbite" // needs a better sprite.

/obj/effect/proc_holder/spell/targeted/headbite/cast(list/targets,mob/user = usr)
	for(var/mob/living/L in targets)
		if(!ishuman(L))
			return
		if(user.grab_state <= GRAB_AGGRESSIVE)
			user << "<span class='noticealien'>You need a better grab.</span>"
			return
		if(user.pulling == L)
			L << "<span class='warning'>[user] begins to slowly crawl over you...</span>"
			user << "<span class='alertalien>'>You begin to crawl ontop of [user]....</span>"
			sleep(30) // three seconds.
			var/mob/living/carbon/human/H = L
			var/obj/item/bodypart/B = H.get_bodypart("head")
			if(!B)
				user << "<span class='alertalien'>[user] doesn't have a head... there's nothing to bite.</span>"
				return
			L << "<span class='warning'>[user]'s tongue snaps at your head!</span>"
			flash_color(L, color = "#FF0000", time = 50)
			sleep(10)
			if(istype(H.head, /obj/item/clothing/head/helmet/space/hardsuit))
				L << "<span class='warning'>[H.head] protects you!</span>"
				user << "<span class='alertalien'>[L]'s [H.head] gets in the way!</span>"
				flash_color(user, color = "#FF0000", time = 50)
				user.Stun(10)
				return
			L.visible_message("<span class='warning'>[L]'s head is mutilated by [user]'s snake-like tongue!</span>", \
				"<span class='warning'>[L]'s head is mutilated by [user]'s snake-like tongue!</span>")
			if(B)
				B.dismember()