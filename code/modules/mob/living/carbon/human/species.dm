// This code handles different species in the game.

#define HEAT_DAMAGE_LEVEL_1 2
#define HEAT_DAMAGE_LEVEL_2 3
#define HEAT_DAMAGE_LEVEL_3 8

#define COLD_DAMAGE_LEVEL_1 0.5
#define COLD_DAMAGE_LEVEL_2 1.5
#define COLD_DAMAGE_LEVEL_3 3


/datum/species
	var/id = null		// if the game needs to manually check your race to do something not included in a proc here, it will use this
	var/limbs_id = null	//this is used if you want to use a different species limb sprites. Mainly used for angels as they look like humans.
	var/name = null		// this is the fluff name. these will be left generic (such as 'Lizardperson' for the lizard race) so servers can change them to whatever
	var/roundstart = 0	// can this mob be chosen at roundstart? (assuming the config option is checked?)
	var/default_color = "#FFF"	// if alien colors are disabled, this is the color that will be used by that race

	var/sexes = 1		// whether or not the race has sexual characteristics. at the moment this is only 0 for skeletons and shadows

	var/face_y_offset = 0
	var/hair_y_offset = 0

	var/hair_color = null	// this allows races to have specific hair colors... if null, it uses the H's hair/facial hair colors. if "mutcolor", it uses the H's mutant_color
	var/hair_alpha = 255	// the alpha used by the hair. 255 is completely solid, 0 is transparent.

	var/use_skintones = 0	// does it use skintones or not? (spoiler alert this is only used by humans)
	var/exotic_blood = ""	// If your race wants to bleed something other than bog standard blood, change this to reagent id.
	var/exotic_bloodtype = "" //If your race uses a non standard bloodtype (A+, O-, AB-, etc)
	var/meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human //What the species drops on gibbing
	var/skinned_type = /obj/item/stack/sheet/animalhide/generic
	var/list/no_equip = list()	// slots the race can't equip stuff to
	var/nojumpsuit = 0	// this is sorta... weird. it basically lets you equip stuff that usually needs jumpsuits without one, like belts and pockets and ids
	var/blacklisted = 0 //Flag to exclude from green slime core species.
	var/dangerous_existence = null //A flag for transformation spells that tells them "hey if you turn a person into one of these without preperation, they'll probably die!"
	var/say_mod = "says"	// affects the speech message
	var/list/default_features = list() // Default mutant bodyparts for this species. Don't forget to set one for every mutant bodypart you allow this species to have.
	var/list/mutant_bodyparts = list() 	// Parts of the body that are diferent enough from the standard human model that they cause clipping with some equipment
	var/list/mutant_organs = list(/obj/item/organ/tongue)		//Internal organs that are unique to this race.
	var/speedmod = 0	// this affects the race's speed. positive numbers make it move slower, negative numbers make it move faster
	var/armor = 0		// overall defense for the race... or less defense, if it's negative.
	var/brutemod = 1
	var/burnmod = 1
	var/coldmod = 1
	var/heatmod = 1
	var/toxmod = 1
	var/acidmod = 1
	var/clonemod = 1
	var/staminamod = 1
	var/brainmod = 1
	var/stamina_recover_normal = 3
	var/stamina_recover_sleeping = 10
	var/stunmod = 1		// multiplier for stun duration
	var/radiation_faint_threshhold = 100
	var/radiation_effect_mod = 1
	var/punchdamagelow = 0       //lowest possible punch damage
	var/punchdamagehigh = 9      //highest possible punch damage
	var/punchstunthreshold = 9//damage at which punches from this race will stun //yes it should be to the attacked race but it's not useful that way even if it's logical
	var/siemens_coeff = 1 //base electrocution coefficient
<<<<<<< HEAD
	var/limb_default_status = ORGAN_ORGANIC
	var/exotic_damage_overlay = ""
	var/fixed_mut_color = "" //to use MUTCOLOR with a fixed color that's independent of dna.feature["mcolor"]
	var/can_grab_items = TRUE
=======
	var/damage_overlay_type = "human" //what kind of damage overlays (if any) appear on our species when wounded?
	var/fixed_mut_color = "" //to use MUTCOLOR with a fixed color that's independent of dna.feature["mcolor"]
>>>>>>> masterTGbranch

<<<<<<< HEAD
	var/invis_sight = SEE_INVISIBLE_LIVING
	var/sight_mod = 0 //Add these flags to your mob's sight flag. For shadowlings and things to see people through walls.
	var/darksight = 2
	var/disease_resist = 0

=======
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
	// species flags. these can be found in flags.dm
	var/list/species_traits = list()

	var/attack_verb = "punch"	// punch-specific attack verb
	var/sound/attack_sound = 'sound/weapons/punch1.ogg'
	var/sound/miss_sound = 'sound/weapons/punchmiss.ogg'

	var/mob/living/list/ignored_by = list()	// list of mobs that will ignore this species
	//Breathing!
	var/obj/item/organ/lungs/mutantlungs = null
	var/breathid = "o2"

	//Flight and floating
	var/override_float = 0

<<<<<<< HEAD
	var/high_temp_level_1 = BODYTEMP_HEAT_DAMAGE_LEVEL_1
	var/high_temp_level_2 = BODYTEMP_HEAT_DAMAGE_LEVEL_2
	var/high_temp_level_3 = BODYTEMP_HEAT_DAMAGE_LEVEL_3
	var/low_temp_level_1 = BODYTEMP_COLD_DAMAGE_LEVEL_1
	var/low_temp_level_2 = BODYTEMP_COLD_DAMAGE_LEVEL_2
	var/low_temp_level_3 = BODYTEMP_COLD_DAMAGE_LEVEL_3

	var/warning_low_pressure = WARNING_LOW_PRESSURE
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE
	var/warning_high_pressure = WARNING_HIGH_PRESSURE
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE
	var/highpressure_mod = 1
	var/lowpressure_mod = 1

	var/cold_slowdown_factor = COLD_SLOWDOWN_FACTOR //the lower this is the slower you go in the cold

=======

	//Eyes
	var/obj/item/organ/eyes/mutanteyes = /obj/item/organ/eyes
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
	///////////
	// PROCS //
	///////////


/datum/species/New()

	if(!limbs_id)	//if we havent set a limbs id to use, just use our own id
		limbs_id = id
	..()


/datum/species/proc/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_name(gender)

	var/randname
	if(gender == MALE)
		randname = pick(GLOB.first_names_male)
	else
		randname = pick(GLOB.first_names_female)

	if(lastname)
		randname += " [lastname]"
	else
		randname += " [pick(GLOB.last_names)]"

	return randname


//Please override this locally if you want to define when what species qualifies for what rank if human authority is enforced.
/datum/species/proc/qualifies_for_rank(rank, list/features)
	if(rank in GLOB.command_positions)
		return 0
	return 1

/datum/species/proc/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	// Drop the items the new species can't wear
	for(var/slot_id in no_equip)
		var/obj/item/thing = C.get_item_by_slot(slot_id)
		if(thing && (!thing.species_exception || !is_type_in_list(src,thing.species_exception)))
			C.dropItemToGround(thing)

	C.prepare_huds()
	if(limb_default_status)
		for(var/V in C.bodyparts)
			var/obj/item/bodypart/BP = V
			BP.change_bodypart_status(limb_default_status)

	var/obj/item/organ/heart/heart = C.getorganslot("heart")
	var/obj/item/organ/lungs/lungs = C.getorganslot("lungs")
	var/obj/item/organ/appendix/appendix = C.getorganslot("appendix")
	var/obj/item/organ/eyes/eyes = C.getorganslot("eye_sight")

	if((NOBLOOD in species_traits) && heart)
		heart.Remove(C)
		qdel(heart)
	else if((!(NOBLOOD in species_traits)) && (!heart))
		heart = new()
		heart.Insert(C, 1)
	if(lungs)
		qdel(lungs)
		lungs = null

	if(eyes)
		qdel(eyes)
		eyes = new mutanteyes
		eyes.Insert(C)

	if((!(NOBREATH in species_traits)) && !lungs)
		if(mutantlungs)
			lungs = new mutantlungs()
		else
			lungs = new()
		lungs.Insert(C, 1)

	if((NOHUNGER in species_traits) && appendix)
		qdel(appendix)
	else if((!(NOHUNGER in species_traits)) && (!appendix))
		appendix = new()
		appendix.Insert(C, 1)

	for(var/path in mutant_organs)
		var/obj/item/organ/I = new path()
		I.Insert(C, 1)

	if(exotic_bloodtype && C.dna.blood_type != exotic_bloodtype)
		C.dna.blood_type = exotic_bloodtype
	if(("legs" in C.dna.species.mutant_bodyparts) && C.dna.features["legs"] == "Digitigrade Legs")
		species_traits += DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)

/datum/species/proc/on_species_loss(mob/living/carbon/C)
	if(C.dna.species.exotic_bloodtype)
		C.dna.blood_type = random_blood_type()
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(TRUE)

/datum/species/proc/handle_hair(mob/living/carbon/human/H, forced_colour)
	H.remove_overlay(HAIR_LAYER)

	var/obj/item/bodypart/head/HD = H.get_bodypart("head")
	if(!HD) //Decapitated
		return

	if(H.disabilities & HUSK)
		return
	var/datum/sprite_accessory/S
	var/list/standing = list()

	var/hair_hidden = FALSE //ignored if the matching dynamic_X_suffix is non-empty
	var/facialhair_hidden = FALSE // ^

	var/dynamic_hair_suffix = "" //if this is non-null, and hair+suffix matches an iconstate, then we render that hair instead
	var/dynamic_fhair_suffix = ""

	//we check if our hat or helmet hides our facial hair.
	if(H.head)
		var/obj/item/I = H.head
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			dynamic_fhair_suffix = C.dynamic_fhair_suffix
		if(I.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		dynamic_fhair_suffix = M.dynamic_fhair_suffix //mask > head in terms of facial hair
		if(M.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.facial_hair_style && (FACEHAIR in species_traits) && (!facialhair_hidden || dynamic_fhair_suffix))
		S = GLOB.facial_hair_styles_list[H.facial_hair_style]
		if(S)

			//List of all valid dynamic_fhair_suffixes
			var/static/list/fextensions
			if(!fextensions)
				var/icon/fhair_extensions = icon('icons/mob/facialhair_extensions.dmi')
				fextensions = list()
				for(var/s in fhair_extensions.IconStates(1))
					fextensions[s] = TRUE
				qdel(fhair_extensions)

			//Is hair+dynamic_fhair_suffix a valid iconstate?
			var/fhair_state = S.icon_state
			var/fhair_file = S.icon
			if(fextensions[fhair_state+dynamic_fhair_suffix])
				fhair_state += dynamic_fhair_suffix
				fhair_file = 'icons/mob/facialhair_extensions.dmi'

			var/image/img_facial = image("icon" = fhair_file, "icon_state" = fhair_state, "layer" = -HAIR_LAYER)

			if(!forced_colour)
				if(hair_color)
					if(hair_color == "mutcolor")
						img_facial.color = "#" + H.dna.features["mcolor"]
					else
						img_facial.color = "#" + hair_color
				else
					img_facial.color = "#" + H.facial_hair_color
			else
				img_facial.color = forced_colour

			img_facial.alpha = hair_alpha

			standing += img_facial

	if(H.head)
		var/obj/item/I = H.head
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix
		if(I.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		if(!dynamic_hair_suffix) //head > mask in terms of head hair
			dynamic_hair_suffix = M.dynamic_hair_suffix
		if(M.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(!hair_hidden || dynamic_hair_suffix)
		if(!hair_hidden && !H.getorgan(/obj/item/organ/brain)) //Applies the debrained overlay if there is no brain
			if(!(NOBLOOD in species_traits))
				standing += image("icon"='icons/mob/human_face.dmi', "icon_state" = "debrained", "layer" = -HAIR_LAYER)

		else if(H.hair_style && (HAIR in species_traits))
			S = GLOB.hair_styles_list[H.hair_style]
			if(S)

				//List of all valid dynamic_hair_suffixes
				var/static/list/extensions
				if(!extensions)
					var/icon/hair_extensions = icon('icons/mob/hair_extensions.dmi') //hehe
					extensions = list()
					for(var/s in hair_extensions.IconStates(1))
						extensions[s] = TRUE
					qdel(hair_extensions)

				//Is hair+dynamic_hair_suffix a valid iconstate?
				var/hair_state = S.icon_state
				var/hair_file = S.icon
				if(extensions[hair_state+dynamic_hair_suffix])
					hair_state += dynamic_hair_suffix
					hair_file = 'icons/mob/hair_extensions.dmi'

				var/image/img_hair = image("icon" = hair_file, "icon_state" = hair_state, "layer" = -HAIR_LAYER)

				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							img_hair.color = "#" + H.dna.features["mcolor"]
						else
							img_hair.color = "#" + hair_color
					else
						img_hair.color = "#" + H.hair_color
				else
					img_hair.color = forced_colour
				img_hair.alpha = hair_alpha
				img_hair.pixel_y += hair_y_offset
				standing += img_hair

	if(standing.len)
		H.overlays_standing[HAIR_LAYER]	= standing

	H.apply_overlay(HAIR_LAYER)

/datum/species/proc/handle_body(mob/living/carbon/human/H)
	H.remove_overlay(BODY_LAYER)

	var/list/standing	= list()

	var/obj/item/bodypart/head/HD = H.get_bodypart("head")


	// eyes
	var/has_eyes = TRUE

	if(!H.getorgan(/obj/item/organ/eyes) && HD)
		standing += image("icon"='icons/mob/human_face.dmi', "icon_state" = "eyes_missing", "layer" = -BODY_LAYER)
		has_eyes = FALSE

	if(!(H.disabilities & HUSK))
		// lipstick
		if(H.lip_style && (LIPS in species_traits) && HD)
			var/image/lips = image("icon"='icons/mob/human_face.dmi', "icon_state"="lips_[H.lip_style]", "layer" = -BODY_LAYER)
			lips.color = H.lip_color
			lips.pixel_y += face_y_offset
			standing	+= lips

		// eyes
		if((EYECOLOR in species_traits) && HD && has_eyes)
			var/image/img_eyes = image("icon" = 'icons/mob/human_face.dmi', "icon_state" = "eyes", "layer" = -BODY_LAYER)
			img_eyes.color = "#" + H.eye_color
			img_eyes.pixel_y += face_y_offset
			standing	+= img_eyes

	//Underwear, Undershirts & Socks
	if(H.underwear)
		var/datum/sprite_accessory/underwear/underwear = GLOB.underwear_list[H.underwear]
		if(underwear)
			standing	+= image("icon"=underwear.icon, "icon_state"="[underwear.icon_state]", "layer"=-BODY_LAYER)

	if(H.undershirt)
		var/datum/sprite_accessory/undershirt/undershirt = GLOB.undershirt_list[H.undershirt]
		if(undershirt)
			if(H.dna.species.sexes && H.gender == FEMALE)
				standing	+=	wear_female_version("[undershirt.icon_state]", undershirt.icon, BODY_LAYER)
			else
				standing	+= image("icon"=undershirt.icon, "icon_state"="[undershirt.icon_state]", "layer"=-BODY_LAYER)

	if(H.socks && H.get_num_legs() >= 2 && !(DIGITIGRADE in species_traits))
		var/datum/sprite_accessory/socks/socks = GLOB.socks_list[H.socks]
		if(socks)
			standing	+= image("icon"=socks.icon, "icon_state"="[socks.icon_state]", "layer"=-BODY_LAYER)

	if(standing.len)
		H.overlays_standing[BODY_LAYER] = standing

	H.apply_overlay(BODY_LAYER)
	handle_mutant_bodyparts(H)

/datum/species/proc/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	var/list/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	var/list/standing	= list()

	H.remove_overlay(BODY_BEHIND_LAYER)
	H.remove_overlay(BODY_ADJ_LAYER)
	H.remove_overlay(BODY_FRONT_LAYER)

	if(!mutant_bodyparts)
		return

	var/obj/item/bodypart/head/HD = H.get_bodypart("head")

	if("tail_lizard" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_lizard"

	if("waggingtail_lizard" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_lizard"
		else if ("tail_lizard" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_lizard"

	if("tail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_human"


	if("waggingtail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_human"
		else if ("tail_human" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_human"

	if("spines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "spines"

	if("waggingspines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingspines"
		else if ("tail" in mutant_bodyparts)
			bodyparts_to_add -= "waggingspines"

	if("snout" in mutant_bodyparts) //Take a closer look at that snout!
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "snout"

	if("frills" in mutant_bodyparts)
		if(!H.dna.features["frills"] || H.dna.features["frills"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "frills"

	if("horns" in mutant_bodyparts)
		if(!H.dna.features["horns"] || H.dna.features["horns"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "horns"

	if("ears" in mutant_bodyparts)
		if(!H.dna.features["ears"] || H.dna.features["ears"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "ears"

	if("wings" in mutant_bodyparts)
		if(!H.dna.features["wings"] || H.dna.features["wings"] == "None" || (H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))
			bodyparts_to_add -= "wings"

	if("wings_open" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception)))
			bodyparts_to_add -= "wings_open"
		else if ("wings" in mutant_bodyparts)
			bodyparts_to_add -= "wings_open"

	//Digitigrade legs are stuck in the phantom zone between true limbs and mutant bodyparts. Mainly it just needs more agressive updating than most limbs.
	var/update_needed = FALSE
	var/not_digitigrade = TRUE
	for(var/X in H.bodyparts)
		var/obj/item/bodypart/O = X
		if(!O.use_digitigrade)
			continue
		not_digitigrade = FALSE
		if(!(DIGITIGRADE in species_traits)) //Someone cut off a digitigrade leg and tacked it on
			species_traits += DIGITIGRADE
		var/should_be_squished = FALSE
		if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) || (H.wear_suit.body_parts_covered & LEGS)) || (H.w_uniform && (H.w_uniform.body_parts_covered & LEGS)))
			should_be_squished = TRUE
		if(O.use_digitigrade == FULL_DIGITIGRADE && should_be_squished)
			O.use_digitigrade = SQUISHED_DIGITIGRADE
			update_needed = TRUE
		else if(O.use_digitigrade == SQUISHED_DIGITIGRADE && !should_be_squished)
			O.use_digitigrade = FULL_DIGITIGRADE
			update_needed = TRUE
	if(update_needed)
		H.update_body_parts()
	if(not_digitigrade && (DIGITIGRADE in species_traits)) //Curse is lifted
		species_traits -= DIGITIGRADE

	if(!bodyparts_to_add)
		return

	var/g = (H.gender == FEMALE) ? "f" : "m"

	var/image/I

	for(var/layer in relevent_layers)
		var/layertext = mutant_bodyparts_layertext(layer)

		for(var/bodypart in bodyparts_to_add)
			var/datum/sprite_accessory/S
			switch(bodypart)
				if("tail_lizard")
					S = GLOB.tails_list_lizard[H.dna.features["tail_lizard"]]
				if("waggingtail_lizard")
					S.= GLOB.animated_tails_list_lizard[H.dna.features["tail_lizard"]]
				if("tail_human")
					S = GLOB.tails_list_human[H.dna.features["tail_human"]]
				if("waggingtail_human")
					S.= GLOB.animated_tails_list_human[H.dna.features["tail_human"]]
				if("spines")
					S = GLOB.spines_list[H.dna.features["spines"]]
				if("waggingspines")
					S.= GLOB.animated_spines_list[H.dna.features["spines"]]
				if("snout")
					S = GLOB.snouts_list[H.dna.features["snout"]]
				if("frills")
					S = GLOB.frills_list[H.dna.features["frills"]]
				if("horns")
					S = GLOB.horns_list[H.dna.features["horns"]]
				if("ears")
					S = GLOB.ears_list[H.dna.features["ears"]]
				if("body_markings")
					S = GLOB.body_markings_list[H.dna.features["body_markings"]]
				if("wings")
					S = GLOB.wings_list[H.dna.features["wings"]]
				if("wingsopen")
					S = GLOB.wings_open_list[H.dna.features["wings"]]
				if("legs")
					S = GLOB.legs_list[H.dna.features["legs"]]

			if(!S || S.icon_state == "none")
				continue

			//A little rename so we don't have to use tail_lizard or tail_human when naming the sprites.
			if(bodypart == "tail_lizard" || bodypart == "tail_human")
				bodypart = "tail"
			else if(bodypart == "waggingtail_lizard" || bodypart == "waggingtail_human")
				bodypart = "waggingtail"


			var/icon_string

			if(S.gender_specific)
				icon_string = "[g]_[bodypart]_[S.icon_state]_[layertext]"
			else
				icon_string = "m_[bodypart]_[S.icon_state]_[layertext]"

			I = image("icon" = S.icon, "icon_state" = icon_string, "layer" =- layer)

			if(S.center)
				I = center_image(I,S.dimension_x,S.dimension_y)

			if(!(H.disabilities & HUSK))
				if(!forced_colour)
					switch(S.color_src)
						if(MUTCOLORS)
							if(fixed_mut_color)
								I.color = "#[fixed_mut_color]"
							else
								I.color = "#[H.dna.features["mcolor"]]"
						if(HAIR)
							if(hair_color == "mutcolor")
								I.color = "#[H.dna.features["mcolor"]]"
							else
								I.color = "#[H.hair_color]"
						if(FACEHAIR)
							I.color = "#[H.facial_hair_color]"
						if(EYECOLOR)
							I.color = "#[H.eye_color]"
				else
					I.color = forced_colour
			standing += I

			if(S.hasinner)
				if(S.gender_specific)
					icon_string = "[g]_[bodypart]inner_[S.icon_state]_[layertext]"
				else
					icon_string = "m_[bodypart]inner_[S.icon_state]_[layertext]"

				I = image("icon" = S.icon, "icon_state" = icon_string, "layer" =- layer)

				if(S.center)
					I = center_image(I,S.dimension_x,S.dimension_y)

				standing += I

		H.overlays_standing[layer] = standing.Copy()
		standing = list()

	H.apply_overlay(BODY_BEHIND_LAYER)
	H.apply_overlay(BODY_ADJ_LAYER)
	H.apply_overlay(BODY_FRONT_LAYER)


//This exists so sprite accessories can still be per-layer without having to include that layer's
//number in their sprite name, which causes issues when those numbers change.
/datum/species/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(BODY_BEHIND_LAYER)
			return "BEHIND"
		if(BODY_ADJ_LAYER)
			return "ADJ"
		if(BODY_FRONT_LAYER)
			return "FRONT"


/datum/species/proc/spec_life(mob/living/carbon/human/H)
	if(NOBREATH in species_traits)
		H.setOxyLoss(0)
		H.losebreath = 0
		var/takes_crit_damage = (!(NOCRITDAMAGE in species_traits))
		if((H.health < HEALTH_THRESHOLD_CRIT) && takes_crit_damage)
			H.adjustBruteLoss(1)

/datum/species/proc/spec_death(gibbed, mob/living/carbon/human/H)
	return

/datum/species/proc/spawn_gibs(mob/living/carbon/human/H)
	hgibs(H.loc, H.viruses, H.dna)

/datum/species/proc/spec_husk(mob/living/carbon/human/H)
	return

/datum/species/proc/auto_equip(mob/living/carbon/human/H)
	// handles the equipping of species-specific gear
	return

/datum/species/proc/handle_emp(mob/living/carbon/human/H, severity)
	var/informed = 0
	for(var/obj/item/bodypart/L in H.bodyparts)
		if(L.status == ORGAN_ROBOTIC)
			if(!informed)
				H << "<span class='userdanger'>You feel a sharp pain as your robotic limbs overload.</span>"
				informed = 1
			switch(severity)
				if(1)
					L.take_damage(0,10)
					H.Stun(10)
				if(2)
					L.take_damage(0,5)
					H.Stun(5)
	return //return value does nothing.

/datum/species/proc/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H)
	if(slot in no_equip)
		if(!I.species_exception || !is_type_in_list(src, I.species_exception))
			return 0

	var/num_arms = H.get_num_arms()
	var/num_legs = H.get_num_legs()

	switch(slot)
		if(slot_hands)
			if(H.get_empty_held_indexes())
				return TRUE
			return FALSE
		if(slot_wear_mask)
			if(H.wear_mask)
				return 0
			if( !(I.slot_flags & SLOT_MASK) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_neck)
			if(H.wear_neck)
				return 0
			if( !(I.slot_flags & SLOT_NECK) )
				return 0
			return 1
		if(slot_back)
			if(H.back)
				return 0
			if( !(I.slot_flags & SLOT_BACK) )
				return 0
			return 1
		if(slot_wear_suit)
			if(H.wear_suit)
				return 0
			if( !(I.slot_flags & SLOT_OCLOTHING) )
				return 0
			return 1
		if(slot_gloves)
			if(H.gloves)
				return 0
			if( !(I.slot_flags & SLOT_GLOVES) )
				return 0
			if(num_arms < 2)
				return 0
			return 1
		if(slot_shoes)
			if(H.shoes)
				return 0
			if( !(I.slot_flags & SLOT_FEET) )
				return 0
			if(num_legs < 2)
				return 0
			if(DIGITIGRADE in species_traits)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>The footwear around here isn't compatible with your feet!</span>")
				return 0
			return 1
		if(slot_belt)
			if(H.belt)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
				return 0
			if( !(I.slot_flags & SLOT_BELT) )
				return
			return 1
		if(slot_glasses)
			if(H.glasses)
				return 0
			if( !(I.slot_flags & SLOT_EYES) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_head)
			if(H.head)
				return 0
			if( !(I.slot_flags & SLOT_HEAD) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_ears)
			if(H.ears)
				return 0
			if( !(I.slot_flags & SLOT_EARS) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_w_uniform)
			if(H.w_uniform)
				return 0
			if( !(I.slot_flags & SLOT_ICLOTHING) )
				return 0
			return 1
		if(slot_wear_id)
			if(H.wear_id)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
				return 0
			if( !(I.slot_flags & SLOT_ID) )
				return 0
			return 1
		if(slot_l_store)
			if(I.flags & NODROP) //Pockets aren't visible, so you can't move NODROP items into them.
				return 0
			if(H.l_store)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
				return 0
			if(I.slot_flags & SLOT_DENYPOCKET)
				return
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & SLOT_POCKET) )
				return 1
		if(slot_r_store)
			if(I.flags & NODROP)
				return 0
			if(H.r_store)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
				return 0
			if(I.slot_flags & SLOT_DENYPOCKET)
				return 0
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & SLOT_POCKET) )
				return 1
			return 0
		if(slot_s_store)
			if(I.flags & NODROP)
				return 0
			if(H.s_store)
				return 0
			if(!H.wear_suit)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a suit before you can attach this [I.name]!</span>")
				return 0
<<<<<<< HEAD
			if(istype(H.wear_suit, /obj/item/clothing/suit))
				var/obj/item/clothing/suit/S = H.wear_suit
				if(S.can_hold(I))
					return 1
=======
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(H, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
				return 0
			if(I.w_class > WEIGHT_CLASS_BULKY)
				if(!disable_warning)
					to_chat(H, "The [I.name] is too big to attach.") //should be src?
				return 0
			if( istype(I, /obj/item/device/pda) || istype(I, /obj/item/weapon/pen) || is_type_in_list(I, H.wear_suit.allowed) )
				return 1
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
			return 0
		if(slot_handcuffed)
			if(H.handcuffed)
				return 0
			if(!istype(I, /obj/item/weapon/restraints/handcuffs))
				return 0
			if(num_arms < 2)
				return 0
			return 1
		if(slot_legcuffed)
			if(H.legcuffed)
				return 0
			if(!istype(I, /obj/item/weapon/restraints/legcuffs))
				return 0
			if(num_legs < 2)
				return 0
			return 1
		if(slot_in_backpack)
			if(H.back && istype(H.back, /obj/item/weapon/storage))
				var/obj/item/weapon/storage/B = H.back
				if(B.can_be_inserted(I, 1, H))
					return 1
			return 0
	return 0 //Unsupported slot

/datum/species/proc/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	return

/datum/species/proc/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.update_mutant_bodyparts()

/datum/species/proc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == exotic_blood)
		H.blood_volume = min(H.blood_volume + round(chem.volume, 0.1), BLOOD_VOLUME_MAXIMUM)
<<<<<<< HEAD
		H.reagents.remove_reagent(chem.id, chem.volume)
=======
		H.reagents.del_reagent(chem.id)
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
		return 1
	return 0

/datum/species/proc/handle_speech(message, mob/living/carbon/human/H)
	return message

//return a list of spans or an empty list
/datum/species/proc/get_spans()
	return list()

/datum/species/proc/handle_inherent_channels(mob/living/carbon/human/H, message, message_mode)
	return 0

/datum/species/proc/check_weakness(obj/item/weapon, mob/living/attacker)
	return 0

/datum/species/proc/handle_flash(mob/living/carbon/human/H, intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0)
	return 0 //returning 1 will cancel all normal flash effects.

/datum/species/proc/on_gain_disease(mob/living/carbon/human/H, datum/disease/D)
	return

	////////
	//LIFE//
	////////

/datum/species/proc/handle_chemicals_in_body(mob/living/carbon/human/H)

	//The fucking FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
	if(H.disabilities & FAT)
		if(H.overeatduration < 100)
			to_chat(H, "<span class='notice'>You feel fit again!</span>")
			H.disabilities &= ~FAT
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()
	else
		if(H.overeatduration > 500)
			to_chat(H, "<span class='danger'>You suddenly feel blubbery!</span>")
			H.disabilities |= FAT
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()

	// nutrition decrease and satiety
	if (H.nutrition > 0 && H.stat != DEAD && \
		H.dna && H.dna.species && (!(NOHUNGER in H.dna.species.species_traits)))
		// THEY HUNGER
		var/hunger_rate = HUNGER_FACTOR
		if(H.satiety > 0)
			H.satiety--
		if(H.satiety < 0)
			H.satiety++
			if(prob(round(-H.satiety/40)))
				H.Jitter(5)
			hunger_rate = 3 * HUNGER_FACTOR
		H.nutrition = max(0, H.nutrition - hunger_rate)


	if (H.nutrition > NUTRITION_LEVEL_FULL)
		if(H.overeatduration < 600) //capped so people don't take forever to unfat
			H.overeatduration++
	else
		if(H.overeatduration > 1)
			H.overeatduration -= 2 //doubled the unfat rate

	//metabolism change
	if(H.nutrition > NUTRITION_LEVEL_FAT)
		H.metabolism_efficiency = 1
	else if(H.nutrition > NUTRITION_LEVEL_FED && H.satiety > 80)
		if(H.metabolism_efficiency != 1.25 && (H.dna && H.dna.species && !(NOHUNGER in H.dna.species.species_traits)))
			to_chat(H, "<span class='notice'>You feel vigorous.</span>")
			H.metabolism_efficiency = 1.25
	else if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		if(H.metabolism_efficiency != 0.8)
			to_chat(H, "<span class='notice'>You feel sluggish.</span>")
		H.metabolism_efficiency = 0.8
	else
		if(H.metabolism_efficiency == 1.25)
			to_chat(H, "<span class='notice'>You no longer feel vigorous.</span>")
		H.metabolism_efficiency = 1

	switch(H.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			H.throw_alert("nutrition", /obj/screen/alert/fat)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FULL)
			H.clear_alert("nutrition")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			H.throw_alert("nutrition", /obj/screen/alert/hungry)
		else
			H.throw_alert("nutrition", /obj/screen/alert/starving)

<<<<<<< HEAD

/datum/species/proc/update_sight(mob/living/carbon/human/H)
	H.sight = initial(H.sight) | sight_mod
	H.see_in_dark = darksight
	H.see_invisible = invis_sight

	if(H.client && H.client.eye != H)
		var/atom/A = H.client.eye
		if(A.update_remote_sight(H)) //returns 1 if we override all other sight updates.
			return

	for(var/obj/item/organ/cyberimp/eyes/E in H.internal_organs)
		H.sight |= E.sight_flags
		if(E.dark_view)
			H.see_in_dark = E.dark_view
		if(E.see_invisible)
			H.see_invisible = min(H.see_invisible, E.see_invisible)

	if(H.glasses)
		var/obj/item/clothing/glasses/G = H.glasses
		H.sight |= G.vision_flags
		H.see_in_dark = max(G.darkness_view, H.see_in_dark)
		if(G.invis_override)
			H.see_invisible = G.invis_override
		else
			H.see_invisible = min(G.invis_view, H.see_invisible)

	for(var/X in H.dna.mutations)
		var/datum/mutation/M = X
		if(M.name == XRAY)
			H.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
			H.see_in_dark = max(H.see_in_dark, 8)

	if(H.see_override)	//Override all
		H.see_invisible = H.see_override

=======
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
/datum/species/proc/update_health_hud(mob/living/carbon/human/H)
	return 0

/datum/species/proc/handle_mutations_and_radiation(mob/living/carbon/human/H)

	if(!(RADIMMUNE in species_traits))
		if(H.radiation)
			if (H.radiation > radiation_faint_threshhold)
				if(!H.weakened)
					H.emote("collapse")
				H.Weaken(10)
				to_chat(H, "<span class='danger'>You feel weak.</span>")
			switch(H.radiation)
				if(50 to 75)
					if(prob(radiation_effect_mod*5))
						if(!H.weakened)
							H.emote("collapse")
						H.Weaken(3)
						to_chat(H, "<span class='danger'>You feel weak.</span>")

					if(prob(radiation_effect_mod*15))
						if(!( H.hair_style == "Shaved") || !(H.hair_style == "Bald") || (HAIR in species_traits))
							to_chat(H, "<span class='danger'>Your hair starts to fall out in clumps...<span>")
							addtimer(CALLBACK(src, .proc/go_bald, H), 50)

				if(75 to 100)
<<<<<<< HEAD
					if(prob(radiation_effect_mod*1))
						H << "<span class='danger'>You mutate!</span>"
=======
					if(prob(1))
						to_chat(H, "<span class='danger'>You mutate!</span>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
						H.randmutb()
						H.emote("gasp")
						H.domutcheck()
		return 0
	H.radiation = 0
	return 1

/datum/species/proc/go_bald(mob/living/carbon/human/H)
	if(QDELETED(H))	//may be called from a timer
		return
	H.facial_hair_style = "Shaved"
	H.hair_style = "Bald"
	H.update_hair()

////////////////
// MOVE SPEED //
////////////////

/datum/species/proc/movement_delay(mob/living/carbon/human/H)
	. = 0	//We start at 0.
	var/flight = 0	//Check for flight and flying items
	var/flightpack = 0
	var/ignoreslow = 0
	var/gravity = 0
	var/obj/item/device/flightpack/F = H.get_flightpack()
	if(istype(F) && F.flight)
		flightpack = 1
	if(H.movement_type & FLYING)
		flight = 1

	if(!flightpack)	//Check for chemicals and innate speedups and slowdowns if we're moving using our body and not a flying suit
		if(GOTTAGOFAST in H.status_flags)
			. -= 1
		if(GOTTAGOREALLYFAST in H.status_flags)
			. -= 2
		. += speedmod

	if(IGNORESLOWDOWN in H.status_flags)
		ignoreslow = 1

	if(H.has_gravity())
		gravity = 1

	if(!gravity)
		var/obj/item/weapon/tank/jetpack/J = H.back
		var/obj/item/clothing/suit/space/hardsuit/C = H.wear_suit
		var/obj/item/organ/cyberimp/chest/thrusters/T = H.getorganslot("thrusters")
		if(!istype(J) && istype(C))
			J = C.jetpack
		if(istype(J) && J.full_speed && J.allow_thrust(0.01, H))	//Prevents stacking
			. -= 2
		else if(istype(T) && T.allow_thrust(0.01, H))
			. -= 2
		else if(flightpack && F.allow_thrust(0.01, src))
			. -= 2

	if(flightpack && F.boost)
		. -= F.boost_speed
	else if(flightpack && F.brake)
		. += 2

	if(!ignoreslow && !flightpack && gravity)
		if(H.wear_suit)
			. += H.wear_suit.slowdown
		if(H.shoes)
			. += H.shoes.slowdown
		if(H.back)
			. += H.back.slowdown
		for(var/obj/item/I in H.held_items)
			if(HAS_SECONDARY_FLAG(I, SLOWS_WHILE_IN_HAND))
				. += I.slowdown
		var/health_deficiency = (100 - H.health + H.staminaloss)
		var/hungry = (500 - H.nutrition) / 5 // So overeat would be 100 and default level would be 80
		if(health_deficiency >= 40)
			if(flight)
				. += (health_deficiency / 75)
			else
				. += (health_deficiency / 25)
		if((hungry >= 70) && !flight)		//Being hungry won't stop you from using flightpack controls/flapping your wings although it probably will in the wing case but who cares.
			. += hungry / 50
		if(H.disabilities & FAT)
			. += (1.5 - flight)
		if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			. += (BODYTEMP_COLD_DAMAGE_LIMIT - H.bodytemperature) / COLD_SLOWDOWN_FACTOR
	return .

<<<<<<< HEAD
	if(GOTTAGOFAST in H.status_flags)
		. -= 1
	if(GOTTAGOREALLYFAST in H.status_flags)
		. -= 2

	if(!(IGNORESLOWDOWN in H.status_flags))
		if(!has_gravity(H))
			if(specflags & FLYING)
				. += speedmod
				return
			// If there's no gravity we have the sanic speed of jetpack.
			var/obj/item/weapon/tank/jetpack/J = H.back
			var/obj/item/clothing/suit/space/hardsuit/C = H.wear_suit
			if(!istype(J) && istype(C))
				J = C.jetpack

			if(istype(J) && J.allow_thrust(0.01, H))
				. -= 2
			else
				var/obj/item/organ/cyberimp/chest/thrusters/T = H.getorganslot("thrusters")
				if(istype(T) && T.allow_thrust(0.01, H))
					. -= 2
=======

//////////////////
// ATTACK PROCS //
//////////////////
>>>>>>> masterTGbranch

/datum/species/proc/help(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.health >= 0 && !(FAKEDEATH in target.status_flags))
		target.help_shake_act(user)
		if(target != user)
			add_logs(user, target, "shaked")
		return 1
	else
		var/we_breathe = (!(NOBREATH in user.dna.species.species_traits))
		var/we_lung = user.getorganslot("lungs")

		if(we_breathe && we_lung)
			user.do_cpr(target)
		else if(we_breathe && !we_lung)
			to_chat(user, "<span class='warning'>You have no lungs to breathe with, so you cannot peform CPR.</span>")
		else
			to_chat(user, "<span class='notice'>You do not breathe, so you cannot perform CPR.</span>")

/datum/species/proc/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s grab attempt!</span>")
		return 0
	if(attacker_style && attacker_style.grab_act(user,target))
		return 1
	else
		target.grabbedby(user)
		return 1


<<<<<<< HEAD
			if((H.disabilities & FAT))
				. += 1.5
			if(H.bodytemperature < low_temp_level_1)
				. += (low_temp_level_1 - H.bodytemperature) / cold_slowdown_factor
=======
>>>>>>> masterTGbranch


			if(SLOWDOWN in H.status_flags) //From bolamine, intended to replicate the slowdown of a 50K freeze blast.
				. += 3


/datum/species/proc/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s attack!</span>")
		return 0
	if(attacker_style && attacker_style.harm_act(user,target))
		return 1
	else

		var/atk_verb = user.dna.species.attack_verb
		if(target.lying)
			atk_verb = "kick"

		switch(atk_verb)
			if("kick")
				user.do_attack_animation(target, ATTACK_EFFECT_KICK)
			if("slash")
				user.do_attack_animation(target, ATTACK_EFFECT_CLAW)
			if("smash")
				user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
			else
				user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

		var/damage = rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh)

		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))

		if(!damage || !affecting)
			playsound(target.loc, user.dna.species.miss_sound, 25, 1, -1)
			target.visible_message("<span class='danger'>[user] has attempted to [atk_verb] [target]!</span>",\
			"<span class='userdanger'>[user] has attempted to [atk_verb] [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			return 0


		var/armor_block = target.run_armor_check(affecting, "melee")

		playsound(target.loc, user.dna.species.attack_sound, 25, 1, -1)

<<<<<<< HEAD
/datum/species/proc/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, obj/item/bodypart/affecting)
=======
		target.visible_message("<span class='danger'>[user] has [atk_verb]ed [target]!</span>", \
					"<span class='userdanger'>[user] has [atk_verb]ed [target]!</span>", null, COMBAT_MESSAGE_RANGE)

		if(user.limb_destroyer)
			target.dismembering_strike(user, affecting.body_zone)
		target.apply_damage(damage, BRUTE, affecting, armor_block)
		add_logs(user, target, "punched")
		if((target.stat != DEAD) && damage >= user.dna.species.punchstunthreshold)
			target.visible_message("<span class='danger'>[user] has weakened [target]!</span>", \
							"<span class='userdanger'>[user] has weakened [target]!</span>")
			target.apply_effect(4, WEAKEN, armor_block)
			target.forcesay(GLOB.hit_appends)
		else if(target.lying)
			target.forcesay(GLOB.hit_appends)



/datum/species/proc/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	var/aim_for_mouth  = user.zone_selected == "mouth"
	var/target_on_help_and_unarmed = target.a_intent == INTENT_HELP && !target.get_active_held_item()
	var/target_aiming_for_mouth = target.zone_selected == "mouth"
	var/target_restrained = target.restrained()
	if(aim_for_mouth && ( target_on_help_and_unarmed || target_restrained || target_aiming_for_mouth))
		playsound(target.loc, 'sound/weapons/slap.ogg', 50, 1, -1)
		user.visible_message("<span class='danger'>[user] slaps [target] in the face!</span>",
			"<span class='notice'>You slap [target] in the face! </span>",\
		"You hear a slap.")
		target.endTailWag()
		return FALSE
	else if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s disarm attempt!</span>")
		return 0
	if(attacker_style && attacker_style.disarm_act(user,target))
		return 1
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))
		var/randn = rand(1, 100)
		if(randn <= 25)
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			target.visible_message("<span class='danger'>[user] has pushed [target]!</span>",
				"<span class='userdanger'>[user] has pushed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(2, WEAKEN, target.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
			target.forcesay(GLOB.hit_appends)
			add_logs(user, target, "disarmed", " pushing them to the ground")
			return

		if(randn <= 60)
			var/obj/item/I = null
			if(target.pulling)
				to_chat(target, "<span class='warning'>[user] has broken [target]'s grip on [target.pulling]!</span>")
				target.stop_pulling()
			else
				I = target.get_active_held_item()
				if(target.drop_item())
					target.visible_message("<span class='danger'>[user] has disarmed [target]!</span>", \
						"<span class='userdanger'>[user] has disarmed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
				else
					I = null
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			add_logs(user, target, "disarmed", "[I ? " removing \the [I]" : ""]")
			return


		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message("<span class='danger'>[user] attempted to disarm [target]!</span>", \
						"<span class='userdanger'>[user] attemped to disarm [target]!</span>", null, COMBAT_MESSAGE_RANGE)



/datum/species/proc/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	return

/datum/species/proc/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style = M.martial_art)
>>>>>>> masterTGbranch
	if(!istype(M))
		return
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return
<<<<<<< HEAD
	if((M != H) && M.a_intent != "help" && H.check_shields(0, M.name, M, attack_type = UNARMED_ATTACK))
		if(M.dna.check_mutation(HULK) && M.a_intent == "disarm")
			H.check_shields(0, M.name, attack_type = HULK_ATTACK) // We check their shields twice since we are a hulk. Also triggers hitreactions for HULK_ATTACK
			M.visible_message("<span class='danger'>[M]'s punch knocks the shield out of [H]'s hand.</span>", \
							"<span class='userdanger'>[M]'s punch knocks the shield out of [H]'s hand.</span>")
			if(M.dna)
				playsound(H.loc, M.dna.species.attack_sound, 25, 1, -1)
			else
				playsound(H.loc, 'sound/weapons/punch1.ogg', 25, 1, -1)
			add_logs(M, H, "hulk punched a shield held by")
			return 0
=======
	if((M != H) && M.a_intent != INTENT_HELP && H.check_shields(0, M.name, attack_type = UNARMED_ATTACK))
>>>>>>> masterTGbranch
		add_logs(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return 0
	switch(M.a_intent)
		if("help")
			help(M, H, attacker_style)

		if("grab")
			grab(M, H, attacker_style)

		if("harm")
<<<<<<< HEAD
			if(attacker_style && attacker_style.harm_act(M,H))
				return 1
			else
				M.do_attack_animation(H)

				var/atk_verb = M.dna.species.attack_verb
				if(H.lying)
					atk_verb = "kick"

				var/damage = rand(M.dna.species.punchdamagelow, M.dna.species.punchdamagehigh)

				if(!affecting)
					affecting = H.get_bodypart(ran_zone(M.zone_selected))
=======
			harm(M, H, attacker_style)
>>>>>>> masterTGbranch

		if("disarm")
<<<<<<< HEAD
			if(attacker_style && attacker_style.disarm_act(M,H))
				return 1
			else
				M.do_attack_animation(H)
				add_logs(M, H, "disarmed")

				if(H.w_uniform)
					H.w_uniform.add_fingerprint(M)
				if(!affecting)
					affecting = H.get_bodypart(ran_zone(M.zone_selected))
				var/randn = rand(1, 100)
				if(randn <= 25)
					playsound(H, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					H.visible_message("<span class='danger'>[M] has pushed [H]!</span>",
									"<span class='userdanger'>[M] has pushed [H]!</span>")
					H.apply_effect(2, WEAKEN, H.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
					H.forcesay(hit_appends)
					return

				var/talked = 0	// BubbleWrap

				if(randn <= 60)
					//BubbleWrap: Disarming breaks a pull
					if(H.pulling)
						H.visible_message("<span class='warning'>[M] has broken [H]'s grip on [H.pulling]!</span>")
						talked = 1
						H.stop_pulling()
					//End BubbleWrap

					if(!talked)	//BubbleWrap
						if(H.drop_item())
							H.visible_message("<span class='danger'>[M] has disarmed [H]!</span>", \
											"<span class='userdanger'>[M] has disarmed [H]!</span>")
					playsound(H, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return


				playsound(H, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				H.visible_message("<span class='danger'>[M] attempted to disarm [H]!</span>", \
								"<span class='userdanger'>[M] attemped to disarm [H]!</span>")
	return

/datum/species/proc/handle_vision(mob/living/carbon/human/H)
	if( H.stat == DEAD )
		H.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		H.see_in_dark = 8
		if(!H.druggy)
			H.see_invisible = SEE_INVISIBLE_LEVEL_TWO
		return

	if(!(SEE_TURFS & H.permanent_sight_flags))
		H.sight &= ~SEE_TURFS
	if(!(SEE_MOBS & H.permanent_sight_flags))
		H.sight &= ~SEE_MOBS
	if(!(SEE_OBJS & H.permanent_sight_flags))
		H.sight &= ~SEE_OBJS

	if(H.remote_view)
		H.sight |= SEE_TURFS
		H.sight |= SEE_MOBS
		H.sight |= SEE_OBJS

	H.see_in_dark = (H.sight == SEE_TURFS|SEE_MOBS|SEE_OBJS) ? 8 : darksight
	var/see_temp = H.see_invisible
	H.see_invisible = invis_sight

	if(H.glasses)
		if(istype(H.glasses, /obj/item/clothing/glasses))
			var/obj/item/clothing/glasses/G = H.glasses
			H.sight |= G.vision_flags
			H.see_in_dark = G.darkness_view
			H.see_invisible = G.invis_view
	if(H.druggy)	//Override for druggy
		H.see_invisible = see_temp

	if(H.see_override)	//Override all
		H.see_invisible = H.see_override

	//	This checks how much the mob's eyewear impairs their vision
	if(H.tinttotal >= TINT_IMPAIR)
		if(tinted_weldhelh)
			H.overlay_fullscreen("tint", /obj/screen/fullscreen/impaired, 2)
		if(H.tinttotal >= TINT_BLIND)
			H.eye_blind = max(H.eye_blind, 1)
	else
		H.clear_fullscreen("tint")

	if(H.adjust_eye_damage() > 30)
		H.overlay_fullscreen("impaired", /obj/screen/fullscreen/impaired, 2)
	else if(H.adjust_eye_damage() > 20)
		H.overlay_fullscreen("impaired", /obj/screen/fullscreen/impaired, 1)
	else
		H.clear_fullscreen("impaired")

	if(!H.client)//no client, no screen to update
		return 1

	if(H.eye_blind)
		H.overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		H.throw_alert("blind")
	else
		H.clear_fullscreen("blind")
		H.clear_alert("blind")

	if(H.disabilities & NEARSIGHT && !istype(H.glasses, /obj/item/clothing/glasses/regular))
		H.overlay_fullscreen("nearsighted", /obj/screen/fullscreen/impaired, 1)
	else
		H.clear_fullscreen("nearsighted")

	if(H.eye_blurry)
		H.overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else
		H.clear_fullscreen("blurry")

	if(H.druggy)
		H.overlay_fullscreen("high", /obj/screen/fullscreen/high)
		H.throw_alert("high", /obj/screen/alert/high)
	else
		H.clear_fullscreen("high")
		H.clear_alert("high")

	return 1

/datum/species/proc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, target_area, mob/living/carbon/human/H)
	// Allows you to put in item-specific reactions based on species
	if(user != H)
		user.do_attack_animation(H)
		if(H.check_shields(I.force, "the [I.name]", user, MELEE_ATTACK, I.armour_penetration))
=======
			disarm(M, H, attacker_style)

/datum/species/proc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	// Allows you to put in item-specific reactions based on species
	if(user != H)
		if(H.check_shields(I.force, "the [I.name]", I, MELEE_ATTACK, I.armour_penetration))
>>>>>>> masterTGbranch
			return 0
	if(H.check_block())
		H.visible_message("<span class='warning'>[H] blocks [I]!</span>")
		return 0

	var/hit_area
	if(!affecting) //Something went wrong. Maybe the limb is missing?
		affecting = H.bodyparts[1]

	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/armor_block = H.run_armor_check(affecting, "melee", "<span class='notice'>Your armor has protected your [hit_area].</span>", "<span class='notice'>Your armor has softened a hit to your [hit_area].</span>",I.armour_penetration)
	armor_block = min(90,armor_block) //cap damage reduction at 90%
	var/Iforce = I.force //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)

	var/weakness = H.check_weakness(I, user)
	apply_damage(I.force * weakness, I.damtype, def_zone, armor_block, H)
	H.damage_clothes(I.force, I.damtype, "melee", affecting.body_zone)

	H.send_item_attack_message(I, user, hit_area)

	if(!I.force)
		return 0 //item force is zero

	//dismemberment
	var/probability = I.get_dismemberment_chance(affecting)
<<<<<<< HEAD
	if(prob(probability) || ((EASYDISMEMBER in specflags) && prob(2*probability)))
=======
	if(prob(probability) || ((EASYDISMEMBER in species_traits) && prob(2*probability)))
>>>>>>> masterTGbranch
		if(affecting.dismember(I.damtype))
			I.add_mob_blood(H)
			playsound(get_turf(H), I.get_dismember_sound(), 80, 1)

	var/bloody = 0
	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			if(prob(I.force * 2))	//blood spatter!
				bloody = 1
				var/turf/location = get_turf(H)
				var/obj/effect/decal/cleanable/blood/hitsplatter/B = new(H)
				B.blood_source = H
				B.transfer_mob_blood_dna(H)
				var/n = rand(1,3)
				var/turf/targ = get_ranged_target_turf(H, get_dir(user, H), n)
				B.GoTo(targ, n)
				if (istype(location))
					H.add_splatter_floor(location)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if("head")
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked senseless!</span>", \
										"<span class='userdanger'>[H] has been knocked senseless!</span>")
						H.confused = max(H.confused, 20)
						H.adjust_blurriness(10)

					if(prob(I.force + ((100 - H.health)/2)) && H != user)
						SSticker.mode.remove_revolutionary(H.mind)

				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_mob_blood(H)
						H.update_inv_glasses()

			if("chest")
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked down!</span>", \
									"<span class='userdanger'>[H] has been knocked down!</span>")
						H.apply_effect(3, WEAKEN, armor_block)

				if(bloody)
					if(H.wear_suit)
						H.wear_suit.add_mob_blood(H)
						H.update_inv_wear_suit()
					if(H.w_uniform)
						H.w_uniform.add_mob_blood(H)
						H.update_inv_w_uniform()

		if(Iforce > 10 || Iforce >= 5 && prob(33))
<<<<<<< HEAD
			H.forcesay(hit_appends)	//forcesay checks stat already.
<<<<<<< HEAD
	return 1

/datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H)
	blocked = (100-(blocked+armor))/100
	if(!damage || blocked <= 0)
=======
=======
			H.forcesay(GLOB.hit_appends)	//forcesay checks stat already.
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
	return TRUE

/datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H)
	var/hit_percent = (100-(blocked+armor))/100
	if(!damage || hit_percent <= 0)
>>>>>>> masterTGbranch
		return 0

	var/obj/item/bodypart/BP = null
	if(islimb(def_zone))
		BP = def_zone
	else
		if(!def_zone)
			def_zone = ran_zone(def_zone)
		BP = H.get_bodypart(check_zone(def_zone))
		if(!BP)
			BP = H.bodyparts[1]

	switch(damagetype)
		if(BRUTE)
			H.damageoverlaytemp = 20
<<<<<<< HEAD
			if(organ.take_damage(damage, 0, application))
				H.update_damage_overlays(0)
		if(BURN)
			H.damageoverlaytemp = 20
			if(organ.take_damage(0, damage, application))
				H.update_damage_overlays(0)
		if(TOX)
			H.adjustToxLoss(damage, 1, application)
		if(OXY)
			H.adjustOxyLoss(damage, 1, application)
		if(CLONE)
			H.adjustCloneLoss(damage, 1, application)
		if(STAMINA)
			H.adjustStaminaLoss(damage, 1, application)
		if(BRAIN)
			H.adjustBrainLoss(damage, 1, application)
=======
			if(BP)
				if(BP.receive_damage(damage * hit_percent * brutemod, 0))
					H.update_damage_overlays()
			else//no bodypart, we deal damage with a more general method.
				H.adjustBruteLoss(damage * hit_percent * brutemod)
		if(BURN)
			H.damageoverlaytemp = 20
			if(BP)
				if(BP.receive_damage(0, damage * hit_percent * burnmod))
					H.update_damage_overlays()
			else
				H.adjustFireLoss(damage * hit_percent* burnmod)
		if(TOX)
			H.adjustToxLoss(damage * hit_percent)
		if(OXY)
			H.adjustOxyLoss(damage * hit_percent)
		if(CLONE)
			H.adjustCloneLoss(damage * hit_percent)
		if(STAMINA)
			H.adjustStaminaLoss(damage * hit_percent)
>>>>>>> masterTGbranch
	return 1

/datum/species/proc/on_hit(obj/item/projectile/P, mob/living/carbon/human/H)
	// called when hit by a projectile
	switch(P.type)
		if(/obj/item/projectile/energy/floramut) // overwritten by plants/pods
			H.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		if(/obj/item/projectile/energy/florayield)
			H.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")

/datum/species/proc/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	// called before a projectile hit
	return 0

/////////////
//BREATHING//
/////////////

/datum/species/proc/breathe(mob/living/carbon/human/H)
	if(NOBREATH in species_traits)
		return TRUE

<<<<<<< HEAD
/datum/species/proc/check_breath(datum/gas_mixture/breath, var/mob/living/carbon/human/H)
	if((GODMODE in H.status_flags))
		return

	var/lungs = H.getorganslot("lungs")

	if(!breath || (breath.total_moles() == 0) || !lungs)
		if(H.reagents.has_reagent("epinephrine") && lungs)
			return
		if(NOCRIT in H.status_flags)
			return
		if(H.health >= config.health_threshold_crit)
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			if(!lungs)
				H.adjustOxyLoss(1)
		else if(!(NOCRITDAMAGE in specflags))
			H.adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		H.failed_last_breath = 1
		H.throw_alert("oxy", /obj/screen/alert/oxy)

		return 0

	var/gas_breathed = 0

	var/list/breath_gases = breath.gases

	breath.assert_gases("o2", "plasma", "co2", "n2o", "bz")

	//Partial pressures in our breath
	var/O2_pp = breath.get_breath_partial_pressure(breath_gases["o2"][MOLES])
	var/Toxins_pp = breath.get_breath_partial_pressure(breath_gases["plasma"][MOLES])
	var/CO2_pp = breath.get_breath_partial_pressure(breath_gases["co2"][MOLES])


	//-- OXY --//

	//Too much oxygen! //Yes, some species may not like it.
	if(safe_oxygen_max)
		if(O2_pp > safe_oxygen_max && !(NOBREATH in specflags))
			var/ratio = (breath_gases["o2"][MOLES]/safe_oxygen_max) * 10
			H.adjustOxyLoss(Clamp(ratio,oxy_breath_dam_min,oxy_breath_dam_max))
			H.throw_alert("too_much_oxy", /obj/screen/alert/too_much_oxy)
		else
			H.clear_alert("too_much_oxy")

	//Too little oxygen!
	if(safe_oxygen_min)
		if(O2_pp < safe_oxygen_min)
			gas_breathed = handle_too_little_breath(H,O2_pp,safe_oxygen_min,breath_gases["o2"][MOLES])
			H.throw_alert("oxy", /obj/screen/alert/oxy)
		else
			H.failed_last_breath = 0
			if(H.getOxyLoss())
				H.adjustOxyLoss(-5)
			gas_breathed = breath_gases["o2"][MOLES]
			H.clear_alert("oxy")

	//Exhale
	breath_gases["o2"][MOLES] -= gas_breathed
	breath_gases["co2"][MOLES] += gas_breathed
	gas_breathed = 0


	//-- CO2 --//

	//CO2 does not affect failed_last_breath. So if there was enough oxygen in the air but too much co2, this will hurt you, but only once per 4 ticks, instead of once per tick.
	if(safe_co2_max)
		if(CO2_pp > safe_co2_max && !(NOBREATH in specflags))
			if(!H.co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
				H.co2overloadtime = world.time
			else if(world.time - H.co2overloadtime > 120)
				H.Paralyse(3)
				H.adjustOxyLoss(3) // Lets hurt em a little, let them know we mean business
				if(world.time - H.co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
					H.adjustOxyLoss(8)
				H.throw_alert("too_much_co2", /obj/screen/alert/too_much_co2)
			if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
				H.emote("cough")

		else
			H.co2overloadtime = 0
			H.clear_alert("too_much_co2")

	//Too little CO2!
	if(safe_co2_min)
		if(CO2_pp < safe_co2_min)
			gas_breathed = handle_too_little_breath(H,CO2_pp, safe_co2_min,breath_gases["co2"][MOLES])
			H.throw_alert("not_enough_co2", /obj/screen/alert/not_enough_co2)
		else
			H.failed_last_breath = 0
			H.adjustOxyLoss(-5)
			gas_breathed = breath_gases["co2"][MOLES]
			H.clear_alert("not_enough_co2")

	//Exhale
	breath_gases["co2"][MOLES] -= gas_breathed
	breath_gases["o2"][MOLES] += gas_breathed
	gas_breathed = 0


	//-- TOX --//

	//Too much toxins!
	if(safe_toxins_max)
		if(Toxins_pp > safe_toxins_max && !(NOBREATH in specflags))
			var/ratio = (breath_gases["plasma"][MOLES]/safe_toxins_max) * 10
			if(H.reagents)
				H.reagents.add_reagent("plasma", Clamp(ratio, tox_breath_dam_min, tox_breath_dam_max))
			H.throw_alert("tox_in_air", /obj/screen/alert/tox_in_air)
		else
			H.clear_alert("tox_in_air")


	//Too little toxins!
	if(safe_toxins_min)
		if(Toxins_pp < safe_toxins_min && !(NOBREATH in specflags))
			gas_breathed = handle_too_little_breath(H,Toxins_pp, safe_toxins_min, breath_gases["plasma"][MOLES])
			H.throw_alert("not_enough_tox", /obj/screen/alert/not_enough_tox)
		else
			H.failed_last_breath = 0
			H.adjustOxyLoss(-5)
			gas_breathed = breath_gases["plasma"][MOLES]
			H.clear_alert("not_enough_tox")

	//Exhale
	breath_gases["plasma"][MOLES] -= gas_breathed
	breath_gases["co2"][MOLES] += gas_breathed
	gas_breathed = 0


	//-- TRACES --//

	if(breath && !(NOBREATH in specflags))	// If there's some other shit in the air lets deal with it here.

	// N2O

		var/SA_pp = breath.get_breath_partial_pressure(breath_gases["n2o"][MOLES])
		if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
			H.Paralyse(3) // 3 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
				H.Sleeping(max(H.sleeping+2, 10))
		else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				H.emote(pick("giggle", "laugh"))

	// BZ

		var/bz_pp = breath.get_breath_partial_pressure(breath_gases["bz"][MOLES])
		if(bz_pp > BZ_trip_balls_min)
			H.hallucination += 20
			if(prob(33))
				H.adjustBrainLoss(3)
		else if(bz_pp > 0.01)
			H.hallucination += 5//Removed at 2 per tick so this will slowly build up
		handle_breath_temperature(breath, H)
		breath.garbage_collect()

	return 1


//Returns the amount of true_pp we breathed
/datum/species/proc/handle_too_little_breath(mob/living/carbon/human/H = null,breath_pp = 0, safe_breath_min = 0, true_pp = 0)
	. = 0
	if(!H || !safe_breath_min) //the other args are either: Ok being 0 or Specifically handled.
		return 0

	if(!(NOBREATH in specflags) || (H.health <= config.health_threshold_crit))
		if(prob(20))
			H.emote("gasp")
		if(breath_pp > 0)
			var/ratio = safe_breath_min/breath_pp
			H.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!
			H.failed_last_breath = 1
			. = true_pp*ratio/6
		else
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			H.failed_last_breath = 1


/datum/species/proc/handle_breath_temperature(datum/gas_mixture/breath, mob/living/carbon/human/H) // called by human/life, handles temperatures
	if(abs(310.15 - breath.temperature) > 50)

		if(!(mutations_list[COLDRES] in H.dna.mutations)) // COLD DAMAGE
			switch(breath.temperature)
				if(-INFINITY to low_temp_level_3)
					H.apply_damage(COLD_GAS_DAMAGE_LEVEL_3*coldmod, BURN, "head")
					H.lastburntype = "coldburn"
				if(low_temp_level_3 to low_temp_level_2)
					H.apply_damage(COLD_GAS_DAMAGE_LEVEL_2*coldmod, BURN, "head")
					H.lastburntype = "coldburn"
				if(low_temp_level_2 to low_temp_level_1)
					H.apply_damage(COLD_GAS_DAMAGE_LEVEL_1*coldmod, BURN, "head")
					H.lastburntype = "coldburn"

		if(!(RESISTTEMP in specflags)) // HEAT DAMAGE
			switch(breath.temperature)
				if(high_temp_level_1 to high_temp_level_2)
					H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_1*heatmod, BURN, "head")
					H.lastburntype = "hotburn"
				if(high_temp_level_1 to 1000)
					H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_2*heatmod, BURN, "head")
					H.lastburntype = "hotburn"
				if(1000 to INFINITY)
					H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_3*heatmod, BURN, "head")
					H.lastburntype = "hotburn"

=======
>>>>>>> masterTGbranch
/datum/species/proc/handle_environment(datum/gas_mixture/environment, mob/living/carbon/human/H)
	if(!environment)
		return
	if(istype(H.loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	var/loc_temp = H.get_temperature(environment)

	//Body temperature is adjusted in two steps. First, your body tries to stabilize itself a bit.
	if(H.stat != DEAD)
		H.natural_bodytemperature_stabilization()

	//Then, it reacts to the surrounding atmosphere based on your thermal protection
	if(!H.on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
		if(loc_temp < H.bodytemperature)
			//Place is colder than we are
			var/thermal_protection = H.get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				H.bodytemperature += min((1-thermal_protection) * ((loc_temp - H.bodytemperature) / BODYTEMP_COLD_DIVISOR), BODYTEMP_COOLING_MAX)
		else
			//Place is hotter than we are
			var/thermal_protection = H.get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				H.bodytemperature += min((1-thermal_protection) * ((loc_temp - H.bodytemperature) / BODYTEMP_HEAT_DIVISOR), BODYTEMP_HEATING_MAX)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
<<<<<<< HEAD
	if(H.bodytemperature > high_temp_level_1 && !(RESISTTEMP in specflags))
=======
	if(H.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !(RESISTHOT in species_traits))
>>>>>>> masterTGbranch
		//Body temperature is too hot.
<<<<<<< HEAD
=======
		switch(H.bodytemperature)
			if(360 to 400)
				H.throw_alert("temp", /obj/screen/alert/hot, 1)
				H.apply_damage(HEAT_DAMAGE_LEVEL_1*heatmod, BURN)
			if(400 to 460)
				H.throw_alert("temp", /obj/screen/alert/hot, 2)
				H.apply_damage(HEAT_DAMAGE_LEVEL_2*heatmod, BURN)
			if(460 to INFINITY)
				H.throw_alert("temp", /obj/screen/alert/hot, 3)
				if(H.on_fire)
					H.apply_damage(HEAT_DAMAGE_LEVEL_3*heatmod, BURN)
				else
					H.apply_damage(HEAT_DAMAGE_LEVEL_2*heatmod, BURN)
	else if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !(GLOB.mutations_list[COLDRES] in H.dna.mutations))
		switch(H.bodytemperature)
			if(200 to 260)
				H.throw_alert("temp", /obj/screen/alert/cold, 1)
				H.apply_damage(COLD_DAMAGE_LEVEL_1*coldmod, BURN)
			if(120 to 200)
				H.throw_alert("temp", /obj/screen/alert/cold, 2)
				H.apply_damage(COLD_DAMAGE_LEVEL_2*coldmod, BURN)
			if(-INFINITY to 120)
				H.throw_alert("temp", /obj/screen/alert/cold, 3)
				H.apply_damage(COLD_DAMAGE_LEVEL_3*coldmod, BURN)
			else
				H.clear_alert("temp")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

		if(H.bodytemperature > high_temp_level_3)
			H.throw_alert("temp", /obj/screen/alert/hot, 3)
			if(H.on_fire)
				H.apply_damage(HEAT_DAMAGE_LEVEL_3*heatmod, BURN)
			else
				H.apply_damage(HEAT_DAMAGE_LEVEL_2*heatmod, BURN)
		else if(H.bodytemperature > high_temp_level_2)
			H.throw_alert("temp", /obj/screen/alert/hot, 2)
			H.apply_damage(HEAT_DAMAGE_LEVEL_2*heatmod, BURN)
		else if(H.bodytemperature > high_temp_level_1)
			H.throw_alert("temp", /obj/screen/alert/hot, 1)
			H.apply_damage(HEAT_DAMAGE_LEVEL_1*heatmod, BURN)

	else if(H.bodytemperature < low_temp_level_1 && !(mutations_list[COLDRES] in H.dna.mutations))
		if(H.bodytemperature < low_temp_level_3)
			H.throw_alert("temp", /obj/screen/alert/cold, 3)
			H.apply_damage(COLD_DAMAGE_LEVEL_3*coldmod, BURN)
		else if(H.bodytemperature < low_temp_level_2)
			H.throw_alert("temp", /obj/screen/alert/cold, 2)
			H.apply_damage(COLD_DAMAGE_LEVEL_2*coldmod, BURN)
		else if(H.bodytemperature < low_temp_level_1)
			H.throw_alert("temp", /obj/screen/alert/cold, 1)
			H.apply_damage(COLD_DAMAGE_LEVEL_1*coldmod, BURN)
	else
		H.clear_alert("temp")

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.
<<<<<<< HEAD
	if(adjusted_pressure > hazard_high_pressure)
		if(!(RESISTTEMP in specflags))
			H.lastbrutetype = "pressure"
			H.apply_damage( min( ( (adjusted_pressure / hazard_high_pressure) -1 ) * PRESSURE_DAMAGE_COEFFICIENT * lowpressure_mod , MAX_HIGH_PRESSURE_DAMAGE), BRUTE)
			H.throw_alert("pressure", /obj/screen/alert/highpressure, 2)
		else
			H.clear_alert("pressure")
	else if(adjusted_pressure > warning_high_pressure)
		H.throw_alert("pressure", /obj/screen/alert/highpressure, 1)
	else if(adjusted_pressure > warning_low_pressure)
		H.clear_alert("pressure")
	else if((adjusted_pressure > hazard_low_pressure) && (adjusted_pressure < warning_low_pressure))
		H.throw_alert("pressure", /obj/screen/alert/lowpressure, 1)
	else
		if(H.dna.check_mutation(COLDRES) || (RESISTTEMP in specflags))
=======
	switch(adjusted_pressure)
		if(HAZARD_HIGH_PRESSURE to INFINITY)
			if(!(RESISTPRESSURE in species_traits))
				H.adjustBruteLoss( min( ( (adjusted_pressure / HAZARD_HIGH_PRESSURE) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE) )
				H.throw_alert("pressure", /obj/screen/alert/highpressure, 2)
			else
				H.clear_alert("pressure")
		if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
			H.throw_alert("pressure", /obj/screen/alert/highpressure, 1)
		if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
>>>>>>> masterTGbranch
			H.clear_alert("pressure")
		else
<<<<<<< HEAD
			H.apply_damage(LOW_PRESSURE_DAMAGE * highpressure_mod, BRUTE)
			H.throw_alert("pressure", /obj/screen/alert/lowpressure, 2)

/datum/species/proc/can_accept_organ(mob/living/carbon/human/H, obj/item/organ/O)
	return 1

/datum/species/proc/emag_act(mob/user)
	return 0
=======
			if(H.dna.check_mutation(COLDRES) || (RESISTPRESSURE in species_traits))
				H.clear_alert("pressure")
			else
				H.adjustBruteLoss( LOW_PRESSURE_DAMAGE )
				H.throw_alert("pressure", /obj/screen/alert/lowpressure, 2)
>>>>>>> masterTGbranch

//////////
// FIRE //
//////////

/datum/species/proc/handle_fire(mob/living/carbon/human/H, no_protection = FALSE)
	if(NOFIRE in species_traits)
		return
	if(H.on_fire)
		//the fire tries to damage the exposed clothes and items
		var/list/burning_items = list()
		//HEAD//
		var/obj/item/clothing/head_clothes = null
		if(H.glasses)
			head_clothes = H.glasses
		if(H.wear_mask)
			head_clothes = H.wear_mask
		if(H.wear_neck)
			head_clothes = H.wear_neck
		if(H.head)
			head_clothes = H.head
		if(head_clothes)
			burning_items += head_clothes
		else if(H.ears)
			burning_items += H.ears

		//CHEST//
		var/obj/item/clothing/chest_clothes = null
		if(H.w_uniform)
			chest_clothes = H.w_uniform
		if(H.wear_suit)
			chest_clothes = H.wear_suit

		if(chest_clothes)
			burning_items += chest_clothes

		//ARMS & HANDS//
		var/obj/item/clothing/arm_clothes = null
		if(H.gloves)
			arm_clothes = H.gloves
		if(H.w_uniform && ((H.w_uniform.body_parts_covered & HANDS) || (H.w_uniform.body_parts_covered & ARMS)))
			arm_clothes = H.w_uniform
		if(H.wear_suit && ((H.wear_suit.body_parts_covered & HANDS) || (H.wear_suit.body_parts_covered & ARMS)))
			arm_clothes = H.wear_suit
		if(arm_clothes)
			burning_items += arm_clothes

		//LEGS & FEET//
		var/obj/item/clothing/leg_clothes = null
		if(H.shoes)
			leg_clothes = H.shoes
		if(H.w_uniform && ((H.w_uniform.body_parts_covered & FEET) || (H.w_uniform.body_parts_covered & LEGS)))
			leg_clothes = H.w_uniform
		if(H.wear_suit && ((H.wear_suit.body_parts_covered & FEET) || (H.wear_suit.body_parts_covered & LEGS)))
			leg_clothes = H.wear_suit
		if(leg_clothes)
			burning_items += leg_clothes

		for(var/X in burning_items)
			var/obj/item/I = X
			if(!(I.resistance_flags & FIRE_PROOF))
				I.take_damage(H.fire_stacks, BURN, "fire", 0)

		var/thermal_protection = H.get_thermal_protection()

		if(thermal_protection >= FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT && !no_protection)
			return
		if(thermal_protection >= FIRE_SUIT_MAX_TEMP_PROTECT && !no_protection)
			H.bodytemperature += 11
		else
			H.bodytemperature += (BODYTEMP_HEATING_MAX + (H.fire_stacks * 12))

/datum/species/proc/CanIgniteMob(mob/living/carbon/human/H)
	if(NOFIRE in species_traits)
		return FALSE
	return TRUE

/datum/species/proc/ExtinguishMob(mob/living/carbon/human/H)
	return


////////
//Stun//
////////

/datum/species/proc/spec_stun(mob/living/carbon/human/H,amount)
	. = stunmod * amount

//////////////
//Space Move//
//////////////

/datum/species/proc/space_move(mob/living/carbon/human/H)
	return 0

/datum/species/proc/negates_gravity(mob/living/carbon/human/H)
	return 0

////////////
//Click On//
////////////

/datum/species/proc/specAltClickOn(atom/A)
	var/mob/living/carbon/human/H = usr
	if(H.dna && H.dna.species && (CONSUMEPOWER in H.dna.species.specflags) && A.Adjacent(H))
		return species_drain_act(H, A)
	return 0
