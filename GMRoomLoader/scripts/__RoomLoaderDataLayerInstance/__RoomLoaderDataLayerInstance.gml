/// @feather ignore all

function __RoomLoaderDataLayerInstance(_layerData, _instancesData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.INSTANCES;
	
	static __OnLoad = function(_layer, _xOffset, _yOffset, _flags) {
		if (ROOMLOADER_USE_RETURN_DATA) {
			var _returnData = RoomLoader.__returnData.__instances;
			var _ids = _returnData.__ids;
			var _roomIds = _returnData.__roomIds;
			var _index = _returnData.__index;
		}
		
		var _i = 0; repeat (array_length(__instancesData)) {
			var _iData = __instancesData[_i];
			var _iX = _iData.x + _xOffset;
			var _iY = _iData.y + _yOffset;
			var _inst = instance_create_layer(_iX, _iY, _layer, _iData.object_index, _iData.preCreate);
			__ROOMLOADER_INSTANCE_CC;
			if (ROOMLOADER_USE_RETURN_DATA) {
				_ids[_index] = _inst;
				_roomIds[_index] = _iData.id;
				_index++;
			}
			_i++;
		}
		
		if (ROOMLOADER_USE_RETURN_DATA) {
			_returnData.__index = _index;
		}
	};
	static __OnDraw = function() {
		var _i = 0; repeat (array_length(__instancesData)) {
			with (__instancesData[_i]) {
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
	__instancesData = array_map(_instancesData, __MapData);
	
	static __MapData = function(_iData) {
		return __owner.__instancesInitLut[$ _iData.inst_id];
	};
}
