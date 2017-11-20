/client/verb/toggle_sound_env()
	set name = "Toggle Echo Effect"
	set category = "Preferences"
	set desc = "Environments in this game and your characters condition can affect the sound you hear. Toggle whether you want that off or on."
	prefs.soundenv = !prefs.soundenv
	to_chat(src, "Environments will [prefs.soundenv ? "now affect the sound you hear" : "no longer affect the sound you hear"].")