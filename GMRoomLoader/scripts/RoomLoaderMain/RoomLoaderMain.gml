/// @feather ignore all

/// @func RoomLoader()
/// @desc Main interface. Handles data initialization and removal, room loading, 
/// layer filtering and taking room screenshots.
/// 
/// NOTE: This is a statically initialized constructor, it should NOT be explicitly instantiated.
/// All methods are to be called as follows: RoomLoader.action(<arguments>).
function RoomLoader() {
	#region __private
	
	static __message_prefix = "RoomLoader";
	static __data = {
		__message_prefix: __message_prefix,
		__pool: {},
		
		__add: function(_room, _method_name) {
			__roomloader_catch_nonroom(__message_prefix, _method_name, _room, "initialize data for");
			
			var _room_name = room_get_name(_room);
			if (struct_exists(__pool, _room_name)) {
				__roomloader_log_method(__message_prefix, _method_name, $"Data for <{_room_name}> is already initialized");
				return;
			}
			
			RoomLoader.__benchmark.__start();
			__pool[$ _room_name] = new __RoomLoaderData(_room);
			__roomloader_log_method_timed(__message_prefix, _method_name, "Initialized data for", _room);
		},
		__remove: function(_room, _method_name) {
			__roomloader_catch_nonroom(__message_prefix, _method_name, _room, "remove data for");
			
			var _room_name = room_get_name(_room);
			if (not struct_exists(__pool, _room_name)) {
				__roomloader_log_method(__message_prefix, _method_name, $"Data for <{_room_name}> doesn't exist, there's nothing to remove");
				return;
			}
			
			struct_remove(__pool, _room_name);
			__roomloader_log_method(__message_prefix, _method_name, $"Removed data for <{_room_name}>");
		},
		__get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	static __benchmark = {
		__t: undefined,
		
		__start: function() {
			__t = get_timer();	
		},
		__get: function() {
			return ((get_timer() - __t) / 1000);
		},
	};
	static __all_rooms = undefined;
	static __layer_whitelist = new __RoomLoaderFilter("Whitelist", true);
	static __layer_blacklist = new __RoomLoaderFilter("Blacklist", false);
	static __return_data = undefined;
	
	static __layer_failed_filters = function(_name) {
		var _match = ((__layer_whitelist.__check(_name)) and (not __layer_blacklist.__check(_name)));
		return (not _match);
	};
	static __get_load_data = function(_room, _method_name, _nonroom_message, _nodata_message) {
		__roomloader_catch_nonroom(__message_prefix, _method_name, _room, _nonroom_message);
		
		var _data = __data.__get(_room);
		if (_data != undefined) return _data;
		
		var _room_name = $"<{room_get_name(_room)}>";
		var _message = $"Could not find the data for room {_room_name}.\nMake sure to initialize data for your rooms before trying to {_nodata_message}"
		__roomloader_error_method(__message_prefix, _method_name, _message);
	};
	static __take_screenshot = function(_room, _left, _top, _width, _height, _xorigin, _yorigin, _scale, _flags, _method_name) {
		var _data = __get_load_data(_room, _method_name, "take a screenshot of", "take screenshots");
		
		__benchmark.__start();
		var _screenshot = _data.__take_screenshot(_left, _top, _width, _height, _xorigin, _yorigin, _scale, _flags);
		__roomloader_log_method_timed(__message_prefix, _method_name, "screenshotted", _room);
		return _screenshot;
	};
	
	#endregion
	
	#region data initialization
	
	/// @param {Asset.GMRoom} ...rooms The rooms to initialize data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all given rooms.
	/// @context RoomLoader
	static data_init = function() {
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i], "data_init");
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
		__roomloader_catch_array(__message_prefix, _method_name, _rooms);
		
		var _i = 0; repeat (array_length(_rooms)) {
			__data.__add(_rooms[_i], _method_name);
			_i++;
		}
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Array<Asset.GMRoom>}
	/// @desc Initializes data for all rooms starting with the given prefix. Returns an array of found rooms.
	/// @context RoomLoader
	static data_init_prefix = function(_prefix) {
		static _method_name = "data_init_prefix";
		static _closure = { prefix: undefined };
		static _filter = method(_closure, function(_room) {
			var _name = room_get_name(_room);
			return (string_pos(prefix, _name) > 0);
		});
		
		__roomloader_catch_string(__message_prefix, _method_name, _prefix);
		
		__all_rooms ??= asset_get_ids(asset_room);
		_closure.prefix = _prefix;
		var _rooms = array_filter(__all_rooms, _filter);
		
		var _n = array_length(_rooms);
		if (_n == 0) {
			__roomloader_log_method(__message_prefix, _method_name, $"Could not find any rooms starting with \"{_prefix}\"");
			return _rooms;
		}
		
		var _i = 0; repeat (_n) {
			__data.__add(_rooms[_i], _method_name);
			_i++;
		}
		
		return _rooms;
	};
	
	/// @param {String} tag The tag to extract rooms from.
	/// @returns {Array<Asset.GMRoom>}
	/// @desc Initializes data for all rooms with the given tag assigned. Returns an array of found rooms.
	/// @context RoomLoader
	static data_init_tag = function(_tag) {
		static _method_name = "data_init_tag";
		__roomloader_catch_string(__message_prefix, _method_name, _tag);
		
		var _rooms = tag_get_asset_ids(_tag, asset_room);
		var _n = array_length(_rooms);
		if (_n == 0) {
			__roomloader_log_method(__message_prefix, _method_name, $"Could not find any rooms with the \"{_tag}\" tag assigned");
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
		__roomloader_catch_array(__message_prefix, _method_name, _rooms);
		
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
		 
		__roomloader_catch_string(__message_prefix, _method_name, _prefix);
		
		var _removed = false;
		var _pool = __data.__pool;
		var _names = struct_get_names(_pool);
		var _i = 0; repeat (array_length(_names)) {
			var _name = _names[_i];
			if (string_pos(_prefix, _name) > 0) {
				struct_remove(_pool, _names[_i]);
				__roomloader_log_method(__message_prefix, _method_name, $"Removed data for <{_name}>");
				_removed = true;
			}
			_i++;
		}
		
		if (not _removed) {
			__roomloader_log_method(__message_prefix, _method_name, $"Could not find any rooms starting with \"{_prefix}\"");
		}
		
		return self;
	};
	
	/// @param {String} tag The tag to extract rooms from.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all rooms with the given tag assigned.
	/// @context RoomLoader
	static data_remove_tag = function(_tag) {
		static _method_name = "data_remove_tag";
		__roomloader_catch_string(__message_prefix, _method_name, _tag);
		
		var _rooms = tag_get_asset_ids(_tag, asset_room);
		var _n = array_length(_rooms);
		if (_n == 0) {
			return __roomloader_log_method(__message_prefix, _method_name, $"Could not find any rooms with the \"{_tag}\" tag assigned");
		}
		
		var _i = 0; repeat (_n) {
			__data.__remove(_rooms[_i], _method_name);
			_i++;
		}
	
		return self;
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Clears all initialized room data.
	/// @context RoomLoader
	static data_clear = function() {
		static _method_name = "data_clear";
		if (struct_names_count(__data.__pool) == 0) {
			__roomloader_log_method(__message_prefix, _method_name, "There's no data to clear");
			return self;
		}
		
		__data.__pool = {};
		__roomloader_log_method(__message_prefix, _method_name, "Data cleared");
		return self;
	};
	
	#endregion
	#region data status/getters
	
	/// @param {Asset.GMRoom} room The room to check.
	/// @returns {Bool}
	/// @desc Returns whether the data for the given room is initialized (true) or not (false).
	/// @context RoomLoader
	static data_is_initialized = function(_room) {
		__roomloader_catch_nonroom(__message_prefix, "data_is_initialized", _room, $"check whether data is initialized for");
		return (__data.__get(_room) != undefined);
	};
	
	/// @param {Asset.GMRoom} room The room to get the width for.
	/// @returns {Real}
	/// @desc Returns the width of the given room.
	/// @context RoomLoader
	static data_get_width = function(_room) {
		static _method_name = "data_get_width";
		__roomloader_catch_nonroom(__message_prefix, _method_name, _room, $"get room width for");
		var _data = __get_load_data(_room, _method_name, "load", "get their widths");
		return _data.__width;
	};
	
	/// @param {Asset.GMRoom} room The room to get the height for.
	/// @returns {Real}
	/// @desc Returns the height of the given room.
	/// @context RoomLoader
	static data_get_height = function(_room) {
		static _method_name = "data_get_height";
		__roomloader_catch_nonroom(__message_prefix, _method_name, _room, $"get room height for");
		var _data = __get_load_data(_room, _method_name, "load", "get their heights");
		return _data.__height;
	};
	
	#endregion
	#region loading
	
	/// @param {Asset.GMRoom} room The room to load.
	/// @param {Real} x The x coordinate to load the room at.
	/// @param {Real} y The y coordinate to load the room at.
	/// @param {Real} xorigin=[ROOMLOADER_DEFAULT_XORIGIN] The x origin to load the room at.
	/// @param {Real} yorigin=[ROOMLOADER_DEFAULT_YORIGIN] The y origin to load the room at.
	/// @param {Enum.ROOMLOADER_FLAG} flags=[ROOMLOADER_DEFAULT_FLAGS] The flags to filter the loaded data by.
	/// @returns {struct.RoomLoaderReturnData}
	/// @desc Loads the given room at the given coordinates and [origins], filtered by the given [flags]. 
	/// Returns an instance of RoomLoaderReturnData.
	/// @context RoomLoader
	static load = function(_room, _x, _y, _xorigin = ROOMLOADER_DEFAULT_XORIGIN, _yorigin = ROOMLOADER_DEFAULT_YORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		static _method_name = "load";
		var _data = __get_load_data(_room, _method_name, "load", "load them");
		
		__benchmark.__start();
		__return_data = new RoomLoaderReturnData(_room);
		_data = _data.__load(_x, _y, _xorigin, _yorigin, _flags);
		__roomloader_log_method_timed(__message_prefix, _method_name, "loaded", _room);
		
		return _data;
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Id.Layer, String} layer The layer ID or name to assign instances to.
	/// @param {Real} xorigin=[ROOMLOADER_DEFAULT_XORIGIN] The x origin to load the room at.
	/// @param {Real} yorigin=[ROOMLOADER_DEFAULT_YORIGIN] The y origin to load the room at.
	/// @returns {Array<Id.Instance>}
	/// @desc Loads the given room's instances at the given coordinates, layer and [origins].
	/// Returns an array of created Instances.
	/// @context RoomLoader
	static load_instances_layer = function(_room, _x, _y, _layer, _xorigin = ROOMLOADER_DEFAULT_XORIGIN, _yorigin = ROOMLOADER_DEFAULT_YORIGIN) {
		static _method_name = "load_instances_layer";
		var _data = __get_load_data(_room, _method_name, "load instances for", "load their instances");
		
		__benchmark.__start();
		var _instances = __roomloader_load_instances(_x, _y, _data, _xorigin, _yorigin, instance_create_layer, _layer);
		__roomloader_log_method_timed(__message_prefix, _method_name, "loaded instances for", _room);
		return _instances;
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Real} depth The depth to create instances at.
	/// @param {Real} xorigin=[ROOMLOADER_DEFAULT_XORIGIN] The x origin to load the room's instances at.
	/// @param {Real} yorigin=[ROOMLOADER_DEFAULT_YORIGIN] The y origin to load the room's instances at.
	/// @returns {Array<Id.Instance>}
	/// @desc Loads the given room's instances at the given coordinates, depth and [origins].
	/// Returns an array of created Instances.
	/// @context RoomLoader
	static load_instances_depth = function(_room, _x, _y, _depth, _xorigin = ROOMLOADER_DEFAULT_XORIGIN, _yorigin = ROOMLOADER_DEFAULT_YORIGIN) {
		static _method_name = "load_instances_depth";
		var _data = __get_load_data(_room, _method_name, "load instances for", "load their instances");
		
		__benchmark.__start();
		var _instances = __roomloader_load_instances(_x, _y, _data, _xorigin, _yorigin, instance_create_depth, _depth);
		__roomloader_log_method_timed(__message_prefix, _method_name, "loaded instances for", _room);
		return _instances;
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
		return self;
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
	#region screenshotting
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Real} xorigin=[ROOMLOADER_DEFAULT_XORIGIN] The x origin of the created sprite.
	/// @param {Real} yorigin=[ROOMLOADER_DEFAULT_YORIGIN] The y origin of the created sprite.
	/// @param {Real} scale=[1] The scale to create the sprite at.
	/// @param {Enum.ROOMLOADER_FLAG} flags=[ROOMLOADER_DEFAULT_FLAGS] The flags to filter the loaded data by.
	/// @returns {Asset.GMSprite}
	/// @desc Takes a screenshot of the given room.
	/// Assigns the given xorigin/yorigin origin to the created sprite and filters the drawn elements by the given flags.
	/// Returns a Sprite ID.
	/// @context RoomLoader
	static take_screenshot = function(_room, _xorigin = ROOMLOADER_DEFAULT_XORIGIN, _yorigin = ROOMLOADER_DEFAULT_YORIGIN, _scale = 1, _flags = ROOMLOADER_FLAG.ALL) {
		return __take_screenshot(_room, 0, 0, 1, 1, _xorigin, _yorigin, _scale, _flags, "take_screenshot");
	};
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Real} left The x position on the sprite of the top left corner of the area to draw, as a 0-1 percentage.
	/// @param {Real} top The y position on the sprite of the top left corner of the area to draw, as a 0-1 percentage.
	/// @param {Real} width The width of the area to draw, as a 0-1 percentage.
	/// @param {Real} height The height of the area to draw, as a 0-1 percentage.
	/// @param {Real} xorigin=[ROOMLOADER_DEFAULT_XORIGIN] The x origin of the created sprite.
	/// @param {Real} yorigin=[ROOMLOADER_DEFAULT_YORIGIN] The y origin of the created sprite.
	/// @param {Real} scale=[1] The scale to create the sprite at.
	/// @param {Enum.ROOMLOADER_FLAG} flags=[ROOMLOADER_DEFAULT_FLAGS] The flags to filter the loaded data by.
	/// @returns {Asset.GMSprite}
	/// @desc Takes a screenshot part of the given room.
	/// Assigns the given xorigin/yorigin origin to the created sprite and filters the drawn elements by the given flags.
	/// Returns a Sprite ID.
	/// @context RoomLoader
	static take_screenshot_part = function(_room, _left, _top, _width, _height, _xorigin = ROOMLOADER_DEFAULT_XORIGIN, _yorigin = ROOMLOADER_DEFAULT_YORIGIN, _scale = 1, _flags = ROOMLOADER_FLAG.ALL) {
		return __take_screenshot(_room, _left, _top, _width, _height, _xorigin, _yorigin, _scale, _flags, "take_screenshot_part");
	};
	
	#endregion
}

RoomLoader();
