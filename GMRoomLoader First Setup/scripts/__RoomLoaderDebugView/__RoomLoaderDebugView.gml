// feather ignore all
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
	
	static __loadModes = [
		new __RoomLoaderDebugViewLoadModeRoom(),
		new __RoomLoaderDebugViewLoadModeInstances(),
		new __RoomLoaderDebugViewLoadModeTilemap(),
	];
	static __loadModesNames = array_map(__loadModes, function(_mode) {
		return _mode.__name;
	});
	static __loadMode = __loadModes[0];
	static __prevLoadMode = __loadMode;
	
	static __posModes = [
		new __RoomLoaderDebugViewPosModeMouse(),
		new __RoomLoaderDebugViewPosModeCustom(),
		new __RoomLoaderDebugViewPosModeRandom(),
		new __RoomLoaderDebugViewPosModeGetters(),
	];
	static __posModesNames = array_map(__posModes, function(_mode) {
		return _mode.__name;
	});
	static __posMode = __posModes[0];
	static __posLoadMode = __posMode;
	
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
		
		if (not dbg_view_exists(__view)) {
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
				method(self, __loadMode.__Load)();
			}, true);
			
			__view = dbg_view("RoomLoader Debug", ROOMLOADER_DEBUG_VIEW_START_VISIBLE,,,, 500);
		}
		else {
			dbg_section_delete(__sectionMain);
			dbg_section_delete(__sectionFlags);
			dbg_section_delete(__sectionWhitelist);
			dbg_section_delete(__sectionBlacklist);
		}
		
		dbg_set_view(__view);
		
		__sectionMain = dbg_section("Main", true);
		var _buttonSize = 19;
		
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
		},, _buttonSize);
		
		dbg_text_separator("");
		
		dbg_drop_down(ref_create(self, "__room"), __rooms, __roomNames, "Room");
		dbg_same_line();
		dbg_button("-", function() { __CycleRoom(-1); }, _buttonSize, _buttonSize);
		dbg_same_line();
		dbg_button("+", function() { __CycleRoom(1); }, _buttonSize, _buttonSize);
		
		dbg_drop_down(ref_create(self, "__loadMode"), __loadModes, __loadModesNames, "Load Mode");
		dbg_same_line();
		dbg_button("-", function() { __CycleLoadMode(-1); }, _buttonSize, _buttonSize);
		dbg_same_line();
		dbg_button("+", function() { __CycleLoadMode(1); }, _buttonSize, _buttonSize);
		
		dbg_text_separator("");
		
		dbg_drop_down(ref_create(self, "__posMode"), __posModes, __posModesNames, "Position Mode");
		dbg_same_line();
		dbg_button("-", function() { __CyclePosMode(-1); }, _buttonSize, _buttonSize);
		dbg_same_line();
		dbg_button("+", function() { __CyclePosMode(1); }, _buttonSize, _buttonSize);
		
		__posMode.__InitDbg();
		
		dbg_text_separator("");
		
		method(self, __loadMode.__InitDbg)();
	};
	static __RefreshData = function() {
		if ((__room == __prevRoom) and (__loadMode == __prevLoadMode) and (__posMode == __prevPosMode)) return false;
		
		__prevRoom = __room;
		__prevLoadMode = __loadMode;
		__prevPosMode = __posMode;
		
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
	static __CycleLoadMode = function(_dir) {
		var _n = array_length(__loadModes);
		var _index = (array_get_index(__loadModes, __loadMode) + _dir + _n) mod _n;
		__loadMode = __loadModes[_index];
	};
	static __CyclePosMode = function(_dir) {
		var _n = array_length(__posModes);
		var _index = (array_get_index(__posModes, __posMode) + _dir + _n) mod _n;
		__posMode = __posModes[_index];
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
