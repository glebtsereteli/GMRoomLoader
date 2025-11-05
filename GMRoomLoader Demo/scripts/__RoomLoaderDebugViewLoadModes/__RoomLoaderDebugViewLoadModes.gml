
function __RoomLoaderDebugViewLoadMode(_name) constructor {
	__owner = other;
	__name = _name;
	
	static __InitDbg = __RoomLoaderNoop;
}
function __RoomLoaderDebugViewLoadModeRoom() : __RoomLoaderDebugViewLoadMode("Room") constructor {
	static __InitDbg = function() {
		__InitDbgOrigin();
		__InitDbgScale();
		__InitDbgAngle();
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
	static __Load = function() {
		var _payload = RoomLoader
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
		.Load(__room, __posMode.__GetX(), __posMode.__GetY());
		
		RoomLoader.LayerWhitelistReset().LayerBlacklistReset();
		
		array_push(__loadedPayloads, _payload);
	};
}
function __RoomLoaderDebugViewLoadModeInstances() : __RoomLoaderDebugViewLoadMode("Instances") constructor {
	static __InitDbg = function() {
		dbg_text_input(ref_create(self, "__depth"), "Depth", "r");
		__InitDbgOrigin();
		__InitDbgScale();
		__InitDbgAngle();
	};
	static __Load = function() {
		var _instances = RoomLoader
		.Scale(__xScale, __yScale).Angle(__angle)
		.LoadInstances(__room, __posMode.__GetX(), __posMode.__GetY(), __depth);
		
		__loadedInstances = array_concat(__loadedInstances, _instances);
	};
}
function __RoomLoaderDebugViewLoadModeTilemap() : __RoomLoaderDebugViewLoadMode("Tilemap") constructor {
	static __InitDbg = function() {
		dbg_text_input(ref_create(self, "__sourceLayerName"), "Source Layer Name", "s");
		dbg_text_input(ref_create(self, "__targetLayerName"), "Target Layer Name", "s");
		__InitDbgOrigin();
		dbg_checkbox(ref_create(self, "__mirror"), "Mirror?");
		dbg_checkbox(ref_create(self, "__flip"), "Flip?");
		__InitDbgAngle(90);
	};
	static __Load = function() {
		var _tilemap = RoomLoader
		.Mirror(__mirror).Flip(__flip).Angle(__angle)
		.LoadTilemap(__room, __posMode.__GetX(), __posMode.__GetY(), __sourceLayerName, __targetLayerName);
		
		array_push(__loadedTilemaps, _tilemap);
	};
}
