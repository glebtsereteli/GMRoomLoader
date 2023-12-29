
if (keyboard_check(vk_backspace)) {
	data.cleanup();
}

var _room = undefined;
var _checker = (keyboard_check(vk_lalt) ? keyboard_check : keyboard_check_pressed);
if (_checker(ord("1"))) _room = rm_load_test_01;
if (_checker(ord("2"))) _room = rm_load_test_02;

if (_room != undefined) {
	var _t = get_timer();
	var _data = RoomLoader.load(_room, mouse_x, mouse_y, flags.get());
	_t = ((get_timer() - _t) / 1000);
	show_debug_message($"{room_get_name(_room)} loaded in {_t}ms.");
	
	data.add(_data);
}

flags.update();
