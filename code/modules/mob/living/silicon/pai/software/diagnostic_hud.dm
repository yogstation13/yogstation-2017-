/datum/pai/software/diagnostic_hud
	name = "Robotics Diagnostic System"
	description = "Displays a holographic hud over bots and silicon-based lifeforms showing the amount of damage they have sustained."
	category = "Advanced"
	sid = "diagnostichud"
	hrefline = 1
	ram = 15

/datum/pai/software/diagnostic_hud/action_hrefline(mob/living/silicon/pai/user)
	var/dat = ""
	dat += "<a href='byond://?src=\ref[user];software=[sid];sub=0'>Robotics Diagnostic Suite</a>[(user.diagHUD) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
	return dat

/datum/pai/software/diagnostic_hud/action_use(mob/living/silicon/pai/user, var/args)
	if(args["toggle"])
		user.diagHUD = !user.diagHUD
		if(user.diagHUD)
			user.add_diag_hud()
		else
			var/datum/atom_hud/diag = huds[user.d_hud]
			diag.remove_hud_from(user)

/datum/pai/software/diagnostic_hud/action_menu(mob/living/silicon/pai/user, var/args)
	var/dat = {"<h3>Robotics Diagnostic System</h3><br>
				When enabled, this package will link with the internal diagnostic system of advanced machinery, such as cyborgs and bots, and present a visual representaion of their current state of integrity.<br><br>
				The package is currently [ (user.diagHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled.</font><br>
				<a href='byond://?src=\ref[user];software=[sid];sub=0;toggle=1'>Toggle Package</a><br>
				"}
	return dat