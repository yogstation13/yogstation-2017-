/datum/pai/software/security_records
	name = "Security Records"
	description = "Allows read-only access to NT disciplinary-security catalogues."
	category = "Security"
	sid = "securityrecords"
	ram = 15

/datum/pai/software/security_records/action_use(mob/living/silicon/pai/user, var/args)
	if(user.subscreen == 1)
		user.securityActive1 = find_record("id", args["sec_rec"], data_core.general)
		if(user.securityActive1)
			user.securityActive2 = find_record("id", args["sec_rec"], data_core.security)
		if(!user.securityActive2)
			user.securityActive1 = null
			user.temp = "Unable to locate requested security record. Record may have been deleted, or never have existed."

/datum/pai/software/security_records/action_menu(mob/living/silicon/pai/user)
	. = ""
	switch(user.subscreen)
		if(0)
			. += "<h3>Security Records</h3><HR>"
			if(data_core.general)
				for(var/datum/data/record/R in sortRecord(data_core.general))
					. += "<A href='?src=\ref[user];sec_rec=[R.fields["id"]];software=[sid];sub=1'>[R.fields["id"]]: [R.fields["name"]]<BR>"
		if(1)
			. += "<h3>Security Record</h3>"
			if(user.securityActive1 in data_core.general)
				. += {"Name: <A href='?src=\ref[user];field=name'>[user.securityActive1.fields["name"]]</A>
				ID: <A href='?src=\ref[user];field=id'>[user.securityActive1.fields["id"]]</A><BR>\n
				Sex: <A href='?src=\ref[user];field=sex'>[user.securityActive1.fields["sex"]]</A><BR>\n
				Age: <A href='?src=\ref[user];field=age'>[user.securityActive1.fields["age"]]</A><BR>\n
				Rank: <A href='?src=\ref[user];field=rank'>[user.securityActive1.fields["rank"]]</A><BR>\n
				Fingerprint: <A href='?src=\ref[user];field=fingerprint'>[user.securityActive1.fields["fingerprint"]]</A><BR>\n
				Physical Status: [user.securityActive1.fields["p_stat"]]<BR>\n
				Mental Status: [user.securityActive1.fields["m_stat"]]<BR>"}
			else
				. += "<pre>Requested security record not found,</pre><BR>"
			if(user.securityActive2 in data_core.security)
				. += {"<BR>\nSecurity Data<BR>\nCriminal Status: [user.securityActive2.fields["criminal"]]<BR>\n<BR>\n
				Minor Crimes: <A href='?src=\ref[user];field=mi_crim'>[user.securityActive2.fields["mi_crim"]]</A><BR>\n
				Details: <A href='?src=\ref[user];field=mi_crim_d'>[user.securityActive2.fields["mi_crim_d"]]</A><BR>\n<BR>\n
				Major Crimes: <A href='?src=\ref[user];field=ma_crim'>[user.securityActive2.fields["ma_crim"]]</A><BR>\n
				Details: <A href='?src=\ref[user];field=ma_crim_d'>[user.securityActive2.fields["ma_crim_d"]]</A><BR>\n
				<BR>\nImportant Notes:<BR>\n\t<A href='?src=\ref[user];field=notes'>[user.securityActive2.fields["notes"]]</A><BR>\n
				<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"}
			else
				. += "<pre>Requested security record not found,</pre><BR>"
			. += text("<BR>\n<A href='?src=\ref[];software=[sid];sub=0'>Back</A><BR>", src)
	return .
