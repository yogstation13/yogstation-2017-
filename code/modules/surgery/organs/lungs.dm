/obj/item/organ/lungs
	name = "lungs"
	icon_state = "lungs"
	zone = "chest"
	slot = "lungs"
	gender = PLURAL
	w_class = 3

/obj/item/organ/lungs/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("salbutamol", 5)
	return S