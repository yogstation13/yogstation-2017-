/obj/item/module
	name = "generic module"
	icon_state = "gavelblock"
	desc = "A module that can be inserted into equipment that supports modules...although this one is just a dummy that is not functional."
	var/verbose_desc //description to show in the module modification menu
	var/id = "module" //this should be thought of as a slot rather than id, you can only place 1 module with the same id into the holder
	var/can_be_applied = TRUE //Does this module apply anything to anything or is it something passive that isn't checked
	var/can_be_toggled = TRUE
	var/can_be_removed = TRUE
	var/has_charges = FALSE
	var/module_type //bitflag for determining if this module should be resolved on attack or on defense or if it gives us any kind of ability to use, see code/__DEFINES/modules.dm
	var/onhit_type
	var/list/action_types //list of action types we are to be given
	var/list/action_list
	var/unique_resolution = TRUE //Only 1 module of this id can be applied on one action, processed here and in mob_procs.dm
	var/list/mode_list //Does this module have any specific modes (See 'repulsor module' for an example)
	var/mode //current mode (index of it, at least)
	var/active = FALSE // on/off, only modules that are on will be considered for application
	var/power_cost
	var/charges = 0 //do we have a limited amount of times we can activate? (Not exclusive with power_cost)
	var/min_range = 1 //Don't affect ourselves if we click on us
	var/max_range = 1 //Melee range by default
	var/next_allowed_time = 0 //for your cooldown needs

	var/list/applicable_atoms //typecache of things we can be applied to
	var/list/applicable_atom_types //which atom types (and subtypes) the module effects can be applied to. Will be applied to anything if not defined...please be careful with this
	var/list/insertable_atom_types //what this can be inserted into. Requires definition, otherwise module cannot be inserted into anything (this is for safety, you'll have to be explicit in what equipment effects you are going to process in your code)
	var/list/insertable_atoms //typecache of things we can be inserted into
	var/obj/item/module_holder/holder

/obj/item/module/New()
	..()
	if(max_range < min_range)
		max_range = min_range
	if(insertable_atom_types && insertable_atom_types.len)
		insertable_atoms = typecacheof(insertable_atom_types)
	if(applicable_atom_types && applicable_atom_types.len)
		applicable_atoms = typecacheof(applicable_atom_types)
	if(mode_list && mode_list.len)
		mode = 1

/obj/item/module/proc/on_unarmed_attack(atom/A, mob/user)

/obj/item/module/proc/on_ranged_attack(atom/A, mob/user)

/obj/item/module/proc/on_obj_melee_attack(atom/A, mob/user)

/obj/item/module/proc/on_obj_ranged_attack(atom/A, mob/user)

/obj/item/module/proc/on_bullet_act(obj/item/projectile/I, mob/user, mob/victim)

/obj/item/module/proc/on_attacked_by(obj/item/I, mob/user, mob/victim)

/obj/item/module/proc/on_attack_hand(mob/user, mob/victim)

/obj/item/module/proc/on_hitby(atom/movable/AM, mob/user, mob/victim)

/obj/item/module/proc/can_be_applied(atom/target, mob/user)
	if(!target || !holder || !user)
		return
	if(!can_be_applied)
		return FALSE
	if(!active)
		return FALSE
	if(!power_check())
		to_chat(user, "<span class='notice'>There is not enough power to use [name], recharge the cell!</span>")
		return FALSE
	if(!charge_check())
		to_chat(user, "<span class='notice'>The [name] is out of charges!</span>")
		return FALSE
	if(!distance_check(target))
		to_chat(user, "<span class='notice'>The [target] is outside the range of [name].</span>")
		return FALSE
	if(applicable_atoms && applicable_atoms.len > 0)
		if(!is_type_in_typecache(target, applicable_atoms))
			return FALSE
	if(world.time < next_allowed_time)
		to_chat(user, "<span class='notice'>You must wait [round(((next_allowed_time-world.time)/10), 0.1)] more seconds before you can use [name] again.</span>")
		return FALSE
	return TRUE

/obj/item/module/proc/power_check()
	if(power_cost && (!holder.power_source || holder.power_source.charge < power_cost))
		return FALSE
	return TRUE

/obj/item/module/proc/charge_check()
	if(has_charges && charges == 0)
		return FALSE
	return TRUE

/obj/item/module/proc/distance_check(atom/target)
	var/distance = get_dist(target, src)
	if((distance > max_range) || (distance < min_range))
		return FALSE
	return TRUE

/obj/item/module/proc/on_install(obj/item/module_holder/holder, obj/item/owner)
	if(!holder)
		return
	src.holder = holder

//Toggle off before removing, just in case
/obj/item/module/proc/on_remove(obj/item/module_holder/holder, obj/item/owner)
	if(!holder)
		return
	if(active && can_be_toggled)
		toggle()
	src.holder = null

/obj/item/module/proc/toggle()
	if(!holder)
		return
	if(!can_be_toggled)
		return
	if(!active)
		active = TRUE
		on_toggle_on()
	else
		active = FALSE
		on_toggle_off()

/obj/item/module/proc/on_toggle_on()
	if(!holder)
		return

/obj/item/module/proc/on_toggle_off()
	if(!holder)
		return

/obj/item/module/proc/switch_mode(what)
	if(!mode_list || !mode_list.len > 1)
		return
	if(what)
		mode = what
		if(mode > mode_list.len)
			mode %= mode_list.len
	else
		//used in this format so modes can be compared using mode_list[mode] == mode_list[1] or something
		mode = (mode % mode_list.len) + 1

//This needs to be called manually at the end of everything
/obj/item/module/proc/action(mob/target, mob/user)
	add_logs(user, target, "attacked using module", src)

/obj/item/module/assault
	module_type = MODULE_ASSAULT

/obj/item/module/defense
	module_type = MODULE_DEFENSE

/obj/item/module/defense/local
	onhit_type = ONHIT_LOCAL

/obj/item/module/defense/global
	onhit_type = ONHIT_GLOBAL