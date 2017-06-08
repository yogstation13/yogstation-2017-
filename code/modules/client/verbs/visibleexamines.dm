/client/verb/visibleexamine()
	set name = "Toggle Visible Examines"
	set category = "IC"

	if(prefs.examine_throttle == NO_VISIBLE)
		prefs.examine_throttle = FULL_VISIBLE
	else
		prefs.examine_throttle++

	switch(prefs.examine_throttle)
		if(FULL_VISIBLE)
			usr << "<span class='notice'>You will always notice people examining things..</span>"
		if(HALF_VISIBLE)
			usr << "<span class='notice'>You will notice people examining things from time to time.</span>"
		if(NO_VISIBLE)
			usr << "<span class='notice'>You can no longer notice other people examining things...</span>"