#define CHARTER_EXP CHALLENGE_TIME_LIMIT

/obj/item/station_charter
	name = "station charter"
	icon = 'icons/obj/wizard.dmi'
	attack_verb = list("renamed", "charted", "named")
	icon_state = "scroll2"
	desc = "An official document entrusting the governance of the station and surrounding space to the Captain. Despite the fact it looks like a scroll, it actually has highly powerful electronic bindings attached which transmits information back and forth to Centcomm."
	var/used = FALSE
	var/pending_name
	var/admin_controlled
	var/mob/living/scripter
	var/expire_date
	var/cooldown // that's not needed, but hey. can stop spam.
	var/cooldownLEN = 60

	var/cooldownbonus = FALSE // 0 for not given, 1 for given.

/obj/item/station_charter/New()
	..()
	expire_date = CHARTER_EXP + world.time

/obj/item/station_charter/attack_self(mob/living/user)
	..()
	if(used)
		user << "The station has already been named."
		return
	if(cooldown > world.time)
		user << "<span class='notice'>The charter is recharging. You can still use it afterwards.</span>"
		return

	cooldown = world.time + cooldownLEN // six seconds sounds fine, right?
	if(!cooldownbonus)
		var/admins_number = admins.len
		if(!admins_number)
			user << "You hear something crackle in your ears for a moment before a voice speaks. \"Central Command is currently inactive, please check in again later before attempting to change the station's name.\""
			expire_date += 1200 // 2 more minutes
			cooldownbonus = TRUE
			return

	if(world.time > expire_date) //5 minutes from arrival + whatever
		user << "The crew has already settled into the shift. It probably wouldn't be good to rename the station right now."
		return

	used = TRUE

	var/new_name = input(user, "What do you want to name [station_name()]? Keep in mind particularly terrible names may attract the attention of your employers.")  as text|null
	if(new_name)
		pending_name = new_name
		user << "You hear something crackle in your ears for a moment before a voice speaks.  \"Thank you for getting in touch with Central Command, one of our advisers will be with you shortly. You will now be put on hold. Message ends.\""
		playsound(src,'sound/items/smoothelevator.ogg',40,1)

		for(var/client/X in admins)
			if(X.prefs.toggles & SOUND_ADMINHELP)
				X << 'sound/effects/adminhelp.ogg'
			X << ("<b><span class='notice'>[user.real_name] ([user.ckey]) is changing the station's name to [pending_name]. (<a href='byond://?src=\ref[src];admin=\ref[X];bearer=\ref[user];choice=approve'>Approve</a> | <a href='byond://?src=\ref[src];admin=\ref[X];choice=deny'>Deny</a>)</span></b>")
		log_game("[user.ckey] has attempted to change the station's name to [pending_name].")
		scripter = user
	else
		used = FALSE

/obj/item/station_charter/Topic(href, href_list)
	if (href_list["choice"])
		var/client/admin = locate(href_list["admin"])
		var/client/bearer = locate(href_list["bearer"])

		switch(href_list["choice"])
			if("approve")
				if(admin_controlled)
					admin << "A decision has already been made."
					return
				if(admin.ckey == bearer.ckey || admin.key == bearer.key)
					admin << "You cannot approve your own station name."
					log_admin("[admin] has attempted to approve their own station name: [pending_name]")
					message_admins("[admin] has attempted to approve their own station name: [pending_name]")
					return

				message_admins("[admin] has approved the new station's name made by: [pending_name]")
				log_admin("[admin] has approved [bearer]'s new station name: [pending_name]")
				log_game("[scripter] ([bearer]) has changed the station's name to [pending_name]")
				world.name = pending_name
				station_name = pending_name
				feedback_set_details("station_name","[pending_name]")
				minor_announce("[scripter.real_name] has designated your station as [world.name]", "Captain's Charter", 0)
				admin_controlled = TRUE

			if("deny")
				if(admin_controlled)
					admin << "A decision has already been made."
					return
				message_admins("[admin] has denied [scripter.ckey]'s new station name: [pending_name]")
				log_admin("[admin] has denied [scripter.ckey]'s new station name: [pending_name]")
				log_game("[scripter] ([bearer]) was denied when they attempted to change the station's name to [pending_name]")
				admin_controlled = TRUE
