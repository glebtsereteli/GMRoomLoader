EVENT_METHOD;

fill_sprite = asset_get_index(string_replace(sprite_get_name(sprite_index), "outline", "fill"));
hovered = false;
prev_room = undefined;
index = 1;
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
fill_alpha = {
	current: 0,
	target: 0,
	block_time: 0,
	
	update: function(_hovered) {
		block_time = max(block_time - 1, 0);
		if (block_time > 0) return;
		
		target = (0.1 * _hovered);
		current = lerp(current, target, 0.25);
	},
	click: function() {
		current = 0.3;
		target = 0.3;
		block_time = 5;
	},
};
