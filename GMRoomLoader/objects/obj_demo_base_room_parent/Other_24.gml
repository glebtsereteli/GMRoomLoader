/// @desc Methods

update = function() {
	hovered = position_meeting(mouse_x, mouse_y, id);
	fill.update(hovered);
	
	blend_01 = lerp(blend_01, hovered, 0.3);
	image_blend = merge_color(c_white, fill.color, blend_01);
};
draw = function() {
	draw_self();
	fill.draw();
};
load = function(_all) {
	(_all ? index.shuffle : index.progress)();
	
	var _room_name = $"rm_demo_base_{vd_name}_0{index.value}";
	var _room = asset_get_index(_room_name);
	
	var _t = get_timer();
	var _data = RoomLoader.load(_room, x + 4, y + 4);
	show_debug_message($"Room \"{_room_name}\" loaded in {(get_timer() - _t) / 1000} milliseconds.");
	
	data.set(_data);
	fill.click(c_orange, 0.3);
};
cleanup = function(_all) {
	data.cleanup();
	index.reset();
	fill.click(c_white, (_all ? 0.1 : 0.25));
};
