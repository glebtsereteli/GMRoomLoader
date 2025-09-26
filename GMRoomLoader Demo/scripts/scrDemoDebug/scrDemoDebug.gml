
/// @func DebugResources()
/// @desc Displays the data fetched from debug_event("ResourceCounts") in a neat Resource Counts debug overlay view.
/// Call anywhere in the project.
function DebugResources() {
	static __ = new (function() constructor {
		var _refresh = function() {
			if (not is_debug_overlay_open()) return;
			struct_foreach(debug_event("ResourceCounts", true), function(_key, _value) {
				self[$ _key] = _value;
			});
		};
		_refresh();
		call_later(1, time_source_units_frames, _refresh, true);
		
		dbg_view("Resource Counts", false, 16, 35, 320, 500);
		dbg_text_separator("Resources");
		dbg_watch(ref_create(self, "listCount"), "DS Lists");
		dbg_watch(ref_create(self, "mapCount"), "DS Maps");
		dbg_watch(ref_create(self, "queueCount"), "DS Queues");
		dbg_watch(ref_create(self, "gridCount"), "DS Grids");
		dbg_watch(ref_create(self, "priorityCount"), "DS Priority Queues");
		dbg_watch(ref_create(self, "stackCount"), "DS Stacks");
		dbg_watch(ref_create(self, "mpGridCount"), "DS Grids");
		dbg_watch(ref_create(self, "bufferCount"), "Buffers");
		dbg_watch(ref_create(self, "vertexBufferCount"), "Vertex Buffers");
		dbg_watch(ref_create(self, "surfaceCount"), "Surfaces");
		dbg_watch(ref_create(self, "audioEmitterCount"), "Audio Emitters");
		dbg_watch(ref_create(self, "partSystemCount"), "Particle Systems");
		dbg_watch(ref_create(self, "partEmitterCount"), "Particle Emitters");
		dbg_watch(ref_create(self, "partTypeCount"), "Particle Types");
		dbg_watch(ref_create(self, "timeSourceCount"), "Time Sources");
		dbg_text_separator("Assets");
		dbg_watch(ref_create(self, "spriteCount"), "Sprites");		
		dbg_watch(ref_create(self, "pathCount"), "Paths");
		dbg_watch(ref_create(self, "fontCount"), "Fonts");
		dbg_watch(ref_create(self, "roomCount"), "Rooms");
		dbg_watch(ref_create(self, "timelineCount"), "Timelines");
		dbg_text_separator("Instances");					
		dbg_watch(ref_create(self, "instanceCount"), "Instances");
	})();
}

/// @func DebugInstances()
/// @desc Displays the overall and per object amounts of instances in a neat Instances debug overlay __view.
/// Call anywhere in the project.
function DebugInstances() {
	static __ = new (function() constructor {
		__objects = array_map(asset_get_ids(asset_object), function(_obj) {
			return {
				__ref: _obj,
				__name: object_get_name(_obj),
				__n: undefined,
			};
		});
		__nobj = array_length(__objects);
		__ninst = undefined;
		__view = undefined;
		__section = undefined;
		
		__refresh = function() {
			__ninst = instance_count;
			array_foreach(__objects, function(_obj) {
				_obj.__n = instance_number(_obj.__ref);
			});
			array_sort(__objects, function(_a, _b) {
				return sign(_b.__n - _a.__n);
			});
			if (__view != undefined) {
				dbg_view_delete(__view);
				dbg_section_delete(__section);
			}
			__view = dbg_view("Instances", false, 16, 35, 400, 500);
			__section = dbg_section($"Total: {instance_count}");
			for (var _i = 0; _i < __nobj; _i++) {
				var _obj = __objects[_i];
				if (_obj.__n == 0) break;
				dbg_watch(ref_create(_obj, "__n"), _obj.__name);
			}
		};
		__refresh();
		call_later(1, time_source_units_frames, function() {
			if (not is_debug_overlay_open()) return;
			if (instance_count == __ninst) return;
			__refresh();
		}, true);
	})();
}
