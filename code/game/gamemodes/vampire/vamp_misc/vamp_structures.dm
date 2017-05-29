#define VAMP_COFFIN_CD 20 // heal and regene every 2 ticks

/obj/structure/closet/coffin/vampiric
	desc = "There's something about this coffin that doesn't feel right..."
	burn_state = null
	anchored = TRUE
	var/datum/vampire/vdatum
	var/delay

/obj/structure/closet/coffin/vampiric/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/closet/coffin/vampiric/process()
	if(vdatum)
		if(vdatum.vampire)
			if(vdatum.vampire in contents)
				if(world.time > delay)
					delay = world.time + VAMP_COFFIN_CD
					heal_vampire()
					regenerate_blood()
		if(qdeleted(src))
			vdatum.coffin = null
			vdatum = null
			STOP_PROCESSING(SSobj, src)
	//	else
	//		STOP_PROCESSING(SSobj, src)
			desc = "It doesn't look right... It's battered down and weakened."

/obj/structure/closet/coffin/vampiric/proc/heal_vampire()
	if(!vdatum || !vdatum.vampire)
		return

	vdatum.vampire.adjustBruteLoss(-1, 0)
	vdatum.vampire.adjustOxyLoss(-1, 0)
	vdatum.vampire.adjustFireLoss(-1, 0)

	if(vdatum.thousand_unlocked)
		vdatum.vampire.regenerate_limbs(1)

/obj/structure/closet/coffin/vampiric/proc/regenerate_blood()
	var/limit = vdatum.get_limit()

	if(vdatum.bloodcount < limit)
		vdatum.bloodcount += 1