/mob/living/silicon/pai/death(gibbed)
	if(stat == DEAD)
		return
	unpair(1)

	if (!did_suicide)
		if(canmove || resting)
			var/turf/T = get_turf(loc)
			for (var/mob/M in viewers(T))
				M.show_message("\red [src]'s holographic emitters lose power and coherence immediately, collapsing into the charred remains of what was once a personal AI.", 3, "\red A loud beeping followed by the tinkling clatter of glass and metal suddenly fills the air.", 2)
			name = "pAI debris"
			desc = "The unfortunate remains of some poor personal AI device."
			icon = 'icons/mob/robots.dmi'
			icon_state = "gib6"
		else
			card.overlays.Cut()
			card.overlays += "pai-off"
	else
		//pai died via suicide so we handle things a bit differently
		var/turf/T = get_turf(src.loc)
		T.visible_message("<span class='notice'>[src]'s screen goes completely black for a moment, before flashing a message across its screen, \"Personality core has returned to the network. Please register a new personality in order to continue use.\"</span>",
		"<span class='notice'>[src] emits a light-hearted shutdown ditty before falling perilously silent..</span>")
		card.overlays.Cut()
		card.overlays += "pai-off"


	canmove = 0
	did_suicide = 0
	stat = DEAD

	update_sight()
	clear_fullscreens()
	close_up()

	//var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	//mind.store_memory("Time of death: [tod]", 0)

	//New pAI's get a brand new mind to prevent meta stuff from their previous life. This new mind causes problems down the line if it's not deleted here.
	//Read as: I have no idea what I'm doing but asking for help got me nowhere so this is what you get. - Nodrak
	if(mind)	del(mind)
	living_mob_list -= src
	ghostize()
	qdel(src)
