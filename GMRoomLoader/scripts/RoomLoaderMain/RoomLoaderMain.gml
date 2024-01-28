/// @feather ignore all

function RoomLoader() constructor {
	// Private:
	static __data = {
		__pool: {},
		
		__add: function(_room) {
			__pool[$ room_get_name(_room)] = new __RoomLoaderData(_room);	
		},
		__get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	
	// Public:
	static init = function() {
		var _i = 0; repeat (argument_count) {
			__data.__add(argument[_i]);
			_i++;
		}
		return self;
	};
	static init_array = function(_rooms) {
		array_foreach(_rooms, __data.__add);
		return self;
	};
	static init_prefix = function(_prefix) {
		static _all_rooms = asset_get_ids(asset_room);
		var _i = 0; repeat (array_length(_all_rooms)) {
			var _room = _all_rooms[_i];
			if (string_pos(_prefix, room_get_name(_room)) > 0) {
				__data.__add(_room);
			}
			_i++;
		}
		return self;
	};
	
	static load = function(_room, _x, _y, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		var _data = __data.__get(_room);
		if (_data == undefined) return undefined;
		
		return _data.__load(_x, _y, _origin, _flags);
	};
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __data.__get(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_layer, _layer);
	};
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = __data.__get(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	static get_data_raw = function(_room) {
		with (__data.get(_room)) return __raw;
		return undefined;
	};
	static get_data_packed = function(_room) {
		with (__get.get(_room)) return __packed;
		return undefined;
	};
}
function RoomLoaderReturnData() constructor {
	// Private:
	__pool = [];
	
	static __add = function(_data) {
		array_push(__pool, _data);
	};
	
	// Public:
	static get_element_id = function(_name) {
		// ...
	};
	static cleanup = function() {
		var _i = 0; repeat (array_length(__pool)) {
			__pool[_i].__cleanup();
			_i++;
		}
	};
};

RoomLoader();
