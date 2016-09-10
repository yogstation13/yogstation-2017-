/obj/item/weapon/implant/bombcollar
	name = "collar console implant"
	desc = "You die with me."
	origin_tech = "materials=4;magnets=4;programming=4;biotech=4;syndicate=5;bluespace=5"
	var/list/linkedCollars = list()
	var/info
	var/list/boundCollars = list()

/obj/item/weapon/implant/bombcollar/activate(mob/user as mob)
	switch(alert("Select an option.","Bomb Collar Control","Locks","Detonation","Other"))
		if("Locks")
			var/choice = input(user, "Select collar to change.", "Locking Control") in linkedCollars
			var/obj/item/clothing/head/bombCollar/collarToLock = choice
			if(!collarToLock)
				return
			if(!iscarbon(collarToLock.loc))
				imp_in << "<span class='warning'>That collar isn't being held or worn by anyone.</span>"
				return
			var/mob/living/carbon/C = collarToLock.loc
			if(C.head != collarToLock)
				imp_in << "<span class='warning'>That collar isn't around someone's neck.</span>"
				return
			collarToLock.audible_message("<span class='warning'>[collarToLock] softly clicks.</span>")
			switch(collarToLock.locked)
				if(0)
					collarToLock.locked = 1
					collarToLock.flags |= NODROP
					C << "<span class='boldannounce'>[collarToLock] tightens and locks around your neck.</span>"
					message_admins("[imp_in] locked bomb collar worn by [C]")
				if(1)
					collarToLock.locked = 0
					collarToLock.flags &= ~NODROP
					C << "<span class='boldannounce'>[collarToLock] loosens around your neck.</span>"
					message_admins("[imp_in] unlocked bomb collar worn by [C]")
			imp_in << "<span class='notice'>You [collarToLock.locked ? "" : "dis"]engage [collarToLock]'s locks.</span>"
			return
		if("Detonation")
			var/choice = input(user, "Select collar to detonate.", "Detonation Control") in linkedCollars
			var/obj/item/clothing/head/bombCollar/collarToDetonate = choice
			if(!collarToDetonate)
				return
			if(!iscarbon(collarToDetonate.loc))
				imp_in << "<span class='warning'>That collar isn't being held or worn by anyone.</span>"
				return
			var/mob/living/carbon/C = collarToDetonate.loc
			if(C.head != collarToDetonate)
				imp_in << "<span class='warning'>That collar isn't around someone's neck.</span>"
				return
			switch(alert("Are you sure about this?","Bomb Collar Detonation","Proceed","Exit"))
				if("Proceed")
					if(!collarToDetonate.locked)
						imp_in << "<span class='warning'>That collar isn't locked.</span>"
						return
					imp_in << "<span class='notice'>Detonation signal sent.</span>"
					linkedCollars.Remove(collarToDetonate)
					collarToDetonate.detonate()
					message_admins("[imp_in] detonated bomb collar worn by [C]")
				if("Exit")
					return
			return

		if("Other")
			switch(alert("Select an option", "Collar console","Status","Bind"))
				if("Status")
					imp_in << "<span class='notice'><b>Bomb Collar Status Report:</b></span>"
					for(var/obj/item/clothing/head/bombCollar/C in linkedCollars)
						var/turf/T = get_turf(C)
						imp_in << "<b>[C]:</b> [iscarbon(C.loc) ? "Worn by [C.loc], " : ""][get_area(C)], [T.loc.x], [T.loc.y], [C.locked ? "<span class='boldannounce'>Locked</span>" : "<font color='green'><b>Unlocked</b></font>"]"
					return
				if("Bind")
					imp_in << "<span class='warning'>Bind a collar to your implant, if you die, they die with you"
					var/choice = input(user, "Select collar to bind.", "Binding Control") in linkedCollars
					var/obj/item/clothing/head/bombCollar/collarToBind = choice
					if(!collarToBind)
						return
					if(!iscarbon(collarToBind.loc))
						imp_in << "<span class='warning'>That collar isn't being held or worn by anyone.</span>"
						return
					var/mob/living/carbon/C = collarToBind.loc
					if(C.head != collarToBind)
						imp_in << "<span class='warning'>That collar isn't around someone's neck.</span>"
						return
					switch(alert("Select an option","Collar console","Bind","Unbind"))
						if("Bind")
							boundCollars += collarToBind
							imp_in << "You bind [collarToBind] to you, once you die, their collar will detonate."
						if("Unbind")
							boundCollars -= collarToBind
							imp_in << "You unbind [collarToBind], if you die, they wont suffer the same fate."
					return

/obj/item/weapon/implant/bombcollar/trigger(emote)
	if(emote == "deathgasp")
		alluha_ackbar()

/obj/item/weapon/implant/bombcollar/proc/alluha_ackbar(mob/source) //I'm not great with names
	for(var/obj/item/clothing/head/bombCollar/C in boundCollars)
		C.detonate()
		message_admins("[C] detonated due to the death of an implantee")

/obj/item/weapon/implanter/bombcollar
	name = "implanter (collar console)"

/obj/item/weapon/implanter/bombcollar/New()
	imp = new /obj/item/weapon/implant/bombcollar(src)
	..()

/obj/item/weapon/implantcase/bombcollar
	name = "implant case - 'Collar Console'"
	desc = "A glass case containing an implant version of the collar detonator."

/obj/item/weapon/implantcase/bombcollar/New()
	imp = new /obj/item/weapon/implant/bombcollar(src)
	..()
