
fill_sprite = asset_get_index(string_replace(sprite_get_name(sprite_index), "outline", "fill"));
hovered = false;

update = function() {
	hovered = position_meeting(mouse_x, mouse_y, id);
	image_blend = merge_color(c_white, c_orange, hovered);
};
click = function() {
	show_debug_message($"Clicked on room \"{vd_name}\".");
};
