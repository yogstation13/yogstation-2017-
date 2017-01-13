
/client/verb/admin_link_approval(hyperlink as text)
	set category = "Admin"
	set name = "Approve Link"

	/*// 15 second cool-down for link posting
	src.verbs -= /client/verb/admin_link_approval
	spawn(150)
		src.verbs += /client/verb/admin_link_approval*/

	for(var/datum/link_approval/test in link_approval_list)
		if(test.link == hyperlink)
			usr << "<span class='boldnotice'>Error: This link is already under approval.</span>"
			return

		//if(ckey(test.poster) == ckey(usr))
			//usr << "<span class='boldnotice'>Error: You already have a link waiting for approval.</span>"
			//return
			//This causes some bugs

	var/datum/link_approval/link = new /datum/link_approval(hyperlink)
	link_approval_list += link

	for(var/client/X in admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		X << "<span class='boldnotice'>[src] would like to <a href='?src=\ref[link];poster=\ref[src];admin=\ref[X];link=\ref[link];action=admin_link_approval;approved=1'>approve</a> | <a href='?src=\ref[link];poster=\ref[src];admin=\ref[X];link=\ref[link];action=admin_link_approval;approved=0'>deny</a> this link: [hyperlink]</span>"

/var/global/list/link_approval_list = list()

/datum/link_approval
	var/mob/poster = null
	var/link = null
	var/approved = -1
	var/mob/admin = null


/datum/link_approval/Topic(href, href_list[])
	..()

	if(href_list["action"] == "admin_link_approval")
		var/client/poster = locate(href_list["poster"])
		var/client/admin = locate(href_list["admin"])
		var/datum/link_approval/link = locate(href_list["link"])
		var/approved = href_list["approved"]

		if(!istype(link, /datum/link_approval))
			usr << "<span class='boldnotice'>Error: It may already have been accepted or denied.</span>"
			return

		if(!istype(admin, /client))
			usr << "<span class='boldnotice'>Error: It may already have been accepted or denied.</span>"
			return

		if(!istype(poster, /client))
			usr << "<span class='boldnotice'>Error: It may already have been accepted or denied.</span>"
			return

		if(!link)
			usr << "<span class='boldnotice'>Error: No link was found. It may already have been accepted or denied.</span>"
			return

		if(link.approved > -1)
			admin << "<span class='boldnotice'>This link was already [link.approved == 1 ? "approved" : "denied"] by [link.admin]</span>"
			return

		if(approved == "1")
			link.approved = 1
			link.admin = admin
			poster.bypass_ooc_approval = 1
			poster.ooc("Approved by [admin]: [link.link]")

			log_admin("Link Approved: Poster=[poster] Admin=[admin] Link=[link.link]")
		else
			link.approved = 0
			link.admin = admin
			var/why = input("Reason (or leave empty):")

			poster << "<span class='boldnotice'>Your link was denied.[why ? " Reason: [why]." : ""]</span>"

			for(var/client/X in admins)
				X << "<span class='boldnotice'>[admin] denied [poster]'s link: [link.link].[why ? " Reason: [why]." : ""]</span>"

			log_admin("Link Denied: Poster=[poster] Admin=[admin] Link=[link.link]")

		link_approval_list -= link

/datum/link_approval/New(var/hyperlink)
	poster = usr
	link = hyperlink

