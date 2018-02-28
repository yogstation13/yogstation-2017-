var/admins = list("Xantam", "OakBoscage", "Alexandria404", "Slovenian", "Atomicapples", "Oisin100", "AsV9", "ktlwjec", "R3DGL4R3", "simonset55", "Nichlas0010", "AtRealDonaldTrump", "Kmc2000", "YeOldeSheriff", "halueryphi", "Wardog390", "MorrowWolf", "Arkaotic", "Colburn3000", "MrRory", "Menacingmanatee", "Altoids0", "Hydre", "Sircodey", "Kiripirin", "Yogurtshrimp69", "Bachri", "BritishGrace", "Spl99", "20thgirl", "Madventurer", "Nightshadow1055", "Grayrachnid", "Robotic Potato", "Hadrin Alucard", "Kayozz11", "Alek2ander", "Matskuman5", "kooarbiter", "Void00", "Ikoden", "dotlyna", "enkaa", "TheBombmaker", "ThatLing", "Observer", "Yogstation13-Bot")

/client/verb/OOC(msg as text)
	set name = "OOC"
	set category = "OOC"
	if(key in admins)
		msg = "<font color='green'>\[Admin\][key]: [msg]</font>"
	else
		msg = "<font color='blue'>[key]: [msg]</font>"
	world << msg