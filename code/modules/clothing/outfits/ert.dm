/datum/outfit/ert
	name = "ERT Common"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/device/radio/headset/headset_cent/alt

/datum/outfit/ert/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/weapon/implant/mindshield/L = new(H)
	L.imp_in = H
	L.implanted = 1
	H.sec_hud_set_implants()

	var/obj/item/weapon/implant/krav_maga/KM = new(H)
	KM.imp_in = H
	KM.implanted = 1

	var/obj/item/device/radio/R = H.ears
	R.set_frequency(CENTCOM_FREQ)
	R.freqlock = 1

	var/obj/item/weapon/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label(W.registered_name, W.assignment)

/datum/outfit/ert/commander
	name = "ERT Commander"

	id = /obj/item/weapon/card/id/ert
	suit = /obj/item/clothing/suit/space/hardsuit/ert
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	back = /obj/item/weapon/storage/backpack/captain
	belt = /obj/item/weapon/storage/belt/security/full
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/gun/energy/gun=1,\
		/obj/item/weapon/gun/projectile/automatic/wt550)
	l_pocket = /obj/item/weapon/kitchen/knife/combat

/datum/outfit/ert/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.keyslot = new /obj/item/device/encryptionkey/heads/captain
	R.recalculateChannels()

/datum/outfit/ert/commander/alert
	name = "ERT Commander - High Alert"

	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/gun/projectile/automatic/ar=1,\
		/obj/item/ammo_box/magazine/m556=1,\
		/obj/item/weapon/gun/energy/pulse/pistol/loyalpin=1)
	belt = /obj/item/weapon/storage/belt/military/assault
	/* Commented out until belt content definition becomes supported
	belt_contents = list(/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/weapon/grenade/flashbang=1,\
		/obj/item/weapon/restraints/handcuffs=1,\
		/obj/item/weapon/grenade/syndieminibomb/concussion/frag=3,\
		/obj/item/weapon/grenade/gluon=1)
	*/
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	l_pocket = /obj/item/weapon/melee/energy/sword/saber

/datum/outfit/ert/security
	name = "ERT Security"

	id = /obj/item/weapon/card/id/ert/Security
	suit = /obj/item/clothing/suit/space/hardsuit/ert/sec
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/gars/supergars
	back = /obj/item/weapon/storage/backpack/security
	belt = /obj/item/weapon/storage/belt/security/full
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/storage/box/handcuffs=1,\
		/obj/item/clothing/mask/gas/sechailer=1,\
		/obj/item/weapon/gun/projectile/automatic/wt550=1,\
		/obj/item/weapon/storage/box/emps=1,\
		/obj/item/weapon/gun/energy/gun/advtaser=1)
	l_pocket = /obj/item/weapon/kitchen/knife/combat
	r_pocket = /obj/item/ammo_box/magazine/wt550m9/wtap

/datum/outfit/ert/security/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.keyslot = new /obj/item/device/encryptionkey/heads/captain
	R.recalculateChannels()

/datum/outfit/ert/security/alert
	name = "ERT Security - High Alert"

	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/storage/box/handcuffs=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/storage/box/emps=1,\
		/obj/item/weapon/gun/energy/pulse/carbine/loyalpin=1)
	belt = /obj/item/weapon/storage/belt/military/assault
	/*
	belt_contents = list(/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/weapon/grenade/flashbang=1,\
		/obj/item/weapon/restraints/handcuffs=1,\
		/obj/item/weapon/grenade/syndieminibomb/concussion/frag=3,\
		/obj/item/weapon/grenade/gluon=1)
	*/
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal


/datum/outfit/ert/medic
	name = "ERT Medic"

	id = /obj/item/weapon/card/id/ert/Medical
	suit = /obj/item/clothing/suit/space/hardsuit/ert/med
	glasses = /obj/item/clothing/glasses/hud/health/night
	back = /obj/item/weapon/storage/backpack/medic
	belt = /obj/item/weapon/storage/belt/medical
	r_hand = /obj/item/weapon/storage/firstaid/regular
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer=1,\
		/obj/item/weapon/gun/energy/gun=1,\
		/obj/item/weapon/reagent_containers/hypospray/combat/nanites=1,\
		/obj/item/weapon/gun/syringe/rapidsyringe=1,\
		/obj/item/weapon/reagent_containers/syringe/lethal=1,\
		/obj/item/weapon/gun/medbeam=1)

/datum/outfit/ert/medic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.keyslot = new /obj/item/device/encryptionkey/heads/captain
	R.recalculateChannels()

/datum/outfit/ert/medic/alert
	name = "ERT Medic - High Alert"

	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/gun/energy/pulse/pistol/loyalpin=1,\
		/obj/item/weapon/reagent_containers/hypospray/combat/nanites=1,\
		/obj/item/weapon/storage/box/syndie_kit/bioterror=1,\
		/obj/item/weapon/gun/syringe/rapidsyringe=1,\
		/obj/item/weapon/gun/medbeam=1)
	r_pocket = /obj/item/weapon/grenade/chem_grenade/bioterrorfoam //yes, NT has some samples
	l_pocket = /obj/item/weapon/grenade/chem_grenade/bioterrorfoam //two to be specific

/datum/outfit/ert/engineer
	name = "ERT Engineer"

	id = /obj/item/weapon/card/id/ert/Engineer
	suit = /obj/item/clothing/suit/space/hardsuit/ert/engi
	glasses =  /obj/item/clothing/glasses/meson/night
	back = /obj/item/weapon/storage/backpack/industrial
	belt = /obj/item/weapon/storage/belt/utility/full
	/*
	belt_contents = list(/obj/item/weapon/weldingtool/experimental=1,\
		/obj/item/weapon/crowbar/red=1,\
		/obj/item/weapon/wirecutters=1,\
		/obj/item/weapon/screwdriver=1,\
		/obj/item/weapon/wrench=1,\
		/obj/item/device/multitool=1,\
		/obj/item/device/t_scanner=1)
	*/
	l_pocket = /obj/item/weapon/rcd_ammo/large
	r_hand = /obj/item/weapon/storage/firstaid/regular
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer=1,\
		/obj/item/weapon/gun/energy/gun=1,\
		/obj/item/areaeditor/blueprints,\
		/obj/item/weapon/rcd/combat=1)

/datum/outfit/ert/engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.keyslot = new /obj/item/device/encryptionkey/heads/captain
	R.recalculateChannels()

/datum/outfit/ert/engineer/alert
	name = "ERT Engineer - High Alert"

	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/rcd/combat=1,\
		/obj/item/weapon/gun/projectile/automatic/ar=1,\
		/obj/item/ammo_box/magazine/m556=2,\
		/obj/item/areaeditor/blueprints,\
		/obj/item/weapon/gun/energy/pulse/pistol/loyalpin=1)

/datum/outfit/ert/inquisitor //FUCKEN XENOS
	name = "ERT Religious Specialist"

	id = /obj/item/weapon/card/id/ert
	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor
	glasses = /obj/item/clothing/glasses/godeye
	back = /obj/item/weapon/storage/backpack/cultpack
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/restraints/legcuffs/bola/cult=1,\
		/obj/item/weapon/sharpener/cult=1,\
		/obj/item/weapon/nullrod/claymore/chainsaw_sword=1,\
		/obj/item/weapon/storage/book/bible=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater=1,\
		/obj/item/weapon/melee/baton/loaded=1)
	r_pocket = /obj/item/weapon/restraints/handcuffs/energy/cult
	l_pocket = /obj/item/weapon/gun/energy/gun/mini
	belt = /obj/item/weapon/storage/belt/security/full

/datum/outfit/ert/inquisitor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.keyslot = new /obj/item/device/encryptionkey/heads/captain
	R.recalculateChannels()


/datum/outfit/ert/inquisitor/alert
	name = "ERT Religious Specialist - High Alert"

	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/restraints/legcuffs/bola/cult=1,\
		/obj/item/weapon/sharpener/cult=1,\
		/obj/item/weapon/nullrod/claymore/chainsaw_sword=1,\
		/obj/item/weapon/storage/book/bible=1,\
		/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater=1,\
		/obj/item/clothing/mask/gas/sechailer/swat=1,\
		/obj/item/weapon/gun/projectile/automatic/gyropistol=1,\
		/obj/item/ammo_box/magazine/m75=2,\
		/obj/item/weapon/melee/baton/loaded=1)

/datum/outfit/centcom_official
	name = "Centcom Official"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/device/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/weapon/gun/energy/gun
	l_pocket = /obj/item/weapon/pen
	back = /obj/item/weapon/storage/backpack/satchel_norm
	r_pocket = /obj/item/device/pda/heads
	l_hand = /obj/item/weapon/clipboard
	id = /obj/item/weapon/card/id

/datum/outfit/centcom_official/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/device/pda/heads/pda = H.r_store
	pda.owner = H.real_name
	pda.ownjob = "Centcom Official"
	pda.update_label()

	var/obj/item/weapon/card/id/W = H.wear_id
	W.icon_state = "centcom"
	W.access = get_centcom_access("Centcom Official")
	W.access += access_weapons
	W.assignment = "Centcom Official"
	W.registered_name = H.real_name
	W.update_label()
