/proc/send_discord_message(var/channel, var/message)
	if(discord_token == "nodiscord")
		return
	var/json_message = "{ \"content\" : \"[message]\" }"

	call("ByondPOST.dll", "send_post_request")("https://discordapp.com/api/channels/[discord_channels[channel]]/messages", json_message, "Authorization: Bot [discord_token]", "Content-Type: application/json")
