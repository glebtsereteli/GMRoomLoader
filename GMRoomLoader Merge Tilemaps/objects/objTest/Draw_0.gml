
if (position_meeting(mouse_x, mouse_y, tilemap)) {
	draw_set_font(fntTest);
	draw_text(mouse_x + 20, mouse_y, "Collision!");
	draw_set_font(-1);
}
