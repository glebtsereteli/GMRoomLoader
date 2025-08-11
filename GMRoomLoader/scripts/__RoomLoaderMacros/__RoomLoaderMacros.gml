/// @feather ignore all

#region info

#macro __ROOMLOADER_VERSION "v1.9.0" // major.minor.patch
#macro __ROOMLOADER_DATE "2025.xx.xx" // year.month.day
#macro __ROOMLOADER_NAME "GMRoomLoader"
#macro __ROOMLOADER_LOG_PREFIX $"[{__ROOMLOADER_NAME}]"
#macro __ROOMLOADER_REPO "https://github.com/glebtsereteli/GMRoomLoader"
#macro __ROOMLOADER_WIKI $"{__ROOMLOADER_REPO}/wiki"
#macro __ROOMLOADER_ITCH "https://glebtsereteli.itch.io/gmroomloader"

#endregion
#region instances generic

#macro __ROOMLOADER_INSTANCE_CC \
with (_inst) { \
	script_execute(_idata.creation_code); \
}

#endregion
#region instances full

#macro __ROOMLOADER_INSTANCE_FULL_START_RETURNDATA \
var _return_data = RoomLoader.__return_data.__instances; \
var _ids = _return_data.__ids; \
var _room_ids = _return_data.__roomIds; \
var _index = _return_data.__index; \
var _i = 0; repeat (array_length(__instances_data)) { \
	var _idata = __instances_data[_i]; \
	var _ix = _idata.x + _xoffset; \
	var _iy = _idata.y + _yoffset; \
	var _inst = instance_create_layer(_ix, _iy, _layer, _idata.object_index, _idata.precreate); \
	_ids[_index] = _inst; \
	_room_ids[_index] = _idata.id;

#macro __ROOMLOADER_INSTANCE_FULL_END_RETURNDATA \
	_i++; \
	_index++; \
} \
_return_data.__index = _index;

#macro __ROOMLOADER_INSTANCE_FULL_START_NORETURNDATA \
var _i = 0; repeat (array_length(__instances_data)) { \
	var _idata = __instances_data[_i]; \
	var _ix = _idata.x + _xoffset; \
	var _iy = _idata.y + _yoffset; \
	var _inst = instance_create_layer(_ix, _iy, _layer, _idata.object_index, _idata.precreate);

#macro __ROOMLOADER_INSTANCE_FULL_END_NORETURNDATA \
	_i++; \
}

#endregion
#region instances standalone

#macro __ROOMLOADER_INSTANCE_STANDALONE_START \
var _i = 0; repeat (_n) { \
	var _idata = _idatas[_i]; \
	var _ix = _idata.x + _xoffset; \
	var _iy = _idata.y + _yoffset; \
	var _inst = _func(_ix, _iy, _lod, _idata.object_index, _idata.precreate);

#macro __ROOMLOADER_INSTANCE_STANDALONE_END \
	_instances[_i] = _inst; \
	_i++; \
}

#macro __ROOMLOADER_INSTANCE_STANDALONE_EXT_START \
var _i = 0; repeat (_n) { \
	var _idata = _idatas[_i]; \
	var _precreate = _idata.precreate; \
	var _xscaled = _idata.x * _xscale; \
	var _yscaled = _idata.y * _yscale; \
	var _dist = point_distance(0, 0, _xscaled, _yscaled); \
	var _dir = point_direction(0, 0, _xscaled, _yscaled) + _angle; \
	var _ix = _x1 + lengthdir_x(_dist, _dir); \
	var _iy = _y1 + lengthdir_y(_dist, _dir); \
	_precreate.image_xscale *= _ixscale; \
	_precreate.image_yscale *= _iyscale; \
	_precreate.image_angle += _iangle; \
	var _inst = _func(_ix, _iy, _lod, _idata.object_index, _idata.precreate);

#macro __ROOMLOADER_INSTANCE_STANDALONE_EXT_END \
_precreate.image_xscale /= _ixscale; \
	_precreate.image_yscale /= _iyscale; \
	_precreate.image_angle -= _iangle; \
	_instances[_i] = _inst; \
	_i++; \
}

#endregion
