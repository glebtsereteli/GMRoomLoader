/// @feather ignore all

function __RoomLoaderDataLayerInstance(_layerData, _instancesData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.INSTANCES;
	
	static __OnLoad = function(_layer, _x1, _y1, _flags) {
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			var _payload = RoomLoader.__payload.__instances;
			var _ids = _payload.__ids;
			var _roomIds = _payload.__roomIds;
			var _index = _payload.__index;
		}
		
		var _i = 0; repeat (array_length(__instancesPool)) {
			var _iData = __instancesPool[_i];
			var _iX = _x1 + _iData.x;
			var _iY = _y1 + _iData.y;
			
			var _inst = instance_create_layer(_iX, _iY, _layer, _iData.object, _iData.preCreate);
			__ROOMLOADER_INSTANCE_CC;
			if (ROOMLOADER_DELIVER_PAYLOAD) {
				_ids[_index] = _inst;
				_roomIds[_index] = _iData.id;
				_index++;
			}
			_i++;
		}
		
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			_payload.__index = _index;
		}
	};
	static __OnDraw = function() {
		var _i = 0; repeat (array_length(__instancesPool)) {
			with (__instancesPool[_i]) {
				if (sprite == -1) break;
				draw_sprite_ext(
					sprite, preCreate.image_index,
					x, y,
					preCreate.image_xscale, preCreate.image_yscale, preCreate.image_angle,
					preCreate.image_blend, preCreate.image_alpha
				);
			}
			_i++;
		}
	};
	
	// custom
	__instancesPool = array_map(_instancesData, __MapData);
	
	static __MapData = function(_iData) {
		return __owner.__instancesInitLut[$ _iData.inst_id];
	};
}
