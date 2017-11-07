#define MEMOFILE "data/memo.sav"	//where the memos are saved
#define ENABLE_MEMOS 1				//using a define because screw making a config variable for it. This is more efficient and purty.

/client/proc/admin_memo()
	set name = "Memo"
	set category = "Server"
	if(!ENABLE_MEMOS)
		return
	if(!check_rights(0))
		return
	if(!dbcon.IsConnected())
		to_chat(src, "<span class='danger'>Failed to establish database connection.</span>")
		return
	var/memotask = input(usr,"Choose task.","Memo") as anything in list("Show","Write","Edit","Remove")
	if(!memotask)
		return
	admin_memo_output(memotask)

/client/proc/admin_memo_output(task)
	if(!task)
		return
	if(!dbcon.IsConnected())
		to_chat(src, "<span class='danger'>Failed to establish database connection.</span>")
		return
	var/sql_ckey = sanitizeSQL(src.ckey)
	switch(task)
		if("Write")
			var/savefile/F = new(MEMOFILE)
			if(F)
				var/memo = stripped_multiline_input(src,"Type your memo\n(Leaving it blank will delete your current memo):","Write Memo",null)
				switch(memo)
					if(null)
						return
					if("")
						message_admins("<span class='admin'>[src.ckey] removed their own Memo</span>")
						log_admin("[src.ckey] removed their own Memo")
						F.dir.Remove(ckey)
						return
				if( findtext(memo,"<script",1,0) )
					return
				F[ckey] << "[key] on [time2text(world.realtime,"(DDD) DD MMM hh:mm")]<br>[memo]"
				message_admins("[key] set an admin memo:<br>[memo]")
				log_admin("[key] set an admin memo:[memo]")
		if("Edit")
			/* Not updated to Yogstation yet*/
			return
			var/DBQuery/query_memolist = dbcon.NewQuery("SELECT ckey FROM [format_table_name("memo")]")
			if(!query_memolist.Execute())
				var/err = query_memolist.ErrorMsg()
				log_game("SQL ERROR obtaining ckey from memo table. Error : \[[err]\]\n")
				return
			var/list/memolist = list()
			while(query_memolist.NextRow())
				var/lkey = query_memolist.item[1]
				memolist += "[lkey]"
			if(!memolist.len)
				to_chat(src, "No memos found in database.")
				return
			var/target_ckey = input(src, "Select whose memo to edit", "Select memo") as null|anything in memolist
			if(!target_ckey)
				return
			var/target_sql_ckey = sanitizeSQL(target_ckey)
			var/DBQuery/query_memofind = dbcon.NewQuery("SELECT memotext FROM [format_table_name("memo")] WHERE ckey = '[target_sql_ckey]'")
			if(!query_memofind.Execute())
				var/err = query_memofind.ErrorMsg()
				log_game("SQL ERROR obtaining memotext from memo table. Error : \[[err]\]\n")
				return
			if(query_memofind.NextRow())
				var/old_memo = query_memofind.item[1]
				var/new_memo = stripped_multiline_input("Input new memo", "New Memo", "[old_memo]", null)
				if(!new_memo)
					return
				new_memo = sanitizeSQL(new_memo)
				var/edit_text = "Edited by [sql_ckey] on [SQLtime()] from<br>[old_memo]<br>to<br>[new_memo]<hr>"
				edit_text = sanitizeSQL(edit_text)
				var/DBQuery/update_query = dbcon.NewQuery("UPDATE [format_table_name("memo")] SET memotext = '[new_memo]', last_editor = '[sql_ckey]', edits = CONCAT(IFNULL(edits,''),'[edit_text]') WHERE ckey = '[target_sql_ckey]'")
				if(!update_query.Execute())
					var/err = update_query.ErrorMsg()
					log_game("SQL ERROR editing memo. Error : \[[err]\]\n")
					return
				if(target_sql_ckey == sql_ckey)
					log_admin("[key_name(src)] has edited their memo from [old_memo] to [new_memo]")
					message_admins("[key_name_admin(src)] has edited their memo from<br>[old_memo]<br>to<br>[new_memo]")
				else
					log_admin("[key_name(src)] has edited [target_sql_ckey]'s memo from [old_memo] to [new_memo]")
					message_admins("[key_name_admin(src)] has edited [target_sql_ckey]'s memo from<br>[old_memo]<br>to<br>[new_memo]")
		if("Show")
			if(ENABLE_MEMOS)
				var/savefile/F = new(MEMOFILE)
				if(F)
					for(var/ckey in F.dir)
						to_chat(src, "<center><span class='motd'><span class='prefix'>Admin Memo</span><span class='emote'> by [F[ckey]]</span></span></center>")
		if("Remove")
			var/savefile/F = new(MEMOFILE)
			if(F)
				var/ckey
				if(check_rights(R_SERVER,0))	//high ranking admins can delete other admin's memos
					ckey = input(src,"Whose memo shall we remove?","Remove Memo",null) as null|anything in F.dir
				else
					ckey = src.ckey
				if(ckey)
					message_admins("<span class='admin'>[src.ckey] removed [ckey]'s Memo.</span>")
					log_admin("[src.ckey] removed Memo created by [ckey].")
					for(var/memo in F.dir)
						F.dir.Remove(ckey)

#undef MEMOFILE
#undef ENABLE_MEMOS