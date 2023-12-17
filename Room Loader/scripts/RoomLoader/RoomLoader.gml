
function room_load_instances(_room, _xstart, _ystart, _depth) {
	/// @func room_load_instances()
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
