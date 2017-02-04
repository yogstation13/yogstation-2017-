/obj/item/weapon/implant/mindshield
	name = "mindshield implant"
	desc = "Protects against brainwashing."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0

/obj/item/weapon/implant/mindshield/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Management Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device are much more resistant to brainwashing and become loyal to Nanotrasen.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that protects the host's mental functions from manipulation.<BR>
				<b>Special Features:</b> Enforces nanotrasen loyalty.<BR>
				<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat


/obj/item/weapon/implant/mindshield/implant(mob/target)
	if(..())
		var/obj/item/weapon/implant/mindslave/imp = locate(/obj/item/weapon/implant/mindslave) in target
		if(imp)
			imp.removed(target)
		if((target.mind in (ticker.mode.head_revolutionaries | ticker.mode.get_gang_bosses())) || is_shadow_or_thrall(target) || (target.mind in ticker.mode.cult) || (target.mind in ticker.mode.blue_deity_prophets | ticker.mode.red_deity_prophets | ticker.mode.red_deity_followers | ticker.mode.blue_deity_followers))
			target.visible_message("<span class='warning'>[target] seems to resist the implant!</span>", "<span class='warning'>You feel the vile corporate tendrils of Nanotrasen trying to infiltrate your mind!</span>")
			removed(target, 1)
			qdel(src)
			return -1
		if(target.mind in ticker.mode.get_gangsters())
			ticker.mode.remove_gangster(target.mind)
			target.visible_message("<span class='notice'>[target] seems to have given up their life of crime!</span>")
		if(target.mind in ticker.mode.revolutionaries)
			ticker.mode.remove_revolutionary(target.mind)
		if(ticker.mode.is_cyberman(target.mind))
			target << "<span class='notice'>Your cyberman body silenty disables the Nanotrasen nanobots as they enter your bloodstream. You appear to be implanted, but the implant has no effect.</span>"
		if((target.mind in ticker.mode.cult) || (target.mind in ticker.mode.blue_deity_prophets | ticker.mode.red_deity_prophets | ticker.mode.red_deity_followers | ticker.mode.blue_deity_followers))
			target << "<span class='warning'>You feel the vile corporate tendrils of Nanotrasen try to clear your mind of your lord's influence, before a light floods your vision and the implant shuts down!</span>"
		if(target.mind in ticker.mode.traitors)
			target << "<span class='warning'>You feel the vile corporate tendrils of Nanotrasen try to corrupt your mind, but your syndicate training fights it off.</span>"
		if(target.mind in ticker.mode.changelings)
			target << "<span class='warning'>We feel some primitive technology attempt to control our minds, but we quash it's effects quickly."
		if(target.mind in ticker.mode.wizards)
			target << "<span class='warning'>You feel the vile corporate tendrils of Nanotrasen try to influence your mind, before the nanobots violently self destruct out of confusion and fear. Seems like they don't much like your choice in comic books."
			target.visible_message("<span class='warning'>[target] seems to be immune to the effects of the implant! Seems like magic trumps technology...</span>")
			removed(target, 1)
			qdel(src)
			return -1
		if(target.mind in ticker.mode.syndicates)
			target << "<span class='warning'You feel something knock against your mind. Nothing happens. You suppose it was just a breeze?"
			target.visible_message("<span class='warning'>[target] is completely immune to the effects of the loyalty implant. Why did you implant a syndicate operative, you moron?")
		else
			target << "<span class='notice'>You feel a surge of loyalty towards Nanotrasen! Your mind is now a puppet of their will!</span>"
		return 1
	return 0

/obj/item/weapon/implant/mindshield/removed(mob/target, var/silent = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			target << "<span class='boldnotice'>Your mind suddenly feels free of Nanotrasen's influence. You can think for yourself again-But is this really a good thing?</span>"
		return 1
	return 0


/obj/item/weapon/implanter/mindshield
	name = "implanter (loyalty)"

/obj/item/weapon/implanter/mindshield/New()
	imp = new /obj/item/weapon/implant/mindshield(src)
	..()
	update_icon()


/obj/item/weapon/implantcase/mindshield
	name = "implant case - 'Loyalty'"
	desc = "A glass case containing a loyalty implant."

/obj/item/weapon/implantcase/mindshield/New()
	imp = new /obj/item/weapon/implant/mindshield(src)
	..()
