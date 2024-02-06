/// @feather ignore all

function __RoomLoaderFilter(_idle_return) constructor {
	__idle_return = _idle_return;
	__layers = [];
	
	static __check_idle = function() {
		return __idle_return;
	};
	static __check_active = function(_name) {
		return array_contains(__layers, _name);
	};
	static __check = __check_idle;
	static __add = function(_layer) {
		array_push(__layers, _layer);
		__check = __check_active;
	};
	static __remove = function(_layer) {
		var _index = array_get_index(__layers, _layer);
		if (_index != undefined) {
			array_delete(__layers, _index, 1);
		}
	};
	static __reset = function() {
		__layers = [];
		__check = __check_idle;
	};
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
			_data.pre_creation_code = __roomloader_process_script(_data.pre_creation_code);
			_data.creation_code = __roomloader_process_script(_data.creation_code);
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
					_layer_data.name = ROOMLOADER_LAYER_PREFIX + _layer_data.name;
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
		
		RoomLoader.__return_data.__instances = array_create(array_length(__instances_data), noone);
		
		var _i = 0; repeat (array_length(__data)) {
			__data[_i].__load(_x, _y, _flags);
			_i++;
		}
		
		return RoomLoader.__return_data;
	};
	
	__init();
};
function __RoomLoaderDataLayer(_layer_data) constructor {
	__owner = other;
	__layer_data = _layer_data;
	
	static __load = function(_xoffs, _yoffs, _flags) {
		if (not __roomloader_check_flags(_flags)) return undefined;
		if (RoomLoader.__layer_failed_filters(__layer_data.name)) return undefined;
		
		var _layer = __roomloader_create_layer(__layer_data);
		array_push(RoomLoader.__return_data.__layers, _layer);
		
		__on_load(_layer, _xoffs, _yoffs, _flags);
	};
	static __on_load = __roomloader_noop;
}
function __RoomLoaderDataLayerInstance(_layer_data, _instances_data) : __RoomLoaderDataLayer(_layer_data) constructor {
	__flag = ROOMLOADER_FLAG.INSTANCES;
	__instances_data = array_map(_instances_data, __map_data);
	
	static __map_data = function(_inst_data) {
		return __owner.__instances_init_lookup[$ _inst_data.inst_id];
	};
	static __on_load = function(_layer, _xoffs, _yoffs, _flags) {
		var _instances = RoomLoader.__return_data.__instances;
		var _index = RoomLoader.__return_data.__instance_index;
		
		var _i = 0; repeat (array_length(__instances_data)) {
			var _inst_data = __instances_data[_i];
			var _x = _inst_data.x + _xoffs;
			var _y = _inst_data.y + _yoffs;
			var _inst = instance_create_layer(_x, _y, _layer, _inst_data.object_index);
			__ROOMLOADER_SETUP_INSTANCE;
			_instances[_index] = _inst;
			_i++;
			_index++;
		}
		RoomLoader.__return_data.__instance_index = _index;
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
			
			array_push(RoomLoader.__return_data.__sprites, {
				id: _sprite,
				name: __data.name,
			});
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
			
			array_push(RoomLoader.__return_data.__particle_systems, {
				id: _particle_system,
				name: __data.name,
			});
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
			
			array_push(RoomLoader.__return_data.__sequences, {
				id: _sequence,
				name: __data.name,
			});
		}
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
		array_push(RoomLoader.__return_data.__layers, _layer);
		
		var _i = 0; repeat (array_length(__data)) {
			__data[_i].__load(_layer, _xoffs, _yoffs, _flags);
			_i++;
		}
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
		
		array_push(RoomLoader.__return_data.__tilemaps, {
			id: _tilemap,
			name: __tilemap_data.name,
		});
	};
	
	__init();
};
function __RoomLoaderDataLayerBackground(_layer_data, _bg_data) : __RoomLoaderDataLayer(_layer_data) constructor {
	__flag = ROOMLOADER_FLAG.BACKGROUNDS;
	__bg_data = _bg_data[0];
	
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
		
		array_push(RoomLoader.__return_data.__backgrounds, {
			id: _bg,
			name: __bg_data.name,
		});
	};
};
