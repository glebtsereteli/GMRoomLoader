/// @desc Constructors

Interface = function() constructor {
	rooms = [rm_demo_base, rm_demo_benchmark, rm_demo_screenshots];
	names = ["Base", "Benchmark", "Screenshots"];
	n = array_length(rooms);
	
	init = function() {
		var _pad = 8;
		var _x = _pad;
		var _y = _pad + 19;
		var _w = 400;
		var _h = window_get_height() - _y - _pad;
		dbg_view($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} Demo", true, _x, _y, _w, _h);
		dbg_drop_down(ref_create(CONTROL, "rm"), rooms, names, "Example");
		
		dbg_same_line();
		dbg_button("<", function() { change(-1); }, 20, 20);
		dbg_same_line();
		dbg_button(">", function() { change(+1); }, 20, 20);
		
		goto(rooms[0]);
	};
	update = function() {
		if (room != CONTROL.rm) {
			goto(room);
		}
	};
	change = function(_dir) {
		var _index = mod2(get_index() + _dir, n);
		goto(rooms[_index]);
	};
	goto = function(_room) {
		CONTROL.rm = _room;
		room_goto(_room);
	};
	
	get_index = function() {
		return array_get_index(rooms, CONTROL.rm);
	};
};
