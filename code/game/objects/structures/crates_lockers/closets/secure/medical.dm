/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled to the brim with medical junk."
	icon_state = "med"
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/medical1/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/beaker/large/styptic(src)
	new /obj/item/weapon/reagent_containers/glass/beaker/large/silver_sulfadiazine(src)
	new /obj/item/weapon/reagent_containers/dropper(src)
	new /obj/item/weapon/reagent_containers/dropper(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/toxin(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/morphine(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/morphine(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/epinephrine(src)
	new /obj/item/weapon/reagent_containers/glass/beaker/large/charcoal(src)
	new /obj/item/weapon/storage/box/rxglasses(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/salglu_solution(src)

/obj/structure/closet/secure_closet/medical2
	name = "anesthetic closet"
	desc = "Used to knock people out."
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/medical2/New()
	..()
	for(var/i in 1 to 3)
		new /obj/item/weapon/tank/internals/anesthetic(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/mask/breath/medical(src)
	for(var/i in 1 to 2)
		new /obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_surgery)
	icon_state = "med_secure"

/obj/structure/closet/secure_closet/medical3/New()
	..()
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/weapon/defibrillator/loaded(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/weapon/gun/syringe(src)
	return

/obj/structure/closet/secure_closet/CMO
	name = "\proper chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/CMO/New()
	..()
	new /obj/item/clothing/neck/cloak/cmo(src)
	new /obj/item/weapon/storage/backpack/dufflebag/med(src)
	new /obj/item/clothing/suit/bio_suit/cmo(src)
	new /obj/item/clothing/head/bio_hood/cmo(src)
	new /obj/item/clothing/suit/toggle/labcoat/cmo(src)
	new /obj/item/clothing/under/rank/chief_medical_officer(src)
	new /obj/item/clothing/shoes/sneakers/brown	(src)
	new /obj/item/weapon/cartridge/cmo(src)
	new /obj/item/device/radio/headset/heads/cmo(src)
	new /obj/item/device/megaphone/command(src)
	new /obj/item/weapon/defibrillator/compact/loaded(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/device/assembly/flash/handheld(src)
	new /obj/item/weapon/reagent_containers/hypospray/CMO(src)
	new /obj/item/device/autoimplanter/cmo(src)
	new /obj/item/weapon/door_remote/chief_medical_officer(src)
	new /obj/item/weapon/storage/box/chemimp(src)

/obj/structure/closet/secure_closet/animal
	name = "animal control"
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/animal/New()
	..()
	new /obj/item/device/assembly/signaler(src)
	for(var/i in 1 to 3)
		new /obj/item/device/electropack(src)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_door = "chemical"

/obj/structure/closet/secure_closet/chemical/New()
	..()
	new /obj/item/weapon/storage/box/pillbottles(src)
	new /obj/item/weapon/storage/box/pillbottles(src)
	new /obj/item/weapon/reagent_containers/glass/beaker/sulphuric(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/facid(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/capsaicin(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/mutagen(src)

/obj/structure/closet/secure_closet/mmedical
	name = "mining medic's locker"
	req_access = list(access_medical)
	icon_state = "med_secure"

/obj/structure/closet/secure_closet/mmedical/New()
	..()
	new /obj/item/weapon/reagent_containers/hypospray/mixi(src)
	new /obj/item/weapon/reagent_containers/hypospray/derm(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	new /obj/item/weapon/defibrillator/loaded(src)
	new /obj/item/clothing/suit/toggle/labcoat/emt/explorer(src)
	new /obj/item/clothing/under/rank/miner/medic(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/weapon/cartridge/medical(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/weapon/storage/firstaid/toxin(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/weapon/pickaxe(src)
	new /obj/item/device/sensor_device(src)
	new /obj/item/weapon/storage/box/bodybags(src)
	new /obj/item/weapon/extinguisher/mini(src)
	new /obj/item/clothing/glasses/hud/health/optical(src)
	var/obj/item/key/K = new(src)
	K.name = "ATV key"
	K.desc = "It's a small grey key. Don't let those goddamn ashwalkers get it."

/obj/structure/closet/secure_closet/paramedic
	name = "paramedical closet"
	desc = "It's a secure storage unit for paramedical supplies."
	icon_state = "paramedic"
	req_access = list(access_paramedic)

/obj/structure/closet/secure_closet/paramedic/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/suit/toggle/labcoat/emt(src)
	new /obj/item/clothing/head/soft/emt(src)
	new /obj/item/weapon/defibrillator/loaded(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/device/gps/medical(src)