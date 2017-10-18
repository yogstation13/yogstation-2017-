/obj/item/module_holder
	name = "module holder"
	desc = "This is a generic module holder, very classified. Please report sightings to the nearest CentComm official...or spawn a subtype of this, if you are the said CentComm official."
	icon_state = "game_kit"
	var/module_limit = 0
	var/list/defense_modules
	var/list/assault_modules
	var/list/installed_modules
	var/obj/item/weapon/stock_parts/cell/power_source
	var/list/default_modules
	var/default_removable = TRUE //can the default modules be removed
	var/obj/item/owner //which object is our owner

/obj/item/module_holder/attackby(obj/item/W, mob/user, params)
	if(ismodholder(W))
		to_chat(user, "<span class='notice'>That would be an interesting topological exercise...</span>")
	if(ismodule(W))
		to_chat(user, "<span class='notice'>You'll need to install the module holder into something before you do that.</span>")

/obj/item/module_holder/New(obj/item/owner)
	..()
	if(default_modules && default_modules.len)
		module_limit += default_modules.len
		for(var/type in default_modules)
			var/obj/item/module/newmod = new type()
			newmod.can_be_removed = default_removable
			install(newmod)
	if(owner && istype(owner))
		install_holder(owner)

/obj/item/module_holder/Destroy()
	if(owner)
		owner.module_holder = null
		owner.verbs -= /obj/item/module_holder/verb/modify_modules
		owner = null
	return ..()

/obj/item/module_holder/proc/get_module(id)
	if(installed_modules && installed_modules[id])
		return installed_modules[id]

/obj/item/module_holder/proc/get_flat_installed_module_list()
	. = list()
	for(var/key in installed_modules)
		. += installed_modules[key]

/obj/item/module_holder/proc/get_active_module(id)
	if(installed_modules && installed_modules[id])
		var/obj/item/module/module = installed_modules[id]
		if(module.active)
			return module

/obj/item/module_holder/proc/install_holder(obj/item/owner, mob/user)
	if(owner.module_holder)
		return FALSE
	owner.module_holder = src
	src.owner = owner
	if(user)
		user.drop_item() //Inventory code...need to drop before moving into the item
	forceMove(owner)
	on_holder_install()
	return TRUE

/obj/item/module_holder/proc/on_holder_install()
	if(owner)
		var/verb_name = "Modify Modules([owner.name])"
		owner.verbs += new /obj/item/module_holder/verb/modify_modules(src, verb_name)

/obj/item/module_holder/proc/install(obj/item/module/module, mob/user)
	if(!istype(module) || !owner)
		return
	if(!installed_modules)
		installed_modules = list()
	if(installed_modules.len >= module_limit)
		return "No more slots to install extra modules."
	if(installed_modules[module.id]) //don't install duplicates in the same item
		return "A module of this type is already installed."
	if(!module.insertable_atoms || !module.insertable_atoms.len)
		return "Tell the coders that insertable_atoms is not defined for this module."
	for(!is_type_in_typecache(owner, module.insertable_atoms))
		return "[owner] does not support this type of module."

	if(module.module_type & MODULE_DEFENSE)
		if(!defense_modules)
			defense_modules = list("global" = list(), "local" = list())
		switch(module.onhit_type)
			if(ONHIT_LOCAL)
				defense_modules["local"][module.id] = module
			if(ONHIT_GLOBAL)
				defense_modules["global"][module.id] = module

	if(module.module_type & MODULE_ASSAULT)
		if(!assault_modules)
			assault_modules = list()
		assault_modules[module.id] = module

	if(user)
		user.drop_item() //This is here because inventory code
	module.forceMove(owner)
	installed_modules[module.id] = module
	module.on_install(src, owner)
	return TRUE

/obj/item/module_holder/proc/remove(obj/item/module/module, force = 0)
	if(!module || (!installed_modules || !installed_modules.len) || !owner)
		return
	if(!installed_modules[module.id])
		return FALSE
	if(!module.can_be_removed && !force)
		return FALSE

	if(module.module_type & MODULE_DEFENSE)
		switch(module.onhit_type)
			if(ONHIT_LOCAL)
				defense_modules["local"] -= module.id
			if(ONHIT_GLOBAL)
				defense_modules["global"] -= module.id

	if(module.module_type & MODULE_ASSAULT)
		assault_modules -= module.id

	module.on_remove(src, owner)
	installed_modules -= module.id
	module.forceMove(get_turf(owner))
	return TRUE

/obj/item/module_holder/proc/remove_all(force = 0)
	. = FALSE
	for(var/key in installed_modules)
		var/obj/item/module/module_check = installed_modules[key]
		if(remove(module_check, force))
			. = TRUE


/*
    Attack resolution proc - this runs when we click on stuff
*/
/obj/item/module_holder/resolve_assault_modules(atom/A, mob/user, resolve_proc)
	if(!assault_modules || !assault_modules.len)
		return

	var/resolved = FALSE //we will resolve all modules on the item before stopping

	for(var/key in assault_modules)
		var/obj/item/module/module = assault_modules[key]

		switch(resolve_proc)
			if(UNARMED_MELEE_CLICK)
				resolved = module.on_unarmed_attack(A, user)
			if(UNARMED_RANGE_CLICK)
				resolved = module.on_ranged_attack(A, user)
			if(ARMED_MELEE_CLICK)
				resolved = module.on_obj_melee_attack(A, user)
			if(ARMED_RANGE_CLICK)
				resolved = module.on_obj_ranged_attack(A, user)

		if(resolved)
			. = TRUE

/*
	Defense resolution proc - this runs when stuff hits us
*/
/obj/item/module_holder/resolve_defense_modules(atom/I, mob/user, mob/victim, attack_type, which = ONHIT_LOCAL)
	if(!defense_modules)
		return

	var/list/def_mod_list

	switch(which)
		if(ONHIT_LOCAL)
			def_mod_list = defense_modules["local"]
		if(ONHIT_GLOBAL)
			def_mod_list = defense_modules["global"]

	if(!def_mod_list || !def_mod_list.len)
		return FALSE

	var/resolved = FALSE

	for(var/key in def_mod_list)
		var/obj/item/module/module = def_mod_list[key]

		switch(attack_type)
			if(MELEE_ATTACK)
				resolved = module.on_attacked_by(I, user, victim)
			if(UNARMED_ATTACK)
				resolved = module.on_attack_hand(user, victim)
			if(PROJECTILE_ATTACK)
				if(istype(I, /obj/item/projectile))
					var/obj/item/projectile/proj = I
					user = proj.firer
				resolved = module.on_bullet_act(I, user, victim)
			if(THROWN_PROJECTILE_ATTACK)
				if(isobj(I))
					var/obj/item/thing = I
					user = thing.thrownby
				resolved = module.on_hitby(I, user, victim)

		if(resolved)
			. = TRUE

//This verb is added to the owner item
/obj/item/module_holder/verb/modify_modules()
	set name = "Modify Modules"
	set category = "Modules"

	//we are inside of the owner item, but obviously, neither compiler nor runtime can resolve this
	var/obj/item/current_holder = src

	var/obj/item/module_holder/module_holder = current_holder.get_m_holder()

	if(!module_holder)
		to_chat(usr, "<span class='notice'>This is an error : Please notify coders that the verb didn't find the module holder, despite you being able to use it!</span>")
		return
	if(!ishuman(usr))
		to_chat(usr, "<span class='warning'>You don't have the slightest clue on how to do that.</span>")
		return
	if(!module_holder.installed_modules || !module_holder.installed_modules.len)
		to_chat(usr, "<span class='warning'>There are no modules to modify.</span>")
		return

	module_holder.make_topic()

/obj/item/module_holder/proc/make_topic()
	var/dat = get_content()
	var/datum/browser/popup = new(usr, "modular", "Modify Modules", 600, 600)
	popup.set_content(dat)
	popup.open()

/obj/item/module_holder/proc/get_content()
	var/css = {"<style>
td.desc {
	font-size: 10px;
	line-height: 1;
	border-style: hidden solid hidden hidden;
	border-width: 2px;
}
td {
	border-style:hidden solid hidden hidden;
	border-width: 2px;
	border-color: white;
}
</style>"}
	var/dat = "<html><head><title>Modify Modules</title>[css]</head><body>"
	if(power_source)
		dat += "<b>Power cell charge : [power_source.charge]/[power_source.maxcharge]</b>"
	else
		dat += "<b style='color:red'>No power cell installed!</b>"
	dat += "<hr>"
	for(var/key in installed_modules)
		dat += "<table>"
		var/obj/item/module/module = installed_modules[key]
		var/has_modes = (module.mode_list && module.mode_list.len > 1)
		dat += "<tr><th style='text-align:left'>[module.name]</th><th>State</th>"
		if(module.has_charges)
			dat += "<th>Charges</th>"
		if(has_modes)
			dat += "<th>Mode</th>"
		dat += "</tr>"
		dat += "<tr>"
		dat += "<td class='desc'>[module.verbose_desc]</td><td style='color:[module.active ? "green" : "red"]'><b>[module.active ? "On" : "Off"]</b></td>"
		if(module.has_charges)
			dat += "<td>[module.charges]</td>"
		if(has_modes)
			dat += "<td>"
			dat += "<div>"
			var/mode = 1
			for(var/v in module.mode_list)
				dat += "[module.mode == mode ? "<span class='linkOff'>[v]</span>" : "<A href='?src=\ref[src];target=[module.id];action=switch_mode;mode=[mode]'>[v]</A>"]"
				mode++
			dat += "</div>"
			dat += "</td>"
		dat += "<td>"
		dat += "<div>"
		dat += "<A href='?src=\ref[src];target=[module.id];action=toggle'>Toggle</A>"
		if(module.can_be_removed)
			dat += "<A href='?src=\ref[src];target=[module.id];action=eject'>Eject</A>"
		dat += "</div>"
		dat += "</td>"
		dat += "</tr>"
		dat += "</table>"
		dat += "<br>"
	dat += "</body></html>"
	return dat

/obj/item/module_holder/Topic(href, href_list)
	if(href_list["target"])
		var/obj/item/module/module = get_module(href_list["target"])
		if(!istype(module))
			return
		if(href_list["action"])
			var/action = href_list["action"]
			switch(action)
				if("toggle")
					module.toggle()
					. = TRUE
				if("eject")
					if(remove(module))
						. = TRUE
				if("switch_mode")
					var/mode = text2num(href_list["mode"])
					module.switch_mode(mode)
					. = TRUE

	if(.) //Only remake the popup if there's a successful action
		make_topic()