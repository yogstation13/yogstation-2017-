
/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster. If necessary, it encrypts the signal for secure channels.

	Store a maximum of 100 logs and then deletes them.
*/


/obj/machinery/telecomms/server
	name = "telecommunication server"
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 15
	machinetype = 4
	//heatgen = 50
	var/list/log_entries = list()
	var/list/stored_names = list()
	var/list/TrafficActions = list()
	var/logs = 0 // number of logs
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/list/memory = list()	// stored memory
	var/rawcode = ""	// the code to compile (raw text)

	var/datum/TCS_Compiler/Compiler	// the compiler that compiles and runs the code
	var/autoruncode = 0		// 1 if the code is set to run every time a signal is picked up

	var/obj/item/device/encryptionkey/encryptionkey = null
	var/encryption = ""

	var/obj/item/device/radio/headset/server_radio = null
	var/last_signal = 0 	// Last time it sent a signal

/obj/machinery/telecomms/server/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/machine/telecomms/server(null)
	component_parts += new /obj/item/weapon/stock_parts/subspace/filter(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)
	RefreshParts()
	Compiler = new()
	Compiler.Holder = src
	server_radio = new()

/obj/machinery/telecomms/server/Destroy()
	// Garbage collects all the NTSL datums.
	if(Compiler)
		Compiler.GC()
		Compiler = null
	encryptionkey.forceMove(get_turf(src))
	encryptionkey = null
	..()

/obj/machinery/telecomms/server/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	if(signal.data["message"])

		if(is_freq_listening(signal))

			if(traffic > 0)
				totaltraffic += traffic // add current traffic to total traffic

			//Is this a test signal? Bypass logging
			if(signal.data["type"] != BROADCAST_TEST)

				// If signal has a message and appropriate frequency

				update_logs()

				var/datum/comm_log_entry/log = new

				// Copy the signal.data entries we want
				log.parameters["mobtype"] = signal.data["mobtype"]
				log.parameters["job"] = signal.data["job"]
				log.parameters["key"] = signal.data["key"]
				log.parameters["languages"] = signal.data["languages"]
				log.parameters["message"] = signal.data["message"]
				log.parameters["name"] = signal.data["name"]
				log.parameters["realname"] = signal.data["realname"]
				log.parameters["encryption"] = encryption

				log.parameters["uspeech"] = signal.data["languages"]

				// If the signal is still compressed, make the log entry gibberish
				if(signal.data["compression"] > 0)
					log.parameters["message"] = Gibberish(signal.data["message"], signal.data["compression"] + 50)
					log.parameters["job"] = Gibberish(signal.data["job"], signal.data["compression"] + 50)
					log.parameters["name"] = Gibberish(signal.data["name"], signal.data["compression"] + 50)
					log.parameters["realname"] = Gibberish(signal.data["realname"], signal.data["compression"] + 50)
					log.input_type = "Corrupt File"

				// Log and store everything that needs to be logged
				log_entries.Add(log)
				if(!(signal.data["name"] in stored_names))
					stored_names.Add(signal.data["name"])
				logs++
				signal.data["server"] = src
				if(encryptionkey && encryption)
					signal.data["encryption"] = encryption

				// Give the log a name
				var/identifier = num2text( rand(-1000,1000) + world.time )
				log.name = "data packet ([md5(identifier)])"

				if(Compiler && autoruncode)
					Compiler.Run(signal)	// execute the code
			if(encryption && !signal.data["encryption"])
				signal.data["encryption"] = encryption
			var/can_send = relay_information(signal, "/obj/machinery/telecomms/hub")
			if(!can_send)
				relay_information(signal, "/obj/machinery/telecomms/broadcaster")


/obj/machinery/telecomms/server/proc/setcode(t)
	if(t)
		if(istext(t))
			rawcode = t

/obj/machinery/telecomms/server/proc/admin_log(mob/mob)

	var/msg="[key_name(mob)] has compiled a script to server [src]:"
	diary << msg
	diary << rawcode
	src.investigate_log("[msg]<br>[rawcode]", "ntsl")
	if(length(rawcode)) // Let's not bother the admins for empty code.
		message_admins("[key_name_admin(mob)] (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) has compiled and uploaded a NTSL script to [src.id]",0,1)

/obj/machinery/telecomms/server/proc/compile(mob/user)
	if(jobban_isbanned(user, "ntsl"))
		usr << "<span class='warning'>You are banned from using NTSL.</span>"
		return
	if(Compiler)
		admin_log(user)
		return Compiler.Compile(rawcode)

/obj/machinery/telecomms/server/proc/update_logs()
	// start deleting the very first log entry
	if(logs >= 400)
		for(var/i = 1, i <= logs, i++) // locate the first garbage collectable log entry and remove it
			var/datum/comm_log_entry/L = log_entries[i]
			if(L.garbage_collector)
				log_entries.Remove(L)
				logs--
				break

/obj/machinery/telecomms/server/proc/add_entry(content, input)
	var/datum/comm_log_entry/log = new
	var/identifier = num2text( rand(-1000,1000) + world.time )
	log.name = "[input] ([md5(identifier)])"
	log.input_type = input
	log.parameters["message"] = content
	log_entries.Add(log)
	update_logs()



// Simple log entry datum

/datum/comm_log_entry
	var/parameters = list() // carbon-copy to signal.data[]
	var/name = "data packet (#)"
	var/garbage_collector = 1 // if set to 0, will not be garbage collected
	var/input_type = "Speech File"


/obj/machinery/telecomms/server/Options_Menu()
	var/dat = "<br>Encryption Key: "
	if(encryptionkey)
		dat += "<A href='?src=\ref[src];removekey=1'>\[[encryptionkey]\]</A>"
	else
		dat += "<A href='?src=\ref[src];addkey=1'>\[EMPTY\]</A>"
	return dat

// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/server/Options_Topic(href, href_list)
	if(href_list["removekey"])
		if(usr && encryptionkey && !issilicon(usr))
			usr.put_in_hands(encryptionkey)
			encryptionkey = null
			encryption = ""
	if(href_list["addkey"])
		insertKey(usr.get_active_hand(), usr)
	return
/*
/obj/machinery/telecomms/server/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/encryptionkey) && user.intent != "harm")
		insertKey(user.get_active_hand(), user)
		return 0
	return ..()
*/
/obj/machinery/telecomms/server/proc/insertKey(obj/item/device/encryptionkey/key, mob/user)
	if(user && !user.canUseTopic(src))
		return
	if(!istype(key))
		return
	if(encryptionkey)
		if(user)
			user << "<span class='notice'>\The [src] already contains an encryption key.</span>"
	if(istype(key))
		if(!user || user.unEquip(key))
			encryptionkey = key
			encryptionkey.forceMove(src)
			if(encryptionkey.encryption_keys.len)
				encryption = encryptionkey.encryption_keys[1]
			if(user)
				user << "<span class='notice'>You insert [key] into [src].</span>"
		else
			if(user)
				user << "<span class='notice'>\The [key] is stuck to your hand!</span>"
	else

/obj/machinery/telecomms/server/TelemonitorInfo()
	return "Encryption Mode: [encryption ? encryption : "none"]<br>"

//Preset Servers

/obj/machinery/telecomms/server/presets
	network = "tcommsat"
	var/keytype

/obj/machinery/telecomms/server/presets/New()
	..()
	name = id
	if(keytype)
		var/obj/item/device/encryptionkey/E = new keytype()
		insertKey(E)

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(SCI_FREQ)
	autolinkers = list("science")
	keytype = /obj/item/device/encryptionkey/headset_sci

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(MED_FREQ)
	autolinkers = list("medical")
	keytype = /obj/item/device/encryptionkey/headset_med

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(SUPP_FREQ)
	autolinkers = list("supply")
	keytype = /obj/item/device/encryptionkey/headset_cargo

/obj/machinery/telecomms/server/presets/service
	id = "Service Server"
	freq_listening = list(SERV_FREQ)
	autolinkers = list("service")
	keytype = /obj/item/device/encryptionkey/headset_service

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list()
	autolinkers = list("common")

	//Common and other radio frequencies for people to freely use
	// 1441 to 1489
/obj/machinery/telecomms/server/presets/common/New()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(COMM_FREQ)
	autolinkers = list("command")
	keytype = /obj/item/device/encryptionkey/headset_com

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ)
	autolinkers = list("engineering")
	keytype = /obj/item/device/encryptionkey/headset_eng

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	autolinkers = list("security")
	keytype = /obj/item/device/encryptionkey/headset_sec


/obj/item/weapon/circuitboard/machine/telecomms/server
	name = "circuit board (Telecommunication Server)"
	build_path = /obj/machinery/telecomms/server
	origin_tech = "programming=2;engineering=2"
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)