// feather ignore all

function DemoModuleFlags() constructor {
	static reloaderNames = ["instances", "tilemaps", "sprites", "sequences", "particles", "texts", "backgrounds", "effects"];
	
	instances = true;
	tilemaps = true;
	sprites = true;
	sequences = true;
	particles = true;
	texts = true;
	backgrounds = true;
	effects = true;
	
	static InitDbg = function() {
		dbg_text_separator("Flags");
		dbg_checkbox(ref_create(self, "instances"), "Instances");
		dbg_checkbox(ref_create(self, "tilemaps"), "Tilemaps");
		dbg_checkbox(ref_create(self, "sprites"), "Sprites");
		dbg_checkbox(ref_create(self, "sequences"), "Sequences");
		dbg_checkbox(ref_create(self, "particles"), "Particles");
		dbg_checkbox(ref_create(self, "texts"), "Texts");
		dbg_checkbox(ref_create(self, "backgrounds"), "Backgrounds");
		dbg_checkbox(ref_create(self, "effects"), "Effects");
	};
	static Get = function() {
		var _total = ROOMLOADER_FLAG_NONE;
		_total |= instances * ROOMLOADER_FLAG_INSTANCES;
		_total |= tilemaps * ROOMLOADER_FLAG_TILEMAPS;
		_total |= sprites * ROOMLOADER_FLAG_SPRITES;
		_total |= sequences * ROOMLOADER_FLAG_SEQUENCES;
		_total |= particles * ROOMLOADER_FLAG_PARTICLES;
		_total |= texts * ROOMLOADER_FLAG_TEXTS;
		_total |= backgrounds * ROOMLOADER_FLAG_BACKGROUNDS;
		_total |= effects * ROOMLOADER_FLAG_EFFECTS;
		return _total;
	};
}
