/obj/item/module_holder/basic
	name = "basic module holder"
	desc = "A module holder that, when installed into an item, allows installation of modules. Very cleverly disguised as a game kit. This version has 1 slot and comes with a high capacity cell."
	module_limit = 1

/obj/item/module_holder/basic/New(obj/item/owner, obj_name)
	..()
	power_source = new /obj/item/weapon/stock_parts/cell/high(src)