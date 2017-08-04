/datum/robot_skin
	var/name
	var/transform_animation_length = 0
	var/icon/transform_animation_icon = 'icons/mob/robot_transformations.dmi'
	var/transform_animation_icon_state

	var/icon/icon = 'icons/mob/robots.dmi'
	var/icon_state

	var/headlamp_eye_icon = 'icons/mob/robots.dmi'
	var/eye_icon_state
	var/headlight_icon_state

	var/open_cover_icon = 'icons/mob/robots.dmi'
	var/open_cover_wires_icon_state = "ov-opencover +w"
	var/open_cover_cell_icon_state  = "ov-opencover +c"
	var/open_cover_empty_icon_state = "ov-opencover -c"

	var/list/modules = list()

	var/donator_only = FALSE
	var/list/ckey_only

/datum/robot_skin/proc/can_be_used_by(mob/living/silicon/robot/M)
	if(donator_only && !is_donator(M))
		return FALSE
	if(ckey_only && !(M.ckey in ckey_only))
		return FALSE
	return TRUE

//Standard
/datum/robot_skin/standard
	name = "Standard"
	icon_state = "robot"
	eye_icon_state = "eyes-standard"
	headlight_icon_state = "eyes-standard-lights"
	modules = list(/obj/item/weapon/robot_module/standard)

/datum/robot_skin/standard_droid
	name = "Droid"
	icon_state = "droid"
	eye_icon_state = "eyes-droid"
	headlight_icon_state = "eyes-droid-lights"
	modules = list(/obj/item/weapon/robot_module/standard)


//Medical
/datum/robot_skin/mediborg
	name = "Mediborg"
	icon_state = "mediborg"
	transform_animation_icon_state = "mediborg"
	transform_animation_length = 36
	eye_icon_state = "eyes-mediborg"
	headlight_icon_state = "eyes-mediborg-lights"
	modules = list(/obj/item/weapon/robot_module/medical)

/datum/robot_skin/medihover
	name = "Medihover"
	icon_state = "medihover"
	eye_icon_state = "eyes-medihover"
	headlight_icon_state = "eyes-medihover-lights"
	modules = list(/obj/item/weapon/robot_module/medical)

/datum/robot_skin/medismile
	name = "Smile Screen"
	icon_state = "mediborg+smile"
	eye_icon_state = "eyes-medihover"
	transform_animation_icon_state = "mediborg+smile"
	transform_animation_length = 36
	headlight_icon_state = "eyes-mediborg-lights"
	modules = list(/obj/item/weapon/robot_module/medical)

/datum/robot_skin/medidroid
	name = "Medical Droid"
	icon_state = "droid-medical"
	eye_icon_state = "eyes-droid-medical"
	headlight_icon_state = "eyes-droid-medical-lights"
	modules = list(/obj/item/weapon/robot_module/medical)

/datum/robot_skin/mediblue
	name = "Blue"
	icon_state = "mediborg-blue"
	eye_icon_state = "eyes-mediborg-blue"
	headlight_icon_state = "eyes-mediborg-blue-lights"
	modules = list(/obj/item/weapon/robot_module/medical)


//Engineering
/datum/robot_skin/engiyellow
	name = "Yellow"
	icon_state = "engiborg-yellow"
	eye_icon_state = "eyes-engiborg-yellow"
	headlight_icon_state = "eyes-standard-lights"
	modules = list(/obj/item/weapon/robot_module/engineering)

/datum/robot_skin/engiborg
	name = "Engiborg"
	icon_state = "engiborg"
	transform_animation_icon_state = "engiborg"
	transform_animation_length = 45
	eye_icon_state = "eyes-engiborg"
	headlight_icon_state = "eyes-engiborg-lights"
	modules = list(/obj/item/weapon/robot_module/engineering)


//Security
/datum/robot_skin/secborg
	name = "Secborg"
	icon_state = "secborg"
	transform_animation_icon_state = "secborg"
	transform_animation_length = 28
	eye_icon_state = "eyes-secborg"
	headlight_icon_state = "eyes-secborg-lights"
	modules = list(/obj/item/weapon/robot_module/security)


//Peacekeeper
/datum/robot_skin/peaceborg
	name = "Peaceborg"
	icon_state = "peaceborg"
	transform_animation_icon_state = "peaceborg"
	transform_animation_length = 56
	eye_icon_state = "eyes-peaceborg"
	headlight_icon_state = "eyes-peaceborg-lights"
	modules = list(/obj/item/weapon/robot_module/peacekeeper)

//Janitor
/datum/robot_skin/janiborg
	name = "Janiborg"
	icon_state = "janiborg"
	transform_animation_icon_state = "janiborg"
	transform_animation_length = 22
	eye_icon_state = "eyes-janiborg"
	headlight_icon_state = "eyes-janiborg-lights"
	modules = list(/obj/item/weapon/robot_module/janitor)

/datum/robot_skin/disposal
	name = "Disposal"
	icon_state = "disposalbot"
	eye_icon_state = "eyes-disposalbot"
	headlight_icon_state = "eyes-disposalbot-lights"
	modules = list(/obj/item/weapon/robot_module/janitor)

/datum/robot_skin/janipurple
	name = "Purple"
	icon_state = "janiborg-purple"
	eye_icon_state = "eyes-janiborg-purple"
	headlight_icon_state = "eyes-standard-lights"
	modules = list(/obj/item/weapon/robot_module/janitor)


//Service
/datum/robot_skin/brobot
	name = "Bro"
	icon_state = "brobot"
	transform_animation_icon_state = "brobot"
	transform_animation_length = 55
	headlight_icon_state = "eyes-brobot-lights"
	modules = list(/obj/item/weapon/robot_module/butler)

/datum/robot_skin/waitress
	name = "Waitress"
	icon_state = "service_female"
	transform_animation_icon_state = "service_female"
	transform_animation_length = 44
	headlight_icon_state = "eyes-service_female-lights"
	modules = list(/obj/item/weapon/robot_module/butler)

/datum/robot_skin/maximillion
	name = "Rich"
	icon_state = "maximillion"
	transform_animation_icon_state = "maximillion"
	transform_animation_length = 60
	headlight_icon_state = "eyes-maximillion-lights"
	modules = list(/obj/item/weapon/robot_module/butler)

/datum/robot_skin/butler
	name = "Butler"
	icon_state = "service_male"
	transform_animation_icon_state = "service_male"
	transform_animation_length = 43
	headlight_icon_state = "eyes-service_male-lights"
	modules = list(/obj/item/weapon/robot_module/butler)

/datum/robot_skin/toilet
	name = "Kent"
	icon_state = "toiletbot"
	eye_icon_state = "eyes-mediborg"
	headlight_icon_state = "eyes-mediborg-lights"
	modules = list(/obj/item/weapon/robot_module/butler)

//Mining
/datum/robot_skin/miningborg
	name = "Minerborg"
	icon_state = "minerborg"
	transform_animation_icon_state = "minerborg"
	eye_icon_state = "eyes-minerborg"
	transform_animation_length = 30
	headlight_icon_state = "eyes-minerborg-lights"
	modules = list(/obj/item/weapon/robot_module/miner)

/datum/robot_skin/minerdroid
	name = "Miner Droid"
	icon_state = "droid-miner"
	eye_icon_state = "eyes-droid-miner"
	headlight_icon_state = "eyes-droid-lights"
	modules = list(/obj/item/weapon/robot_module/miner)


//Clown
/datum/robot_skin/clown
	name = "Clown"
	icon_state = "ClownBot"
	transform_animation_icon_state = "ClownBot"
	transform_animation_length = 19
	headlight_icon_state = "eyes-ClownBot-lights"
	modules = list(/obj/item/weapon/robot_module/clown)

/datum/robot_skin/wiz
	name = "Wizard Bot"
	icon_state = "WizardBot"
	headlight_icon_state = "eyes-WizardBot-lights"
	modules = list(/obj/item/weapon/robot_module/clown)

/datum/robot_skin/wizborg
	name = "Wizard Borg"
	icon_state = "WizardBorg"
	headlight_icon_state = "eyes-WizardBorg-lights"
	modules = list(/obj/item/weapon/robot_module/clown)

/datum/robot_skin/chicken
	name = "Chicken"
	icon_state = "ChickenBot"
	headlight_icon_state = "eyes-ChickenBot-lights"
	modules = list(/obj/item/weapon/robot_module/clown)

//Syndicate
/datum/robot_skin/syndicate
	name = "Syndicate Assault"
	icon_state = "syndie_bloodhound"
	eye_icon_state = "eyes-syndie_bloodhound"
	headlight_icon_state = "eyes-syndie_bloodhound-lights"
	modules = list(/obj/item/weapon/robot_module/syndicate)

/datum/robot_skin/syndi_med
	name = "Syndicate Medical"
	icon_state = "syndi-medi"
	headlight_icon_state = "eyes-syndi-medi-lights"
	modules = list(/obj/item/weapon/robot_module/syndicate_medical)


//Mixed
//Engineering, Mining
/datum/robot_skin/wall_e
	name = "Wall-E"
	icon_state = "wall-eng"
	eye_icon_state = "eyes-wall-eng"
	headlight_icon_state = "eyes-wall-eng-lights"
	modules = list(/obj/item/weapon/robot_module/engineering, /obj/item/weapon/robot_module/miner)
	donator_only = TRUE

//Service, Medical
/datum/robot_skin/eve
	name = "Eve"
	icon_state = "eve"
	eye_icon_state = "eyes-eve"
	headlight_icon_state = "eyes-eve-lights"
	modules = list(/obj/item/weapon/robot_module/butler, /obj/item/weapon/robot_module/medical)
	donator_only = TRUE
