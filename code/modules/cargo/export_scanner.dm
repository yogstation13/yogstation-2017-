/obj/item/device/export_scanner
	name = "export scanner"
	desc = "A device used to check objects against Nanotrasen exports database."
	icon_state = "export_scanner"
	item_state = "radio"
	flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	siemens_coefficient = 1
	var/obj/machinery/computer/cargo/cargo_console = null

/obj/item/device/export_scanner/examine(user)
	..()
	if(!cargo_console)
		to_chat(user, "<span class='notice'>The [src] is currently not linked to a cargo console.</span>")

/obj/item/device/export_scanner/afterattack(obj/O, mob/user, proximity)
	if(!istype(O) || !proximity)
		return

	if(istype(O, /obj/machinery/computer/cargo))
		var/obj/machinery/computer/cargo/C = O
		if(!C.requestonly)
			cargo_console = C
			to_chat(user, "<span class='notice'>Scanner linked to [C].</span>")
	else if(!istype(cargo_console))
		to_chat(user, "<span class='warning'>You must link [src] to a cargo console first!</span>")
	else
<<<<<<< HEAD
		user.visible_message("<span class='notice'>[user] scans [O] with [src].</span>", "<span class='notice'>You scan [O] with [src].</span>")
		export_scan(O, user, cargo_console)

/proc/export_scan(obj/O, user, obj/machinery/computer/cargo/cargo_console)
	var/obj/docking_port/mobile/supply/supply = SSshuttle.supply
	if(!supply)
		user << "<span class='warning'>Falied to connect to exports database!</span>"
		return
	// Before you fix it: yes, checking manifests is a part of intended functionality.
	var/exported = FALSE
	for(var/a in supply.exports)
		var/datum/export/E = a
		if(E.applies_to(O, cargo_console.contraband, cargo_console.emagged))
			var/cost = E.get_cost(O, cargo_console.contraband, cargo_console.emagged)
			user << "<span class='notice'>Export cost: [cost] credits.</span>"
			if(is_type_in_list(O, supply.storage_objects) && O.contents.len)
				user << "<span class='notice'>(contents not included)</span>"
			exported = TRUE
			break
	if(!exported)
		user << "<span class='notice'>The object is unexportable.</span>"
=======
		// Before you fix it:
		// yes, checking manifests is a part of intended functionality.
		var/price = export_item_and_contents(O, cargo_console.contraband, cargo_console.emagged, dry_run=TRUE)

		if(price)
			to_chat(user, "<span class='notice'>Scanned [O], value: <b>[price]</b> credits[O.contents.len ? " (contents included)" : ""].</span>")
		else
<<<<<<< HEAD
			user << "<span class='warning'>Scanned [O], no export value. \
				</span>"
>>>>>>> masterTGbranch
=======
			to_chat(user, "<span class='warning'>Scanned [O], no export value.</span>")
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
