// feather ignore all

function __RoomLoaderDataRoom(_room) constructor {
	__room = _room;
	__layersPool = [];
	__instancesPool = [];
	__instancesInitLut = {};
	__tilemapsLut = {};
	__width = undefined;
	__height = undefined;
	__creationCode = undefined;
	
	static __Init = function() {
		static _MapInstanceData = function(_in) {
			var _object = asset_get_index(_in.object_index);
			var _out = {
				id: _in.id,
				x: _in.x,
				y: _in.y,
			    object: _object,
				preCreate: {},
				creationCode: max(_in.creation_code, __RoomLoaderNoop),
			};
			
			if (ROOMLOADER_INSTANCES_USE_ROOM_PARAMS) {
				with (_out.preCreate) {
				    image_xscale = _in.xscale;
				    image_yscale = _in.yscale;
				    image_angle = _in.angle;
					
				    var _color = _in.colour;
				    if (_color == -1) {
				        image_blend = c_white;
				        image_alpha = 1;
				    }
					else {
				        image_blend = _color & 0xffffff;
				        image_alpha = ((_color >> 24) & 0xff) / 255;
				    }
					
					sprite_index = object_get_sprite(_object);
				    image_index = _in.image_index;
				    image_speed = _in.image_speed;
					
				    var _pcc = _in.pre_creation_code;
				    if (_pcc != -1) {
						x = _in.x;
						y = _in.y;
				        _pcc();
						struct_remove(self, "x");
						struct_remove(self, "y");
				    }
				};
			}
			
			__instancesInitLut[$ _in.id] = _out;
			
			return _out;
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
		__creationCode = max(_rawData.creationCode, __RoomLoaderNoop);
		
		var _instancesData = _rawData.instances;
		if (_instancesData != 0) {
			__instancesPool = array_map(_instancesData, _MapInstanceData);
		}
		
		var _layersData = _rawData.layers;
		var _i = 0; repeat (array_length(_layersData)) {
			var _layerData = _layersData[_i];
			var _elementsData = _layerData.elements;
			var _layer = undefined;
			
			if (_elementsData != 0) {
				var _j = 0; repeat (array_length(_elementsData)) {
					var _dataConstructor = _GetDataConstructor(_elementsData[_j].type);
					if (_dataConstructor != undefined) {
						_layer = new _dataConstructor(_layerData, _elementsData);
						break;
					}
					_j++;
				}
			}
			else if ((struct_exists(_layerData, "effectInfo")) and (not _layerData.effectInfo.singleLayerOnly)) {
				_layer = new __RoomLoaderDataLayerEffect(_layerData);
			}
			
			if (_layer != undefined) {
				_layer.__Init();
				array_push(__layersPool, _layer);
			}
			
			_i++;
		}
		
		delete __instancesInitLut;
	};
	static __Load = function(_x1, _y1, _xOrigin, _yOrigin, _flags, _xScale, _yScale, _angle) {
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__instances.__Init(array_length(__instancesPool));
		}
		
		if (__ROOMLOADER_NOTRANSFORM) {
			_x1 -= __width * _xOrigin;
			_y1 -= __height * _yOrigin;
			
			var _i = 0; repeat (array_length(__layersPool)) {
				__layersPool[_i].__Load(_x1, _y1, _flags);
				_i++;
			}
		}
		else {
			var _xOffset = __width * _xOrigin * _xScale;
			var _yOffset = __height * _yOrigin * _yScale;
			
			var _cos = dcos(_angle);
		    var _sin = dsin(_angle);
			
		    var _x = _x1 - ((_xOffset * _cos) + (_yOffset * _sin));
		    var _y = _y1 - ((-_xOffset * _sin) + (_yOffset * _cos));
			
			var _i = 0; repeat (array_length(__layersPool)) {
				with (__layersPool[_i]) {
					var _xx = (__tile ? _x1 : _x);
					var _yy = (__tile ? _y1 : _y);
					__LoadTransformed(_xx, _yy, _flags, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin);
				}
				_i++;
			}
		}
		
		__creationCode();
	};
	static __ScreenshotSprite = function(_left01, _top01, _width01, _height01, _xOrigin01, _yOrigin01, _xScale, _yScale, _flags) {
		__ROOMLOADER_SCREENSHOT_START;
		
	    var _width = __width * _xScale;
	    var _height = __height * _yScale;
		
	    var _finalSurf = _rawSurf;
	    if ((_xScale != 1) or (_yScale != 1)) {
	        _finalSurf = surface_create(_width, _height);
	        surface_set_target(_finalSurf); {
	            draw_clear_alpha(c_black, 0);
	            draw_surface_stretched(_rawSurf, 0, 0, _width, _height);
	            surface_reset_target();
	        }
			surface_free(_rawSurf);
	    }
		
		var _left = _left01 * _width;
		var _top = _top01 * _height;
		_width = (_width * _width01) - _left;
		_height = (_height * _height01) - _top;
		var _xOrigin = _xOrigin01 * _width;
		var _yOrigin = _yOrigin01 * _height;
		var _sprite = sprite_create_from_surface(_finalSurf, _left, _top, _width, _height, false, false, _xOrigin, _yOrigin);
		
	    surface_free(_finalSurf);
		
	    return _sprite;
	};
	static __ScreenshotSurface = function(_left01, _top01, _width01, _height01, _xOrigin01, _yOrigin01, _xScale, _yScale, _flags) {
		__ROOMLOADER_SCREENSHOT_START;
		
		if (not __ROOMLOADER_SCREENSHOT_TRANSFORMED) {
			return _rawSurf;
		}
		
	    __ROOMLOADER_FINAL_SURF;
		
	    return _finalSurf;
	};
	static __ScreenshotBuffer = function(_left01, _top01, _width01, _height01, _xOrigin01, _yOrigin01, _xScale, _yScale, _flags) {
	    __ROOMLOADER_SCREENSHOT_START;
		
		var _width = __width;
		var _height = __height;
		var _finalSurf = _rawSurf;
		
		if (__ROOMLOADER_SCREENSHOT_TRANSFORMED) {
		    __ROOMLOADER_FINAL_SURF;
		}
		
		var _return = {
			width: _width,
			height: _height,
			buffer: buffer_create(_width * _height * 4, buffer_fixed, 1),
		};
		buffer_get_surface(_return.buffer, _finalSurf, 0);
		
		surface_free(_finalSurf);
		
	    return _return;
	};
	
	__Init();
}
