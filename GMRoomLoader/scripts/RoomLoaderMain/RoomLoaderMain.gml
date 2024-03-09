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
		
		__add: function(_room, _method_name) {
			__roomloader_catch_nonroom(_room, _method_name, "initialize data for");
			
			var _room_name = room_get_name(_room);
			if (struct_exists(__pool, _room_name)) {
				__roomloader_log_method(_method_name, $"Data for <{_room_name}> is already initialized, skipping");
				return;
			}
			
			__pool[$ _room_name] = new __RoomLoaderData(_room);
			__roomloader_log_method(_method_name, $"Initialized data for <{_room_name}>");
		},
		__remove: function(_room, _method_name) {
			__roomloader_catch_nonroom(_room, _method_name, "remove data for");
			
			var _room_name = room_get_name(_room);
			if (not struct_exists(__pool, _room_name)) {
				__roomloader_log_method(_method_name, $"Data for <{_room_name}> doesn't exist, there's nothing to remove");
				return;
			}
			
			struct_remove(__pool, _room_name);
			__roomloader_log_method(_method_name, $"Removed data for <{_room_name}>");
		},
		__get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	static __all_rooms = undefined;
	static __layer_whitelist = new __RoomLoaderFilter("whitelist", true);
	static __layer_blacklist = new __RoomLoaderFilter("blacklist", false);
	static __return_data = undefined;
	
	static __layer_failed_filters = function(_name) {
		var _match = ((__layer_whitelist.__check(_name)) and (not __layer_blacklist.__check(_name)));
		return (not _match);
	};
	static __get_load_data = function(_room, _method_name, _nonroom_message, _nodata_message) {
		__roomloader_catch_nonroom(_room, _method_name, _nonroom_message);
		
		var _data = __data.__get(_room);
		if (_data != undefined) return _data;
		
		var _room_name = $"<{room_get_name(_room)}>";
		__roomloader_error($"RoomLoader.{_method_name}(): Could not find the data for room {_room_name}.\nMake sure to initialize data for your rooms before trying to {_nodata_message}");
	};
	
	#endregion
	
	#region data initialization
	
	/// @param {Asset.GMRoom} ...rooms The rooms to initialize data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all given rooms.
	/// @context RoomLoader
	static data_init = function() {
		static _method_name = "data_init";
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i], _method_name);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to initialize data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms in the given array.
	/// @context RoomLoader
	static data_init_array = function(_rooms) {
		static _method_name = "data_init_array";
		__roomloader_catch_argument(_rooms, is_array, _method_name, "Array");
		
		var _i = 0; repeat (array_length(_rooms)) {
			__data.__add(_rooms[_i], _method_name);
			_i++;
		}
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Array<Asset.GMRoom>}
	/// @desc Initializes data for all rooms starting with the given prefix,
	/// returns an array of filtered rooms.
	/// @context RoomLoader
	static data_init_prefix = function(_prefix) {
		static _method_name = "data_init_prefix";
		static _closure = { prefix: undefined };
		static _filter = method(_closure, function(_room) {
			var _name = room_get_name(_room);
			return (string_pos(prefix, _name) > 0);
		});
		
		__roomloader_catch_argument(_prefix, is_string, _method_name, "String");
		
		__all_rooms ??= asset_get_ids(asset_room);
		_closure.prefix = _prefix;
		var _rooms = array_filter(__all_rooms, _filter);
		
		var _n = array_length(_rooms);
		if (_n == 0) {
			__roomloader_log_method(_method_name, $"Could not find any rooms starting with \"{_prefix}\"");
			return _rooms;
		}
		
		var _i = 0; repeat (_n) {
			__data.__add(_rooms[_i], _method_name);
			_i++;
		}
		
		return _rooms;
	};
	
	#endregion
	#region data removal
	
	/// @param {Asset.GMRoom} ...rooms The rooms to remove data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) given rooms.
	/// @context RoomLoader
	static data_remove = function() {
		static _method_name = "data_remove";
		var _i = 0; repeat (argument_count) {
			__data.__remove(argument[_i], _method_name);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to remove data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) rooms in the given array.
	/// @context RoomLoader
	static data_remove_array = function(_rooms) {
		static _method_name = "data_remove_array";
		__roomloader_catch_argument(_rooms, is_array, _method_name, "Array");
		
		var _i = 0; repeat (array_length(_rooms)) {
			__data.__remove(_rooms[_i], _method_name);
			_i++;
		}
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) rooms starting with the given prefix.
	/// @context RoomLoader
	static data_remove_prefix = function(_prefix) {
		static _method_name = "data_remove_prefix";
		static _closure = { prefix: undefined };
		static _filter = method(_closure, function(_room_name) {
			return (string_pos(prefix, _room_name) > 0);
		});
		
		_closure.prefix = _prefix;
		var _names = array_filter(struct_get_names(__data.__pool), _filter);
		
		var _n = array_length(_names);
		if (_n == 0) {
			return __roomloader_log_method(_method_name, $"Could not find any rooms starting with \"{_prefix}\"");	
		}
		
		var _i = 0; repeat (array_length(_names)) {
			var _name = _names[_i];
			struct_remove(__data.__pool, _names[_i]);
			__roomloader_log_method(_method_name, $"Removed data for <{_name}>");
			_i++;
		}
		
		return self;
	};
	
	/// @desc Removes all initialized room data.
	/// @context RoomLoader
	static data_clear = function() {
		__data.__pool = {};
		return self;
	};
	
	#endregion
	#region data misc
	
	/// @param {Asset.GMRoom} room The room to check.
	/// @returns {Bool}
	/// @desc Checks whether the data for the given room is initialized (returns true) or not (return false).
	/// @context RoomLoader
	static data_is_initialized = function(_room) {
		__roomloader_catch_nonroom(_room, "data_is_initialized", $"check whether data is initialized for");
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
	/// @context RoomLoader
	static load = function(_room, _x, _y, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		var _data = __get_load_data(_room, "load", "load", "load them");
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
	/// @context RoomLoader
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __get_load_data(_room, "load_instances_layer", "load instances for", "load their instances");
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
	/// @context RoomLoader
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __get_load_data(_room, "load_instances_depth", "load instances for", "load their instances");
		return __roomloader_load_instances(_x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	#endregion
	#region layer whitelist
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Whitelist filter.
	/// @context RoomLoader
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
	/// @context RoomLoader
	static layer_whitelist_remove = function() {
		var _i = 0; repeat (argument_count) {
			__layer_whitelist.__remove(argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Whitelist filter.
	/// @context RoomLoader
	static layer_whitelist_reset = function() {
		__layer_whitelist.__reset();
		return self;
	};
	
	/// @returns {Array<String>}
	/// @desc Returns an array of whitelisted layer names.
	/// @context RoomLoader
	static layer_whitelist_get = function() {
		return __layer_whitelist.__get();
	};
	
	#endregion
	#region layer blacklist
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Blacklist filter.
	/// @context RoomLoader
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
	/// @context RoomLoader
	static layer_blacklist_remove = function() {
		var _i = 0; repeat (argument_count) {
			__layer_blacklist.__remove(argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Blacklist filter.
	/// @context RoomLoader
	static layer_blacklist_reset = function() {
		__layer_blacklist.__reset();
		return self;
	};
	
	/// @returns {Array<String>}
	/// @desc Returns an array of blacklisted layer names.
	/// @context RoomLoader
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
	/// @context RoomLoader
	static take_screenshot = function(_room, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_FLAG.ALL) {
		var _data = __get_load_data(_room, "take_screenshot", "take a screenshot of", "take screenshots");
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
	/// @context RoomLoaderReturnData
	static get_layer = function(_name) {
		return __layers.__get(_name);
	};
	
	/// @returns {Array<Id.Layer>}
	/// @desc Returns an array of created layers.
	/// @context RoomLoaderReturnData
	static get_layers = function() {
		return __layers.__ids;
	};
	
	/// @returns {Array<Id.Instance>}
	/// @desc Returns an array of created Instances.
	/// @context RoomLoaderReturnData
	static get_instances = function() {
		return __instances.__ids;
	};
	
	/// @param {String} layer_name The Tilemap layer name to search for.
	/// @returns {Id.Tilemap, undefined}
	/// @desc Returns the Tilemap ID matching the given layer name if found, or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_tilemap = function(_layer_name) {
		return __tilemaps.__get(_layer_name);
	};
	
	/// @returns {Array<Id.Tilemap>}
	/// @desc Returns an array of created Tilemaps.
	/// @context RoomLoaderReturnData
	static get_tilemaps = function() {
		return __tilemaps.__ids;
	};
	
	/// @param {String} name The Sprite name to search for.
	/// @returns {Id.Sprite, undefined}
	/// @desc Returns the Sprite ID matching the given name if found, or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_sprite = function(_name) {
		return __sprites.__get(_name);
	};
	
	/// @returns {Array<Id.Sprite>}
	/// @desc Returns an array of created Sprites.
	/// @context RoomLoaderReturnData
	static get_sprites = function() {
		return __sprites.__ids;
	};
	
	/// @param {String} name The Particle System name to search for.
	/// @returns {Id.ParticleSystem, undefined}
	/// @desc Returns the created Particle System ID matching the given name if found, or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_particle_system = function(_name) {
		return __particle_systems.__get(_name);
	};
	
	/// @returns {Array<Id.ParticleSystem>}
	/// @desc Returns an array of created Particle Systems.
	/// @context RoomLoaderReturnData
	static get_particle_systems = function() {
		return __particle_systems.__ids;
	};
	
	/// @param {String} name The Sequence name to search for.
	/// @returns {Id.Sequence, undefined}
	/// @desc Returns the created Sequence ID matching the given name if found, or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_sequence = function(_name) {
		return __sequences.__get(_name);
	};
	
	/// @returns {Array<Id.Sequence>}
	/// @desc Returns an array of created Sequences.
	/// @context RoomLoaderReturnData
	static get_sequences = function() {
		return __sequences.__ids;
	};
	
	/// @param {String} layer_name The Background layer name to search for.
	/// @returns {Id.Background, undefined}
	/// @desc Returns the created Background ID matching the given layer name if found, or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_background = function(_layer_name) {
		return __backgrounds.__get(_layer_name);
	};
	
	/// @returns {Array<Id.Background>}
	/// @desc Returns an array of created Backgrounds.
	/// @context RoomLoaderReturnData
	static get_backgrounds = function() {
		return __backgrounds.__ids;
	};
	
	#endregion
	#region cleanup
	
	/// @returns {Undefined}
	/// @desc Destroys created layers and their elements. After calling this method, the instance becomes practically 
	/// useless and should be dereferenced to be picked up by the Garbage Collector.
	/// @context RoomLoaderReturnData
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
