
var _tile_size = 16;
var _x = round_to(mouse_x, _tile_size);
var _y = round_to(mouse_y, _tile_size);

if (keyboard_check(ord("1"))) {
	if (data != undefined) data.cleanup();
	
	var _t = get_timer();
	data = loader.load(mouse_x, mouse_y);
	show_debug_message((get_timer() - _t) / 1000);
}
if (keyboard_check_pressed(ord("2"))) {
	if (data != undefined) data.cleanup();
}
if (keyboard_check_pressed(ord("3"))) {
	var _data = room_load_tilemap(rm_load_test_02, "tiles_mid", _x, _y);
	show_debug_message(_data);
}
if (keyboard_check_pressed(ord("4"))) {
	var _t = get_timer();
	var _data = room_load_tilemaps(rm_load_test_02, _x, _y);
	show_debug_message((get_timer() - _t) / 1000);
}
