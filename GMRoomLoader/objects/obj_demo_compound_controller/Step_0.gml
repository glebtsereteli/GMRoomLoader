
var _hovered_room = noone;

with (room_obj) {
	update();
	if (hovered) {
		_hovered_room = id;	
	}
}

if (mouse_check_button_pressed(mb_left)) {
	with (_hovered_room) {
		load();
	}
}

if (mouse_check_button_pressed(mb_right)) {
	with (_hovered_room) {
		cleanup();
	}
}
