/// feather ignore all

function __RoomLoaderDataLayerInstance(_layerData, _instancesData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.INSTANCES;
	
	static __OnLoad = function(_layer, _x1, _y1) {
		__ROOMLOADER_INST_LAYER_PRELOAD;

		var _i = 0; repeat (array_length(__instancesPool)) {
			var _iData = __instancesPool[_i];
			var _x = _x1 + _iData.x;
			var _y = _y1 + _iData.y;
			var _inst = instance_create_layer(_x, _y, _layer, _iData.object, _iData.preCreate);
			__ROOMLOADER_INST_CC;
			if (ROOMLOADER_DELIVER_PAYLOAD) {
				_ids[_index] = _inst;
				_roomIds[_index] = _iData.id;
				_index++;
			}
			_i++;
		}
		
		__ROOMLOADER_INST_LAYER_POSTLOAD;
	};
	static __OnLoadTransformed = function(_layer, _x1, _y1, _xScale, _yScale, _angle, _sin, _cos) {
		__ROOMLOADER_INST_LAYER_PRELOAD;
		
		var _i = 0; repeat (array_length(__instancesPool)) {
			var _iData = __instancesPool[_i];
			
			__ROOMLOADER_INST_TRANSFORM_PRELOAD;
			var _inst = instance_create_layer(_x, _y, _layer, _iData.object, _preCreate);
			__ROOMLOADER_INST_TRANSFORM_POSTLOAD;
			
			if (ROOMLOADER_DELIVER_PAYLOAD) {
				_ids[_index] = _inst;
				_roomIds[_index] = _iData.id;
				_index++;
			}
			_i++;
		}
		
		__ROOMLOADER_INST_LAYER_POSTLOAD;
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
