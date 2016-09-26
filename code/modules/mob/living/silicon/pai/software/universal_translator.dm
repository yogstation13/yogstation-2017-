/datum/pai/software/universal_translator
	name = "Universal Translator"
	description = "Access to the galactic linguistic matrix, allowing instant real-time translation of all known human-xeno vocalisations and communication apparata."
	category = "Basic"
	sid = "universaltranslator"
	hrefline = 1
	ram = 5

/datum/pai/software/universal_translator/action_hrefline(mob/living/silicon/pai/user)
	var/dat = ""
	dat += "<a href='byond://?src=\ref[user];software=[sid];sub=0'>Universal Translator</a>[((user.languages_understood == ALL) && (user.languages_spoken == ALL)) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
	return dat

/datum/pai/software/universal_translator/action_menu(mob/user)
	. = {"<h3>Universal Translator</h3><br>
				When enabled, this device will automatically convert all spoken and written language into a format that any known recipient can understand.<br><br>
				The device is currently [ ((user.languages_understood == ALL) && (user.languages_spoken == ALL)) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled.</font><br>
				<a href='byond://?src=\ref[user];software=[sid];sub=0;toggle=1'>Toggle Device</a><br>
				"}
	return .

/datum/pai/software/universal_translator/action_use(mob/living/silicon/pai/user, var/args)
	if(args["toggle"])
		var/on_already = ((user.languages_understood == ALL) && (user.languages_spoken == ALL))
		user.languages_spoken = on_already ? (HUMAN | ROBOT) : ALL
		user.languages_understood = on_already ? (HUMAN | ROBOT) : ALL