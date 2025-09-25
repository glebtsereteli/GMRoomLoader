/// feather ignore all

function DemoModulePos() constructor {
	static reloaderNames = ["x", "y"];
	
	x = undefined;
	y = undefined;
	
	static InitDbg = function() {
		x = DEMOS.xCenter;
		y = DEMOS.yCenter;
		
		dbg_text_separator("Position", 1);
		dbg_slider_int(ref_create(self, "x"), 0, room_width, "X", 10);
		dbg_slider_int(ref_create(self, "y"), 0, room_height, "Y", 10);
	};
}
function DemoModuleOrigin(_x = 0.5, _y = 0.5) constructor {
	static reloaderNames = ["x", "y"];
	
	x = _x;
	y = _y;
	
	static InitDbg = function() {
		dbg_text_separator("Origin", 1);
		dbg_slider(ref_create(self, "x"), 0, 1, "X", 0.05);
		dbg_slider(ref_create(self, "y"), 0, 1, "Y", 0.05);
	};
}
function DemoModuleFlags() constructor {
	static reloaderNames = ["instances", "tilemaps", "sprites", "sequences", "texts", "backgrounds"];
	
	instances = true;
	tilemaps = true;
	sprites = true;
	sequences = true;
	texts = true;
	backgrounds = true;
	
	static InitDbg = function() {
		dbg_text_separator("Flags", 1);
		dbg_checkbox(ref_create(self, "instances"), "Instances");
		dbg_checkbox(ref_create(self, "tilemaps"), "Tilemaps");
		dbg_checkbox(ref_create(self, "sprites"), "Sprites");
		dbg_checkbox(ref_create(self, "sequences"), "Sequences");
		dbg_checkbox(ref_create(self, "texts"), "Texts");
		dbg_checkbox(ref_create(self, "backgrounds"), "Backgrounds");
	};
	static Get = function() {
		var _total = ROOMLOADER_FLAG.NONE;
		_total |= instances * ROOMLOADER_FLAG.INSTANCES;
		_total |= tilemaps * ROOMLOADER_FLAG.TILEMAPS;
		_total |= sprites * ROOMLOADER_FLAG.SPRITES;
		_total |= sequences * ROOMLOADER_FLAG.SEQUENCES;
		_total |= texts * ROOMLOADER_FLAG.TEXTS;
		_total |= backgrounds * ROOMLOADER_FLAG.BACKGROUNDS;
		return _total;
	};
}
