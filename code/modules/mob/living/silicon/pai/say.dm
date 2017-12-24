/mob/living/silicon/pai/say(msg)
	if(silence_time)
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(msg)

/mob/living/silicon/pai/binarycheck()
	if(radio && radio.translate_binary)
		return 1
	return 0
