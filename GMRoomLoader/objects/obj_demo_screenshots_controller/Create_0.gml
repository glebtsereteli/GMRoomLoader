EVENT_METHOD;

screenshot = {
	rooms: undefined,
	room_ref: undefined,
	sprite: undefined,
	
	init: function() {
		rooms = tag_get_asset_ids("base_rooms", asset_room);
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
		
		sprite = RoomLoader.take_screenshot(room_ref, 0.5, 0.5);
		return room_ref;
	},
};

init();
