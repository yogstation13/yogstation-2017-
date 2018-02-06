/obj/effect/decal
	name = "decal"
	anchored = 1


/obj/effect/decal/ex_act(severity, target)
	destroy_effect()

/obj/effect/turf_decal
	var/group = TURF_DECAL_PAINT
	icon = 'icons/turf/decals.dmi'
	icon_state = "warningline"
	layer = TURF_DECAL_LAYER
	anchored = TRUE
	var/mutable_appearance/pic

//in case we need some special decals
/obj/effect/turf_decal/proc/get_decal()
	return image(icon='icons/turf/decals.dmi',icon_state=icon_state,dir=dir,layer=TURF_LAYER)

/obj/effect/turf_decal/initialize()
	..()
	var/turf/T = loc
	if(!istype(T)) //you know this will happen somehow
		CRASH("Turf decal initialized in an object/nullspace")
	pic = new(get_decal())
	pic.color = color
	T.add_decal(pic, group)
	qdel(src)
