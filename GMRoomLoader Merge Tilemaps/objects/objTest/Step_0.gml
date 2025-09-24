
if (placing) {
	if (keyboard_check_released(vk_space)) {
		RoomLoader.MiddleCenter().LoadTilemap(rmTestLoad, mouse_x, mouse_y, "Tiles");
		placing = false;
	}
}
else {
	if (mouse_check_button(mb_right)) {
		tilemap_set_at_pixel(hostTilemap, 0, mouse_x, mouse_y);
	}
	if (keyboard_check_pressed(vk_space)) {
		placing = true;
	}
}
