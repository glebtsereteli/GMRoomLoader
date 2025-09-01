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

#macro __ROOMLOADER_INST_CC \
if (ROOMLOADER_INSTANCES_RUN_CREATION_CODE) { \
	with (_inst) { \
		script_execute(_iData.creationCode); \
	} \
}

#macro __ROOMLOADER_INST_TRANSFORM_PRELOAD \
var _xScaled = _iData.x * _xScale; \
var _yScaled = _iData.y * _yScale; \
var _x = _x1 + (_xScaled * _cos) + (_yScaled * _sin); \
var _y = _y1 + (-_xScaled * _sin) + (_yScaled * _cos); \
\
var _preCreate = _iData.preCreate; \
var _xScalePrev = _preCreate.image_xscale; \
var _yScalePrev = _preCreate.image_yscale; \
\
_preCreate.image_xscale *= _xScale; \
_preCreate.image_yscale *= _yScale; \
_preCreate.image_angle += _angle;

#macro __ROOMLOADER_INST_LAYER_PRELOAD \		
if (ROOMLOADER_DELIVER_PAYLOAD) { \
	var _payload = RoomLoader.__payload.__instances; \
	var _ids = _payload.__ids; \
	var _roomIds = _payload.__roomIds; \
	var _index = _payload.__index; \
}

#macro __ROOMLOADER_INST_LAYER_POSTLOAD \
if (ROOMLOADER_DELIVER_PAYLOAD) { \
	_payload.__index = _index; \
}

#macro __ROOMLOADER_INST_TRANSFORM_POSTLOAD \
__ROOMLOADER_INST_CC \
_preCreate.image_xscale = _xScalePrev; \
_preCreate.image_yscale = _yScalePrev; \
_preCreate.image_angle -= _angle;

#macro __ROOMLOADER_SPRITE_LOAD \
var _sprite = layer_sprite_create(_layer, _x, _y, __sprite); \
layer_sprite_index(_sprite, __frame); \
layer_sprite_speed(_sprite, __spd); \
layer_sprite_blend(_sprite, __blend); \
layer_sprite_alpha(_sprite, __alpha); \
if (ROOMLOADER_DELIVER_PAYLOAD) { \
	RoomLoader.__payload.__sprites.__Add(_sprite, __roomId); \
}

#macro __ROOMLOADER_SEQUENCE_LOAD \
var _sequence = layer_sequence_create(_layer, _x, _y, __id); \
layer_sequence_headpos(_sequence, __headPos); \
layer_sequence_speedscale(_sequence, __speedScale); \
if (ROOMLOADER_SEQUENCES_PAUSE) { \
	layer_sequence_pause(_sequence); \
} \
if (ROOMLOADER_DELIVER_PAYLOAD) { \
	RoomLoader.__payload.__sequences.__Add(_sequence, __roomId); \
}

#macro __ROOMLOADER_TILE_STEP 3 // x, y, data

#endregion
#region Benchmarking

#macro __ROOMLOADER_BENCH_START RoomLoader.__benchTime = get_timer();
#macro __ROOMLOADER_BENCH_END ((get_timer() - RoomLoader.__benchTime) / 1000)

#endregion
