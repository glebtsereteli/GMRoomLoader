/// @desc Methods

init = function() {
	screenshot.init();
	RoomLoader.data_init_array(screenshot.rooms);
};
update = function() {
	if (keyboard_check_pressed(vk_backspace)) {
		screenshot.cleanup();
	}
	
	var _checker = (keyboard_check(vk_lcontrol) ? keyboard_check : keyboard_check_pressed);
	if (_checker(vk_space)) {
		var _t = get_timer();
		var _room = screenshot.take();
		var _t = ((get_timer() - _t) / 1000);
		show_debug_message($"Screenshot for {room_get_name(_room)} generated in {_t} milliseconds.");
	}
};
draw = function() {
	screenshot.draw();
};
cleanup = function() {
	screenshot.cleanup();	
};
