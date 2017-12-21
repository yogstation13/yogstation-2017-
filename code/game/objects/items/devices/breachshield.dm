/obj/item/device/breachshield
	name = "portable anti-breach shield"
	desc = "A portable device that allows you to create a 3x3 ring of shields."
	icon_state = "antibreach" // NEEDS AN ACTUAL SPRITE
	var/used

/obj/item/device/breachshield/attack_self(mob/user)
	if(used)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return

	to_chat(user, "<span class='notice'>[src] begins to vibrate! The shields going to expand!</span>")
	addtimer(src, "expand", 100, TRUE)

/obj/item/device/breachshield/proc/expand()
	var/turf/T = get_turf(src)

	if(!(istype(T, /turf/open/space)))
		var/datum/gas_mixture/pressure = T.return_air()
		var/pressureamt = pressure.return_pressure()
		if(pressureamt > 60)
			visible_message("<span class='warning'>[src] buzzes! Invalid territory!</span>")
			return

	used = TRUE
	visible_message("<span class='warning'>[src] begins to morph into a barrier!</span>")
	addtimer(src, "triggershield", 100)

/obj/item/device/breachshield/proc/triggershield()
	visible_message("<span class='warning'>Blue shields begin to inflate from the bottom of [src].</span>")
	for(var/turf/T in orange(1, src))
		var/obj/machinery/shield/S = new(T)
		S.health = 20
		playsound(T, 'sound/effects/phasein.ogg', 100)

/obj/item/device/breachshield/emag_act(mob/user)
	if(!used)
		to_chat(user, "<span class='warning'>You screw up [src]'s transformation blueprints rendering the device useless.</span>.")
		used = TRUE