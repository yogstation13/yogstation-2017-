/obj/item/weapon/implant/mindshield
	name = "mindshield implant"
	desc = "Protects against brainwashing."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0

/obj/item/weapon/implant/mindshield/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Management Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device are much more resistant to brainwashing.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that protects the host's mental functions from manipulation.<BR>
				<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
				<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat


/obj/item/weapon/implant/mindshield/implant(mob/living/target, mob/user, silent = 0)
	if(..())
<<<<<<< HEAD
<<<<<<< HEAD
		var/obj/item/weapon/implant/mindslave/imp = locate(/obj/item/weapon/implant/mindslave) in target
		if(imp)
			imp.removed(target)
		if((target.mind in (ticker.mode.head_revolutionaries | ticker.mode.get_gang_bosses())) || is_shadow_or_thrall(target))
			target.visible_message("<span class='warning'>[target] seems to resist the implant!</span>", "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>")
			removed(target, 1)
			qdel(src)
			return -1
		if(target.mind in ticker.mode.revolutionaries | ticker.mode.get_gangsters())
			ticker.mode.remove_revolutionary(target.mind)
			ticker.mode.remove_gangster(target.mind)
		if(ticker.mode.is_cyberman(target.mind))
			target << "<span class='notice'>Your cyberman body silenty disables the Nanotrasen nanobots as they enter your bloodstream. You appear to be implanted, but the implant has no effect.</span>"
		if((target.mind in ticker.mode.cult) || (target.mind in ticker.mode.blue_deity_prophets|ticker.mode.red_deity_prophets|ticker.mode.red_deity_followers|ticker.mode.blue_deity_followers))
			target << "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>"
		else
			target << "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>"
=======
		if((target.mind in (ticker.mode.head_revolutionaries | ticker.mode.get_gang_bosses())))
=======
		if((target.mind in (SSticker.mode.head_revolutionaries | SSticker.mode.get_gang_bosses())))
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
			if(!silent)
				target.visible_message("<span class='warning'>[target] seems to resist the implant!</span>", "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>")
			removed(target, 1)
			qdel(src)
			return 0
		if(target.mind in SSticker.mode.get_gangsters())
			SSticker.mode.remove_gangster(target.mind)
			if(!silent)
				target.visible_message("<span class='warning'>[src] was destroyed in the process!</span>", "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>")
			removed(target, 1)
			qdel(src)
			return 0
		if(target.mind in SSticker.mode.revolutionaries)
			SSticker.mode.remove_revolutionary(target.mind)
		if(!silent)
			if(target.mind in SSticker.mode.cult)
				to_chat(target, "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>")
			else
<<<<<<< HEAD
				target << "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>"
>>>>>>> masterTGbranch
=======
				to_chat(target, "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
		return 1
	return 0

/obj/item/weapon/implant/mindshield/removed(mob/target, silent = 0, special = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			to_chat(target, "<span class='boldnotice'>Your mind suddenly feels terribly vulnerable. You are no longer safe from brainwashing.</span>")
		return 1
	return 0

/obj/item/weapon/implanter/mindshield
	name = "implanter (mindshield)"
<<<<<<< HEAD
	imp_type = /obj/item/weapon/implant/mindshield
=======
	imptype = /obj/item/weapon/implant/mindshield
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee

/obj/item/weapon/implantcase/mindshield
	name = "implant case - 'Mindshield'"
	desc = "A glass case containing a mindshield implant."
<<<<<<< HEAD
	imp_type = /obj/item/weapon/implant/mindshield
=======
	imptype = /obj/item/weapon/implant/mindshield
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee
