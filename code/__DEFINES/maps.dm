#define CROSSLINKED 2
#define SELFLOOPING 1
#define UNAFFECTED 0
#define MAIN_STATION "Main Station"
#define CENTCOMM "CentComm"
#define ABANDONED_SATELLITE "Abandoned Satellite"
#define DERELICT "Derelicted Station"
#define MINING "Mining Asteroid"
#define EMPTY_AREA_1 "Empty Area 1"
#define EMPTY_AREA_2 "Empty Area 2"
#define EMPTY_AREA_3 "Empty Area 3"
#define EMPTY_AREA_4 "Empty Area 4"
#define ASTEROID "Abandoned Asteroid"
#define AWAY_MISSION "Away Mission"

#define MAP_JOB_CHECK if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

//zlevel defines, can be overridden for different maps in the appropriate _maps file.
#define ZLEVEL_STATION 1
#define ZLEVEL_CENTCOM 2
#define ZLEVEL_MINING 5
#define ZLEVEL_LAVALAND 5
#define ZLEVEL_EMPTY_SPACE 11

#define ZLEVEL_SPACEMIN 3
#define ZLEVEL_SPACEMAX 11 
