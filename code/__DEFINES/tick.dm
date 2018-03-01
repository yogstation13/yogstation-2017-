#define TICK_LIMIT_RUNNING 80
#define TICK_LIMIT_TO_RUN 75
#define TICK_LIMIT_MC 80
#define TICK_LIMIT_MC_INIT_DEFAULT 98

#define TICK_CHECK ( world.tick_usage > CURRENT_TICKLIMIT ? stoplag() : 0 )
#define CHECK_TICK if (world.tick_usage > CURRENT_TICKLIMIT)  stoplag()

#define TICKS *world.tick_lag
#define DS2TICKS(DS) (DS/world.tick_lag)
#define TICKS2DS(T) (T TICKS)