
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
	xCenter = undefined;
	yCenter = undefined;
	w = undefined;
	h = undefined;
	liveRefresh = true;
	
	static Init = function() {
		var _pad = 8;
		var _x = _pad;
		var _y = _pad + 19;
		var _w = 510;
		var _h = window_get_height() - _y - _pad;
		
		x1 = _x + _w + _pad;
		y1 = _y;
		x2 = window_get_width() - _pad;
		y2 = window_get_height() - _pad;
		xCenter = mean(x1, x2);
		yCenter = mean(y1, y2);
		w = x2 - x1;
		h = y2 - y1;
		
		dbg_view($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} Demo", true, _x, _y, _w, _h);
		
		dbg_section("Meta");
		static _indices = array_create_ext(n, function(_i) {
			pool[_i].Setup(_i);
			return _i;
		});
		static _names = array_map(pool, function(_demo) {
			return _demo.iname;
		});
		dbg_drop_down(ref_create(self, "index2"), _indices, _names, "Demo (cycle with Left/Right)");
		
		dbg_same_line();
		dbg_button("-", function() { Change(index - 1); }, 20, 20);
		dbg_same_line();
		dbg_button("+", function() { Change(index + 1); }, 20, 20);
		
		var _w = 109;
		dbg_button("GitHub", function() { url_open("https://github.com/glebtsereteli/GMRoomLoader"); }, _w, 20);
		dbg_same_line();
		dbg_button("Last Release", function() { url_open($"https://github.com/glebtsereteli/GMRoomLoader/Releases/tag/{__ROOMLOADER_VERSION}"); }, _w, 20);
		dbg_same_line();
		dbg_button("Docs", function() { url_open("https://GlebTsereteli.github.io/GMRoomLoader"); }, _w, 20);
		dbg_same_line();
		dbg_button("Itch", function() { url_open("https://glebtsereteli.itch.io/gmroomloader"); }, _w, 20);
		
		Change(index);
	};
	static Update = function() {
		if (index2 != index) {
			Change(index2);
		}
		
		var _input = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
		if (_input != 0) {
			Change(index + _input);
		}
		
		GetCurrent().Update();
	};
	static Draw = function() {
		GetCurrent().Draw();
	};
	
	static Change = function(_index) {
		_index = mod2(_index, n);
		GetCurrent().Cleanup();
		index = _index;
		index2 = index;
		if (controls != undefined) dbg_section_delete(controls);
		if (info != undefined) dbg_section_delete(info);
		GetCurrent().Init();
		window_set_caption($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo: {GetCurrent().iname}");
	};
	
	static GetCurrent = function() {
		return pool[index];
	};
}
function DemoPar(_name) constructor {
	name = _name;
	iname = undefined;
	index = undefined;
	reloader = new DemoReloader();
	
	static Setup = function(_index) {
		index = _index;
		iname = $"0{index + 1}. {name}";
	};
	static Init = noop;
	static Update = function() {
		reloader.Update();
		OnUpdate();
	};
	static Draw = noop;
	static Cleanup = noop;

	static OnUpdate = noop;
}
function DemoReloader(_pool) constructor {
	pool = [];
	callbackOnTrigger = noop;
	
	static Update = function() {
		static _check = function(_var) {
			var _new = _var.scope[$ _var.name];
			if (_new != _var.def) {
				_var.def = _new;
				return true;
			}
			return false;
		};
		
		if ((not DEMOS.liveRefresh) and (not mouse_check_button_released(mb_left))) return;
		if (not array_any(pool, _check)) return;
		
		callbackOnTrigger();
	};
	
	static addVariable = function(_scope, _name) {
		array_push(pool, {
			def: _scope[$ _name],
			scope: _scope,
			name: _name,
		});
		return self;
	};
	static AddVariables = function(_scope, _pool) {
		for (var _i = 0; _i < array_length(_pool); _i++) {
			addVariable(_scope, _pool[_i]);
		}
		return self;
	};
	static AddModules = function(_pool) {
		array_foreach(_pool, function(_module) {
			AddVariables(_module, _module.reloader_names);
		});
		return self;
	};
	static Clear = function() {
		pool = [];
		return self;
	};
	
	static OnTrigger = function(_callback) {
		callbackOnTrigger = _callback;
		return self;
	};
}
