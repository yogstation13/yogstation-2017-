/datum/pai/software/signaller
	name = "Signaller"
	description = "Provides ad-hoc broadcasting of radio signalling protocols. Useful for triggering things remotely."
	category = "Basic"
	sid = "signaller"
	ram = 5

/datum/pai/software/signaller/action_menu(mob/living/silicon/pai/user)
	var/dat = ""
	dat += "<h3>Remote Signaller</h3><br><br>"
	dat += {"<B>Frequency/Code</B> for signaler:<BR>
	Frequency:
	<A href='byond://?src=\ref[user];software=[sid];freq=-10;'>-</A>
	<A href='byond://?src=\ref[user];software=[sid];freq=-2'>-</A>
	[format_frequency(user.sradio.frequency)]
	<A href='byond://?src=\ref[user];software=[sid];freq=2'>+</A>
	<A href='byond://?src=\ref[user];software=[sid];freq=10'>+</A><BR>

	Code:
	<A href='byond://?src=\ref[user];software=[sid];code=-5'>-</A>
	<A href='byond://?src=\ref[user];software=[sid];code=-1'>-</A>
	[user.sradio.code]
	<A href='byond://?src=\ref[user];software=[sid];code=1'>+</A>
	<A href='byond://?src=\ref[user];software=[sid];code=5'>+</A><BR>

	<A href='byond://?src=\ref[user];software=[sid];send=1'>Send Signal</A><BR>"}
	return dat

/datum/pai/software/signaller/action_use(mob/living/silicon/pai/user, var/args)
	if(args["send"])
		user.sradio.send_signal("ACTIVATE")
		user.audible_message("[icon2html(user, viewers(user))] *beep* *beep*")
	if(args["freq"])
		var/new_frequency = (user.sradio.frequency + text2num(args["freq"]))
		if(new_frequency < 1200 || new_frequency > 1600)
			new_frequency = sanitize_frequency(new_frequency)
			user.sradio.set_frequency(new_frequency)
	if(args["code"])
		user.sradio.code += text2num(args["code"])
		user.sradio.code = round(user.sradio.code)
		user.sradio.code = min(100, user.sradio.code)
		user.sradio.code = max(1, user.sradio.code)