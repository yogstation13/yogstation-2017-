/proc/webhook_send_asay(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("asaymessage", query)

/proc/webhook_send_ooc(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("oocmessage", query)

/proc/webhook_send(var/method, var/data)
	var/query = "[webhook_address]?key=[webhook_key]&method=[method]&data=[json_encode(data)]"
	spawn(-1)
		world.Export(query)