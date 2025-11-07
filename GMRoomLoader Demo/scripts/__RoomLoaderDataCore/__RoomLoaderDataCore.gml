// feather ignore all

function __RoomLoaderDataCore() constructor {
	static __messagePrefix = RoomLoader.__messagePrefix;
	
	__pool = {};
	
	static __Add = function(_room, _methodName) {
		__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, "initialize data for");
		
		var _roomName = room_get_name(_room);
		if (struct_exists(__pool, _roomName)) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Data for <{_roomName}> is already initialized");
			return;
		}
		
		__ROOMLOADER_BENCH_START;
		var _data = new __RoomLoaderDataRoom(_room);
		__pool[$ _roomName] = _data;
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, "Initialized data for", _room);
		
		return _data;
	};
	static __Remove = function(_room, _methodName) {
		__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, "remove data for");
		
		var _roomName = room_get_name(_room);
		if (not struct_exists(__pool, _roomName)) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Data for <{_roomName}> doesn't exist, there's nothing to remove");
			return;
		}
		
		struct_remove(__pool, _roomName);
		__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Removed data for <{_roomName}>");
	};
	static __Get = function(_room, _methodName) {
		return (__pool[$ room_get_name(_room)] ?? __Add(_room, _methodName));
	};
}
