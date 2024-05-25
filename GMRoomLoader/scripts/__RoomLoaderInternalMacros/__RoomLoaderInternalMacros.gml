/// @feather ignore all

#macro __ROOMLOADER_VERSION "v1.6.0" // major.minor.patch
#macro __ROOMLOADER_DATE "07.03.2024" // day.month.year
#macro __ROOMLOADER_LOG_PREFIX "[GMRoomLoader]"

#region loading

#macro __ROOMLOADER_INSTANCE_ONLOAD_START_FULL \
	var _return_data = RoomLoader.__return_data.__instances; \
	var _instances = _return_data.__ids; \
	var _index = _return_data.__index; \
	var _i = 0; repeat (array_length(__instances_data)) { \
		var _inst_data = __instances_data[_i]; \
		var _x = _inst_data.x + _xoffs; \
		var _y = _inst_data.y + _yoffs;
		
#macro __ROOMLOADER_INSTANCE_ONLOAD_END_FULL \
		_i++; \
		_index++; \
	} \
	_return_data.__index = _index;
	
#macro __ROOMLOADER_INSTANCE_ONLOAD_START_STANDALONE \
	var _n = array_length(_data); \
	var _instances = array_create(_n); \
	var _i = 0; repeat (_n) { \
		var _inst_data = _data[_i]; \
		var _x = _inst_data.x + _xoffs; \
		var _y = _inst_data.y + _yoffs;

#endregion
#region misc

#macro __ROOMLOADER_METHOD_NAME string_copy(_GMFUNCTION_, 12, string_pos("@", _GMFUNCTION_) - 12)

#endregion

show_debug_message($"{__ROOMLOADER_LOG_PREFIX} You're using GMRoomLoader {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) by Gleb Tsereteli.");
