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
	desc = ""
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
		M.gib()
		invocation_emote_self = "<span class='notice'>The silentfather's wrath gibs you on the spot!</span>"
		invocation = "<B>[usr.real_name]</B>is torn apart by the silentfather's wrath!"
