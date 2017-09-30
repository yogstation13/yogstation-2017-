/obj/item/weapon/reagent_containers/food/snacks/meat
	var/subjectname = ""
	var/subjectjob = null

/obj/item/weapon/reagent_containers/food/snacks/meat/slab
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	dried_type = /obj/item/weapon/reagent_containers/food/snacks/sosjerky
	bitesize = 3
	list_reagents = list("nutriment" = 3)
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain
	slices_num = 3
	filling_color = "#FF0000"
	foodtype = MEAT | RAW

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/initialize_slice(obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/slice, reagents_per_slice)
	..()
	var/image/I = new(icon, "rawcutlet_coloration")
	I.color = filling_color
	slice.overlays += I
	slice.filling_color = filling_color
	slice.name = "raw [name] cutlet"
	slice.meat_type = name

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/S, cooking_efficiency)
	..()
	S.name = "[name] steak"

///////////////////////////////////// HUMAN MEATS //////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	name = " meat"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain/human
	foodtype = MEAT | RAW | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/initialize_slice(obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain/human/slice, reagents_per_slice)
	..()
	slice.subjectname = subjectname
	slice.subjectjob = subjectjob
	if(subjectname)
		slice.name = "raw [subjectname] cutlet"
	else if(subjectjob)
		slice.name = "raw [subjectjob] cutlet"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/meat/S, cooking_efficiency)
	..()
	S.subjectname = subjectname
	S.subjectjob = subjectjob
	if(subjectname)
		S.name = "[subjectname] meatsteak"
	else if(subjectjob)
		S.name = "[subjectjob] meatsteak"


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	name = " slime meat"
	icon_state = "slimemeat"
	desc = "Because jello wasn't offensive enough to vegans."
	list_reagents = list("nutriment" = 3, "slimejelly" = 3)
	filling_color = "#00FFFF"
	foodtype = MEAT | RAW | TOXIC

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem
	name = " meat-shaped rock"
	icon_state = "golemmeat"
	desc = "Edible rocks, welcome to the future."
	list_reagents = list("nutriment" = 3, "iron" = 3)
	filling_color = "#A9A9A9"
	foodtype = MEAT | RAW | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem/adamantine
	name = " blue meat-shaped rock"
	icon_state = "agolemmeat"
	desc = "From the slime pen to the rune to the kitchen, science."
	filling_color = "#66CDAA"
	foodtype = MEAT | RAW | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	name = " scaly meat"
	icon_state = "lizardmeat"
	desc = "The true purpose of all lizards."
	filling_color = "#6B8E23"
	foodtype = MEAT | RAW

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/plant
	name = " plant meat"
	icon_state = "plantmeat"
	desc = "All the joys of healthy eating with all the fun of cannibalism."
	filling_color = "#E9967A"
	foodtype = VEGETABLES

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/shadow
	name = " pitch-black meat"
	icon_state = "shadowmeat"
	desc = "Ow, the edge."
	filling_color = "#202020"
	foodtype = MEAT | RAW

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	icon_state = "flymeat"
	desc = "Nothing says tasty like maggot filled radioactive mutant flesh."
	list_reagents = list("nutriment" = 3, "uranium" = 3)
	foodtype = MEAT | RAW | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	name = " bone meat"
	icon_state = "skeletonmeat"
	desc = "There's a point where this needs to stop, and clearly we have passed it."
	filling_color = "#F0F0F0"
	slice_path = null  //can't slice a bone into cutlets
	foodtype = GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	name = " rotten meat"
	icon_state = "lizardmeat" //Close enough.
	desc = "Halfway to becoming fertilizer for your garden."
	filling_color = "#6B8E23"
	foodtype = RAW | MEAT | TOXIC






////////////////////////////////////// OTHER MEATS ////////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/synthmeat
	name = "synthmeat"
	desc = "A synthetic slab of meat."
	foodtype = RAW | MEAT //hurr durr chemicals we're harmed in the production of this meat thus its non-vegan.

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/meatproduct
	name = "meat product"
	desc = "A slab of station reclaimed and chemically processed meat product."
	foodtype = RAW | MEAT

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey
	name = "monkey meat"
	foodtype = RAW | MEAT

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi
	name = "corgi meat"
	desc = "Tastes like... well you know..."
	foodtype = RAW | MEAT | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/pug
	name = "pug meat"
	desc = "Tastes like... well you know..."
	foodtype = RAW | MEAT | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/killertomato
	name = "killer tomato meat"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	list_reagents = list("nutriment" = 2)
	filling_color = "#FF0000"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/killertomato
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/killertomato
	foodtype = VEGETABLES

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/bear
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	list_reagents = list("nutriment" = 12, "morphine" = 5, "vitamin" = 2)
	filling_color = "#FFB6C1"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/bear
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/bear
	foodtype = RAW | MEAT


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno
	name = "xeno meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	list_reagents = list("nutriment" = 3, "vitamin" = 1)
	bitesize = 4
	filling_color = "#32CD32"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/xeno
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/xeno
	foodtype = RAW | MEAT

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/spider
	name = "spider meat"
	desc = "A slab of spider meat."
	icon_state = "spidermeat"
	list_reagents = list("nutriment" = 3, "toxin" = 3, "vitamin" = 1)
	filling_color = "#7CFC00"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/spider
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/spider
	foodtype = RAW | MEAT | TOXIC


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/goliath
	name = "goliath meat"
	desc = "A slab of goliath meat. It's not very edible now, but it cooks great in lava."
	list_reagents = list("nutriment" = 3, "toxin" = 5)
	icon_state = "goliathmeat"
	foodtype = RAW | MEAT | TOXIC

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/goliath/burn()
	visible_message("[src] finishes cooking!")
	new /obj/item/weapon/reagent_containers/food/snacks/meat/steak/goliath/(loc)
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/meatwheat
	name = "meatwheat clump"
	desc = "This doesn't look like meat, but your standards aren't <i>that</i> high to begin with."
	list_reagents = list("nutriment" = 3, "vitamin" = 2, "blood" = 5)
	filling_color = rgb(150, 0, 0)
	icon_state = "meatwheat_clump"
	bitesize = 4
	foodtype = GRAIN

////////////////////////////////////// MEAT STEAKS ///////////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/meat/steak
	name = "steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatsteak"
	list_reagents = list("nutriment" = 5)
	bonus_reagents = list("nutriment" = 2, "vitamin" = 1)
	trash = /obj/item/trash/plate
	filling_color = "#B22222"
	foodtype = MEAT

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human
	foodtype = MEAT | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/killertomato
	name = "killer tomato steak"
	foodtype = VEGETABLES

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/bear
	name = "bear steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/xeno
	name = "xeno steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/spider
	name = "spider steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/goliath
	name = "goliath steak"
	desc = "A delicious, lava cooked steak."
	burn_state = LAVA_PROOF
	icon_state = "goliathsteak"
	trash = null
	foodtype = MEAT

//////////////////////////////// MEAT CUTLETS ///////////////////////////////////////////////////////

//Raw cutlets

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet
	name = "raw cutlet"
	desc = "A raw meat cutlet."
	icon_state = "rawcutlet"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/plain
	bitesize = 2
	list_reagents = list("nutriment" = 1)
	filling_color = "#B22222"
	var/meat_type = "meat"
	foodtype = MEAT | RAW

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/S, cooking_efficiency)
	..()
	S.name = "[meat_type] cutlet"


/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain/human
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/plain/human
	foodtype = MEAT | RAW | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain/human/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/S, cooking_efficiency)
	..()
	if(subjectname)
		S.name = "[subjectname] [initial(S.name)]"
	else if(subjectjob)
		S.name = "[subjectjob] [initial(S.name)]"

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/killertomato
	name = "raw killer tomato cutlet"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/killertomato
	foodtype = VEGETABLES

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/bear
	name = "raw bear cutlet"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/bear

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/xeno
	name = "raw xeno cutlet"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/xeno

/obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/spider
	name = "raw spider cutlet"
	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/spider


//Cooked cutlets

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet
	name = "cutlet"
	desc = "A cooked meat cutlet."
	icon_state = "cutlet"
	bitesize = 2
	list_reagents = list("nutriment" = 2)
	bonus_reagents = list("nutriment" = 1, "vitamin" = 1)
	filling_color = "#B22222"
	foodtype = MEAT

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/plain

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/plain/human
	foodtype = MEAT | GROSS

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/killertomato
	name = "killer tomato cutlet"
	foodtype = VEGETABLES

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/bear
	name = "bear cutlet"

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/xeno
	name = "xeno cutlet"

/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/spider
	name = "spider cutlet"
