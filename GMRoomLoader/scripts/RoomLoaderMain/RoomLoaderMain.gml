/// @feather ignore all

function RoomLoader() constructor {
	#region __private
	
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
	static __layer_whitelist = new __RoomLoaderFilter(true);
	static __layer_blacklist = new __RoomLoaderFilter(false);
	static __return_data = undefined;
	
	static __layer_failed_filters = function(_name) {
		var _match = ((__layer_whitelist.__check(_name)) and (not __layer_blacklist.__check(_name)));
		return (not _match);
	};
	
	#endregion
	
	#region data initialization
	
	/// @param {Asset.GMRoom} ...rooms The rooms to initialize data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all given rooms. 
	static data_init = function() {
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to initialize data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms in the given array.
	static data_init_array = function(_rooms) {
		script_execute_ext(data_init, _rooms);
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms starting with the given prefix.
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
	
	#endregion
	#region data removal
	
	/// @param {Asset.GMRoom} ...rooms The rooms to remove data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) given rooms. 
	static data_remove = function() {
		var _i = 0; repeat (argument_count) {
			__data.__remove(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to remove data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) rooms in the given array.
	static data_remove_array = function(_rooms) {
		script_execute_ext(data_remove, _rooms);
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) rooms starting with the given prefix.
	static data_remove_prefix = function(_prefix) {
		static _remove = method(__data, function(_name, _data) {
			if (not __roomloader_room_has_prefix(_data.__room, __prefix)) return;
			struct_remove(__pool, _name);
		});
		
		__data.__prefix = _prefix;
		struct_foreach(__data.__pool, _remove);
		return self;
	};
	
	/// @desc Removes all initialized room data.
	static data_clear = function() {
		__data.__pool = {};
		return self;
	};
	
	#endregion
	#region layer whitelist
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Whitelist filter.
	static layer_whitelist_add = function() {
		var _i = 0; repeat (argument_count) {
			__layer_whitelist.__add(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes all given layer names from the Whitelist filter.
	static layer_whitelist_remove = function() {
		var _i = 0; repeat (argument_count) {
			__layer_whitelist.__remove(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Whitelist filter.
	static layer_whitelist_reset = function() {
		__layer_whitelist.__reset();
		return self;
	};
	
	#endregion
	#region layer blacklist
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Blacklist filter.
	static layer_blacklist_add = function() {
		var _i = 0; repeat (argument_count) {
			__layer_blacklist.__add(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes all given layer names from the Blacklist filter.
	static layer_blacklist_remove = function() {
		var _i = 0; repeat (argument_count) {
			__layer_blacklist.__remove(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Blacklist filter.
	static layer_blacklist_reset = function() {
		__layer_blacklist.__reset();
		return self;
	};
	
	#endregion
	#region loading
	
	/// @param {Asset.GMRoom} room The room to load.
	/// @param {Real} x The x coordinate to load the room at.
	/// @param {Real} y The y coordinate to load the room at.
	/// @param {Enum.ROOMLOADER_ORIGIN} [origin] OPTIONAL! The origin to load the room at. Defaults to the ROOMLOADER_DEFAULT_ORIGIN config macro.
	/// @param {Enum.ROOMLOADER_FLAG} [flags] OPTIONAL! The flags to filter the loaded data by. Defaults to the ROOMLOADER_DEFAULT_FLAGS config macro.
	/// @returns {struct.RoomLoaderReturnData, undefined}
	/// @desc Loads the given room at the given coordinates and [origin], filtered by the given [flags]. 
	/// Returns an instance of RoomLoaderReturnData on success or undefined on fail.
	static load = function(_room, _x, _y, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		var _data = __data.__get(_room);
		if (_data == undefined) return undefined;
		
		__return_data = new RoomLoaderReturnData();
		return _data.__load(_x, _y, _origin, _flags);
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Id.Layer, String} [layer] The layer ID or name to assign instances to.
	/// @param {Enum.ROOMLOADER_ORIGIN} [origin] OPTIONAL! The origin to load instances at. Defaults to the ROOMLOADER_DEFAULT_ORIGIN config macro.
	/// @returns {Array<Id.Instance>, undefined}
	/// @desc Loads the given room's instances at the given coordinates, layer and [origin].
	/// Returns an array of instance IDs on success or undefined on fail.
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __data.__get(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_layer, _layer);
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Real} depth The depth to create instances at.
	/// @param {Enum.ROOMLOADER_ORIGIN} [origin] OPTIONAL! The origin to load instances at. Defaults to the ROOMLOADER_DEFAULT_ORIGIN config macro.
	/// @returns {Array<Id.Instance>, undefined}s
	/// @desc Loads the given room's instances at the given coordinates, depth and [origin].
	/// Returns an array of instance IDs on success or undefined on fail.
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __data.__get(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	#endregion
}
function RoomLoaderReturnData() constructor {
	#region __private
	
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
	
	/// @returns {Array<Id.Instance>}
	/// @desc Returns an array of created Instances.
	static get_instances = function() {
		return __instances;
	};
	
	/// @param {String} name The Tilemap name to search for.
	/// @returns {Id.Tilemap, undefined}
	/// @desc Returns the Tilemap ID matching the given name if found, or undefined if not found.
	static get_tilemap = function(_name) {
		return __getter_get_element(__tilemaps, _name);
	};
	
	/// @returns {Array<Id.Tilemap>}
	/// @desc Returns an array of created Tilemaps.
	static get_tilemaps = function() {
		return __getter_map_elements(__tilemaps);
	};
	
	/// @param {String} name The Sprite name to search for.
	/// @returns {Id.Sprite, undefined}
	/// @desc Returns the Sprite ID matching the given name if found, or undefined if not found.
	static get_sprite = function(_name) {
		return __getter_get_element(__sprites, _name);
	};
	
	/// @returns {Array<Id.Sprite>}
	/// @desc Returns an array of created Sprites.
	static get_sprites = function() {
		return __getter_map_elements(__sprites);
	};
	
	/// @param {String} name The Particle System name to search for.
	/// @returns {Id.ParticleSystem, undefined}
	/// @desc Returns the Particle System ID matching the given name if found, or undefined if not found.
	static get_particle_system = function(_name) {
		return __getter_get_element(__particle_systems, _name);
	};
	
	/// @returns {Array<Id.ParticleSystem>}
	/// @desc Returns an array of created Particle Systems.
	static get_particle_systems = function() {
		return __getter_map_elements(__particle_systems);
	};
	
	/// @param {String} name The Sequence name to search for.
	/// @returns {Id.Sequence, undefined}
	/// @desc Returns the Sequence ID matching the given name if found, or undefined if not found.
	static get_sequence = function(_name) {
		return __getter_get_element(__sequences, _name);
	};
	
	/// @returns {Array<Id.Sequence>}
	/// @desc Returns an array of created Sequences.
	static get_sequences = function() {
		return __getter_map_elements(__sequences);
	};
	
	/// @param {String} name The Background name to search for.
	/// @returns {Id.Background, undefined}
	/// @desc Returns the Background ID matching the given name if found, or undefined if not found.
	static get_background = function(_name) {
		return __getter_get_element(__backgrounds, _name);
	};
	
	/// @returns {Array<Id.Background>}
	/// @desc Returns an array of created Backgrounds.
	static get_backgrounds = function() {
		return __getter_map_elements(__backgrounds);
	};
	
	#endregion
	#region cleanup
	
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

	#endregion
};

RoomLoader();
