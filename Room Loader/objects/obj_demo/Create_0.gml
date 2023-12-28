EVENT_METHOD;

show_debug_overlay(true, true);

loader = new RoomLoader();
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

var _t = get_timer();
loader.init(rm_load_test_01).init(rm_load_test_02);
show_debug_message((get_timer() - _t) / 1000);
