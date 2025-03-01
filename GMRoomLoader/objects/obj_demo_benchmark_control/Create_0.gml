EVENT_CONSTRUCTOR;
EVENT_METHOD;

prefix = "rm_demo_benchmark_load_";
origin = {
	x: 0,
	y: 0,
	
	update: function() {
		var _step = 0.1;
		
		var _xinput = (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left));
		x = clamp(x + (_xinput * _step), 0, 1);
		
		var _yinput = (keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up));
		y = clamp(y - (_yinput * _step), 0, 1);
	},
	get_message: function() {
		return $"Origin: {string_format(x, 1, 2)}x{string_format(y, 1, 2)}";
	},
};
flags = {
	pool: [
		new Flag("Instances", ROOMLOADER_FLAG.INSTANCES),
		new Flag("Tilemaps", ROOMLOADER_FLAG.TILEMAPS),
		new Flag("Sprites", ROOMLOADER_FLAG.SPRITES),
		new Flag("Particle Systems", ROOMLOADER_FLAG.PARTICLE_SYSTEMS),
		new Flag("Sequences", ROOMLOADER_FLAG.SEQUENCES),
		new Flag("Texts", ROOMLOADER_FLAG.TEXTS),
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
	get_message: function() {
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
		
		return _message;
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
