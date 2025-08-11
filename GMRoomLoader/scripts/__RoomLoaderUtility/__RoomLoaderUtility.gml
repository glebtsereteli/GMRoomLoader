/// @feather ignore all

function __RoomLoaderNoop() {}
function __RoomLoaderGetLayer(_data) {
	if (ROOMLOADER_MERGE_LAYERS and layer_exists(_data.name)) {
		return layer_get_id(_data.name);
	}
	
	var _layer = layer_create(_data.depth, _data.name);
	layer_set_visible(_layer, _data.visible);
	layer_x(_layer, _data.xoffset);
	layer_y(_layer, _data.yoffset);
	layer_hspeed(_layer, _data.hspeed);
	layer_vspeed(_layer, _data.vspeed);
	
	return _layer;
}
function __RoomLoaderCheckFlag(_flags) {
	return ((_flags & __flag) == __flag);
}
function __RoomLoaderProcessScript(_script) {
	return ((_script == -1) ? __RoomLoaderNoop : _script);
}

function __RoomLoaderLogBase(_message) {
	show_debug_message($"{__ROOMLOADER_LOG_PREFIX} {_message}.");
}
function __RoomLoaderLog(_message) {
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	
	__RoomLoaderLogBase(_message);
}
function __RoomLoaderLogMethod(_prefix, _methodName, _message) {
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	
	__RoomLoaderLog($"{_prefix}.{_methodName}(): {_message}");
}
function __RoomLoaderLogMethodTimed(_prefix, _methodName, _message, _room) {
	if (not ROOMLOADER_ENABLE_DEBUG) return;
	
	__RoomLoaderLogMethod(_prefix, _methodName, $"{_message} <{room_get_name(_room)}> in {RoomLoader.__benchmark.__get()} milliseconds");
}

function __RoomLoaderEror(_message) {
	show_error($"[{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION}] Error.\n-----------------------------------\n{_message}.\n\n", true);
}
function __RoomLoaderErorMethod(_prefix, _methodName, _message) {
	__RoomLoaderEror($"{_prefix}.{_methodName}(): {_message}");
}

function __RoomLoaderCatchNonRoom(_prefix, _methodName, _room, _message) {
	var _type = typeof(_room);
	if ((_type == "ref") and (room_exists(_room))) return;
	
	__RoomLoaderErorMethod(_prefix, _methodName, $"Could not {_message} <{_room}>.\nExpected \{Asset.GMRoom\}, got \{{_type}\}");
}
function __RoomLoaderCatchArgument(_prefix, _methodName, _value, _checker, _typeName, _preMessage = "use", _postMessage = "") {
	if (not _checker(_value)) {
		__RoomLoaderErorMethod(_prefix, _methodName, $"Could not {_preMessage} <{_value}> {_postMessage}.\nExpected \{{_typeName}\}, got \{{typeof(_value)}\}");
	}
}
function __RoomLoaderCatchString(_prefix, _methodName, _value, _preMessage = undefined, _postMessage = undefined) {
	__RoomLoaderCatchArgument(_prefix, _methodName, _value, is_string, "String", _preMessage, _postMessage);
}
function __RoomLoaderCatchArray(_prefix, _methodName, _value, _preMessage = undefined, _postMessage = undefined) {
	__RoomLoaderCatchArgument(_prefix, _methodName, _value, is_array, "Array", _preMessage, _postMessage);
}
