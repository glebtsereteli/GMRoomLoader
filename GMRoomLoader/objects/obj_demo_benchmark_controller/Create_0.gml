EVENT_METHOD;

origin = {
	value: ROOMLOADER_ORIGIN.TOP_LEFT,
	
	update: function() {
		static _get = function() {
			switch (keyboard_key) {
				case vk_numpad7: return ROOMLOADER_ORIGIN.TOP_LEFT;
				case vk_numpad8: return ROOMLOADER_ORIGIN.TOP_CENTER;
				case vk_numpad9: return ROOMLOADER_ORIGIN.TOP_RIGHT;
				case vk_numpad4: return ROOMLOADER_ORIGIN.MIDDLE_LEFT;
				case vk_numpad5: return ROOMLOADER_ORIGIN.MIDDLE_CENTER;
				case vk_numpad6: return ROOMLOADER_ORIGIN.MIDDLE_RIGHT;
				case vk_numpad1: return ROOMLOADER_ORIGIN.BOTTOM_LEFT;
				case vk_numpad2: return ROOMLOADER_ORIGIN.BOTTOM_CENTER;
				case vk_numpad3: return ROOMLOADER_ORIGIN.BOTTOM_RIGHT;
			}
		};
		value = (_get() ?? value);
	},
	get: function() {
		return value;	
	},
};
flags = {
	instances: true,
	sprites: true,
	tilemaps: true,
	particle_systems: true,
	sequences: true,
	backgrounds: true,
	
	update: function() {
		//instances ^= keyboard_check_pressed(vk_numpad1);
		//sprites ^= keyboard_check_pressed(vk_numpad2);
		//tilemaps ^= keyboard_check_pressed(vk_numpad3);
		//particle_systems ^= keyboard_check_pressed(vk_numpad4);
		//sequences ^= keyboard_check_pressed(vk_numpad5);
		//backgrounds ^= keyboard_check_pressed(vk_numpad6);
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
		_flags |= (ROOMLOADER_FLAG.INSTANCES * instances);
		_flags |= (ROOMLOADER_FLAG.SPRITES * sprites);
		_flags |= (ROOMLOADER_FLAG.TILEMAPS * tilemaps);
		_flags |= (ROOMLOADER_FLAG.PARTICLE_SYSTEMS * particle_systems);
		_flags |= (ROOMLOADER_FLAG.SEQUENCES * sequences);
		_flags |= (ROOMLOADER_FLAG.BACKGROUNDS * backgrounds);
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

RoomLoader.data_init_prefix("rm_demo_benchmark");
