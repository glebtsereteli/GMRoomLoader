/// @feather ignore all

/// @desc Main interface. Handles data initialization and removal, room loading, 
/// layer filtering and taking room screenshots.
/// 
/// NOTE: This is a statically-initialized constructor, it should NOT be explicitly instantiated.
/// All methods are to be called as follows: RoomLoader.action(<arguments>).
function RoomLoader() constructor {
	#region __private
	
	static __data = {
		__pool: {},
		__prefix: undefined,
		
		__add: function(_room, _func_name) {
			var _type = typeof(_room);
			if ((_type != "ref") or (not room_exists(_room))) {
				__roomloader_error($"RoomLoader.{_func_name}(): Could not initialize data for \"{_room}\". Expected \{Asset.GMRoom\}, got \{{_type}\}");
			}
			
			__pool[$ room_get_name(_room)] = new __RoomLoaderData(_room);	
		},
		__remove: function(_room) {
			struct_remove(__pool, room_get_name(_room));
		},
		__get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	static __all_rooms = undefined;
	static __layer_whitelist = new __RoomLoaderFilter(true);
	static __layer_blacklist = new __RoomLoaderFilter(false);
	static __return_data = undefined;
	
	static __layer_failed_filters = function(_name) {
		var _match = ((__layer_whitelist.__check(_name)) and (not __layer_blacklist.__check(_name)));
		return (not _match);
	};
	static __show_error_noroomdata = function(_room, _func_name, _ending) {
		var _room_name = $"\"{room_get_name(_room)}\"";
		__roomloader_error($"RoomLoader.{_func_name}(): Could not find the data for room {_room_name}.\nMake sure to initialize data for your rooms before trying to load them.");
	};
	
	#endregion
	
	#region data initialization
	
	/// @param {Asset.GMRoom} ...rooms The rooms to initialize data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all given rooms. 
	static data_init = function() {
		static _func_name = "data_init";
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i], _func_name);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to initialize data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms in the given array.
	static data_init_array = function(_rooms) {
		static _func_name = "data_init_array";
		var _i = 0; repeat (array_length(_rooms)) {
			__data.__add(_rooms[_i], _func_name);
			_i++;
		}
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms starting with the given prefix.
	static data_init_prefix = function(_prefix) {
		static _init = method(__data, function(_room) {
			static _func_name = "data_init_prefix";
			if (__roomloader_room_has_prefix(_room, __prefix)) {
				__add(_room, _func_name);
			}
		});
		
		__all_rooms ??= asset_get_ids(asset_room);
		__data.__prefix = _prefix;
		array_foreach(__all_rooms, _init);
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
	#region data misc
	
	/// @param {Asset.GMRoom} room The room to check.
	/// @returns {Bool}
	/// @desc Checks whether the data for the given room is initialized (returns true) or not (return false).
	static data_is_initialized = function(_room) {
		return (__data.__get(_room) != undefined);
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
		if (_data == undefined) {
			__show_error_noroomdata(_room, "load", "load it");
		}
		
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
	/// Returns an array of created Instances on success or undefined on fail.
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __data.__get(_room);
		if (_data == undefined) {
			__show_error_noroomdata(_room, "load_instances_layer", "load its instances");
		}
		
		return __roomloader_load_instances(_x, _y, _data, _origin, instance_create_layer, _layer);
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Real} depth The depth to create instances at.
	/// @param {Enum.ROOMLOADER_ORIGIN} [origin] OPTIONAL! The origin to load instances at. Defaults to the ROOMLOADER_DEFAULT_ORIGIN config macro.
	/// @returns {Array<Id.Instance>, undefined}s
	/// @desc Loads the given room's instances at the given coordinates, depth and [origin].
	/// Returns an array of created Instances on success or undefined on fail.
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __data.__get(_room);
		if (_data == undefined) {
			__show_error_noroomdata(_room, "load_instances_depth", "load its instances");
		}
		
		return __roomloader_load_instances(_x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	#endregion
	#region layer whitelist
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Whitelist filter.
	static layer_whitelist_add = function() {
		var _i = 0; repeat (argument_count) {
			__layer_whitelist.__add(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes all given layer names from the Whitelist filter.
	static layer_whitelist_remove = function() {
		var _i = 0; repeat (argument_count) {
			__layer_whitelist.__remove(argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Whitelist filter.
	static layer_whitelist_reset = function() {
		__layer_whitelist.__reset();
		return self;
	};
	
	/// @returns {Array<String>}
	/// @desc Returns an array of whitelisted layer names.
	static layer_whitelist_get = function() {
		return __layer_whitelist.__get();
	};
	
	#endregion
	#region layer blacklist
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Blacklist filter.
	static layer_blacklist_add = function() {
		var _i = 0; repeat (argument_count) {
			__layer_blacklist.__add(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes all given layer names from the Blacklist filter.
	static layer_blacklist_remove = function() {
		var _i = 0; repeat (argument_count) {
			__layer_blacklist.__remove(argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Blacklist filter.
	static layer_blacklist_reset = function() {
		__layer_blacklist.__reset();
		return self;
	};
	
	/// @returns {Array<String>}
	/// @desc Returns an array of blacklisted layer names.
	static layer_blacklist_get = function() {
		return __layer_blacklist.__get();
	};
	
	#endregion
	#region misc
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Enum.ROOMLOADER_ORIGIN} [origin] OPTIONAL! The origin set to the generated sprite. Defaults to the ROOMLOADER_DEFAULT_ORIGIN config macro.
	/// @param {Enum.ROOMLOADER_FLAG} [flags] OPTIONAL! The flags to filter the room elements by. Defaults to the ROOMLOADER_FLAG.ALL.
	/// @returns {Asset.GMSprite, Undefined}
	/// @desc Takes a screenshot of the given room.
	/// Assigns the given origin to the created sprite and filters the drawn elements by the given flags.
	/// Returns a Sprite ID if the data for the given room has previously been initialized, or undefined if it hasn't.
	static take_screenshot = function(_room, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_FLAG.ALL) {
		var _data = __data.__get(_room);
		if (_data == undefined) {
			__show_error_noroomdata(_room, "take_screenshot", "take a screenshot of it");	
		}
		
		return _data.__take_screenshot(_origin, _flags);
	};
	
	#endregion
}

/// @desc Returned by RoomLoader's .load() method. Stores all layers and elements created on load, 
/// and handles element fetching and cleanup.
/// 
/// NOTE: This constructor is only used by RoomLoader's .load() method, it should NOT be explicitly instantiated.
function RoomLoaderReturnData() constructor {
	#region __private
	
	static __Container = function(_on_destroy) constructor {
		__ids = [];
		__names = [];
		
		__on_destroy = _on_destroy;
		static __add = function(_id, _name) {
			array_push(__ids, _id);
			array_push(__names, _name);
		};
		static __get = function(_name) {
			var _index = array_get_index(__names, _name);
			return ((_index == -1) ? undefined : __ids[_index]);
		};
		static __destroy = function() {
			static _callback = function(_element) { __on_destroy(_element); };
			array_foreach(__ids, _callback);
		};
	};
	
	__layers = new __Container(layer_destroy);
	__instances = {
		__ids: undefined,
		__index: 0,
		__destroy: function() {
			array_foreach(__ids, instance_destroy);
		},
	};
	__tilemaps = new __Container(layer_tilemap_destroy);
	__sprites = new __Container(layer_sprite_destroy);
	__particle_systems = new __Container(part_system_destroy);
	__sequences = new __Container(layer_sequence_destroy);
	__backgrounds = new __Container(layer_background_destroy);
	__cleaned_up = false;
	
	#endregion
	
	#region getters
	
	/// @param {String} layer_name Thes layer name to search for.
	/// @returns {Id.Layer, undefined}
	/// @desc Returns the layer ID matching the given name if found, or undefined if not found.
	static get_layer = function(_name) {
		return __layers.__get(_name);
	};
	
	/// @returns {Array<Id.Layer>}
	/// @desc Returns an array of created layers.
	static get_layers = function() {
		return __layers.__ids;
	};
	
	/// @returns {Array<Id.Instance>}
	/// @desc Returns an array of created Instances.
	static get_instances = function() {
		return __instances.__ids;
	};
	
	/// @param {String} layer_name The Tilemap layer name to search for.
	/// @returns {Id.Tilemap, undefined}
	/// @desc Returns the Tilemap ID matching the given layer name if found, or undefined if not found.
	static get_tilemap = function(_layer_name) {
		return __tilemaps.__get(_layer_name);
	};
	
	/// @returns {Array<Id.Tilemap>}
	/// @desc Returns an array of created Tilemaps.
	static get_tilemaps = function() {
		return __tilemaps.__ids;
	};
	
	/// @param {String} name The Sprite name to search for.
	/// @returns {Id.Sprite, undefined}
	/// @desc Returns the Sprite ID matching the given name if found, or undefined if not found.
	static get_sprite = function(_name) {
		return __sprites.__get(_name);
	};
	
	/// @returns {Array<Id.Sprite>}
	/// @desc Returns an array of created Sprites.
	static get_sprites = function() {
		return __sprites.__ids;
	};
	
	/// @param {String} name The Particle System name to search for.
	/// @returns {Id.ParticleSystem, undefined}
	/// @desc Returns the created Particle System ID matching the given name if found, or undefined if not found.
	static get_particle_system = function(_name) {
		return __particle_systems.__get(_name);
	};
	
	/// @returns {Array<Id.ParticleSystem>}
	/// @desc Returns an array of created Particle Systems.
	static get_particle_systems = function() {
		return __particle_systems.__ids;
	};
	
	/// @param {String} name The Sequence name to search for.
	/// @returns {Id.Sequence, undefined}
	/// @desc Returns the created Sequence ID matching the given name if found, or undefined if not found.
	static get_sequence = function(_name) {
		return __sequences.__get(_name);
	};
	
	/// @returns {Array<Id.Sequence>}
	/// @desc Returns an array of created Sequences.
	static get_sequences = function() {
		return __sequences.__ids;
	};
	
	/// @param {String} layer_name The Background layer name to search for.
	/// @returns {Id.Background, undefined}
	/// @desc Returns the created Background ID matching the given layer name if found, or undefined if not found.
	static get_background = function(_layer_name) {
		return __backgrounds.__get(_layer_name);
	};
	
	/// @returns {Array<Id.Background>}
	/// @desc Returns an array of created Backgrounds.
	static get_backgrounds = function() {
		return __backgrounds.__ids;
	};
	
	#endregion
	#region cleanup
	
	/// @returns {Undefined}
	/// @desc Destroys created layers and their elements. After calling this method, the instance becomes practically 
	/// useless and should be dereferenced to be picked up by the Garbage Collector.
	static cleanup = function() {
		if (__cleaned_up) return;
		
		__cleaned_up = true;
		__instances.__destroy();
		__tilemaps.__destroy();
		__sprites.__destroy();
		__particle_systems.__destroy();
		__sequences.__destroy();
		__backgrounds.__destroy();
		__layers.__destroy();
	};

	#endregion
};

RoomLoader();
