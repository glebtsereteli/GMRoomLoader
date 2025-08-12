// @feather ignore all

/// @func RoomLoader()
/// @desc Main interface. Handles data initialization and removal, room loading, 
/// layer filtering and taking room screenshots.
/// 
/// NOTE: This is a "static namespace" (made up term), initialized in this script. No further initialization is required.
/// All methods are to be called as follows: RoomLoader.action(arguments...).
function RoomLoader() {
	#region __private
	
	static __messagePrefix = "RoomLoader";
	static __data = {
		__messagePrefix: __messagePrefix,
		__pool: {},
		
		__Add: function(_room, _methodName) {
			__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, "initialize data for");
			
			var _roomName = room_get_name(_room);
			if (struct_exists(__pool, _roomName)) {
				__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Data for <{_roomName}> is already initialized");
				return;
			}
			
			__ROOMLOADER_BENCH_START;
			__pool[$ _roomName] = new __RoomLoaderData(_room);
			__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, "Initialized data for", _room);
		},
		__Remove: function(_room, _methodName) {
			__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, "remove data for");
			
			var _roomName = room_get_name(_room);
			if (not struct_exists(__pool, _roomName)) {
				__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Data for <{_roomName}> doesn't exist, there's nothing to remove");
				return;
			}
			
			struct_remove(__pool, _roomName);
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Removed data for <{_roomName}>");
		},
		__Get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	static __benchTime = undefined;
	
	static __allRooms = undefined;
	static __layerWhitelist = new __RoomLoaderLayerFilter("Whitelist", true);
	static __layerBlacklist = new __RoomLoaderLayerFilter("Blacklist", false);
	static __returnData = undefined;
	
	static __LayerFailedFilters = function(_name) {
		var _match = ((__layerWhitelist.__check(_name)) and (not __layerBlacklist.__check(_name)));
		return (not _match);
	};
	static __GetLoadData = function(_room, _methodName, _nonroom_message, _nodata_message) {
		__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, _nonroom_message);
		
		var _data = __data.__Get(_room);
		if (_data != undefined) return _data;
		
		var _roomName = $"<{room_get_name(_room)}>";
		var _message = $"Could not find the data for room {_roomName}.\nMake sure to initialize data for your rooms before trying to {_nodata_message}"
		__RoomLoaderErrorMethod(__messagePrefix, _methodName, _message);
	};
	static __TakeScreenshot = function(_room, _left, _top, _width, _height, _xOrigin, _yOrigin, _scale, _flags, _methodName) {
		var _data = __GetLoadData(_room, _methodName, "take a screenshot of", "take screenshots");
		
		__ROOMLOADER_BENCH_START;
		var _screenshot = _data.__TakeScreenshot(_left, _top, _width, _height, _xOrigin, _yOrigin, _scale, _flags);
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, "screenshotted", _room);
		return _screenshot;
	};
	
	#endregion
	
	#region Data: Initialization
	
	/// @param {Asset.GMRoom} ...rooms The rooms to initialize data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all given rooms.
	/// @context RoomLoader
	static DataInit = function() {
		static _methodName = "DataInit";
		var _i = 0; repeat (argument_count) {
			__data.__Add(argument[_i], _methodName);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to initialize data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms in the given array.
	/// @context RoomLoader
	static DataInitArray = function(_rooms) {
		static _methodName = "DataInitArray";
		__RoomLoaderCatchArray(__messagePrefix, _methodName, _rooms);
		
		var _i = 0; repeat (array_length(_rooms)) {
			__data.__Add(_rooms[_i], _methodName);
			_i++;
		}
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Array<Asset.GMRoom>}
	/// @desc Initializes data for all rooms starting with the given prefix. Returns an array of found rooms.
	/// @context RoomLoader
	static DataInitPrefix = function(_prefix) {
		static _methodName = "DataInitPrefix";
		static _closure = { prefix: undefined };
		static _filter = method(_closure, function(_room) {
			var _name = room_get_name(_room);
			return (string_pos(prefix, _name) > 0);
		});
		
		__RoomLoaderCatchString(__messagePrefix, _methodName, _prefix);
		
		__allRooms ??= asset_get_ids(asset_room);
		_closure.prefix = _prefix;
		var _rooms = array_filter(__allRooms, _filter);
		
		var _n = array_length(_rooms);
		if (_n == 0) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Could not find any rooms starting with \"{_prefix}\"");
			return _rooms;
		}
		
		var _i = 0; repeat (_n) {
			__data.__Add(_rooms[_i], _methodName);
			_i++;
		}
		
		return _rooms;
	};
	
	/// @param {String} tag The tag to extract rooms from.
	/// @returns {Array<Asset.GMRoom>}
	/// @desc Initializes data for all rooms with the given tag assigned. Returns an array of found rooms.
	/// @context RoomLoader
	static DataInitTag = function(_tag) {
		static _methodName = "DataInitTag";
		__RoomLoaderCatchString(__messagePrefix, _methodName, _tag);
		
		var _rooms = tag_get_asset_ids(_tag, asset_room);
		var _n = array_length(_rooms);
		if (_n == 0) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Could not find any rooms with the \"{_tag}\" tag assigned");
			return _rooms;
		}
		
		var _i = 0; repeat (_n) {
			__data.__Add(_rooms[_i], _methodName);
			_i++;
		}
		
		return _rooms;
	};
	
	#endregion
	#region Data: Removal
	
	/// @param {Asset.GMRoom} ...rooms The rooms to remove data for. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) given rooms.
	/// @context RoomLoader
	static DataRemove = function() {
		static _methodName = "DataRemove";
		var _i = 0; repeat (argument_count) {
			__data.__Remove(argument[_i], _methodName);
			_i++;
		}
		return self;
	};
	
	/// @param {Array<Asset.GMRoom>} rooms The array of rooms to remove data for.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) rooms in the given array.
	/// @context RoomLoader
	static DataRemoveArray = function(_rooms) {
		static _methodName = "DataRemoveArray";
		__RoomLoaderCatchArray(__messagePrefix, _methodName, _rooms);
		
		var _i = 0; repeat (array_length(_rooms)) {
			__data.__Remove(_rooms[_i], _methodName);
			_i++;
		}
		return self;
	};
	
	/// @param {String} prefix The prefix to filter rooms with.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all (initialized) rooms starting with the given prefix.
	/// @context RoomLoader
	static DataRemovePrefix = function(_prefix) {
		static _methodName = "DataRemovePrefix";
		 
		__RoomLoaderCatchString(__messagePrefix, _methodName, _prefix);
		
		var _removed = false;
		var _pool = __data.__pool;
		var _names = struct_get_names(_pool);
		var _i = 0; repeat (array_length(_names)) {
			var _name = _names[_i];
			if (string_pos(_prefix, _name) > 0) {
				struct_remove(_pool, _names[_i]);
				__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Removed data for <{_name}>");
				_removed = true;
			}
			_i++;
		}
		
		if (not _removed) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"Could not find any rooms starting with \"{_prefix}\"");
		}
		
		return self;
	};
	
	/// @param {String} tag The tag to extract rooms from.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes data for all rooms with the given tag assigned.
	/// @context RoomLoader
	static DataRemoveTag = function(_tag) {
		static _methodName = "DataRemoveTag";
		__RoomLoaderCatchString(__messagePrefix, _methodName, _tag);
		
		var _rooms = tag_get_asset_ids(_tag, asset_room);
		var _n = array_length(_rooms);
		if (_n == 0) {
			return __RoomLoaderLogMethod(__messagePrefix, _methodName, $"Could not find any rooms with the \"{_tag}\" tag assigned");
		}
		
		var _i = 0; repeat (_n) {
			__data.__Remove(_rooms[_i], _methodName);
			_i++;
		}
	
		return self;
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Clears all initialized room data.
	/// @context RoomLoader
	static DataClear = function() {
		static _methodName = "DataClear";
		if (struct_names_count(__data.__pool) == 0) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, "There's no data to clear");
			return self;
		}
		
		__data.__pool = {};
		__RoomLoaderLogMethod(__messagePrefix, _methodName, "Data cleared");
		return self;
	};
	
	#endregion
	#region Data: Status & Getters
	
	/// @param {Asset.GMRoom} room The room to check.
	/// @returns {Bool}
	/// @desc Returns whether the data for the given room is initialized (true) or not (false).
	/// @context RoomLoader
	static dataIsInitialized = function(_room) {
		__RoomLoaderCatchNonRoom(__messagePrefix, "dataIsInitialized", _room, $"check whether data is initialized for");
		return (__data.__Get(_room) != undefined);
	};
	
	/// @param {Asset.GMRoom} room The room to get the width for.
	/// @returns {Real}
	/// @desc Returns the width of the given room.
	/// @context RoomLoader
	static DataGetWidth = function(_room) {
		static _methodName = "DataGetWidth";
		__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, $"get room width for");
		var _data = __GetLoadData(_room, _methodName, "load", "get their widths");
		return _data.__width;
	};
	
	/// @param {Asset.GMRoom} room The room to get the height for.
	/// @returns {Real}
	/// @desc Returns the height of the given room.
	/// @context RoomLoader
	static DataGetHeight = function(_room) {
		static _methodName = "DataGetHeight";
		__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, $"get room height for");
		var _data = __GetLoadData(_room, _methodName, "load", "get their heights");
		return _data.__height;
	};
	
	#endregion
	#region Loading
	
	/// @param {Asset.GMRoom} room The room to load.
	/// @param {Real} x The x coordinate to load the room at.
	/// @param {Real} y The y coordinate to load the room at.
	/// @param {Real} xOrigin The x origin to load the room at. (default = ROOMLOADER_DEFAULT_XORIGIN)
	/// @param {Real} yOrigin The y origin to load the room at. (default = ROOMLOADER_DEFAULT_YORIGIN)
	/// @param {Enum.ROOMLOADER_FLAG} flags The flags to filter the loaded data by. (default = ROOMLOADER_DEFAULT_FLAGS)
	/// @returns {struct.RoomLoaderReturnData,undefined}
	/// @desc Loads the given room at the given coordinates and [origins], filtered by the given [flags]. 
	/// Returns an instance of RoomLoaderReturnData if ROOMLOADER_USE_RETURN_DATA is true, undefined otherwise.
	/// @context RoomLoader
	static Load = function(_room, _x, _y, _xOrigin = ROOMLOADER_DEFAULT_XORIGIN, _yOrigin = ROOMLOADER_DEFAULT_YORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		static _methodName = "load";
		static _nonroom_message = "load";
		static _nodata_message = "load them";
		static _bench_message = "loaded";
		
		var _data = __GetLoadData(_room, _methodName, _nonroom_message, _nodata_message);
		
		__ROOMLOADER_BENCH_START;
		if (ROOMLOADER_USE_RETURN_DATA) {
			__returnData = new RoomLoaderReturnData(_room);
		}
		_data.__load(_x, _y, _xOrigin, _yOrigin, _flags);
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, _bench_message, _room);
		
		return (ROOMLOADER_USE_RETURN_DATA ? __returnData : undefined);
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Id.Layer, String, Real} layerOrDepth The layer ID, layer name or depth to create instances on.
	/// @param {Real} xscale The horizontal scale applied to instance positioning.
	/// @param {Real} yscale The vertical scale applied to instance positioning.
	/// @param {Real} angle The angle applied to instance positioning.
	/// @param {Bool} multiplicative_scale Whether to multiply loaded instances' image_xscale/yscale by xscale/yscale (true) or not (false). (default = ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE)
	/// @param {Bool} additive_angle Whether to combinte loaded instances' image_angle with angle (true) or not (false). (default = ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE)
	/// @param {Real} xOrigin The x origin to load the room at. (default = ROOMLOADER_DEFAULT_XORIGIN)
	/// @param {Real} yOrigin The y origin to load the room at. (default = ROOMLOADER_DEFAULT_YORIGIN)
	/// @returns {Array<Id.Instance>}
	static LoadInstances = function(_room, _x, _y, _lod, _xScale, _yScale, _angle, _xOrigin = ROOMLOADER_DEFAULT_XORIGIN, _yOrigin = ROOMLOADER_DEFAULT_YORIGIN, _multScale = ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE, _addAngle = ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE) {
		static _methodName = "load_instances";
		static _body = "load instances for";
		static _end = "load their instances";
		
		var _func = undefined;
		if (is_real(_lod)) {
			_func = instance_create_depth;
		}
		else if (is_string(_lod) or is_handle(_lod)) {
			_func = instance_create_layer;
		}
		
		__ROOMLOADER_BENCH_START;
		var _data = __GetLoadData(_room, _methodName, _body, _end);
		var _instancesData = _data.__instancesData;
		var _n = array_length(_instancesData);
		var _instances = array_create(_n, noone);
		
		if ((_xScale == 1) and (_yScale == 1) and (_angle == 0)) {
			var _xOffset = _x - (_data.__width * _xOrigin);
			var _yOffset = _y - (_data.__height * _yOrigin);
			
			if (ROOMLOADER_INSTANCES_RUN_CREATION_CODE) {
				__ROOMLOADER_INSTANCE_STANDALONE_START
				__ROOMLOADER_INSTANCE_CC
				__ROOMLOADER_INSTANCE_STANDALONE_END
			}
			else {
				__ROOMLOADER_INSTANCE_STANDALONE_START
				__ROOMLOADER_INSTANCE_STANDALONE_END
			}
		}
		else {
			var _xOffset = _data.__width * _xScale * _xOrigin;
			var _yOffset = _data.__height * _yScale * _yOrigin;
			var _x1 = _x - (lengthdir_x(_xOffset, _angle) + lengthdir_x(_yOffset, _angle - 90));
			var _y1 = _y - (lengthdir_y(_xOffset, _angle) + lengthdir_y(_yOffset, _angle - 90));
			
			var _iXScale = (_multScale ? _xScale : 1);
			var _iYScale = (_multScale ? _yScale : 1);
			var _iangle = _angle * _addAngle;
			
			if (ROOMLOADER_INSTANCES_RUN_CREATION_CODE) {
				__ROOMLOADER_INSTANCE_STANDALONE_EXT_START
				__ROOMLOADER_INSTANCE_CC
				__ROOMLOADER_INSTANCE_STANDALONE_EXT_END
			}
			else {
				__ROOMLOADER_INSTANCE_STANDALONE_EXT_START
				__ROOMLOADER_INSTANCE_STANDALONE_EXT_END
			}
		}
		
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, _body, _room);
		
		return _instances;
	};
	
	#endregion
	#region Layer Whitelist
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Whitelist layer filter.
	/// @context RoomLoader
	static LayerWhitelistAdd = function() {
		var _i = 0; repeat (argument_count) {
			__layerWhitelist.__Add(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {String} ...layer_names The layer names to whitelist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes all given layer names from the Whitelist layer filter.
	/// @context RoomLoader
	static LayerWhitelistRemove = function() {
		var _i = 0; repeat (argument_count) {
			__layerWhitelist.__Remove(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Whitelist layer filter.
	/// @context RoomLoader
	static LayerWhitelistReset = function() {
		__layerWhitelist.__Reset();
		return self;
	};
	
	/// @returns {Array<String>}
	/// @desc Returns an array of whitelisted layer names.
	/// @context RoomLoader
	static LayerWhitelistGet = function() {
		return __layerWhitelist.__Get();
	};
	
	#endregion
	#region Layer Blacklist
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Adds all given layer names to the Blacklist layer filter.
	/// @context RoomLoader
	static LayerBlacklistAdd = function() {
		var _i = 0; repeat (argument_count) {
			__layerBlacklist.__Add(argument[_i]);
			_i++;
		}
		return self;
	};
	
	/// @param {String} ...layer_names The layer names to blacklist. Supports any amount of arguments.
	/// @returns {Struct.RoomLoader}
	/// @desc Removes all given layer names from the Blacklist layer filter.
	/// @context RoomLoader
	static LayerBlacklistRemove = function() {
		var _i = 0; repeat (argument_count) {
			__layerBlacklist.__Remove(argument[_i]);
			_i++;
		}
	};
	
	/// @returns {Struct.RoomLoader}
	/// @desc Resets the Blacklist layer filter.
	/// @context RoomLoader
	static LayerBlacklistReset = function() {
		__layerBlacklist.__Reset();
		return self;
	};
	
	/// @returns {Array<String>}
	/// @desc Returns an array of blacklisted layer names.
	/// @context RoomLoader
	static LayerBlacklistGet = function() {
		return __layerBlacklist.__Get();
	};
	
	#endregion
	#region Screenshotting
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Real} xOrigin The x origin of the created sprite. (default = ROOMLOADER_DEFAULT_XORIGIN)
	/// @param {Real} yOrigin The y origin of the created sprite. (default = ROOMLOADER_DEFAULT_YORIGIN)
	/// @param {Real} scale The scale to create the sprite at. (default = 1)
	/// @param {Enum.ROOMLOADER_FLAG} flags The flags to filter the captured elements by. (default = ROOMLOADER_DEFAULT_FLAGS)
	/// @returns {Asset.GMSprite}
	/// @desc Takes a screenshot of the given room.
	/// Assigns the given xorigin/yorigin origin to the created sprite and filters the captured elements by the given flags.
	/// Returns a Sprite ID.
	/// @context RoomLoader
	static TakeScreenshot = function(_room, _xOrigin = ROOMLOADER_DEFAULT_XORIGIN, _yOrigin = ROOMLOADER_DEFAULT_YORIGIN, _scale = 1, _flags = ROOMLOADER_FLAG.ALL) {
		static _methodName = "TakeScreenshot";
		return __TakeScreenshot(_room, 0, 0, 1, 1, _xOrigin, _yOrigin, _scale, _flags, _methodName);
	};
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Real} left The x position on the sprite of the top left corner of the area to capture, as a 0-1 percentage.
	/// @param {Real} top The y position on the sprite of the top left corner of the area to capture, as a 0-1 percentage.
	/// @param {Real} width The width of the area to capture, as a 0-1 percentage.
	/// @param {Real} height The height of the area to capture, as a 0-1 percentage.
	/// @param {Real} xOrigin The x origin of the created sprite. (default = ROOMLOADER_DEFAULT_XORIGIN)
	/// @param {Real} yOrigin The y origin of the created sprite. (default = ROOMLOADER_DEFAULT_YORIGIN)
	/// @param {Real} scale The scale to create the sprite at. (default = 1)
	/// @param {Enum.ROOMLOADER_FLAG} flags The flags to filter the captured elements by. (default = ROOMLOADER_DEFAULT_FLAGS)
	/// @returns {Asset.GMSprite}
	/// @desc Takes a screenshot part of the given room.
	/// Assigns the given xorigin/yorigin origin to the created sprite and filters the captured elements by the given flags.
	/// Returns a Sprite ID.
	/// @context RoomLoader
	static TakeScreenshotPart = function(_room, _left, _top, _width, _height, _xOrigin = ROOMLOADER_DEFAULT_XORIGIN, _yOrigin = ROOMLOADER_DEFAULT_YORIGIN, _scale = 1, _flags = ROOMLOADER_FLAG.ALL) {
		static _methodName = "TakeScreenshotPart";
		return __TakeScreenshot(_room, _left, _top, _width, _height, _xOrigin, _yOrigin, _scale, _flags, _methodName);
	};
	
	#endregion
}
RoomLoader();
