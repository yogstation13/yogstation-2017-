/datum/pai/software/security_hud
	name = "APB Security Advisory Matrix"
	description = "Taps into the holographic disciplinary matrix used by station security services. Can determine criminal status and job role based off facial recognition within camera range."
	category = "Security"
	sid = "securityhud"
	hrefline = 1
	ram = 15

/datum/pai/software/security_hud/action_hrefline(mob/living/silicon/pai/user)
	var/dat = ""
	dat += "<a href='byond://?src=\ref[user];software=[sid];sub=0'>Facial Recognition Suite</a>[(user.secHUD) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
	return dat

/datum/pai/software/security_hud/action_use(mob/living/silicon/pai/user, var/args)
	if(args["toggle"])
		user.secHUD = !user.secHUD
		if(user.secHUD)
			user.add_sec_hud()
		else
			var/datum/atom_hud/sec = huds[user.sec_hud]
			sec.remove_hud_from(user)

/datum/pai/software/security_hud/action_menu(mob/living/silicon/pai/user, var/args)
	var/dat = {"<h3>Facial Recognition Suite</h3><br>
				When enabled, this package will scan all viewable faces and compare them against the known criminal database, providing real-time graphical data about any detected persons of interest.<br><br>
				The package is currently [ (user.secHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled.</font><br>
				<a href='byond://?src=\ref[user];software=[sid];sub=0;toggle=1'>Toggle Package</a><br>
				"}
	return dat