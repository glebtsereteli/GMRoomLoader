EVENT_METHOD;

flags = {
	instances: true,
	sprites: true,
	tilemaps: true,
	
	update: function() {
		instances ^= keyboard_check_pressed(vk_numpad1);
		sprites ^= keyboard_check_pressed(vk_numpad2);
		tilemaps ^= keyboard_check_pressed(vk_numpad3);
	},
	draw: function() {
		var _message = "Flags: ";
		var _flags = get();
		if (_flags == 0) _message += "None";
		else {
			if (instances) _message += "Instances";
			if (sprites) _message += $"{instances ? " | " : ""}Sprites";
			if (tilemaps) _message += $"{(instances or sprites) ? " | " : ""}Tilemaps";
		}
		
		draw_set_valign(fa_bottom);
		var _pad = 16;
		draw_text(_pad, room_height - _pad, _message);
		draw_set_valign(fa_top);
	},
	get: function() {
		var _flags = 0;
		_flags |= (ROOM_LOADER_FLAG.INSTANCES * instances);
		_flags |= (ROOM_LOADER_FLAG.SPRITES * sprites);
		_flags |= (ROOM_LOADER_FLAG.TILEMAPS * tilemaps);
		return _flags;
	},
};
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

loader = new RoomLoader()
.init_prefix("rm_demo_load_");
