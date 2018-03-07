
/mob
	var/bloody_hands = 0

/obj/item/clothing/gloves
	var/transfer_blood = 0


/obj/item/weapon/mop/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	flags = OPENCONTAINER | NOBLUDGEON
	force = 0
	throwforce = 0
	attack_verb = list("slapped", "wiped")
	burn_state = FLAMMABLE
	mopspeed = 60
	janiLocate = FALSE
	var/volume = 5

/obj/item/weapon/mop/rag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] ties the [src.name] around their head and groans! It looks like--</span>")
	user.say("MY BRAIN HURTS!!")
	return (OXYLOSS)

/obj/item/weapon/mop/rag/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(iscarbon(A) && A.reagents && reagents.total_volume)
		var/mob/living/carbon/C = A
		if(user.a_intent == "harm" && !C.is_mouth_covered())
			reagents.trans_to(C, reagents.total_volume)
			reagents.reaction(C, INGEST)
			C.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='userdanger'>[user] has smothered you with \the [src]!</span>", "<span class='italics'>You hear some struggling and muffled cries of surprise.</span>")
			var/reagentlist = pretty_string_from_reagent_list(A.reagents)
			log_game("[key_name(user)] smothered [key_name(A)] with a damp rag containing [reagentlist]")
			log_attack("[key_name(user)] smothered [key_name(A)] with a damp rag containing [reagentlist]")
			return
	return ..()
