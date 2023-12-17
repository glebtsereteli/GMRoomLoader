EVENT_METHOD;

instances = {
	pool: [],
	
	load: function() {
		pool = room_load_instances(rm_load_test_01, mouse_x, mouse_y, 0);
		return self;
	},
	clear: function() {
		for (var _i = 0; _i < array_length(pool); _i++) {
			instance_destroy(pool[_i]);
		}
		pool = [];
		return self;
	},
};
