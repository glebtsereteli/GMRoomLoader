/// @feather ignore all

function __RoomLoaderData(_room) constructor {
	__raw = room_get_info(_room, false, true, true, true, true);
	__packed = [];
	__instance_lookup = undefined;
	
	static __init = function() {
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
		
		// Generate instance lookup:
		var _instances_data = __raw.instances;
		var _instances_data_n = array_length(_instances_data);
		
		__instance_lookup = array_create(_instances_data_n);
		var _i = 0; repeat (_instances_data_n) {
			var _inst_data = _instances_data[_i];
			_inst_data.object_index = asset_get_index(_inst_data.object_index);
			if (_inst_data.pre_creation_code == -1) _inst_data.pre_creation_code = __roomloader_noop;
			if (_inst_data.creation_code == -1) _inst_data.creation_code = __roomloader_noop;
			__instance_lookup[_inst_data.id - 100001] = _inst_data;
			_i++;
		}
		
		// Collect data:
		var _layers_data = __raw.layers;
		var _i = 0; repeat (array_length(_layers_data)) {
			var _layer_data = _layers_data[_i];
			var _elements_data = _layer_data.elements;
			if (_elements_data != 0) {
				var _data_constructor = _get_data_constructor(_elements_data[0].type);
				if (_data_constructor != undefined) {
					_layer_data.name = ROOMLOADER_LAYER_PREFIX + _layer_data.name;
					struct_remove(_layer_data, "elements");
					
					var _data = new _data_constructor(_layer_data, _elements_data);
					array_push(__packed, _data);
				}
			}
			_i++;
		}
	};
	static __load = function(_x, _y, _origin, _flags) {
		_x = __roomloader_get_offset_x(_x, __raw.width, _origin);
		_y = __roomloader_get_offset_y(_y, __raw.height, _origin);
		
		var _pool = [];
		var _i = 0; repeat (array_length(__packed)) {
			var _data = __packed[_i].__load(_x, _y, _flags);
			if (_data != undefined) {
				array_push(_pool, _data);
			}
			_i++;
		}
		
		return new RoomLoaderReturnData(_pool);
	};
	
	__init();
};
function __RoomLoaderDataLayerParent(_layer_data) constructor {
	__owner = other;
	__layer_data = _layer_data;
	
	static __load = function(_xoffs, _yoffs, _flags) {
		if (not __roomloader_check_flags(_flags)) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		return __on_load(_layer, _xoffs, _yoffs, _flags);
	};
	static __on_load = __roomloader_noop;
}
function __RoomLoaderDataLayerInstance(_layer_data, _instances_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __ReturnData = function(_layer) constructor {
		__layer = _layer;
		__cleaned_up = false;
		
		static __get_element = __roomloader_noop;
		static __cleanup = function() {
			if (__cleaned_up) return;
			
			__cleaned_up = true;
			layer_destroy_instances(__layer);
			layer_destroy(__layer);
		};
	};
	
	__flag = ROOMLOADER_FLAG.INSTANCES;
	__instances_data = array_map(_instances_data, __map_data);
	
	static __map_data = function(_inst_data) {
		var _index = _inst_data.inst_id - 100001;
		return __owner.__instance_lookup[_index];
	};
	static __on_load = function(_layer, _xoffs, _yoffs, _flags) {
		var _instances = __roomloader_create_instances(_xoffs, _yoffs, __instances_data, instance_create_layer, _layer);
		return new __ReturnData(_layer, _instances);
	};
}
function __RoomLoaderDataLayerAsset(_layer_data, _data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __DataSprite = function(_data) constructor {
		static __ReturnData = function(_sprite, _name) constructor {
			__sprite = _sprite;
			__name = _name;
			
			static __get_element = function(_name) {
				return ((_name == __name) ? __sprite : undefined);
			};
			static __cleanup = function() {
				layer_sprite_destroy(__sprite);
			};
		};
		
		__data = _data;
		__flag = ROOMLOADER_FLAG.SPRITES;
		
		static __load = function(_layer, _xoffs, _yoffs, _flags) {
			if (not __roomloader_check_flags(_flags)) return undefined;
			
			var _x = __data.x + _xoffs;
			var _y = __data.y + _yoffs;
			var _sprite = layer_sprite_create(_layer, _x, _y, __data.sprite_index);
			layer_sprite_index(_sprite, __data.image_index);
			layer_sprite_xscale(_sprite, __data.image_xscale);
			layer_sprite_yscale(_sprite, __data.image_yscale);
			layer_sprite_angle(_sprite, __data.image_angle);
			layer_sprite_speed(_sprite, __data.image_speed);
			layer_sprite_blend(_sprite, __data.image_blend);
			layer_sprite_alpha(_sprite, __data.image_alpha);
			
			return new __ReturnData(_sprite, __data.name);
		};
	};
	static __DataParticleSystem = function(_data) constructor {
		static __ReturnData = function(_particle_system, _name) constructor {
			__particle_system = _particle_system;
			__name = _name;
			
			static __get_element = function(_name) {
				return ((_name == __name) ? __particle_system : undefined);
			};
			static __cleanup = function() {
				part_system_destroy(__particle_system);
			};
		};
		
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
			
			return new __ReturnData(_particle_system, __data.name);
		}
	};
	static __DataSequence = function(_data) constructor {
		static __ReturnData = function(_sequence, _name) constructor {
			__sequence = _sequence;
			__name = _name;
			
			static __get_element = function(_name) {
				return ((_name == __name) ? __sequence : undefined);
			};
			static __cleanup = function() {
				layer_sequence_destroy(__sequence);
			};
		};
		
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
			if (ROOMLOADER_PAUSE_SEQUENCES) layer_sequence_pause(_sequence);
			
			return new __ReturnData(_sequence, __data.name);
		}
	};
	static __ReturnData = function(_layer, _elements) constructor {
		__layer = _layer;
		__elements = _elements;
		__cleaned_up = false;
		__n = array_length(_elements);
		
		static __get_element = function(_name) {
			var _i = 0; repeat (array_length(__elements)) {
				var _element = __elements[_i].__get_element(_name);
				if (_element != undefined) {
					return _element;
				}
				_i++;
			}
			return undefined;
		};
		static __cleanup = function() {
			if (__cleaned_up) return;
			
			__cleaned_up = true;
			var _i = 0; repeat (__n) {
				__elements[_i].__cleanup();
				_i++;
			}
			layer_destroy(__layer);
		};
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
			__data[_i] = new _constructor(_data);
			_i++;
		}
	};
	static __load = function(_xoffs, _yoffs, _flags) {
		var _layer = __roomloader_create_layer(__layer_data);
		var _elements = [];
		
		var _i = 0; repeat (array_length(__data)) {
			var _data = __data[_i].__load(_layer, _xoffs, _yoffs, _flags);
			if (_data != undefined) {
				array_push(_elements, _data);
			}
			_i++;
		}
		
		return new __ReturnData(_layer, _elements);
	};
	
	__init();
};
function __RoomLoaderDataLayerTilemap(_layer_data, _elements_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __ReturnData = function(_layer, _tilemap, _name) constructor {
		__layer = _layer;
		__tilemap = _tilemap;
		__name = _name;
		__cleaned_up = false;
		
		static __get_element = function(_name) {
			return ((_name == __name) ? __tilemap : undefined);
		};
		static __cleanup = function() {
			if (__cleaned_up) return;
			
			__cleaned_up = true;
			layer_tilemap_destroy(__tilemap);
			layer_destroy(__layer);
		};
	};
	
	__flag = ROOMLOADER_FLAG.TILEMAPS;
	__layer_data = _layer_data;
	__tilemap_data = array_first(_elements_data);
	__tiles_data = [];
	__tileset = undefined;
	__width = undefined;
	__height = undefined;
	
	static __init = function() {
		__tileset = __tilemap_data.background_index;
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
	static __on_load = function(_layer, _xoffs, _yoffs, _flags) {
		var _tilemap = layer_tilemap_create(_layer, _xoffs, _yoffs, __tileset, __width, __height);
		
		var _i = 0; repeat (array_length(__tiles_data)) {
			var _tile_data = __tiles_data[_i];
			tilemap_set(_tilemap, _tile_data.data, _tile_data.x, _tile_data.y);
			_i++;
		}
		
		return new __ReturnData(_layer, _tilemap, __tilemap_data.name);
	};
	
	__init();
};
function __RoomLoaderDataLayerBackground(_layer_data, _bg_data) : __RoomLoaderDataLayerParent(_layer_data) constructor {
	static __ReturnData = function(_layer, _bg, _name) constructor {
		__layer = _layer;
		__bg = _bg;
		__name = _name;
		__cleaned_up = false;
		
		static __get_element = function(_name) {
			return ((_name == __name) ? __bg : undefined);
		};
		static __cleanup = function() {
			if (__cleaned_up) return;
			
			__cleaned_up = true;
			layer_background_destroy(__bg);
			layer_destroy(__layer);
		};
	};
	
	__flag = ROOMLOADER_FLAG.BACKGROUNDS;
	__bg_data = _bg_data[0];
	
	static __on_load = function(_layer, _xoffs, _yoffs, _flags) {
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
		
		return new __ReturnData(_layer, _bg, __bg_data.name);
	};
};

function __roomloader_noop() {}
function __roomloader_create_layer(_data) {
	var _layer = layer_create(_data.depth, _data.name);
	layer_set_visible(_layer, _data.visible);
	layer_x(_layer, _data.xoffset);
	layer_y(_layer, _data.yoffset);
	layer_hspeed(_layer, _data.hspeed);
	layer_vspeed(_layer, _data.vspeed);
	
	return _layer;
}
function __roomloader_create_instances(_xoffs, _yoffs, _data, _create_func, _create_data) {
	var _n = array_length(_data);
	var _instances = array_create(_n);
	
	var _i = 0; repeat (array_length(_data)) {
		var _inst_data = _data[_i];
		var _x = _inst_data.x + _xoffs;
		var _y = _inst_data.y + _yoffs;
		var _inst = _create_func(_x, _y, _create_data, _inst_data.object_index);
		with (_inst) {
			image_xscale = _inst_data.xscale;
			image_yscale = _inst_data.yscale;
			image_angle = _inst_data.angle;
			image_blend = _inst_data.colour;
			image_index = _inst_data.image_index;
			image_speed = _inst_data.image_speed;
			_inst_data.pre_creation_code();
			_inst_data.creation_code();
		}
		_instances[_i] = _inst;
		_i++;
	}
	
	return _instances;
}
function __roomloader_load_instances(_room, _x, _y, _data, _origin, _create_func, _create_data) {
	var _xoffs = __roomloader_get_offset_x(_x, _data.__raw.width, _origin);
	var _yoffs = __roomloader_get_offset_y(_y, _data.__raw.height, _origin);
	
	return __roomloader_create_instances(_xoffs, _yoffs, _data.__instance_lookup, _create_func, _create_data);
}
function __roomloader_get_offset_x(_x, _width, _origin) {
	static _offsets = [
		+0.0, -0.5, -1.0,
		+0.0, -0.5, -1.0,
		-0.0, -0.5, -1.0,
	];
	return (_x + (_width * _offsets[_origin]));
}
function __roomloader_get_offset_y(_y, _height, _origin) {
	static _offsets = [
		+0.0, +0.0, +0.0,
		-0.5, -0.5, -0.5,
		-1.0, -1.0, -1.0,
	];
	return (_y + (_height * _offsets[_origin]));
}
function __roomloader_check_flags(_flags) {
	return ((_flags & __flag) == __flag);
}
