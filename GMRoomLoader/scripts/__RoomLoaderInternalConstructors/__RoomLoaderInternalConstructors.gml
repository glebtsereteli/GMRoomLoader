/// @feather ignore all

function __RoomLoaderFilter(_positive) constructor {
	__positive = _positive;
	__layer_names = [];
	
	static __check_empty = function() {
		return __positive;
	};
	static __check_active = function(_layer_name) {
		return array_contains(__layer_names, _layer_name);	
	};
	static __add = function(_layer_name) {
		array_push(__layer_names, _layer_name);
		__check = __check_active;
	};
	static __remove = function(_layer_name) {
		var _index = array_get_index(__layer_names, _layer_name);
		if (_index == undefined) return;
		
		array_delete(__layer_names, _index, 1);
		if (array_length(__layer_names) == 0) {
			__check = __check_empty;
		}
	};
	static __reset = function() {
		__layer_names = [];
	};
	static __get = function() {
		return __layer_names;
	};
	
	__check = __check_empty;
}

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
			_data.object_index = asset_get_index(_data.object_index);
			_data.sprite = object_get_sprite(_data.object_index);
			_data.creation_code = __roomloader_process_script(_data.creation_code);
			_data.precreate = {}; with (_data.precreate) {
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
				if (_data.pre_creation_code != -1) script_execute(_data.pre_creation_code);
			};
			__instances_init_lookup[$ _data.id] = _data;
			return _data;
		};
		static _get_data_constructor = function(_type) {
			switch (_type) {
				case layerelementtype_instance: return __RoomLoaderDataLayerInstance;
				case layerelementtype_sprite:
				case layerelementtype_sequence:
				case layerelementtype_particlesystem: return __RoomLoaderDataLayerAsset;
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
					_layer_data.prefixed_name = (ROOMLOADER_LAYER_PREFIX + _layer_data.name);
					var _data = new _data_constructor(_layer_data, _elements_data);
					array_push(__data, _data);
				}
			}
			_i++;
		}
		
		__instances_init_lookup = undefined;
	};
	static __load = function(_x, _y, _origin, _flags) {
		_x = __roomloader_get_offset_x(_x, __width, _origin);
		_y = __roomloader_get_offset_y(_y, __height, _origin);
		
		RoomLoader.__return_data.__instances.__ids = array_create(array_length(__instances_data), noone);
		
		var _i = 0; repeat (array_length(__data)) {
			__data[_i].__load(_x, _y, _flags);
			_i++;
		}
		
		if (ROOMLOADER_ROOM_RUN_CREATION_CODE) __creation_code();
		
		return RoomLoader.__return_data;
	};
	static __take_screenshot = function(_origin, _flags) {
		var _surf = surface_create(__width, __height);
		
		surface_set_target(_surf); {
			var _i = array_length(__data);
			while (_i--) { 
				with (__data[_i]) {
					//if (not __roomloader_check_flags(_flags)) break;
					if (not __layer_data.visible) break;
					__draw();
				}
			}
			
			surface_reset_target();
		}
		
		var _xorigin = __roomloader_get_offset_x(0, -__width, _origin);
		var _yorigin = __roomloader_get_offset_y(0, -__height, _origin);
		var _sprite = sprite_create_from_surface(_surf, 0, 0, __width, __height, false, false, _xorigin, _yorigin);
		
		surface_free(_surf);
		return _sprite;
	};
	
	__init();
};
function __RoomLoaderDataLayerParent(_layer_data) constructor {
	__owner = other;
	__layer_data = _layer_data;
	
	static __load = function(_xoffs, _yoffs, _flags) {
		if (not __roomloader_check_flags(_flags)) return undefined;
		if (RoomLoader.__layer_failed_filters(__layer_data.name)) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		RoomLoader.__return_data.__layers.__add(_layer, __layer_data.name);
		
		__on_load(_layer, _xoffs, _yoffs, _flags);
	};
	static __draw = __roomloader_noop;
	static __on_load = __roomloader_noop;
}
function __RoomLoaderDataLayerInstance(_layer_data, _instances_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	__flag = ROOMLOADER_FLAG.INSTANCES;
	__instances_data = array_map(_instances_data, __map_data);
	
	static __map_data = function(_inst_data) {
		return __owner.__instances_init_lookup[$ _inst_data.inst_id];
	};
	static __on_load = function(_layer, _xoffs, _yoffs, _flags) {
		var _instances = RoomLoader.__return_data.__instances.__ids;
		var _index = RoomLoader.__return_data.__instances.__index;
		
		var _i = 0; repeat (array_length(__instances_data)) {
			var _inst_data = __instances_data[_i];
			var _x = _inst_data.x + _xoffs;
			var _y = _inst_data.y + _yoffs;
			var _inst = instance_create_layer(_x, _y, _layer, _inst_data.object_index, _inst_data.precreate);
			with (_inst) {
				script_execute(_inst_data.creation_code);
			}
			_instances[_index] = _inst;
			_i++;
			_index++;
		}
		
		RoomLoader.__return_data.__instances.__index = _index;
	};
	static __draw = function() {
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
		
		static __load = function(_layer, _xoffs, _yoffs, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			var _x = __data.x + _xoffs;
			var _y = __data.y + _yoffs;
			var _sprite = layer_sprite_create(_layer, _x, _y, __data.sprite_index);
			layer_sprite_index(_sprite, __data.image_index);
			layer_sprite_xscale(_sprite, __data.image_xscale);
			//layer_sprite_yscale(_sprite, __data.image_yscale);
			layer_sprite_angle(_sprite, __data.image_angle);
			layer_sprite_speed(_sprite, __data.image_speed);
			layer_sprite_blend(_sprite, __data.image_blend);
			layer_sprite_alpha(_sprite, __data.image_alpha);
			
			RoomLoader.__return_data.__sprites.__add(_sprite, __data.name);
		};
		static __draw = function() {
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
		
		static __load = function(_layer, _xoffs, _yoffs, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			var _particle_system = part_system_create_layer(_layer, false, __data.ps);
			var _x = __data.x + _xoffs;
			var _y = __data.y + _yoffs;
			part_system_position(_particle_system, _x, _y);
			part_system_color(_particle_system, __data.blend, __data.alpha)
			part_system_angle(_particle_system, __data.angle);
			
			repeat (ROOMLOADER_PARTICLE_SYSTEMS_STEPS) part_system_update(_particle_system);
			
			RoomLoader.__return_data.__particle_systems.__add(_particle_system, __data.name);
		}
		static __draw = __roomloader_noop;
	};
	static __DataSequence = function(_data) constructor {
		__data = _data;
		__flag = ROOMLOADER_FLAG.SEQUENCES;
		
		static __load = function(_layer, _xoffs, _yoffs, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			var _x = __data.x + _xoffs;
			var _y = __data.y + _yoffs;
			var _sequence = layer_sequence_create(_layer, _x, _y, __data.seq_id);
			layer_sequence_headpos(_sequence, __data.head_position);
			layer_sequence_xscale(_sequence, __data.image_xscale);
			layer_sequence_yscale(_sequence, __data.image_yscale);
			layer_sequence_angle(_sequence, __data.image_angle);
			layer_sequence_speedscale(_sequence, __data.image_speed);
			
			if (ROOMLOADER_SEQUENCES_PAUSE) layer_sequence_pause(_sequence);
			
			RoomLoader.__return_data.__sequences.__add(_sequence, __data.name);
		}
		static __draw = __roomloader_noop;
	};
	
	__data = _data;
	
	static __init = function() {
		var _i = 0; repeat (array_length(__data)) {
			var _data = __data[_i];
			var _constructor = undefined;
			switch (_data.type) {
				case layerelementtype_sprite: _constructor = __DataSprite; break;
				case layerelementtype_particlesystem: _constructor = __DataParticleSystem; break;
				case layerelementtype_sequence: _constructor = __DataSequence; break;
			}
			if (_constructor != undefined) {
				__data[_i] = new _constructor(_data);
			}
			_i++;
		}
	};
	static __load = function(_xoffs, _yoffs, _flags) {
		if (RoomLoader.__layer_failed_filters(__layer_data.name)) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		var _i = 0; repeat (array_length(__data)) {
			__data[_i].__load(_layer, _xoffs, _yoffs, _flags);
			_i++;
		}
		
		RoomLoader.__return_data.__layers.__add(_layer, __layer_data.name);
	};
	static __draw = function(_flags) {
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				//if (not __roomloader_check_flags(_flags)) break;
				__draw();
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
		__tileset = (__tilemap_data[$ "tileset_index"] ?? __tilemap_data[$ "background_index"]);
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
	static __on_load = function(_layer, _xoffs, _yoffs) {
		var _tilemap = __create_tilemap(_layer, _xoffs, _yoffs);
		RoomLoader.__return_data.__tilemaps.__add(_tilemap, __tilemap_data.name);
	};
	static __draw = function() {
		var _layer = layer_create(0);
		var _tilemap = __create_tilemap(_layer, 0, 0);
		draw_tilemap(_tilemap, 0, 0);
		layer_tilemap_destroy(_tilemap);
		layer_destroy(_layer);
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
	
	__init();
};
function __RoomLoaderDataLayerBackground(_layer_data, _bg_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	__bg_data = _bg_data[0];
	__owner = other;
	__flag = ROOMLOADER_FLAG.BACKGROUNDS;
	
	static __on_load = function(_layer, _xoffs, _yoffs, _flags, _return_data) {
		var _bg = layer_background_create(_layer, __bg_data.sprite_index);
		layer_background_visible(_bg, __bg_data.visible);
		layer_background_htiled(_bg, __bg_data.htiled);
		layer_background_vtiled(_bg, __bg_data.vtiled);
		layer_background_stretch(_bg, __bg_data.stretch);
		layer_background_xscale(_bg, __bg_data.xscale);
		layer_background_yscale(_bg, __bg_data.yscale);
		layer_background_index(_bg, __bg_data.image_index);
		layer_background_speed(_bg, __bg_data.image_speed);
		layer_background_blend(_bg, __bg_data.blendColour);
		layer_background_alpha(_bg, __bg_data.blendAlpha);
		
		RoomLoader.__return_data.__backgrounds.__add(_bg, __bg_data.name);
	};
	static __draw = function() {
		static _vtiled = function(_sprite, _x1, _y1, _width, _height, _n) {
			for (var _i = 0; _i < _n; _i++) {
				var _y = _y1 + (_i * _height);
				draw_sprite_stretched_ext(_sprite, image_index, _x1, _y, _width, _height, blendColour, blendAlpha);
			}
		};
		
		var _room_width = __owner.__width;
		var _room_height = __owner.__height;
		var _xoffs = __layer_data.xoffset;
		var _yoffs = __layer_data.yoffset;
		
		with (__bg_data) {
			var _sprite = sprite_index;
			if (_sprite == -1) {
				draw_clear_alpha(blendColour, blendAlpha);
				return;
			}
			
			var _width = (stretch ? _room_width : sprite_get_width(_sprite));
			var _height = (stretch ? _room_height : sprite_get_height(_sprite));
			var _y1 = (vtiled ? (-_height + ((abs(_yoffs) mod _height) * sign(_yoffs))) : _yoffs);
			var _ny = (_room_height div _height) + 2;
			
			if (htiled) {
				var _x1 = -_width + ((abs(_xoffs) mod _width) * sign(_xoffs));
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
				_vtiled(_sprite, _xoffs, _y1, _width, _height, _ny);
			}
			else {
				draw_sprite_stretched_ext(_sprite, image_index, _xoffs, _yoffs, _width, _height, blendColour, blendAlpha);	
			}
		}
	};
};
