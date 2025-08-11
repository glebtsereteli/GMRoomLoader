
function __RoomLoaderFilter(_name, _positive) constructor {
	__name = _name;
	__positive = _positive;
	__layerNames = [];
	__methodNames = undefined;
	__messagePrefix = RoomLoader.__messagePrefix;
	
	static __Init = function() {
		__check = __CheckEmpty;
		
		var _prefix = $"layer_{string_lower(__name)}";
		__methodNames = {
			__add: $"{_prefix}_add",
			__remove: $"{_prefix}_remove",
			__reset: $"{_prefix}_reset",
		};
	};
	static __CheckEmpty = function() {
		return __positive;
	};
	static __CheckActive = function(_layer_name) {
		return array_contains(__layerNames, _layer_name);	
	};
	static __Add = function(_layer_name) {
		var _method_name = __methodNames.__add;
		__RoomLoaderCatchString(__messagePrefix, _method_name, _layer_name);
		
		if (__GetIndex(_layer_name) != -1) {
			return __RoomLoaderLogMethod(__messagePrefix, _method_name, $"Layer \"{_layer_name}\" is already {__name}ed");
		}
		
		array_push(__layerNames, _layer_name);
		__check = __CheckActive;
		__RoomLoaderLogMethod(__messagePrefix, _method_name, $"{__name}ed layer \"{_layer_name}\"");
	};
	static __Remove = function(_layer_name) {
		var _method_name = __methodNames.__remove;
		__RoomLoaderCatchString(__messagePrefix, _method_name, _layer_name);
		
		var _index = __GetIndex(_layer_name);
		if (_index == -1) {
			return __RoomLoaderLogMethod(__messagePrefix, _method_name, $"Layer \"{_layer_name}\" is not {__name}ed");
		}
		
		array_delete(__layerNames, _index, 1);
		if (__IsEmpty()) {
			__check = __CheckEmpty;
		}
		return __RoomLoaderLogMethod(__messagePrefix, _method_name, $"Removed layer \"{_layer_name}\" from {__name}");
	};
	static __reset = function() {
		var _method_name = __methodNames.__reset;
		if (__IsEmpty()) {
			return __RoomLoaderLogMethod(__messagePrefix, _method_name, $"{__name} is already empty");
		}
		
		__layerNames = [];
		__check = __CheckEmpty;
		__RoomLoaderLogMethod(__messagePrefix, _method_name, $"{__name} is reset");
	};
	static __Get = function() {
		return __layerNames;
	};
	static __GetIndex = function(_layer_name) {
		 return array_get_index(__layerNames, _layer_name);
	};
	static __IsEmpty = function() {
		return (array_length(__layerNames) == 0);
	};
	
	__Init();
}
