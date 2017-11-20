// simple is_type and similar inline helpers

#define islist(L) (istype(L,/list))

#define in_range(source, user) (get_dist(source, user) <= 1)

#define ismodholder(O) (istype(O, /obj/item/module_holder))

#define ismodule(O) (istype(O, /obj/item/module))


//Turfs
#define isopenturf(A) (istype(A, /turf/open))

#define isspaceturf(A) (istype(A, /turf/open/space))

#define isfloorturf(A) (istype(A, /turf/open/floor))

#define isclosedturf(A) (istype(A, /turf/closed))

#define iswallturf(A) (istype(A, /turf/closed/wall))

#define ismineralturf(A) (istype(A, /turf/closed/mineral))


#define islavaturf(A) (istype(A, /turf/open/floor/plating/lava))
#define isminingturf(A) (istype(A, /turf/open/floor/plating/asteroid))
#define ischasm(A) (istype(A, /turf/open/chasm))

// MOB HELPERS

#define ishuman(A) (istype(A, /mob/living/carbon/human))

// Human sub-species
#define isabductor(A) (is_species(A, /datum/species/abductor))
#define isgolem(A) (is_species(A, /datum/species/golem))
#define islizard(A) (is_species(A, /datum/species/lizard))
#define isplasmaman(A) (is_species(A, /datum/species/plasmaman))
#define ispodperson(A) (is_species(A, /datum/species/podperson))
#define isflyperson(A) (is_species(A, /datum/species/fly))
#define iszombie(A) (is_species(A, /datum/species/zombie))
#define ishumanbasic(A) (is_species(A, /datum/species/human))
#define isabomination(A) (is_species(A, /datum/species/abomination))
#define isshadow(A) (is_species(A, /datum/species/shadow))
#define isshadowling(A) (is_species(A, /datum/species/shadow/ling))
#define isashwalker(A) (is_species(A, /datum/species/lizard/ashwalker))
#define ischiefwalker(A) (is_species(A, /datum/species/lizard/ashwalker/chieftain))
#define iskrampus(A) (is_species(A, /datum/species/demon))
#define ispod(A) (is_species(A, /datum/species/plant/pod))
#define isphytosian(A) (is_species(A, /datum/species/plant))
#define isplant(A) (PLANT in A.dna.species.specflags)

#define ismonkey(A) (istype(A, /mob/living/carbon/monkey))

#define isbrain(A) (istype(A, /mob/living/carbon/brain))

#define isalien(A) (istype(A, /mob/living/carbon/alien))

#define islarva(A) (istype(A, /mob/living/carbon/alien/larva))

#define isalienadult(A) (istype(A, /mob/living/carbon/alien/humanoid))

#define isalienhunter(A) (istype(A, /mob/living/carbon/alien/humanoid/hunter))

#define isaliensentinel(A) (istype(A, /mob/living/carbon/alien/humanoid/sentinel))

#define isalienroyal(A) (istype(A, /mob/living/carbon/alien/humanoid/royal))

#define isalienqueen(A) (istype(A, /mob/living/carbon/alien/humanoid/royal/queen))

#define issimpleanimal(A) (istype(A, /mob/living/simple_animal))

#define isslime(A) (istype(A, /mob/living/simple_animal/slime))

#define isrobot(A) (istype(A, /mob/living/silicon/robot))

#define isanimal(A) (istype(A, /mob/living/simple_animal))

#define iscorgi(A) (istype(A, /mob/living/simple_animal/pet/dog/corgi))

#define iscrab(A) (istype(A, /mob/living/simple_animal/crab))

#define iscat(A) (istype(A, /mob/living/simple_animal/pet/cat))

#define ismouse(A) (istype(A, /mob/living/simple_animal/mouse))

#define isconstruct(A) (istype(A, /mob/living/simple_animal/hostile/construct))

#define ismegafauna(A) (istype(A, /mob/living/simple_animal/hostile/megafauna))

#define isclockmob(A) (istype(A, /mob/living/simple_animal/hostile/clockwork))

#define isbear(A) (istype(A, /mob/living/simple_animal/hostile/bear))

#define iscarp(A) (istype(A, /mob/living/simple_animal/hostile/carp))

#define isclown(A) (istype(A, /mob/living/simple_animal/hostile/retaliate/clown))

#define isAI(A) (istype(A, /mob/living/silicon/ai))

#define ispAI(A) (istype(A, /mob/living/silicon/pai))

#define iscarbon(A) (istype(A, /mob/living/carbon))

#define issilicon(A) (istype(A, /mob/living/silicon))

#define isaiorborg(A) (istype(A, /mob/living/silicon/ai) || istype(A, /mob/living/silicon/robot))

#define isliving(A) (istype(A, /mob/living))

#define isobserver(A) (istype(A, /mob/dead/observer))

#define isnewplayer(A) (istype(A, /mob/new_player))

#define isovermind(A) (istype(A, /mob/camera/blob))

#define isdrone(A) (istype(A, /mob/living/simple_animal/drone))

#define isswarmer(A) (istype(A, /mob/living/simple_animal/hostile/swarmer))

#define isguardian(A) (istype(A, /mob/living/simple_animal/hostile/guardian))

#define islimb(A) (istype(A, /obj/item/bodypart))

#define isbot(A) (istype(A, /mob/living/simple_animal/bot))

#define ismovableatom(A) (istype(A, /atom/movable))

#define isobj(A) istype(A, /obj) //override the byond proc because it returns true on children of /atom/movable that aren't objs

#define isitem(A) istype(A, /obj/item)

#define ispredator(A) (istype(A, /mob/living/carbon/human/predator))

#define isborer(A) (istype(A, /mob/living/simple_animal/borer))

#define iscaptive(A) (istype(A, /mob/living/captive_brain))

// ASSEMBLY HELPERS

#define isassembly(O) (istype(O, /obj/item/device/assembly))

#define isigniter(O) (istype(O, /obj/item/device/assembly/igniter))

#define isinfared(O) (istype(O, /obj/item/device/assembly/infra))

#define isprox(O) (istype(O, /obj/item/device/assembly/prox_sensor))

#define issignaler(O) (istype(O, /obj/item/device/assembly/signaler))

#define istimer(O) (istype(O, /obj/item/device/assembly/timer))

#define is_cleanable(A) (istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/rune))
