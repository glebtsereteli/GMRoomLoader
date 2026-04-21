// feather ignore all

function __RoomLoaderNoop() {}
function __RoomLoaderLogBase(_message) {
	show_debug_message($"[{__ROOMLOADER_NAME}] {_message}.");
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
	
	_message = $"{_message} <{room_get_name(_room)}> in {__ROOMLOADER_BENCH_END} milliseconds";
	__RoomLoaderLogMethod(_prefix, _methodName, _message);
}

function __RoomLoaderError(_message) {
	show_error($"[{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION}] Error.\n-----------------------------------\n{_message}.\n\n", true);
}
function __RoomLoaderErrorMethod(_prefix, _methodName, _message) {
	__RoomLoaderError($"{_prefix}.{_methodName}(): {_message}");
}

function __RoomLoaderCatchNonRoom(_prefix, _methodName, _room, _message) {
	var _type = typeof(_room);
	if ((_type == "ref") and (room_exists(_room))) return;
	
	_message = $"Could not {_message} <{_room}>.\nExpected <Asset.GMRoom>, got <{_type}>";
	__RoomLoaderErrorMethod(_prefix, _methodName, _message);
}
function __RoomLoaderCatchArgument(_prefix, _methodName, _value, _checker, _typeName, _preMessage = "use", _postMessage = "") {
	if (not _checker(_value)) {
		var _message = $"Could not {_preMessage} <{_value}> {_postMessage}.\nExpected <{_typeName}>, got <{typeof(_value)}>";
		__RoomLoaderErrorMethod(_prefix, _methodName, _message);
	}
}
function __RoomLoaderCatchString(_prefix, _methodName, _value, _preMessage = undefined, _postMessage = undefined) {
	__RoomLoaderCatchArgument(_prefix, _methodName, _value, is_string, "String", _preMessage, _postMessage);
}
function __RoomLoaderCatchArray(_prefix, _methodName, _value, _preMessage = undefined, _postMessage = undefined) {
	__RoomLoaderCatchArgument(_prefix, _methodName, _value, is_array, "Array", _preMessage, _postMessage);
}
