/// @feather ignore all

#region Info

#macro __ROOMLOADER_VERSION "v1.9.0" // major.minor.patch
#macro __ROOMLOADER_DATE "2025.xx.xx" // year.month.day
#macro __ROOMLOADER_NAME "GMRoomLoader"
#macro __ROOMLOADER_LOG_PREFIX $"[{__ROOMLOADER_NAME}]"
#macro __ROOMLOADER_REPO "https://github.com/glebtsereteli/GMRoomLoader"
#macro __ROOMLOADER_WIKI $"{__ROOMLOADER_REPO}/wiki"
#macro __ROOMLOADER_ITCH "https://glebtsereteli.itch.io/gmroomloader"

#endregion
#region Instances: Generic

#macro __ROOMLOADER_INSTANCE_CC \
with (_inst) { \
	script_execute(_iData.creationCode); \
}

#endregion
#region Instances: Full

#macro __ROOMLOADER_INSTANCE_FULL_START_RETURNDATA \
var _return_data = RoomLoader.__returnData.__instances; \
var _ids = _return_data.__ids; \
var _roomIds = _return_data.__roomIds; \
var _index = _return_data.__index; \
var _i = 0; repeat (array_length(__instancesData)) { \
	var _iData = __instancesData[_i]; \
	var _iX = _iData.x + _xOffset; \
	var _iY = _iData.y + _yOffset; \
	var _inst = instance_create_layer(_iX, _iY, _layer, _iData.object_index, _iData.preCreate); \
	_ids[_index] = _inst; \
	_roomIds[_index] = _iData.id;

#macro __ROOMLOADER_INSTANCE_FULL_END_RETURNDATA \
	_i++; \
	_index++; \
} \
_return_data.__index = _index;

#macro __ROOMLOADER_INSTANCE_FULL_START_NORETURNDATA \
var _i = 0; repeat (array_length(__instancesData)) { \
	var _iData = __instancesData[_i]; \
	var _iX = _iData.x + _xOffset; \
	var _iY = _iData.y + _yOffset; \
	var _inst = instance_create_layer(_iX, _iY, _layer, _iData.object_index, _iData.preCreate);

#macro __ROOMLOADER_INSTANCE_FULL_END_NORETURNDATA \
	_i++; \
}

#endregion
#region Instances: Standalone

#macro __ROOMLOADER_INSTANCE_STANDALONE_START \
var _i = 0; repeat (_n) { \
	var _iData = _instancesData[_i]; \
	var _iX = _iData.x + _xOffset; \
	var _iY = _iData.y + _yOffset; \
	var _inst = _func(_iX, _iY, _lod, _iData.object_index, _iData.preCreate);

#macro __ROOMLOADER_INSTANCE_STANDALONE_END \
	_instances[_i] = _inst; \
	_i++; \
}

#macro __ROOMLOADER_INSTANCE_STANDALONE_EXT_START \
var _i = 0; repeat (_n) { \
	var _iData = _instancesData[_i]; \
	var _preCreate = _iData.preCreate; \
	var _xScaled = _iData.x * _xScale; \
	var _yScaled = _iData.y * _yScale; \
	var _dist = point_distance(0, 0, _xScaled, _yScaled); \
	var _dir = point_direction(0, 0, _xScaled, _yScaled) + _angle; \
	var _iX = _x1 + lengthdir_x(_dist, _dir); \
	var _iY = _y1 + lengthdir_y(_dist, _dir); \
	_preCreate.image_xscale *= _iXScale; \
	_preCreate.image_yscale *= _iYScale; \
	_preCreate.image_angle += _iangle; \
	var _inst = _func(_iX, _iY, _lod, _iData.object_index, _iData.preCreate);

#macro __ROOMLOADER_INSTANCE_STANDALONE_EXT_END \
_preCreate.image_xscale /= _iXScale; \
	_preCreate.image_yscale /= _iYScale; \
	_preCreate.image_angle -= _iangle; \
	_instances[_i] = _inst; \
	_i++; \
}

#endregion
#region Benchmarking

#macro __ROOMLOADER_BENCH_START RoomLoader.__benchTime = get_timer();
#macro __ROOMLOADER_BENCH_END ((get_timer() - RoomLoader.__benchTime) / 1000)

#endregion
