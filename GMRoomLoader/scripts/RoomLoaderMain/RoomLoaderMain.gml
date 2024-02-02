/// @feather ignore all

function RoomLoader() constructor {
	#region private
	
	static __data = {
		__pool: {},
		__prefix: undefined,
		
		__add: function(_room) {
			__pool[$ room_get_name(_room)] = new __RoomLoaderData(_room);	
		},
		__remove: function(_room) {
			struct_remove(__pool, room_get_name(_room));
		},
		__get: function(_room) {
			return __pool[$ room_get_name(_room)];
		},
	};
	static __blacklist = {
		__layers: [],
		
		__check: __roomloader_noop,
		__check_layer: function(_name) {
			return array_contains(__layers, _name);
		},
		__add: function(_layer) {
			array_push(__layers, _layer);
			__check = __check_layer;
		},
		__reset: function() {
			__layers = [];
			__check = __roomloader_noop;
		},
	};
	
	#endregion
	
	// Initialization:
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
		static _init = method(__data, function(_room) {
			if (not __roomloader_room_has_prefix(_room, __prefix)) return;
			__add(_room);
		});
		
		__data.__prefix = _prefix;
		array_foreach(_all_rooms, _init);
		return self;
	};
	
	// Loading:
	static load = function(_room, _x, _y, _origin = ROOMLOADER_DEFAULT_ORIGIN, _flags = ROOMLOADER_DEFAULT_FLAGS) {
		var _data = get_data(_room);
		if (_data == undefined) return undefined;
		
		return _data.__load(_x, _y, _origin, _flags);
	};
	static load_instances_layer = function(_room, _x, _y, _layer, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = get_data(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_layer, _layer);
	};
	static load_instances_depth = function(_room, _x, _y, _depth, _origin = ROOMLOADER_DEFAULT_ORIGIN) {
		var _data = get_data(_room);
		if (_data == undefined) return undefined;
		
		return __roomloader_load_instances(_room, _x, _y, _data, _origin, instance_create_depth, _depth);
	};
	
	// Blacklist:
	static layer_blacklist_set = function() {
		var _i = 0; repeat (argument_count) {
			__blacklist.__add(ROOMLOADER_LAYER_PREFIX + argument[_i]);
			_i++;
		}
		return self;
	};
	static layer_blacklist_set_array = function(_layers) {
		script_execute_ext(layer_blacklist_set, _layers);
		return self;
	};
	static layer_blacklist_reset = function() {
		__blacklist.__reset();
		return self;
	};
	
	// Removal:
	static remove = function() {
		var _i = 0; repeat (argument_count) {
			__data.__remove(argument[_i]);
			_i++;
		}
	};
	static remove_array = function(_rooms) {
		array_foreach(_rooms, __data.__remove);
	};
	static remove_prefix = function(_prefix) {
		static _remove = method(__data, function(_name, _data) {
			if (not __roomloader_room_has_prefix(_data.__room, __prefix)) return;
			struct_remove(__pool, _name);
		});
		
		__data.__prefix = _prefix;
		struct_foreach(__data.__pool, _remove);
	};
	static clear = function() {
		delete __data.__pool;
		__data.__pool = {};
	};
	
	// Getters:
	static get_data = function(_room) {
		return __data.__get(_room);
	};
}
function RoomLoaderReturnData(_pool) constructor {
	#region private
	
	__pool = _pool;
	__cleaned_up = false;
	
	#endregion
	
	static get_element = function(_name) {
		var _i = 0; repeat (array_length(__pool)) {
			var _element = __pool[_i].__get_element(_name);
			if (_element != undefined) {
				return _element;
			}
			_i++;
		}
		return undefined;
	};
	static cleanup = function() {
		if (__cleaned_up) return;
		
		__cleaned_up = true;
		var _i = 0; repeat (array_length(__pool)) {
			__pool[_i].__cleanup();
			_i++;
		}
	};
};

RoomLoader();
