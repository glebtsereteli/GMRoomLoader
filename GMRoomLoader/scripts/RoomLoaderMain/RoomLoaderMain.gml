/// @feather ignore all

function RoomLoader() constructor {
	// Private:
	__data_handler = new __RoomLoaderDataHandler();
	
	// Public:
	static init = function() {
		var _i = 0; repeat (argument_count) {
			var _room = argument[_i];
			__data_handler.__add(_room, new __RoomLoaderData(_room));
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
	
	static load = function(_room, _x, _y, _origin = ROOM_LOADER_DEFAULT_ORIGIN, _flags = ROOM_LOADER_DEFAULT_FLAGS) {
		var _data = __data_handler.__get(_room);
		if (_data == undefined) return undefined;
		
		return _data.__load(_x, _y, _origin, _flags);
	};
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOM_LOADER_ORIGIN.TOP_LEFT) {
		var _data = __data_handler.__get(_room);
		if (_data == undefined) return undefined;
		
		var _xoffs = __room_loader_get_offset_x(_x, _data.__raw.width, _origin);
		var _yoffs = __room_loader_get_offset_y(_y, _data.__raw.height, _origin);
		
		return __room_loader_spawn_instances(_xoffs, _yoffs, _data.__instance_pool, instance_create_depth, _depth);
	};
	
	static get_info = function(_room) {
		with (__data_handler.__get(_room)) {
			return __raw;
		}
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
