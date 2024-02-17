/// @desc Methods

init = function() {
	RoomLoader.data_init_prefix("rm_demo_base_");
};
update = function() {
	var _hovered_room = noone;
	
	// Update hover:
	with (room_obj) {
		update();
		if (hovered) {
			_hovered_room = id;
		}
	}
	
	// Load/cleanup hovered room:
	with (_hovered_room) {
		if (mouse_check_button_pressed(mb_left)) load(false);
		if (mouse_check_button_pressed(mb_right)) cleanup(false);
	}
	
	// Randomly load all rooms:
	if (keyboard_check_pressed(vk_space)) {
		with (room_obj) {
			load(true);
		}
	}
	
	// Clean up all rooms:
	if (keyboard_check_pressed(vk_backspace)) {
		with (room_obj) {
			cleanup(true);	
		}
	}
};
