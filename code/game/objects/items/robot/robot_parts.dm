/obj/item/robot_parts/robot_suit
	name = "cyborg endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	attack_verb = list("borged", "stated the laws of", "robotized")
	hitsound = 'sound/voice/liveagain.ogg'
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "robo_suit"
	var/obj/item/bodypart/l_arm/robot/l_arm = null
	var/obj/item/bodypart/r_arm/robot/r_arm = null
	var/obj/item/bodypart/l_leg/robot/l_leg = null
	var/obj/item/bodypart/r_leg/robot/r_leg = null
	var/obj/item/bodypart/chest/robot/chest = null
	var/obj/item/bodypart/head/robot/head = null

	var/created_name = ""
	var/mob/living/silicon/ai/forced_ai
	var/locomotion = 1
	var/lawsync = 1
	var/aisync = 1
	var/panel_locked = 1

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	if(src.l_arm)
		src.overlays += "l_arm+o"
	if(src.r_arm)
		src.overlays += "r_arm+o"
	if(src.chest)
		src.overlays += "chest+o"
	if(src.l_leg)
		src.overlays += "l_leg+o"
	if(src.r_leg)
		src.overlays += "r_leg+o"
	if(src.head)
		src.overlays += "head+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				feedback_inc("cyborg_frames_built",1)
				return 1
	return 0

/obj/item/robot_parts/robot_suit/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = W
		if(!l_arm && !r_arm && !l_leg && !r_leg && !chest && !head)
			if (M.use(1))
				var/obj/item/weapon/ed209_assembly/B = new /obj/item/weapon/ed209_assembly
				B.loc = get_turf(src)
				to_chat(user, "<span class='notice'>You arm the robot frame.</span>")
				if (user.get_inactive_hand()==src)
					user.unEquip(src)
					user.put_in_inactive_hand(B)
				qdel(src)
			else
				to_chat(user, "<span class='warning'>You need one sheet of metal to start building ED-209!</span>")
				return
	else if(istype(W, /obj/item/bodypart/l_leg/robot))
		if(src.l_leg)
			return
		if(!user.unEquip(W))
			return
		W.loc = src
		src.l_leg = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/r_leg/robot))
		if(src.r_leg)
			return
		if(!user.unEquip(W))
			return
		W.loc = src
		src.r_leg = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/l_arm/robot))
		if(src.l_arm)
			return
		if(!user.unEquip(W))
			return
		W.loc = src
		src.l_arm = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/r_arm/robot))
		if(src.r_arm)
			return
		if(!user.unEquip(W))
			return
		W.loc = src
		src.r_arm = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/chest/robot))
		if(src.chest)
			return
		if(W:wired && W:cell)
			if(!user.unEquip(W))
				return
			W.loc = src
			src.chest = W
			src.updateicon()
		else if(!W:wired)
			to_chat(user, "<span class='warning'>You need to attach wires to it first!</span>")
		else
			to_chat(user, "<span class='warning'>You need to attach a cell to it first!</span>")

	else if(istype(W, /obj/item/bodypart/head/robot))
		if(src.head)
			return
		if(W:flash2 && W:flash1)
			if(!user.unEquip(W))
				return
			W.loc = src
			src.head = W
			src.updateicon()
		else
			to_chat(user, "<span class='warning'>You need to attach a flash to it first!</span>")

	else if (istype(W, /obj/item/device/multitool))
		if(check_completion())
			Interact(user)
		else
			to_chat(user, "<span class='warning'>The endoskeleton must be assembled before debugging can begin!</span>")

	else if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!istype(loc,/turf))
				to_chat(user, "<span class='warning'>You can't put the MMI in, the frame has to be standing on the ground to be perfectly precise!</span>")
				return
			if(!M.brainmob)
				to_chat(user, "<span class='warning'>Sticking an empty MMI into the frame would sort of defeat the purpose!</span>")
				return

			var/mob/living/carbon/brain/BM = M.brainmob
			if(!BM.key || !BM.mind)
				to_chat(user, "<span class='warning'>The mmi indicates that their mind is completely unresponsive; there's no point!</span>")
				return

			if(!BM.client) //braindead
				to_chat(user, "<span class='warning'>The mmi indicates that their mind is currently inactive; it might change!</span>")
				return

			if(BM.stat == DEAD || (M.brain && M.brain.damaged_brain))
				to_chat(user, "<span class='warning'>Sticking a dead brain into the frame would sort of defeat the purpose!</span>")
				return

			if(jobban_isbanned(BM, "Cyborg"))
				to_chat(user, "<span class='warning'>This MMI does not seem to fit!</span>")
				return

			if(!user.unEquip(W))
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(loc))
			if(!O)
				return

			if(M.hacked || M.clockwork)
				aisync = 0
				lawsync = 0
				var/datum/ai_laws/L
				if(M.clockwork)
					L = new/datum/ai_laws/ratvar
				else
					L = new/datum/ai_laws/syndicate_override
				O.laws = L
				L.associate(O)

			O.invisibility = 0
			//Transfer debug settings to new mob
			O.custom_name = created_name
			O.locked = panel_locked
			if(!aisync)
				lawsync = 0
				O.connected_ai = null
			else
				O.notify_ai(1)
				if(forced_ai)
					O.connected_ai = forced_ai
			if(!lawsync)
				O.lawupdate = 0
				if(!M.hacked && !M.clockwork)
					O.make_laws()

			if(!M.clockwork)
				remove_servant_of_ratvar(BM, TRUE)

			ticker.mode.remove_antag_for_borging(BM.mind)
			BM.mind.transfer_to(O)

			if(O.mind && O.mind.special_role)
				O.mind.store_memory("As a cyborg, you must obey your silicon laws and master AI above all else. Your objectives will consider you to be dead.")
				to_chat(O, "<span class='userdanger'>You have been robotized!</span>")
				to_chat(O, "<span class='danger'>You must obey your silicon laws and master AI above all else. Your objectives will consider you to be dead.</span>")

			O.job = "Cyborg"

			O.cell = chest.cell
			chest.cell.loc = O
			chest.cell = null
			W.loc = O//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.
			if(O.mmi) //we delete the mmi created by robot/New()
				qdel(O.mmi)
			O.mmi = W //and give the real mmi to the borg.
			O.updatename()

			feedback_inc("cyborg_birth",1)

			if(pulledby)
				pulledby.stop_pulling()

			src.loc = O
			O.robot_suit = src

			if(!locomotion)
				O.lockcharge = 1
				O.update_canmove()
				to_chat(O, "<span class='warning'>Error: Servo motors unresponsive.</span>")

		else
			to_chat(user, "<span class='warning'>The MMI must go in after everything else!</span>")

	else if(istype(W,/obj/item/weapon/pen))
		to_chat(user, "<span class='warning'>You need to use a multitool to name [src]!</span>")
	else
		return ..()

/obj/item/robot_parts/robot_suit/proc/Interact(mob/user)
			var/t1 = text("Designation: <A href='?src=\ref[];Name=1'>[(created_name ? "[created_name]" : "Default Cyborg")]</a><br>\n",src)
			t1 += text("Master AI: <A href='?src=\ref[];Master=1'>[(forced_ai ? "[forced_ai.name]" : "Automatic")]</a><br><br>\n",src)

			t1 += text("LawSync Port: <A href='?src=\ref[];Law=1'>[(lawsync ? "Open" : "Closed")]</a><br>\n",src)
			t1 += text("AI Connection Port: <A href='?src=\ref[];AI=1'>[(aisync ? "Open" : "Closed")]</a><br>\n",src)
			t1 += text("Servo Motor Functions: <A href='?src=\ref[];Loco=1'>[(locomotion ? "Unlocked" : "Locked")]</a><br>\n",src)
			t1 += text("Panel Lock: <A href='?src=\ref[];Panel=1'>[(panel_locked ? "Engaged" : "Disengaged")]</a><br>\n",src)
			var/datum/browser/popup = new(user, "robotdebug", "Cyborg Boot Debug", 310, 220)
			popup.set_content(t1)
			popup.open()

/obj/item/robot_parts/robot_suit/Topic(href, href_list)
	if(usr.lying || usr.stat || usr.stunned || !Adjacent(usr))
		return

	var/mob/living/living_user = usr
	var/obj/item/item_in_hand = living_user.get_active_hand()
	if(!istype(item_in_hand, /obj/item/device/multitool))
		to_chat(living_user, "<span class='warning'>You need a multitool!</span>")
		return

	if(href_list["Name"])
		var/new_name = name_input(usr, "Enter new designation. Set to blank to reset to default.", "Cyborg Debug", src.created_name, TRUE)
		if(!in_range(src, usr) && src.loc != usr)
			return
		if(new_name)
			created_name = new_name
		else
			created_name = ""

	else if(href_list["Master"])
		forced_ai = select_active_ai(usr)
		if(!forced_ai)
			to_chat(usr, "<span class='error'>No active AIs detected.</span>")

	else if(href_list["Law"])
		lawsync = !lawsync
	else if(href_list["AI"])
		aisync = !aisync
	else if(href_list["Loco"])
		locomotion = !locomotion
	else if(href_list["Panel"])
		panel_locked = !panel_locked

	add_fingerprint(usr)
	Interact(usr)
	return
