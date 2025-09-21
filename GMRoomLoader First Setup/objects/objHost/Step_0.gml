
if (keyboard_check_pressed(ord("1"))) {
    Cleanup(); // Clean up the loaded room.
	
	// Load the room centered at the mouse position:
    payload = RoomLoader.MiddleCenter().Load(rm, mouse_x, mouse_y);
}
if (keyboard_check_pressed(ord("2"))) {
    Cleanup(); // Clean up the loaded room.
}
