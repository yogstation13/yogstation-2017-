//By Carnwennan

//This system was made as an alternative to all the in-game lists and variables used to log stuff in-game.
//lists and variables are great. However, they have several major flaws:
//Firstly, they use memory. TGstation has one of the highest memory usage of all the ss13 branches.
//Secondly, they are usually stored in an object. This means that they aren't centralised. It also means that
//the data is lost when the object is deleted! This is especially annoying for things like the singulo engine!
#define INVESTIGATE_DIR "data/investigate/"

//SYSTEM
/proc/investigate_subject2file(subject)
	return file("[INVESTIGATE_DIR][subject].html")

/proc/investigate_reset()
	if(fdel(INVESTIGATE_DIR))	return 1
	return 0

/atom/proc/investigate_log(message, subject)
	if(!message)	return
	var/F = investigate_subject2file(subject)
	if(!F)	return
	F << "<small>[time_stamp()] \ref[src] ([x],[y],[z])</small> || [src] [message]<br>"

//ADMINVERBS
	set name = "Investigate"
	set category = "Admin"
	if(!holder)	return
	switch(subject)
			var/F = investigate_subject2file(subject)
			if(!F)
				src << "<font color='red'>Error: admin_investigate: [INVESTIGATE_DIR][subject] is an invalid path or cannot be accessed.</font>"
				return
			src << browse(F,"window=investigate[subject];size=800x300")

		if("hrefs")				//persistant logs and stuff
			if(config && config.log_hrefs)
				if(href_logfile)
					src << browse(href_logfile,"window=investigate[subject];size=800x300")
				else
					src << "<font color='red'>Error: admin_investigate: No href logfile found.</font>"
					return
			else
				src << "<font color='red'>Error: admin_investigate: Href Logging is not on.</font>"
				return
		if("notes")
			show_note()
		if("multikey")
			var/list/K = list()

			for(var/mob/M in player_list)
				var/ip = get_ip(M)

				var/exists = 0
				for(var/datum/investigation/multikeyer/MK in K)
					if(MK.ip == ip)
						exists = 1
						MK.clients += get_client(M)
						break

				if(!exists)
					K += new /datum/investigation/multikeyer(M)

			var/data
			data += "<html><head><title>Multikeyer Viewer</title><style> div { font-family: Verdana; margin: 4px; background: #ff9900; border: solid 1px #333333; } p { margin: 4px; padding: 4px; } .safe { background: #009900; } .header { text-align: center; font-weight: bold; } </style></head><body>"

			var/count = 0
			for(var/datum/investigation/multikeyer/MK in K)
				if(MK.clients.len < 2)
					continue

				count++

				data += "<div>"
				data += "<p class='header'>[MK.ip]</p><ul>"
				for(var/client/C in MK.clients)
					data += "<li><b>[get_ckey(C)]</b> (cid [get_computer_id(C)]) "
					if(C.mob)
						data += {"
							(<a href='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</a>)
							(<a href='?_src_=holder;adminplayeropts=\ref[C.mob]'>PP</a>)
							(<a href='?_src_=vars;Vars=\ref[C.mob]'>VV</a>)
							(<a href='?_src_=holder;subtlemessage=\ref[C.mob]'>SM</a>)
							(<a href='?_src_=holder;adminplayerobservefollow=\ref[C.mob]'>FLW</a>)
							"}
					data += "</li>"
				data += "</ul></div>"

			if(count == 0)
				data += "<div class='safe'>"
				data += "<p>No keys exist on the same IP address.</p>"
				data += "</div>"

			data += "</body></html>"

			src << browse(data,"window=investigate-multikeys;size=700x400")

/datum/investigation/multikeyer
	var/ip
	var/list/clients = list()

/datum/investigation/multikeyer/New(var/mob/M)
	src.ip = get_ip(M)
	src.clients += get_client(M)