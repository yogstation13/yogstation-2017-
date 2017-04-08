//Here are the procs used to modify status effects of a mob.
//The effects include: stunned, weakened, paralysis, sleeping, resting, jitteriness, dizziness, ear damage,
// eye damage, eye_blind, eye_blurry, druggy, BLIND disability, and NEARSIGHT disability.

/////////////////////////////////// STUNNED ////////////////////////////////////

/mob/living/carbon/alien/Stun(amount, updating = 1, ignore_canstun = 0)
<<<<<<< HEAD
	if((CANSTUN in status_flags) || ignore_canstun)
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		if(updating)
			update_canmove()
	else
		// add some movement delay
		move_delay_add = min(move_delay_add + round(amount / 2), 10) // a maximum delay of 10
=======
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10) //a maximum delay of 10

/mob/living/carbon/alien/SetStunned(amount, updating = 1, ignore_canstun = 0)
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10)

/mob/living/carbon/alien/AdjustStunned(amount, updating = 1, ignore_canstun = 0)
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10)
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc
