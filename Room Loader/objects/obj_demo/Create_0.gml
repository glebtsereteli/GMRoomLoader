EVENT_METHOD;

data = {
	pool: [],
	
	add: function(_data) {
		array_push(pool, _data);
	},
	cleanup: function() {
		static _cleanup = function(_data) { _data.cleanup(); };
		array_foreach(pool, _cleanup);
		pool = [];
	},
};

show_debug_overlay(true, true);
//RoomLoader.init(rm_load_test_01, rm_load_test_02);
//RoomLoader.init_array([rm_load_test_01, rm_load_test_02]);
RoomLoader.init_prefix("rm_load_test_");
