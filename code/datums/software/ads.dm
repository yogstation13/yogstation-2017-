//<a href='byond://?src=\ref[topic_ref];ad_click=1'>Advertisement</a>

/proc/get_random_popup_ad(var/topic_ref)
	var/datum/popup_ad/ad = null
	var/list/ad_options = list(/datum/popup_ad/ad1, /datum/popup_ad/ad2, /datum/popup_ad/ad3, /datum/popup_ad/ad4, /datum/popup_ad/ad5, /datum/popup_ad/ad6, /datum/popup_ad/ad7)
	ad = pick(ad_options)
	if(ad)
		ad = new ad()
		ad.generate_content(topic_ref)
		return ad

/datum/popup_ad
	var/size = "390x400"
	var/content = ""

/datum/popup_ad/proc/generate_content(var/topic_ref)
	return ""

/datum/popup_ad/ad1
	size = "400x350"

/datum/popup_ad/ad1/generate_content(var/topic_ref)
	content = {"
<head><title>NT Product Ads</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad1.png>
</a>
"}


/datum/popup_ad/ad2
	size = "400x430"

/datum/popup_ad/ad2/generate_content(var/topic_ref)
	content = {"
<head><title>Click-o-Tron</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad2.png>
</a>
"}

/datum/popup_ad/ad3
	size = "390x400"

/datum/popup_ad/ad3/generate_content(var/topic_ref)
	content = {"
<head><title>Click-o-Tron</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad3.png>
</a>
"}

/datum/popup_ad/ad4
	size = "390x400"

/datum/popup_ad/ad4/generate_content(var/topic_ref)
	content = {"
<head><title>Click-o-Tron</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad4.png>
</a>
"}

/datum/popup_ad/ad5
	size = "390x400"

/datum/popup_ad/ad5/generate_content(var/topic_ref)
	content = {"
<head><title>Click-o-Tron</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad5.png>
</a>
"}

/datum/popup_ad/ad6
	size = "390x400"

/datum/popup_ad/ad6/generate_content(var/topic_ref)
	content = {"
<head><title>Click-o-Tron</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad6.png>
</a>
"}

/datum/popup_ad/ad7
	size = "390x400"

/datum/popup_ad/ad7/generate_content(var/topic_ref)
	content = {"
<head><title>Click-o-Tron</title></head>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<img src=ad7.png>
</a>
"}

/*
/datum/popup_ad/ad3
	size = "460x120"

/datum/popup_ad/ad3/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>Nanotrasen mum finds best way to cure brainrot, leaves doctors baffled with her 5$ trick</a>
</body>
</a>
"}

/datum/popup_ad/ad4
	size = "430x200"

/datum/popup_ad/ad4/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>18 best griefs of all time. #9 is really shocking!</a>
</body>
</a>
"}

/datum/popup_ad/ad5
	size = "430x200"

/datum/popup_ad/ad5/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>Man steals dog, puts it in washing machine with his laundry</a>
</body>
</a>
"}

/datum/popup_ad/ad6
	size = "430x200"

/datum/popup_ad/ad6/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>This assistant makes $1300 space bucks an hour working from Dorms. Find out how!</a>
</body>
</a>
"}

/datum/popup_ad/ad7
	size = "430x200"

/datum/popup_ad/ad7/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>ASSISTANTS SECRET TO ALL ACCES DISCOVERED! CLICK QUICK BEFORE IT GETS REMOVED!!</a>
</body>
</a>
"}

/datum/popup_ad/ad8
	size = "430x200"

/datum/popup_ad/ad8/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>WARNING!! Your PDA has <font color='red'><b>13</b></font> viruses! Click here to remove them now!</a>
</body>
</a>
"}

/datum/popup_ad/ad9
	size = "430x200"

/datum/popup_ad/ad9/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>Warning, your AI is malfunctioning and has been hacked, click here to revert to asimov</a>
</body>
</a>
"}

/datum/popup_ad/ad10
	size = "430x200"

/datum/popup_ad/ad10/generate_content(var/topic_ref)
	content = {"
<style>
body
{
	font-size: 18pt;
}
</style>
<body>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>
<a href='byond://?src=\ref[topic_ref];ad_click=1'>Security has tracked you! Click here to pay your $1000 bail NOW or face prosecution!</a>
</body>
</a>
"}
*/