
if (placing) {
	var _rotationInput = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"));
	if (_rotationInput != 0) {
		var _nextAngle = angle - (90 * _rotationInput);
		angle = Mod2(_nextAngle, 360);
	}
	if (keyboard_check_released(vk_space)) {
		RoomLoader.MiddleCenter().Angle(angle).LoadTilemap(rmTestLoad, mouse_x, mouse_y, "Tiles");
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
