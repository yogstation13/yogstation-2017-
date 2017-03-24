/obj/item/proc/get_m_holder()
	if(!module_holder)
		return
	var/obj/item/module_holder/holder = module_holder
	if(!istype(holder))
		return
	return holder

/obj/item/proc/has_active_module(id)
	var/obj/item/module_holder/holder = get_m_holder()
	if(holder && holder.has_active_module(id))
		return TRUE
	return FALSE

//Called by resolve_modules when we click on someone adjacent without any item in hand
/obj/item/proc/resolve_assault_modules(atom/A, mob/user, resolve_proc)
	if(!resolve_proc)
		return
	var/obj/item/module_holder/holder = get_m_holder()
	if(!holder)
		return

	switch(resolve_proc)
		if(UNARMED_MELEE_CLICK, UNARMED_RANGE_CLICK, ARMED_MELEE_CLICK, ARMED_RANGE_CLICK)
			if(holder.resolve_assault_modules(A, user, resolve_proc))
				return 1

/obj/item/proc/resolve_defense_modules(obj/item/I, mob/user, mob/victim, attack_type, which = ONHIT_LOCAL)
	var/obj/item/module_holder/holder = get_m_holder()
	if(!holder)
		return

	switch(which)
		if(ONHIT_LOCAL, ONHIT_GLOBAL)
			if(holder.resolve_defense_modules(I, user, victim, attack_type, which))
				return 1