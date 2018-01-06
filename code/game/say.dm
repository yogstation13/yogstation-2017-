/*
 	Miauw's big Say() rewrite.
	This file has the basic atom/movable level speech procs.
	And the base of the send_speech() proc, which is the core of saycode.
*/
var/list/freqtospan = list(
	"1351" = "sciradio",
	"1355" = "medradio",
	"1357" = "engradio",
	"1347" = "suppradio",
	"1349" = "servradio",
	"1359" = "secradio",
	"1353" = "comradio",
	"1447" = "aiprivradio",
	"1213" = "syndradio",
	"1337" = "centcomradio"
	)

/atom/movable/proc/say(message, languages = src.languages_spoken) //if you change src.languages_spoken to languages_spoken the proc will runtime due to an obscure byond bug
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	if(findtext(message, "linux") && !findtext(message, "gnu"))
		to_chat(src, "<span class='userdanger'>I’d just like to interject for moment. What you’re refering to as Linux, is in fact, GNU/Linux, or as I’ve recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX. Many computer users run a modified version of the GNU system every day, without realizing it. Through a peculiar turn of events, the version of GNU which is widely used today is often called Linux, and many of its users are not aware that it is basically the GNU system, developed by the GNU Project. There really is a Linux, and these people are using it, but it is just a part of the system they use. Linux is the kernel: the program in the system that allocates the machine’s resources to the other programs that you run. The kernel is an essential part of an operating system, but useless by itself; it can only function in the context of a complete operating system. Linux is normally used in combination with the GNU operating system: the whole system is basically GNU with Linux added, or GNU/Linux. All the so-called Linux distributions are really distributions of GNU/Linux!</span>")
		return
	var/list/spans = get_spans()
	send_speech(message, 7, src, , spans, languages)

/atom/movable/proc/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	return

/atom/movable/proc/can_speak()
	return 1

/atom/movable/proc/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, languages = src.languages_spoken) //if you change src.languages_spoken to languages_spoken the proc will runtime due to an obscure byond bug
	var/rendered = compose_message(src, languages, message, , spans)
	for(var/atom/movable/AM in get_hearers_in_view(range, src))
		AM.Hear(rendered, src, languages, message, , spans)

//To get robot span classes, stuff like that.
/atom/movable/proc/get_spans()
	return list()

/atom/movable/proc/compose_message(atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	//This proc uses text() because it is faster than appending strings. Thanks BYOND.
	//Basic span
	var/spanpart1 = "<span class='[radio_freq ? get_radio_span(radio_freq) : "game say"]'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq)]\] " : ""
	//Speaker name
	var/namepart =  "[speaker.GetVoice()][speaker.get_alt_name()]"
	//End name span.
	var/endspanpart = "</span>"
	//Message
	var/messagepart = " <span class='message'>[lang_treat(speaker, message_langs, raw_message, spans)]</span></span>"

	return "[spanpart1][spanpart2][freqpart][compose_track_href(speaker, namepart)][namepart][compose_job(speaker, message_langs, raw_message, radio_freq)][endspanpart][messagepart]"

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_quote(input, list/spans=list(), languages)
	if(!input)
		return "says, \"...\""	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
	var/extra = ""
	if(languages == ROBOT) //only if we are speaking only in robot
		extra = " in binary"
	var/ending = copytext(input, length(input))
	if(copytext(input, length(input) - 1) == "!!")
		spans |= SPAN_YELL
		return "[verb_yell][extra], \"[attach_spans(input, spans)]\""
	input = attach_spans(input, spans)
	if(ending == "?")
		return "[verb_ask][extra], \"[input]\""
	if(ending == "!")
		return "[verb_exclaim][extra], \"[input]\""

	return "[verb_say][extra], \"[input]\""

/atom/movable/proc/lang_treat(atom/movable/speaker, message_langs, raw_message, list/spans)
	if(languages_understood & message_langs)
		var/atom/movable/AM = speaker.GetSource()
		if(AM) //Basically means "if the speaker is virtual"
			if(AM.verb_say != speaker.verb_say || AM.verb_ask != speaker.verb_ask || AM.verb_exclaim != speaker.verb_exclaim || AM.verb_yell != speaker.verb_yell) //If the saymod was changed
				return speaker.say_quote(raw_message, spans, message_langs)
			return AM.say_quote(raw_message, spans, message_langs)
		else
			return speaker.say_quote(raw_message, spans, message_langs)
	else if((message_langs & HUMAN) || (message_langs & RATVAR)) //it's human or ratvar language
		var/atom/movable/AM = speaker.GetSource()
		if(message_langs & HUMAN)
			raw_message = stars(raw_message)
		if(message_langs & RATVAR)
			raw_message = text2ratvar(raw_message)
		if(AM)
			return AM.say_quote(raw_message, spans, message_langs)
		else
			return speaker.say_quote(raw_message, spans, message_langs)
	else if(message_langs & MONKEY)
		return "chimpers."
	else if(message_langs & ALIEN)
		return "hisses."
	else if(message_langs & ROBOT)
		return "beeps rapidly."
	else if(message_langs & DRONE)
		return "chitters."
	else if(message_langs & SWARMER)
		return "hums."
	else
		return "makes a strange sound."

/proc/get_radio_span(freq)
	var/returntext = freqtospan["[freq]"]
	if(returntext)
		return returntext
	return "radio"

/proc/get_radio_name(freq)
	var/returntext = radiochannelsreverse["[freq]"]
	if(returntext)
		return returntext
	return "[copytext("[freq]", 1, 4)].[copytext("[freq]", 4, 5)]"

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/atom/movable/proc/GetVoice()
	return name

/atom/movable/proc/IsVocal()
	return 1

/atom/movable/proc/get_alt_name()

//HACKY VIRTUALSPEAKER STUFF BEYOND THIS POINT
//these exist mostly to deal with the AIs hrefs and job stuff.

/atom/movable/proc/GetJob() //Get a job, you lazy butte

/atom/movable/proc/GetSource()

/atom/movable/proc/GetRadio()

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/device/radio/radio

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetSource()
	return source

/atom/movable/virtualspeaker/GetRadio()
	return radio

/atom/movable/virtualspeaker/Destroy()
	..()
	return QDEL_HINT_PUTINPOOL

/proc/get_virtual_speaker_for(atom/movable/AM, obj/item/device/radio/radio)
	if(!AM)
		return null
	var/atom/movable/virtualspeaker/virt = PoolOrNew(/atom/movable/virtualspeaker, null)
	virt.name = AM.name
	virt.languages_spoken = AM.languages_spoken
	virt.languages_understood = AM.languages_understood
	virt.identifier = AM.identifier
	virt.source = AM
	virt.radio = radio
	virt.verb_say = AM.verb_say
	virt.verb_ask = AM.verb_ask
	virt.verb_exclaim = AM.verb_exclaim
	virt.verb_yell = AM.verb_yell
	if(ismob(AM))
		var/mob/M = AM
		virt.job = M.job
	return virt
