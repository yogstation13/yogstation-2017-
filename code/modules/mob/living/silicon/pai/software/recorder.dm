/datum/pai/software/recorder
	name = "Digital Audio Recorder"
	description = "Enables the recording and playback of audible messages. Best used in conjuntion with Universal Translator software."
	category = "Basic"
	sid = "recorder"
	ram = 5

/datum/pai/software/recorder/action_use(mob/living/silicon/pai/user, args)
	if(!user.recorder)
		return
	if(args["record"])
		var/i = text2num(args["record"])
		var/wasRecording = user.recorder.recording
		user.recorder.stop()
		if(user.recorder.mytape == user.audio_tapes[i])
			if(!wasRecording)
				spawn(-1)
					user.recorder.record()
		else
			user.recorder.mytape = user.audio_tapes[i]
			spawn(-1)
				user.recorder.record()
	if(args["play"])
		var/i = text2num(args["play"])
		var/wasPlaying = user.recorder.playing
		user.recorder.stop()
		if(user.recorder.mytape == user.audio_tapes[i])
			if(!wasPlaying)
				spawn(-1)
					user.recorder.play()
		else
			user.recorder.mytape = user.audio_tapes[i]
			spawn(-1)
				user.recorder.play()
	if(args["erase"])
		var/i = text2num(args["erase"])
		var/answer = alert("Are you sure you wish to erase this recording?", "Erase Recording", "Yes", "No")
		if((answer != "Yes") || !user || qdeleted(user) || user.stat || !user.audio_tapes || (user.audio_tapes.len < i))
			return
		var/obj/item/device/tape/T = user.audio_tapes[i]
		if(user.recorder.mytape == T)
			user.recorder.stop()
		T.erase()

/datum/pai/software/recorder/action_installed(mob/living/silicon/pai/user)
	user.recorder = new /obj/item/device/taperecorder/pai(user)
	var/obj/item/device/tape/tape1 = new /obj/item/device/tape(user)
	var/obj/item/device/tape/tape2 = new /obj/item/device/tape(user)
	tape1.name = "Recording 1"
	tape2.name = "Recording 2"
	tape1.max_capacity = 300
	tape2.max_capacity = 300
	user.audio_tapes = list(tape1, tape2)

/datum/pai/software/recorder/action_menu(mob/living/silicon/pai/user)
	if(!user.recorder)
		return "<b>No recorder installed</b><br>"
	var/dat = ""
	dat += "<h3>Digital Audio Recorder</h3><br><br>Audio Files:<ul>"
	var/i = 1
	for(var/obj/item/device/tape/tape in user.audio_tapes)
		var/rec = (user.recorder && (user.recorder.mytape == tape) && user.recorder.recording)
		var/play = (user.recorder && (user.recorder.mytape == tape) && user.recorder.playing)
		dat += "<li>[tape.name] ([time2text(tape.used_capacity * 10,"mm:ss")]/[time2text(tape.max_capacity * 10,"mm:ss")]):\
										<A href='byond://?src=\ref[user];software=[sid];erase=[i];'>\[ERASE\]</A>\
						[rec ? "<b>" : ""]<A href='byond://?src=\ref[user];software=[sid];record=[i];'>\[RECORD\]</A>[rec ? "</b>" : ""]\
						[play ? "<b>" : ""]<A href='byond://?src=\ref[user];software=[sid];play=[i];'>\[PLAY\]</A>[play ? "</b>" : ""]</li>"
		i++
	dat += "</ul>"

	return dat


//Pai TAPE RECORDER

/obj/item/device/taperecorder/pai

/obj/item/device/taperecorder/pai/New()
	..()
	update_languages()

/obj/item/device/taperecorder/pai/proc/update_languages()
	var/mob/living/silicon/pai/P = loc
	if(!istype(loc))
		return
	languages_understood = P.languages_understood
	languages_spoken = P.languages_spoken

/obj/item/device/taperecorder/pai/sayRecorded(index)
	update_languages()
	..()

/obj/item/device/taperecorder/pai/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans)
	update_languages()
	..()

/obj/item/device/taperecorder/pai/record()
	update_languages()
	..()

/obj/item/device/taperecorder/pai/stop()
	update_languages()
	..()