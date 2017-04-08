/mob/living/silicon/examine(mob/user) //Displays a silicon's laws to ghosts
	if(laws && isobserver(user))
<<<<<<< HEAD
		to_chat(user, "<b>[src] has the following laws:</b>")
		laws.show_laws(user)
=======
		user << "<b>[src] has the following laws:</b>"
		laws.show_laws(user)
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee
