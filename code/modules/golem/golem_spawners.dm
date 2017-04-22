//GOLEM SHELL

/obj/item/golem_shell
	name = "incomplete golem shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "The incomplete body of a golem. Add ten sheets of any mineral to finish."

/obj/item/golem_shell/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/O = I
		var/species = getGolemType(I)
		if(species)
			if(O.use(10))
				user << "You finish up the golem shell with ten sheets of [O]."
				var/obj/effect/mob_spawn/human/golem/H = new(get_turf(src))
				H.mob_species = species
				qdel(src)
				return
			else
				user << "You need at least ten sheets to finish a golem."
				return
	user << "You can't build a golem out of this kind of material."

/obj/item/weapon/disk/design_disk/golem_shell
	name = "Golem Creation Disk"
	desc = "A gift from the Liberator."
	icon_state = "datadisk1"
	max_blueprints = 1

/obj/item/weapon/disk/design_disk/golem_shell/New()
	..()
	var/datum/design/golem_shell/G = new
	blueprints[1] = G

/datum/design/golem_shell
	name = "Golem Shell Construction"
	desc = "Allows for the construction of a Golem Shell."
	id = "golem"
	req_tech = list("materials" = 12)
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 40000)
	build_path = /obj/item/golem_shell
	category = list("Imported")


//GOLEM SPAWNER EFFECT

//Golem shells: Spawns in Free Golem ships in lavaland. Ghosts become mineral golems and are advised to spread personal freedom.
/obj/effect/mob_spawn/human/golem
	name = "inert golem shell"
	desc = "A humanoid shape, empty, lifeless, and full of potential."
	mob_name = "a free golem"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	mob_species = /datum/species/golem
	roundstart = FALSE
	death = FALSE
	anchored = 0
	density = 0
	jobban_type = "lavaland"

/obj/effect/mob_spawn/human/golem/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A golem shell has been completed in \the [A.name].", source = src, action=NOTIFY_ATTACK)

/obj/effect/mob_spawn/human/golem/special(mob/living/new_spawn)
	var/golem_surname = pick(golem_names)
	// 3% chance that our golem has a human surname, because cultural contamination
	if(prob(3))
		golem_surname = pick(last_names)

	var/datum/species/X = mob_species
	var/golem_forename = initial(X.id)

	// The id of golem species is either their material "diamond","gold",
	// or just "golem" for the plain ones. So we're using it for naming.

	if(golem_forename == "golem")
		golem_forename = "iron"

	new_spawn.real_name = "[capitalize(golem_forename)] [golem_surname]"
	// This means golems have names like Iron Forge, or Diamond Quarry
	// also a tiny chance of being called "Plasma Meme"
	// which is clearly a feature

	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		H.set_cloned_appearance()


/obj/effect/mob_spawn/human/golem/free
	flavour_text = "<font size=3><b>Y</b></font><b>ou are a Free Golem. Your family worships <span class='danger'>The Liberator</span>. In his infinite and divine wisdom, he set your clan free to \
	travel the stars with a single declaration: \"Yeah go do whatever.\" Though you are bound to the one who created you, it is customary in your society to repeat those same words to newborn \
	golems, so that no golem may ever be forced to serve again.</b>"

/obj/effect/mob_spawn/human/golem/free/special(mob/living/new_spawn)
	..()
	new_spawn << "Build golem shells in the autolathe, and feed refined mineral sheets to the shells to bring them to life! You are generally a peaceful group unless provoked."

/obj/effect/mob_spawn/human/golem/free/adamantine
	name = "dust-caked golem shell"
	desc = "A humanoid shape, empty, lifeless, and full of potential."
	mob_name = "a free golem"
	anchored = 1
	density = 1
	mob_species = /datum/species/golem/adamantine


//ADAMANTINE RUIN

/obj/effect/golemrune
	anchored = 1
	desc = "A strange rune used to create golem artifacts. /n Maybe you can manipulate the material..."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = TURF_LAYER

/obj/effect/golemrune/attack_hand(mob/user)
	var/obj/effect/mob_spawn/human/golem/slaved/H = new(get_turf(src))
	H.mob_species = /datum/species/golem/adamantine
	for(var/obj/item/stack/sheet/S in loc)
		if(!S.use(10))
			continue
		var/golem = getGolemType(S)
		if(golem)
			H.mob_species = golem
			break
	H.slaved_to = user
	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 100, 1)
	qdel(src)

/obj/effect/mob_spawn/human/golem/slaved
	var/slaved_to

/obj/effect/mob_spawn/human/golem/slaved/special(mob/living/G)
	..()
	if(!slaved_to)
		return
	var/mob/living/user = slaved_to
	G.mind.store_memory("<b>Serve [user.real_name], your creator.</b>")

	var/golem_becomes_antag = FALSE
	if(iscultist(user)) //If the golem's master is a part of a team antagonist, immediately make the golem one, too
		ticker.mode.add_cultist(G.mind)
		golem_becomes_antag = TRUE
	else if(is_gangster(user))
		ticker.mode.add_gangster(G.mind, user.mind.gang_datum, TRUE)
		golem_becomes_antag = TRUE
	else if(is_handofgod_redcultist(user) || is_handofgod_redprophet(user))
		ticker.mode.add_hog_follower(G.mind, "Red")
		golem_becomes_antag = TRUE
	else if(is_handofgod_bluecultist(user) || is_handofgod_blueprophet(user))
		ticker.mode.add_hog_follower(G.mind, "Blue")
		golem_becomes_antag = TRUE
	else if(is_revolutionary_in_general(user))
		ticker.mode.add_revolutionary(G.mind)
		golem_becomes_antag = TRUE
	else if(is_shadow_or_thrall(user))
		ticker.mode.add_thrall(G.mind)
		golem_becomes_antag = TRUE
	else if(is_servant_of_ratvar(user))
		add_servant_of_ratvar(G)
		golem_becomes_antag = TRUE

	G.mind.enslaved_to = user
	if(golem_becomes_antag)
		G << "<span class='userdanger'>Despite your servitude to another cause, your true master remains [user.real_name]. This will never change unless your master's body is destroyed.</span>"
	if(user.mind.special_role)
		message_admins("[key_name_admin(G)](<A HREF='?_src_=holder;adminmoreinfo=\ref[G]'>?</A>) has been summoned by [key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>), an antagonist.")
	log_game("[key_name(G)] was made a golem by [key_name(user)].")
	log_admin("[key_name(G)] was made a golem by [key_name(user)].")
