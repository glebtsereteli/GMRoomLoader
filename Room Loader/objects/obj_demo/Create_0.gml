EVENT_METHOD;

instances = {
	pool: [],
	
	load: function() {
		pool = room_load_instances_quick(rm_load_test_01, mouse_x, mouse_y, 0);
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

loader = new RoomLoader();

var _t = get_timer();
loader.init(rm_load_test_01);
show_debug_message((get_timer() - _t) / 1000);
