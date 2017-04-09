/datum/status_effect/z_level_lock
	id = "z_lock"
	duration = -1
	alert_type = null
	var/z_level
	var/message

/datum/status_effect/z_level_lock/on_apply()
	var/turf/T = get_turf(owner)
	z_level = T ? T.z : null

/datum/status_effect/z_level_lock/tick()
	var/turf/T = get_turf(owner)
	if(isnull(z_level) || isnull(T))
		if(!(isnull(z_level) && isnull(T)))
			kill()
	else if(T.z != z_level)
		kill()

/datum/status_effect/z_level_lock/proc/kill()
	if(message)
		owner << message
	owner.gib(TRUE, TRUE)

/datum/status_effect/z_level_lock/wizard_academy
	message = "<span class='userdanger'>You cannot leave the wizard academy!</span>"

//Largely negative status effects go here, even if they have small benificial effects

/datum/status_effect/sigil_mark //allows the affected target to always trigger sigils while mindless
	id = "sigil_mark"
	duration = -1
	alert_type = null
	var/stat_allowed = DEAD //if owner's stat is below this, will remove itself

/datum/status_effect/sigil_mark/tick()
	if(owner.stat < stat_allowed)
		qdel(src)

/datum/status_effect/his_wrath //does minor damage over time unless holding His Grace
	id = "his_wrath"
	duration = -1
	tick_interval = 4
	alert_type = /obj/screen/alert/status_effect/his_wrath

/obj/screen/alert/status_effect/his_wrath
	name = "His Wrath"
	desc = "You fled from His Grace instead of feeding Him, and now you suffer."
	icon_state = "his_grace"
	alerttooltipstyle = "hisgrace"

/datum/status_effect/his_wrath/tick()
	for(var/obj/item/weapon/his_grace/HG in owner.held_items)
		qdel(src)
		return
	owner.adjustBruteLoss(0.1)
	owner.adjustFireLoss(0.1)
	owner.adjustToxLoss(0.2, TRUE, TRUE)
