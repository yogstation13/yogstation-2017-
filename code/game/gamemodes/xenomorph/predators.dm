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
		a suicide bomber to destroy your ships. Now it's time for action, your ship has appropriately discovered \
		xenomorph influence aboard a nearby plasma-research facility. Space Station 13.</span>"
	suit = /obj/item/clothing/suit/space/hardsuit/predator
//	pocket1 = /obj/item/weapon/shuriken
//	pocket2 = /obj/item/weapon/twohanded/spear/combistick
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
	new_spawn << "<span class='notice'>To summarize what your code is telling you. <BR>\
	1 - Stay on [on_lavaland ? "lavaland" : "the station"] if you're going to hunt. <BR>\
	2 - Do not hunt unarmed crewmembers or alien larvas.<BR>\
	3 - Do not \"Steal a Kill\" from your fellow Yautja Brothers.<BR>\
	4 - If you catch another Yautja breaking code you are free to attack them.<BR>\
	5 - If you fail your mission, then you are expected to kill yourself.<BR>\
	6 - If another hunters murders an innocent brother, then they are free to kill.<BR>\
	7 - Fight honorably."