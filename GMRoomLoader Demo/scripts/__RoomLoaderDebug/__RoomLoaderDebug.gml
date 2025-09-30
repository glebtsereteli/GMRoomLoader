
function __RoomLoaderDebugView(_rooms) constructor {
	static __view = undefined;
	static __rooms = _rooms;
	static __roomNames = undefined;
	
	static __room = array_first(__rooms);
	static __xOrigin = 0;
	static __yOrigin = 0;
	static __xScale = 1;
	static __yScale = 1;
	static __angle = 0;
	static __payloads = [];
	
	static __keys = [];
	static __keyNames = [];
	static __key = vk_space;
	
	static __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, method(self, function() {
		if (not keyboard_check_pressed(__key)) return;
		
		if (not RoomLoader.DataIsInitialized(__room)) {
			RoomLoader.DataInit(__room);
		}
		
		var _payload = RoomLoader
		.Origin(__xOrigin, __yOrigin)
		.Scale(__xScale, __yScale)
		.Angle(__angle)
		.Load(__room, mouse_x, mouse_y);
		
		array_push(__payloads, _payload);
	}), [], -1);
	
	static __Refresh = function() {
		__roomNames ??= array_map(__rooms, function(_room) {
			return room_get_name(_room);
		});
		
		if (dbg_view_exists(__view)) {
			dbg_view_delete(__view);
		}
		
		if (time_source_get_state(__timeSource) != time_source_state_active) {
			time_source_start(__timeSource);
		}
		
		__view = dbg_view(__ROOMLOADER_NAME, true);
		
		dbg_drop_down(ref_create(self, "__room"), __rooms, __roomNames, "Room");
		dbg_same_line();
		dbg_button("-", function() {
			__CycleRoom(-1);
		}, 20, 20);
		dbg_same_line();
		dbg_button("+", function() {
			__CycleRoom(1);
		}, 20, 20);
		
		dbg_text_separator("Origin", 1);
		dbg_slider(ref_create(self, "__xOrigin"), 0, 1, "X", 0.1);
		dbg_slider(ref_create(self, "__yOrigin"), 0, 1, "Y", 0.1);
		dbg_text_separator("Transform", 1);
		dbg_slider(ref_create(self, "__xScale"), -2, 2, "X", 0.1);
		dbg_slider(ref_create(self, "__yScale"), -2, 2, "Y", 0.1);
		dbg_slider_int(ref_create(self, "__angle"), 0, 360, "Angle", 5);
	
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
