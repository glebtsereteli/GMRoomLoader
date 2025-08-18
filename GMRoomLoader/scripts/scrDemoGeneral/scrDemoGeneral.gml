
function DemoGeneral() : DemoPar("General") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInit(rm);
		
		// Whitelist & Blacklist:
		layer_set_target_room(rm);
		whitelist = array_map(layer_get_all(), function(_layer) {
			return {
				name: layer_get_name(_layer),
				enabled: false,
			}
		});
		blacklist = variable_clone(whitelist);
		layer_reset_target_room();
		
		// Interface:
		DEMOS.info = dbg_section("Info");
		dbg_text("This demo showcases the main \"RoomLoader.Load()\" method for general\nroom loading. Use the controls below to adjust the loading position,\norigin, flags, layer whitelist and blacklist.");
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
		reloader
		.Clear()
		.AddModules([pos, origin, flags])
		.OnTrigger(function() {
			Load();
		});
		array_foreach(whitelist, function(_layer) {
			reloader.addVariable(_layer, "enabled");
		});
		array_foreach(blacklist, function(_layer) {
			reloader.addVariable(_layer, "enabled");
		});
	};
	static Draw = function() {
		DemoDrawFrame(rm, pos.x, pos.y, origin);
	};
	static Cleanup = function() {
		RoomLoader.DataRemove(rm);
		Unload();
	};
	
	static OnUpdate = function() {
		if (keyboard_check_pressed(ord("1"))) Load();
		if (keyboard_check_pressed(ord("2"))) Unload();
	};
	
	// Custom:
	rm = rmDemoGeneral01;
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
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
