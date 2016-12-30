
/*****************************Survival Pod********************************/


/area/survivalpod
	name = "\improper Emergency Shelter"
	icon_state = "away"
	requires_power = 0
	has_gravity = 1

/obj/item/weapon/survivalcapsule
	name = "bluespace shelter capsule"
	desc = "An emergency shelter stored within a pocket of bluespace."
	icon_state = "capsule"
	icon = 'icons/obj/mining.dmi'
	w_class = 1
	origin_tech = "engineering=3;bluespace=3"
	var/template_id = "shelter_alpha"
	var/datum/map_template/shelter/template
	var/used = FALSE

/obj/item/weapon/survivalcapsule/proc/get_template()
	if(template)
		return
	template = shelter_templates[template_id]
	if(!template)
		throw EXCEPTION("Shelter template ([template_id]) not found!")
		qdel(src)

/obj/item/weapon/survivalcapsule/Destroy()
	template = null // without this, capsules would be one use. per round.
	. = ..()

/obj/item/weapon/survivalcapsule/examine(mob/user)
	. = ..()
	get_template()
	user << "This capsule has the [template.name] stored."
	user << template.description

/obj/item/weapon/survivalcapsule/attack_self()
	// Can't grab when capsule is New() because templates aren't loaded then
	get_template()
	if(used == FALSE)
		src.loc.visible_message("<span class='warning'>\The [src] begins \
			to shake. Stand back!</span>")
		used = TRUE
		sleep(50)
		var/turf/deploy_location = get_turf(src)
		var/status = template.check_deploy(deploy_location)
		switch(status)
			if(SHELTER_DEPLOY_BAD_AREA)
				src.loc.visible_message("<span class='warning'>\The [src] \
				will not function in this area.</span>")
			if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
				var/width = template.width
				var/height = template.height
				src.loc.visible_message("<span class='warning'>\The [src] \
				doesn't have room to deploy! You need to clear a \
				[width]x[height] area!</span>")

		if(status != SHELTER_DEPLOY_ALLOWED)
			used = FALSE
			return

		playsound(get_turf(src), 'sound/effects/phasein.ogg', 100, 1)

		template.load(deploy_location, centered = TRUE)
		PoolOrNew(/obj/effect/particle_effect/smoke, get_turf(src))
		qdel(src)

/*****************************Sinew Tent********************************/


/obj/item/weapon/sinew_tent
	name = "sinew tent"
	desc = "A small sinew and bone box with a spring loaded tent."
	icon_state = "tent"
	icon = 'icons/obj/mining.dmi'
	w_class = 1
	origin_tech = "engineering=1"
	var/template_id = "shelter_beta"
	var/datum/map_template/shelter/template
	var/used = FALSE

/obj/item/weapon/sinew_tent/proc/get_template()
	if(template)
		return
	template = shelter_templates[template_id]
	if(!template)
		throw EXCEPTION("Shelter template ([template_id]) not found!")
		qdel(src)

/obj/item/weapon/sinew_tent/Destroy()
	template = null // without this, capsules would be one use. per round.
	. = ..()

/obj/item/weapon/sinew_tent/examine(mob/user)
	. = ..()
	get_template()
	user << "This box has the [template.name] stored."
	user << template.description

/obj/item/weapon/sinew_tent/attack_self()
	// Can't grab when capsule is New() because templates aren't loaded then
	get_template()
	if(used == FALSE)
		src.loc.visible_message("<span class='warning'>\The [src] begins \
			to shake. Stand back!</span>")
		used = TRUE
		sleep(50)
		var/turf/deploy_location = get_turf(src)
		var/status = template.check_deploy(deploy_location)
		switch(status)
			if(SHELTER_DEPLOY_BAD_AREA)
				src.loc.visible_message("<span class='warning'>\The [src] \
				will not function in this area.</span>")
			if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
				var/width = template.width
				var/height = template.height
				src.loc.visible_message("<span class='warning'>\The [src] \
				doesn't have room to deploy! You need to clear a \
				[width]x[height] area!</span>")

		if(status != SHELTER_DEPLOY_ALLOWED)
			used = FALSE
			return

		playsound(get_turf(src), 'sound/effects/splat.ogg', 100, 1)

		var/turf/T = deploy_location
		if(T.z != ZLEVEL_MINING && T.z != ZLEVEL_LAVALAND)//only report capsules away from the mining/lavaland level
			message_admins("[key_name_admin(usr)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) activated a sinew tent away from the mining level! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)")
			log_admin("[key_name(usr)] activated a sinew tent away from the mining level at [T.x], [T.y], [T.z]")
		template.load(deploy_location, centered = TRUE)
		PoolOrNew(/obj/effect/particle_effect/smoke, get_turf(src))
		qdel(src)

//Pod turfs and objects


//Floors
/turf/open/floor/pod
	name = "pod floor"
	icon_state = "podfloor"
	icon_regular_floor = "podfloor"
	floor_tile = /obj/item/stack/tile/pod

/turf/open/floor/pod/light
	icon_state = "podfloor_light"
	icon_regular_floor = "podfloor_light"
	floor_tile = /obj/item/stack/tile/pod/light

/turf/open/floor/pod/dark
	icon_state = "podfloor_dark"
	icon_regular_floor = "podfloor_dark"
	floor_tile = /obj/item/stack/tile/pod/dark

//Walls
/turf/closed/wall/shuttle/survival
	name = "pod wall"
	desc = "An easily-compressable wall used for temporary shelter."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "smooth"
	walltype = "shuttle"
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(/turf/closed/wall/shuttle/survival, /obj/machinery/door/airlock/survival_pod, /obj/structure/window/shuttle/survival_pod, /obj/structure/shuttle/engine)

/turf/closed/wall/shuttle/survival/nodiagonal
	smooth = SMOOTH_MORE

/turf/closed/wall/shuttle/survival/pod
	canSmoothWith = list(/turf/closed/wall/shuttle/survival, /obj/machinery/door/airlock, /obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/shuttle, /obj/structure/shuttle/engine)

//Window
/obj/structure/window/shuttle/survival_pod
	name = "pod window"
	icon = 'icons/obj/smooth_structures/pod_window.dmi'
	icon_state = "smooth"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/wall/shuttle/survival, /obj/machinery/door/airlock/survival_pod, /obj/structure/window/shuttle/survival_pod)

//Door
/obj/machinery/door/airlock/survival_pod
	name = "airlock"
	icon = 'icons/obj/doors/airlocks/survival/horizontal/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/horizontal/survival_overlays.dmi'
	doortype = /obj/structure/door_assembly/door_assembly_pod
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/survival_pod/vertical
	icon = 'icons/obj/doors/airlocks/survival/vertical/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/vertical/survival_overlays.dmi'
	doortype = /obj/structure/door_assembly/door_assembly_pod/vertical

/obj/structure/door_assembly/door_assembly_pod
	name = "pod airlock assembly"
	icon = 'icons/obj/doors/airlocks/survival/horizontal/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/horizontal/survival_overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/survival_pod
	anchored = 1
	state = 1
	mineral = "glass"
	material = "glass"

/obj/structure/door_assembly/door_assembly_pod/vertical
	icon = 'icons/obj/doors/airlocks/survival/vertical/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/vertical/survival_overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/survival_pod/vertical

//Table
/obj/structure/table/survival_pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE

//Sleeper
/obj/machinery/sleeper/survival_pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "sleeper"

/obj/machinery/sleeper/survival_pod/update_icon()
	if(state_open)
		overlays.Cut()
	else
		overlays += "sleeper_cover"


//Bed
/obj/structure/bed/pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "bed"

//Fans
/obj/structure/fans
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "fans"
	name = "environmental regulation system"
	desc = "A large machine releasing a constant gust of air."
	anchored = 1
	density = 1
	var/arbitraryatmosblockingvar = TRUE
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 5

/obj/structure/fans/deconstruct()
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/fans/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench) && !(flags&NODECONSTRUCT))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] disassembles the fan.</span>", \
						"<span class='notice'>You start to disassemble the fan...</span>", "You hear clanking and banging noises.")
		if(do_after(user, 20/W.toolspeed, target = src))
			deconstruct()
			return ..()

/obj/structure/fans/tiny
	name = "tiny fan"
	desc = "A tiny fan, releasing a thin gust of air."
	layer = ABOVE_NORMAL_TURF_LAYER
	density = 0
	icon_state = "fan_tiny"
	buildstackamount = 2

/obj/structure/fans/New(loc)
	..()
	air_update_turf(1)

/obj/structure/fans/Destroy()
	arbitraryatmosblockingvar = FALSE
	air_update_turf(1)
	return ..()

/obj/structure/fans/CanAtmosPass(turf/T)
	return !arbitraryatmosblockingvar

//Signs
/obj/structure/sign/mining
	name = "nanotrasen mining corps sign"
	desc = "A sign of relief for weary miners, and a warning for would be competitors to Nanotrasen's mining claims."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "ntpod"

/obj/structure/sign/mining/survival
	name = "shelter sign"
	desc = "A high visibility sign designating a safe shelter."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "survival"

//Fluff
/obj/structure/tubes
	icon_state = "tubes"
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	name = "tubes"
	anchored = 1
	layer = BELOW_MOB_LAYER
	density = 0