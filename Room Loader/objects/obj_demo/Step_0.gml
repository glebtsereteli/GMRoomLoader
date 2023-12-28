
if (keyboard_check(ord("1"))) {
	if (data != undefined) data.cleanup();
	
	var _t = get_timer();
	data = loader.load(mouse_x, mouse_y);
	show_debug_message((get_timer() - _t) / 1000);
}
if (keyboard_check_pressed(ord("2"))) {
	if (data != undefined) data.cleanup();
}
