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
	#region data
	
	// Initialization:
	static data_init = function() {
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i]);
			_i++;
		}
		return self;
	};
	static data_init_array = function(_rooms) {
		script_execute_ext(data_init, _rooms);
		return self;
	};
	static data_init_prefix = function(_prefix) {
		static _all_rooms = asset_get_ids(asset_room);
		static _init = method(__data, function(_room) {
			if (not __roomloader_room_has_prefix(_room, __prefix)) return;
			__add(_room);
		});
		
		__data.__prefix = _prefix;
		array_foreach(_all_rooms, _init);
		return self;
	};
	
	// Removal:
	static data_remove = function() {
		var _i = 0; repeat (argument_count) {
			__data.__remove(argument[_i]);
			_i++;
		}
		return self;
	};
	static data_remove_array = function(_rooms) {
		script_execute_ext(data_remove, _rooms);
		return self;
	};
	static data_remove_prefix = function(_prefix) {
		static _remove = method(__data, function(_name, _data) {
			if (not __roomloader_room_has_prefix(_data.__room, __prefix)) return;
			struct_remove(__pool, _name);
		});
		
		__data.__prefix = _prefix;
		struct_foreach(__data.__pool, _remove);
	};
	static data_clear = function() {
		__data.__pool = {};
	};
	
	// Getters:
	static data_get = function(_room) {
		return __data.__get(_room);
	};
	
	#endregion
	#region whitelist/blacklist
	
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
	
	#endregion
	#region loading
	
	static load = function(_room, _x, _y, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		var _data = data_get(_room);
		if (_data == undefined) return undefined;
		
		__return_data = new RoomLoaderReturnData();
		return _data.__load(_x, _y, _origin, _flags);
	};
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = data_get(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_layer, _layer);
	};
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = data_get(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	#endregion
}
function RoomLoaderReturnData() constructor {
	#region private
	
	__layers = [];
	__instances = undefined;
	__instance_index = 0;
	__tilemaps = [];
	__sprites = [];
	__particle_systems = []
	__sequences = [];
	__backgrounds = [];
	__cleaned_up = false;
	
	static __getter_get_element = function(_array, _name) {
		var _i = 0; repeat (array_length(_array)) {
			var _element = _array[_i];
			if (_element.name == _name) {
				return _element.id;
			}
			_i++;
		}
		return undefined;
	};
	static __getter_map_elements = function(_array) {
		static _map = function(_element) { return _element.id; }
		return array_map(_array, _map);
	};
	
	#endregion
	#region getters
	
	static get_instances = function() {
		return __instances;
	};
	
	static get_tilemap = function(_name) {
		return __getter_get_element(__tilemaps, _name);
	};
	static get_tilemaps = function() {
		return __getter_map_elements(__tilemaps);
	};
	
	static get_sprite = function(_name) {
		return __getter_get_element(__sprites, _name);
	};
	static get_sprites = function() {
		return __getter_map_elements(__sprites);
	};
	
	static get_particle_system = function(_name) {
		return __getter_get_element(__particle_systems, _name);
	};
	static get_particle_systems = function() {
		return __getter_map_elements(__particle_systems);
	};
	
	static get_sequence = function(_name) {
		return __getter_get_element(__sequences, _name);
	};
	static get_sequences = function() {
		return __getter_map_elements(__sequences);
	};
	
	static get_background = function(_name) {
		return __getter_get_element(__backgrounds, _name);
	};
	static get_backgrounds = function() {
		return __getter_map_elements(__backgrounds);
	};
	
	#endregion
	
	static cleanup = function() {
		static _tilemap = function(_tilemap) {	layer_tilemap_destroy(_tilemap.id); };
		static _sprite = function(_sprite) { layer_sprite_destroy(_sprite.id); };
		static _particle_system = function(_particle_system) { part_system_destroy(_particle_system.id); };
		static _sequence = function(_sequence) { layer_sequence_destroy(_sequence.id); };
		static _background = function(_background) { layer_background_destroy(_background.id); };
		static _layer = function (_layer) { layer_destroy(_layer) };
		
		if (__cleaned_up) return;
		
		__cleaned_up = true;
		array_foreach(__instances, instance_destroy);
		array_foreach(__tilemaps, _tilemap);
		array_foreach(__sprites, _sprite);
		array_foreach(__particle_systems, _particle_system);
		array_foreach(__sequences, _sequence);
		array_foreach(__backgrounds, _background);
		array_foreach(__layers, _layer);
	};
};

RoomLoader();
