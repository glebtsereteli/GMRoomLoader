EVENT_METHOD;

show_debug_overlay(true, true);

flags = {
	instances: true,
	sprites: true,
	tilemaps: true,
	particle_systems: true,
	sequences: true,
	backgrounds: true,
	
	update: function() {
		instances ^= keyboard_check_pressed(vk_numpad1);
		sprites ^= keyboard_check_pressed(vk_numpad2);
		tilemaps ^= keyboard_check_pressed(vk_numpad3);
		particle_systems ^= keyboard_check_pressed(vk_numpad4);
		sequences ^= keyboard_check_pressed(vk_numpad5);
		backgrounds ^= keyboard_check_pressed(vk_numpad6);
	},
	draw: function() {
		var _message = "Flags: ";
		var _flags = get();
		if (_flags == 0) _message += "None";
		else {
			if (instances) _message += "Instances";
			if (sprites) _message += $"{instances ? " | " : ""}Sprites";
			if (tilemaps) _message += $"{(instances or sprites) ? " | " : ""}Tilemaps";
			if (particle_systems) _message += $"{(instances or sprites or tilemaps) ? " | " : ""}Particle Systems";
			if (sequences) _message += $"{(instances or sprites or tilemaps or particle_systems) ? " | " : ""}Sequences";
			if (backgrounds) _message += $"{(instances or sprites or tilemaps or particle_systems or backgrounds) ? " | " : ""}Backgrounds";
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
		_flags |= (ROOM_LOADER_FLAG.PARTICLE_SYSTEMS * particle_systems);
		_flags |= (ROOM_LOADER_FLAG.SEQUENCES * sequences);
		_flags |= (ROOM_LOADER_FLAG.BACKGROUNDS * backgrounds);
		return _flags;
	},
};
data = {
	ref: undefined,
	
	set: function(_ref) {
		cleanup();
		ref = _ref;
	},
	cleanup: function() {
		with (ref) {
			cleanup();	
		}
	},
};

loader = new RoomLoader()
.init_prefix("rm_demo_load_");
