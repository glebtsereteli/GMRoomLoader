
#macro DEMOS global.__demos

function Demos(_pool) constructor {
	pool = _pool;
	n = array_length(pool);
	index = 0;
	index2 = 0;
	controls = undefined;
	info = undefined;
	x1 = undefined;
	y1 = undefined;
	x2 = undefined;
	y2 = undefined;
	xcenter = undefined;
	ycenter = undefined;
	w = undefined;
	h = undefined;
	
	static init = function() {
		var _pad = 8;
		var _x = _pad;
		var _y = _pad + 19;
		var _w = 500;
		var _h = window_get_height() - _y - _pad;
		
		x1 = _x + _w + _pad;
		y1 = _y;
		x2 = window_get_width() - _pad;
		y2 = window_get_height() - _pad;
		xcenter = mean(x1, x2);
		ycenter = mean(y1, y2);
		w = x2 - x1;
		h = y2 - y1;
		
		dbg_view($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} Demo", true, _x, _y, _w, _h);
		
		dbg_section("Selection");
		static _indices = array_create_ext(n, function(_i) {
			pool[_i].index = _i;
			return _i;
		});
		static _names = array_map(pool, function(_demo) {
			return _demo.name;
		});
		dbg_drop_down(ref_create(self, "index2"), _indices, _names, "Demo");
		
		dbg_same_line();
		dbg_button("-", function() { change(index - 1); }, 20, 20);
		dbg_same_line();
		dbg_button("+", function() { change(index + 1); }, 20, 20);
		
		change(index);
	};
	static update = function() {
		if (index2 != index) {
			change(index2);
		}
		get_current().update();
	};
	
	static change = function(_index) {
		_index = mod2(_index, n);
		get_current().cleanup();
		index = _index;
		index2 = index;
		if (controls != undefined) dbg_section_delete(controls);
		if (info != undefined) dbg_section_delete(info);
		get_current().init();
		window_set_caption($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo: {get_current().name}");
	};
	static draw = function() {
		get_current().draw();
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
	static draw = noop;
	static cleanup = noop;
}
