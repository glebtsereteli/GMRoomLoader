/// @feather ignore all

function __RoomLoaderDataLayerInstance(_layerData, _instancesData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.INSTANCES;
	
	static __OnLoad = function(_layer, _xOffset, _yOffset, _flags) {
		if (ROOMLOADER_INSTANCES_RUN_CREATION_CODE) {
			if (ROOMLOADER_USE_RETURN_DATA) {
				__ROOMLOADER_INSTANCE_FULL_START_RETURNDATA;
				__ROOMLOADER_INSTANCE_CC;
				__ROOMLOADER_INSTANCE_FULL_END_RETURNDATA;
			}
			else {
				__ROOMLOADER_INSTANCE_FULL_START_NORETURNDATA;
				__ROOMLOADER_INSTANCE_CC;
				__ROOMLOADER_INSTANCE_FULL_END_NORETURNDATA;
			}
		}
		else {
			if (ROOMLOADER_USE_RETURN_DATA) {
				__ROOMLOADER_INSTANCE_FULL_START_RETURNDATA;
				__ROOMLOADER_INSTANCE_FULL_END_RETURNDATA;
			}
			else {
				__ROOMLOADER_INSTANCE_FULL_START_NORETURNDATA;
				__ROOMLOADER_INSTANCE_FULL_END_NORETURNDATA;
			}
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
