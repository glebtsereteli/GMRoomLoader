/// @feather ignore all

function __RoomLoaderData(_room) constructor {
	__room = _room;
	__data = undefined;
	__instances_data = [];
	__instances_init_lookup = {};
	__width = undefined;
	__height = undefined;
	__creation_code = undefined;
	
	static __init = function() {
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
			} : __roomloader_noop);
			
			_data.object_index = asset_get_index(_data.object_index);
			_data.sprite = object_get_sprite(_data.object_index);
			_data.creation_code = __roomloader_process_script(_data.creation_code);
			_data.precreate = {}; with (_data.precreate) {
				_room_params(_data);
				var _precreate = _data.pre_creation_code;
				if (_precreate != -1) {
					_precreate();
				}
			};
			__instances_init_lookup[$ _data.id] = _data;
			return _data;
		};
		static _get_data_constructor = function(_type) {
			switch (_type) {
				case layerelementtype_instance: return __RoomLoaderDataLayerInstance;
				case layerelementtype_sprite:
				case layerelementtype_sequence:
				case layerelementtype_particlesystem:
				case layerelementtype_text: return __RoomLoaderDataLayerAsset;
				case layerelementtype_tilemap: return __RoomLoaderDataLayerTilemap;
				case layerelementtype_background: return __RoomLoaderDataLayerBackground;
			}
			return undefined;
		};
		
		var _raw_data = room_get_info(__room, false, true, true, true, true);
		__data = [];
		__width = _raw_data.width;
		__height = _raw_data.height;
		__creation_code = __roomloader_process_script(_raw_data.creationCode);
		
		// Store instances data:
		var _instances_data = _raw_data.instances;
		if (_instances_data != 0) {
			__instances_data = array_map(_instances_data, _map_instance_data);
		}
		
		// Collect data:
		var _layers_data = _raw_data.layers;
		var _i = 0; repeat (array_length(_layers_data)) {
			var _layer_data = _layers_data[_i];
			var _elements_data = _layer_data.elements;
			if (_elements_data != 0) {
				var _data_constructor = _get_data_constructor(_elements_data[0].type);
				if (_data_constructor != undefined) {
					var _data = new _data_constructor(_layer_data, _elements_data);
					array_push(__data, _data);
				}
			}
			_i++;
		}
		
		delete __instances_init_lookup;
	};
	static __load = function(_x, _y, _xorigin, _yorigin, _flags) {
		_x -= (__width * _xorigin);
		_y -= (__height * _yorigin);
		
		RoomLoader.__return_data.__instances.__init(array_length(__instances_data));
		
		var _i = 0; repeat (array_length(__data)) {
			__data[_i].__load(_x, _y, _flags);
			_i++;
		}
		
		if (ROOMLOADER_ROOMS_RUN_CREATION_CODE) {
			__creation_code();	
		}
		
		return RoomLoader.__return_data;
	};
	static __take_screenshot = function(_pleft01, _ptop01, _pwidth01, _pheight01, _xorigin, _yorigin, _scale, _flags) {
        var _scaled = (_scale != 1);
		var _width = (__width * _scale);
		var _height = (__height * _scale);
        
        // Raw surface, room contents:
        var _raw_surf = surface_create(__width, __height);
        surface_set_target(_raw_surf); {
            draw_clear_alpha(c_black, 0);
			
	        var _bm = gpu_get_blendmode_ext_sepalpha();
	        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
			
            var _i = array_length(__data);
            while (_i--) { 
                with (__data[_i]) {
                    __draw(_flags);
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
			(_xorigin * _width), (_yorigin * _height)
		);
        
        // Cleanup & return:
        surface_free(_raw_surf);
        if (_scaled) {
			surface_free(_final_surf);	
		}
        return _sprite;
    };
	
	__init();
};
function __RoomLoaderDataLayerParent(_layer_data) constructor {
	__owner = other;
	__layer_data = _layer_data;
	
	static __failed_filters = function() {
		return RoomLoader.__layer_failed_filters(__layer_data.name);
	};
	static __load = function(_xoffset, _yoffset, _flags) {
		if (not __roomloader_check_flags(_flags)) return undefined;
		if (__failed_filters()) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		RoomLoader.__return_data.__layers.__add(_layer, __layer_data.name);
		
		__on_load(_layer, _xoffset, _yoffset, _flags);
	};
	static __draw = function(_flags) {
		if (not __layer_data.visible) return;
		if (not __roomloader_check_flags(_flags)) return;
		if (__failed_filters()) return undefined;
		__on_draw();
	};
	static __on_load = __roomloader_noop;
	static __on_draw = __roomloader_noop;
}
function __RoomLoaderDataLayerInstance(_layer_data, _instances_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __flag = ROOMLOADER_FLAG.INSTANCES;
	__instances_data = array_map(_instances_data, __map_data);
	
	static __map_data = function(_inst_data) {
		return __owner.__instances_init_lookup[$ _inst_data.inst_id];
	};
	
	static __on_load_cc = function(_layer, _xoffset, _yoffset, _flags) {
		__ROOMLOADER_INSTANCE_FULL_START
		__ROOMLOADER_INSTANCE_CC
		__ROOMLOADER_INSTANCE_FULL_END
	};
	static __on_load_nocc = function(_layer, _xoffset, _yoffset, _flags) {
		__ROOMLOADER_INSTANCE_FULL_START
		__ROOMLOADER_INSTANCE_FULL_END
	};
	static __on_load = (ROOMLOADER_INSTANCES_RUN_CREATION_CODE ? __on_load_cc : __on_load_nocc);
	static __on_draw = function() {
		var _i = 0; repeat (array_length(__instances_data)) {
			with (__instances_data[_i]) {
				if (sprite == -1) break;
				draw_sprite_ext(
					sprite, precreate.image_index,
					x, y,
					precreate.image_xscale, precreate.image_yscale, precreate.image_angle,
					precreate.image_blend, precreate.image_alpha
				);
			}
			_i++;
		}
	};
}
function __RoomLoaderDataLayerAsset(_layer_data, _data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __DataSprite = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.SPRITES;
		
		static __load = function(_layer, _xoffset, _yoffset, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			with (__data) {
				var _x = x + _xoffset;
				var _y = y + _yoffset;
				var _sprite = layer_sprite_create(_layer, _x, _y, sprite_index);
				layer_sprite_index(_sprite, image_index);
				layer_sprite_xscale(_sprite, image_xscale);
				layer_sprite_yscale(_sprite, image_yscale);
				layer_sprite_angle(_sprite, image_angle);
				layer_sprite_speed(_sprite, image_speed);
				layer_sprite_blend(_sprite, image_blend);
				layer_sprite_alpha(_sprite, image_alpha);
				
				RoomLoader.__return_data.__sprites.__add(_sprite, name);
			}
		};
		static __draw = function(_flags) {
			if (not __roomloader_check_flags(_flags)) return;
			
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
	static __DataParticleSystem = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.PARTICLE_SYSTEMS;
		
		static __load = function(_layer, _xoffset, _yoffset, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			var _particle_system = part_system_create_layer(_layer, false, __data.ps);
			var _x = __data.x + _xoffset;
			var _y = __data.y + _yoffset;
			part_system_position(_particle_system, _x, _y);
			part_system_color(_particle_system, __data.blend, __data.alpha)
			part_system_angle(_particle_system, __data.angle);
			
			repeat (ROOMLOADER_PARTICLE_SYSTEMS_STEPS) {
				part_system_update(_particle_system);	
			}
			
			RoomLoader.__return_data.__particle_systems.__add(_particle_system, __data.name);
		}
		static __draw = __roomloader_noop;
	};
	static __DataSequence = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.SEQUENCES;
		
		static __load = function(_layer, _xoffset, _yoffset, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			var _x = __data.x + _xoffset;
			var _y = __data.y + _yoffset;
			var _sequence = layer_sequence_create(_layer, _x, _y, __data.seq_id);
			layer_sequence_headpos(_sequence, __data.head_position);
			layer_sequence_xscale(_sequence, __data.image_xscale);
			layer_sequence_yscale(_sequence, __data.image_yscale);
			layer_sequence_angle(_sequence, __data.image_angle);
			layer_sequence_speedscale(_sequence, __data.image_speed);
			
			if (ROOMLOADER_SEQUENCES_PAUSE) {
				layer_sequence_pause(_sequence);
			}
			
			RoomLoader.__return_data.__sequences.__add(_sequence, __data.name);
		}
		static __draw = __roomloader_noop;
	};
	static __DataText = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.TEXTS;
		
		static __load = function(_layer, _xoffset, _yoffset, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			with (__data) {
				var _x = x + _xoffset;
				var _y = y + _yoffset;
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
				
				RoomLoader.__return_data.__texts.__add(_text, name);
			}
		}
		static __draw = function() {
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
	
	static __init = function() {
		var _i = 0; repeat (array_length(__data)) {
			var _data = __data[_i];
			var _constructor = undefined;
			switch (_data.type) {
				case layerelementtype_sprite: _constructor = __DataSprite; break;
				//case layerelementtype_particlesystem: _constructor = __DataParticleSystem; break;
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
	static __load = function(_xoffset, _yoffset, _flags) {
		if (RoomLoader.__layer_failed_filters(__layer_data.name)) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		var _i = 0; repeat (array_length(__data)) {
			__data[_i].__load(_layer, _xoffset, _yoffset, _flags);
			_i++;
		}
		
		RoomLoader.__return_data.__layers.__add(_layer, __layer_data.name);
	};
	static __draw = function(_flags) {
		if (not __layer_data.visible) return;
		if (__failed_filters()) return undefined;
		
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				__draw(_flags);
			}
			_i++;
		}
	};
	
	__init();
};
function __RoomLoaderDataLayerTilemap(_layer_data, _elements_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	__flag = ROOMLOADER_FLAG.TILEMAPS;
	__layer_data = _layer_data;
	__tilemap_data = _elements_data[0];
	__tiles_data = [];
	__tileset = undefined;
	__width = undefined;
	__height = undefined;
	
	static __init = function() {
		__tileset = __tilemap_data[$ "tileset_index"];
		__width = __tilemap_data.width;
		__height = __tilemap_data.height;
		
		var _tiles_data = __tilemap_data.tiles;
		var _i = 0; repeat (array_length(_tiles_data)) {
			var _data = _tiles_data[_i];
			if (_data > 0) {
				array_push(__tiles_data, {
					data: _data,
					x: (_i mod __width),
					y: (_i div __width),
				});
			}
			_i++;
		}
	};
	static __create_tilemap = function(_layer, _x, _y) {
		var _tilemap = layer_tilemap_create(_layer, _x, _y, __tileset, __width, __height);
		
		var _i = 0; repeat (array_length(__tiles_data)) {
			var _tile_data = __tiles_data[_i];
			tilemap_set(_tilemap, _tile_data.data, _tile_data.x, _tile_data.y);
			_i++;
		}
		
		return _tilemap;
	};
	static __on_load = function(_layer, _xoffset, _yoffset) {
		var _tilemap = __create_tilemap(_layer, _xoffset, _yoffset);
		RoomLoader.__return_data.__tilemaps.__add(_tilemap, __tilemap_data.name);
	};
	static __on_draw = function() {
		var _layer = layer_create(0);
		var _tilemap = __create_tilemap(_layer, 0, 0);
		draw_tilemap(_tilemap, 0, 0);
		layer_tilemap_destroy(_tilemap);
		layer_destroy(_layer);
	};
	
	__init();
};
function __RoomLoaderDataLayerBackground(_layer_data, _bg_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __flag = ROOMLOADER_FLAG.BACKGROUNDS;
	__bg_data = _bg_data[0];
	
	static __on_load = function(_layer, _xoffset, _yoffset, _flags, _return_data) {
		with (__bg_data) {
			layer_x(_layer, layer_get_x(_layer) + _xoffset);
			layer_y(_layer, layer_get_y(_layer) + _yoffset);
			
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
			
			RoomLoader.__return_data.__backgrounds.__add(_bg, name);
		}
	};
	static __on_draw = function() {
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
		var _xoffset = __layer_data.xoffset;
		var _yoffset = __layer_data.yoffset;
		
		with (__bg_data) {
			var _sprite = sprite_index;
			if (_sprite == -1) return _fill(_room_width, _room_height);
			
			var _width = (stretch ? _room_width : sprite_get_width(_sprite));
			var _height = (stretch ? _room_height : sprite_get_height(_sprite));
			var _y1 = (vtiled ? (-_height + ((abs(_yoffset) mod _height) * sign(_yoffset))) : _yoffset);
			var _ny = (_room_height div _height) + 2;
			
			if (htiled) {
				var _x1 = -_width + ((abs(_xoffset) mod _width) * sign(_xoffset));
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
				_vtiled(_sprite, _xoffset, _y1, _width, _height, _ny);
			}
			else {
				draw_sprite_stretched_ext(_sprite, image_index, _xoffset, _yoffset, _width, _height, blendColour, blendAlpha);	
			}
		}
	};
};
