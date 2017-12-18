/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1

	var/list/files = list()

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if (t)
		src.name = "data disk- '[t]'"
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/*
 * ID CARDS
 */
/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	// attack_verb = list("emagged", "hacked", "glitched") //might cause some problems with trying to emag borgs, will be excluded until someone resolves it
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"
	flags = NOBLUDGEON
	var/prox_check = TRUE //If the emag requires you to be in range

/obj/item/weapon/card/emag/bluespace
	name = "bluespace cryptographic sequencer"
	desc = "It's a blue card with a magnetic strip attached to some circuitry. It appears to have some sort of transmitter attached to it."
	color = rgb(40, 130, 255)
	origin_tech = "bluespace=4;magnets=4;syndicate=5"
	prox_check = FALSE

/obj/item/weapon/card/emag/attack()
	return

/obj/item/weapon/card/emag/afterattack(atom/target, mob/user, proximity)
	var/atom/A = target
	if(!proximity && prox_check)
		return
	A.emag_act(user)

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	slot_flags = SLOT_ID
	attack_verb = list("identified", "slapped")
	var/mining_points = 0 //For redeeming at mining equipment vendors
	var/list/access = list()
	var/registered_name = null // The name registered_name on the card
	var/assignment = null
	var/dorm = 0		// determines if this ID has claimed a dorm already
	var/has_fluff

/obj/item/weapon/card/id/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user] shows you: \icon[src] [src.name].</span>", \
					"<span class='notice'>You show \the [src.name].</span>")
	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/examine(mob/user)
	..()
	if(mining_points)
		to_chat(user, "There's [mining_points] mining equipment redemption point\s loaded onto this card.")

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/*
Usage:
update_label()
	Sets the id name to whatever registered_name and assignment is

update_label("John Doe", "Clowny")
	Properly formats the name and occupation and sets the id name to the arguments
*/
/obj/item/weapon/card/id/proc/update_label(newname, newjob)
	if(newname || newjob)
		name = "[(!newname)	? "identification card"	: "[newname]'s ID Card"][(!newjob) ? "" : " ([newjob])"]"
		return

	name = "[(!registered_name)	? "identification card"	: "[registered_name]'s ID Card"][(!assignment) ? "" : " ([assignment])"]"
	ID_fluff()

/obj/item/weapon/card/id/silver
	name = "silver identification card"
	desc = "A silver card which shows honour and dedication."
	attack_verb = list("promoted", "slapped", "identified")
	icon_state = "id_silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/gold
	name = "gold identification card"
	desc = "A golden card which shows power and might."
	attack_verb = list("promoted", "honored", "identified", "slapped")
	icon_state = "id_gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate)
	origin_tech = "syndicate=1"
	var/restricted = TRUE

/obj/item/weapon/card/id/syndicate/New()
	..()
	chameleon = new /datum/chameleon(src)
	chameleon.include_basetype = 1
	chameleon.chameleon_type = /obj/item/weapon/card/id
	chameleon.chameleon_name = "ID Card"
	chameleon.initialize_disguises()

/obj/item/weapon/card/id/syndicate/afterattack(obj/item/weapon/O, mob/user, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		if(istype(user, /mob/living) && user.mind)
			if(!restricted || user.mind.special_role)
				to_chat(usr, "<span class='notice'>The card's microscanners activate as you pass it over the ID, copying its access.</span>")

/obj/item/weapon/card/id/syndicate/attack_self(mob/user)
	if(istype(user, /mob/living) && user.mind)
		if(!restricted || user.mind.special_role)
			if(alert(user, "Action", "Agent ID", "Show", "Forge") == "Forge")
				var t = name_input(user, "What name would you like to put on this card?", "Agent card name", registered_name ? registered_name : (ishuman(user) ? user.real_name : user.name))
				if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
					if (t)
						alert("Invalid name.")
					return
				registered_name = t

				var u = stripped_input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant", MAX_MESSAGE_LEN)
				if(!u)
					registered_name = ""
					return
				assignment = u
				update_label()
				to_chat(user, "<span class='notice'>You successfully forge the ID card.</span>")
				return
	..()

/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate)

/obj/item/weapon/card/id/syndicate/unrestricted
	restricted = FALSE

/obj/item/weapon/card/id/syndicate/unrestricted/New()
	..()
	chameleon.antag_only = FALSE

/obj/item/weapon/card/id/syndicate/abductor
	name = "abductor agent card"
	desc = "A card that can copy access from the IDs of abductees."
	access = list()
	origin_tech = "abductor=3"

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	attack_verb = list("spared", "promoted", "honored", "identified", "slapped")
	icon_state = "id_gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/weapon/card/id/captains_spare/New()
	var/datum/job/captain/J = new/datum/job/captain
	access = J.get_access()
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper Centcom ID"
	desc = "An ID straight from Cent. Com."
	attack_verb = list("inspected", "identified", "slapped")
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/weapon/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/weapon/card/id/ert
	name = "\improper Centcom ID"
	desc = "A ERT ID card"
	icon_state = "centcom"
	attack_verb = list("responded to","identified", "slapped")
	registered_name = "Emergency Response Team Commander"
	assignment = "Emergency Response Team Commander"

/obj/item/weapon/card/id/ert/New()
	access = get_all_accesses()+get_ert_access("commander")-access_change_ids

/obj/item/weapon/card/id/ert/Security
	registered_name = "Security Response Officer"
	assignment = "Security Response Officer"

/obj/item/weapon/card/id/ert/Security/New()
	access = get_all_accesses()+get_ert_access("sec")-access_change_ids

/obj/item/weapon/card/id/ert/Engineer
	registered_name = "Engineer Response Officer"
	assignment = "Engineer Response Officer"

/obj/item/weapon/card/id/ert/Engineer/New()
	access = get_all_accesses()+get_ert_access("eng")-access_change_ids

/obj/item/weapon/card/id/ert/Medical
	registered_name = "Medical Response Officer"
	assignment = "Medical Response Officer"

/obj/item/weapon/card/id/ert/Medical/New()
	access = get_all_accesses()+get_ert_access("med")-access_change_ids

/obj/item/weapon/card/id/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	attack_verb = list("arrested", "cuffed", "took freedom from", "imprisoned", "identified", "slapped")
	icon_state = "id_orange"
	item_state = "orange-id"
	assignment = "Prisoner"
	registered_name = "Scum"
	var/goal = 0 //How far from freedom?
	var/points = 0

/obj/item/weapon/card/id/prisoner/attack_self(mob/user)
	to_chat(usr, "<span class='notice'>You have accumulated [points] out of the [goal] points you need for freedom.</span>")

/obj/item/weapon/card/id/prisoner/one
	name = "Prisoner #13-001"
	registered_name = "Prisoner #13-001"

/obj/item/weapon/card/id/prisoner/two
	name = "Prisoner #13-002"
	registered_name = "Prisoner #13-002"

/obj/item/weapon/card/id/prisoner/three
	name = "Prisoner #13-003"
	registered_name = "Prisoner #13-003"

/obj/item/weapon/card/id/prisoner/four
	name = "Prisoner #13-004"
	registered_name = "Prisoner #13-004"

/obj/item/weapon/card/id/prisoner/five
	name = "Prisoner #13-005"
	registered_name = "Prisoner #13-005"

/obj/item/weapon/card/id/prisoner/six
	name = "Prisoner #13-006"
	registered_name = "Prisoner #13-006"

/obj/item/weapon/card/id/prisoner/seven
	name = "Prisoner #13-007"
	registered_name = "Prisoner #13-007"

/obj/item/weapon/card/id/mining
	name = "mining ID"
	access = list(access_mining, access_mining_station, access_mineral_storeroom)


/obj/item/weapon/card/id/proc/ID_fluff()
	var/job = assignment
	var/list/idfluff = list(
	"Assistant" = list("civillian","green"),
	"Captain" = list("captain","gold"),
	"Head of Personnel" = list("civillian","silver"),
	"Head of Security" = list("security","silver"),
	"Chief Engineer" = list("engineering","silver"),
	"Research Director" = list("science","silver"),
	"Chief Medical Officer" = list("medical","silver"),
	"Station Engineer" = list("engineering","yellow"),
	"Atmospheric Technician" = list("engineering","white"),
	"Signal Technician" = list("engineering","green"),
	"Medical Doctor" = list("medical","blue"),
	"Geneticist" = list("medical","purple"),
	"Virologist" = list("medical","green"),
	"Chemist" = list("medical","orange"),
	"Paramedic" = list("medical","white"),
	"Psychiatrist" = list("medical","brown"),
	"Scientist" = list("science","purple"),
	"Roboticist" = list("science","black"),
	"Quartermaster" = list("cargo","silver"),
	"Cargo Technician" = list("cargo","brown"),
	"Shaft Miner" = list("cargo","black"),
	"Mining Medic" = list("cargo","blue"),
	"Bartender" = list("civillian","black"),
	"Botanist" = list("civillian","blue"),
	"Cook" = list("civillian","white"),
	"Janitor" = list("civillian","purple"),
	"Librarian" = list("civillian","purple"),
	"Chaplain" = list("civillian","black"),
	"Clown" = list("clown","rainbow"),
	"Mime" = list("mime","white"),
	"Clerk" = list("civillian","blue"),
	"Tourist" = list("civillian","yellow"),
	"Warden" = list("security","black"),
	"Security Officer" = list("security","red"),
	"Detective" = list("security","brown"),
	"Lawyer" = list("security","purple")
	)
	if(job in idfluff)
		has_fluff = 1
	else
		if(has_fluff)
			return
		else
			job = "Assistant" //Loads up the basic green ID
	overlays.Cut()
	overlays += idfluff[job][1]
	overlays += idfluff[job][2]
