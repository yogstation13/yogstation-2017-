/obj/item/weapon/resonator
	name = "resonator"
	icon = 'icons/obj/mining.dmi'
	icon_state = "resonator"
	item_state = "resonator"
	desc = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. It can also be activated without a target to create a field at the user's location, to act as a delayed time trap. It's more effective in a vacuum."
	w_class = 3
	force = 15
	throwforce = 10
	slot_flags = SLOT_BELT
	var/cooldown = 0
	var/fieldsactive = 0
	var/burst_time = 30
	var/fieldlimit = 4
	origin_tech = "magnets=3;engineering=3"

/obj/item/weapon/resonator/upgraded
	name = "upgraded resonator"
	desc = "An upgraded version of the resonator that can produce more fields at once."
	icon_state = "resonator_u"
	item_state = "resonator_u"
	origin_tech = "materials=4;powerstorage=3;engineering=3;magnets=3"
	fieldlimit = 6

/obj/item/weapon/resonator/proc/CreateResonance(target, creator)
	var/turf/T = get_turf(target)
	if(locate(/obj/effect/resonance) in T)
		return
	if(fieldsactive < fieldlimit)
		playsound(src,'sound/weapons/resonator_fire.ogg',50,1)
		new /obj/effect/resonance(T, creator, burst_time)
		fieldsactive++
		spawn(burst_time)
			fieldsactive--

/obj/item/weapon/resonator/attack_self(mob/user)
	if(burst_time == 50)
		burst_time = 30
		to_chat(user, "<span class='info'>You set the resonator's fields to detonate after 3 seconds.</span>")
	else
		burst_time = 50
		to_chat(user, "<span class='info'>You set the resonator's fields to detonate after 5 seconds.</span>")

/obj/item/weapon/resonator/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(!check_allowed_items(target, 1))
			return
		CreateResonance(target, user)

/obj/effect/resonance
	name = "resonance field"
	desc = "A resonating field that significantly damages anything inside of it when the field eventually ruptures."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = 0
	var/resonance_damage = 20

/obj/effect/resonance/New(loc, var/creator = null, var/timetoburst)
	var/turf/proj_turf = get_turf(src)
	if(!istype(proj_turf))
		return
	if(istype(proj_turf, /turf/closed/mineral))
		var/turf/closed/mineral/M = proj_turf
		spawn(timetoburst)
			playsound(src,'sound/weapons/resonator_blast.ogg',50,1)
			for(var/turf/closed/T in orange(1, M))
				if(istype(T, M))
					var/turf/closed/mineral/T2 = T
					if(T2.mineralType) // so we don't end up in the ultimate chain reaction
						new /obj/effect/resonance(T, creator, timetoburst)
			M.gets_drilled(creator)
			qdel(src)
	else
		var/datum/gas_mixture/environment = proj_turf.return_air()
		var/pressure = environment.return_pressure()
		if(pressure < 50)
			name = "strong resonance field"
			resonance_damage = 60
		spawn(timetoburst)
			playsound(src,'sound/weapons/resonator_blast.ogg',50,1)
			if(creator)
				for(var/mob/living/L in src.loc)
					add_logs(creator, L, "used a resonator field on", "resonator")
					to_chat(L, "<span class='danger'>The [src.name] ruptured with you in it!</span>")
					L.adjustBruteLoss(resonance_damage)
			else
				for(var/mob/living/L in src.loc)
					to_chat(L, "<span class='danger'>The [src.name] ruptured with you in it!</span>")
					L.adjustBruteLoss(resonance_damage)
			qdel(src)

/obj/effect/resonance/proc/replicate(turf/M, creator, timetoburst)
	for(var/turf/closed/T in orange(1, M))
		if(istype(T, M))
			var/turf/closed/mineral/T2 = T
			if(T2.mineralType) // so we don't end up in the ultimate chain reaction
				new /obj/effect/resonance(T, creator, timetoburst)