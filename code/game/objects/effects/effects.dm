/obj/effect
	icon = 'icons/effects/effects.dmi'
	var/use_fade = 1

/obj/effect/New()
	if(use_fade)
		alpha = 0
		..()
		animate(src, alpha = 255, time = 5)
	else
		..()

/obj/effect/proc/destroy_effect()
	if(use_fade)
		animate(src, alpha = 0, time = 5)
		QDEL_IN(src, 5)
	else
		qdel(src)
