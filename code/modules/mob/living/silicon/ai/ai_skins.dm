/datum/ai_skin
	var/name
	var/icon = 'icons/mob/AI.dmi'
	var/icon_state
	var/dead_icon = 'icons/mob/AI.dmi'
	var/dead_icon_state = "ai_dead"
	var/unbolted_icon
	var/unbolted_icon_state
	var/bolt_animation_icon
	var/unbolt_animation_icon_state
	var/rebolt_animation_icon_state
	var/donator_only = FALSE
	var/ckey_only

/datum/ai_skin/proc/apply_to(mob/living/silicon/ai/ai)
	ai.skin = src
	if(ai.stat == DEAD)
		ai.icon = dead_icon
		ai.icon_state = dead_icon_state
	else if(!ai.anchored && unbolted_icon)
		ai.icon = unbolted_icon
		ai.icon_state = unbolted_icon_state
	else
		ai.icon = icon
		ai.icon_state = icon_state

/datum/ai_skin/proc/can_be_used_by(mob/living/silicon/ai/ai)
	if(donator_only && !is_donator(ai))
		return FALSE
	if(ckey_only && !(ai.ckey in ckey_only))
		return FALSE
	return TRUE


/datum/ai_skin/default
	name = "Default"
	icon_state = "ai"

/datum/ai_skin/clown
	name = "Clown"
	icon_state = "ai-clown2"
	dead_icon_state = "ai-clown2_dead"

/datum/ai_skin/rainbow
	name = "Rainbow"
	icon_state = "ai-clown"
	dead_icon_state = "ai-clown_dead"

/datum/ai_skin/monocrome
	name = "Monochrome"
	icon_state = "ai-mono"
	dead_icon_state = "ai-mono_dead"

/datum/ai_skin/inverted
	name = "Inverted"
	icon_state = "ai-u"
	dead_icon_state = "ai-u_dead"

/datum/ai_skin/firewall
	name = "Firewall"
	icon_state = "ai-magma"

/datum/ai_skin/green
	name = "Green"
	icon_state = "ai-wierd"
	dead_icon_state = "ai-wierd_dead"

/datum/ai_skin/red
	name = "Red"
	icon_state = "ai-malf"
	dead_icon_state = "ai-malf_dead"

/datum/ai_skin/staticy
	name = "Static"
	icon_state = "ai-static"
	dead_icon_state = "ai-static_dead"

/datum/ai_skin/red_october
	name = "Red October"
	icon_state = "ai-redoctober"

/datum/ai_skin/house
	name = "House"
	icon_state = "ai-house"
	dead_icon_state = "ai-house_dead"

/datum/ai_skin/heartline
	name = "Heartline"
	icon_state = "ai-heartline"
	dead_icon_state = "ai-heartline_dead"

/datum/ai_skin/hades
	name = "Hades"
	icon_state = "ai-hades"
	dead_icon_state = "ai-hades_dead"
	dead_icon_state = "ai-hades_dead"

/datum/ai_skin/helios
	name = "Helios"
	icon_state = "ai-helios"

/datum/ai_skin/president
	name = "President"
	icon_state = "ai-pres"

/datum/ai_skin/meow
	name = "Syndicat Meow"
	icon_state = "ai-syndicatmeow"

/datum/ai_skin/alien
	name = "Alien"
	icon_state = "ai-alien"
	dead_icon_state = "ai-alien_dead"

/datum/ai_skin/deep
	name = "Too Deep"
	icon_state = "ai-toodeep"

/datum/ai_skin/triumvirate
	name = "Triumvirate"
	icon_state = "ai-triumvirate"

/datum/ai_skin/triumvirate_m
	name = "Triumvirate-M"
	icon_state = "ai-triumvirate-malf"

/datum/ai_skin/text
	name = "Text"
	icon_state = "ai-text"

/datum/ai_skin/matrix
	name = "Matrix"
	icon_state = "ai-matrix"

/datum/ai_skin/dorf
	name = "Dorf"
	icon_state = "ai-dorf"

/datum/ai_skin/bliss
	name = "Bliss"
	icon_state = "ai-bliss"

/datum/ai_skin/notmalf
	name = "Not Malf"
	icon_state = "ai-notmalf"

/datum/ai_skin/fuzzy
	name = "Fuzzy"
	icon_state = "ai-fuzz"

/datum/ai_skin/goon
	name = "Goon"
	icon_state = "ai-goon"
	dead_icon_state = "ai-goon_dead"

/datum/ai_skin/livininthedatabasewowow
	name = "Database"
	icon_state = "ai-database"
	dead_icon_state = "ai-database_dead"

/datum/ai_skin/glitchman
	name = "Glitchman"
	icon_state = "ai-glitchman"
	dead_icon_state = "ai-glitchman_dead"

/datum/ai_skin/murica
	name = "Murica"
	icon_state = "ai-murica"
	dead_icon_state = "ai-murica_dead"

/datum/ai_skin/nanotrasen
	name = "Nanotrasen"
	icon_state = "ai-nanotrasen"

/datum/ai_skin/gentoo
	name = "Gentoo"
	icon_state = "ai-gentoo"
	dead_icon_state = "ai-gentoo_dead"

/datum/ai_skin/blob
	name = "Blob"
	icon_state = "ai-blob"
	dead_icon_state = "ai-blob_dead"


/mob/living/silicon/ai/verb/pick_icon()
	set category = "AI Commands"
	set name = "Set AI Core Display"
	if(stat || aiRestorePowerRoutine)
		return

	var/static/list/skins
	if(!skins)
		skins = list()
		for(var/V in subtypesof(/datum/ai_skin))
			var/datum/ai_skin/skin = new V()
			skins[skin.name] = skin

	var/list/skinOptions = list()
	for(var/V in skins)
		var/datum/ai_skin/skin = skins[V]
		if(skin.can_be_used_by(src))
			skinOptions[V] = skin
	var/selected_skin = input("Select a display!", "AI") as null|anything in skinOptions
	if(!selected_skin)
		return
	skin = skinOptions[selected_skin]
	skin.apply_to(src)
