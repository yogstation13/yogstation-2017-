//Xenobio control console
/mob/camera/aiEye/remote/xenobio
	visible_icon = 1
	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera_target"


/mob/camera/aiEye/remote/xenobio/setLoc(var/t)
	var/area/new_area = get_area(t)
	if(new_area && new_area.name == "Xenobiology Lab" || istype(new_area, /area/toxins/xenobiology ))
		return ..()
	else
		return

/obj/machinery/computer/camera_advanced/xenobio
	name = "Slime management console"
	desc = "A computer used for remotely handling slimes."
	networks = list("SS13")
	var/datum/action/innate/slime_place/slime_place_action = new
	var/datum/action/innate/slime_pick_up/slime_up_action = new
	var/datum/action/innate/feed_slime/feed_slime_action = new
	var/datum/action/innate/monkey_recycle/monkey_recycle_action = new

	var/list/stored_slimes = list()
	var/max_slimes = 5
	var/monkeys = 0

	icon_screen = "slime_comp"
	icon_keyboard = "rd_key"

/obj/machinery/computer/camera_advanced/xenobio/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/xenobio()
	eyeobj.loc = get_turf(src)
	eyeobj.origin = src
	eyeobj.visible_icon = 1
	eyeobj.icon = 'icons/obj/abductor.dmi'
	eyeobj.icon_state = "camera_target"

/obj/machinery/computer/camera_advanced/xenobio/GrantActions(mob/living/carbon/user)
	..()

	if(slime_up_action)
		slime_up_action.target = src
		slime_up_action.Grant(user)
		actions += slime_up_action

	if(slime_place_action)
		slime_place_action.target = src
		slime_place_action.Grant(user)
		actions += slime_place_action

	if(feed_slime_action)
		feed_slime_action.target = src
		feed_slime_action.Grant(user)
		actions += feed_slime_action

	if(monkey_recycle_action)
		monkey_recycle_action.target = src
		monkey_recycle_action.Grant(user)
		actions += monkey_recycle_action


/obj/machinery/computer/camera_advanced/xenobio/attack_hand(mob/user)
	if(!ishuman(user)) //AIs using it might be weird
		return
	return ..()

/obj/machinery/computer/camera_advanced/xenobio/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		monkeys++
		user << "<span class='notice'>You feed [O] into [src]. It now has [monkeys] monkey cubes stored.</span>"
		user.drop_item()
		qdel(O)
		return
	else if(istype(O, /obj/item/weapon/storage/bag))
		var/obj/item/weapon/storage/P = O
		var/loaded = 0
		for(var/obj/G in P.contents)
			if(istype(G, /obj/item/weapon/reagent_containers/food/snacks/monkeycube))
				loaded = 1
				monkeys++
				qdel(G)
		if (loaded)
			user << "<span class='notice'>You fill [src] with the monkey cubes stored in [O]. [src] now has [monkeys] monkey cubes stored.</span>"
		return
	..()


/datum/action/innate/slime_place
	name = "Place Slimes"
	button_icon_state = "slime_down"

/datum/action/innate/slime_place/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/simple_animal/slime/S in X.stored_slimes)
			S.loc = remote_eye.loc
			S.visible_message("[S] warps in!")
			X.stored_slimes -= S
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"

/datum/action/innate/slime_pick_up
	name = "Pick up Slime"
	button_icon_state = "slime_up"

/datum/action/innate/slime_pick_up/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/simple_animal/slime/S in remote_eye.loc)
			if(X.stored_slimes.len >= X.max_slimes)
				break
			if(!S.ckey)
				if(S.buckled)
					S.Feedstop(silent=1)
				S.visible_message("[S] vanishes in a flash of light!")
				S.loc = X
				X.stored_slimes += S
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"


/datum/action/innate/feed_slime
	name = "Feed Slimes"
	button_icon_state = "monkey_down"

/datum/action/innate/feed_slime/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(cameranet.checkTurfVis(remote_eye.loc))
		if(X.monkeys >= 1)
			var/mob/living/carbon/monkey/food = new /mob/living/carbon/monkey(remote_eye.loc)
			food.LAssailant = C
			X.monkeys --
			owner << "[X] now has [X.monkeys] monkeys left."
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"


/datum/action/innate/monkey_recycle
	name = "Recycle Monkeys"
	button_icon_state = "monkey_up"

/datum/action/innate/monkey_recycle/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/carbon/monkey/M in remote_eye.loc)
			if(M.stat)
				M.visible_message("[M] vanishes as they are reclaimed for recycling!")
				X.monkeys = round(X.monkeys + 0.2,0.1)
				qdel(M)
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"


////////////////////////////////////////////////////



/mob/camera/aiEye/remote/security
	visible_icon = 1
	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera_target"


/mob/camera/aiEye/remote/security/setLoc(var/t)
	var/area/new_area = get_area(t)
	if(new_area && new_area.name != "Space")
		return ..()
	else
		return

/obj/machinery/computer/camera_advanced/security
	name = "Criminal management console"
	desc = "A computer used for remotely handling criminals."
	networks = list("SS13")
	off_action = new/datum/action/innate/camera_off/security
	var/datum/action/innate/taze/taze_action = new
	var/datum/action/innate/cuff/cuff_action = new
	var/datum/action/innate/arrest/normal/arrest_action = new
	var/datum/action/innate/arrest/perma/perma_action = new

	icon_screen = "security"
	icon_keyboard = "security_key"

/obj/machinery/computer/camera_advanced/security/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/security()
	eyeobj.origin = src
	eyeobj.visible_icon = 1
	eyeobj.icon = 'icons/obj/abductor.dmi'
	eyeobj.icon_state = "camera_target"
	eyeobj.setLoc(src)

/obj/machinery/computer/camera_advanced/security/GrantActions(mob/living/carbon/user)
	off_action.target = user
	off_action.Grant(user)

	jump_action.target = user
	jump_action.Grant(user)

	taze_action.target = src
	taze_action.Grant(user)

	cuff_action.target = src
	cuff_action.Grant(user)

	arrest_action.target = src
	arrest_action.Grant(user)

	perma_action.target = src
	perma_action.Grant(user)

/datum/action/innate/camera_off/security/Activate()
	if(!target || !ishuman(target))
		return
	var/mob/living/carbon/C = target
	var/mob/camera/aiEye/remote/security/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/security/origin = remote_eye.origin
	origin.current_user = null
	origin.jump_action.Remove(C)
	origin.taze_action.Remove(C)
	origin.cuff_action.Remove(C)
	origin.arrest_action.Remove(C)
	origin.perma_action.Remove(C)
	//All of this stuff below could probably be a proc for all advanced cameras, only the action removal needs to be camera specific
	remote_eye.eye_user = null
	C.reset_perspective(null)
	if(C.client)
		C.client.images -= remote_eye.user_image
		for(var/datum/camerachunk/chunk in remote_eye.visibleCameraChunks)
			C.client.images -= chunk.obscured
	C.remote_control = null
	C.unset_machine()
	src.Remove(C)

/datum/action/innate/taze
	name = "Stun"
	button_icon_state = "monkey_up"

/datum/action/innate/taze/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/security/remote_eye = C.remote_control

	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/carbon/human/H in remote_eye.loc)
			//H.visible_message("[H] warps out!")
			add_logs(C, H, "stunned with a security management console", src)
			H.apply_effects(5, 5, 0, 0, 0, 5, 0, 0, 0, 0, 0)
			playsound(H, 'sound/weapons/Genhit.ogg', 50, 1)
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"

/datum/action/innate/cuff
	name = "Cuff"
	button_icon_state = "monkey_up"

/datum/action/innate/cuff/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/security/remote_eye = C.remote_control

	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/carbon/human/H in remote_eye.loc)
			if(!H.stunned)
				owner << "<span class='notice'>Target must be stunned to cuff.</span>"
				continue
			if(!H.handcuffed)
				playsound(H.loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
				H.handcuffed = new /obj/item/weapon/restraints/handcuffs/cable/zipties/used(H)
				H.update_handcuffed()
				add_logs(C, H, "handcuffed with a security management console", src)
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"

/datum/action/innate/arrest
	var/arrest_type

/datum/action/innate/arrest/proc/extra(mob/living/carbon/user, mob/living/carbon/human/target)
	return

/datum/action/innate/arrest/normal
	name = "Arrest"
	button_icon_state = "monkey_up"
	arrest_type = "arrest"

/datum/action/innate/arrest/perma
	name = "Permabrig"
	button_icon_state = "monkey_up"
	arrest_type = "perma"

/datum/action/innate/arrest/perma/extra(mob/living/carbon/user, mob/living/carbon/human/target)
	if(!user || !target)
		return
	var/warped = FALSE
	for(var/obj/item/I in target)
		if(target.unEquip(I))
			I.forceMove(user.loc)
			warped = TRUE
	target.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/orange(target), slot_shoes)
	target.equip_to_slot_or_del(new /obj/item/clothing/under/rank/prisoner(target), slot_w_uniform)
	if(warped)
		user.visible_message("<span class='notice'>Objects warp in at [user]'s feet.</span>", "<span class='notice'>The target's possessions warp in at your feet.</span>")

/datum/action/innate/arrest/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/security/remote_eye = C.remote_control

	var/teleloc
	for(var/obj/effect/landmark/sectele/S in landmarks_list)
		if(S.arrest_type == arrest_type)
			teleloc = S.loc

	if(!teleloc)
		owner << "<span class='notice'>No arrest location has been calibrated, please contact NT technical support.</span>"
		return

	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/carbon/human/H in remote_eye.loc)
			if(!H.handcuffed)
				owner << "<span class='notice'>Target must be handcuffed to arrest.</span>"
				continue
			H.visible_message("[H] warps out!")
			add_logs(C, H, "[arrest_type]ed with a security management console", src)
			H.forceMove(teleloc)
			extra(C, H)
			H.visible_message("[H] warps in!")
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"


/obj/effect/landmark/sectele
	var/arrest_type = "arrest"

/obj/effect/landmark/sectele/perma
	arrest_type = "perma"
