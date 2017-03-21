/datum/pai/software/medical_records
	name = "Medical Records Register"
	description = "Allows access to NT crew medical records in a limited read-only capacity."
	category = "Medical"
	sid = "medicalrecords"
	ram = 15

/datum/pai/software/medical_records/action_use(mob/living/silicon/pai/user, var/args)
	user.medicalActive1 = find_record("id", args["med_rec"], data_core.general)
	if(user.medicalActive1)
		user.medicalActive2 = find_record("id", args["med_rec"], data_core.medical)
	if(!user.medicalActive2)
		user.medicalActive1 = null
		return "Unable to locate requested security record. Record may have been deleted, or never have existed."

/datum/pai/software/medical_records/action_menu(mob/living/silicon/pai/user)
	switch(user.subscreen)
		if(0)
			. += "<h3>Medical Records</h3><HR>"
			if(data_core.general)
				for(var/datum/data/record/R in sortRecord(data_core.general))
					. += "<A href='?src=\ref[user];med_rec=[R.fields["id"]];software=[sid];sub=1'>[R.fields["id"]]: [R.fields["name"]]<BR>"
		if(1)
			. += "<CENTER><B>Medical Record</B></CENTER><BR>"
			if(user.medicalActive1 in data_core.general)
				. += {"Name: [user.medicalActive1.fields["name"]]
				ID: [user.medicalActive1.fields["id"]]<BR>\n
				Sex: [user.medicalActive1.fields["sex"]]<BR>\n
				Age: [user.medicalActive1.fields["age"]]<BR>\n
				Fingerprint: [user.medicalActive1.fields["fingerprint"]]<BR>\n
				Physical Status: [user.medicalActive1.fields["p_stat"]]<BR>\n
				Mental Status: [user.medicalActive1.fields["m_stat"]]<BR>"}
			else
				. += "<pre>Requested medical record not found.</pre><BR>"
			if(user.medicalActive2 in data_core.medical)
				. += {"<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\n
				Blood Type: <A href='?src=\ref[user];field=blood_type'>[user.medicalActive2.fields["blood_type"]]</A><BR>\n
				DNA: <A href='?src=\ref[user];field=b_dna'>[user.medicalActive2.fields["b_dna"]]</A><BR>\n<BR>\n
				Minor Disabilities: <A href='?src=\ref[user];field=mi_dis'>[user.medicalActive2.fields["mi_dis"]]</A><BR>\n
				Details: <A href='?src=\ref[user];field=mi_dis_d'>[user.medicalActive2.fields["mi_dis_d"]]</A><BR>\n
				<BR>\nMajor Disabilities: <A href='?src=\ref[user];field=ma_dis'>[user.medicalActive2.fields["ma_dis"]]</A><BR>\n
				Details: <A href='?src=\ref[user];field=ma_dis_d'>[user.medicalActive2.fields["ma_dis_d"]]</A><BR>\n<BR>\n
				Allergies: <A href='?src=\ref[user];field=alg'>[user.medicalActive2.fields["alg"]]</A><BR>\n
				Details: <A href='?src=\ref[user];field=alg_d'>[user.medicalActive2.fields["alg_d"]]</A><BR>\n<BR>\n
				Current Diseases: <A href='?src=\ref[user];field=cdi'>[user.medicalActive2.fields["cdi"]]</A> (per disease info placed in log/comment section)<BR>\n
				Details: <A href='?src=\ref[user];field=cdi_d'>[user.medicalActive2.fields["cdi_d"]]</A><BR>\n
				<BR>\nImportant Notes:<BR>\n\t<A href='?src=\ref[user];field=notes'>[user.medicalActive2.fields["notes"]]</A><BR>\n<BR>\n
				<CENTER><B>Comments/Log</B></CENTER><BR>"}
			else
				. += "<pre>Requested medical record not found.</pre><BR>"
			. += "<BR>\n<A href='?src=\ref[user];software=[sid];sub=0'>Back</A><BR>"
	return .