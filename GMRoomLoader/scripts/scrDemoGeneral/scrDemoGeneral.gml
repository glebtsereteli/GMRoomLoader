
function DemoGeneral() : DemoPar("General") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInit(rm);
		
		// Whitelist & Blacklist:
		var _layerNames = RoomLoader.DataGetLayerNames(rm);
		whitelist = array_map(_layerNames, function(_layer) {
			return {
				name: _layer,
				enabled: false,
			};
		});
		blacklist = variable_clone(whitelist);
		
		// Interface:
		DEMOS.info = dbg_section("Info");
		dbg_text("This demo shows the main \"RoomLoader.Load/LoadExt()\" methods for full\nroom loading. Use the controls below to adjust the loading position,\norigin, Flags, layer Whitelist and Blacklist.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to load the room.");
		dbg_text("- [PRESS 2] to clean up the room.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Load", function() {
			Load();
		});
		dbg_same_line();
		dbg_button("Clean Up", function() {
			Unload();
		});
		
		pos.InitDbg();
		origin.InitDbg();
		
		dbg_text_separator("Transform", 1);
		dbg_slider(ref_create(self, "xScale"), -2, 2, "X Scale", 0.1);
		dbg_slider(ref_create(self, "yScale"), -2, 2, "Y Scale", 0.1);
		dbg_slider_int(ref_create(self, "angle"), -180, 180, "Angle", 10);
		
		flags.InitDbg();
		
		dbg_text_separator("Layer Whitelist", 1);
		array_foreach(whitelist, function(_layer) {
			dbg_checkbox(ref_create(_layer, "enabled"), _layer.name);
		});
		
		dbg_text_separator("Layer Blacklist", 1);
		array_foreach(blacklist, function(_layer) {
			dbg_checkbox(ref_create(_layer, "enabled"), _layer.name);
		});
	
		// Reloader:
		owner.reloader
		.AddVariables(self, ["xScale", "yScale", "angle"])
		.AddModules([pos, origin, flags])
		.OnTrigger(function() {
			Load();
		});
		array_foreach(whitelist, function(_layer) {
			owner.reloader.AddVariable(_layer, "enabled");
		});
		array_foreach(blacklist, function(_layer) {
			owner.reloader.AddVariable(_layer, "enabled");
		});
	};
	static Draw = function() {
		DemoDrawFrame(rm, pos.x, pos.y, origin);
	};
	
	static OnUpdate = function() {
		if (keyboard_check_pressed(ord("1"))) Load();
		if (keyboard_check_pressed(ord("2"))) Unload();
	};
	static OnCleanup = function() {
		RoomLoader.DataRemove(rm);
		Unload();
	};
	
	// Custom:
	rm = rmDemoGeneral01;
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
	xScale = 1;
	yScale = 1;
	angle = 0;
	flags = new DemoModuleFlags();
	whitelist = undefined;
	blacklist = undefined;
	
	static Load = function() {
		Unload();
		array_foreach(whitelist, function(_layer) {
			if (_layer.enabled) {
				RoomLoader.LayerWhitelistAdd(_layer.name);
			}
		});
		array_foreach(blacklist, function(_layer) {
			if (_layer.enabled) {
				RoomLoader.LayerBlacklistAdd(_layer.name);
			}
		});
		DEMO_PAYLOAD = RoomLoader.Load(rm, pos.x, pos.y, origin.x, origin.y, flags.get());
		RoomLoader.LayerWhitelistReset();
		RoomLoader.LayerBlacklistReset();
	};
	static Unload = function() {
		if (DEMO_PAYLOAD == undefined) return;
		
		DEMO_PAYLOAD.Cleanup();
		delete DEMO_PAYLOAD;
	};
}
