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
	static __payloads = [];
	
	static __enabled = true;
	static __room = array_first(__rooms);
	static __prevRoom = undefined;
	static __xOrigin = 0;
	static __yOrigin = 0;
	static __xScale = 1;
	static __yScale = 1;
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
				
				var _payload = RoomLoader
				.Origin(__xOrigin, __yOrigin)
				.Scale(__xScale, __yScale).Angle(__angle)
				.Flags(
					__instances * ROOMLOADER_FLAG.INSTANCES |
					__tilemaps * ROOMLOADER_FLAG.TILEMAPS |
					__sprites * ROOMLOADER_FLAG.SPRITES |
					__sequences * ROOMLOADER_FLAG.SEQUENCES |
					__texts * ROOMLOADER_FLAG.TEXTS |
					__backgrounds * ROOMLOADER_FLAG.BACKGROUNDS
				)
				.LayerWhitelistSet(array_filter(__layerNames, function(_layerName, _i) { return __layerWhitelist[_i]; }))
				.LayerBlacklistSet(array_filter(__layerNames, function(_layerName, _i) { return __layerBlacklist[_i]; }))
				.Load(__room, mouse_x, mouse_y);
				
				RoomLoader.LayerWhitelistReset().LayerBlacklistReset();
				
				array_push(__payloads, _payload);
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
				array_foreach(__payloads, function(_payload) {
					_payload.Cleanup();
				});
				__payloads = [];
			},, 20);
			
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
		}
		__sectionFlags = dbg_section("Flags", false); {
			dbg_checkbox(ref_create(self, "__instances"), "Instances");
			dbg_checkbox(ref_create(self, "__tilemaps"), "Tilemaps");
			dbg_checkbox(ref_create(self, "__sprites"), "Sprites");
			dbg_checkbox(ref_create(self, "__sequences"), "Sequences");
			dbg_checkbox(ref_create(self, "__texts"), "Texts");
			dbg_checkbox(ref_create(self, "__backgrounds"), "Backgrounds");
		}
		__sectionWhitelist = dbg_section("Layer Whitelist", false); {
			array_foreach(__layerNames, function(_layerName, _i) {
				dbg_checkbox(ref_create(self, "__layerWhitelist", _i), _layerName);
			});
		}
		__sectionBlacklist = dbg_section("Layer Blacklist", false); {
			array_foreach(__layerNames, function(_layerName, _i) {
				dbg_checkbox(ref_create(self, "__layerBlacklist", _i), _layerName);
			});
		}
	};
	static __RefreshData = function() {
		if (__room == __prevRoom) return false;
		
		__prevRoom = __room;
		
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
}
