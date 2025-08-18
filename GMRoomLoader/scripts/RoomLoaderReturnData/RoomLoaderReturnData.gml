/// @feather ignore all

/// @func RoomLoaderReturnData()
/// @param {Asset.GMRoom} room
/// @desc Returned by RoomLoader's .Load() method. Stores all layers and elements created on load, 
/// and handles element fetching and cleanup.
/// 
/// NOTE: This constructor is only used by RoomLoader's .Load() method, it should NOT be explicitly instantiated.
function RoomLoaderReturnData(_room) constructor {
	#region __private
	
	static __Container = function(_on_destroy) constructor {
		__ids = [];
		__names = [];
		
		__OnDestroy = _on_destroy;
		
		static __Add = function(_id, _name) {
			array_push(__ids, _id);
			array_push(__names, _name);
		};
		static __Get = function(_name) {
			var _index = array_get_index(__names, _name);
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
			__ids = array_create(_n, noone)
			__roomIds = array_create(_n, noone);
		};
		static __Get = function(_room_id) {
			var _index = array_get_index(__roomIds, _room_id);
			return ((_index == -1) ? noone : __ids[_index]);
		};
		static __Destroy = function() {
			array_foreach(__ids, function(_inst) {
				instance_destroy(_inst);
			});
		};
	};
	static __messagePrefix = "RoomLoaderReturnData";
	
	__room = _room;
	__layers = new __Container(layer_destroy);
	__instances = new __Instances();
	__tilemaps = new __Container(layer_tilemap_destroy);
	__sprites = new __Container(layer_sprite_destroy);
	__sequences = new __Container(layer_sequence_destroy);
	__texts = new __Container(layer_text_destroy);
	__backgrounds = new __Container(layer_background_destroy);
	__cleanedUp = false;
	
	#endregion
	
	#region Getters
	
	/// @param {String} name Thes layer name to search for.
	/// @returns {Id.Layer,undefined}
	/// @desc Returns the layer ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static GetLayer = function(_name) {
		__RoomLoaderCatchString(__messagePrefix, "GetLayer", _name, "get a Layer ID from the", "name");
		return __layers.__Get(_name);
	};
	
	/// @returns {Array<Id.Layer>}
	/// @desc Returns an array of created layers.
	/// @context RoomLoaderReturnData
	static GetLayers = function() {
		return __layers.__ids;
	};
	
	/// @param {Id.Instance} roomId The room ID of the instance to search for.
	/// @returns {Array<Id.Instance>}
	/// @context RoomLoaderReturnData
	static GetInstance = function(_roomId) {
		return __instances.__Get(_roomId);
	};
	
	/// @returns {Array<Id.Instance>}
	/// @desc Returns an array of created Instances.
	/// @context RoomLoaderReturnData
	static GetInstances = function() {
		return __instances.__ids;
	};
	
	/// @param {String} layerName The Tilemap layer name to search for.
	/// @returns {Id.Tilemap,undefined}
	/// @desc Returns the Tilemap ID matching the given layer name or undefined if not found.
	/// @context RoomLoaderReturnData
	static GetTilemap = function(_layerName) {
		__RoomLoaderCatchString(__messagePrefix, "GetTilemap", _layerName, "get a Tilemap ID from the", "layer name");
		return __tilemaps.__Get(_layerName);
	};
	
	/// @returns {Array<Id.Tilemap>}
	/// @desc Returns an array of created Tilemaps.
	/// @context RoomLoaderReturnData
	static GetTilemaps = function() {
		return __tilemaps.__ids;
	};
	
	/// @param {String} name The Sprite name to search for.
	/// @returns {Id.Sprite,undefined}
	/// @desc Returns the Sprite ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static GetSprite = function(_name) {
		__RoomLoaderCatchString(__messagePrefix, "_name", _name, "get a Sprite ID from the", "name");
		return __sprites.__Get(_name);
	};
	
	/// @returns {Array<Id.Sprite>}
	/// @desc Returns an array of created Sprites.
	/// @context RoomLoaderReturnData
	static GetSprites = function() {
		return __sprites.__ids;
	};
	
	/// @param {String} name The Sequence name to search for.
	/// @returns {Id.Sequence,undefined}
	/// @desc Returns the created Sequence ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static GetSequence = function(_name) {
		__RoomLoaderCatchString(__messagePrefix, "GetSequence", _name, "get a Sequence ID from the", "name");
		return __sequences.__Get(_name);
	};
	
	/// @returns {Array<Id.Sequence>}
	/// @desc Returns an array of created Sequences.
	/// @context RoomLoaderReturnData
	static GetSequences = function() {
		return __sequences.__ids;
	};
	
	/// @param {String} layerName The Background layer name to search for.
	/// @returns {Id.Background}
	/// @desc Returns the created Background ID matching the given layer name or undefined if not found.
	/// @context RoomLoaderReturnData
	static GetBackground = function(_layerName) {
		__RoomLoaderCatchString(__messagePrefix, "GetBackground", _layerName, "get a Background ID from the", "layer name");
		return __backgrounds.__Get(_layerName);
	};
	
	/// @returns {Array<Id.Background>}
	/// @desc Returns an array of created Backgrounds.
	/// @context RoomLoaderReturnData
	static GetBackgrounds = function() {
		return __backgrounds.__ids;
	};
	
	#endregion
	#region Cleanup
	
	/// @returns {Undefined}
	/// @param {Bool} destroy_layers=[true] Whether to destroy loaded layers (true) or not (false).
	/// @desc Destroys created layers and their elements. After calling this method, the instance becomes practically useless and should be dereferenced to be picked up by the Garbage Collector.
	/// NOTE: Setting "destroy_layers" to false can be useful if ROOMLOADER_MERGE_LAYERS is set to true and you don't want to
	/// accidentally destroy layers shared between multiple loaded rooms, and destroy only created elements instead.
	/// @context RoomLoaderReturnData
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
