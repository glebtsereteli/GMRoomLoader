/// @feather ignore all

function RoomLoader() constructor {
	#region private
	
	static __data = {
		__pool: {},
		__prefix: undefined,
		
		__add: function(_room) {
			__pool[$ room_get_name(_room)] = new __RoomLoaderData(_room);	
		},
		__remove: function(_room) {
			struct_remove(__pool, room_get_name(_room));
		},
		__get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	static __whitelist = new __RoomLoaderFilter(true);
	static __blacklist = new __RoomLoaderFilter(false);
	static __return_data = undefined;
	
	static __layer_failed_filters = function(_name) {
		var _match = ((__whitelist.__check(_name)) and (not __blacklist.__check(_name)));
		return (not _match);
	};
	
	#endregion
	
	// Initialization:
	static init = function() {
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i]);
			_i++;
		}
		return self;
	};
	static init_array = function(_rooms) {
		script_execute_ext(init, _rooms);
		return self;
	};
	static init_prefix = function(_prefix) {
		static _all_rooms = asset_get_ids(asset_room);
		static _init = method(__data, function(_room) {
			if (not __roomloader_room_has_prefix(_room, __prefix)) return;
			__add(_room);
		});
		
		__data.__prefix = _prefix;
		array_foreach(_all_rooms, _init);
		return self;
	};
	
	// Loading:
	static load = function(_room, _x, _y, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		var _data = get_data(_room);
		if (_data == undefined) return undefined;
		
		__return_data = new RoomLoaderReturnData();
		_data.__load(_x, _y, _origin, _flags);
		return __return_data;
	};
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = get_data(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_layer, _layer);
	};
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = get_data(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	// Whitelist/Blacklist Layer Filtering:
	static whitelist_set = function() {
		__whitelist.__reset();
		var _i = 0; repeat (argument_count) {
			__whitelist.__add(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
		return self;
	};
	static whitelist_set_array = function(_layers) {
		script_execute_ext(whitelist_set, _layers);
		return self;
	};
	static whitelist_reset = function() {
		__whitelist.__reset();
		return self;
	};
	
	static blacklist_set = function() {
		__blacklist.__reset();
		var _i = 0; repeat (argument_count) {
			__blacklist.__add(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
		return self;
	};
	static blacklist_set_array = function(_layers) {
		script_execute_ext(blacklist_set, _layers);
		return self;
	};
	static blacklist_reset = function() {
		__blacklist.__reset();
		return self;
	};
	
	// Removal:
	static remove = function() {
		var _i = 0; repeat (argument_count) {
			__data.__remove(argument[_i]);
			_i++;
		}
		return self;
	};
	static remove_array = function(_rooms) {
		script_execute_ext(remove, _rooms);
		return self;
	};
	static remove_prefix = function(_prefix) {
		static _remove = method(__data, function(_name, _data) {
			if (not __roomloader_room_has_prefix(_data.__room, __prefix)) return;
			struct_remove(__pool, _name);
		});
		
		__data.__prefix = _prefix;
		struct_foreach(__data.__pool, _remove);
	};
	static clear = function() {
		__data.__pool = {};
	};
	
	// Getters:
	static get_data = function(_room) {
		return __data.__get(_room);
	};
}
function RoomLoaderReturnData() constructor {
	#region private
	
	__layers = [];
	__instances = undefined;
	__tilemaps = [];
	__sprites = [];
	__particle_systems = []
	__sequences = [];
	__backgrounds = [];
	__cleaned_up = false;
	
	#endregion
	
	static cleanup = function() {
		static _tilemaps = function(_tilemap) {	layer_tilemap_destroy(_tilemap.id); };
		static _sprites = function(_sprite) { layer_sprite_destroy(_sprite.id); };
		static _particle_systems = function(_particle_system) { part_system_destroy(_particle_system.id); };
		static _sequences = function(_sequence) { layer_sequence_destroy(_sequence.id); };
		static _backgrounds = function(_background) { layer_background_destroy(_background.id); };
		static _layers = function (_layer) { layer_destroy(_layer) };
		
		if (__cleaned_up) return;
		
		__cleaned_up = true;
		
		array_foreach(__instances, instance_destroy);
		array_foreach(__tilemaps, _tilemaps);
		array_foreach(__sprites, _sprites);
		array_foreach(__particle_systems, _particle_systems);
		array_foreach(__sequences, _sequences);
		array_foreach(__backgrounds, _backgrounds);
		array_foreach(__layers, _layers);
	};
};

RoomLoader();
