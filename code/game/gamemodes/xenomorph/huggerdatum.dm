// datum predetermines the outcome of the xenomorph and their colony.
// colony suffix is carried from a queen to an egg, and from that egg to the hugger, and from that hugger to the xeno.

var/list/colony_database = list()

/datum/huggerdatum
	var/name = null
	var/mob/living/carbon/owner = null
	var/colony_suffix
	var/species = null
	var/changetraits = FALSE
	var/list/traits = list("name" = null, "desc" = null, "see_in_the_dark" = null, "heat_protection" = null)

/datum/huggerdatum/proc/assemble(var/suffix)
	if(suffix)
		colony_suffix = suffix

/datum/huggerdatum/default/New(var/mob/living/carbon/alien/origin, var/spec)
	name = "[origin.name]"
	owner = origin

	if(spec)
		if(spec != "human")
			choseTraits(spec)

/datum/huggerdatum/proc/choseTraits(var/datum/species/S)
	if(!S)
		return

	var/randomdigit = pick(1,1250)

	switch(S.id)

		if("lizard")
			traits["name"] = "odd smelling xenomorph ([randomdigit])"
			traits["desc"] = "A pecuilar xenomorphic beast, which appears to have less than smooth skin. Along the skin of it's flesh are imprinted scales symbolizing a reptilian origin."
			traits["heat_protection"] = 0.8
			changetraits = TRUE

		if("pred")
			traits["name"] = "PredXenomorph ([randomdigit])"
			traits["desc"] = "A disturbing fusion between two evolutionary abstract species that should have never interacted. There are significant signs of birth defect, such as splitting of the jaw, awkward stubby tail, and how the xenomorphic lifeform has managed to grow hair."
			traits["heat_protection"] = 0.2
			changetraits = TRUE

/datum/huggerdatum/queen/assemble(var/origin)
	name = "queen"
	owner = origin
	colony_suffix += pick("4N", "PB", "3Y", "A4", "0X", "JD")
	colony_suffix += pick("4N", "PB", "3Y", "A4", "0X", "JD")
	colony_suffix += pick("4N", "PB", "3Y", "A4", "0X", "JD")
	colony_suffix += pick("4N", "PB", "3Y", "A4", "0X", "JD")
	colony_suffix += pick("4N", "PB", "3Y", "A4", "0X", "JD")
	for(var/a in colony_database)
		if(a == colony_suffix)
			colony_suffix = pick("C4X", "PFX", "3AX", "ARX", "XBX", "X0A")
	colony_database["[owner]"] += colony_suffix