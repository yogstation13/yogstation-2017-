/obj/effect/mob_spawn/human/predator
	name = "predator cyro sleeper"
	desc = "Sleep now great warrior, until the time is right."
	mob_name = "predator"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_s"
	density = TRUE
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/predator
	mob_type = /mob/living/carbon/human/predator
	flavour_text = "<span class='danger'>You are proud Yautja Warrior who had been recently hunting on an uninhabitable planet \
		ruled by the Xenomorph Species. To your surprise, a Nanotrasen-owned carrier landed on your planet \
		full of Deathsquad troopers that tore through the planet, captured the queen, blasted off, and left \
		a suicide bomber to destroy your ships. Now it's time for action because your ship has appropriately discovered \
		xenomorph influence aboard a nearby plasma-research facility. Space Station 13.</span>"
	suit = /obj/item/clothing/suit/space/hardsuit/predator
	uniform = /obj/item/clothing/under/predator
	shoes = /obj/item/clothing/shoes/predator
	belt = /obj/item/weapon/storage/belt/yautija
	back = /obj/item/weapon/predatortank
	var/on_lavaland = FALSE // uh oh. is this an easter egg?!

/obj/effect/mob_spawn/human/predator/special(mob/living/carbon/human/new_spawn)


	new /obj/item/weapon/gun/netgun(new_spawn.belt)
	new /obj/item/weapon/twohanded/spear/combistick(new_spawn.belt)
	new /obj/item/weapon/shuriken(new_spawn.belt)

	new_spawn.equip_to_slot_or_del(new/obj/item/yautijaholster(null), slot_wear_id)
	if(ticker)
		if(ticker.mode)
			ticker.mode.predators += new_spawn.mind

	new_spawn.mind.special_role = "Predator"

	var/tag = rand(1,255)
	//var/list/randname = list("Scarface")
	new_spawn.name = "Predator [tag]"


/*	var/dat = "<B>YAUTJA CODE</B><BR><BR> \
	1) Hunting - Never hunt within an unclaimed location. A location can only be properly claimed within the Yautja name if there is suitable game available. Suitable game is defined as any sort of prey that is armed and/or poses a threat big enough to a Yautja soldier. Locations expand up to entire stations to smaller shuttles. <BR> \
	2) Unworthy Game - Do not attack unworthy game. As law 1 puts it, if prey are not armed or showing any threat then you should not bother with them. This infringes on certain situations, for example a Yautja soldier shouldn't attempt to combat a lonely assistant with a toolbox. Only when that game is getting in the way of the hunt, a Yautja may strike. <BR>\
	3) Stealing Game - Interrupting another hunter or coming in between their prey during a hunt is looked down upon. This can happen when you decide to kill another hunter's wounded prey during a hunt or claim the kill for yourself or when you claim the trophy of an already fallen prey. This code breach can even happen when a hunter decides to rescue or save the prey. The outcome is a fight to the death between the two Yautja or they negotiate terms over the trophy. <BR> \
	4) Code Breach - If a hunter soldier breaks one of their codes, then they are no longer considered to be a Yautja. They must be killed when encountered and obliterated.<BR> \
	5) Failing a Hunt - When a Yautja fails to complete their mission, they are usually expected to take their own life. If they do not, then they must be killed and obliterated. <BR>\
	6) Murder of a hunter - If another hunter murders one of their own for a malicious reason when none of the codes were broken, they are considered no longer a Yautja and must be obliterated.<BR>\
	7) Worthy Game - If a game shows sport, than you may fight them honorably."
	new_spawn.mind.store_memory(dat, popup = TRUE, sane = FALSE)
*/
	new_spawn.memory += "<span class='notice'>To summarize what your code. <BR>\
	1 - Stay on [on_lavaland ? "lavaland" : "the station"] if you're going to hunt. <BR>\
	2 - Do not hunt unarmed crewmembers, alien larvas, or even facehuggers.<BR>\
	3 - Do not \"Steal a Kill\" from your fellow Yautja Brothers.<BR>\
	4 - If you catch another Yautja breaking code you are free to attack them.<BR>\
	5 - If you fail your mission you are expected to kill yourself.<BR>\
	6 - If another hunter murders an innocent brother, then they are free to kill.<BR>\
	7 - Fight honorably.<BR>"

	if(!on_lavaland)
		give_predator_objectives(new_spawn)

	new_spawn << new_spawn.memory

/obj/effect/mob_spawn/human/predator/proc/give_predator_objectives(mob/living)
	if(!living.mind)
		return
	var/queenobj

	if(prob(75))
		var/datum/objective/trophy/trophy_obj = new
		trophy_obj.owner = living
		trophy_obj.find_target_by_role()
		living.mind.objectives += trophy_obj
	else
		queenobj = TRUE
		var/datum/objective/queen/queen_obj = new
		queen_obj.owner = living
		living.mind.objectives += queen_obj

	if(prob(50))
		var/datum/objective/steal/alien/hunter/hunt_obj = new
		hunt_obj.owner = living
		living.mind.objectives += hunt_obj
	else
		var/datum/objective/steal/alien/worker/worker_obj = new
		worker_obj.owner = living
		living.mind.objectives += worker_obj

	if(!queenobj)
		if(prob(10))
			var/datum/objective/queen/queen_obj = new
			queen_obj.owner = living
			living.mind.objectives += queen_obj

	var/datum/objective/survive/survive = new
	survive.owner = living
	living.mind.objectives += survive

/datum/objective/steal/alien
	dangerrating = 30
	var/alien_type

/datum/objective/steal/alien/New()
	if(alien_type == "hunter")
		targetinfo = new/datum/objective_item/tail/hunter
	if(alien_type == "worker")
		targetinfo = new/datum/objective_item/tail/worker
	var/datum/objective_item/tail/T = targetinfo
	explanation_text = "Capture [T.num] alien [alien_type] tails"
	steal_target = targetinfo.targetitem

/datum/objective/steal/alien/hunter
	alien_type = "hunter"

/datum/objective/steal/alien/worker
	alien_type = "worker"

var/list/global_trophy_targets = list()

/datum/objective/trophy
	var/list/command_roles = list("Captain",
								"Head of Security",
								"Head of Personnel",
								"Chief Engineer",
								"Chief Medical Officer",
								"Research Director",
								"Quartermaster")
	var/obj/item/bodypart/trophy

/datum/objective/trophy/find_target_by_role(role, role_type=0, invert=0)
	for(var/datum/mind/possible_target in ticker.minds)
		if(!(possible_target in global_trophy_targets))
			if(possible_target.current.job in command_roles)
				target = possible_target
				if(ishuman(target.current))
					var/mob/living/carbon/human/H = target.current
					trophy = H.get_bodypart("head")
				global_trophy_targets += target
				break

	update_explanation_text()

/datum/objective/trophy/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Claim the head of [target.name], the [target.current.job]."
	else
		explanation_text = "Free Objective"

/datum/objective/trophy/check_completion()
	if(!target)
		return TRUE
	if(!owner.current || owner.current.stat == DEAD)
		return FALSE
	if(!trophy)
		return FALSE
	if(trophy.loc == owner.current)
		return TRUE
	return FALSE

/datum/objective/queen
	dangerrating = 100
	explanation_text = "Assassinate the Alien Queen. Bring their corpse onto the droppod."
	var/mob/living/carbon/alien/humanoid/queen

/datum/objective/queen/New()
	for(var/mob/living/carbon/alien/humanoid/royal/queen/Q in living_mob_list)
		if(Q)
			if(compareAlienSuffix(Q, col2 = ticker.mode.queensuffix))
				queen = Q
				break

/datum/objective/queen/check_completion()
	if(queen)
		if(queen.stat == DEAD || issilicon(queen) || isbrain(queen) || queen.z > 6 || !queen.ckey)
			return 1
		return 0
	return 1

/datum/objective_item/tail
	name = "steal 5 tails"
	targetitem = /obj/item/weapon/xenomorphtail
	difficulty = 50
	var/num
	var/tail_type

/datum/objective_item/tail/New()
	..()
	num = rand(5,8)
	name = "steal [num] [tail_type] tails"

/datum/objective_item/tail/check_special_completion(obj/item/weapon/xenomorphtail/tail)
	var/amount = text2num(name)
	var/captured
	for(var/obj/item/weapon/xenomorphtail/H in tail.loc)
		if(istype(H, targetitem))
			captured++
	if(captured >= amount)
		return 1
	return 0

/datum/objective_item/tail/hunter
	targetitem = /obj/item/weapon/xenomorphtail/hunter
	tail_type = "hunter"

/datum/objective_item/tail/worker
	targetitem = /obj/item/weapon/xenomorphtail/worker
	tail_type = "worker"
