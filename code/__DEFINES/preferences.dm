
//Preference toggles
#define SOUND_ADMINHELP	1
#define SOUND_MIDI		2
#define SOUND_AMBIENCE	4
#define SOUND_LOBBY		8
#define MEMBER_PUBLIC	16
#define INTENT_STYLE	32
#define MIDROUND_ANTAG	64
#define SOUND_INSTRUMENTS	128
#define SOUND_SHIP_AMBIENCE 256
#define SOUND_PRAYERS 512
#define ANNOUNCE_LOGIN 1024
#define SOUND_ANNOUNCEMENTS 2048
#define TICKET_ALL		4096
#define QUIET_ROUND		8192
#define DISABLE_DEATHRATTLE 16384

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|MEMBER_PUBLIC|INTENT_STYLE|MIDROUND_ANTAG|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS|DISABLE_DEATHRATTLE)

//Chat toggles
#define CHAT_OOC		1
#define CHAT_DEAD		2
#define CHAT_GHOSTEARS	4
#define CHAT_GHOSTSIGHT	8
#define CHAT_PRAYER		16
#define CHAT_RADIO		32
#define CHAT_PULLR		64
#define CHAT_GHOSTWHISPER 128
#define CHAT_GHOSTPDA	256
#define CHAT_GHOSTRADIO 512

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO)

//Antag toggles
#define BE_TRAITOR		"role_traitor"
#define BE_DOUBLEAGENT "role_doubleagent"
#define BE_OPERATIVE	"role_operative"
#define BE_CHANGELING	"role_changeling"
#define BE_WIZARD		"role_wizard"
#define BE_REV			"role_rev"
#define BE_ALIEN		"role_alien"
#define BE_PAI			"role_pai"
#define BE_CULTIST		"role_cultist"
#define BE_BLOB			"role_blob"
#define BE_NINJA		"role_ninja"
#define BE_MONKEY		"role_monkey"
#define BE_GANG			"role_gang"
#define BE_SHADOWLING	"role_shadowling"
#define BE_ABDUCTOR		"role_abductor"
#define BE_REVENANT		"role_revenant"
#define BE_ZOMBIE		"role_zombie"
#define BE_CYBERMAN		"role_cyberman"