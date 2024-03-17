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
		var _data = RoomLoader.load(rm_demo_benchmark_load_01, mouse_x, mouse_y, origin.get(), flags.get());
		data.set(_data);
	}
	
	if (keyboard_check_pressed(vk_numpad1)) {
		RoomLoader.take_screenshot(rm_demo_benchmark_load_01);
	}
	if (keyboard_check_pressed(vk_numpad2)) {
		RoomLoader.data_clear();
	}
};
draw = function() {
	flags.draw();
};
