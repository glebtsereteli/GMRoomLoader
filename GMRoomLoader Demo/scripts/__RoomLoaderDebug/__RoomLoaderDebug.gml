
function __RoomLoaderDebugView() constructor {
	static __enabled = true;
	
	static __rooms = RoomLoader.__allRooms;
	static __roomNames = undefined;
	static __room = array_first(__rooms);
	
	static __xOrigin = 0;
	static __yOrigin = 0;
	static __xScale = 1;
	static __yScale = 1;
	static __angle = 0;
	static __payloads = [];
	
	static __Init = function(_enabled) {
		__roomNames ??= array_map(__rooms, function(_room) {
			return room_get_name(_room);
		});
		
		call_later(1, time_source_units_frames, function() {
			if (not __enabled) return;
			if (not keyboard_check_pressed(ROOMLOADER_DEBUG_VIEW_LOAD_KEY)) return;
			if (not is_debug_overlay_open()) return;
			
			if (not RoomLoader.DataIsInitialized(__room)) {
				RoomLoader.DataInit(__room);
			}
			
			var _payload = RoomLoader
			.Origin(__xOrigin, __yOrigin)
			.Scale(__xScale, __yScale)
			.Angle(__angle)
			.Load(__room, mouse_x, mouse_y);
			
			array_push(__payloads, _payload);
		}, true);
		
		dbg_view(ROOMLOADER_DEBUG_VIEW_NAME, ROOMLOADER_DEBUG_VIEW_START_VISIBLE);
		
		dbg_checkbox(ref_create(self, "__enabled"), "Enabled");
		
		dbg_text_separator("");
		
		dbg_drop_down(ref_create(self, "__room"), __rooms, __roomNames, "Room");
		dbg_same_line();
		dbg_button("-", function() { __CycleRoom(-1); }, 20, 20);
		dbg_same_line();
		dbg_button("+", function() { __CycleRoom(1); }, 20, 20);
		
		dbg_slider(ref_create(self, "__xOrigin"), 0, 1, "X Origin", 0.05);
		dbg_slider(ref_create(self, "__yOrigin"), 0, 1, "Y Origin", 0.05);
		dbg_slider(ref_create(self, "__xScale"), -2, 2, "X Scale", 0.05);
		dbg_slider(ref_create(self, "__yScale"), -2, 2, "Y Scale", 0.05);
		dbg_slider_int(ref_create(self, "__angle"), 0, 360, "Angle", 5);
		
		dbg_text_separator("");
		
		dbg_button("Cleanup", function() {
			array_foreach(__payloads, function(_payload) {
				_payload.Cleanup();
			});
			__payloads = [];
		});
	};
	static __CycleRoom = function(_dir) {
		var _n = array_length(__rooms);
		var _index = (array_get_index(__rooms, __room) + _dir + _n) mod _n;
		__room = __rooms[_index];
	};
}
