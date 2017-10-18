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
		to_chat(owner, message)
	owner.gib(TRUE, TRUE)

/datum/status_effect/z_level_lock/wizard_academy
	message = "<span class='userdanger'>You cannot leave the wizard academy!</span>"