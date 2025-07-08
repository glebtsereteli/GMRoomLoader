
function DemoGeneral() : DemoPar("General") constructor {
	// Shared:
	static init = function() {
		RoomLoader.data_init(rm);
		
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
		dbg_text("This demo showcases the main \"RoomLoader.load()\" method for general\nroom loading. Use the controls below to adjust the loading position,\norigin, flags, layer whitelist and blacklist.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to load the room.");
		dbg_text("- [PRESS 2] to clean up the room.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Load", function() {
			load();
		});
		dbg_same_line();
		dbg_button("Clean Up", function() {
			unload();
		});
		
		pos.init_dbg();
		origin.init_dbg();
		flags.init_dbg();
		
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
		.clear()
		.add_modules([pos, origin, flags])
		.on_trigger(function() {
			load();
		});
		array_foreach(whitelist, function(_layer) {
			reloader.add_variable(_layer, "enabled");
		});
		array_foreach(blacklist, function(_layer) {
			reloader.add_variable(_layer, "enabled");
		});
	};
	static draw = function() {
		demo_draw_frame(rm, pos.x, pos.y, origin);
	};
	static cleanup = function() {
		RoomLoader.data_remove(rm);
		unload();
	};
	
	static on_update = function() {
		if (keyboard_check_pressed(ord("1"))) load();
		if (keyboard_check_pressed(ord("2"))) unload();
	};
	
	// Custom:
	rm = rm_demo_general_01;
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
	flags = new DemoModuleFlags();
	whitelist = undefined;
	blacklist = undefined;
	
	static load = function() {
		unload();
		array_foreach(whitelist, function(_layer) {
			if (_layer.enabled) {
				RoomLoader.layer_whitelist_add(_layer.name);
			}
		});
		array_foreach(blacklist, function(_layer) {
			if (_layer.enabled) {
				RoomLoader.layer_blacklist_add(_layer.name);
			}
		});
		DEMO_ROOM_DATA = RoomLoader.load(rm, pos.x, pos.y, origin.x, origin.y, flags.get());
		RoomLoader.layer_whitelist_reset();
		RoomLoader.layer_blacklist_reset();
	};
	static unload = function() {
		if (DEMO_ROOM_DATA == undefined) return;
		
		DEMO_ROOM_DATA.cleanup();
		delete DEMO_ROOM_DATA;
	};
}
