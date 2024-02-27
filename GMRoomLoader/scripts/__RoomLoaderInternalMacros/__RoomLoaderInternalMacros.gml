/// @feather ignore all

#macro __ROOMLOADER_INSTANCE_ONLOAD_START \
	var _instances = RoomLoader.__return_data.__instances.__ids; \
	var _index = RoomLoader.__return_data.__instances.__index; \
	var _i = 0; repeat (array_length(__instances_data)) { \
		var _inst_data = __instances_data[_i]; \
		var _x = _inst_data.x + _xoffs; \
		var _y = _inst_data.y + _yoffs;
		
#macro __ROOMLOADER_INSTANCE_ONLOAD_END \
		_i++; \
		_index++; \
	} \
	RoomLoader.__return_data.__instances.__index = _index;
