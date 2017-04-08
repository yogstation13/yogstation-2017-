/datum/pai/software/crew_manifest
	name = "Crew Manifest"
	description = "Allows access to the currently assigned crew manifest as distributed by Command."
	category = "Basic"
	sid = "crewmanifest"
	ram = 5

/datum/pai/software/crew_manifest/action_menu(mob/user)
	. += "<h2>Crew Manifest</h2><br><br>"
	if(data_core.general)
		for(var/datum/data/record/t in sortRecord(data_core.general))
			. += "[t.fields["name"]] - [t.fields["rank"]]<BR>"
	. += "</body></html>"
	return .