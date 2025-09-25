/// feather ignore all

/// @func RoomLoaderPayload() constructor
/// @param {Asset.GMRoom} room
/// @desc Returned from RoomLoader.Load(). Stores all layers and elements created by RoomLoader.Load(), handles element fetching and cleanup.
/// Only used by RoomLoader.Load() and should NOT be explicitly instantiated.
/// Documentation: https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/overview
function RoomLoaderPayload(_room) constructor {
	#region __private
	
	static __Container = function(_OnDestroy) constructor {
		__ids = [];
		__roomIds = [];
		
		__OnDestroy = _OnDestroy;
		
		static __Add = function(_id, _roomId) {
			array_push(__ids, _id);
			array_push(__roomIds, _roomId);
		};
		static __Get = function(_roomId) {
			var _index = array_get_index(__roomIds, _roomId);
			return ((_index == -1) ? undefined : __ids[_index]);
		};
		static __Destroy = function() {
			array_foreach(__ids, function(_element) {
				__OnDestroy(_element);
			});
		};
	};
	static __Instances = function() constructor {
		__ids = undefined;
		__roomIds = undefined;
		__index = 0;
		
		static __Init = function(_n) {
			__ids = array_create(_n, noone);
			__roomIds = array_create(_n, noone);
		};
		static __Get = function(_roomId) {
			var _index = array_get_index(__roomIds, _roomId);
			return ((_index == -1) ? noone : __ids[_index]);
		};
		static __Destroy = function() {
			array_foreach(__ids, function(_inst) {
				instance_destroy(_inst);
			});
		};
	};
	static __messagePrefix = "RoomLoaderPayload";
	
	__room = _room;
	__layers = new __Container(layer_destroy);
	__instances = new __Instances();
	__tilemaps = new __Container(layer_tilemap_destroy);
	__sprites = new __Container(layer_sprite_destroy);
	__sequences = new __Container(layer_sequence_destroy);
	__texts = new __Container(layer_text_destroy);
	__backgrounds = new __Container(layer_background_destroy);
	__cleanedUp = false;
	
	static __GetTargetDepth = function(_lod, _methodName) {
		var _targetDepth = undefined;
		if (is_real(_lod)) {
			_targetDepth = _lod;
		}
		else if (is_string(_lod) or is_handle(_lod)) {
			_targetDepth = layer_get_depth(_lod);
		}
		else {
			var _message = $"Could not shift layer depths for Layer Or Depth <{_lod}>.\nExpected <Real, String or Id.Layer>, got <{typeof(_lod)}>";
			__RoomLoaderErrorMethod(__messagePrefix, _methodName, _message);
		}
		
		return _targetDepth;
	};
	
	#endregion
	
	#region Depth
	
	/// @param {Id.Layer, String, Real} layerOrDepth The layer or depth to shift depth above.
	/// @param {Real} offset The depth offset [Default: -100]
	/// @desc Shifts all layers to a depth above layerOrDepth, with an optional depth offset.
	/// @returns {Struct.RoomLoaderPayload}
	/// @context RoomLoaderPayload
	static DepthAbove = function(_lod, _offset = -100) {
		static _methodName = "DepthAbove";
		
		var _targetDepth = __GetTargetDepth(_lod, _methodName) + _offset;
		
		var _layers = GetLayers();
		var _n = array_length(_layers);
		
		var _highestDepth = -infinity;
		var _i = 0; repeat (_n) {
			_highestDepth = max(_highestDepth, layer_get_depth(_layers[_i]));
			_i++;
		}
		var _depthOffset = _targetDepth - _highestDepth;
		
		var _i = 0; repeat (_n) {
			var _newDepth = layer_get_depth(_layers[_i]) + _depthOffset;
		    layer_depth(_layers[_i], _newDepth);
			_i++;
		}
		
		return self;
	};
	
	/// @param {Id.Layer, String, Real} layerOrDepth The layer or depth to shift depth below.
	/// @param {Real} offset The depth offset [Default: -100]
	/// @desc Shifts all layers to a depth below layerOrDepth, with an optional depth offset.
	/// @returns {Struct.RoomLoaderPayload}
	/// @context RoomLoaderPayload
	static DepthBelow = function(_lod, _offset = 100) {
		static _methodName = "DepthBelow";
		
		var _targetDepth = __GetTargetDepth(_lod, _methodName) + _offset;
		
	    var _layers = GetLayers();
	    var _n = array_length(_layers);
		
	    var _lowestDepth = infinity;
	    var _i = 0; repeat (_n) {
			_lowestDepth = min(_lowestDepth, layer_get_depth(_layers[_i]));
	        _i++;
	    }
	    var _depthOffset = _targetDepth - _lowestDepth;
		
	    var _i = 0; repeat (_n) {
	        var _newDepth = layer_get_depth(_layers[_i]) + _depthOffset;
	        layer_depth(_layers[_i], _newDepth);
	        _i++;
	    }
		
	    return self;
	};
	
	#endregion
	#region Getters
	
	/// @param {String} name The layer name to search for.
	/// @returns {Id.Layer,undefined}
	/// @desc Returns the layer ID matching the given name, or undefined if not found.
	/// @context RoomLoaderPayload
	static GetLayer = function(_name) {
		__RoomLoaderCatchString(__messagePrefix, "GetLayer", _name, "get a Layer ID from the", "name");
		return __layers.__Get(_name);
	};
	
	/// @returns {Array<Id.Layer>}
	/// @desc Returns an array of created layers.
	/// @context RoomLoaderPayload
	static GetLayers = function() {
		return __layers.__ids;
	};
	
	/// @param {Id.Instance} roomId The Instance room ID to search for, as a constant.
	/// @returns {Id.Instance,noone}
	/// @desc Returns the Instance ID matching the given room ID, or noone if not found.
	/// @context RoomLoaderPayload
	static GetInstance = function(_roomId) {
		return __instances.__Get(_roomId);
	};
	
	/// @returns {Array<Id.Instance>}
	/// @desc Returns an array of created Instances.
	/// @context RoomLoaderPayload
	static GetInstances = function() {
		return __instances.__ids;
	};
	
	/// @param {String} layerName The Tilemap layer name to search for.
	/// @returns {Id.Tilemap,undefined}
	/// @desc Returns the Tilemap ID matching the given layer name, or undefined if not found.
	/// @context RoomLoaderPayload
	static GetTilemap = function(_layerName) {
		__RoomLoaderCatchString(__messagePrefix, "GetTilemap", _layerName, "get a Tilemap ID from the", "layer name");
		return __tilemaps.__Get(_layerName);
	};
	
	/// @returns {Array<Id.Tilemap>}
	/// @desc Returns an array of created Tilemaps.
	/// @context RoomLoaderPayload
	static GetTilemaps = function() {
		return __tilemaps.__ids;
	};
	
	/// @param {String} roomId The Sprite room ID to search for, as a String.
	/// @returns {Id.Sprite,undefined}
	/// @desc Returns the Sprite ID matching the given name, or undefined if not found.
	/// @context RoomLoaderPayload
	static GetSprite = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetSprite", _roomId, "get a Sprite ID from the", "room ID");
		return __sprites.__Get(_roomId);
	};
	
	/// @returns {Array<Id.Sprite>}
	/// @desc Returns an array of created Sprites.
	/// @context RoomLoaderPayload
	static GetSprites = function() {
		return __sprites.__ids;
	};
	
	/// @param {String} roomId The Sequence room ID to search for, as a String.
	/// @returns {Id.Sequence,undefined}
	/// @desc Returns the created Sequence ID matching the given room ID, or undefined if not found.
	/// @context RoomLoaderPayload
	static GetSequence = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetSequence", _roomId, "get a Sequence ID from the", "room ID");
		return __sequences.__Get(_roomId);
	};
	
	/// @returns {Array<Id.Sequence>}
	/// @desc Returns an array of created Sequences.
	/// @context RoomLoaderPayload
	static GetSequences = function() {
		return __sequences.__ids;
	};
	
	/// @param {String} roomId The Background room ID to search for, as a String.
	/// @returns {Id.Background,undefined}
	/// @desc Returns the created Background ID matching the given room ID, or undefined if not found.
	/// @context RoomLoaderPayload
	static GetBackground = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetBackground", _roomId, "get a Background ID from the", "room ID");
		return __backgrounds.__Get(_roomId);
	};
	
	/// @returns {Array<Id.Background>}
	/// @desc Returns an array of created Backgrounds.
	/// @context RoomLoaderPayload
	static GetBackgrounds = function() {
		return __backgrounds.__ids;
	};
	
	#endregion
	#region Cleanup
	
	/// @returns {Undefined}
	/// @param {Bool} destroyLayers=[true] Whether to destroy loaded layers (true) or not (false).
	/// @desc Destroys created layers and their elements. After calling this method, the instance becomes practically useless and should be dereferenced to be picked up by the Garbage Collector.
	/// NOTE: Setting destroyLayers to false can be useful if ROOMLOADER_MERGE_LAYERS is set to true and you don't want to accidentally destroy layers shared between multiple loaded rooms, and destroy only created elements instead.
	/// @context RoomLoaderPayload
	static Cleanup = function(_destroyLayers = true) {
		static _methodName = "Cleanup";
		static _benchMessage = "cleaned up data for";
		
		if (__cleanedUp) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"data for \<{room_get_name(__room)}\> is already cleaned up");
			return;
		}
		
		__ROOMLOADER_BENCH_START;
		__instances.__Destroy();
		__tilemaps.__Destroy();
		__sprites.__Destroy();
		__sequences.__Destroy();
		__texts.__Destroy();
		__backgrounds.__Destroy();
		if (_destroyLayers) {
			__layers.__Destroy();
		}
		__cleanedUp = true;
		
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, _benchMessage, __room);
	};

	#endregion
};
