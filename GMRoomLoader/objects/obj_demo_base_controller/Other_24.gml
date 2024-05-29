/// @desc Methods

init = function() {
	RoomLoader.data_init_tag("base_rooms");
};
update = function() {
	var _hovered_room = noone;
	var _fast = keyboard_check(vk_lcontrol);
	
	// Update hover:
	with (room_obj) {
		update();
		if (hovered) {
			_hovered_room = id;
		}
	}
	
	// Load/cleanup hovered room:
	with (_hovered_room) {
		var _checker = (_fast ? mouse_check_button : mouse_check_button_pressed);
		if (_checker(mb_left)) load(false);
		if (mouse_check_button_pressed(mb_right)) cleanup(false);
	}
	
	// Load all rooms:
	var _checker = (_fast ? keyboard_check : keyboard_check_pressed);
	if (_checker(vk_space)) {
		with (room_obj) {
			load(true);
		}
	}
	
	// Cleanup all rooms:
	if (keyboard_check_pressed(vk_backspace)) {
		with (room_obj) {
			cleanup(true);
		}
	}
};
