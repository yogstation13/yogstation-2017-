/obj/item/anthrax_packet
	name = "hotsauce pack"
	desc = "A small plastic pack with condiments to put on your food."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "condi_hotsauce"
	w_class = 1

/obj/item/anthrax_packet/proc/apply(obj/item/I, mob/living/carbon/human/H)
	if(!istype(I) || !istype(H))
		return
	to_chat(H, "<span class='notice'>You apply the packet to [I].</span>")
	H.attack_log += "\[[time_stamp()]\] <font color='red'>Has applied anthrax to <a href='?_src_=vars;Vars=\ref[I]'>[I]</a>.</font>"
	log_attack("[H]/[H.ckey] has applied anthrax to [I].")
	if(!H.gloves || istype(H.gloves, /obj/item/clothing/gloves/fingerless))
		H.ForceContractDisease(new /datum/disease/anthrax)
		H.attack_log += "\[[time_stamp()]\] <font color='red'>Has infected themselves with anthrax while applying it.</font>"
		log_attack("[H]/[H.ckey] has infected themselves with anthrax while applying it.")
	I.anthrax_laced = TRUE
	qdel(src)