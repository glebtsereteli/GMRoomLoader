/// @desc Methods

update = function() {
	flags.update();
	if (keyboard_check(vk_backspace)) {
		data.cleanup();
	}

	var _room = undefined;
	var _checker = (keyboard_check(vk_lalt) ? keyboard_check : keyboard_check_pressed);
	if (_checker(ord("1"))) _room = rm_demo_benchmark_load_01;
	if (_checker(ord("2"))) _room = rm_demo_benchmark_load_02;

	if (_room != undefined) {
		var _t = get_timer();
		var _data = RoomLoader.load(_room, mouse_x, mouse_y, ROOMLOADER_ORIGIN.TOP_LEFT, flags.get());
		_t = ((get_timer() - _t) / 1000);
		show_debug_message($"{room_get_name(_room)} loaded in {_t}ms.");
	
		data.set(_data);
	}	
};
draw = function() {
	flags.draw();	
};
