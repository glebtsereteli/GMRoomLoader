// @feather ignore all

/// @func RoomLoader()
/// @desc Main interface. Handles data initialization and removal, room and instances loading, 
/// layer filtering and taking screenshots.
/// 
/// NOTE: This is a "static namespace" function (made up term), no initialization is required.
/// All methods are to be called as follows: RoomLoader.action(arguments...).
function RoomLoader() {
	#region __private
	
	static __messagePrefix = "RoomLoader";
	static __data = new __RoomLoaderDataCore();
	static __benchTime = undefined;
	
	static __allRooms = asset_get_ids(asset_room);
	static __layerWhitelist = new __RoomLoaderLayerFilter("Whitelist", true);
	static __layerBlacklist = new __RoomLoaderLayerFilter("Blacklist", false);
	static __payload = undefined;
	
	static __LayerFailedFilters = function(_name) {
		var _match = ((__layerWhitelist.__check(_name)) and (not __layerBlacklist.__check(_name)));
		return (not _match);
	};
	static __GetLoadData = function(_room, _methodName, _nonRoomMessage, _noDataMessage) {
		__RoomLoaderCatchNonRoom(__messagePrefix, _methodName, _room, _nonRoomMessage);
		
		var _data = __data.__Get(_room);
		if (_data != undefined) return _data;
		
		var _roomName = $"<{room_get_name(_room)}>";
		var _message = $"Could not find the data for room {_roomName}.\nMake sure to initialize data for your rooms before trying to {_noDataMessage}"
		__RoomLoaderErrorMethod(__messagePrefix, _methodName, _message);
	};
	static __TakeScreenshot = function(_room, _left, _top, _width, _height, _xOrigin, _yOrigin, _scale, _flags, _methodName) {
		var _data = __GetLoadData(_room, _methodName, "take a screenshot of", "take screenshots");
		
		__ROOMLOADER_BENCH_START;
		var _screenshot = _data.__TakeScreenshot(_left, _top, _width, _height, _xOrigin, _yOrigin, _scale, _flags);
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, "screenshotted", _room);
		return _screenshot;
	};
	
	// state
	static __xOrigin = ROOMLOADER_DEFAULT_XORIGIN;
	static __yOrigin = ROOMLOADER_DEFAULT_YORIGIN;
	static __flags = ROOMLOADER_DEFAULT_FLAGS;
	static __flagsDefault = true;
	static __xScale = 1;
	static __yScale = 1;
	
	static __ResetState = function() {
		__xOrigin = ROOMLOADER_DEFAULT_XORIGIN;
		__yOrigin = ROOMLOADER_DEFAULT_YORIGIN;
		__flags = ROOMLOADER_DEFAULT_FLAGS;
		__flagsDefault = true;
		__xScale = 1;
		__yScale = 1;
	};
	static __ResetStateFlags = function() {
		if (__flagsDefault) {
			__flags = 0;
			__flagsDefault = false;
		}
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
	
	/// @param {Array<Asset.GMRoom>} blacklist The rooms to NOT initialize data for. [Default: empty]
	/// @returns {Struct.RoomLoader}
	/// @desc Initializes data for all rooms in the project BUT the ones listed in the blacklist array.
	static DataInitAll = function(_blacklist = []) {
		static _methodName = "DataInitAll";
		
		__RoomLoaderCatchArray(__messagePrefix, _methodName, _blacklist);
		
		if (array_length(_blacklist) > 0) {
			var _i = 0; repeat (array_length(__allRooms)) {
				var _room = __allRooms[_i];
				if (not array_contains(_blacklist, _room)) {
					__data.__Add(_room, _methodName);
				}
				_i++;
			}
		}
		else {
			var _i = 0; repeat (array_length(__allRooms)) {
				__data.__Add(__allRooms[_i], _methodName);
				_i++;
			}
		}
		
		return self;
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
	static DataIsInitialized = function(_room) {
		__RoomLoaderCatchNonRoom(__messagePrefix, "DataIsInitialized", _room, $"check whether data is initialized for");
		return (__data.__Get(_room) != undefined);
	};
	
	/// @param {Asset.GMRoom} room The room to get the width for.
	/// @returns {Real}
	/// @desc Returns the width of the given room.
	/// @context RoomLoader
	static DataGetWidth = function(_room) {
		static _methodName = "DataGetWidth";
		
		var _data = __GetLoadData(_room, _methodName, "get width for", "get their widths");
		return _data.__width;
	};
	
	/// @param {Asset.GMRoom} room The room to get the height for.
	/// @returns {Real}
	/// @desc Returns the height of the given room.
	/// @context RoomLoader
	static DataGetHeight = function(_room) {
		static _methodName = "DataGetHeight";
		
		var _data = __GetLoadData(_room, _methodName, "get height for", "get their heights");
		return _data.__height;
	};
	
	/// @param {Asset.GMRoom} room The room to an array of layer names for.
	/// @returns {Array<String>}
	/// @desc Returns an array of layer names from the given room, in the order defined in the room editor.
	/// @context RoomLoader
	static DataGetLayerNames = function(_room) {
		static _methodName = "DataGetLayerNames";
		
		var _data = __GetLoadData(_room, _methodName, "get layer names for", "get their layer names");
		return array_map(_data.__layersPool, function(_layer) {
			return _layer.__layerData.name;
		});
	};
	
	/// @param {Asset.GMRoom} room The room to get the instances data for.
	/// @returns {Real}
	/// @desc Returns an array of processed instance data. Refer to the docs to see format specifics.
	/// @context RoomLoader
	static DataGetInstances = function(_room) {
		static _methodName = "DataGetInstances";
		
		var _data = __GetLoadData(_room, _methodName, "get intances data for", "get their instances data");
		return _data.__instancesPool;
	};
	
	#endregion
	
	#region Loading
	
	/// @param {Asset.GMRoom} room The room to load.
	/// @param {Real} x The x coordinate to load the room at.
	/// @param {Real} y The y coordinate to load the room at.
	/// @param {Real} xOrigin The x origin to load the room at. [Default: State.XOrigin or ROOMLOADER_DEFAULT_XORIGIN]
	/// @param {Real} yOrigin The y origin to load the room at. [Default: State.YOrigin or ROOMLOADER_DEFAULT_YORIGIN]
	/// @param {Enum.ROOMLOADER_FLAG} flags The flags to filter the loaded data by. [Default: State.Flags or ROOMLOADER_DEFAULT_FLAGS]
	/// @param {Real} xscale The horizontal scale to load the room at. [Default: State.XScale or 1]
	/// @param {Real} yscale The vertical scale to load the room at. [Default: State.YScale or 1]
	/// @param {Real} angle The angle to load the room at. [Default: State.Angle or 0]
	/// @returns {struct.RoomLoaderPayload,undefined}
	/// @desc Loads the given room at the given coordinates and [origins], filtered by the given [flags]. 
	/// Returns an instance of RoomLoaderPayload if ROOMLOADER_DELIVER_PAYLOAD is true, undefined otherwise.
	/// @context RoomLoader
	static Load = function(_room, _x, _y, _xOrigin = __xOrigin, _yOrigin = __yOrigin, _flags = __flags, _xScale = __xScale, _yScale = __yScale, _angle = __angle) {
		static _methodName = "Load";
		static _nonRoomMessage = "load";
		static _noDataMessage = "load them";
		static _benchMessage = "loaded";
		
		var _data = __GetLoadData(_room, _methodName, _nonRoomMessage, _noDataMessage);
		
		__ROOMLOADER_BENCH_START;
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			__payload = new RoomLoaderPayload(_room);
		}
		_data.__Load(_x, _y, _xOrigin, _yOrigin, _flags, _xScale, _yScale, _angle);
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, _benchMessage, _room);
		
		__ResetState();
		
		return (ROOMLOADER_DELIVER_PAYLOAD ? __payload : undefined);
	};
	
	/// @param {Asset.GMRoom} room The room to load instances for.
	/// @param {Real} x The x coordinate to load instances at.
	/// @param {Real} y The y coordinate to load instances at.
	/// @param {Id.Layer, String, Real} layerOrDepth The layer ID, layer name or depth to create instances on.
	/// @param {Real} xOrigin The x origin to load the room at. [Default: State.XOrigin or ROOMLOADER_DEFAULT_XORIGIN]
	/// @param {Real} yOrigin The y origin to load the room at. [Default: State.YOrigin or ROOMLOADER_DEFAULT_YORIGIN]
	/// @param {Real} xscale The horizontal scale applied to instance positioning. [Default: State.XScale or 1]
	/// @param {Real} yscale The vertical scale applied to instance positioning. [Default: State.YScale or 1]
	/// @param {Real} angle The angle applied to instance positioning. [Default: State.Angle or 0]
	/// @param {Bool} multiplicativeScale Whether to multiply loaded instances' image_xscale/yscale by xscale/yscale (true) or not (false). [Default: ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE]
	/// @param {Bool} additiveAngle Whether to combine loaded instances' image_angle with angle (true) or not (false). [Default: ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE]
	/// @returns {Array<Id.Instance>}
	/// @context RoomLoader
	static LoadInstances = function(_room, _x0, _y0, _lod, _xOrigin = __xOrigin, _yOrigin = __yOrigin, _xScale = __xScale, _yScale = __yScale, _angle = __angle, _multScale = ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE, _addAngle = ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE) {
		static _methodName = "LoadInstances";
		static _body = "load instances for";
		static _end = "load their instances";
		
		var _data = __GetLoadData(_room, _methodName, _body, _end);
		
		var _func = undefined;
		if (is_real(_lod)) {
			_func = instance_create_depth;
		}
		else if (is_string(_lod) or is_handle(_lod)) {
			_func = instance_create_layer;
		}
		else {
			var _message = $"Could not load instances at layer or depth <{_lod}>.\nExpected <Real, String or Id.Layer>, got <{typeof(_lod)}>";
			__RoomLoaderErrorMethod(__messagePrefix, _methodName, _message);
		}
		
		__ROOMLOADER_BENCH_START;
		var _instancesData = _data.__instancesPool;
		var _n = array_length(_instancesData);
		var _instances = array_create(_n, noone);
		
		if (__ROOMLOADER_NOTRANSFORM) {
			var _xOffset = _x0 - (_data.__width * _xOrigin);
			var _yOffset = _y0 - (_data.__height * _yOrigin);
			
			var _i = 0; repeat (_n) {
				var _iData = _instancesData[_i];
				var _iX = _iData.x + _xOffset;
				var _iY = _iData.y + _yOffset;
				var _inst = _func(_iX, _iY, _lod, _iData.object, _iData.preCreate);
				__ROOMLOADER_INST_CC;
				_instances[_i] = _inst;
				_i++;
			}
		}
		else {
		    var _xOffset = _data.__width * _xScale * _xOrigin;
		    var _yOffset = _data.__height * _yScale * _yOrigin;
			
		    var _cos = dcos(_angle);
		    var _sin = dsin(_angle);
			
		    var _x1 = _x0 - ((_xOffset * _cos) + (_yOffset * _sin));
		    var _y1 = _y0 - ((-_xOffset * _sin) + (_yOffset * _cos));
			
		    var _xScaleInst = (_multScale ? _xScale : 1);
		    var _yScaleInst = (_multScale ? _yScale : 1);
		    _angle *= _addAngle;
			
		    var _i = 0; repeat (_n) {
		        var _iData = _instancesData[_i];
				
				__ROOMLOADER_INST_TRANSFORM_PRELOAD;
				var _inst = _func(_x, _y, _lod, _iData.object, _preCreate);
		        _instances[_i] = _inst;
				__ROOMLOADER_INST_TRANSFORM_POSTLOAD;
				
		        _i++;
		    }
		}
		
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, _body, _room);
		__ResetState();
		
		return _instances;
	};
	
	/// @param {Asset.GMRoom} room The room to load a tilemap from.
	/// @param {Real} x The x coordinate to load the tilemap at.
	/// @param {Real} y The y coordinate to load the tilemap at.
	/// @param {String} sourceLayerName The source layer name to load a tilemap from.
	/// @param {Id.Layer, String} targetLayer The target layer to create the tilemap on.
	/// @param {Real} xOrigin The x origin to load the tilemap at. [Default: State.XOrigin or ROOMLOADER_DEFAULT_XORIGIN]
	/// @param {Real} yOrigin The y origin to load the tilemap at. [Default: State.YOrigin or ROOMLOADER_DEFAULT_YORIGIN]
	/// @param {Bool} mirror Mirror the loaded tilemap? [Default: State.Mirror or false]
	/// @param {Bool} flip Flip the loaded tilemap? [Default: State.Flip or false]
	/// @param {Real} angle The angle to load the tilemap at. [Default: State.Angle or 0]
	/// @param {Asset.GMTileset} tileset The tileset to use for the tilemap. [Default: source]
	static LoadTilemap = function(_room, _x, _y, _sourceLayerName, _targetLayer, _xOrigin = __xOrigin, _yOrigin = __yOrigin,_mirror = (__xScale == -1), _flip = (__yScale == -1), _angle = __angle, _tileset = undefined) {
		static _methodName = "LoadTilemap";
		
		var _roomData = __GetLoadData(_room, _methodName, "body", "end");
		var _tilemapData = _roomData.__tilemapsLut[$ _sourceLayerName];
		
		__ROOMLOADER_BENCH_START;
		if ((not _mirror) and (not _flip) and (_angle == 0)) {
			_x -= _roomData.__width * _xOrigin;
			_y -= _roomData.__height * _yOrigin;
			var _tilemap = _tilemapData.__CreateTilemap(_targetLayer, _x, _y, _tileset);
		}
		else {
			var _xScale = (_mirror ? -1 : 1);
			var _yScale = (_flip ? -1 : 1);
			var _tilemap = _tilemapData.__CreateTilemapTransformed(_targetLayer, _x, _y, _xScale, _yScale, _angle, _xOrigin, _yOrigin, _tileset);
		}
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, "loaded tilemap from", _room);
		__ResetState();
		
		return _tilemap;
	};
	
	#endregion
	#region Screenshotting
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Real} xOrigin The x origin of the created sprite. [Default: State.XOrigin or ROOMLOADER_DEFAULT_XORIGIN]
	/// @param {Real} yOrigin The y origin of the created sprite. [Default: State.YOrigin or ROOMLOADER_DEFAULT_YORIGIN]
	/// @param {Enum.ROOMLOADER_FLAG} flags The flags to filter the captured elements by. [Default: State.Flags or ROOMLOADER_DEFAULT_FLAGS]
	/// @param {Real} scale The scale to create the sprite at. [Default: 1]
	/// @returns {Asset.GMSprite}
	/// @desc Takes a screenshot of the given room.
	/// Assigns the given xorigin/yorigin origin to the created sprite and filters the captured elements by the given flags.
	/// Returns a Sprite ID.
	/// @context RoomLoader
	static Screenshot = function(_room, _xOrigin = __xOrigin, _yOrigin = __yOrigin, _flags = __flags, _scale = 1) {
		static _methodName = "Screenshot";
		
		var _screenshot = __TakeScreenshot(_room, 0, 0, 1, 1, _xOrigin, _yOrigin, _scale, _flags, _methodName);
		__ResetState();
		
		return _screenshot;
	};
	
	/// @param {Asset.GMRoom} room The room to take a screenshot of.
	/// @param {Real} left The x position on the sprite of the top left corner of the area to capture, as a 0-1 percentage.
	/// @param {Real} top The y position on the sprite of the top left corner of the area to capture, as a 0-1 percentage.
	/// @param {Real} width The width of the area to capture, as a 0-1 percentage.
	/// @param {Real} height The height of the area to capture, as a 0-1 percentage.
	/// @param {Real} xOrigin The x origin of the created sprite. [Default: State.XOrigin or ROOMLOADER_DEFAULT_XORIGIN]
	/// @param {Real} yOrigin The y origin of the created sprite. [Default: State.YOrigin or ROOMLOADER_DEFAULT_YORIGIN]
	/// @param {Enum.ROOMLOADER_FLAG} flags The flags to filter the captured elements by. [Default: State.Flags or ROOMLOADER_DEFAULT_FLAGS]
	/// @param {Real} scale The scale to create the sprite at. [Default: 1]
	/// @returns {Asset.GMSprite}
	/// @desc Takes a screenshot part of the given room.
	/// Assigns the given xorigin/yorigin origin to the created sprite and filters the captured elements by the given flags.
	/// Returns a Sprite ID.
	/// @context RoomLoader
	static ScreenshotPart = function(_room, _left, _top, _width, _height, _xOrigin = __xOrigin, _yOrigin = __yOrigin, _flags = __flags, _scale = 1) {
		static _methodName = "ScreenshotPart";
		
		var _screenshot = __TakeScreenshot(_room, _left, _top, _width, _height, _xOrigin, _yOrigin, _scale, _flags, _methodName);
		__ResetState();
		
		return _screenshot;
	};
	
	#endregion
	
	#region State: Origin
	
	/// 
	static XOrigin = function(_xOrigin) {
		__xOrigin = _xOrigin;
		
		return self;
	};
	
	///
	static YOrigin = function(_yOrigin) {
		__yOrigin = _yOrigin;
		
		return self;
	};
	
	/// 
	static Origin = function(_xOrigin, _yOrigin = _xOrigin) {
		__xOrigin = _xOrigin;
		__yOrigin = _yOrigin;
		
		return self;
	};
	
	/// 
	static TopLeft = function() {
		__xOrigin = 0;
		__yOrigin = 0;
		
		return self;
	};
	
	/// 
	static TopCenter = function() {
		__xOrigin = 0.5;
		__yOrigin = 0;
		
		return self;
	};
	
	/// 
	static TopRight = function() {
		__xOrigin = 1;
		__yOrigin = 0;
		
		return self;
	};
	
	/// 
	static MiddleLeft = function() {
		__xOrigin = 0;
		__yOrigin = 0.5;
		
		return self;
	};
	
	/// 
	static MiddleCenter = function() {
		__xOrigin = 0.5;
		__yOrigin = 0.5;
		
		return self;
	};
	
	/// 
	static MiddleRight = function() {
		__xOrigin = 1;
		__yOrigin = 0.5;
		
		return self;
	};
	
	/// 
	static BottomLeft = function() {
		__xOrigin = 0;
		__yOrigin = 1;
		
		return self;
	};
	
	/// 
	static BottomCenter = function() {
		__xOrigin = 0.5;
		__yOrigin = 1;
		
		return self;
	};
	
	/// 
	static BottomRight = function() {
		__xOrigin = 1;
		__yOrigin = 1;
		
		return self;
	};
	
	#endregion
	#region State: Flags
	
	///
	static Flags = function(_flags) {
		__ResetStateFlags();
		__flags = _flags;
		
		return self;
	};
	
	///
	static Instances = function() {
		__ResetStateFlags();
		__flags |= ROOMLOADER_FLAG.INSTANCES;
		
		return self;
	};
	
	///
	static Tilemaps = function() {
		__ResetStateFlags();
		__flags |= ROOMLOADER_FLAG.TILEMAPS;
		
		return self;
	};
	
	///
	static Sprites = function() {
		__ResetStateFlags();
		__flags |= ROOMLOADER_FLAG.SPRITES;
		
		return self;
	};
	
	///
	static Sequences = function() {
		__ResetStateFlags();
		__flags |= ROOMLOADER_FLAG.SEQUENCES;
		
		return self;
	};
	
	///
	static Texts = function() {
		__ResetStateFlags();
		__flags |= ROOMLOADER_FLAG.TEXTS;
		
		return self;
	};
	
	///
	static Backgrounds = function() {
		__ResetStateFlags();
		__flags |= ROOMLOADER_FLAG.BACKGROUNDS;
		
		return self;
	};
	
	#endregion
	#region State: Transformations
	
	///
	static XScale = function(_scale) {
		__xScale = _scale;
		
		return self;
	};
	
	///
	static YScale = function(_scale) {
		__yScale = _scale;
		
		return self;
	};
	
	///
	static Scale = function(_xScale, _yScale = _xScale) {
		__xScale = _xScale;
		__yScale = _yScale;
		
		return self;
	};
	
	/// 
	static Mirror = function() {
		__xScale = -1;
		
		return self;
	};
	
	/// 
	static Flip = function() {
		__yScale = -1;
		
		return self;
	};
	
	/// 
	static Angle = function(_angle) {
		__angle = _angle;
		
		return self;
	};
	
	#endregion
	
	#region Layer Name Filtering: Whitelist
	
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
	#region Layer Name Filtering: Blacklist
	
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
		
		return self;
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
}
