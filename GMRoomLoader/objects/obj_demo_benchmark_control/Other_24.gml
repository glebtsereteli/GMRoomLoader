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
		var _data = RoomLoader.load(rm_demo_benchmark_load_01, mouse_x, mouse_y, origin.x, origin.y, flags.get());
		data.set(_data);
	}
};
draw = function() {
	draw_set_valign(fa_bottom);
	var _pad = 16;
	var _message = origin.get_message() + "\n" + flags.get_message();
	draw_text(_pad, room_height - _pad, _message);
	draw_set_valign(fa_top);
};
