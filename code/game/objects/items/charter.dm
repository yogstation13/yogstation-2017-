/obj/item/station_charter
	name = "station charter"
	icon = 'icons/obj/wizard.dmi'
	attack_verb = list("renamed", "charted", "named")
	icon_state = "scroll2"
<<<<<<< HEAD
	desc = "An official document entrusting the governance of the station and surrounding space to the Captain. Despite the fact it looks like a scroll, it actually has highly powerful electronic bindings attached which transmits information back and forth to Centcomm."
=======
	desc = "An official document entrusting the governance of the station \
		and surrounding space to the Captain. "
>>>>>>> masterTGbranch
	var/used = FALSE
	var/pending_name
	var/admin_controlled
	var/mob/living/scripter

	var/unlimited_uses = FALSE
	var/ignores_timeout = FALSE
	var/response_timer_id = null
	var/approval_time = 600

	var/static/regex/standard_station_regex

/obj/item/station_charter/New()
	. = ..()
	if(!standard_station_regex)
		var/prefixes = jointext(station_prefixes, "|")
		var/names = jointext(station_names, "|")
		var/suffixes = jointext(station_suffixes, "|")
		var/numerals = jointext(station_numerals, "|")
		var/regexstr = "(([prefixes]) )?(([names]) ?)([suffixes]) ([numerals])"
		standard_station_regex = new(regexstr)

/obj/item/station_charter/Destroy()
	if(response_timer_id)
		deltimer(response_timer_id)
	response_timer_id = null
	. = ..()

/obj/item/station_charter/attack_self(mob/living/user)
	..()
	var/admins_number = admins.len
	if(!admins_number)
		user << "You hear something crackle in your ears for a moment before a voice speaks. \"Central Command is currently inactive, please check in again later before attempting to change the station's name.\""
		return
	if(used)
		user << "This charter has already been used to name the station."
		return
	if(!ignores_timeout && (world.time-round_start_time > CHALLENGE_TIME_LIMIT)) //5 minutes
		user << "The crew has already settled into the shift. \
			It probably wouldn't be good to rename the station right now."
		return
	if(response_timer_id)
		user << "You're still waiting for approval from your employers about \
			your proposed name change, it'd be best to wait for now."
		return

<<<<<<< HEAD
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
=======
	var/new_name = stripped_input(user, message="What do you want to name \
		[station_name()]? Keep in mind particularly terrible names may be \
		rejected by your employers, while names using the standard format, \
		will automatically be accepted.", max_length=MAX_CHARTER_LEN)

	if(!new_name)
		return
	log_game("[key_name(user)] has proposed to name the station as \
		[new_name]")

	if(standard_station_regex.Find(new_name))
		user << "Your name has been automatically approved."
		rename_station(new_name, user)
		return

	user << "Your name has been sent to your employers for approval."
	// Autoapproves after a certain time
	response_timer_id = addtimer(src, "rename_station", approval_time, TIMER_NORMAL, new_name, user)
	admins << "<span class='adminnotice'><b><font color=orange>CUSTOM STATION RENAME:</font></b>[key_name_admin(user)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) proposes to rename the station to [new_name] (will autoapprove in [approval_time / 10] seconds). (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[user]'>BSA</A>) (<A HREF='?_src_=holder;reject_custom_name=\ref[src]'>REJECT</A>) (<a href='?_src_=holder;CentcommReply=\ref[user]'>RPLY</a>)</span>"

/obj/item/station_charter/proc/reject_proposed(user)
	if(!user)
		return
	if(!response_timer_id)
		return
	var/turf/T = get_turf(src)
	T.visible_message("<span class='warning'>The proposed changes disappear \
		from [src]; it looks like they've been rejected.</span>")
	var/m = "[key_name(user)] has rejected the proposed station name."

	message_admins(m)
	log_admin(m)

	deltimer(response_timer_id)
	response_timer_id = null

/obj/item/station_charter/proc/rename_station(designation, mob/user)
	if(config && config.server_name)
		world.name = "[config.server_name]: [designation]"
	else
		world.name = designation
	station_name = designation
	minor_announce("[user.real_name] has designated your station as [station_name()]", "Captain's Charter", 0)
	log_game("[key_name(user)] has renamed the station as [station_name()].")

	name = "station charter for [station_name()]"
	desc = "An official document entrusting the governance of \
		[station_name()] and surrounding space to Captain [user]."

	if(!unlimited_uses)
		used = TRUE
>>>>>>> masterTGbranch
