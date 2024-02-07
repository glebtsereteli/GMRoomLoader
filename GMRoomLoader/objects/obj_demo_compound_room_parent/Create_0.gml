
fill_sprite = asset_get_index(string_replace(sprite_get_name(sprite_index), "outline", "fill"));
hovered = false;
prev_room = undefined;
data = {
	ref: undefined,
	
	set: function(_ref) {
		cleanup();
		ref = _ref;
	},
	cleanup: function() {
		with (ref) {
			cleanup();
		}
	},
};

update = function() {
	hovered = position_meeting(mouse_x, mouse_y, id);
	image_blend = merge_color(c_white, c_orange, hovered);
};
load = function() {
	do {
		var _room_name = $"rm_demo_compound_{vd_name}_0{irandom_range(1, 3)}";
		var _room = asset_get_index(_room_name);
	} until (_room != prev_room)
	prev_room = _room;
	
	var _data = RoomLoader.load(_room, x + 4, y + 4);
	data.set(_data);
};
cleanup = function() {
	data.cleanup();
};
