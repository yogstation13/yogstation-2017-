var/datum/subsystem/objects/SSobj

#define INITIALIZATION_INSSOBJ 0		//New should not call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 1	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR 2	//New should call Initialize(FALSE)

/datum/var/isprocessing = 0

/datum/proc/process()
	set waitfor = 0
	STOP_PROCESSING(SSobj, src)
	return 0

/datum/subsystem/objects
	name = "Objects"
	init_order = 12
	priority = 40

	var/initialized = INITIALIZATION_INSSOBJ
	var/old_initialized
	var/list/atom_spawners = list()
	var/list/processing = list()
	var/list/currentrun = list()
	var/list/burning = list()

/datum/subsystem/objects/New()
	NEW_SS_GLOBAL(SSobj)

/datum/subsystem/objects/Initialize(timeofdayl)
	trigger_atom_spawners()
	setupGenetics()
	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	. = ..()

/datum/subsystem/objects/proc/InitializeAtoms(list/objects = null)
	if(initialized == INITIALIZATION_INSSOBJ)
		return

	var/list/late_loaders

	initialized = INITIALIZATION_INNEW_MAPLOAD
	
	if(objects)
		for(var/I in objects)
			var/atom/A = I
			if(!A.initialized)	//this check is to make sure we don't call it twice on an object that was created in a previous Initialize call
				var/start_tick = world.time
				if(A.Initialize(TRUE))
					LAZYADD(late_loaders, A)
				if(start_tick != world.time)
					WARNING("[A]: [A.type] slept during it's Initialize!")
				CHECK_TICK
	else
		for(var/atom/A in world)
			if(!A.initialized)	//this check is to make sure we don't call it twice on an object that was created in a previous Initialize call
				var/start_tick = world.time
				if(A.Initialize(TRUE))
					LAZYADD(late_loaders, A)
				if(start_tick != world.time)
					WARNING("[A]: [A.type] slept during it's Initialize!")
				CHECK_TICK

	initialized = INITIALIZATION_INNEW_REGULAR
	
	if(late_loaders)
		for(var/I in late_loaders)
			var/atom/A = I
			var/start_tick = world.time
			A.Initialize(FALSE)
			if(start_tick != world.time)
				WARNING("[A]: [A.type] slept during it's Initialize!")
			CHECK_TICK

/datum/subsystem/objects/proc/map_loader_begin()
	old_initialized = initialized
	initialized = FALSE
	
/datum/subsystem/objects/proc/map_loader_stop()
	initialized = old_initialized

/datum/subsystem/objects/proc/trigger_atom_spawners(zlevel, ignore_z=FALSE)
	for(var/V in atom_spawners)
		var/atom/A = V
		if (!ignore_z && (zlevel && A.z != zlevel))
			continue
		A.spawn_atom_to_world()

/datum/subsystem/objects/stat_entry()
	..("P:[processing.len]")


/datum/subsystem/objects/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process(wait)
		else
			SSobj.processing -= thing
		if (MC_TICK_CHECK)
			return

	for(var/obj/burningobj in SSobj.burning)
		if(burningobj && (burningobj.burn_state == ON_FIRE))
			if(burningobj.burn_world_time < world.time)
				burningobj.burn()
		else
			SSobj.burning.Remove(burningobj)

/datum/subsystem/objects/Recover()
	initialized = SSobj.initialized
	old_initialized = SSobj.old_initialized
	if (istype(SSobj.atom_spawners))
		atom_spawners = SSobj.atom_spawners
	if (istype(SSobj.processing))
		processing = SSobj.processing
	if (istype(SSobj.burning))
		burning = SSobj.burning