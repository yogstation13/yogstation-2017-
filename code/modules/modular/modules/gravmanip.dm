/obj/item/module/assault/gravmanip
	name = "gravity manipulation module"
	id = "gravity"
	desc = "Allows the gloves to exert forces of gravity on mobs or turfs. Cleverly disguised as a gavel block."
	verbose_desc = "Has 4 modes : Push/Pull will push or pull the targetted mob. Attract/Repel will push or pull things away \
		from the targetted turf."
	insertable_atom_types = list(/obj/item/clothing/gloves)
	applicable_atom_types = list(/mob/living, /turf)
	max_range = 5
	var/vortex_range = 3
	mode_list = list("Push", "Pull", "Repel", "Attract")
	var/const/USE_COOLDOWN_MOB = 30
	var/const/USE_COOLDOWN_TURF = 60

/obj/item/module/assault/gravmanip/can_be_applied(atom/A, mob/user)
	if(!..())
		return
	if(mode in 1 to 2)
		if(isturf(A)) //can't push pull turfs
			return FALSE
	return TRUE

/obj/item/module/assault/gravmanip/on_unarmed_attack(atom/A, mob/user)
	switch(mode)
		if(1,2)
			return action(A, user, 1)
		if(3,4)
			return action(A, user)

/obj/item/module/assault/gravmanip/on_ranged_attack(atom/A, mob/user)
	switch(mode)
		if(1,2)
			return action(A, user, 1)
		if(3,4)
			return action(A, user)

/obj/item/module/assault/gravmanip/action(atom/A, mob/user, is_mob = 0)
	if(can_be_applied(A, user))
		var/setting = mode % 2 //0 for attracting, 1 for repelling
		var/list/affected_atoms

		if(is_mob)
			affected_atoms = list(A)
			manipulate_gravity(user, affected_atoms, setting)
			next_allowed_time = world.time + USE_COOLDOWN_MOB
		else
			affected_atoms = (orange(vortex_range, A) - user)
			manipulate_gravity(A, affected_atoms, setting)
			next_allowed_time = world.time + USE_COOLDOWN_TURF
		..()
		return TRUE

//Copy paste of goon_vortex, but everything gets thrown
/obj/item/module/assault/gravmanip/proc/manipulate_gravity(atom/gravity_source, list/affected_atoms, setting)
	for(var/atom/movable/X in affected_atoms)
		if(istype(X, /obj/effect))
			continue
		if(!X.anchored)
			if(setting)
				var/atom/throw_target = get_edge_target_turf(X, get_dir(X, get_step_away(X, gravity_source)))
				X.throw_at_fast(throw_target, vortex_range, 1)
			else
				X.throw_at_fast(gravity_source, vortex_range, 1)