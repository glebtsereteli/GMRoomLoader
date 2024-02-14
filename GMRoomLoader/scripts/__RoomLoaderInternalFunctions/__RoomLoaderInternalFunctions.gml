/// @feather ignore all

#macro __ROOMLOADER_INSTANCE_RUN_SCRIPTS \
with (_inst) { \
	script_execute(_inst_data.pre_creation_code); \
	script_execute(_inst_data.creation_code); \
}

function __roomloader_noop() {}
function __roomloader_room_has_prefix(_room, _prefix) {
	var _name = room_get_name(_room);
	return (string_pos(_prefix, _name) > 0);
}
function __roomloader_create_layer(_data) {
	var _layer = layer_create(_data.depth, _data.prefixed_name);
	layer_set_visible(_layer, _data.visible);
	layer_x(_layer, _data.xoffset);
	layer_y(_layer, _data.yoffset);
	layer_hspeed(_layer, _data.hspeed);
	layer_vspeed(_layer, _data.vspeed);
	
	return _layer;
}
function __roomloader_load_instances(_room, _x, _y, _data, _origin, _create_func, _create_data) {
	var _xoffs = __roomloader_get_offset_x(_x, _data.__width, _origin);
	var _yoffs = __roomloader_get_offset_y(_y, _data.__height, _origin);
	
	_data = _data.__instances_data;
	var _n = array_length(_data);
	var _instances = array_create(_n);
	
	var _i = 0; repeat (array_length(_data)) {
		var _inst_data = _data[_i];
		_x = _inst_data.x + _xoffs;
		_y = _inst_data.y + _yoffs;
		var _inst = _create_func(_x, _y, _create_data, _inst_data.object_index, _inst_data.precreate_struct);
		__ROOMLOADER_INSTANCE_RUN_SCRIPTS;
		_instances[_i] = _inst;
		_i++;
	}
	
	return _instances;
}
function __roomloader_get_offset_x(_x, _width, _origin) {
	static _offsets = [
		+0.0, -0.5, -1.0,
		+0.0, -0.5, -1.0,
		-0.0, -0.5, -1.0,
	];
	return (_x + (_width * _offsets[_origin]));
}
function __roomloader_get_offset_y(_y, _height, _origin) {
	static _offsets = [
		+0.0, +0.0, +0.0,
		-0.5, -0.5, -0.5,
		-1.0, -1.0, -1.0,
	];
	return (_y + (_height * _offsets[_origin]));
}
function __roomloader_check_flags(_flags) {
	return ((_flags & __flag) == __flag);
}
function __roomloader_process_script(_script) {
	return ((_script == -1) ? __roomloader_noop : _script);
}
function __roomloader_log(_message) {
	show_debug_message($"[GMRoomLoader] {_message}.");
}
