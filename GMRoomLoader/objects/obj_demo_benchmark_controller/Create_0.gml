EVENT_CONSTRUCTOR;
EVENT_METHOD;

origin = {
	value: ROOMLOADER_ORIGIN.TOP_LEFT,
	
	update: function() {
		static _get = function() {
			switch (keyboard_key) {
				case vk_numpad7: return ROOMLOADER_ORIGIN.TOP_LEFT;
				case vk_numpad8: return ROOMLOADER_ORIGIN.TOP_CENTER;
				case vk_numpad9: return ROOMLOADER_ORIGIN.TOP_RIGHT;
				case vk_numpad4: return ROOMLOADER_ORIGIN.MIDDLE_LEFT;
				case vk_numpad5: return ROOMLOADER_ORIGIN.MIDDLE_CENTER;
				case vk_numpad6: return ROOMLOADER_ORIGIN.MIDDLE_RIGHT;
				case vk_numpad1: return ROOMLOADER_ORIGIN.BOTTOM_LEFT;
				case vk_numpad2: return ROOMLOADER_ORIGIN.BOTTOM_CENTER;
				case vk_numpad3: return ROOMLOADER_ORIGIN.BOTTOM_RIGHT;
			}
		};
		value = (_get() ?? value);
	},
	get: function() {
		return value;	
	},
};
flags = {
	pool: [
		new Flag("Instances", ROOMLOADER_FLAG.INSTANCES),
		new Flag("Tilemaps", ROOMLOADER_FLAG.TILEMAPS),
		new Flag("Sprites", ROOMLOADER_FLAG.SPRITES),
		new Flag("Particle Systems", ROOMLOADER_FLAG.PARTICLE_SYSTEMS),
		new Flag("Sequences", ROOMLOADER_FLAG.SEQUENCES),
		new Flag("Backgrounds", ROOMLOADER_FLAG.BACKGROUNDS),
	],
	n: undefined,
	
	init: function() {
		n = array_length(pool);
		for (var _i = 0; _i < n; _i++) {
			pool[_i].init(_i);
		}
	},
	update: function() {
		for (var _i = 0; _i < n; _i++) {
			pool[_i].update();
		}
	},
	draw: function() {
		var _value = 0;
		var _message = "Flags:";
		
		for (var _i = 0; _i < n; _i++) {
			var _flag = pool[_i];
			if (_flag.enabled) {
				_message += $"{(_value > 0) ? " |" : ""} {_flag.name}";
				_value++;
			}
		}
		
		if (_value == 0) {
			_message += " None";
		}
		
		draw_set_valign(fa_bottom);
		var _pad = 16;
		draw_text(_pad, room_height - _pad, _message);
		draw_set_valign(fa_top);
	},
	get: function() {
		var _value = ROOMLOADER_FLAG.NONE;
		for (var _i = 0; _i < n; _i++) {
			var _flag = pool[_i];
			if (_flag.enabled) {
				_value |= _flag.value;
			}
		}
		return _value;
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

init();
