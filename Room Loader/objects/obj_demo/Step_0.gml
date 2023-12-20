
var _tile_size = 16;
var _x = round_to(mouse_x, _tile_size);
var _y = round_to(mouse_y, _tile_size);

if (keyboard_check_pressed(ord("1"))) instances.clear().load();
if (keyboard_check_pressed(ord("2"))) instances.clear();
if (keyboard_check_pressed(ord("3"))) {
	var _data = room_load_tilemap(rm_load_test_02, "tiles_mid", _x, _y);
	show_debug_message(_data);
}
if (keyboard_check_pressed(ord("4"))) {
	var _data = room_load_tilemaps(rm_load_test_02, _x, _y);
	show_debug_message(_data);
}
