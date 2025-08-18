/// @feather ignore all

function __RoomLoaderDataRoom(_room) constructor {
	__room = _room;
	__layersPool = [];
	__instancesData = [];
	__instancesInitLut = {};
	__width = undefined;
	__height = undefined;
	__creationCode = undefined;
	
	static __Init = function() {
		static _MapInstanceData = function(_data) {
			_data.object_index = asset_get_index(_data.object_index);
			_data.sprite = object_get_sprite(_data.object_index);
			_data.creationCode = __RoomLoaderProcessScript(_data.creation_code);
			
			_data.preCreate = {}; 
			with (_data.preCreate) {
				if (ROOMLOADER_INSTANCES_USE_ROOM_PARAMS) {
					image_xscale = _data.xscale;
					image_yscale = _data.yscale;
					image_angle = _data.angle;
					var _color = _data.colour;
					if (_color == -1) {
						image_blend = c_white;
						image_alpha = 1;
					}
					else {
						image_blend = _color & 0xffffff;
						image_alpha = ((_color >> 24) & 0xff) / 255;
					}
					image_index = _data.image_index;
					image_speed = _data.image_speed;
				}
				var _preCreate = _data.pre_creation_code;
				if (_preCreate != -1) {
					_preCreate();
				}
			};
			
			__instancesInitLut[$ _data.id] = _data;
			
			return _data;
		};
		static _GetDataConstructor = function(_type) {
			switch (_type) {
				case layerelementtype_instance: return __RoomLoaderDataLayerInstance;
				case layerelementtype_sprite:
				case layerelementtype_sequence:
				case layerelementtype_text: return __RoomLoaderDataLayerAsset;
				case layerelementtype_tilemap: return __RoomLoaderDataLayerTile;
				case layerelementtype_background: return __RoomLoaderDataLayerBackground;
			}
			return undefined;
		};
		
		var _rawData = room_get_info(__room, false, true, true, true, true);
		
		__layersPool = [];
		__width = _rawData.width;
		__height = _rawData.height;
		__creationCode = __RoomLoaderProcessScript(_rawData.creationCode);
		
		// Store instances data:
		var _instancesData = _rawData.instances;
		if (_instancesData != 0) {
			__instancesData = array_map(_instancesData, _MapInstanceData);
		}
		
		// Collect data:
		var _layersData = _rawData.layers;
		var _i = 0; repeat (array_length(_layersData)) {
			var _layerData = _layersData[_i];
			var _elementsData = _layerData.elements;
			if (_elementsData != 0) {
				var _j = 0; repeat (array_length(_elementsData)) {
					var _dataConstructor = _GetDataConstructor(_elementsData[_j].type);
					if (_dataConstructor != undefined) {
						var _data = new _dataConstructor(_layerData, _elementsData);
						_data.__Init();
						array_push(__layersPool, _data);
						break;
					}
					_j++;
				}
			}
			_i++;
		}
		
		delete __instancesInitLut;
	};
	static __Load = function(_x, _y, _xOrigin, _yOrigin, _flags) {
		_x -= (__width * _xOrigin);
		_y -= (__height * _yOrigin);
		
		if (ROOMLOADER_USE_PAYLOAD) {
			RoomLoader.__payload.__instances.__Init(array_length(__instancesData));
		}
		
		var _i = 0; repeat (array_length(__layersPool)) {
			__layersPool[_i].__Load(_x, _y, _flags);
			_i++;
		}
		
		if (ROOMLOADER_ROOMS_RUN_CREATION_CODE) {
			__creationCode();
		}
	};
	static __TakeScreenshot = function(_pLeft01, _pTop01, _pWidth01, _pHeight01, _xOrigin, _yOrigin, _scale, _flags) {
        var _scaled = (_scale != 1);
		var _width = __width * _scale;
		var _height = __height * _scale;
        
        // Raw surface, room contents:
        var _rawSurf = surface_create(__width, __height);
        surface_set_target(_rawSurf); {
            draw_clear_alpha(c_black, 0);
			
	        var _bm = gpu_get_blendmode_ext_sepalpha();
	        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
			
            var _i = array_length(__layersPool);
            while (_i--) { 
                with (__layersPool[_i]) {
                    __Draw(_flags);
                }
            }
			
			script_execute_ext(gpu_set_blendmode_ext_sepalpha, _bm);
            surface_reset_target();
        }
        
        // Final scaled surface:
        var _finalSurf = _rawSurf;
        if (_scaled) {
            _finalSurf = surface_create(_width, _height);
            surface_set_target(_finalSurf); {
                draw_clear_alpha(c_black, 0);
                draw_surface_stretched(_rawSurf, 0, 0, _width, _height);
                surface_reset_target();
            }
        }
        
        // Generate sprite:
		_width = _pWidth01 * _width;
		_height = _pHeight01 * _height;
        var _sprite = sprite_create_from_surface(_finalSurf, 
			(_pLeft01 * _width), (_pTop01 * _height),
			_width, _height,
			false, false,
			(_xOrigin * _width), (_yOrigin * _height)
		);
        
        // Cleanup & return:
        surface_free(_rawSurf);
        if (_scaled) {
			surface_free(_finalSurf);
		}
        return _sprite;
    };
	
	__Init();
}
