/datum/pai/software/medical_hud
	name = "External Vitals Monitoring Suite"
	description = "Grants a holographic HUD which displays an approximate state of organic vitals within camera range, and a biometrics scanning suite."
	category = "Medical"
	sid = "medicalhud"
	hrefline = 1
	ram = 15

/datum/pai/software/medical_hud/action_hrefline(mob/living/silicon/pai/user)
	var/dat = ""
	dat = "<a href='byond://?src=\ref[user];software=[sid];sub=0'>Medical Analysis Suite</a>[(user.medHUD) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
	return dat

/datum/pai/software/medical_hud/action_use(mob/living/silicon/pai/user, var/args)
	if(args["toggle"])
		user.medHUD = !user.medHUD
		if(user.medHUD)
			user.add_med_hud()
		else
			var/datum/atom_hud/med = huds[user.med_hud]
			med.remove_hud_from(user)

/datum/pai/software/medical_hud/action_menu(mob/living/silicon/pai/user)
	var/dat = ""
	if(user.subscreen == 0)
		dat += {"<h3>Medical Analysis Suite</h3><br>
				 <h4>Visual Status Overlay</h4><br>
					When enabled, this package will scan all nearby crewmembers' vitals and provide real-time graphical data about their state of health.<br><br>
					The suite is currently [ (user.medHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled.</font><br>
					<a href='byond://?src=\ref[user];software=[sid];sub=0;toggle=1'>Toggle Suite</a><br>
					<br>
					<a href='byond://?src=\ref[user];software=[sid];sub=1'>Host Bioscan</a><br>
					"}
	if(user.subscreen == 1)
		dat += {"<h3>Medical Analysis Suite</h3><br>
				 <h4>Host Bioscan</h4><br>
				"}
		var/mob/living/M = user.card.loc
		if(!istype(M, /mob/living))
			while (!istype(M, /mob/living))
				if(istype(M, /turf))
					user.temp = "Error: No biological host found. <br>"
					user.subscreen = 0
					return dat
				M = M.loc
		dat += {"Bioscan Results for [M]: <br>"
		Overall Status: [M.stat > 1 ? "dead" : "[M.health]% healthy"] <br>
		Scan Breakdown: <br>
		Respiratory: [M.getOxyLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getOxyLoss()]</font><br>
		Toxicology: [M.getToxLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getToxLoss()]</font><br>
		Burns: [M.getFireLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getFireLoss()]</font><br>
		Structural Integrity: [M.getBruteLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getBruteLoss()]</font><br>
		Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)<br>
		"}
		for(var/datum/disease/D in M.viruses)
			dat += {"<h4>Infection Detected.</h4><br>
					 Name: [D.name]<br>
					 Type: [D.spread_text]<br>
					 Stage: [D.stage]/[D.max_stages]<br>
					 Possible Cure: [D.cure_text]<br>
					"}
		dat += "<a href='byond://?src=\ref[user];software=[sid];sub=0'>Visual Status Overlay</a><br>"
	return dat

