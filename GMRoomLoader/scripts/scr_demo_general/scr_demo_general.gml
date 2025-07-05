
function DemoGeneral() : Demo("General") constructor {
	// Shared:
	static init = function() {
		x = DEMOS.xcenter;
		y = DEMOS.ycenter;
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
		dbg_text("- [PRESS 2] to unload the room.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Load", function() {
			load();
		});
		dbg_same_line();
		dbg_button("Unload", function() {
			unload();
		});
		
		dbg_text_separator("Position", 1);
		dbg_slider_int(ref_create(self, "x"), 0, room_width, "X", 10);
		dbg_slider_int(ref_create(self, "y"), 0, room_height, "Y", 10);
		
		dbg_text_separator("Origin", 1);
		dbg_slider(ref_create(self, "xorigin"), 0, 1, "X", 0.1);
		dbg_slider(ref_create(self, "yorigin"), 0, 1, "Y", 0.1);
		
		dbg_text_separator("Flags", 1);
		dbg_checkbox(ref_create(flags, "instances"), "Instances");
		dbg_checkbox(ref_create(flags, "tilemaps"), "Tilemaps");
		dbg_checkbox(ref_create(flags, "sprites"), "Sprites");
		dbg_checkbox(ref_create(flags, "particle_systems"), "Particle Systems");
		dbg_checkbox(ref_create(flags, "sequences"), "Sequences");
		dbg_checkbox(ref_create(flags, "texts"), "Texts");
		dbg_checkbox(ref_create(flags, "backgrounds"), "Backgrounds");
		
		dbg_text_separator("Layer Whitelist", 1);
		array_foreach(whitelist, function(_layer) {
			dbg_checkbox(ref_create(_layer, "enabled"), _layer.name);
		});
		
		dbg_text_separator("Layer Blacklist", 1);
		array_foreach(blacklist, function(_layer) {
			dbg_checkbox(ref_create(_layer, "enabled"), _layer.name);
		});
	};
	static update = function() {
		if (keyboard_check_pressed(ord("1"))) load();
		if (keyboard_check_pressed(ord("2"))) unload();
	};
	static draw = function() {
		var _w = RoomLoader.data_get_width(rm);
		var _h = RoomLoader.data_get_height(rm);
		var _x = floor(x - (_w * xorigin));
		var _y = floor(y - (_h * yorigin));
		draw_sprite_stretched(spr_demo_frame, 0, _x, _y, _w, _h);
		draw_sprite(spr_demo_cross, 0, x, y);
	};
	static cleanup = function() {
		RoomLoader.data_remove(rm);
		unload();
	};
	
	// Custom:
	rm = rm_demo_general_01;
	x = undefined;
	y = undefined;
	xorigin = 0.5;
	yorigin = 0.5;
	flags = {
		instances: true,
		tilemaps: true,
		sprites: true,
		particle_systems: true,
		sequences: true,
		texts: true,
		backgrounds: true,
		
		get: function() {
			var _total = ROOMLOADER_FLAG.NONE;
			_total |= instances * ROOMLOADER_FLAG.INSTANCES;
			_total |= tilemaps * ROOMLOADER_FLAG.TILEMAPS;
			_total |= sprites * ROOMLOADER_FLAG.SPRITES;
			_total |= particle_systems * ROOMLOADER_FLAG.PARTICLE_SYSTEMS;
			_total |= sequences * ROOMLOADER_FLAG.SEQUENCES;
			_total |= texts * ROOMLOADER_FLAG.TEXTS;
			_total |= backgrounds * ROOMLOADER_FLAG.BACKGROUNDS;
			return _total;
		},
	};
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
		DEMO_ROOM_DATA = RoomLoader.load(rm, x, y, xorigin, yorigin, flags.get());
		RoomLoader.layer_whitelist_reset();
		RoomLoader.layer_blacklist_reset();
	};
	static unload = function() {
		if (DEMO_ROOM_DATA == undefined) return;
		
		DEMO_ROOM_DATA.cleanup();
		delete DEMO_ROOM_DATA;
	};
}
