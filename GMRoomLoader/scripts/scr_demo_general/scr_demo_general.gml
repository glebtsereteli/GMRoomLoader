
function DemoGeneral() : Demo("General") constructor {
	// Shared:
	static init = function() {
		x = DEMOS.xcenter;
		y = DEMOS.ycenter;
		RoomLoader.data_init(rm);
		
		DEMOS.info = dbg_section("Info");
		dbg_text("This demo showcases the main \"RoomLoader.load()\" method for general\nroom loading. Use the controls below to adjust the loading position,\norigin and flags.");
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
		dbg_checkbox(ref_create(self, "instances"), "Instances");
		dbg_checkbox(ref_create(self, "tilemaps"), "Tilemaps");
		dbg_checkbox(ref_create(self, "sprites"), "Sprites");
		dbg_checkbox(ref_create(self, "particle_systems"), "Particle Systems");
		dbg_checkbox(ref_create(self, "texts"), "Texts");
		dbg_checkbox(ref_create(self, "backgrounds"), "Backgrounds");
	};
	static update = function() {
		flags = ROOMLOADER_FLAG.NONE;
		flags |= instances * ROOMLOADER_FLAG.INSTANCES;
		flags |= tilemaps * ROOMLOADER_FLAG.TILEMAPS;
		flags |= sprites * ROOMLOADER_FLAG.SPRITES;
		flags |= particle_systems * ROOMLOADER_FLAG.PARTICLE_SYSTEMS;
		flags |= sequences * ROOMLOADER_FLAG.SEQUENCES;
		flags |= texts * ROOMLOADER_FLAG.TEXTS;
		flags |= backgrounds * ROOMLOADER_FLAG.BACKGROUNDS;
		
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
	instances = true;
	tilemaps = true;
	sprites = true;
	particle_systems = true;
	sequences = true;
	texts = true;
	backgrounds = true;
	flags = undefined;
	
	static load = function() {
		unload();
		DEMO_ROOM_DATA = RoomLoader.load(rm, x, y, xorigin, yorigin, flags);
	};
	static unload = function() {
		if (DEMO_ROOM_DATA == undefined) return;
		
		DEMO_ROOM_DATA.cleanup();
		delete DEMO_ROOM_DATA;
	};
}
