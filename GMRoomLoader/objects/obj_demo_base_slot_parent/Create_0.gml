
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
fill = {
	sprite: asset_get_index(string_replace(sprite_get_name(sprite_index), "outline", "fill")),
	color: c_white,
	alpha: {
		current: 0,
		target: 0,
		block_time: 0,
		
		update: function(_hovered) {
			block_time = max(block_time - 1, 0);
			if (block_time > 0) return false;
			
			target = (0.15 * _hovered);
			current = lerp(current, target, 0.25);
			return true;
		},
		click: function(_alpha) {
			target = _alpha;
			current = target;
			block_time = 7;
		},
	},
	
	update: function(_hovered) {
		if (alpha.update(_hovered)) {
			color = c_orange;	
		}
	},
	draw: method(self, function() {
		draw_sprite_ext(fill.sprite, 0, x, y, image_xscale, image_yscale, 0, fill.color, fill.alpha.current);	
	}),
	click: function(_color, _alpha) {
		color = _color;
		alpha.click(_alpha);
	},
};
blend01 = 0;

update = function() {
	hovered = position_meeting(mouse_x, mouse_y, id);
	fill.update(hovered);
	
	blend01 = lerp(blend01, hovered, 0.3);
	image_blend = merge_color(c_white, fill.color, blend01);
};
load = function(_all) {
	(_all ? index.shuffle : index.progress)();
	var _room = asset_get_index($"rm_demo_base_slot_{vd_name}_0{index.value}");
	var _data = RoomLoader.load(_room, x + 4, y + 4, 0, 0, ROOMLOADER_FLAG.CORE | ROOMLOADER_FLAG.TEXTS);
	data.set(_data);
	fill.click(c_orange, 0.3);
};
cleanup = function(_all) {
	data.cleanup();
	index.reset();
	fill.click(c_white, (_all ? 0.1 : 0.25));
};
