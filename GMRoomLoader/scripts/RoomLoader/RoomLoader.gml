/// @feather ignore all

function RoomLoader() constructor {
	static __RoomData = function(_room) constructor {
		static __DataInstances = function(_layer_data, _instances_data) constructor {
			static __ReturnData = function(_layer, _instances) constructor {
				__layer = _layer;
				__instances = _instances;
			
				static __cleanup = function() {
					if (!layer_exists(__layer)) return;
				
					layer_destroy_instances(__layer);
					layer_destroy(__layer);
				};
			};
			
			__owner = other;
			__flag = ROOM_LOADER_FLAG.INSTANCES;
			__layer_data = _layer_data;
			__total_amount = array_length(_instances_data);
			
			static __init = function(_elements_data) {
				static _noop = function() {};
				
				__layer_data.instances = array_create(__total_amount);
				
				var _i = 0; repeat (__total_amount) {
					var _inst = __owner.__instance_lookup[_elements_data[_i].inst_id - 100001];
					_inst.object_index = asset_get_index(_inst.object_index);
					if (_inst.pre_creation_code == -1) _inst.pre_creation_code = _noop;
					if (_inst.creation_code == -1) _inst.creation_code = _noop;
					__layer_data.instances[_i] = _inst;
					_i++;
				}
				
				return self;
			};
			static __load = function(_xoffs, _yoffs) {
				var _instances_data = __layer_data.instances;
				var _layer = layer_create(__layer_data.depth, __layer_data.name);
				var _instances = array_create(__total_amount);
				
				var _i = 0; repeat (__total_amount) {
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
						script_execute(_inst_data.pre_creation_code);
						script_execute(_inst_data.creation_code);
					}
					_instances[_i] = _inst;
					_i++;
				}
				
				return new __ReturnData(_layer, _instances);
			};
			
			__init(_instances_data);
		};
		static __DataSprites = function(_layer_data, _sprites_data) constructor {
			static __ReturnData = function(_layer, _sprites) constructor {
				__layer = _layer;
				__sprites = _sprites;
				
				static __cleanup = function() {
					if (!layer_exists(__layer)) return;
					
					var _i = 0; repeat (array_length(__sprites)) {
						layer_sprite_destroy(__sprites[_i]);
						_i++;
					}
					layer_destroy(__layer);
				};
			};
			
			__flag = ROOM_LOADER_FLAG.SPRITES;
			__layer_data = _layer_data;
			__total_amount = array_length(_sprites_data);
			__sprites_data = _sprites_data;
			
			static __load = function(_xoffs, _yoffs) {
				var _layer = layer_create(__layer_data.depth, __layer_data.name);
				var _sprites = array_create(__total_amount);
			
				var _i = 0; repeat (__total_amount) {
					var _sprite_data = __sprites_data[_i];
					var _x = _sprite_data.x + _xoffs;
					var _y = _sprite_data.y + _yoffs;
					var _sprite = layer_sprite_create(_layer, _x, _y, _sprite_data.sprite_index);
					layer_sprite_index(_sprite, _sprite_data.image_index);
					layer_sprite_xscale(_sprite, _sprite_data.image_xscale);
					layer_sprite_yscale(_sprite, _sprite_data.image_yscale);
					layer_sprite_angle(_sprite, _sprite_data.image_angle);
					layer_sprite_speed(_sprite, _sprite_data.image_speed);
					layer_sprite_blend(_sprite, _sprite_data.image_blend);
					layer_sprite_alpha(_sprite, _sprite_data.image_alpha);
					_sprites[_i] = _sprite;
					_i++;
				}
			
				return new __ReturnData(_layer, _sprites);
			};
		};
		static __DataTilemap = function(_layer_data, _elements_data) constructor {
			static __ReturnData = function(_layer, _tilemap) constructor {
				__layer = _layer;
				__tilemap = _tilemap;
				
				static __cleanup = function() {
					if (!layer_exists(__layer)) return;
					
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
			static __load = function(_xoffs, _yoffs) {
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
					case layerelementtype_instance: return __DataInstances;
					case layerelementtype_sprite: return __DataSprites;
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
					name: __ROOM_LOADER_LAYER_PREFIX + _layer_data.name,
					depth: _layer_data.depth,
				};
				var _data = new _data_constructor(_layer, _elements_data);
				array_push(__packed, _data);
				_i++;
			}	
		};
		static __load = function(_x, _y, _origin, _flags) {
			static _origin_offsets = [
				[+0.0, +0.0], [-0.5, +0.0], [-1.0, +0.0],
				[+0.0, -0.5], [-0.5, -0.5], [-1.0, -0.5],
				[-0.0, -1.0], [-0.5, -1.0], [-1.0, -1.0],
			];
			
			// Adjust position for origin:
			var _origin_offset = _origin_offsets[_origin];
			_x += (_origin_offset[0] * __raw.width);
			_y += (_origin_offset[1] * __raw.height);
			
			// Load, collect and return data:
			var _return_data = new __ReturnData();
			var _i = 0; repeat (array_length(__packed)) {
				with (__packed[_i]) {
					if ((_flags & __flag) == __flag) {
						var _data = __load(_x, _y);
						_return_data.__add(_data);
					}
				}
				_i++;
			}
			return _return_data;
		};
		
		__init();
	};
	static __data = {};
	
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
		static _filter_data = { prefix: undefined };
		static _filter = method(_filter_data, function(_room) {
			var _name = room_get_name(_room);
			return (string_pos(prefix, _name) > 0);
		});
		
		_filter_data.prefix = _prefix;
		var _rooms = array_filter(asset_get_ids(asset_room), _filter);
		init_array(_rooms);
		return self;
	};
	
	static load = function(_room, _x, _y, _origin = ROOM_LOADER_ORIGIN.TOP_LEFT, _flags = ROOM_LOADER_FLAG.ALL) {
		var _data = __data[$ room_get_name(_room)];
		if (_data == undefined) return undefined;
		
		return _data.__load(_x, _y, _origin, _flags);
	};
	
	static get_raw_data = function(_room) {
		with (__data[$ room_get_name(_room)]) {
			return __raw;	
		}
		return undefined;
	};
}
RoomLoader();
