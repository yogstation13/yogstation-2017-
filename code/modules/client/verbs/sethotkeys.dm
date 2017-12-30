/client/verb/sethotkeys(from_pref = 0 as num)
	set name = "Set Hotkeys"
	set hidden = 1
	set desc = "Used to set mob-specific hotkeys or load hotkey mode from preferences"

	var/hotkey_default = "default"
	var/hotkey_macro = "hotkeys"
	var/current_setting

	var/list/default_macros = list("default", "robot-default")

	if(from_pref)
		current_setting = (prefs.hotkeys ? hotkey_macro : hotkey_default)
	else
		current_setting = winget(src, "mainwindow", "macro")

	if(mob)
		hotkey_macro = mob.macro_hotkeys
		hotkey_default = mob.macro_default

	if(prefs.hotkeysmode)
		hotkey_macro += "-azerty"
		hotkey_default += "-azerty"

	if(current_setting in default_macros)
		winset(src, null, "mainwindow.macro=[hotkey_default] input.focus=true input.background-color=#d3b5b5")
	else
		winset(src, null, "mainwindow.macro=[hotkey_macro] mapwindow.map.focus=true input.background-color=#e0e0e0")

/client/verb/togglehotkeys()
	set name = "Toggle Hotkeys"
	set hidden = 1
	set desc = "Toggles between default mode and hotkeys mode"

	var/hotkey_default = "default"
	var/hotkey_macro = "hotkeys"

	var/list/default_macros = list("default", "robot-default")
	var/new_setting
	var/default

	var/current_setting = winget(src, "mainwindow", "macro")

	if(mob)
		hotkey_macro = mob.macro_hotkeys
		hotkey_default = mob.macro_default


	if(current_setting in default_macros)
		new_setting = hotkey_macro
		default = FALSE
	else
		new_setting = hotkey_default
		default = TRUE

	//Don't add the suffix if it's the default mode
	if(prefs.hotkeysmode && !default)
		new_setting += "-azerty"

	if(default)
		winset(src, null, "mainwindow.macro=[new_setting] input.focus=true input.background-color=#d3b5b5")
	else
		winset(src, null, "mainwindow.macro=[new_setting] mapwindow.map.focus=true input.background-color=#e0e0e0")