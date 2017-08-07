/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	maxHealth = 50
	health = 50
	healable = 0
	speak_emote = list("hisses")
	emote_hear = list("wails.","screeches.")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	speak_chance = 1
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "metaphysically strikes"
	minbodytemp = 0
	maxbodytemp = INFINITY
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	speed = -1
	stop_automated_movement = 1
	faction = list("cult")
	status_flags = list(CANPUSH)
	flying = 1
	loot = list(/obj/item/weapon/ectoplasm)
	del_on_death = 1
	deathmessage = "lets out a contented sigh as their form unwinds."
	var/affiliation = "Cult"

/mob/living/simple_animal/shade/New()
	..()
	addtimer(src, "set_affiliation", 5)

/mob/living/simple_animal/shade/canSuicide()
	if(istype(loc, /obj/item/device/soulstone)) //do not suicide inside the soulstone
		return 0
	return ..()

/mob/living/simple_animal/shade/Process_Spacemove(movement_dir = 0)
	return TRUE //this doesn't make much sense; you'd think TRUE would mean it'd process spacemove but it means it doesn't

/mob/living/simple_animal/shade/attack_animal(mob/living/simple_animal/M)
	if(istype(M, /mob/living/simple_animal/hostile/construct/builder))
		if(M.health < M.maxHealth)
			M.adjustHealth(-25)
			Beam(src,icon_state="sendbeam",icon='icons/effects/effects.dmi',time=4)
			M.visible_message("<span class='danger'>[src] heals \the <b>[M]</b>.</span>", \
					   "<span class='cult'>You heal <b>[M]</b>, leaving <b>[M]</b> at <b>[health]/[maxHealth]</b> health.</span>")
		else
			src << "<span class='cult'>You cannot heal <b>[M]</b>, as it is unharmed!</span>"
	else if(src != M)
		..()

/mob/living/simple_animal/shade/attackby(obj/item/O, mob/user, params)  //Marker -Agouri
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/SS = O
		SS.transfer_soul("SHADE", src, user)
	else
		..()

/mob/living/simple_animal/shade/examine(mob/user)
	. = ..()
	if((iscultist(user) || iswizard(user)) && (!src.key || !src.client))
		user << "<span class='danger'>You can also tell that they've lost all conscious awareness and have become as engaging as a blank wall.</span>"

/mob/living/simple_animal/shade/proc/set_affiliation(var/_affiliation)
	if(_affiliation)
		affiliation = _affiliation
	else if(istype(loc, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = loc
		affiliation = S.affiliation
	switch(affiliation)
		if("Cult")
			faction |= list("cult")
			color = color2hex("red")
		if("Wizard")
			faction |= list("wizard")
			ticker.mode.update_wiz_icons_added(mind)
			color = color2hex("blue")
		if("Neutral")
			color = color2hex("lime")
		else
			color = color2hex(affiliation)