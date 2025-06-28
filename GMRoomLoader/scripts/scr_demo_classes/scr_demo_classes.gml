
#macro DEMOS global.__demos

function Demos(_pool) constructor {
	pool = _pool;
	n = array_length(pool);
	index = 0;
	index2 = 0;
	section = undefined;
	
	static init = function() {
		var _pad = 8;
		var _x = _pad;
		var _y = _pad + 19;
		var _w = 400;
		var _h = window_get_height() - _y - _pad;
		dbg_view($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} Demo", true, _x, _y, _w, _h);
		
		dbg_section("Selection");
		static _indices = array_create_ext(n, function(_i) {
			pool[_i].index = _i;
			return _i;
		});
		static _names = array_map(pool, function(_demo) {
			return _demo.name;
		});
		dbg_drop_down(ref_create(self, "index"), _indices, _names, "Demo");
		
		dbg_same_line();
		dbg_button("-", function() { change(index - 1); }, 20, 20);
		dbg_same_line();
		dbg_button("+", function() { change(index + 1); }, 20, 20);
		
		change(index);
	};
	static update = function() {
		if (index != index2) {
			change(index);
		}
	};
	
	static change = function(_index) {
		_index = mod2(_index, n);
		get_current().cleanup();
		index = _index;
		index2 = index;
		if (section != undefined) {
			dbg_section_delete(section);
		}
		section = dbg_section($"Demo: {get_current().name}");
		get_current().init();
		
	};
	
	static get_current = function() {
		return pool[index];
	};
}
function Demo(_name) constructor {
	name = _name;
	index = undefined;
	
	static init = noop;
	static update = noop;
	static cleanup = noop;
}
function DemoGeneral() : Demo("General") constructor {
	xorigin = 0;
	yorigin = 0;
	instances = true;
	tilemaps = true;
	sprites = true;
	particle_systems = true;
	sequences = true;
	texts = true;
	backgrounds = true;
	
	static init = function() {
		dbg_text_separator("Origin");
		dbg_slider(ref_create(self, "xorigin"), 0, 1, "X", 0.05);
		dbg_slider(ref_create(self, "yorigin"), 0, 1, "Y", 0.05);
		
		dbg_text_separator("Flags");
		dbg_checkbox(ref_create(self, "instances"), "Instances");
		dbg_checkbox(ref_create(self, "tilemaps"), "Tilemaps");
		dbg_checkbox(ref_create(self, "sprites"), "Sprites");
		dbg_checkbox(ref_create(self, "particle_systems"), "Particle Systems");
		dbg_checkbox(ref_create(self, "texts"), "Texts");
		dbg_checkbox(ref_create(self, "backgrounds"), "Backgrounds");
		
		dbg_text_separator("");
	};
}
function DemoBase() : Demo("Base") constructor {
	
}
function DemoScreenshots() : Demo("Screenshots") constructor {
	
}
