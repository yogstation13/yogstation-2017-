//Remember kids. The scope is stuck inside of the biomask.

/obj/screen/scope
	name = "scope control"
	var/toggle

/obj/screen/scope/Click()
	var/mob/living/carbon/human/H = usr
	var/obj/item/clothing/head/helmet/space/hardsuit/predator/bio = locate() in H.contents
	if(!bio)
		return

	var/obj/item/scope/security/S = bio.tightenedscope
	if(S)
		if(!check_next_move(S))
			return

		S.zoom(H, FALSE)
		H << "<span class='notice'>You [name] your scope range.</span>"
		var/next_zoom_amt = 1

		if(istype(S, /obj/item/scope/security/yautija/))
			var/obj/item/scope/security/yautija/Y = S
			next_zoom_amt *= Y.flex

		if(toggle == "increase")
			S.zoom_amt += next_zoom_amt
		else
			S.zoom_amt -= next_zoom_amt

		S.zoom(H)

/obj/screen/scope/proc/check_next_move(obj/item/scope/security/S)
	return

/obj/screen/scope/increase
	name = "increase"
	icon = 'icons/mob/actions.dmi'
	icon_state = "scope-up"
	screen_loc = "1:100,5:0"
	toggle = "increase"
	invisibility = INVISIBILITY_ABSTRACT

/obj/screen/scope/increase/check_next_move(obj/item/scope/security/S)
	if(S.zoom_amt + 1 > S.max_zoom)
		return 0
	return 1

/obj/screen/scope/decrease
	name = "decrease"
	icon = 'icons/mob/actions.dmi'
	icon_state = "scope-down"
	screen_loc = "1:100,5:50"
	toggle = "decrease"
	invisibility = INVISIBILITY_ABSTRACT

/obj/screen/scope/decrease/check_next_move(obj/item/scope/security/S)
	if(S.zoom_amt - 1 <= 0)
		return 0
	return 1

/obj/item/scope/security/yautija
	name = "yautija scope"
	desc = "Incredibly enhanced scope."
	max_zoom = 14
	var/flex = 1

/obj/item/scope/security/yautija/zoom(mob/living/user, forced_zoom)
	..()
	if(!user)
		return
	if(zoomed)
		user.overlay_fullscreen("thermal", /obj/screen/fullscreen/thermal)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.hud_used.increase_scopedisplay.invisibility = 0
			C.hud_used.decrease_scopedisplay.invisibility = 0
	else
		user.clear_fullscreen("thermal")
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.hud_used.increase_scopedisplay.invisibility = INVISIBILITY_ABSTRACT
			C.hud_used.decrease_scopedisplay.invisibility = INVISIBILITY_ABSTRACT

/obj/item/scope/security/yautija/AltClick()
	if(Adjacent(usr))
		var/newtoggle = input("Enter scope increase/decrease range:","Num") as num
		if(newtoggle)
			if(newtoggle > 28)
				usr << "<span class ='warning'>The max range is 28.</span>"
				return
			flex = newtoggle