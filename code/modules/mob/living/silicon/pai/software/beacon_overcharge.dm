/datum/pai/software/beacon_overcharge
	name = "LDT Lumix 'Beacon' Overcharge Uninhibitor"
	description = {"Allows temporary overclocking of holographic core emitters to produce near-blinding levels of illumination.
					<b>WARNING: May cause irreversible damage to card unit.</b>"}
	category = "Blackware"
	sid = "beaconOC"
	ram = 25

/datum/pai/software/beacon_overcharge/action_use(mob/living/silicon/pai/user, var/args)
	if (args["toggle"] && (user.loc != user.card))
		toggleOC(user)

/datum/pai/software/beacon_overcharge/action_menu(mob/living/silicon/pai/user)
	var/dat = ""
	dat += {"
		<h3>Lumix 'Beacon' Overcharge Suite</h3>
		When activated, holographic core emitters will be erratically overclocked to a maximum of 700% of normal operating efficiency.<br>
		This will massively tax internal containment fields and may result in permanent damage to the card unit.<br><br>

		<b>WARNING:</b> There have been reports of this software causing catastrophic emitter failure. Use only in emergencies.<br><br>
	"}

	if (user.loc != user.card)
		dat += "<a href='byond://?src=\ref[user];software=[sid];toggle=1'>[user.emitter_OD ? "Enabled" : "Disabled"]</a>"

	if (user.emitter_OD)
		dat += "<br><br><b>Emitters currently overloaded by [user.luminosity * 100]%</b>"

	return dat

/datum/pai/software/beacon_overcharge/proc/toggleOC(mob/living/silicon/pai/user)
	var/turf/T = get_turf(user.loc)
	if (!user.emitter_OD)
		//toggle the overcharge on. the ramping happens in the life tick
		user.emitter_OD = 1
		user.set_light(2) //add some luminosity straight away for obvious benefit
		T.visible_message("<span class='notice'>A blinding pulse of light emanates briefly from within [user]'s holographic core, slowly fading until its field is nearly twice as bright as before.</span>")
	else
		user.emitter_OD = 0
		T.visible_message("<span class='notice'>Winking down abruptly to a dull ebb, [user]'s holographic form becomes almost spectral for a moment, nearly flickering out of existence entirely.</span>")
		//take damage based on max luminosity reached
		take_overload_damage(user)


/datum/pai/software/beacon_overcharge/proc/take_overload_damage(mob/living/silicon/pai/user)
	//check for the really big fat unlucky insta-death proc
	if (prob(3))
		//oooooh shit you're fucked
		user.emitter_OD = 1 //just to be sure
		user.death(0)
	else
		//just take nominal damage based on total luminosity
		if (user.luminosity > 1) //stops people from spam enabling the software to kill themselves noisily
			var/turf/T = get_turf(user.loc)
			user.adjustFireLoss(rand(6,18) * user.luminosity + 1)
			user.close_up(1)
			T.visible_message("<span class='danger'>Smoke rises from within the interior [user]'s of card, its casing hissing loudly.</span>")
			user.emitter_OD = 0

