#define REVPEN_COOLDOWN 300

// This is the rev_flash. Hijack tool is located in revolution.dm

/obj/item/device/assembly/flash/rev
	name = "suspicious device"
	desc = "You aren't sure what this thing does, but you're almost certain that it can't be good."
	icon = 'icons/obj/device.dmi'
	icon_state = "memorizer"
	item_state = "nullrod"
	origin_tech = "syndicate=1;combat=2;biotech=2"
	var/rev_cooldown = 0

/obj/item/device/assembly/flash/rev/attack(mob/living/M, mob/user)
	if(rev_cooldown)
		if(user.mind && (user.mind in ticker.mode.head_revolutionaries))
			user.visible_message("<span class='warning'>The flash is currently on a cooldown.</span>")
		else
			user.visible_message("<span class='warning'>A red light flickers on and off from the [src].</span>")
		return 0

	if(!try_use_flash(user))
		return 0

	if(iscarbon(M))
		flash_carbon(M, user, 5, 1)
		return 1

	else if(issilicon(M))
		add_logs(user, M, "flashed", src)
		M.flash_eyes(affect_silicon = 1)
		M.Weaken(rand(5,10))
		user.visible_message("<span class='disarm'>[user] holds something up to [M]'s sensor bank, and its eyes fall dark!</span>", "<span class='danger'>You overload [M]'s sensors with the device!</span>")
		return 1

	user.visible_message("<span class='disarm'>[user] tries to hold something up to [M]'s face, but nothing happens!</span>", "<span class='warning'>You fail to convert [M] with the device!</span>")

/obj/item/device/assembly/flash/rev/flash_carbon(mob/living/carbon/M, mob/user = null, power = 5, targeted = 1)
	add_logs(user, M, "flashed", src)
	var/resisted = 0
	if(user && targeted)
		if(M.weakeyes)
			M.Weaken(3) //quick weaken bypasses eye protection but has no eye flash
		if(M.flash_eyes(1, 1))
			M.confused += power
			if(ishuman(M) && ishuman(user) && M.stat != DEAD)
				if(user.mind && (user.mind in ticker.mode.head_revolutionaries))
					if(M.isActive())
						if(M.stat == CONSCIOUS)
							M.mind_initialize() //give them a mind datum if they don't have one.
							if(!isloyal(M))
								if(user.mind in ticker.mode.head_revolutionaries)
									if(ticker.mode.add_revolutionary(M.mind))
										times_used -- //Flashes less likely to burn out for headrevs when used for conversion
									else
										resisted = 1
							else
								resisted = 1

							if(resisted)
								user << "<span class='warning'>This mind seems resistant to conversion!</span>"
						else
							user << "<span class='warning'>They must be conscious before you can convert them!</span>"
							return
					else
						user << "<span class='warning'>This mind is so vacant that it is not susceptible to influence!</span>"
						return
			M.Stun(1)
			visible_message("<span class='disarm'>[user] holds something up to [M]'s face!</span>")
			if(resisted)
				user << "<span class='danger'>You fail to convert [M] with the device!</span>"
			else
				user << "<span class='danger'>You convert [M] to the cause!</span>"
			M << "<span class='userdanger'>[user] holds something up to your face!</span>"
			if(M.weakeyes)
				M.Stun(2)
				M.visible_message("<span class='disarm'>[M] gasps and shields their eyes!</span>", "<span class='userdanger'>You gasp and shield your eyes!</span>")
		else
			visible_message("<span class='disarm'>[user] tries to hold something up to [M]'s face, but fails!</span>")
			user << "<span class='warning'>You fail to convert [M] with the device!</span>"
			M << "<span class='danger'>[user] tries to hold something up to your face, but nothing happens!</span>"
	else
		if(M.flash_eyes())
			M.confused += power

	rev_cooldown = 1
	icon_state = "memorizer2"
	spawn(REVPEN_COOLDOWN)
		icon_state = initial(icon_state)
		rev_cooldown = 0
		src.visible_message("<span class='notice'>[src] vibrates.</span>")
