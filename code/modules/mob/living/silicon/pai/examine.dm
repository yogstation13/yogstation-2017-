/mob/living/silicon/pai/examine()

	set src in oview()

	if(!usr || !src)	return
	if((usr.stat) && !istype(usr,/mob/dead/observer) )
		to_chat(usr, "<span class='notice'>Something is there but you can't see it.</span>")
		return

	var/msg = "<span class='info'>*---------*\nThis is \icon<b>[src][name], <i>a personal AI unit</i>!</b>"

	if (canmove || resting)
		msg += "\nA holographic projection resembling a [chassis] flickers about the unit, almost obscuring its card-shaped core suspended in its center."
	else
		msg += "\nA sleek card-shaped unit of carboncoat plastic, this unit is a container for an enigmatic personal AI unit. Who knows what being calls this humble shell its home?"

	if (src.description)
		msg += "\nA tag upon the unit's core reads: <i>[src.description]</i>."
	else
		msg += "\nA plain, unmarked tag upon the unit's core is clearly visible, though it contains no text."

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	msg += "\nThe unit is unnaturally still, completely frozen in time.." //afk
		if(UNCONSCIOUS)		msg += "\n<span class='warning'>A blue diagnostics screen with hundreds of lines of scrolling text covers its screen.</span>"
		if(DEAD)			msg += "\n<span class='deadsay'>An ominous red ring glowers out from its shattered display screen.</span>"
	msg += "\n*---------*</span>"

	to_chat(usr, msg)