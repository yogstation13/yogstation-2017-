// A very special plant, deserving it's own file.

/obj/item/seeds/replicapod
	name = "pack of replica pod seeds"
	desc = "These seeds grow into replica pods. They say these are used to harvest humans."
	icon_state = "seed-replicapod"
	species = "replicapod"
	plantname = "Replica Pod"
	product = /mob/living/carbon/human //verrry special -- Urist
	lifespan = 50
	endurance = 8
	maturation = 10
	production = 1
	yield = 1 //seeds if there isn't a dna inside
	oneharvest = 1
	potency = 30
	var/ckey = null
	var/realName = null
	var/datum/mind/mind = null
	var/blood_gender = null
	var/blood_type = null
	var/list/features = null
	var/factions = null
	var/contains_sample = 0

/obj/item/seeds/replicapod/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/reagent_containers/syringe))
		if(!contains_sample)
			for(var/datum/reagent/blood/bloodSample in W.reagents.reagent_list)
				if(bloodSample.data["mind"] && bloodSample.data["cloneable"] == 1)
					mind = bloodSample.data["mind"]
					ckey = bloodSample.data["ckey"]
					realName = bloodSample.data["real_name"]
					blood_gender = bloodSample.data["gender"]
					blood_type = bloodSample.data["blood_type"]
					features = bloodSample.data["features"]
					factions = bloodSample.data["factions"]
					W.reagents.clear_reagents()
					to_chat(user, "<span class='notice'>You inject the contents of the syringe into the seeds.</span>")
					contains_sample = 1
				else
					to_chat(user, "<span class='warning'>The seeds reject the sample!</span>")
		else
			to_chat(user, "<span class='warning'>The seeds already contain a genetic sample!</span>")
	..()

/obj/item/seeds/replicapod/get_analyzer_text()
	var/text = ..()
	if(contains_sample)
		text += "\n It contains a blood sample!"
	return text


/obj/item/seeds/replicapod/harvest(mob/user = usr) //now that one is fun -- Urist
	var/obj/machinery/hydroponics/parent = loc
	var/make_phytosian = 0
	var/ckey_holder = null
	if(config.revival_pod_plants)
		if(ckey)
			for(var/mob/M in player_list)
				if(istype(M, /mob/dead/observer))
					var/mob/dead/observer/O = M
					if(O.ckey == ckey && O.can_reenter_corpse)
						make_phytosian = 1
						break
				else
					if(M.ckey == ckey && M.stat == DEAD && !M.suiciding)
						make_phytosian = 1
						if(istype(M, /mob/living))
							var/mob/living/L = M
							make_phytosian = !L.hellbound
						break
		else //If the player has ghosted from his corpse before blood was drawn, his ckey is no longer attached to the mob, so we need to match up the cloned player through the mind key
			for(var/mob/M in player_list)
				if(mind && M.mind && ckey(M.mind.key) == ckey(mind.key) && M.ckey && M.client && M.stat == 2 && !M.suiciding)
					if(istype(M, /mob/dead/observer))
						var/mob/dead/observer/O = M
						if(!O.can_reenter_corpse)
							break
					make_phytosian = 1
					if(istype(M, /mob/living))
						var/mob/living/L = M
						make_phytosian = !L.hellbound
					ckey_holder = M.ckey
					break

	if(make_phytosian)	//all conditions met!
		var/mob/living/carbon/human/phytosian = new /mob/living/carbon/human(parent.loc)
		if(realName)
			phytosian.real_name = realName
		else
			phytosian.real_name = "Phytosian [rand(0,999)]"
		mind.transfer_to(phytosian)
		if(ckey)
			phytosian.ckey = ckey
		else
			phytosian.ckey = ckey_holder
		phytosian.gender = blood_gender
		phytosian.faction |= factions
		if(!features["mcolor"])
			features["mcolor"] = "#59CE00"
		if(prob(90))
			phytosian.hardset_dna(null,null,phytosian.real_name,blood_type,/datum/species/plant,features)
		else
			phytosian.hardset_dna(null,null,phytosian.real_name,blood_type,/datum/species/plant/pod,features)//Discard SE's and UI's, podman cloning is inaccurate, and always make them a podman
		phytosian.set_cloned_appearance()

	else //else, one packet of seeds. maybe two
		var/seed_count = 1
		if(prob(getYield() * 20))
			seed_count++
		for(var/i=0,i<seed_count,i++)
			var/obj/item/seeds/replicapod/harvestseeds = src.Copy()
			harvestseeds.loc = user.loc

	parent.update_tray()