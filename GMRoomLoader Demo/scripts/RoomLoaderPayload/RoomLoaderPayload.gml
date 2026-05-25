// feather ignore all

/// • Returned from RoomLoader.Load(). Stores all newly created layers and elements, handles element fetching and cleanup.
/// • Only used by RoomLoader.Load() and should NOT be explicitly instantiated.
/// • Documentation: https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/overview
/// 
/// @param {Asset.GMRoom} room
/// @returns {Struct.RoomLoaderPayload} self
function RoomLoaderPayload(_room) constructor {
	#region Depth
	
	/// Shifts all layers to a depth above layerOrDepth, with an optional depth offset.
	/// 
	/// @param {Id.Layer, String, Real} layerOrDepth The layer or depth to shift depth above.
	/// @param {Real} offset The depth offset [Default: -100]
	/// 
	/// @returns {Struct.RoomLoaderPayload}
	/// @self RoomLoaderPayload
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
	
	/// Shifts all layers to a depth below layerOrDepth, with an optional depth offset.
	/// 
	/// @param {Id.Layer, String, Real} layerOrDepth The layer or depth to shift depth below.
	/// @param {Real} offset The depth offset [Default: +100]
	/// 
	/// @returns {Struct.RoomLoaderPayload}
	/// @self RoomLoaderPayload
	static DepthBelow = function(_lod, _offset = +100) {
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
	
	/// Returns the axis-aligned bounding box of the loaded room as a struct with x1, y1 (top-left) and x2, y2 (bottom-right) coordinates.
	/// 
	/// @returns {Struct}
	/// @self RoomLoaderPayload
	static GetBbox = function() {
		return __bbox;
	};
	
	/// Returns the corners of the loaded room as a flat array of coordinates in clockwise order.
	/// Accounts for any combination of the room's position, origin, scale, and rotation.
	/// 
	/// @returns {Array<Real>}
	/// @self RoomLoaderPayload
	static GetPolygon = function() {
		if (__polygon != undefined) {
			return __polygon;
		}
		
		if (__obb == undefined) {
			__polygon = [
				__bbox.x1, __bbox.y1, // TL
				__bbox.x2, __bbox.y1, // TR
				__bbox.x2, __bbox.y2, // BR
				__bbox.x1, __bbox.y2, // BL
			];
			return __polygon;
		}
		
		var _cx = __obb.__centerX;
		var _cy = __obb.__centerY;
		var _hwCos = __obb.__hw * __obb.__cos;
		var _hwSin = __obb.__hw * __obb.__sin;
		var _hhSin = __obb.__hh * __obb.__sin;
		var _hhCos = __obb.__hh * __obb.__cos;
		
		__polygon = [
			_cx - _hwCos + _hhSin, _cy + _hwSin + _hhCos, // TL
			_cx + _hwCos + _hhSin, _cy - _hwSin + _hhCos, // TR
			_cx + _hwCos - _hhSin, _cy - _hwSin - _hhCos, // BR
			_cx - _hwCos - _hhSin, _cy + _hwSin - _hhCos, // BL
		];
		return __polygon;
	};
	
	/// Returns the ID of the created layer matching the given name if found, or undefined if not found.
	/// 
	/// @param {String} name The layer name to search for.
	/// 
	/// @returns {Id.Layer,Undefined}
	/// @self RoomLoaderPayload
	static GetLayer = function(_name) {
		__RoomLoaderCatchString(__messagePrefix, "GetLayer", _name, "get a Layer ID from the", "name");
		return __layers.__Get(_name);
	};
	
	/// Returns an array of created layers.
	/// 
	/// @returns {Array<Id.Layer>}
	/// @self RoomLoaderPayload
	static GetLayers = function() {
		return __layers.__ids;
	};
	
	/// Returns the ID of the created Instance matching the given room ID if found, or noone if not found.
	/// 
	/// @param {Id.Instance} roomId The room ID of the Instance to search for.
	/// 
	/// @returns {Id.Instance,noone}
	/// @self RoomLoaderPayload
	static GetInstance = function(_roomId) {
		return __instances.__Get(_roomId);
	};
	
	/// Returns an array of created instances, optionally filtered by object.
	/// 
	/// @param {Asset.GMObject} object The object to filter by. If provided, only instances of this object will be returned. [Default: undefined (no filter)]
	/// 
	/// @returns {Array<Id.Instance>}
	/// @self RoomLoaderPayload
	static GetInstances = function(_obj = undefined) {
		static _closure = {};
		static _Filter = method(_closure, function(_inst) {
			return (_inst.object_index == __object);
		});
		
		_closure.__object = _obj;
		
		return (is_undefined(_obj) ? __instances.__ids : array_filter(__instances.__ids, _Filter));
	};
	
	/// Detaches instances from the payload and stops tracking them. This allows instance cleanup to be handled separately from the rest of the payload.
	/// NOTE: If detached instances remain on their original layers and those layers are destroyed during .Cleanup(), the instances will still be destroyed.
	/// 
	/// @returns {Array<Id.Instance>}
	/// @self RoomLoaderPayload
	static DetachInstances = function() {
		return __instances.__Detach();
	};
	
	/// Returns the ID of the created Tilemap matching the given layer name if found, or undefined if not found.
	/// 
	/// @param {String} layerName The Tile layer name to search for.
	/// 
	/// @returns {Id.Tilemap,Undefined}
	/// @self RoomLoaderPayload
	static GetTilemap = function(_layerName) {
		__RoomLoaderCatchString(__messagePrefix, "GetTilemap", _layerName, "get a Tilemap ID from the", "layer name");
		return __tilemaps.__Get(_layerName);
	};
	
	/// Returns an array of created Tilemaps.
	/// 
	/// @returns {Array<Id.Tilemap>}
	/// @self RoomLoaderPayload
	static GetTilemaps = function() {
		return __tilemaps.__ids;
	};
	
	/// Returns the ID of the created Sprite matching the given room ID if found, or undefined if not found.
	/// 
	/// @param {String} roomId The room ID of the Sprite to search for.
	/// 
	/// @returns {Id.Sprite,Undefined}
	/// @self RoomLoaderPayload
	static GetSprite = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetSprite", _roomId, "get a Sprite ID from the", "room ID");
		return __sprites.__Get(_roomId);
	};
	
	/// Returns an array of created Sprites.
	/// 
	/// @returns {Array<Id.Sprite>}
	/// @self RoomLoaderPayload
	static GetSprites = function() {
		return __sprites.__ids;
	};
	
	/// Returns the ID of the created Sequence matching the given room ID if found, or undefined if not found.
	/// 
	/// @param {String} roomId The room ID of the Sequence to search for.
	/// 
	/// @returns {Id.Sequence,Undefined}
	/// @self RoomLoaderPayload
	static GetSequence = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetSequence", _roomId, "get a Sequence ID from the", "room ID");
		return __sequences.__Get(_roomId);
	};
	
	/// Returns an array of created Sequences.
	/// 
	/// @returns {Array<Id.Sequence>}
	/// @self RoomLoaderPayload
	static GetSequences = function() {
		return __sequences.__ids;
	};
	
	/// Returns the ID of the created Particle System matching the given room ID if found, or undefined if not found.
	/// 
	/// @param {String} roomId The room ID of the Particle System to search for.
	/// 
	/// @returns {Id.ParticleSystem,Undefined}
	/// @self RoomLoaderPayload
	static GetParticleSystem = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetParticleSystem", _roomId, "get a Particle System ID from the", "room ID");
		return __particleSystems.__Get(_roomId);
	};
	
	/// Returns an array of created Particle Systems.
	/// 
	/// @returns {Array<Id.ParticleSystem>}
	/// @self RoomLoaderPayload
	static GetParticleSystems = function() {
		return __particleSystems.__ids;
	};
	
	/// Returns the ID of the created Text matching the given room ID if found, or undefined if not found.
	/// 
	/// @param {String} roomId The room ID of the Text to search for.
	/// 
	/// @returns {Id.Text,Undefined}
	/// @self RoomLoaderPayload
	static GetText = function(_roomId) {
		__RoomLoaderCatchString(__messagePrefix, "GetText", _roomId, "get a Text ID from the", "room ID");
		return __texts.__Get(_roomId);
	};
	
	/// Returns an array of created Texts.
	/// 
	/// @returns {Array<Id.Text>}
	/// @self RoomLoaderPayload
	static GetTexts = function() {
		return __texts.__ids;
	};
	
	/// Returns the ID of the created Background matching the given layer name if found, or undefined if not found.
	/// 
	/// @param {String} layerName The Background layer name to search for.
	/// 
	/// @returns {Id.Background,Undefined}
	/// @self RoomLoaderPayload
	static GetBackground = function(_layerName) {
		__RoomLoaderCatchString(__messagePrefix, "GetBackground", _layerName, "get a Background ID from the", "layer name");
		return __backgrounds.__Get(_layerName);
	};
	
	/// Returns an array of created Backgrounds.
	/// 
	/// @returns {Array<Id.Background>}
	/// @self RoomLoaderPayload
	static GetBackgrounds = function() {
		return __backgrounds.__ids;
	};
	
	#endregion
	#region Status
	
	/// Returns whether the loaded room overlaps the given camera's view (true) or not (false).
	/// Handles any combination of camera and loaded room positioning, scaling, and rotation.
	/// Positive padding expands the view bounds outward, negative padding shrinks them inward.
	/// 
	/// @param {Id.Camera} camera The camera to check against. [Default: view_camera[0]]
	/// @param {Real} padding The padding to apply to the view bounds. [Default: 0]
	/// 
	/// @returns {Bool}
	/// @self RoomLoaderPayload
	static IsInView = function(_camera = view_camera[0], _pad = 0) {
		var _camW = camera_get_view_width(_camera);
		var _camH = camera_get_view_height(_camera);
		var _camHW = (_camW / 2) + _pad;
		var _camHH = (_camH / 2) + _pad;
		
		var _camCX = camera_get_view_x(_camera) + (_camW / 2);
		var _camCY = camera_get_view_y(_camera) + (_camH / 2);
		
		var _angle = camera_get_view_angle(_camera);
		var _cos = dcos(_angle), _absCos = abs(_cos);
		var _sin = dsin(_angle), _absSin = abs(_sin);
		
		if (__obb != undefined) {
			var _deltaX = __obb.__centerX - _camCX;
			var _deltaY = __obb.__centerY - _camCY;
			var _bboxHW = __obb.__hw;
			var _bboxHH = __obb.__hh;
			var _bboxCos = __obb.__cos;
			var _bboxSin = __obb.__sin;
			__ROOMLOADER_ISINVIEW_SAT;
		}
		
		var _deltaX = mean(__bbox.x1, __bbox.x2) - _camCX;
		var _deltaY = mean(__bbox.y1, __bbox.y2) - _camCY;
		var _bboxHW = (__bbox.x2 - __bbox.x1) / 2;
		var _bboxHH = (__bbox.y2 - __bbox.y1) / 2;
		var _bboxCos = 1;
		var _bboxSin = 0;
		__ROOMLOADER_ISINVIEW_SAT;
	};
	
	/// Checks whether the given point falls inside the loaded room's bounds, accounting for any combination of position, origin, scale, and rotation.
	/// 
	/// @param {Real} x The x coordinate of the point to check.
	/// @param {Real} y The y coordinate of the point to check.
	/// 
	/// @returns {Bool}
	/// @self RoomLoaderPayload
	static IsPointInside = function(_px, _py) {
		if (__obb != undefined) {
			var _dx = _px - __obb.__centerX;
			var _dy = _py - __obb.__centerY;
			var _localX = _dx * __obb.__cos - _dy * __obb.__sin;
			var _localY = _dx * __obb.__sin + _dy * __obb.__cos;
			
			return ((abs(_localX) <= __obb.__hw) and (abs(_localY) <= __obb.__hh));
		}
		
		return point_in_rectangle(_px, _py, __bbox.x1, __bbox.y1, __bbox.x2, __bbox.y2);
	};
	
	/// Returns whether the payload has been cleaned up (true) or not (false).
	/// 
	/// @returns {Bool}
	/// @self RoomLoaderPayload
	static IsCleanedUp = function() {
		return __cleanedUp;
	};
	
	#endregion
	#region Cleanup
	
	/// Destroys all created layers and elements.
	/// After calling this method, the Payload instance should be dereferenced to be picked up by the Garbage Collector.
	/// 
	/// @returns {Struct.RoomLoaderPayload}
	/// @self RoomLoaderPayload
	static Cleanup = function() {
		static _methodName = "Cleanup";
		
		if (__cleanedUp) {
			__RoomLoaderLogMethod(__messagePrefix, _methodName, $"data for <{room_get_name(__room)}> is already cleaned up");
			return self;
		}
		
		__ROOMLOADER_BENCH_START;
		__instances.__Destroy();
		__tilemaps.__Destroy();
		__sprites.__Destroy();
		__sequences.__Destroy();
		__particleSystems.__Destroy();
		__texts.__Destroy();
		__backgrounds.__Destroy();
		__layers.__Destroy();
		__cleanedUp = true;
		
		__RoomLoaderLogMethodTimed(__messagePrefix, _methodName, "Unloaded", __room);
		
		return self;
	};

	#endregion
	
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
		static __Finalize = function() {
			if (__index != array_length(__ids)) {
				array_resize(__ids, __index);
				array_resize(__roomIds, __index);
			}
		};
		static __Get = function(_roomId) {
			var _index = array_get_index(__roomIds, _roomId);
			return ((_index == -1) ? noone : __ids[_index]);
		};
		static __Detach = function() {
			var _ids = __ids;
			__ids = [];
			__roomIds = [];
			
			return _ids;
		};
		static __Destroy = function() {
			var _i = 0; repeat (array_length(__ids)) {
				instance_destroy(__ids[_i]);
				_i++;
			}
		};
	};
	static __messagePrefix = "Payload";
	
	__room = _room;
	__bbox = undefined;
	__obb = undefined;
	__polygon = undefined;
	
	__layers = new __Container(layer_destroy);
	__instances = new __Instances();
	__tilemaps = new __Container(layer_tilemap_destroy);
	__sprites = new __Container(layer_sprite_destroy);
	__sequences = new __Container(layer_sequence_destroy);
	__particleSystems = new __Container(part_system_destroy);
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
};