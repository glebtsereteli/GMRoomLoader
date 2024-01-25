/// @feather ignore all

function RoomLoader() constructor {
	static __RoomData = function(_room) constructor {
		static __DataInstance = function(_layer_data, _instances_data) constructor {
			static __ReturnData = function(_layer, _instances) constructor {
				__layer = _layer;
				__instances = _instances;
				__cleaned_up = false;
				
				static __cleanup = function() {
					if (__cleaned_up) return;
					
					__cleaned_up = true;
					layer_destroy_instances(__layer);
					layer_destroy(__layer);
				};
			};
			
			__owner = other;
			__flag = ROOM_LOADER_FLAG.INSTANCES;
			__layer_data = _layer_data;
			__n = array_length(_instances_data);
			
			static __init = function(_elements_data) {
				__layer_data.instances = array_create(__n);
				
				var _i = 0; repeat (__n) {
					var _index = _elements_data[_i].inst_id - 100001;
					__layer_data.instances[_i] = __owner.__instance_lookup[_index];
					_i++;
				}
				
				return self;
			};
			static __load = function(_xoffs, _yoffs, _flags) {
				if (not __room_loader_check_flags(_flags)) return undefined;
				
				var _instances_data = __layer_data.instances;
				var _layer = layer_create(__layer_data.depth, __layer_data.name);
				var _instances = array_create(__n);
				
				var _i = 0; repeat (__n) {
					var _inst_data = _instances_data[_i];
					var _x = _inst_data.x + _xoffs;
					var _y = _inst_data.y + _yoffs;
					var _inst = instance_create_layer(_x, _y, _layer, _inst_data.object_index);
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
				
				return new __ReturnData(_layer, _instances);
			};
			
			__init(_instances_data);
		};
		static __DataAsset = function(_layer_data, _data) constructor {
			static __DataSprite = function(_data) constructor {
				static __ReturnData = function(_sprite) constructor {
					__sprite = _sprite;
					
					static __cleanup = function() {
						layer_sprite_destroy(__sprite);
					};
				};
				
				__data = _data;
				__flag = ROOM_LOADER_FLAG.SPRITES;
				
				static __load = function(_layer, _xoffs, _yoffs, _flags) {
					if (not __room_loader_check_flags(_flags)) return undefined;
					
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
					
					return new __ReturnData(_sprite);
				};
			};
			static __DataParticleSystem = function(_data) constructor {
				static __ReturnData = function(_particle_system) constructor {
					__particle_system = _particle_system;
					
					static __cleanup = function() {
						//part_system_destroy(__particle_system);
					};
				};
				
				__data = _data;
				__flag = ROOM_LOADER_FLAG.PARTICLE_SYSTEMS;
				
				static __load = function(_layer, _xoffs, _yoffs, _flags) {
					if (not __room_loader_check_flags(_flags)) return undefined;
					// ...
					return new __ReturnData();
				}
			};
			static __DataSequence = function(_data) constructor {
				static __ReturnData = function(_sequence) constructor {
					__sequence = _sequence;
					
					static __cleanup = function() {
						
					};
				};
				
				__data = _data;
				__flag = ROOM_LOADER_FLAG.SEQUENCES;
				
				static __load = function(_layer, _xoffs, _yoffs, _flags) {
					if (not __room_loader_check_flags(_flags)) return undefined;
					// ...
					return new __ReturnData();
				}
			};
			static __ReturnData = function(_layer, _elements) constructor {
				__layer = _layer;
				__elements = _elements;
				__cleaned_up = false;
				__n = array_length(_elements);
				
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
			
			__layer_data = _layer_data;
			__data = _data;
			__n = undefined;
			
			static __init = function() {
				// [@TEMP] Ignore Sequences and Particle Systems:
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
				__n = array_length(__data);
			};
			static __load = function(_xoffs, _yoffs, _flags) {
				var _layer = layer_create(__layer_data.depth, __layer_data.name);
				var _elements = [];
				
				var _i = 0; repeat (__n) {
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
		static __DataTilemap = function(_layer_data, _elements_data) constructor {
			static __ReturnData = function(_layer, _tilemap) constructor {
				__layer = _layer;
				__tilemap = _tilemap;
				__cleaned_up = false;
				
				static __cleanup = function() {
					if (__cleaned_up) return;
					
					__cleaned_up = true;
					layer_tilemap_destroy(__tilemap);
					layer_destroy(__layer);
				};
			};
			
			__flag = ROOM_LOADER_FLAG.TILEMAPS;
			__layer_data = _layer_data;
			__tileset = undefined;
			__width = undefined;
			__height = undefined;
			__tiles_data = [];
			
			static __init = function(_tilemap_data) {
				__tileset = _tilemap_data.background_index;
				__width = _tilemap_data.width;
				__height = _tilemap_data.height;
			
				var _tiles_data = _tilemap_data.tiles;
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
			static __load = function(_xoffs, _yoffs, _flags) {
				if (not __room_loader_check_flags(_flags)) return undefined;
				
				var _layer = layer_create(__layer_data.depth, __layer_data.name);
				var _tilemap = layer_tilemap_create(_layer, _xoffs, _yoffs, __tileset, __width, __height);
			
				var _i = 0; repeat (array_length(__tiles_data)) {
					var _tile_data = __tiles_data[_i];
					tilemap_set(_tilemap, _tile_data.data, _tile_data.x, _tile_data.y);
					_i++;
				}
			
				return new __ReturnData(_layer, _tilemap);
			};
			
			__init(array_first(_elements_data));
		};
		static __ReturnData = function() constructor {
			__pool = [];
			
			static __add = function(_data) {
				array_push(__pool, _data);
			};
			
			static cleanup = function() {
				var _i = 0; repeat (array_length(__pool)) {
					__pool[_i].__cleanup();
					_i++;
				}
			};
		};
		
		__raw = room_get_info(_room, false, true, true, true, true);
		__packed = [];
		__instance_lookup = undefined;
		
		static __init = function() {
			static _get_data_constructor = function(_type) {
				switch (_type) {
					case layerelementtype_instance: return __DataInstance;
					case layerelementtype_sprite:
					case layerelementtype_sequence:
					case layerelementtype_particlesystem: return __DataAsset;
					case layerelementtype_tilemap: return __DataTilemap;
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
				if (_inst_data.pre_creation_code == -1) _inst_data.pre_creation_code = __room_loader_noop;
				if (_inst_data.creation_code == -1) _inst_data.creation_code = __room_loader_noop;
				__instance_lookup[_inst_data.id - 100001] = _inst_data;
				_i++;
			}
			
			// Collect data:
			var _layers_data = __raw.layers;
			var _i = 0; repeat (array_length(_layers_data)) {
				var _layer_data = _layers_data[_i];
				var _elements_data = _layer_data.elements;
				if (_elements_data == 0) continue;
				
				var _data_constructor = _get_data_constructor(_elements_data[0].type);
				if (_data_constructor == undefined) continue;
				
				var _layer = {
					name: ROOM_LOADER_LAYER_PREFIX + _layer_data.name,
					depth: _layer_data.depth,
				};
				var _data = new _data_constructor(_layer, _elements_data);
				array_push(__packed, _data);
				_i++;
			}	
		};
		static __load = function(_x, _y, _origin, _flags) {
			_x = __room_loader_get_offset_x(_x, __raw.width, _origin);
			_y = __room_loader_get_offset_y(_y, __raw.height, _origin);
			
			// Load, collect and return data:
			var _return_data = new __ReturnData();
			var _i = 0; repeat (array_length(__packed)) {
				var _data = __packed[_i].__load(_x, _y, _flags);
				if (_data != undefined) {
					_return_data.__add(_data);
				}
				_i++;
			}
			return _return_data;
		};
		
		__init();
	};
	__data = {};
	
	static __get_data = function(_room) {
		return __data[$ room_get_name(_room)];
	};
	
	static init = function() {
		var _i = 0; repeat (argument_count) {
			var _room = argument[_i];
			__data[$ room_get_name(_room)] = new __RoomData(_room);	
			_i++;
		}
		return self;
	};
	static init_array = function(_rooms) {
		static _init = function(_room) { init(_room); };
		array_foreach(_rooms, _init);
		return self;
	};
	static init_prefix = function(_prefix) {
		static _all_rooms = asset_get_ids(asset_room);
		static _filter_data = { prefix: undefined };
		static _filter = method(_filter_data, function(_room) {
			var _name = room_get_name(_room);
			return (string_pos(prefix, _name) > 0);
		});
		
		_filter_data.prefix = _prefix;
		var _rooms = array_filter(_all_rooms, _filter);
		init_array(_rooms);
		return self;
	};
	
	static load = function(_room, _x, _y, _origin = ROOM_LOADER_ORIGIN.TOP_LEFT, _flags = ROOM_LOADER_FLAG.ALL) {
		var _data = __get_data(_room);
		if (_data == undefined) return undefined;
		
		return _data.__load(_x, _y, _origin, _flags);
	};
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOM_LOADER_ORIGIN.TOP_LEFT) {
		var _data = __get_data(_room);
		if (_data == undefined) return undefined;
		
		_x = __room_loader_get_offset_x(_x, _data.__raw.width, _origin);
		_y = __room_loader_get_offset_y(_y, _data.__raw.height, _origin);
		
		var _instances_data = _data.__instance_lookup;
		var _n = array_length(_instances_data);
		var _instances = array_create(_n);
		
		var _i = 0; repeat (_n) {
			var _inst_data = _instances_data[_i];
			var _inst_x = _x + _inst_data.x;
			var _inst_y = _y + _inst_data.y;
			var _inst = instance_create_depth(_inst_x, _inst_y, _depth, _inst_data.object_index);
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
	};
	
	static get_raw_data = function(_room) {
		with (__get_data(_room)) {
			return __raw;
		}
		return undefined;
	};
}
