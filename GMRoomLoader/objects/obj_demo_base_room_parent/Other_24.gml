/// @desc Methods

update = function() {
	hovered = position_meeting(mouse_x, mouse_y, id);
	image_blend = merge_color(c_white, c_orange, hovered);
	fill_alpha.update(hovered);
};
draw = function() {
	draw_self();
	
	if (hovered) {
		draw_sprite_ext(fill_sprite, 0, x, y, image_xscale, image_yscale, 0, image_blend, fill_alpha.current);
	}
};
load = function() {
	do {
		var _room_name = $"rm_demo_base_{vd_name}_0{irandom_range(1, 3)}";
		var _room = asset_get_index(_room_name);
	} until (_room != prev_room);
	prev_room = _room;
	
	var _t = get_timer();
	var _data = RoomLoader.load(_room, x + 4, y + 4);
	show_debug_message($"Room \"{_room_name}\" loaded in {(get_timer() - _t) / 1000} milliseconds.");
	
	data.set(_data);
	fill_alpha.click();
};
cleanup = function() {
	data.cleanup();
	fill_alpha.click();
};
