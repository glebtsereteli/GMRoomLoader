/// @feather ignore all

function __roomloader_noop() {}
function __roomloader_create_layer(_data) {
	var _layer = layer_create(_data.depth, _data.name);
	layer_set_visible(_layer, _data.visible);
	layer_x(_layer, _data.xoffset);
	layer_y(_layer, _data.yoffset);
	layer_hspeed(_layer, _data.hspeed);
	layer_vspeed(_layer, _data.vspeed);
	
	return _layer;
}
function __roomloader_load_instances(_x, _y, _data, _xorigin, _yorigin, _create_func, _create_data) {
	static _cc = function(_data, _create_func, _create_data, _xoffset, _yoffset) {
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
	static _nocc = function(_data, _create_func, _create_data, _xoffset, _yoffset) {
		__ROOMLOADER_INSTANCE_ONLOAD_START_STANDALONE
			_instances[_i] = _create_func(_x, _y, _create_data, _inst_data.object_index, _inst_data.precreate); 
			_i++;
		}
		return _instances;
	};
	static _func = (ROOMLOADER_INSTANCES_RUN_CREATION_CODE ? _cc : _nocc);
	
	var _xoffset = _x - (_data.__width * _xorigin);
	var _yoffset = _y - (_data.__height * _yorigin);
	return _func(_data.__instances_data, _create_func, _create_data, _xoffset, _yoffset);
}
function __roomloader_check_flags(_flags) {
	return ((_flags & __flag) == __flag);
}
function __roomloader_process_script(_script) {
	return ((_script == -1) ? __roomloader_noop : _script);
}

function __roomloader_log(_message) {
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	show_debug_message($"{__ROOMLOADER_LOG_PREFIX} {_message}.");
}
function __roomloader_log_method(_prefix, _method_name, _message) {
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	__roomloader_log($"{_prefix}.{_method_name}(): {_message}");
}
function __roomloader_log_method_timed(_prefix, _method_name, _message, _room) {
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	__roomloader_log_method(_prefix, _method_name, $"{_message} <{room_get_name(_room)}> in {RoomLoader.__benchmark.__get()} milliseconds");
}

function __roomloader_error(_message) {
	show_error($"[{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION}] Error.\n-----------------------------------\n{_message}.\n\n", true);
}
function __roomloader_error_method(_prefix, _method_name, _message) {
	__roomloader_error($"{_prefix}.{_method_name}(): {_message}");
}

function __roomloader_catch_nonroom(_prefix, _method_name, _room, _message) {
	var _type = typeof(_room);
	if ((_type == "ref") and (room_exists(_room))) return;
	__roomloader_error_method(_prefix, _method_name, $"Could not {_message} <{_room}>.\nExpected \{Asset.GMRoom\}, got \{{_type}\}");
}
function __roomloader_catch_argument(_prefix, _method_name, _value, _checker, _type_name, _premessage = "use", _postmessage = "") {
	if (not _checker(_value)) {
		__roomloader_error_method(_prefix, _method_name, $"Could not {_premessage} <{_value}> {_postmessage}.\nExpected \{{_type_name}\}, got \{{typeof(_value)}\}");
	}
}
function __roomloader_catch_string(_prefix, _method_name, _value, _premessage = undefined, _postmessage = undefined) {
	__roomloader_catch_argument(_prefix, _method_name, _value, is_string, "String", _premessage, _postmessage);
}
function __roomloader_catch_array(_prefix, _method_name, _value, _premessage = undefined, _postmessage = undefined) {
	__roomloader_catch_argument(_prefix, _method_name, _value, is_array, "Array", _premessage, _postmessage);
}
