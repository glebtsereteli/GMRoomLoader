/// @feather ignore all

#region info

#macro __ROOMLOADER_VERSION "v1.7.0" // major.minor.patch
#macro __ROOMLOADER_DATE "31.05.2024" // day.month.year
#macro __ROOMLOADER_NAME "GMRoomLoader"
#macro __ROOMLOADER_LOG_PREFIX $"[{__ROOMLOADER_NAME}]"

#endregion
#region loading

#macro __ROOMLOADER_INSTANCE_ONLOAD_START_FULL \
	var _return_data = RoomLoader.__return_data.__instances; \
	var _instances = _return_data.__ids; \
	var _index = _return_data.__index; \
	var _i = 0; repeat (array_length(__instances_data)) { \
		var _inst_data = __instances_data[_i]; \
		var _x = _inst_data.x + _xoffset; \
		var _y = _inst_data.y + _yoffset;
	
#macro __ROOMLOADER_INSTANCE_ONLOAD_START_STANDALONE \
	var _n = array_length(_data); \
	var _instances = array_create(_n); \
	var _i = 0; repeat (_n) { \
		var _inst_data = _data[_i]; \
		var _x = _inst_data.x + _xoffset; \
		var _y = _inst_data.y + _yoffset;

#macro __ROOMLOADER_INSTANCE_ONLOAD_END \
		_i++; \
		_index++; \
	} \
	_return_data.__index = _index;

#endregion
