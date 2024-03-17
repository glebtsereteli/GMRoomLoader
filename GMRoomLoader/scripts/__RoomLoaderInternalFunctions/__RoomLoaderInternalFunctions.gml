/// @feather ignore all

function __roomloader_noop() {}
function __roomloader_create_layer(_data) {
	var _layer = layer_create(_data.depth, _data.prefixed_name);
	layer_set_visible(_layer, _data.visible);
	layer_x(_layer, _data.xoffset);
	layer_y(_layer, _data.yoffset);
	layer_hspeed(_layer, _data.hspeed);
	layer_vspeed(_layer, _data.vspeed);
	
	return _layer;
}
function __roomloader_load_instances(_x, _y, _data, _origin, _create_func, _create_data) {
	static _cc = function(_data, _create_func, _create_data, _xoffs, _yoffs) {
		__ROOMLOADER_INSTANCE_ONLOAD_START_STANDALONE
			var _inst = _create_func(_x, _y, _create_data, _inst_data.object_index, _inst_data.precreate);
			with (_inst) {
				script_execute(_inst_data.creation_code);
			}
			_instances[_i] = _inst;
			_i++;
		}
		return _instances;
	};
	static _nocc = function(_data, _create_func, _create_data, _xoffs, _yoffs) {
		__ROOMLOADER_INSTANCE_ONLOAD_START_STANDALONE
			_instances[_i] = _create_func(_x, _y, _create_data, _inst_data.object_index, _inst_data.precreate); 
			_i++;
		}
		return _instances;
	};
	static _func = (ROOMLOADER_INSTANCES_RUN_CREATION_CODE ? _cc : _nocc);
	
	var _xoffs = __roomloader_get_offset_x(_x, _data.__width, _origin);
	var _yoffs = __roomloader_get_offset_y(_y, _data.__height, _origin);
	_data = _data.__instances_data;
	return _func(_data, _create_func, _create_data, _xoffs, _yoffs);
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
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	show_debug_message($"[GMRoomLoader] {_message}.");
}
function __roomloader_log_method(_method_name, _message) {
	__roomloader_log($"RoomLoader.{_method_name}(): {_message}");
}
function __roomloader_log_method_timed(_method_name, _message) {
	__roomloader_log($"RoomLoader.{_method_name}(): {_message} in {RoomLoader.__benchmark.__get()} milliseconds");
}
function __roomloader_error(_message) {
	show_error($"[GMRoomLoader {__ROOMLOADER_VERSION}] Error.\n-----------------------------------\n{_message}.\n\n", true);
}
function __roomloader_error_method(_method_name, _message) {
	__roomloader_error($"RoomLoader.{_method_name}(): {_message}");
}
function __roomloader_catch_nonroom(_room, _method_name, _message) {
	var _type = typeof(_room);
	if ((_type == "ref") and (room_exists(_room))) return;
	__roomloader_error_method(_method_name, $"Could not {_message} <{_room}>.\nExpected \{Asset.GMRoom\}, got \{{_type}\}");
}
function __roomloader_catch_argument(_value, _checker, _method_name, _type_name, _message_pre = "use", _message_post = "") {
	if (not _checker(_value)) {
		__roomloader_error_method(_method_name, $"Could not {_message_pre} <{_value}>{_message_post}.\nExpected \{{_type_name}\}, got \{{typeof(_value)}\}");
	}
}
