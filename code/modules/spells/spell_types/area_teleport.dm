/obj/effect/proc_holder/spell/targeted/area_teleport
	name = "Area teleport"
	desc = "This spell teleports you to a type of area of your selection."
	nonabstract_req = 1

	var/randomise_selection = 0 //if it lets the usr choose the teleport loc or picks it from the list
	var/invocation_area = 1 //if the invocation appends the selected area
	var/sound1 = "sound/weapons/ZapBang.ogg"
	var/sound2 = "sound/weapons/ZapBang.ogg"

/obj/effect/proc_holder/spell/targeted/area_teleport/perform(list/targets, recharge = 1,mob/living/user = usr)
	var/thearea = before_cast(targets)
	if(!thearea || !cast_check(1))
		revert_cast()
		return
	invocation(thearea,user)
	spawn(0)
		if(charge_type == "recharge" && recharge)
			start_recharge()
	cast(targets,thearea,user)
	after_cast(targets)

/obj/effect/proc_holder/spell/targeted/area_teleport/before_cast(list/targets)
	var/A = null

	if(!randomise_selection)
		A = input("Area to teleport to", "Teleport", A) as null|anything in teleportlocs
	else
		A = pick(teleportlocs)
	if(!A)
		return
	var/area/thearea = teleportlocs[A]

	return thearea

/obj/effect/proc_holder/spell/targeted/area_teleport/cast(list/targets,area/thearea,mob/user = usr)
	playsound(get_turf(user), sound1, 50,1)
	for(var/mob/living/target in targets)
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					L+=T

		if(!L.len)
			usr <<"The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry."
			return

		if(target && target.buckled)
			target.buckled.unbuckle_mob(target, force=1)

		var/list/plebs = list()
		var/mob/living/P = target
		var/obj/obj_to_tele //In case we wanna teleport an object aswell
		var/max_telees = 20// If it runs more then 20 times, we can assume it's stuck in a loop and we should do something about it
		var/telees
		while(P.pulledby)
			if(P.pulledby in plebs)break
			plebs += P.pulledby
			P = P.pulledby
			telees += 1
			if(telees >= max_telees)
				to_chat(target, "<span class='notice'>Spell overload detected. Please remove the unnecessary plebs before casting.</span>")
				revert_cast()
				return
		while(P.pulling)
			if(isobj(P.pulling))
				obj_to_tele = P.pulling
				break
			if(P.pulling in plebs)break
			plebs += P.pulling
			P = P.pulling
			telees += 1
			if(telees >= max_telees)
				to_chat(target, "<span class='notice'>Spell overload detected. Please remove the unnecessary plebs before casting.</span>")
				revert_cast()
				return
		var/list/tempL = L
		var/attempt = null
		var/success = 0
		while(tempL.len)
			attempt = pick(tempL)
			target.Move(attempt)
			if(get_turf(target) == attempt)
				success = 1
				break

			else
				tempL.Remove(attempt)


		if(!success)
			target.loc = pick(L)
			playsound(get_turf(user), sound2, 50,1)
		else
			if(obj_to_tele)
				obj_to_tele.forceMove(pick(tempL))
			plebs -= target
			for(var/mob/living/PLEB in plebs)
				PLEB.forceMove(pick(tempL))


	return

/obj/effect/proc_holder/spell/targeted/area_teleport/invocation(area/chosenarea = null,mob/user = usr)
	if(!invocation_area || !chosenarea)
		..()
	else
		switch(invocation_type)
			if("shout")
				user.say("[invocation] [uppertext(chosenarea.name)]")
				if(user.gender==MALE)
					playsound(user.loc, pick('sound/misc/null.ogg','sound/misc/null.ogg'), 100, 1)
				else
					playsound(user.loc, pick('sound/misc/null.ogg','sound/misc/null.ogg'), 100, 1)
			if("whisper")
				user.whisper("[invocation] [uppertext(chosenarea.name)]")

	return
