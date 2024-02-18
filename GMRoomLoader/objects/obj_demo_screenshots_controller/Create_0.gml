EVENT_METHOD;

screenshot = {
	rooms: undefined,
	room_ref: undefined,
	sprite: undefined,
	
	init: function() {
		rooms = array_filter(asset_get_ids(asset_room), function(_room) {
			var _name = room_get_name(_room);
			return (string_pos("rm_demo_base_", _name) > 0);	
		});
	},
	draw: function() {
		if (sprite == undefined) return;
		
		var _x = (room_width * 0.5);
		var _y = (room_height * 0.5);
		draw_sprite(sprite, 0, _x, _y);
	},
	cleanup: function() {
		if (sprite == undefined) return;
		
		sprite_delete(sprite);
		sprite = undefined;
	},
	
	take: function() {
		cleanup();
		
		var _prev = room_ref;
		do {
			room_ref = script_execute_ext(choose, rooms);
		} until (room_ref != _prev);
		
		sprite = RoomLoader.take_screenshot(room_ref, ROOMLOADER_ORIGIN.MIDDLE_CENTER);
		return room_ref;
	},
};

init();
