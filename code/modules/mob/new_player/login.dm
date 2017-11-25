/mob/new_player/Login()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")

	if(admin_notice)
		to_chat(src, "<span class='notice'><b>Admin Notice:</b>\n \t [admin_notice]</span>")

	if(config.soft_popcap && living_player_count() >= config.soft_popcap)
		to_chat(src, "<span class='notice'><b>Server Notice:</b>\n \t [config.soft_popcap_message]</span>")

	sight |= SEE_TURFS

	if(check_rights(R_NOJOIN, 0))
		joining_forbidden = 1

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/
	new_player_panel()

	if(client.prefs.agree < MAXAGREE)
		disclaimer()
	else
		new_player_panel()
	if(ckey in deadmins)
		verbs += /client/proc/readmin
	spawn(40)
		if(client)
			client.playtitlemusic()
