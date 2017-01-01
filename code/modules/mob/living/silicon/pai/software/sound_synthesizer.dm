/datum/pai/software/sound_synthesizer
	name = "Sound Synthesizer"
	description = "A software suite for creating music and various sounds."
	category = "basic"
	sid = "soundsynth"

	ram = 10
	var/static/list/instruments = list("Space Violin" = "violin", "Guitar" = "guitar", "Space Piano" = "piano", "Space Minimoog" = "piano")
	var/selectedInstrument = "" //This is here solely to recognize the difference between the space piano and minimoog

/datum/pai/software/sound_synthesizer/action_use(mob/living/silicon/pai/user, var/args)
	if(args["song"])
		user.song.interact(user)
	if(args["instrument"])
		var/instrument = args["instrument"]
		if(!instrument in instruments)
			return
		user.song.playing = 0
		selectedInstrument = instrument
		user.song.instrumentDir = instruments[instrument]
		user.song.interact(user)
	if(args["sound"])
		if(world.time < user.nextSoundTime)
			return
		switch(args["sound"])
			if("honk")
				playsound(get_turf(user), 'sound/items/bikehorn.ogg', 50, 0)
				user.nextSoundTime = world.time + 20
			if("airhorn")
				playsound(get_turf(user), 'sound/items/AirHorn2.ogg', 50, 0)
				user.nextSoundTime = world.time + 50
			if("sadtrombone")
				playsound(get_turf(user), 'sound/misc/sadtrombone.ogg', 50, 0)
				user.nextSoundTime = world.time + 35


/datum/pai/software/sound_synthesizer/action_installed(mob/living/silicon/pai/user)
	user.song = new /datum/song/pai(user)

/datum/pai/software/sound_synthesizer/action_menu(mob/living/silicon/pai/user)
	if(!user.song)
		return "<b>Error: software not found</b><br>"
	var/dat = {"<h3>Sound Synthesizer</h3>
		Status: [user.song.instrumentDir ? (user.song.playing ? "Playing" : "Paused") : "No instrument selected"]<br>
		<h4>Song</h4><ul>
		<li><A href='byond://?src=\ref[user];software=[sid];song=1;'>Editor</A></li>
		</ul>
		<h4>Instrument</h4><ul>"}
	for(var/I in instruments)
		var/bold = (I == selectedInstrument)
		dat += "<li>[bold ? "<b>" : "<A href='byond://?src=\ref[user];software=[sid];instrument=[I];'>"][I][bold ? "</b>" : "</A>"]</li>"
	dat += {"</ul>
		<h4>Additional Sounds</h4><ul>
		<li><A href='byond://?src=\ref[user];software=[sid];sound=honk;'>Honk</A></li>
		<li><A href='byond://?src=\ref[user];software=[sid];sound=airhorn;'>Airhorn</A></li>
		<li><A href='byond://?src=\ref[user];software=[sid];sound=sadtrombone;'>Sad Trombone</A></li>
		</ul>
		"}
	return dat

//Pai SONG

/datum/song/pai

/datum/song/pai/New(mob/living/silicon/pai/user)
	..("", user.card)

/datum/song/pai/updateDialog(mob/living/silicon/pai/user)
	interact(user)

/datum/song/pai/shouldStopPlaying(mob/living/silicon/pai/user)
	return !instrumentDir || !user || qdeleted(user) || user.stat
