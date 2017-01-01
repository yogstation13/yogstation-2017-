/*
	This is /tg/'s 'newer' lighting system. It's basically a combination of Forum_Account's and ShadowDarke's
	respective lighting libraries heavily modified by Carnwennan for /tg/station with further edits by
	MrPerson. Credits, where due, to them.

	Originally, like all other lighting libraries on BYOND, we used areas to render different hard-coded light levels.
	The idea was that this was cheaper than using objects. Well as it turns out, the cost of the system is primarily from the
	massive loops the system has to run, not from the areas or objects actually doing any work. Thus the newer system uses objects
	so we can have more lighting states and smooth transitions between them.

	This is a queueing system. Everytime we call a change to opacity or luminosity throwgh SetOpacity() or SetLuminosity(),
	we are simply updating variables and scheduling certain lights/turfs for an update. Actual updates are handled
	periodically by the SSlighting subsystem. Specifically, it runs check() on every light datum that ran changed().
	Then it runs redraw_lighting() on every turf that ran update_lumcount().

	Unlike our older system, there are hardcoded maximum luminosities (different for certain atoms).
	This is to cap the cost of creating lighting effects.
	(without this, an atom with luminosity of 20 would have to update 41^2 turfs!) :s

	Each light remembers the effect it casts on each turf. It reduces cost of removing lighting effects by a lot!

	Known Issues/TODO:
		Shuttles still do not have support for dynamic lighting (I hope to fix this at some point) -probably trivial now
		No directional lighting support. (prototype looked ugly)
		Allow lights to be weaker than 'cap' radius
		Colored lights
*/

#define LIGHTING_CIRCULAR 1									//Comment this out to use old square lighting effects.
//#define LIGHTING_LAYER 15									//Drawing layer for lighting, moved to layers.dm
#define LIGHTING_CAP 10										//The lumcount level at which alpha is 0 and we're fully lit.
#define LIGHTING_CAP_FRAC (255/LIGHTING_CAP)				//A precal'd variable we'll use in turf/redraw_lighting()
#define LIGHTING_ICON 'icons/effects/alphacolors.dmi'
#define LIGHTING_ICON_STATE ""
#define LIGHTING_TIME 2									//Time to do any lighting change. Actual number pulled out of my ass
#define LIGHTING_DARKEST_VISIBLE_ALPHA 250					//Anything darker than this is so dark, we'll just consider the whole tile unlit
#define LIGHTING_LUM_FOR_FULL_BRIGHT 6						//Anything who's lum is lower then this starts off less bright.
#define LIGHTING_MIN_RADIUS 4								//Lowest radius a light source can effect.

/datum/light_source
	var/atom/owner
	var/radius = 0
	var/luminosity = 0
	var/cap = 0
	var/changed = 0

	// I'd love to use a string for this, but that's processing time wasted. Much cheaper just to use 3 ints.
	var/r = 1
	var/g = 1
	var/b = 1
	var/list/effect_r = list()
	var/list/effect_g = list()
	var/list/effect_b = list()
	var/__x = 0		//x coordinate at last update
	var/__y = 0		//y coordinate at last update

/datum/light_source/New(atom/A)
	if(!istype(A))
		CRASH("The first argument to the light object's constructor must be the atom that is the light source. Expected atom, received '[A]' instead.")
	..()
	owner = A
	UpdateLuminosity(A.luminosity)

/datum/light_source/Destroy()
	if(owner && owner.light == src)
		remove_effect()
		owner.light = null
		owner.luminosity = 0
		owner = null
	if(changed)
		SSlighting.changed_lights -= src
	return ..()

/datum/light_source/proc/UpdateLuminosity(new_luminosity, new_cap)
	if(new_luminosity < 0)
		new_luminosity = 0

	if(luminosity == new_luminosity && (new_cap == null || cap == new_cap))
		return

	radius = max(LIGHTING_MIN_RADIUS, new_luminosity)
	luminosity = new_luminosity
	if (new_cap != null)
		cap = new_cap

	changed()


//Check a light to see if its effect needs reprocessing. If it does, remove any old effect and create a new one
/datum/light_source/proc/check()
	if(!owner)
		remove_effect()
		return 0

	if(changed)
		changed = 0
		remove_effect()
		return add_effect()

	return 1

//Tell the lighting subsystem to check() next fire
/datum/light_source/proc/changed()
	if(owner)
		__x = owner.x
		__y = owner.y
	if(!changed)
		changed = 1
		SSlighting.changed_lights |= src

//Remove current effect
/datum/light_source/proc/remove_effect().
	for(var/turf/T in effect_r)
		T.update_lumcount(-effect_r[T], -effect_g[T], -effect_b[T]) // This conveniently loops just through the one list, but unless everything stops making sence, R,G,B should have the same keys.

		if(T.affecting_lights && T.affecting_lights.len)
			T.affecting_lights -= src

	effect_r.Cut()
	effect_g.Cut()
	effect_b.Cut()

//Apply a new effect.
/datum/light_source/proc/add_effect()
	// only do this if the light is turned on and is on the map
	if(!owner || !owner.loc)
		return 0
	var/range = owner.get_light_range(radius)
	if(range <= 0 || luminosity <= 0)
		owner.luminosity = 0
		return 0

	effect_r = list()
	effect_g = list()
	effect_b = list()
	var/turf/To = get_turf(owner)


	for(var/atom/movable/AM in To)
		if(AM == owner)
			continue
		if(AM.opacity)
			range = 0
			break

	owner.luminosity = range
	if (!range)
		return 0
	var/center_strength = 0
	if (cap <= 0)
		center_strength = LIGHTING_CAP/LIGHTING_LUM_FOR_FULL_BRIGHT*(luminosity)
	else
		center_strength = cap

	for(var/turf/T in view(range+1, To))

#ifdef LIGHTING_CIRCULAR
		var/distance = cheap_hypotenuse(T.x, T.y, __x, __y)
#else
		var/distance = max(abs(T,x - __x), abs(T.y - __y))
#endif

		var/delta_lumcount = Clamp(center_strength * (range - distance) / range, 0, LIGHTING_CAP)

		if(delta_lumcount > 0)

			var/max_col = max(r,g,b)
			var/addR = 0
			var/addG = 0
			var/addB = 0
			if(max_col<=0) // Because Dividing by 0 will crash us. And I don't trust user input.
				addR = 1/3
				addG = 1/3
				addB = 1/3
			else
				addR = r/max_col
				addG = g/max_col
				addB = b/max_col


			addR *= delta_lumcount
			addG *= delta_lumcount
			addB *= delta_lumcount

			effect_r[T] = addR
			effect_g[T] = addG
			effect_b[T] = addB
			T.update_lumcount(addR,addG,addB)

			if(!T.affecting_lights)
				T.affecting_lights = list()
			T.affecting_lights |= src

	return 1

/atom
	var/datum/light_source/light


//Turfs with opacity when they are constructed will trigger nearby lights to update
//Turfs and atoms with luminosity when they are constructed will create a light_source automatically
/turf/New()
	..()
	if(luminosity)
		light = new(src)

//Movable atoms with opacity when they are constructed will trigger nearby lights to update
//Movable atoms with luminosity when they are constructed will create a light_source automatically
/atom/movable/New()
	..()
	if(opacity && isturf(loc))
		loc.UpdateAffectingLights()
	if(luminosity)
		light = new(src)

//Objects with opacity will trigger nearby lights to update at next SSlighting fire
/atom/movable/Destroy()
	qdel(light)
	if(opacity && isturf(loc))
		loc.UpdateAffectingLights()
	return ..()

//Objects with opacity will trigger nearby lights of the old location to update at next SSlighting fire
/atom/movable/Moved(atom/OldLoc, Dir)
	if(opacity)
		if (isturf(OldLoc))
			OldLoc.UpdateAffectingLights()
		if (isturf(loc))
			loc.UpdateAffectingLights()
	else
		if(light)
			light.changed()
	return ..()

//Sets our luminosity.
//If we have no light it will create one.
//If we are setting luminosity to 0 the light will be cleaned up by the controller and garbage collected once all its
//queues are complete.
//if we have a light already it is merely updated, rather than making a new one.
//The second arg allows you to scale the light cap for calculating falloff.

/atom/proc/SetLuminosity(new_luminosity, new_cap)
	if (!light)
		if (new_luminosity <= 0)
			return
		light = new(src)

	light.UpdateLuminosity(new_luminosity, new_cap)

/atom/proc/SetLightColor(col)
	if (!light)
		light = new(src)
	light.r = hex2num(copytext(col,2,4))
	light.g = hex2num(copytext(col,4,6))
	light.b = hex2num(copytext(col,6,0))
	light.changed()

/atom/proc/AddLuminosity(delta_luminosity)
	if(light)
		SetLuminosity(light.luminosity + delta_luminosity)
	else
		SetLuminosity(delta_luminosity)

/area/SetLuminosity(new_luminosity)			//we don't want dynamic lighting for areas
	luminosity = !!new_luminosity


//change our opacity (defaults to toggle), and then update all lights that affect us.
/atom/proc/SetOpacity(new_opacity)
	if(new_opacity == null)
		new_opacity = !opacity			//default = toggle opacity
	else if(opacity == new_opacity)
		return 0						//opacity hasn't changed! don't bother doing anything
	opacity = new_opacity				//update opacity, the below procs now call light updates.
	UpdateAffectingLights()
	return 1

/atom/movable/light
	icon = LIGHTING_ICON
	icon_state = LIGHTING_ICON_STATE
	layer = LIGHTING_LAYER
	mouse_opacity = 0
	blend_mode = BLEND_MULTIPLY
	invisibility = INVISIBILITY_LIGHTING
	color = "#000"
	luminosity = 0
	infra_luminosity = 1
	anchored = 1

/atom/movable/light/Destroy(force)
	if(force)
		. = ..()
	else
		return QDEL_HINT_LETMELIVE

/atom/movable/light/Move()
	return 0

/atom/movable/light/dim
	color = "#000" // Always half bright.
	alpha = 0 // Only visible when the tile it's on is ~pure black.
	invisibility = 0 // Never invisible. Might be a bit annoying for observers. Might.
	layer = TURF_LAYER // Don't darken things on top of the turf.

/turf
	var/r_lumcount = 0
	var/g_lumcount = 0
	var/b_lumcount = 0
	var/lighting_changed = 0
	var/atom/movable/light/lighting_object //Will be null for space turfs and anything in a static lighting area
	var/atom/movable/light/dim/light_dim  // Used for shadowlings and night vision and stuffs, to show pure black areas, but make them still visible... So to speak...
	var/list/affecting_lights			//not initialised until used (even empty lists reserve a fair bit of memory)

/turf/ChangeTurf(path)
	if(!path || (!use_preloader && path == type)) //Sucks this is here but it would cause problems otherwise.
		return ..()

	for(var/obj/effect/decal/cleanable/decal in src.contents)
		qdel(decal)

	if(light)
		qdel(light)

	var/old_r_lumcount = r_lumcount - initial(r_lumcount)
	var/old_g_lumcount = g_lumcount - initial(g_lumcount)
	var/old_b_lumcount = b_lumcount - initial(b_lumcount)
	var/oldbaseturf = baseturf

	var/list/our_lights //reset affecting_lights if needed
	if(opacity != initial(path:opacity) && (old_r_lumcount || old_g_lumcount || old_b_lumcount))
		UpdateAffectingLights()

	if(affecting_lights)
		our_lights = affecting_lights.Copy()

	. = ..() //At this point the turf has changed

	affecting_lights = our_lights

	lighting_changed = 1 //Don't add ourself to SSlighting.changed_turfs
	update_lumcount(old_r_lumcount, old_g_lumcount, old_b_lumcount)
	baseturf = oldbaseturf
	lighting_object = locate() in src
	init_lighting()

	for(var/turf/open/space/S in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
		S.update_starlight()

/turf/proc/update_lumcount(r, g, b)
	r_lumcount += r
	g_lumcount += g
	b_lumcount += b
	if(!lighting_changed)
		SSlighting.changed_turfs += src
		lighting_changed = 1

/turf/open/space/update_lumcount(r,g,b) //Keep track in case the turf becomes a floor at some point, but don't process.
	r_lumcount += r
	g_lumcount += g
	b_lumcount += b

/turf/proc/init_lighting()
	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(A))
		if(lighting_changed)
			lighting_changed = 0
		if(lighting_object)
			lighting_object.alpha = 0
			qdel(lighting_object)
			lighting_object = null
	else
		if(!lighting_object)
			lighting_object = new (src)
		if(!light_dim)
			light_dim = new (src)
		redraw_lighting(1)
		for(var/turf/open/space/T in RANGE_TURFS(1,src))
			T.update_starlight()


/turf/open/space/init_lighting()
	if(lighting_changed)
		lighting_changed = 0
	if(lighting_object)
		lighting_object.alpha = 0
		lighting_object = null

/turf/proc/redraw_lighting(instantly = 0)
	if(lighting_object)
		var/newcolor
		if(r_lumcount + g_lumcount + b_lumcount <= 0)
			newcolor = "#000000"
		else
			var/max_val = max(r_lumcount,g_lumcount,b_lumcount)

			var/R = r_lumcount / max_val
			var/G = g_lumcount / max_val
			var/B = b_lumcount / max_val

			var/val = (Clamp(r_lumcount + g_lumcount + b_lumcount, 0, LIGHTING_CAP)/LIGHTING_CAP)*255
			R *= val
			G *= val
			B *= val

			newcolor = "#" + num2hex(R) + num2hex(G) + num2hex(B)
		if(lighting_object.color != newcolor)
			if(instantly)
				lighting_object.color = newcolor
			else
				animate(lighting_object, color = newcolor, time = LIGHTING_TIME)


	lighting_changed = 0

/turf/proc/get_lumcount()
	. = LIGHTING_CAP
	var/area/A = src.loc
	if(IS_DYNAMIC_LIGHTING(A))
		. = src.r_lumcount + src.g_lumcount + src.b_lumcount
	return .

/area
	var/lighting_use_dynamic = DYNAMIC_LIGHTING_ENABLED	//Turn this flag off to make the area fullbright

/area/New()
	. = ..()
	if(lighting_use_dynamic != DYNAMIC_LIGHTING_ENABLED)
		luminosity = 1

/area/proc/SetDynamicLighting()
	if (lighting_use_dynamic == DYNAMIC_LIGHTING_DISABLED)
		lighting_use_dynamic = DYNAMIC_LIGHTING_ENABLED
	luminosity = 0
	for(var/turf/T in src.contents)
		T.init_lighting()
		T.update_lumcount(0,0,0)

#undef LIGHTING_CIRCULAR
#undef LIGHTING_ICON
#undef LIGHTING_ICON_STATE
#undef LIGHTING_TIME
#undef LIGHTING_CAP
#undef LIGHTING_CAP_FRAC
#undef LIGHTING_DARKEST_VISIBLE_ALPHA
#undef LIGHTING_LUM_FOR_FULL_BRIGHT
#undef LIGHTING_MIN_RADIUS


//set the changed status of all lights which could have possibly lit this atom.
//We don't need to worry about lights which lit us but moved away, since they will have change status set already
//This proc can cause lots of lights to be updated. :(
/atom/proc/UpdateAffectingLights()

/atom/movable/UpdateAffectingLights()
	if(isturf(loc))
		loc.UpdateAffectingLights()

/turf/UpdateAffectingLights()
	if(affecting_lights)
		for(var/datum/light_source/thing in affecting_lights)
			if (!thing.changed)
				thing.changed()			//force it to update at next process()


#define LIGHTING_MAX_LUMINOSITY_STATIC	8	//Maximum luminosity to reduce lag.
#define LIGHTING_MAX_LUMINOSITY_MOBILE	7	//Moving objects have a lower max luminosity since these update more often. (lag reduction)
#define LIGHTING_MAX_LUMINOSITY_MOB		6
#define LIGHTING_MAX_LUMINOSITY_TURF	8	//turfs are static too, why was this 1?!

//caps luminosity effects max-range based on what type the light's owner is.
/atom/proc/get_light_range(radius)
	return min(radius, LIGHTING_MAX_LUMINOSITY_STATIC)

/atom/movable/get_light_range(radius)
	return min(radius, LIGHTING_MAX_LUMINOSITY_MOBILE)

/mob/get_light_range(radius)
	return min(radius, LIGHTING_MAX_LUMINOSITY_MOB)

/obj/machinery/light/get_light_range(radius)
	return min(radius, LIGHTING_MAX_LUMINOSITY_STATIC)

/turf/get_light_range(radius)
	return min(radius, LIGHTING_MAX_LUMINOSITY_TURF)

#undef LIGHTING_MAX_LUMINOSITY_STATIC
#undef LIGHTING_MAX_LUMINOSITY_MOBILE
#undef LIGHTING_MAX_LUMINOSITY_MOB
#undef LIGHTING_MAX_LUMINOSITY_TURF
