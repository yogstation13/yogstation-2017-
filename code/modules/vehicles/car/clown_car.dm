/obj/vehicle/car/clown
	name = "clown car"
	desc = "How someone could even fit in there is beyond me."
	icon_state = "clowncar"
	vehicle_move_delay = 0.6
	health = 500 //stronk

	horn_sound = 'sound/items/AirHorn.ogg'

	ramming_sounds = list('sound/effects/clowncar_ram1.ogg', 'sound/effects/clowncar_ram2.ogg', 'sound/effects/clowncar_ram3.ogg') //Sounds for when you hit a person
	crash_sounds = list('sound/effects/clowncar_crash1.ogg', 'sound/effects/clowncar_crash2.ogg')  //Sounds for when you crash into a structure
	load_sounds = list('sound/effects/clowncar_load1.ogg', 'sound/effects/clowncar_load2.ogg') //Sounds for when you load mobs into your car

	ramming = TRUE
	can_load_mobs = TRUE
	keytype = /obj/item/device/assembly/bikehorn
