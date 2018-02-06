/var/global/list/mutations_list = list()

/datum/mutation/New()
	mutations_list[name] = src

/datum/mutation/
	name = "Mutation"
	desc = "A broken mutation brought into the world by shitty coding"
	var/potency = 0  //from 1-100
	var/cooldown_coeff = 1 //2 being twice as much etc
	var/gain_indication = "You feel swole"
	var/lose_indication = "You feel lame"
	var/mob/living/carbon/subject
	var/genetic_stability = 0 //If 20, the new genetic stability would be 120. You want to make this negative for powers
	var/datum/dna/DNA

/datum/mutation/proc/on_acquiring(mob/living/carbon/C,silent = FALSE)
	to_chat

/datum/mutation/proc/on_losing(mob/living/carbon/C, silent = FALSE)


/datum/mutation/proc/installMutation(mob/living/carbon/C)
	if(!C || !C.dna)
		return
	subject = C
	DNA = subject.dna
	if(type in DNA.mutations)
		var/datum/mutation/KILL = mutations[type]
		KILL.on_losing(C,TRUE)
		qdel(KILL)
	DNA.mutations[src.type] = src
	on_acquiring(C)

/datum/mutation/proc/removeMutation(mob/living/carbon/C, silent = FALSE) //Do we want to alert our dude he just got it removed?
	on_losing(C)
	if(C && C.dna && (src.type in C.dna.mutations))
		DNA.mutations.Remove(src)
