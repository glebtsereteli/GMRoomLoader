
function __RoomLoaderDebugViewPosMode(_name) constructor {
	__name = _name;
	
	static __InitDbg = __RoomLoaderNoop;
	static __GetX = __RoomLoaderNoop;
	static __GetY = __RoomLoaderNoop;
}
function __RoomLoaderDebugViewPosModeMouse() : __RoomLoaderDebugViewPosMode("Mouse") constructor {
	static __GetX = function() {
		return mouse_x;
	};
	static __GetY = function() {
		return mouse_y;
	};
}
function __RoomLoaderDebugViewPosModeCustom() : __RoomLoaderDebugViewPosMode("Custom") constructor {
	static __InitDbg = function() {
		dbg_text_input(ref_create(self, "__x"), "X", "r");
		dbg_text_input(ref_create(self, "__y"), "Y", "r");
	};
	static __GetX = function() {
		return __x;
	};
	static __GetY = function() {
		return __y;
	};
	
	__x = 0;
	__y = 0;
}
