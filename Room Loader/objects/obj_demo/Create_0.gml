EVENT_METHOD;

loader = new RoomLoader();

var _t = get_timer();
loader.init(rm_load_test_01);
show_debug_message((get_timer() - _t) / 1000);
