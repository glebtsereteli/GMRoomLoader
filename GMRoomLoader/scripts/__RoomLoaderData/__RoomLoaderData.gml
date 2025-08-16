/// @feather ignore all

function __RoomLoaderData(_room) constructor {
	__room = _room;
	__layersPool = [];
	__layersLut = {};
	__instancesData = [];
	__instancesInitLut = {};
	__width = undefined;
	__height = undefined;
	__creationCode = undefined;
	
	static __Init = function() {
		static _map_instance_data = function(_data) {
			static _room_params = (ROOMLOADER_INSTANCES_USE_ROOM_PARAMS ? function(_data) {
				image_xscale = _data.xscale;
				image_yscale = _data.yscale;
				image_angle = _data.angle;
				var _color = _data.colour;
				if (_color == -1) {
					image_blend = c_white;
					image_alpha = 1;
				}
				else {
					image_blend = (_color & 0xffffff);
					var _c = (_color >> 24);
					_c += (256 * (_c < 0));
					image_alpha = (_c / 255);
				}
				image_index = _data.image_index;
				image_speed = _data.image_speed;
			} : __RoomLoaderNoop);
			
			_data.object_index = asset_get_index(_data.object_index);
			_data.sprite = object_get_sprite(_data.object_index);
			_data.creationCode = __RoomLoaderProcessScript(_data.creation_code);
			_data.preCreate = {}; with (_data.preCreate) {
				_room_params(_data);
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
				//case layerelementtype_particlesystem: [@FIX] GM bug, currently broken.
				case layerelementtype_text: return __RoomLoaderDataLayerAsset;
				case layerelementtype_tilemap: return __RoomLoaderDataLayerTilemap;
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
			__instancesData = array_map(_instancesData, _map_instance_data);
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
						array_push(__layersPool, _data);
						__layersLut[$ _layerData.name] = _data;
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
		
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__instances.__Init(array_length(__instancesData));
		}
		
		var _i = 0; repeat (array_length(__layersPool)) {
			__layersPool[_i].__Load(_x, _y, _flags);
			_i++;
		}
		
		if (ROOMLOADER_ROOMS_RUN_CREATION_CODE) {
			__creationCode();
		}
	};
	static __TakeScreenshot = function(_pleft01, _ptop01, _pwidth01, _pheight01, _xOrigin, _yOrigin, _scale, _flags) {
        var _scaled = (_scale != 1);
		var _width = (__width * _scale);
		var _height = (__height * _scale);
        
        // Raw surface, room contents:
        var _raw_surf = surface_create(__width, __height);
        surface_set_target(_raw_surf); {
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
        
        // Final (scaled) surface:
        var _final_surf = _raw_surf;
        if (_scaled) {
            _final_surf = surface_create(_width, _height);
            surface_set_target(_final_surf); {
                draw_clear_alpha(c_black, 0);
                draw_surface_stretched(_raw_surf, 0, 0, _width, _height);
                surface_reset_target();
            }
        }
        
        // Generate sprite:
		_width = (_pwidth01 * _width);
		_height = (_pheight01 * _height);
        var _sprite = sprite_create_from_surface(_final_surf, 
			(_pleft01 * _width), (_ptop01 * _height),
			_width, _height,
			false, false,
			(_xOrigin * _width), (_yOrigin * _height)
		);
        
        // Cleanup & return:
        surface_free(_raw_surf);
        if (_scaled) {
			surface_free(_final_surf);
		}
        return _sprite;
    };
	
	__Init();
}
function __RoomLoaderDataLayerParent(_layerData) constructor {
	__owner = other;
	__layerData = _layerData;
	
	static __failed_filters = function() {
		return RoomLoader.__LayerFailedFilters(__layerData.name);
	};
	static __Load = function(_xOffset, _yOffset, _flags) {
		if (not __RoomLoaderCheckFlag(_flags)) return undefined;
		if (__failed_filters()) return undefined;
		
		var _layer = __RoomLoaderGetLayer(__layerData);
		
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__layers.__Add(_layer, __layerData.name);
		}
		
		__OnLoad(_layer, _xOffset, _yOffset, _flags);
	};
	static __Draw = function(_flags) {
		if (not __layerData.visible) return;
		if (not __RoomLoaderCheckFlag(_flags)) return;
		if (__failed_filters()) return undefined;
		__OnDraw();
	};
	static __OnLoad = __RoomLoaderNoop;
	static __OnDraw = __RoomLoaderNoop;
}
function __RoomLoaderDataLayerInstance(_layerData, _instancesData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	static __flag = ROOMLOADER_FLAG.INSTANCES;
	__instancesData = array_map(_instancesData, __MapData);
	
	static __MapData = function(_inst_data) {
		return __owner.__instancesInitLut[$ _inst_data.inst_id];
	};
	
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
}
function __RoomLoaderDataLayerAsset(_layerData, _data) : __RoomLoaderDataLayerParent(_layerData) constructor {
	static __DataSprite = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.SPRITES;
		
		static __Load = function(_layer, _xOffset, _yOffset) {
			with (__data) {
				var _x = x + _xOffset;
				var _y = y + _yOffset;
				var _sprite = layer_sprite_create(_layer, _x, _y, sprite_index);
				layer_sprite_index(_sprite, image_index);
				layer_sprite_xscale(_sprite, image_xscale);
				layer_sprite_yscale(_sprite, image_yscale);
				layer_sprite_angle(_sprite, image_angle);
				layer_sprite_speed(_sprite, image_speed);
				layer_sprite_blend(_sprite, image_blend);
				layer_sprite_alpha(_sprite, image_alpha);
				
				if (ROOMLOADER_USE_RETURN_DATA) {
					RoomLoader.__returnData.__sprites.__Add(_sprite, name);
				}
			}
		};
		static __Draw = function() {
			with (__data) {
				draw_sprite_ext(
					sprite_index, image_index,
					x, y,
					image_xscale, 1, image_angle,
					image_blend, image_alpha
				);
			}
		};
	};
	/* [@FIX] GM bug, currently broken.
	static __DataParticleSystem = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.PARTICLE_SYSTEMS;
		
		static __load = function(_layer, _xoffset, _yoffset) {
			var _particle_system = part_system_create_layer(_layer, false, __data.ps);
			var _x = __data.x + _xoffset;
			var _y = __data.y + _yoffset;
			part_system_position(_particle_system, _x, _y);
			part_system_color(_particle_system, __data.blend, __data.alpha)
			part_system_angle(_particle_system, __data.angle);
			
			repeat (ROOMLOADER_PARTICLE_SYSTEMS_STEPS) {
				part_system_update(_particle_system);
			}
			
			if (ROOMLOADER_USE_RETURN_DATA) {
				RoomLoader.__return_data.__particle_systems.__add(_particle_system, __data.name);
			}
		}
		static __draw = __roomloader_noop;
	};
	*/
	static __DataSequence = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.SEQUENCES;
		
		static __Load = function(_layer, _xOffset, _yOffset) {
			var _x = __data.x + _xOffset;
			var _y = __data.y + _yOffset;
			var _sequence = layer_sequence_create(_layer, _x, _y, __data.seq_id);
			layer_sequence_headpos(_sequence, __data.head_position);
			layer_sequence_xscale(_sequence, __data.image_xscale);
			layer_sequence_yscale(_sequence, __data.image_yscale);
			layer_sequence_angle(_sequence, __data.image_angle);
			layer_sequence_speedscale(_sequence, __data.image_speed);
			
			if (ROOMLOADER_SEQUENCES_PAUSE) {
				layer_sequence_pause(_sequence);
			}
			
			if (ROOMLOADER_USE_RETURN_DATA) {
				RoomLoader.__returnData.__sequences.__Add(_sequence, __data.name);
			}
		}
		static __Draw = __RoomLoaderNoop;
	};
	static __DataText = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.TEXTS;
		
		static __Load = function(_layer, _xOffset, _yOffset) {
			with (__data) {
				var _x = x + _xOffset;
				var _y = y + _yOffset;
				var _text = layer_text_create(_layer, _x, _y, font_index, text);
				layer_text_xscale(_text, xscale);
				layer_text_yscale(_text, yscale);
				layer_text_angle(_text, angle);
				layer_text_halign(_text, h_align);
				layer_text_valign(_text, v_align);
				layer_text_charspacing(_text, char_spacing);
				layer_text_linespacing(_text, line_spacing);
				layer_text_framew(_text, frame_width);
				layer_text_frameh(_text, frame_height);
				layer_text_wrap(_text, wrap);
				layer_text_xorigin(_text, xorigin);
				layer_text_yorigin(_text, yorigin);
				layer_text_blend(_text, blend);
				layer_text_alpha(_text, alpha);
				
				if (ROOMLOADER_USE_RETURN_DATA) {
					RoomLoader.__returnData.__texts.__Add(_text, name);
				}
			}
		}
		static __Draw = function() {
			with (__data) {
				var _font = draw_get_font();
				var _halign = draw_get_halign();
				var _valign = draw_get_valign();
				var _color = draw_get_color();
				var _alpha = draw_get_alpha();
				
				draw_set_font(font_index);
				draw_set_halign(h_align);
				draw_set_valign(v_align);
				draw_set_color(blend);
				draw_set_alpha(alpha);
				
				draw_text_transformed(x, y, text, xscale, yscale, angle);
				
				draw_set_font(_font);
				draw_set_color(_color);
				draw_set_alpha(_alpha);
				draw_set_halign(_halign);
				draw_set_halign(_valign);
			}
		};
	};
	
	__data = _data;
	
	static __Init = function() {
		var _i = 0; repeat (array_length(__data)) {
			var _data = __data[_i];
			var _constructor = undefined;
			switch (_data.type) {
				case layerelementtype_sprite: _constructor = __DataSprite; break;
				//case layerelementtype_particlesystem: _constructor = __DataParticleSystem; break; [@FIX] GM bug, currently broken.
				case layerelementtype_sequence: _constructor = __DataSequence; break;
				case layerelementtype_text: _constructor = __DataText; break;
			}
			if (_constructor != undefined) {
				__data[_i] = new _constructor(_data);
			}
			else {
				array_delete(__data, _i--, 1);
			}
			_i++;
		}
	};
	static __Load = function(_xOffset, _yOffset, _flags) {
		if (RoomLoader.__LayerFailedFilters(__layerData.name)) return undefined;
		
		var _layer = __RoomLoaderGetLayer(__layerData);
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__RoomLoaderCheckFlag(_flags)) {
					__Load(_layer, _xOffset, _yOffset);
				}
			}
			_i++;
		}
		
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__layers.__Add(_layer, __layerData.name);
		}
	};
	static __Draw = function(_flags) {
		if (not __layerData.visible) return;
		if (__failed_filters()) return undefined;
		
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__RoomLoaderCheckFlag(_flags)) {
					__Draw();
				}
			}
			_i++;
		}
	};
	
	__Init();
}
function __RoomLoaderDataLayerTilemap(_layerData, _elementsData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	__flag = ROOMLOADER_FLAG.TILEMAPS;
	__layerData = _layerData;
	__tilemapData = _elementsData[0];
	__tilesData = [];
	__tileset = undefined;
	__width = undefined;
	__height = undefined;
	
	static __Init = function() {
		__tileset = __tilemapData.tileset_index;
		__width = __tilemapData.width;
		__height = __tilemapData.height;
		
		var _tilesData = __tilemapData.tiles;
		var _i = 0; repeat (array_length(_tilesData)) {
			var _data = _tilesData[_i];
			if (_data > 0) {
				array_push(__tilesData, {
					data: _data,
					x: (_i mod __width),
					y: (_i div __width),
				});
			}
			_i++;
		}
	};
	static __CreateTilemap = function(_layer, _x, _y) {
		var _tilemap = layer_tilemap_create(_layer, _x, _y, __tileset, __width, __height);
		var _i = 0; repeat (array_length(__tilesData)) {
			with (__tilesData[_i]) {
				tilemap_set(_tilemap, data, x, y);
			}
			_i++;
		}
		return _tilemap;
	};
	static __OnLoad = function(_layer, _xOffset, _yOffset) {
		var _tilemap = __CreateTilemap(_layer, _xOffset, _yOffset);
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__tilemaps.__Add(_tilemap, __tilemapData.name);
		}
	};
	static __OnDraw = function() {
		var _layer = layer_create(0);
		var _tilemap = __CreateTilemap(_layer, 0, 0);
		draw_tilemap(_tilemap, 0, 0);
		layer_tilemap_destroy(_tilemap);
		layer_destroy(_layer);
	};
	
	__Init();
}
function __RoomLoaderDataLayerBackground(_layerData, _bgData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	static __flag = ROOMLOADER_FLAG.BACKGROUNDS;
	__bgData = _bgData[0];
	
	static __OnLoad = function(_layer, _xOffset, _yOffset, _flags, _return_data) {
		with (__bgData) {
			layer_x(_layer, layer_get_x(_layer) + _xOffset);
			layer_y(_layer, layer_get_y(_layer) + _yOffset);
			
			var _bg = layer_background_create(_layer, sprite_index);
			layer_background_visible(_bg, visible);
			layer_background_htiled(_bg, htiled);
			layer_background_vtiled(_bg, vtiled);
			layer_background_stretch(_bg, stretch);
			layer_background_xscale(_bg, xscale);
			layer_background_yscale(_bg, yscale);
			layer_background_index(_bg, image_index);
			layer_background_speed(_bg, image_speed);
			layer_background_blend(_bg, blendColour);
			layer_background_alpha(_bg, blendAlpha);
			
			if (ROOMLOADER_USE_RETURN_DATA) {
				RoomLoader.__returnData.__backgrounds.__Add(_bg, name);
			}
		}
	};
	static __OnDraw = function() {
		static _fill = function(_width, _height) {
			var _prev_color = draw_get_color();
			var _prev_alpha = draw_get_alpha();
			draw_set_color(blendColour);
			draw_set_alpha(blendAlpha);
			draw_rectangle(0, 0, _width, _height, false);
			draw_set_color(_prev_color);
			draw_set_alpha(_prev_alpha);
		};
		static _vtiled = function(_sprite, _x1, _y1, _width, _height, _n) {
			for (var _i = 0; _i < _n; _i++) {
				var _y = _y1 + (_i * _height);
				draw_sprite_stretched_ext(_sprite, image_index, _x1, _y, _width, _height, blendColour, blendAlpha);
			}
		};
		
		var _room_width = __owner.__width;
		var _room_height = __owner.__height;
		var _xOffset = __layerData.xoffset;
		var _yOffset = __layerData.yoffset;
		
		with (__bgData) {
			var _sprite = sprite_index;
			if (_sprite == -1) return _fill(_room_width, _room_height);
			
			var _width = (stretch ? _room_width : sprite_get_width(_sprite));
			var _height = (stretch ? _room_height : sprite_get_height(_sprite));
			var _y1 = (vtiled ? (-_height + ((abs(_yOffset) mod _height) * sign(_yOffset))) : _yOffset);
			var _ny = (_room_height div _height) + 2;
			
			if (htiled) {
				var _x1 = -_width + ((abs(_xOffset) mod _width) * sign(_xOffset));
				var _nx = (_room_width div _width) + 2;
				for (var _i = 0; _i < _nx; _i++) {
					var _x = _x1 + (_i * _width);
					draw_sprite_stretched_ext(_sprite, image_index, _x, _y1, _width, _height, blendColour, blendAlpha);
					if (vtiled) {
						_vtiled(_sprite, _x, _y1 + _height, _width, _height, _ny - 1);
					}
				}
			}
			else if (vtiled) {
				_vtiled(_sprite, _xOffset, _y1, _width, _height, _ny);
			}
			else {
				draw_sprite_stretched_ext(_sprite, image_index, _xOffset, _yOffset, _width, _height, blendColour, blendAlpha);	
			}
		}
	};
}
