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


/obj/item/weapon/implant/mindshield/implant(mob/target)
	if(..())
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
			to_chat(target, "<span class='notice'>Your cyberman body silenty disables the Nanotrasen nanobots as they enter your bloodstream. You appear to be implanted, but the implant has no effect.</span>")
		if((target.mind in ticker.mode.cult) || (target.mind in ticker.mode.blue_deity_prophets|ticker.mode.red_deity_prophets|ticker.mode.red_deity_followers|ticker.mode.blue_deity_followers))
			to_chat(target, "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>")
		else
			to_chat(target, "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>")
		return 1
	return 0

/obj/item/weapon/implant/mindshield/removed(mob/target, var/silent = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			to_chat(target, "<span class='boldnotice'>Your mind suddenly feels terribly vulnerable. You are no longer safe from brainwashing.</span>")
		return 1
	return 0


/obj/item/weapon/implanter/mindshield
	name = "implanter (mindshield)"
	imptype = /obj/item/weapon/implant/mindshield

/obj/item/weapon/implantcase/mindshield
	name = "implant case - 'Mindshield'"
	desc = "A glass case containing a mindshield implant."
	imptype = /obj/item/weapon/implant/mindshield