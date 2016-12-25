/obj/item/weapon/hivelordstabilizer
	name = "stabilizing serum"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"
	desc = "Inject certain types of monster organs with this stabilizer to preserve their healing powers indefinitely."
	w_class = 1
	origin_tech = "biotech=3"

/obj/item/weapon/hivelordstabilizer/afterattack(obj/item/organ/M, mob/user)
	var/obj/item/organ/hivelord_core/C = M
	if(!istype(C, /obj/item/organ/hivelord_core))
		user << "<span class='warning'>The stabilizer only works on certain types of monster organs, generally regenerative in nature.</span>"
		return ..()
	C.preserved = 1
	feedback_add_details("hivelord_core", "[C.type]|stabilizer") // preserved
	user << "<span class='notice'>You inject the [M] with the stabilizer. It will no longer go inert.</span>"
	qdel(src)