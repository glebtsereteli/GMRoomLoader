
hovered = false;
index = {
	value: 0,
	
	progress: function() {
		if (value++ == 3) {
			value = 1;
		}
	},
	shuffle: function() {
		var _prev = value;
		do {
			value = irandom_range(1, 3);
		} until (value != _prev);
	},
	reset: function() {
		value = 0;	
	},
};
payload = {
	ref: undefined,
	
	Set: function(_ref) {
		Cleanup();
		ref = _ref;
	},
	Cleanup: function() {
		with (ref) {
			Cleanup();
		}
	},
};
fill = {
	sprite: asset_get_index(string_replace(sprite_get_name(sprite_index), "Frame", "Fill")),
	color: c_white,
	alpha: {
		current: 0,
		target: 0,
		blockTime: 0,
		
		Update: function(_hovered) {
			blockTime = max(blockTime - 1, 0);
			if (blockTime > 0) return false;
			
			target = (0.15 * _hovered);
			current = lerp(current, target, 0.25);
			return true;
		},
		Click: function(_alpha) {
			target = _alpha;
			current = target;
			blockTime = 7;
		},
	},
	
	Update: function(_hovered) {
		if (alpha.Update(_hovered)) {
			color = c_orange;	
		}
	},
	Draw: method(self, function() {
		draw_sprite_ext(fill.sprite, 0, x, y, image_xscale, image_yscale, 0, fill.color, fill.alpha.current);	
	}),
	Click: function(_color, _alpha) {
		color = _color;
		alpha.Click(_alpha);
	},
};
blend01 = 0;

Update = function() {
	hovered = position_meeting(mouse_x, mouse_y, id);
	fill.Update(hovered);
	
	blend01 = lerp(blend01, hovered, 0.3);
	image_blend = merge_color(c_white, fill.color, blend01);
};
Load = function(_all, _flags) {
	(_all ? index.shuffle : index.progress)();
	var _room = asset_get_index($"rmDemoBaseSlot{vdName}_0{index.value}");
	var _payload = RoomLoader.Load(_room, x + 4, y + 4, 0, 0, _flags);
	payload.Set(_payload);
	fill.Click(c_orange, 0.3);
};
Cleanup = function(_all) {
	payload.Cleanup();
	index.reset();
	fill.Click(c_white, (_all ? 0.1 : 0.25));
};
