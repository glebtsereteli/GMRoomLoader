/// @desc Methods

init = function() {
	RoomLoader.data_init_prefix("rm_demo_base_");
	screenshot = RoomLoader.take_screenshot(rm_demo_base_02_01, ROOMLOADER_ORIGIN.MIDDLE_CENTER);
};
draw = function() {
	if (screenshot == undefined) return;
	
	var _x = (room_width * 0.5);
	var _y = (room_height * 0.5);
	draw_sprite(screenshot, 0, _x, _y);	
};
