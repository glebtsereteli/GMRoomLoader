
function __RoomLoaderDebugViewPosMode(_name) constructor {
	__name = _name;
	
	static __InitDbg = __RoomLoaderNoop;
	static __GetX = __RoomLoaderNoop;
	static __GetY = __RoomLoaderNoop;
}
function __RoomLoaderDebugViewPosModeMouse() : __RoomLoaderDebugViewPosMode("Mouse") constructor {
	static __InitDbg = function() {
		dbg_checkbox(ref_create(self, "__gui"), "In GUI Space?");
	};
	static __GetX = function() {
		return (__gui ? device_mouse_x_to_gui(0) : mouse_x);
	};
	static __GetY = function() {
		return (__gui ? device_mouse_y_to_gui(0) : mouse_y);
	};
	
	__gui = false;
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
function __RoomLoaderDebugViewPosModeRandom() : __RoomLoaderDebugViewPosMode("Random") constructor {
	static __InitDbg = function() {
		dbg_text_input(ref_create(self, "__x1"), "X1", "r");
		dbg_text_input(ref_create(self, "__y1"), "Y1", "r");
		dbg_text_input(ref_create(self, "__x2"), "X2", "r");
		dbg_text_input(ref_create(self, "__y2"), "Y2", "r");
	};
	static __GetX = function() {
		return irandom_range(__x1, __x2);
	};
	static __GetY = function() {
		return irandom_range(__y1, __y2);
	};
	
	__x1 = 0;
	__y1 = 0;
	__x2 = 1000;
	__y2 = 1000;
}
function __RoomLoaderDebugViewPosModeGetters() : __RoomLoaderDebugViewPosMode("Getters") constructor {
	static __InitDbg = function() {
		dbg_text(" X Getter: " + ((ROOMLOADER_DEBUG_VIEW_GET_X != undefined) 
			? script_get_name(ROOMLOADER_DEBUG_VIEW_GET_X) + "()"
			: "MISSING! Set the ROOMLOADER_DEBUG_VIEW_GET_X config macro."
		));
		dbg_text(" Y Getter: " + ((ROOMLOADER_DEBUG_VIEW_GET_Y != undefined) 
			? script_get_name(ROOMLOADER_DEBUG_VIEW_GET_Y) + "()"
			: "MISSING! Set the ROOMLOADER_DEBUG_VIEW_GET_Y config macro."
		));
	};
	static __GetX = function() {
		return ((ROOMLOADER_DEBUG_VIEW_GET_X != undefined) ? ROOMLOADER_DEBUG_VIEW_GET_X : 0);
	};
	static __GetY = function() {
		return ((ROOMLOADER_DEBUG_VIEW_GET_Y != undefined) ? ROOMLOADER_DEBUG_VIEW_GET_Y : 0);
	};
}
