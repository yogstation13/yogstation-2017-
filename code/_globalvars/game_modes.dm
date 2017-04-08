<<<<<<< HEAD
var/master_mode = "traitor"//"extended"
var/secret_force_mode = "secret" // if this is anything but "secret", the secret rotation will forceably choose this mode
var/force_traitor_ai = 0
=======
GLOBAL_VAR_INIT(master_mode, "traitor") //"extended"
GLOBAL_VAR_INIT(secret_force_mode, "secret") // if this is anything but "secret", the secret rotation will forceably choose this mode
>>>>>>> c5999bcdb3efe2d0133e297717bcbc50cfa022bc

GLOBAL_VAR_INIT(wavesecret, 0) // meteor mode, delays wave progression, terrible name
GLOBAL_DATUM(start_state, /datum/station_state) // Used in round-end report
