
function RoomLoader() constructor {
	__data = {
		raw: undefined,
		ready: undefined,
	};
	__instance_lookup = undefined;
	
	static init = function(_room) {
		static _get_inst_data = function(_instances_data, _id) {
			for (var _i = 0; _i < array_length(_instances_data); _i++) {
				var _inst_data = _instances_data[_i];
				if (_inst_data.id == _id) {
					return _inst_data;
				}
			}
			return undefined;
		};
		
		__data.raw = room_get_info(_room, false, true, true, true, false);
		__data.ready = {
			instance: [],
		};
		__instance_lookup = {};
		
		var _layers_data = __data.raw.layers;
		var _instances_data = __data.raw.instances;
		
		for (var _i = 0; _i < array_length(_instances_data); _i++) {
			var _inst_data = _instances_data[_i];
			__instance_lookup[$ _inst_data.id] = _inst_data;
		}
		
		for (var _i = 0; _i < array_length(_layers_data); _i++) {
			var _layer_data = _layers_data[_i];
			var _elements_data = _layer_data.elements;
			if (_elements_data == 0) continue;
			
			switch (_elements_data[0].type) {
				case layerelementtype_instance: {
					var _elements_data_n = array_length(_elements_data);
					
					var _layer = {
						name: __ROOM_LOADER_LAYER_PREFIX + _layer_data.name,
						depth: _layer_data.depth,
						instances: array_create(_elements_data_n),
					};
					
					for (var _j = 0; _j < _elements_data_n; _j++) {
						var _inst = __instance_lookup[$ _elements_data[_j].inst_id];
						_inst.object_index = asset_get_index(_inst.object_index);
						if (_inst.pre_creation_code == -1) _inst.pre_creation_code = __room_loader_noop;
						if (_inst.creation_code == -1) _inst.creation_code = __room_loader_noop;
						_layer.instances[_j] = _inst;
					}
					
					array_push(__data.ready.instance, _layer);
					
					break;
				}
			}
		}
	};
	static load = function(_xoffs = 0, _yoffs = 0) {
		var _layers = __data.ready.instance;
		var _i = 0; repeat (array_length(_layers)) {
			var _layer = _layers[_i];
			var _depth = _layer.depth;
			var _instances = _layer.instances;
			
			var _j = 0; repeat (array_length(_instances)) {
				var _inst_data = _layer.instances[_j];
				var _x = _inst_data.x + _xoffs;
				var _y = _inst_data.y + _yoffs;
				var _inst = instance_create_depth(_x, _y, _depth, _inst_data.object_index);
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
				_j++;
			}
			_i++;
		}
	};
}

function __room_load_tilemap(_layer_data, _tilemap_data, _x, _y, _depth, _tileset) {
	var _layer = layer_create(_depth, _layer_data.name);
	var _tilemap = layer_tilemap_create(_layer, _x, _y, _tileset, _tilemap_data.width, _tilemap_data.height);
	
	var _tiles_data = _tilemap_data.tiles;
	for (var _i = 0; _i < array_length(_tiles_data); _i++) {
		var _tile_data = _tiles_data[_i];
		if (_tile_data == 0) continue;
		
		var _cell_x = (_i mod _tilemap_data.width);
		var _cell_y = (_i div _tilemap_data.width);
		tilemap_set(_tilemap, _tile_data, _cell_x, _cell_y);
	}
	
	return {
		layer: _layer,
		tilemap: _tilemap,
	};
}

function room_load_tilemap(_room, _layer_name, _x = 0, _y = 0, _depth = undefined, _tileset = undefined) {
	static _get_layer_data = function(_data, _layer_name) {
		var _layers = _data.layers;
		for (var _i = 0; _i < array_length(_layers); _i++) {
			var _layer = _layers[_i];
			if (_layer.name != _layer_name) continue;
			if (_layer.elements[0].type != layerelementtype_tilemap) continue;
			
			return _layer;
		}
		return undefined;
	};
	
	var _room_data = room_get_info(_room, false, false, true, true, true);
	var _layer_data = _get_layer_data(_room_data, _layer_name);
	if (_layer_data == undefined) return undefined;
	
	var _tilemap_data = _layer_data.elements[0];
	_depth ??= _layer_data.depth;
	_tileset ??= _tilemap_data.background_index;
	
	return __room_load_tilemap(_layer_data, _tilemap_data, _x, _y, _depth, _tileset);
}
function room_load_tilemaps(_room, _x = 0, _y = 0) {
	var _room_data = room_get_info(_room, false, false, true, true, true);
	var _layers_data = _room_data.layers;
	var _return_data = [];
	
	for (var _i = 0; _i < array_length(_layers_data); _i++) {
		var _layer_data = _layers_data[_i];
		var _tilemap_data = _layer_data.elements[0];
		if (_tilemap_data.type != layerelementtype_tilemap) continue;
		
		var _data = __room_load_tilemap(_layer_data, _tilemap_data, _x, _y, _layer_data.depth, _tilemap_data.background_index);
		array_push(_return_data, _data);
	}
	return _return_data;
}

function __room_loader_noop() {}
