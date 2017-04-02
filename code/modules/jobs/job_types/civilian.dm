/*
Librarian
*/
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/librarian

	access = list(access_library)
	minimal_access = list(access_library)

/datum/outfit/job/librarian
	name = "Librarian"

	belt = /obj/item/device/pda/librarian
	uniform = /obj/item/clothing/under/rank/librarian
	l_hand = /obj/item/weapon/storage/bag/books
	r_pocket = /obj/item/weapon/barcodescanner
	l_pocket = /obj/item/device/laser_pointer

/*
Lawyer
*/
/datum/job/lawyer
	title = "Lawyer"
	flag = LAWYER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	var/lawyers = 0 //Counts lawyer amount

	outfit = /datum/outfit/job/lawyer

	access = list(access_lawyer, access_court, access_sec_doors)
	minimal_access = list(access_lawyer, access_court, access_sec_doors)

/datum/outfit/job/lawyer
	name = "Lawyer"

	belt = /obj/item/device/pda/lawyer
	ears = /obj/item/device/radio/headset/headset_sec
	uniform = /obj/item/clothing/under/lawyer/bluesuit
	suit = /obj/item/clothing/suit/toggle/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/weapon/storage/briefcase/lawyer
	l_pocket = /obj/item/device/laser_pointer

/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/datum/job/lawyer/J = SSjob.GetJob(H.job)
	J.lawyers++
	if(J.lawyers>1)
		uniform = /obj/item/clothing/under/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple

/*
Tourist
*/



/datum/job/tourist
	title = "Tourist"
	flag = TOUR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = -1
	spawn_positions = 0
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list()
	minimal_access = list()

	outfit = /datum/outfit/job/tourist

/datum/outfit/job/tourist
	name = "Tourist"

	uniform = /obj/item/clothing/under/tourist
	shoes = /obj/item/clothing/shoes/sneakers/black
	ears = /obj/item/device/radio/headset
	belt = /obj/item/device/pda
	backpack_contents = list(/obj/item/device/camera_film, /obj/item/stack/spacecash/c20, /obj/item/stack/spacecash/c20, /obj/item/stack/spacecash/c20)
	r_hand =  /obj/item/device/camera
	l_pocket = /obj/item/device/camera_film
	r_pocket = /obj/item/device/camera_film



/*
Clerk
*/



/datum/job/clerk
	title = "Clerk"
	flag = CLERK
	department_head = list("Head of Personnel")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_manufacturing)
	minimal_access = list(access_manufacturing)

	outfit = /datum/outfit/job/clerk

/datum/outfit/job/clerk
	name = "Clerk"

	belt = /obj/item/device/pda
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/clerk
	shoes = /obj/item/clothing/shoes/sneakers/black
	head = /obj/item/clothing/head/clerkcap



