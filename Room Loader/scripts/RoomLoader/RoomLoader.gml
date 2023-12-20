
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

function room_load_instances_quick(_room, _xstart, _ystart, _depth) {
	/// @func room_load_instances_quick()
	/// @param {Asset.GMRoom} room
	/// @param {Real} xstart
	/// @param {Real} ystart
	/// @param {Real} depth
	/// @returns {Array<Id.Instance>}
	
	var _instances = [];
	var _data = room_get_info(_room, false, true, false, false, false).instances;
	if (_data == 0) return _instances;
	
	var _n = array_length(_data);
	for (var _i = 0; _i < _n; _i++) {
		var _inst_data = _data[_i];
		var _x = _xstart + _inst_data.x;
		var _y = _ystart + _inst_data.y;
		var _obj = asset_get_index(_inst_data.object_index);
		
		var _inst = instance_create_depth(_x, _y, _depth, _obj);
		with (_inst) {
			image_xscale = _inst_data.xscale;
			image_yscale = _inst_data.yscale;
			image_angle = _inst_data.angle;
			image_blend = _inst_data.colour;
			image_index = _inst_data.image_index;
			image_speed = _inst_data.image_speed;
			if (_inst_data.pre_creation_code != -1) script_execute(_inst_data.pre_creation_code);
			if (_inst_data.creation_code != -1) script_execute(_inst_data.pre_creation_code);
		}
		_instances[_i] = _inst;
	}
	
	return _instances;
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
