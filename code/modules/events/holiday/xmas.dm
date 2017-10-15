/datum/round_event_control/treevenge
	name = "Treevenge (Christmas)"
	holidayID = CHRISTMAS
	typepath = /datum/round_event/treevenge
	max_occurrences = 1
	weight = 20

/datum/round_event/treevenge/start()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		var/mob/living/simple_animal/hostile/tree/evil_tree = new /mob/living/simple_animal/hostile/tree(xmas.loc)
		evil_tree.icon_state = xmas.icon_state
		evil_tree.icon_living = evil_tree.icon_state
		evil_tree.icon_dead = evil_tree.icon_state
		evil_tree.icon_gib = evil_tree.icon_state
		qdel(xmas) //b-but I don't want to delete xmas...

//this is an example of a possible round-start event
/datum/round_event_control/presents
	name = "Presents under Trees (Christmas)"
	holidayID = CHRISTMAS
	typepath = /datum/round_event/presents
	weight = -1							//forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0

/datum/round_event/presents/start()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(xmas.z != 1)
			continue
		for(var/turf/open/floor/T in orange(1,xmas))
			for(var/i=1,i<=rand(1,5),i++)
				new /obj/item/weapon/a_gift(T)
	for(var/mob/living/simple_animal/pet/dog/corgi/Ian/Ian in mob_list)
		Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))
	for(var/obj/machinery/computer/security/telescreen/entertainment/Monitor in machines)
		Monitor.icon_state = "entertainment_xmas"

/datum/round_event/presents/announce()
	priority_announce("Ho Ho Ho, Merry Xmas!", "Unknown Transmission")

/obj/item/weapon/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/obj/christmas.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	var/cracked = 0

/obj/item/weapon/toy/xmas_cracker/attack(mob/target, mob/user)
	if( !cracked && istype(target,/mob/living/carbon/human) && (target.stat == CONSCIOUS) && !target.get_active_hand() )
		target.visible_message("[user] and [target] pop \an [src]! *pop*", "<span class='notice'>You pull \an [src] with [target]! *pop*</span>", "<span class='italics'>You hear a pop.</span>")
		var/obj/item/weapon/paper/Joke = new /obj/item/weapon/paper(user.loc)
		Joke.name = "[pick("awful","terrible","unfunny")] joke"
		Joke.info = pick("What did one snowman say to the other?\n\n<i>'Is it me or can you smell carrots?'</i>",
			"Why couldn't the snowman get laid?\n\n<i>He was frigid!</i>",
			"Where are santa's helpers educated?\n\n<i>Nowhere, they're ELF-taught.</i>",
			"What happened to the man who stole advent calanders?\n\n<i>He got 25 days.</i>",
			"What does Santa get when he gets stuck in a chimney?\n\n<i>Claus-trophobia.</i>",
			"Where do you find chili beans?\n\n<i>The north pole.</i>",
			"What do you get from eating tree decorations?\n\n<i>Tinsilitis!</i>",
			"What do snowmen wear on their heads?\n\n<i>Ice caps!</i>",
			"Why is Christmas just like life on ss13?\n\n<i>You do all the work and the fat guy gets all the credit.</i>",
			"Why doesn’t Santa have any children?\n\n<i>Because he only comes down the chimney.</i>")
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icons()
		cracked = 1
		icon_state = "cracker1"
		var/obj/item/weapon/toy/xmas_cracker/other_half = new /obj/item/weapon/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, 1)
		return 1
	return ..()

/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper hat that you are REQUIRED to wear."
	flags_inv = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

// holiday roles for HOLIDAYS!!
/datum/round_event_control/holidayrole
	weight = 0
	max_occurrences = 0
	typepath = /datum/round_event/holidayrole

/datum/round_event/holidayrole
	var/windowtext1
	var/windowtext2
	var/chosen

/datum/round_event/holidayrole/start()
	for(var/mob/M in dead_mob_list)
		spawn(0)
			var/response = alert(M, "[windowtext1]", "[windowtext2]", "Yes", "No")
			if(response == "Yes" && M && M.client && M.stat == DEAD && !chosen)
				dressup(M)

/datum/round_event/holidayrole/proc/dressup(var/mob/M)
	return


/* 			******************* CHRISTMAS ROLE DEFINES ***************************
 Santa - Runs around, gives people presents, assigns bad people to the naughty list, hears all.
 Grinch - Runs around, destroys Christmas, turns good presents / gifts into SORDs, the worst creation ever.
 Krampus - Runs around, punishes those who are naughty, is in your worst nightmare.

*/
var/list/naughty_list = list()
var/mob/living/activesanta
var/mob/living/activekrampus
var/krampusweak

/datum/round_event_control/holidayrole/santa
	name = "Santa is coming to town! (Christmas)"
	holidayID = CHRISTMAS
	typepath = /datum/round_event/holidayrole/santa
	weight = 150
	max_occurrences = 1
	earliest_start = 10000

/datum/round_event/holidayrole/santa
	windowtext1 = "Santa is coming to town! Do you want to be santa?"
	windowtext2 = "Ho ho ho!"
	var/mob/living/carbon/human/santa //who is our santa?

/datum/round_event/holidayrole/santa/announce()
	priority_announce("Santa is coming to town!", "Unknown Transmission")

/datum/round_event/holidayrole/santa/dressup(var/mob/M)
	santa = new /mob/living/carbon/human(pick(blobstart))
	activesanta = santa
	santa.key = M.key
	chosen = TRUE
	qdel(M)

	santa.real_name = "Santa Claus"
	santa.name = "Santa Claus"
	santa.mind.name = "Santa Claus"
	santa.mind.assigned_role = "Santa"
	santa.mind.special_role = "Santa"

	santa.hair_style = "Long Hair"
	santa.facial_hair_style = "Full Beard"
	santa.hair_color = "FFF"
	santa.facial_hair_color = "FFF"

	santa.equip_to_slot_or_del(new /obj/item/clothing/under/color/red, slot_w_uniform)
	santa.equip_to_slot_or_del(new /obj/item/clothing/suit/space/santa, slot_wear_suit)
	santa.equip_to_slot_or_del(new /obj/item/clothing/head/santa, slot_head)
	santa.equip_to_slot_or_del(new /obj/item/clothing/mask/breath, slot_wear_mask)
	santa.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/red, slot_gloves)
	santa.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/red, slot_shoes)
	santa.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/double, slot_belt)
	santa.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain/santa, slot_ears)
	santa.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/santabag, slot_back)
	santa.equip_to_slot_or_del(new /obj/item/device/flashlight, slot_r_store) //most blob spawn locations are really dark.

	var/obj/item/weapon/card/id/gold/santacard = new(santa)
	santacard.update_label("Santa Claus", "Santa")
	var/datum/job/captain/J = new/datum/job/captain
	santacard.access = J.get_access()
	santa.equip_to_slot_or_del(santacard, slot_wear_id)

	santa.update_icons()

	var/obj/item/weapon/storage/backpack/bag = santa.back
	var/obj/item/weapon/a_gift/gift = new(santa)
	while(bag.can_be_inserted(gift, 1))
		bag.handle_item_insertion(gift, 1)
		gift = new(santa)

	var/datum/objective/santa_objective = new()
	santa_objective.explanation_text = "Bring joy and presents to the station!"
	santa_objective.completed = 1 //lets cut our santas some slack.
	santa_objective.owner = santa.mind
	santa.mind.objectives += santa_objective
	santa.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/presents)
	santa.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/coal)
	var/obj/effect/proc_holder/spell/targeted/area_teleport/teleport/telespell = new(santa)
	telespell.clothes_req = 0 //santa robes aren't actually magical.
	santa.mind.AddSpell(telespell) //does the station have chimneys? WHO KNOWS!

	to_chat(santa, "<span class='boldannounce'>You are Santa! Your objective is to bring joy to the people on this station. You also have the duty of dictating whether someone is naughty or nice. You can conjure more presents using a spell, and there are several presents in your bag. Merry Christmas!</span>")
	to_chat(santa, "<span class='boldannounce'><span class='warning'>The Christmas Krampus</span> is here to punish naughty children. One of your spells allows you to summon coal. By placing someones name in that coal, you assign them to the naughty list.</span>")

/datum/species/whatchamaycallit
	name = "whatchamaycallit"
	id = "abductor"
	sexes = 0
	dangerous_existence = 1
	var/foundout

/datum/species/whatchamaycallit/spec_life(mob/living/carbon/human/H)
	if(H.health < 80)
		if(!foundout)
			poof(H)
	else if(H.health > 80 && foundout)
		foundout = FALSE
		to_chat(H, "<span class='green'>Well nice job, Mr.Whatchamaycallit. You've made it out.</span>")

/datum/species/whatchamaycallit/proc/poof(mob/living/carbon/human/H)
	for(var/obj/I in H.contents)
		H.unEquip(I)
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_w_uniform)
	to_chat(H, "<span class='green'>Well shit, Mr.Whatchamaycallit. You've been found out.</span>")
	H.color = "#00ff00" // it's green.
	foundout = TRUE

/datum/round_event_control/holidayrole/grinch
	name = "The Grinch is trying to ruin christmas! (Christmas)"
	holidayID = CHRISTMAS
	typepath = /datum/round_event/holidayrole/grinch
	weight = 15
	max_occurrences = 1
	earliest_start = 20000

/datum/round_event/holidayrole/grinch
	var/mob/living/carbon/human/grinch
	windowtext1 = "The Grinch is planning on ruining Christmas. Do you want to play as one?"
	windowtext2 = "And to all a very, very good night..."

/datum/round_event/holidayrole/grinch/announce()
	priority_announce("There's a rotten soul going around tredding over Christmas joy. Keep an eye on your eggnog. Centcomm out, for more milk and cookies.", "Central Command")

/datum/round_event/holidayrole/grinch/dressup(var/mob/M)
	grinch = new /mob/living/carbon/human(pick(latejoin))
	grinch.key = M.key
	chosen = TRUE
	qdel(M)

	to_chat(grinch, "<span class='green'>Oh... you're a mean one.</span>")
	grinch.real_name = "Grinch"
	grinch.name = "Fuzzy Green Alien" // don't take that the wrong way, freak.
	grinch.mind.assigned_role = "Grinch"
	grinch.mind.special_role = "Grinch"


	if(activesanta)
		activesanta.SetSleeping(0)
		to_chat(activesanta, "<span class='warning'>The hairs on the back of your neck stand up. A whatchamaycallit is here to ruin Christmas!</span>")

	grinch.set_species(/datum/species/whatchamaycallit)
	naughty_list += grinch


	grinch.equip_to_slot_or_del(new /obj/item/clothing/under/chameleon, slot_w_uniform)
	grinch.equip_to_slot_or_del(new /obj/item/clothing/suit/chameleon, slot_wear_suit)
	grinch.equip_to_slot_or_del(new /obj/item/clothing/mask/chameleon, slot_wear_mask)
	grinch.equip_to_slot_or_del(new /obj/item/clothing/head/chameleon, slot_head)
	grinch.equip_to_slot_or_del(new /obj/item/clothing/shoes/chameleon, slot_shoes)
	grinch.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/double, slot_belt)
	grinch.equip_to_slot_or_del(new /obj/item/device/radio/headset, slot_ears)
	grinch.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack, slot_back)

	if(grinch.back)
		var/obj/item/weapon/storage/backpack/backpack = grinch.back
		var/turf/turf = get_turf(grinch)
		var/obj/item/weapon/storage/backpack/santabag/S = new(turf) // and a bag to immitate santa!
		S.w_class = 4
		S.storage_slots = 21
		backpack.handle_item_insertion(S, 1, grinch)

	grinch.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/sordit)

	to_chat(grinch, "<font size=4><span class='notice'>You are an agent from the legion of whatchamaycallits</font>, a race of pissed off green-haired aliens that have to listen all day to a bodyless voice always tearing apart your self esteeem. And to top it off Santa has afflicted your entire planet to the naughty list, and has skipped it every year. However, now is the time to get back at them.</span>")
	to_chat(grinch, "<font size=2><span class='warning'>REMEMBER. YOU ARE HERE TO RUIN CHRISTMAS BY STEALING GIFTS AND/OR MAKING THEM WORSE. THIS DOES NOT ENTITLE YOU TO KILL ANYONE IN THE PURSUIT OF DOING THIS.</span></font>")

/obj/effect/proc_holder/spell/targeted/sordit
	name = "Remake Gift"
	charge_max = 1000
	cooldown_min = 700
	clothes_req = 0
	action_icon_state = "drain_life"
	invocation = "Santa~~~! I want some coal for Christmas!"
	invocation_type = "shout"
	range = -1
	level_max = 0
	include_user = 1
	var/obj/item/weapon/sord/grinch/dumbtoy

/obj/effect/proc_holder/spell/targeted/sordit/cast(list/targets, mob/user = usr)
	..()
	var/list/phrases = list ("Santa, I want a naughty magazine!", "Santa, how many generations have you ignored? MY SPECIES HAS BEEN NEGLECTED BY YOU FOR TOO LONG.", "You better not cry, you better not pout. Santa's an asshole.", "Useless fatlardass motherfucker hasn't done shit for me", "BAH HUMBUG. I HATE CHRISTMAS!!! LOOK AT ME I HATE CHRISTMAS!!!", "Santa~~~! I want a piece of shit for Christmas!", "I WISH YOU A HAPPY CHRISTMAS, AND CERTAIN DEATH BY NEXT YEAR!!", "I LOVE MAKING SHITTY PRESENTS!! LOOK AT ME I'M SANTA!!!")
	invocation = pick(phrases) // for next time.

	var/turf/T = get_turf(user)
	dumbtoy = new(T)
	user.put_in_hands(dumbtoy)


/obj/item/weapon/sord/grinch
	name = "evil christmas serpent"
	desc = "It's so goddamn terrible! It's awful! It's the worst thing ever! Pray thee for the soul that gets this on a fine christmas morn!"
	force = 10 // "self defence"
	w_class = 4
	var/obj/item/stolen
	var/used

/obj/item/weapon/sord/grinch/examine(mob/user)
	..()
	to_chat(user, "<span class='warning'>[name] is calling your name... it wants you to pick it up... and activate it in your hand..</span>")

/obj/item/weapon/sord/grinch/afterattack(atom/target, mob/user)
	if(used)
		return
	if(istype(target, /obj/item/))
		var/obj/item/I = target
		if(I.high_risk)
			to_chat(user, "<span class='warning'>You hear an unexpected voice crack from the great beyond...</span>")
			to_chat(user, "<span class='genesisgreen'>You can fuck right off.</span>")
			return
		stolen = I
		I.forceMove(src)
		name = "[I.name]"
		desc = "It's nothing but a lousy toy SORD. Use to be such a good [I]. [I.desc]"
		force = 0
		w_class = I.w_class
		used = TRUE

		addtimer(src, "revert", 1500, TRUE)
	..()

/obj/item/weapon/sord/grinch/proc/revert()
	if(!src)
		return

	var/turf/T = get_turf(src)
	if(T)
		stolen.forceMove(T)
		qdel(src)
	else
		message_admins("ERROR: [src] could not register a turf. Deleting the item stored inside of it [stolen] and the item. Report this to a coder.")
		qdel(stolen)
		qdel(src)

/obj/item/weapon/sord/grinch/Destroy()
	if(stolen)
		var/turf/T = get_turf(src)
		stolen.forceMove(T)
	..()

/obj/item/weapon/sord/grinch/attack_self(mob/user)
	..()
	if(user.mind)
		if(user.mind.special_role == "Santa")
			to_chat(user, "<span class='warning'>You reverse this buffoonery of a mechanism, and return [stolen] to it's true form.</span>")
			revert()
		else if (user.job == "Chaplain")
			to_chat(user, "<span class='warning'>This is the art of a wicked whatchamaycallit. Santa must be alerted!</span>")
		else if (user.job == ("Security Officer" || "Head of Security" || "Warden"))
			to_chat(user, "<span class='warning'>All of that fighting that you've been through, and centcomm can't even bring down a decent gift...</span>")
		else if (user.job == "Captain")
			to_chat(user, "<span class='warning'>The clown must be up to something... he's gotten creative with all of this negative aura around [src].</span>")
		else if (user.job == "Clown")
			to_chat(user, "<span class='warning'>Seems like the Captains taking a piss in your outmeal again... terrific.</span>")
		else if (user.job == "Mime")
			to_chat(user, "<span class='warning'>... It's shit.</span>")
		else if (user.job == "Chef")
			to_chat(user, "<span class='warning'>365 days of working your ass off in the kitchen to feed a research staff full of manchildren and this is the respect you get...</span>")
		else if (user.job == "Head of Personnel")
			to_chat(user, "<span class='warning'>Ian shouldn't have to look at this.. it'd break his spirit.</span>")
		else if (user.job == "Botanist")
			to_chat(user, "<span class='warning'>Another beaker of unstable mutagen could've been nicer...</span>")
		else
			to_chat(user, "<span class='warning'>Just as bad as coal. Thanks, Santa.</span>")

/datum/round_event_control/holidayrole/krampus
	name = "Krampus has been summoned (Christmas)"
	holidayID = CHRISTMAS
	typepath = /datum/round_event/holidayrole/krampus
	weight = 100
	max_occurrences = 1
	earliest_start = 11000

/datum/round_event/holidayrole/krampus
	var/mob/living/carbon/human/krampus
	windowtext1 = "Krampus has been summoned."
	windowtext2 = "Do you wish to prey on the naughty?"

/datum/species/demon
	name = "christmas demon"
	id = "krampus"
	limbs_id = "krampus"
	sexes = 0
	blacklisted = 1
	dangerous_existence = 1
	specflags = list(NOBREATH,NOGUNS,NODISMEMBER)
	burnmod = 2.1 // hey krampus, your horns are as crooked as your soul.
	brutemod = 2.1
	invis_sight = SEE_INVISIBLE_MINIMUM

/datum/species/demon/spec_life(mob/living/carbon/human/H)
	..()
	if(H.health <= 0)
		joy_to_the_world_krampus_has_fallen()

/datum/species/demon/on_species_gain(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/hooves, slot_shoes)

/datum/species/demon/on_species_loss(mob/living/carbon/human/H)
	..()
	if(H.shoes)
		if(istype(H.shoes, /obj/item/clothing/shoes/hooves))
			qdel(H.shoes)

/obj/item/clothing/shoes/hooves
	name = "hooves"
	icon_state = null
	item_state = null
	flags = NOSLIP | ABSTRACT | NODROP

/obj/item/coalbell
	name = "unholy bell"
	desc = "The sigil of the Christmas Krampus. Engraved into the bell is the demons own name. Purely crafted out of coal. Beware."
	icon_state = "krampus"
	item_state = "krampus"

/datum/round_event/holidayrole/krampus/dressup(var/mob/M)
	krampus = new /mob/living/carbon/human(pick(latejoin))
	activekrampus = krampus
	krampus.key = M.key
	chosen = TRUE
	qdel(M)

	krampus.set_species(/datum/species/demon, 1)
	krampus.update_body()
	krampus.icon_state = "krampus_s"

	krampus.real_name = "Krampus"
	krampus.name = "Krampus"
	krampus.mind.assigned_role = "Krampus"
	krampus.mind.special_role = "Krampus"

	krampus.equip_to_slot_or_del(new /obj/item/clothing/suit/space/santa, slot_wear_suit)
	krampus.equip_to_slot_or_del(new /obj/item/clothing/head/santa, slot_head)
	krampus.equip_to_slot_or_del(new /obj/item/weapon/bagofhorrors, slot_back)
	if(krampus.head)
		var/obj/O = krampus.head
		O.flags |= NODROP
	if(krampus.wear_suit)
		var/obj/I = krampus.wear_suit
		I.flags |= NODROP

	if(krampusweak)
		krampusweak = FALSE

	krampus.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/naughty)
	krampus.mind.AddSpell(new /obj/effect/proc_holder/spell/self/krampustele)
	krampus.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/unholybells)
	var/obj/effect/proc_holder/spell/dumbfire/fireball/hellish/H = new(src) // this is too fast.
	H.charge_max = 600
	H.cooldown_min = 500
	krampus.mind.AddSpell(new /obj/effect/proc_holder/spell/dumbfire/fireball/hellish)
	var/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/eth = new(krampus) // maybe the devils jaunt is better... hmmm
	eth.clothes_req = 0
	krampus.mind.AddSpell(eth)

	to_chat(krampus, "<span class='boldannounce'>You are the Christmas Krampus! Your job is to punish the naughty personnel of SS13, and to bring sinners to justice by turning them into your puppets!</span>")
	to_chat(krampus, "<span class='notice'>While you are an antagonist, you are not here to kill or attack anyone. Your purpose is only to punish naughty children.</span>")

	// CHRIST-, I MEAN... KRAMPUS DOES NOT LAST FOREVER
	spawn(10000)
		to_chat(activekrampus, "<span class='warning'>You can feel your power crumbling...It is almost time to vanish. Soon you'll be forced to retreat for the rest of the shift.</span>")
		spawn(5000)
			joy_to_the_world_krampus_has_fallen()

/obj/item/weapon/bagofhorrors
	name = "Krampus's Gift Bag"
	desc = "Do not look inside."
	icon = 'icons/obj/storage.dmi'
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 5
	force = 18
	slot_flags = SLOT_BACK
	var/list/stored_mobs = list()
	var/obj/effect/landmark/sacarea

/obj/item/weapon/bagofhorrors/New()
	..()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(!sacarea)
			if(L.name == "KrampusBag")
				sacarea = L

/obj/item/weapon/bagofhorrors/attack_self(mob/user)
	if(!iskrampus(user))
		if(user.mind)
			if(user.mind.assigned_role == "Santa")
				for(var/mob/M in stored_mobs)
					to_chat(user, "<span class='notice'>[M], the [M.job], is sitting inside.</span>")
				return
		to_chat(user, "<span class='warning'>You slowly look inside....</span><span clsss='genesisred'>AND A BLAST FLIES THROUGH YOUR SOUL AS IT'S MERGED WITH THE FOUL DEMONS OF THE UNDERWORLD!</span>")
		if(isliving(user))
			var/mob/living/L = user
			L.dust_animation()
		playsound(get_turf(user), 'sound/effects/supermatter.ogg', 50, 1)
		var/obj/effect/decal/cleanable/ash/ash = new(get_turf(user))
		var/mob/living/carbon/brain/b = new(ash)
		b.key = user.key
		user.forceMove(ash)
		user.status_flags |= GODMODE
		to_chat(b, "<span class='notice'>Nice job.</span>")
		to_chat(activekrampus, "<span class='notice'>[user.real_name] has attempted to open up your christmas bag in [get_area(user)]!</span>")

		sleep(200) // basically scared straight: but krampus style

		b.grab_ghost()
		user.key = b.key
		user.forceMove(get_turf(ash))
		qdel(b)
		to_chat(user, "<span class='warning'>You hear the ghostly cackle of Krampus in the background. He knowns who you are now. You better watch out...you best not cry...</span>")
		user.status_flags -= GODMODE
		return
	if(krampusweak)
		return

	for(var/mob/living/L in stored_mobs)
		L.Weaken(5)
		to_chat(L, "<span class='warning'>The ground starts shaking, everything becoming wobbly! Krampus is doing something with the bag!</span>")

	to_chat(user, "<span class='notice'>You rustle up [src] stunning everybody inside!</span>")

/obj/item/weapon/bagofhorrors/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target))
		return
	if(user == target)
		return
	if(!target.key)
		to_chat(user, "<span class='warning'>This one is braindead.</span>")
		return
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>You can't drop dead bodies into your bag.</span>")
		return
	if(target.stat == UNCONSCIOUS)
		if(isliving(target))
			var/mob/living/L = target
			if(L.health <= 0)
				to_chat(user, "<span class='warning'>They have to be awake to drop in.</span>")
				return
	if(!sacarea)
		to_chat(user, "<B>ALERT: REPORT TO A CODER/ADMIN. THIS ITEM IS BUGGED, AND CANNOT WORK PROPERLY.</B>")
		return

	if(krampusweak)
		return

	if(user.mind)
		if(user.mind.assigned_role == "Santa")
			to_chat(user, "<span class='warning'>It's not your place...</span>")
			return

	if(!iskrampus(user))
		return

	visible_message("<span class='warning'>[user] is trying to shove [target] into [src]!</span>")
	to_chat(target, "<span class='warning'>[user] begins to pick you up and shove you into [src].</span>")
	var/naughtymult = 1
	if((target in naughty_list)) // if they're naughty, we go 2x faster!
		naughtymult++

	if(do_after(user, 50/naughtymult, target = target))
		target.forceMove(get_turf(sacarea))
		stored_mobs += target
	else
		to_chat(user, "<span class='warning'>You lose grip of [target] releasing him from [src]'s pull.</span>")

/area/krampusbag
	name = "Krampus's Gift Bag"
	has_gravity = 1

/area/krampusworkshop
	name = "Krampus's Workshop"
	has_gravity = 1

/obj/item/toy/figure/cursed
	name = "cursed toy"
	icon_state = "assistant"
	var/mob/living/moving

/obj/item/toy/figure/cursed/New()
	..()
	desc = "It won't stop staring."

/*
/obj/item/toy/figure/cursed/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You scramble [src].</span>")
	var/obj/item/toy/figure/F =  pick(subtypesof(/obj/item/toy/figure))
	F = new F.type(src)
	icon_state = F.icon_state
	qdel(F)
*/

/obj/item/toy/figure/cursed/attackby(obj/item/weapon/W, mob/user, params)
	if(!iskrampus(user))
		return
	if(krampusweak)
		return
	if(moving)
		to_chat(user, "<span class='warning'>[src] has already been used.</span>")
		return

	if(istype(W, /obj/item/weapon/bagofhorrors))
		var/obj/item/weapon/bagofhorrors/BoH = W
		to_chat(user, "<span class='warning'>You begin to reach in and snatch one of the bodies of your bag.</span>")
		if(!BoH.stored_mobs.len)
			to_chat(user, "<span class='warning'>There's no one inside.</span>")
			return
		for(var/mob/M in BoH.stored_mobs)
			to_chat(M, "<span class='warning'>You see a claw drop into the bag! Krampus is looking for one of you!</span>")
		if(do_after(user, 700, target = src))
			var/mob/living/carbon/C = pick(BoH.stored_mobs)
			if(!C)
				to_chat(user, "<span class='warning'>There's nobody in [BoH]</span>")
				return

			to_chat(user, "<span class='warning'>You begin preparing [C].</span>")
			if(C.stat == DEAD)
				C.revive(full_heal = 1)
				C.regenerate_limbs(1)
			C.grab_ghost()
			C.flash_eyes(2)
			var/turf/T = get_turf(src)
			C.forceMove(T)
			BoH.stored_mobs -= C
			to_chat(C, "<span class='warning'>You see the light!</span>")
			C.Stun(30)
			sleep(100)
			var/mob/living/simple_animal/hostile/mimic/copy/cursed = new(get_turf(src), src, user)
			cursed.key = C.key
			desc = "The lost soul of [C] had been thrown in and out of this abomination. This is all that remains of [C.real_name]."
			moving = cursed
			to_chat(cursed, "<span class='warning'>You've been cursed by Krampus to live your life as an immortal toy!</span>")
			cursed.forceMove(pick(blobstart))
			to_chat(user, "<span class='warning'>You have sent [C]/[cursed] off into the station.</span>")
			C.forceMove(src)

/proc/joy_to_the_world_krampus_has_fallen()
	if(!activekrampus)
		return
	krampusweak = TRUE
	// we set free all of the naughty children
	for(var/obj/item/weapon/bagofhorrors/B in world)
		for(var/mob/living/L in B.stored_mobs)
			L.grab_ghost()
			L.forceMove(pick(latejoin))
			L.revive(full_heal = 1)
			L.regenerate_limbs(1)

	// we restore any of the cursed individuals
	for(var/obj/item/toy/figure/cursed/C in world)
		if(C.moving)
			var/mob/living/carbon/human/H = locate() in C
			C.moving.grab_ghost()
			if(H)
				H.forceMove(pick(latejoin))
				H.revive(full_heal = 1)
				H.key = C.moving.key

	for(var/mob/M in player_list)
		to_chat(M, "<span class='genesisgreen'>KRAMPUS IS DEAD! REJOICE!</span>")

	world << 'sound/christmas/krampusfarewell.ogg'
	to_chat(world, "I'll come get you... again.")
	for(var/mob/l in naughty_list)
		to_chat(l, "<span class='warning'>and for you it will be next year.</span>")
	qdel(activekrampus)
	sleep(100)
	priority_announce("Well... what are we waiting for? Celebrate!", null, 'sound/christmas/deckthehalls.ogg', "Nanotrasen")