/datum/gang_item
	var/name
	var/item_path
	var/cost
	var/spawn_msg
	var/category
	var/id

/datum/gang_item/proc/purchase(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool, check_canbuy = TRUE)
	if(check_canbuy && !can_buy(user, gang, gangtool))
		return FALSE
	var/real_cost = get_cost(user, gang, gangtool)
	if(gang && real_cost)
		gang.message_gangtools("A [get_name_display(user, gang, gangtool)] was purchased by [user.real_name] for [real_cost] Influence.")
		log_game("A [id] was purchased by [key_name(user)] ([gang.name] Gang) for [real_cost] Influence.")
	gang.points -= real_cost
	spawn_item(user, gang, gangtool)
	return TRUE

/datum/gang_item/proc/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(item_path)
		var/obj/item/O = new item_path(user.loc)
		user.put_in_hands(O)
	if(spawn_msg)
		to_chat(user, spawn_msg)

/datum/gang_item/proc/can_buy(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return gang && (gang.points >= get_cost(user, gang, gangtool)) && can_see(user, gang, gangtool)

/datum/gang_item/proc/can_see(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return TRUE

/datum/gang_item/proc/get_cost(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return cost

/datum/gang_item/proc/get_cost_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return "([get_cost(user, gang, gangtool)] Influence)"

/datum/gang_item/proc/get_name_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return name

/datum/gang_item/proc/isboss(mob/living/carbon/user, datum/gang/gang)
	return user && gang && (user.mind == gang.bosses[1])

/datum/gang_item/proc/get_extra_info(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return

///////////////////
//FUNCTIONS
///////////////////

/datum/gang_item/function
	category = "Gangtool Functions:"
	cost = 0

/datum/gang_item/function/get_cost_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return ""


/datum/gang_item/function/gang_ping
	name = "Send Message to Gang"
	id = "gang_ping"

/datum/gang_item/function/gang_ping/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool)
		gangtool.ping_gang(user)


/datum/gang_item/function/recall
	name = "Recall Emergency Shuttle"
	id = "recall"

/datum/gang_item/function/recall/can_see(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return isboss(user, gang)

/datum/gang_item/function/recall/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool)
		gangtool.recall(user)


/datum/gang_item/function/outfit
	name = "Create Armored Gang Outfit"
	id = "outfit"

/datum/gang_item/function/outfit/can_buy(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return gangtool && (gangtool.outfits > 0) && ..()

/datum/gang_item/function/outfit/get_cost_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool && !gangtool.outfits)
		return "(Restocking)"
	return ..()

/datum/gang_item/function/outfit/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang && gang.gang_outfit(user, gangtool))
		to_chat(user, "<span class='notice'><b>Gang Outfits</b> can act as armor with moderate protection against ballistic and melee attacks. Every gangster wearing one will also help grow your gang's influence.</span>")
		if(gangtool)
			gangtool.outfits -= 1

///////////////////
//WEAPONS
///////////////////

/datum/gang_item/weapon
	category = "Purchase Weapons:"

/datum/gang_item/weapon/ammo

/datum/gang_item/weapon/ammo/get_cost_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	return "&nbsp;&#8627;" + ..() //this is pretty hacky but it looks nice on the popup

/datum/gang_item/weapon/switchblade
	name = "Switchblade"
	id = "switchblade"
	cost = 10
	item_path = /obj/item/weapon/switchblade

/datum/gang_item/weapon/pistol
	name = "10mm Pistol"
	id = "pistol"
	cost = 25
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol

/datum/gang_item/weapon/ammo/pistol_ammo
	name = "10mm Ammo"
	id = "pistol_ammo"
	cost = 10
	item_path = /obj/item/ammo_box/magazine/m10mm

/datum/gang_item/weapon/uzi
	name = "Uzi SMG"
	id = "uzi"
	cost = 45
	item_path = /obj/item/weapon/gun/projectile/automatic/mini_uzi
	id = "uzi"

/datum/gang_item/weapon/ammo/uzi_ammo
	name = "Uzi Ammo"
	id = "uzi_ammo"
	cost = 15
	item_path = /obj/item/ammo_box/magazine/uzim9mm

/datum/gang_item/weapon/tommygun
	name = "Thompson SMG"
	id = "tommygun"
	cost = 90
	item_path = /obj/item/weapon/gun/projectile/automatic/tommygun

/datum/gang_item/weapon/ammo/tommygun_ammo
	name = "Thompson Ammo"
	id = "tommygun_ammo"
	cost = 45
	item_path = /obj/item/ammo_box/magazine/tommygunm45

//SLEEPING CARP

/datum/gang_item/weapon/bostaff
	name = "Bo Staff"
	id = "bostaff"
	cost = 10
	item_path = /obj/item/weapon/twohanded/bostaff

/datum/gang_item/weapon/sleeping_carp_scroll
	name = "Sleeping Carp Scroll (one-use)"
	id = "sleeping_carp_scroll"
	cost = 25
	item_path = /obj/item/weapon/sleeping_carp_scroll
	spawn_msg = "<span class='notice'>Anyone who reads the <b>sleeping carp scroll</b> will learn secrets of the sleeping carp martial arts style.</span>"

/datum/gang_item/weapon/throwing_weapons
	name = "Throwing Weapons Box"
	id = "throwing_weapons"
	cost = 55
	item_path = /obj/item/weapon/storage/box/syndie_kit/throwing_weapons

///////////////////
//EQUIPMENT
///////////////////

/datum/gang_item/equipment
	category = "Purchase Equipment:"


/datum/gang_item/equipment/spraycan
	name = "Territory Spraycan"
	id = "spraycan"
	cost = 3
	item_path = /obj/item/toy/crayon/spraycan/gang

/datum/gang_item/equipment/necklace
	name = "Gold Necklace"
	id = "necklace"
	cost = 1
	item_path = /obj/item/clothing/tie/dope_necklace

/datum/gang_item/equipment/c4
	name = "C4 Explosive"
	id = "c4"
	cost = 5
	item_path = /obj/item/weapon/c4

/datum/gang_item/equipment/implant_breaker
	name = "Implant Breaker"
	id = "implant_breaker"
	cost = 15
	item_path = /obj/item/weapon/implanter/gang
	spawn_msg = "<span class='notice'>The <b>implant breaker</b> is a single-use device that destroys all implants within the target before trying to recruit them to your gang. Also works on enemy gangsters.</span>"

// APRIL FOOLS START
/datum/gang_item/equipment/banana
	name = "Banana"
	id = "banana"
	cost = 15
	item_path = /obj/item/weapon/reagent_containers/food/snacks/grown/banana
	spawn_msg = "<span class='notice'>Honk!</span>"

/datum/gang_item/equipment/clown_mask
	name = "Clown Mask"
	id = "clownmask"
	cost = 5
	item_path = /obj/item/clothing/mask/gas/clown_hat
	spawn_msg = "<span class='notice'>You're in the family now, son!</span>"

/datum/gang_item/equipment/golden_airhorn
	name = "Golden Airhorn"
	id = "goldenairhorn"
	cost = 10
	item_path = /obj/item/device/assembly/bikehorn/golden
	spawn_msg = "<span class='notice'>Let's get this party STARTED!</span>"

/datum/gang_item/weapon/bananium_esword
	name = "Bananum Esword"
	id = "b_esowrd"
	cost = 30
	item_path = /obj/item/weapon/melee/energy/sword/bananium
	spawn_msg = "<span class='notice'>Ooooh! You are now one with the HONK!</span>"

/datum/gang_item/weapon/bananium_eshield
	name = "Bananum Eshield"
	id = "b_eshield"
	cost = 60
	item_path = /obj/item/weapon/shield/energy/bananium
	spawn_msg = "<span class='notice'>Throw it and it comes back!</span>"

/datum/gang_item/weapon/tearstache
	name = "Tearstache Grenade"
	id = "tearstache"
	cost = 10
	item_path = /obj/item/weapon/grenade/chem_grenade/teargas/moustache

/datum/gang_item/weapon/clownbug
	name = "Clownbug Delivery"
	id = "clownbugs"
	cost = 30
	item_path = /obj/item/weapon/grenade/spawnergrenade/clownbugs/weak

/datum/gang_item/weapon/dark_honk
	name = "Dark H.O.N.K.E.R."
	id = "dark_honk"
	cost = 200
	item_path = /obj/mecha/combat/honker/dark/loaded/aprilfools
	spawn_msg = "<span class='notice'>The rest is up to you! Honk.</span>"


// mimery

/datum/gang_item/equipment/bottleofnothing
	name = "Bottle of Nothing"
	id = "bottleofnothing"
	cost = 10
	item_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing
	spawn_msg = "<span class='notice'>...</span>"

/datum/gang_item/equipment/mimemask
	name = "Mime Mask"
	id = "mime_mask"
	cost = 5
	item_path = /obj/item/clothing/mask/gas/mime
	spawn_msg = "<span class='notice'>...</span>"

/datum/gang_item/equipment/mimearts
	name = "Mimery"
	id = "mimerybook"
	cost = 10
	item_path = /obj/item/weapon/spellbook/oneuse/mime
	spawn_msg = "<span class='notice'>...</span>"

/datum/gang_item/equipment/mimewall
	name = "Mime Wall"
	id = "mimerywall"
	cost = 10
	item_path = /obj/item/weapon/spellbook/oneuse/mime_wall
	spawn_msg = "<span class='notice'>...Make sure you've read the book of mimery before approaching this.</span>"

/datum/gang_item/equipment/mutetoxin
	name = "Bottle of Mutetoxin"
	id = "mutetoxin"
	cost = 20
	item_path = /obj/item/weapon/reagent_containers/glass/bottle/mutetoxin
	spawn_msg = "<span class='notice'>...!</span>"

/datum/gang_item/equipment/invisibletouch
	name = "Legendary Invisible Touch"
	id = "invisibletouch"
	cost = 50
	item_path = /obj/item/weapon/spellbook/oneuse/invisible_touch
	spawn_msg = "<span class='notice'>This ability has no limits.</span>"

/datum/gang_item/equipment/reactivestealth
	name = "Reactive Stealth Armor"
	id = "reactivestealth"
	cost = 30
	item_path = /obj/item/clothing/suit/armor/reactive/stealth
	spawn_msg = "<span class='notice'>...</span>"

/datum/gang_item/weapon/reticence
	name = "Reticence"
	id = "reticence_mech"
	cost = 200
	item_path = /obj/mecha/combat/reticence/loaded
	spawn_msg = "<span class='notice'>... The rest is up to you ...</span>"

// APROIL FOOLS END

/datum/gang_item/equipment/implant_breaker/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(item_path)
		var/obj/item/O = new item_path(user.loc, gang) //we need to override this whole proc for this one argument
		user.put_in_hands(O)
	if(spawn_msg)
		to_chat(user, spawn_msg)

/datum/gang_item/equipment/pen
	name = "Recruitment Pen"
	id = "pen"
	cost = 50
	item_path = /obj/item/weapon/pen/gang
	spawn_msg = "<span class='notice'>More <b>recruitment pens</b> will allow you to recruit gangsters faster. Only gang leaders can recruit with pens.</span>"

/datum/gang_item/equipment/pen/purchase(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(..())
		gangtool.free_pen = FALSE
		return TRUE
	return FALSE

/datum/gang_item/equipment/pen/get_cost(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool && gangtool.free_pen)
		return 0
	return ..()

/datum/gang_item/equipment/pen/get_cost_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool && gangtool.free_pen)
		return "(GET ONE FREE)"
	return ..()


/datum/gang_item/equipment/gangtool
	id = "gangtool"
	cost = 10

/datum/gang_item/equipment/gangtool/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	var/item_type
	if(gang && isboss(user, gang))
		item_type = /obj/item/device/gangtool/spare/lt
		if(gang.bosses.len < 3)
			to_chat(user, "<span class='notice'><b>Gangtools</b> allow you to promote a gangster to be your Lieutenant, enabling them to recruit and purchase items like you. Simply have them register the gangtool. You may promote up to [3-gang.bosses.len] more Lieutenants</span>")
	else
		item_type = /obj/item/device/gangtool/spare
	var/obj/item/device/gangtool/spare/tool = new item_type(user.loc)
	user.put_in_hands(tool)

/datum/gang_item/equipment/gangtool/get_name_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang && isboss(user, gang) && (gang.bosses.len < 3))
		return "Promote a Gangster"
	return "Spare Gangtool"


/datum/gang_item/equipment/dominator
	name = "Station Dominator"
	id = "dominator"
	cost = 30
	item_path = /obj/machinery/dominator
	spawn_msg = "<span class='notice'>The <b>dominator</b> will secure your gang's dominance over the station. Turn it on when you are ready to defend it.</span>"

/datum/gang_item/equipment/dominator/can_buy(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return FALSE
	return ..()

/datum/gang_item/equipment/dominator/get_name_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return ..()
	return "<b>[..()]</b>"

/datum/gang_item/equipment/dominator/get_cost_display(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return "(Out of stock)"
	return ..()

/datum/gang_item/equipment/dominator/get_extra_info(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang)
		return "(Estimated Takeover Time: [round(get_domination_time(gang)/60,0.1)] minutes)"

/datum/gang_item/equipment/dominator/purchase(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	var/area/usrarea = get_area(user.loc)
	var/usrturf = get_turf(user.loc)
	if(initial(usrarea.name) == "Space" || istype(usrturf,/turf/open/space) || user.z != 1)
		to_chat(user, "<span class='warning'>You can only use this on the station!</span>")
		return FALSE

	for(var/obj/obj in usrturf)
		if(obj.density)
			to_chat(user, "<span class='warning'>There's not enough room here!</span>")
			return FALSE

	if(!(usrarea.type in gang.territory|gang.territory_new))
		to_chat(user, "<span class='warning'>The <b>dominator</b> can be spawned only on territory controlled by your gang!</span>")
		return FALSE
	return ..()

/datum/gang_item/equipment/dominator/spawn_item(mob/living/carbon/user, datum/gang/gang, obj/item/device/gangtool/gangtool)
	new item_path(user.loc)
