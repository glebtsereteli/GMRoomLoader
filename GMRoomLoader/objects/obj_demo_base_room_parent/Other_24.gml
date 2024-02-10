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
load = function(_udpate_index = true) {
	var _room_name = $"rm_demo_base_{vd_name}_0{index}";
	var _room = asset_get_index(_room_name);
	
	if ((_udpate_index) and (index++ == 3)) {
		index = 1;
	}
	
	var _t = get_timer();
	var _data = RoomLoader.load(_room, x + 4, y + 4);
	show_debug_message($"Room \"{_room_name}\" loaded in {(get_timer() - _t) / 1000} milliseconds.");
	
	data.set(_data);
	fill_alpha.click();
	
	static _init_patrol_units = function(_inst) {
		if (object_is_ancestor(_inst.object_index, obj_demo_base_unit_parent)) {
			_inst.init();
		}
	};
	array_foreach(_data.get_instances(), _init_patrol_units);
};
shuffle_index = function() {
	var _prev = index;
	do {
		index = irandom_range(1, 3);
	} until (index != _prev);
};
cleanup = function() {
	data.cleanup();
	index = 1;
	fill_alpha.click();
};
