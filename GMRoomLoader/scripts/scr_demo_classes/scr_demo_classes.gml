
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
	live_refresh = true;
	
	static init = function() {
		var _pad = 8;
		var _x = _pad;
		var _y = _pad + 19;
		var _w = 510;
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
		
		dbg_section("Meta");
		static _indices = array_create_ext(n, function(_i) {
			pool[_i].setup(_i);
			return _i;
		});
		static _names = array_map(pool, function(_demo) {
			return _demo.iname;
		});
		dbg_drop_down(ref_create(self, "index2"), _indices, _names, "Demo");
		
		dbg_same_line();
		dbg_button("-", function() { change(index - 1); }, 20, 20);
		dbg_same_line();
		dbg_button("+", function() { change(index + 1); }, 20, 20);
		dbg_checkbox(ref_create(self, "live_refresh"), "Live Refresh");
		
		dbg_same_line();
		dbg_button("Repo", function() { url_open(__ROOMLOADER_REPO); }, 56, 20);
		dbg_same_line();
		dbg_button("Wiki", function() { url_open(__ROOMLOADER_WIKI); }, 56, 20);
		dbg_same_line();
		dbg_button("Itch", function() { url_open(__ROOMLOADER_ITCH); }, 57, 20);
		
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
		window_set_caption($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo: {get_current().iname}");
	};
	static draw = function() {
		get_current().draw();
	};
	
	static get_current = function() {
		return pool[index];
	};
}
function DemoPar(_name) constructor {
	name = _name;
	iname = undefined;
	index = undefined;
	reloader = new DemoReloader();
	
	static setup = function(_index) {
		index = _index;
		iname = $"0{index + 1}. {name}";
	};
	static init = noop;
	static update = function() {
		reloader.update();
		on_update();
	};
	static draw = noop;
	static cleanup = noop;
}
function DemoReloader(_pool) constructor {
	pool = [];
	cb_on_trigger = noop;
	
	static update = function() {
		static _check = function(_var) {
			var _new = _var.scope[$ _var.name];
			if (_new != _var.def) {
				_var.def = _new;
				return true;
			}
			return false;
		};
		
		if ((not DEMOS.live_refresh) and (not mouse_check_button_released(mb_left))) return;
		if (not array_any(pool, _check)) return;
		
		cb_on_trigger();
	};
	
	static add_variable = function(_scope, _name) {
		array_push(pool, {
			def: _scope[$ _name],
			scope: _scope,
			name: _name,
		});
		return self;
	};
	static add_variables = function(_scope, _pool) {
		for (var _i = 0; _i < array_length(_pool); _i++) {
			add_variable(_scope, _pool[_i]);
		}
		return self;
	};
	static add_modules = function(_pool) {
		array_foreach(_pool, function(_module) {
			add_variables(_module, _module.reloader_names);
		});
		return self;
	};
	static clear = function() {
		pool = [];
		return self;
	};
	
	static on_trigger = function(_callback) {
		cb_on_trigger = _callback;
		return self;
	};
}
