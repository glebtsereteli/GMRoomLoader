/// @feather ignore all

function __RoomLoaderData(_room) constructor {
	__room = _room;
	__data = undefined;
	__instance_lookup = undefined;
	__width = undefined;
	__height = undefined;
	__creation_code = undefined;
	
	static __init = function() {
		static _map_instance_data = function(_data) {
			_data.object_index = asset_get_index(_data.object_index);
			_data.pre_creation_code = __roomloader_script_nullish(_data.pre_creation_code);
			_data.creation_code = __roomloader_script_nullish(_data.creation_code);
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
		__creation_code = __roomloader_script_nullish(_raw_data.creationCode);
		
		// Generate instance lookup:
		var _instances_data = _raw_data.instances;
		if (_instances_data != 0) {
			__instance_lookup = array_map(_instances_data, _map_instance_data);	
		}
		
		// Collect data:
		var _layers_data = _raw_data.layers;
		var _i = 0; repeat (array_length(_layers_data)) {
			var _layer_data = _layers_data[_i];
			var _elements_data = _layer_data.elements;
			if (_elements_data != 0) {
				var _data_constructor = _get_data_constructor(_elements_data[0].type);
				if (_data_constructor != undefined) {
					_layer_data.name = ROOMLOADER_LAYER_PREFIX + _layer_data.name;
					var _data = new _data_constructor(_layer_data, _elements_data);
					array_push(__data, _data);
				}
			}
			_i++;
		}
	};
	static __load = function(_x, _y, _origin, _flags) {
		_x = __roomloader_get_offset_x(_x, __width, _origin);
		_y = __roomloader_get_offset_y(_y, __height, _origin);
		
		var _pool = [];
		var _i = 0; repeat (array_length(__data)) {
			var _data = __data[_i].__load(_x, _y, _flags);
			if (_data != undefined) {
				array_push(_pool, _data);
			}
			_i++;
		}
		
		if (ROOMLOADER_RUN_CREATION_CODE) __creation_code(self);
		
		return new RoomLoaderReturnData(_pool);
	};
	
	__init();
};

function __RoomLoaderDataLayer(_layer_data) constructor {
	__owner = other;
	__layer_data = _layer_data;
	
	static __load = function(_xoffs, _yoffs, _flags) {
		if (not __roomloader_check_flags(_flags)) return undefined;
		if (not RoomLoader.__filter.__check(__layer_data.name)) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		return __on_load(_layer, _xoffs, _yoffs, _flags);
	};
	static __on_load = __roomloader_noop;
}
function __RoomLoaderDataLayerInstance(_layer_data, _instances_data) : __RoomLoaderDataLayer(_layer_data) constructor {
	__flag = ROOMLOADER_FLAG.INSTANCES;
	__instances_data = array_map(_instances_data, __map_data);
	
	static __map_data = function(_inst_data) {
		var _index = _inst_data.inst_id - 100001;
		return __owner.__instance_lookup[_index];
	};
	static __on_load = function(_layer, _xoffs, _yoffs, _flags) {
		var _instances = __roomloader_create_instances(_xoffs, _yoffs, __instances_data, instance_create_layer, _layer);
		return new __RoomLoaderDataReturnLayer(_layer, _layer, undefined, layer_destroy_instances);
	};
}
function __RoomLoaderDataLayerAsset(_layer_data, _data) : __RoomLoaderDataLayer(_layer_data) constructor {
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
			layer_sprite_yscale(_sprite, __data.image_yscale);
			layer_sprite_angle(_sprite, __data.image_angle);
			layer_sprite_speed(_sprite, __data.image_speed);
			layer_sprite_blend(_sprite, __data.image_blend);
			layer_sprite_alpha(_sprite, __data.image_alpha);
			
			return new __RoomLoaderDataReturn(_sprite, __data.name, layer_sprite_destroy);
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
			
			repeat (ROOMLOADER_PARTICLE_STEPS) part_system_update(_particle_system);
			
			return new __RoomLoaderDataReturn(_particle_system, __data.name, part_system_destroy);
		}
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
			
			if (ROOMLOADER_PAUSE_SEQUENCES) layer_sequence_pause(_sequence);
			
			return new __RoomLoaderDataReturn(_sequence, __data.name, layer_sequence_destroy);
		}
	};
	static __ReturnData = function(_layer, _elements) constructor {
		__layer = _layer;
		__elements = _elements;
		__n = array_length(_elements);
		
		static __get_element = function(_name) {
			var _i = 0; repeat (__n) {
				var _element = __elements[_i].__get_element(_name);
				if (_element != undefined) {
					return _element;
				}
				_i++;
			}
			return undefined;
		};
		static __cleanup = function() {
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
		if (not RoomLoader.__filter.__check(__layer_data.name)) return undefined;
		
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
function __RoomLoaderDataLayerTilemap(_layer_data, _elements_data) : __RoomLoaderDataLayer(_layer_data) constructor {
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
		
		return new __RoomLoaderDataReturnLayer(_layer, _tilemap, __tilemap_data.name, layer_tilemap_destroy);
	};
	
	__init();
};
function __RoomLoaderDataLayerBackground(_layer_data, _bg_data) : __RoomLoaderDataLayer(_layer_data) constructor {
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
		
		return new __RoomLoaderDataReturnLayer(_layer, _bg, __bg_data.name, layer_background_destroy);
	};
};

function __RoomLoaderDataReturn(_element, _name, _on_cleanup = __roomloader_noop) constructor {
	__element = _element;
	__name = _name;
	__on_cleanup = _on_cleanup;
	
	static __get_element = function(_name) {
		return ((_name == __name) ? __element : undefined);
	};
	static __cleanup = function() {
		__on_cleanup(__element);
	};
}
function __RoomLoaderDataReturnLayer(_layer, _element, _name, _on_cleanup) : __RoomLoaderDataReturn(_element, _name, _on_cleanup) constructor {
	__layer = _layer;
	
	static __cleanup = function() {
		__on_cleanup(__element);
		layer_destroy(__layer);
	};
}
