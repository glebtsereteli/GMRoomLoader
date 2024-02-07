EVENT_METHOD;

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
