/// @feather ignore all

#region Info

#macro __ROOMLOADER_VERSION "v2.0.0" // major.minor.patch
#macro __ROOMLOADER_DATE "2025.xx.xx" // year.month.day
#macro __ROOMLOADER_NAME "GMRoomLoader"
#macro __ROOMLOADER_LOG_PREFIX $"[{__ROOMLOADER_NAME}]"

#endregion
#region Elements, Loading

#macro __ROOMLOADER_NOTRANSFORM ((_xScale == 1) and (_yScale == 1) and (_angle == 0))

#macro __ROOMLOADER_HAS_FLAG (__flag & _flags)

#macro __ROOMLOADER_LOAD_LAYER_START \
if (not __ROOMLOADER_HAS_FLAG) return; \
if (__HasFailedFilters()) return; \
var _layer = __RoomLoaderGetLayer(__layerData); \
if (ROOMLOADER_DELIVER_PAYLOAD) { \
	RoomLoader.__payload.__layers.__Add(_layer, __layerData.name); \
}

#macro __ROOMLOADER_INSTANCE_CC \
if (ROOMLOADER_INSTANCES_RUN_CREATION_CODE) { \
	with (_inst) { \
		script_execute(_iData.creationCode); \
	} \
}

#macro __ROOMLOADER_TILE_STEP 3 // x, y, data

#endregion
#region Benchmarking

#macro __ROOMLOADER_BENCH_START RoomLoader.__benchTime = get_timer();
#macro __ROOMLOADER_BENCH_END ((get_timer() - RoomLoader.__benchTime) / 1000)

#endregion
