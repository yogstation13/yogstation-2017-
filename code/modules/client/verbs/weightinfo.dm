/client/verb/weightstats()
	set name = "Antag Weight Stats"
	set category = "OOC"
	set desc = "Shows information about your current antagonist weight."

	if(dbcon.IsConnected())
		var/ckey_listed = list()
		for (var/mob/new_player/player in player_list)
			ckey_listed += get_ckey(player.mind)

		var/ckey_for_sql = list2string(ckey_listed, "', '")

		var/DBQuery/q = dbcon.NewQuery("SELECT `antag_weight` FROM [format_table_name("player")] WHERE `ckey`='[key]'")
		var/DBQuery/q_total = dbcon.NewQuery("SELECT `antag_weight` FROM [format_table_name("player")] WHERE `ckey` IN ('[ckey_for_sql]')")
		var/weight
		if(!last_cached_weight)
			if(!q.Execute())
				src << "An error occured, try again later."
				return
			weight = text2num(q.item[1])
			last_cached_weight = weight
		else
			weight = last_cached_weight //Only query database once per player, cached weight is updated at round start
		src << "Your current antagonist weight is [max(min(weight,400),25)]/400."
		if(!last_cached_total_weight)
			if(!q_total.Execute())
				src << "Could not fetch statistics."
				return

		var/total = 0
		if(!last_cached_total_weight)
			while(q_total.NextRow())
				total += text2num(q_total.item[1])
				last_cached_total_weight = total //Only updated once, because it's not likely to change significantly over a short period of time.
		else
			total = last_cached_total_weight

		var/nextantag = round(100/((weight/total)*280))

		src << "You account for [(weight/total)*100]% of the antagonist weight on the server right now."
		src << "You will likely be an antagonist within the next [nextantag] [nextantag > 1 ? "rounds" : "round"]." //5.6 being the average number of antagonists in a round
		//as determined by about 5 seconds of shitty math on a napkin
		src << "(Some statistics are cached for performance purposes, and may be slightly inaccurate.)"
	else
		src << "No database connection detected!"
