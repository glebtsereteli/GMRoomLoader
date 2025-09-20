
function __RoomLoaderLayerFilter(_name, _positive) constructor {
	__name = _name;
	__positive = _positive;
	__layerNames = [];
	__methodNames = undefined;
	__messagePrefix = RoomLoader.__messagePrefix;
	
	static __Init = function() {
		__check = __CheckEmpty;
		
		var _prefix = $"Layer{__name}";
		__methodNames = {
			__add: $"{_prefix}Add",
			__remove: $"{_prefix}Remove",
			__set: $"{_prefix}Set",
			__reset: $"{_prefix}Reset",
		};
	};
	static __CheckEmpty = function() {
		return __positive;
	};
	static __CheckActive = function(_layerName) {
		return array_contains(__layerNames, _layerName);	
	};
	static __Add = function(_layerName) {
		var _methodName = __methodNames.__add;
		__RoomLoaderCatchString(__messagePrefix, _methodName, _layerName);
		
		if (__GetIndex(_layerName) != -1) {
			return __RoomLoaderLogMethod(__messagePrefix, _methodName, $"Layer \"{_layerName}\" is already {__name}ed");
		}
		
		array_push(__layerNames, _layerName);
		__check = __CheckActive;
		__RoomLoaderLogMethod(__messagePrefix, _methodName, $"{__name}ed layer \"{_layerName}\"");
	};
	static __Remove = function(_layerName) {
		var _methodName = __methodNames.__remove;
		__RoomLoaderCatchString(__messagePrefix, _methodName, _layerName);
		
		var _index = __GetIndex(_layerName);
		if (_index == -1) {
			return __RoomLoaderLogMethod(__messagePrefix, _methodName, $"Layer \"{_layerName}\" is not {__name}ed");
		}
		
		array_delete(__layerNames, _index, 1);
		if (__IsEmpty()) {
			__check = __CheckEmpty;
		}
		return __RoomLoaderLogMethod(__messagePrefix, _methodName, $"Removed layer \"{_layerName}\" from {__name}");
	};
	static __Set = function(_layerNames) {
		var _methodName = __methodNames.__set;
		
		__layerNames = _layerNames;
		__check = (__IsEmpty() ? __CheckEmpty : __CheckActive);
		
		return __RoomLoaderLogMethod(__messagePrefix, _methodName, $"Set {__name} to: {_layerNames}");
	};
	static __Reset = function() {
		var _methodName = __methodNames.__reset;
		if (__IsEmpty()) {
			return __RoomLoaderLogMethod(__messagePrefix, _methodName, $"{__name} is already empty");
		}
		
		__layerNames = [];
		__check = __CheckEmpty;
		__RoomLoaderLogMethod(__messagePrefix, _methodName, $"{__name} is reset");
	};
	static __Get = function() {
		return __layerNames;
	};
	static __GetIndex = function(_layerName) {
		 return array_get_index(__layerNames, _layerName);
	};
	static __IsEmpty = function() {
		return (array_length(__layerNames) == 0);
	};
	
	__Init();
}
