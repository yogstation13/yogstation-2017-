/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall
	name = "Invisible wall"
	desc = "The mime's performance transmutates into physical reality."
	school = "mime"
	panel = "Mime"
	summon_type = list(/obj/effect/forcefield/mime)
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>You form a wall in front of yourself.</span>"
	summon_lifespan = 300
	charge_max = 300
	clothes_req = 0
	range = 0
	cast_sound = null
	human_req = 1

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			usr << "<span class='notice'>You must dedicate yourself to silence first.</span>"
			return
		invocation = "<B>[usr.real_name]</B> looks as if a wall is in front of them."
	else
		invocation_type ="none"
	..()


/obj/effect/proc_holder/spell/targeted/mime/speak
	name = "Break your vow of silence"
	desc = "This is an awful idea."
	school = "mime"
	panel = "Mime"
	clothes_req = 0
	human_req = 1
	charge_max = 1000
	range = -1
	include_user = 1

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/mime/speak/Click()
	if(!usr)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
			var/input == alert(usr, "Are you sure you want to break your vow? It will probably end badly." "Confirm Vow Break", "Yes", "No")
			if(input == "Yes")
				usr.adjustStaminaLoss(99)
				usr.Stun(99999999)
				usr.Weaken(9999999)
				usr.adjust_eye_damage(50000)
				usr.nutrition = max(usr.nutrition - 6000, 0)
				usr.setEarDamage(50000,0)
				usr.dna.add_mutation(CLOWNMUT)
				usr.dna.add_mutation(EPILEPSY)
				for(var/obj/item/bodypart/B in usr.bodyparts)
   					if(B.body_zone != "head" && B.body_zone != "chest")
       						B.dismember()
				usr << "<span class='notice'>You are torn apart by the silentfather's holy wrath!</span>"
				return
				invocation = "<B>[usr.real_name]</B> has broken their vow of silence, and was punished for it!"
			else
				return

