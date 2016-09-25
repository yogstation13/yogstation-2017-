/*
//////////////////////////////////////

Stimulant //gotta go fast

	Noticable.
	Lowers resistance significantly.
	Decreases stage speed moderately..
	Decreases transmittablity tremendously.
	Moderate Level.

Bonus
	The body generates Ephedrine.

//////////////////////////////////////
*/

/datum/symptom/stimulant

	name = "Artificial Stimulant"
	stealth = -1
	resistance = -3
	stage_speed = -2
	transmittable = -4
	level = 3

/datum/symptom/stimulant/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 10))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(5)
				if(!M.stunned && !M.weakened)
					if (M.reagents.get_reagent_amount("lesserephedrine") < 10)
						M.reagents.add_reagent("lesserephedrine", 10)
			else
				if(prob(SYMPTOM_ACTIVATION_PROB * 5))
					M << "<span class='notice'>[pick("You feel restless.", "You feel like running laps around the station.", "You feel like you could dodge a bullet", "You feel like taking a run outside the skirts of the station.", "You feel like time is moving slowly every time you take a step.")]</span>"
	return