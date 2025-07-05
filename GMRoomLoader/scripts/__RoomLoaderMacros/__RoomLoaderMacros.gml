/// @feather ignore all

#region info

#macro __ROOMLOADER_VERSION "v1.9.0" // major.minor.patch
#macro __ROOMLOADER_DATE "2025.xx.xx" // year.month.day
#macro __ROOMLOADER_NAME "GMRoomLoader"
#macro __ROOMLOADER_LOG_PREFIX $"[{__ROOMLOADER_NAME}]"

#endregion
#region instances generic

#macro __ROOMLOADER_INSTANCE_CC \
with (_inst) { \
	script_execute(_inst_data.creation_code); \
}

#endregion
#region instances full

#macro __ROOMLOADER_INSTANCE_FULL_START_RETURNDATA \
var _return_data = RoomLoader.__return_data.__instances; \
var _ids = _return_data.__ids; \
var _room_ids = _return_data.__room_ids; \
var _index = _return_data.__index; \
var _i = 0; repeat (array_length(__instances_data)) { \
	var _inst_data = __instances_data[_i]; \
	var _x = _inst_data.x + _xoffset; \
	var _y = _inst_data.y + _yoffset; \
	var _inst = instance_create_layer(_x, _y, _layer, _inst_data.object_index, _inst_data.precreate); \
	_ids[_index] = _inst; \
	_room_ids[_index] = _inst_data.id;

#macro __ROOMLOADER_INSTANCE_FULL_END_RETURNDATA \
	_i++; \
	_index++; \
} \
_return_data.__index = _index;

#macro __ROOMLOADER_INSTANCE_FULL_START_NORETURNDATA \
var _i = 0; repeat (array_length(__instances_data)) { \
	var _inst_data = __instances_data[_i]; \
	var _x = _inst_data.x + _xoffset; \
	var _y = _inst_data.y + _yoffset; \
	var _inst = instance_create_layer(_x, _y, _layer, _inst_data.object_index, _inst_data.precreate);

#macro __ROOMLOADER_INSTANCE_FULL_END_NORETURNDATA \
	_i++; \
}

#endregion
#region instances standalone

#macro __ROOMLOADER_INSTANCE_STANDALONE_START \
var _n = array_length(_data); \
var _instances = array_create(_n, noone); \
var _i = 0; repeat (_n) { \
	var _inst_data = _data[_i]; \
	var _x = _inst_data.x + _xoffset; \
	var _y = _inst_data.y + _yoffset; \
	var _inst = _func(_x, _y, _lod, _inst_data.object_index, _inst_data.precreate);

#macro __ROOMLOADER_INSTANCE_STANDALONE_END \
	_instances[_i] = _inst; \
	_i++; \
} \
return _instances;

#endregion
