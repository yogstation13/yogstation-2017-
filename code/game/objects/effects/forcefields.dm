/obj/effect/forcefield
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon_state = "m_shield"
	anchored = 1
	opacity = 0
	density = 1
	CanAtmosPass = ATMOS_PASS_DENSITY

/obj/effect/forcefield/cult
	desc = "An unholy shield that blocks all attacks."
	name = "glowing wall"
	icon_state = "cultshield"

///////////Mimewalls///////////

/obj/effect/forcefield/mime
	icon_state = "empty"
	name = "invisible wall"
	desc = "You have a bad feeling about this."
	var/timeleft = 300

/obj/effect/forcefield/mime/New()
	..()
<<<<<<< HEAD
	last_process = world.time
	START_PROCESSING(SSobj, src)

/obj/effect/forcefield/mime/process()
	timeleft -= (world.time - last_process)
	if(timeleft <= 0)
		STOP_PROCESSING(SSobj, src)
		qdel(src)
=======
	QDEL_IN(src, timeleft)
>>>>>>> masterTGbranch
