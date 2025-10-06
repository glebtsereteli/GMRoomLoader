/// feather ignore all
/// Documentation: https://glebtsereteli.github.io/GMRoomLoader/pages/api/debugView/debugView

function __RoomLoaderDebugView() constructor {
	static __view = undefined;
	static __sectionMain = undefined;
	static __sectionFlags = undefined;
	static __sectionWhitelist = undefined;
	static __sectionBlacklist = undefined;
	
	static __rooms = ROOMLOADER_DEBUG_VIEW_ROOMS ?? RoomLoader.__allRooms;
	static __roomNames = undefined;
	static __loadedPayloads = [];
	static __loadedInstances = [];
	static __loadedTilemaps = [];
	
	static __enabled = true;
	static __room = array_first(__rooms);
	static __prevRoom = undefined;
	
	static __modes = [
		new __RoomLoaderDebugViewModeFullRoom(),
		new __RoomLoaderDebugViewModeInstances(),
		new __RoomLoaderDebugViewModeTilemap(),
	];
	static __modeNames = array_map(__modes, function(_mode) {
		return _mode.__name;
	});
	static __mode = __modes[0];
	static __prevMode = __mode;
	
	static __depth = 0;
	static __sourceLayerName = "Tiles";
	static __targetLayerName = "Tiles";
	static __xOrigin = 0;
	static __yOrigin = 0;
	static __xScale = 1;
	static __yScale = 1;
	static __mirror = false;
	static __flip = false;
	static __angle = 0;
	static __flags = [];
	static __instances = true;
	static __tilemaps = true;
	static __sprites = true;
	static __sequences = true;
	static __texts = true;
	static __backgrounds = true;
	static __layerNames = undefined;
	static __layerWhitelist = undefined;
	static __layerBlacklist = undefined;
	
	static __RefreshView = function(_enabled) {
		__RefreshData();
		
		var _viewExists = dbg_view_exists(__view);
		if (not _viewExists) {
			__roomNames = array_map(__rooms, function(_room) {
				return room_get_name(_room);
			});
			call_later(1, time_source_units_frames, function() {
				if (not is_debug_overlay_open()) return;
				
				if (__RefreshData()) {
					__RefreshView();
				}
				
				if (not __enabled) return;
				if (not keyboard_check_pressed(ROOMLOADER_DEBUG_VIEW_LOAD_KEY)) return;
				
				RoomLoader.Origin(__xOrigin, __yOrigin);
				method(self, __mode.__Load)();
			}, true);
		}
		else {
			dbg_view_delete(__view);
			dbg_section_delete(__sectionMain);
			dbg_section_delete(__sectionFlags);
			dbg_section_delete(__sectionWhitelist);
			dbg_section_delete(__sectionBlacklist);
		}
		
		__view = dbg_view("RoomLoader Debug", (_viewExists or ROOMLOADER_DEBUG_VIEW_START_VISIBLE));
		__sectionMain = dbg_section("Main", true); {
			dbg_checkbox(ref_create(self, "__enabled"), "Enabled");
			dbg_same_line();
			dbg_button("Cleanup", function() {
				array_foreach(__loadedPayloads, function(_payload) {
					_payload.Cleanup();
				});
				__loadedPayloads = [];
				
				array_foreach(__loadedInstances, function(_inst) {
					instance_destroy(_inst);
				});
				__loadedInstances = [];
				
				array_foreach(__loadedTilemaps, function(_tilemap) {
					layer_tilemap_destroy(_tilemap);
				});
				__loadedTilemaps = [];
			},, 20);
			
			dbg_text_separator("");
			
			dbg_drop_down(ref_create(self, "__room"), __rooms, __roomNames, "Room");
			dbg_same_line();
			dbg_button("-", function() { __CycleRoom(-1); }, 20, 20);
			dbg_same_line();
			dbg_button("+", function() { __CycleRoom(1); }, 20, 20);
			
			dbg_drop_down(ref_create(self, "__mode"), __modes, __modeNames, "Mode");
			dbg_same_line();
			dbg_button("-", function() { __CycleMode(-1); }, 20, 20);
			dbg_same_line();
			dbg_button("+", function() { __CycleMode(1); }, 20, 20);
			
			method(self, __mode.__InitDbg)();
		}
	};
	static __RefreshData = function() {
		if ((__room == __prevRoom) and (__mode == __prevMode)) return false;
		
		__prevRoom = __room;
		__prevMode = __mode;
		
		if (not RoomLoader.DataIsInitialized(__room)) {
			RoomLoader.DataInit(__room);
		}
		
		__layerNames = RoomLoader.DataGetLayerNames(__room);
		__layerWhitelist = array_create(array_length(__layerNames), false);
		__layerBlacklist = array_create(array_length(__layerNames), false);
		
		return true;
	};
	static __CycleRoom = function(_dir) {
		var _n = array_length(__rooms);
		var _index = (array_get_index(__rooms, __room) + _dir + _n) mod _n;
		__room = __rooms[_index];
	};
	static __CycleMode = function(_dir) {
		var _n = array_length(__modes);
		var _index = (array_get_index(__modes, __mode) + _dir + _n) mod _n;
		__mode = __modes[_index];
	};
	
	static __InitDbgOrigin = function() {
		dbg_slider(ref_create(self, "__xOrigin"), 0, 1, "X Origin", 0.05);
		dbg_slider(ref_create(self, "__yOrigin"), 0, 1, "Y Origin", 0.05);
	};
	static __InitDbgScale = function() {
		dbg_slider(ref_create(self, "__xScale"), -2, 2, "X Scale", 0.05);
		dbg_slider(ref_create(self, "__yScale"), -2, 2, "Y Scale", 0.05);
	};
	static __InitDbgAngle = function(_increment = 5) {
		dbg_slider_int(ref_create(self, "__angle"), 0, 360, "Angle", _increment);
	};
}
