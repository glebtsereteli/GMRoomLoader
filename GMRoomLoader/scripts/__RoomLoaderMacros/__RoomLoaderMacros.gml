/// @feather ignore all

#region Info

#macro __ROOMLOADER_VERSION "v2.0.0" // major.minor.patch
#macro __ROOMLOADER_DATE "2025.xx.xx" // year.month.day
#macro __ROOMLOADER_NAME "GMRoomLoader"
#macro __ROOMLOADER_LOG_PREFIX $"[{__ROOMLOADER_NAME}]"

#endregion
#region Elements

#macro __ROOMLOADER_INSTANCE_CC \
if (ROOMLOADER_INSTANCES_RUN_CREATION_CODE) { \
	with (_inst) { \
		script_execute(_iData.creationCode); \
	} \
}

#macro __ROOMLOADER_TILE_STEP 3 // data, x, y

#endregion
#region Benchmarking

#macro __ROOMLOADER_BENCH_START RoomLoader.__benchTime = get_timer();
#macro __ROOMLOADER_BENCH_END ((get_timer() - RoomLoader.__benchTime) / 1000)

#endregion
