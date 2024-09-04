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
		screenshot.take();
	}
};
draw = function() {
	screenshot.draw();
};
cleanup = function() {
	screenshot.cleanup();	
};
