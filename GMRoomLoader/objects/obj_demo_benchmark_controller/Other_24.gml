/// @desc Methods

init = function() {
	RoomLoader.data_init_prefix("rm_demo_benchmark_load_");
	flags.init();
};
update = function() {
	origin.update();
	flags.update();
	
	if (keyboard_check_pressed(vk_backspace)) {
		data.cleanup();
	}
	
	var _checker = (keyboard_check(vk_lcontrol) ? keyboard_check : keyboard_check_pressed);
	if (_checker(vk_space)) {
		var _room = rm_demo_benchmark_load_01;
		var _t = get_timer();
		var _data = RoomLoader.load(_room, mouse_x, mouse_y, origin.get(), flags.get());
		_t = ((get_timer() - _t) / 1000);
		show_debug_message($"{room_get_name(_room)} loaded in {_t} milliseconds.");
		
		data.set(_data);
	}
};
draw = function() {
	flags.draw();
};
