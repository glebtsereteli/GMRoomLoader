
function __RoomLoaderFilter(_name, _positive) constructor {
	__name = _name;
	__positive = _positive;
	__layer_names = [];
	__method_names = undefined;
	__message_prefix = RoomLoader.__message_prefix;
	
	static __init = function() {
		__check = __check_empty;
		
		var _prefix = $"layer_{string_lower(__name)}";
		__method_names = {
			__add: $"{_prefix}_add",
			__remove: $"{_prefix}_remove",
			__reset: $"{_prefix}_reset",
		};
	};
	static __check_empty = function() {
		return __positive;
	};
	static __check_active = function(_layer_name) {
		return array_contains(__layer_names, _layer_name);	
	};
	static __add = function(_layer_name) {
		var _method_name = __method_names.__add;
		__roomloader_catch_string(__message_prefix, _method_name, _layer_name);
		
		if (__get_index(_layer_name) != -1) {
			return __roomloader_log_method(__message_prefix, _method_name, $"Layer \"{_layer_name}\" is already {__name}ed");
		}
		
		array_push(__layer_names, _layer_name);
		__check = __check_active;
		__roomloader_log_method(__message_prefix, _method_name, $"{__name}ed layer \"{_layer_name}\"");
	};
	static __remove = function(_layer_name) {
		var _method_name = __method_names.__remove;
		__roomloader_catch_string(__message_prefix, _method_name, _layer_name);
		
		var _index = __get_index(_layer_name);
		if (_index == -1) {
			return __roomloader_log_method(__message_prefix, _method_name, $"Layer \"{_layer_name}\" is not {__name}ed");
		}
		
		array_delete(__layer_names, _index, 1);
		if (__is_empty()) {
			__check = __check_empty;
		}
		return __roomloader_log_method(__message_prefix, _method_name, $"Removed layer \"{_layer_name}\" from {__name}");
	};
	static __reset = function() {
		var _method_name = __method_names.__reset;
		if (__is_empty()) {
			return __roomloader_log_method(__message_prefix, _method_name, $"{__name} is already empty");
		}
		
		__layer_names = [];
		__check = __check_empty;
		__roomloader_log_method(__message_prefix, _method_name, $"{__name} is reset");
	};
	static __get = function() {
		return __layer_names;
	};
	static __get_index = function(_layer_name) {
		 return array_get_index(__layer_names, _layer_name);
	};
	static __is_empty = function() {
		return (array_length(__layer_names) == 0);
	};
	
	__init();
}
