var/list/noise_database = list()

/obj/effect/noise
	name = "noise"
	desc = "Echo..."
	icon_state = "echo"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = 1
	opacity = 0
	var/echolength
	var/image/noiseimage
	var/list/crossed = list()

/obj/effect/noise/proc/channel()
	for(var/mob/living/carbon/alien/A in mob_list)
		if(A.client)
			noiseimage = image('icons/effects/effects.dmi',loc,"echo",MOB_LAYER)
			A.client.images |= noiseimage

	noise_database += src

	if(echolength)
		spawn(echolength)
			qdel(src)
	else
		qdel(src)

/obj/effect/noise/Destroy()
	noise_database -= src
	for(var/mob/living/carbon/alien/A in mob_list)
		if(A.client)
			A.client.images.Remove(noiseimage)
	return ..()

/obj/effect/noise/proc/echo(strength) // each value is another set of tiles around the original point
	var/turf/open/floor/F
	for(F in orange(strength, src))
		var/obj/effect/noise/N = new /obj/effect/noise(F)
		N.desc = desc
		N.echolength = echolength
		N.channel()

/obj/effect/noise/Crossed(AM as mob|obj)
	if(ismob(AM))
		crossed += AM
		spawn(100)
			crossed -= AM