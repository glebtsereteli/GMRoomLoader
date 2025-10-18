/// feather ignore all

function __RoomLoaderDataLayerParent(_layerData) constructor {
	static __flag = undefined;
	static __tile = false;
	
	__owner = other;
	__layerData = _layerData;
	__fx = undefined;
	
	static __Init = function() {
		#region process effect
		
		static _texturedFilters = [
			"_filter_blocks",
			"_filter_boxes",
			"_filter_clouds",
			"_filter_distort",
			"_filter_dots",
			"_filter_fractal_noise",
			"_filter_heathaze",
			"_filter_large_blur",
			"_filter_linear_blur",
			"_filter_lut_colour",
			"_filter_mask",
			"_filter_old_film",
			"_filter_panorama",
			"_filter_parallax",
			"_filter_rgbnoise",
			"_filter_screenshake",
			"_filter_twist_blur",
			"_filter_underwater",
			"_filter_vignette",
			"_filter_whitenoise",
			"_filter_zoom_blur",
		];
		
		with (__layerData[$ "effectInfo"]) {
			var _fx = fx_create(name);
			fx_set_single_layer(_fx, singleLayerOnly);
			
			var _n = array_length(effectParams) - array_contains(_texturedFilters, name);
			var _i = 0; repeat (_n) {
				var _param = effectParams[_i];
				fx_set_parameter(_fx, _param.name, _param.values);
				_i++;
			}
			
			other.__fx = _fx;
		}
		
		#endregion
		
		__OnInit();
	};
	static __Load = function(_x, _y, _flags) {
		__ROOMLOADER_LAYER_START_LOAD;
		__OnLoad(_layer, _x, _y, _flags);
	};
	static __LoadTransformed = function(_x, _y, _flags, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin) {
		__ROOMLOADER_LAYER_START_LOAD;
		__OnLoadTransformed(_layer, _x, _y, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin, _flags);
	};
	static __Draw = function(_flags) {
		if (not __layerData.visible) return;
		if (not __ROOMLOADER_HAS_FLAG) return;
		if (__HasFailedFilters()) return;
		
		__OnDraw();
	};
	
	static __HasFailedFilters = function() {
		return RoomLoader.__LayerFailedFilters(__layerData.name);
	};
	
	static __OnInit = __RoomLoaderNoop;
	static __OnLoad = __RoomLoaderNoop;
	static __OnLoadTransformed = __RoomLoaderNoop;
	static __OnDraw = __RoomLoaderNoop;
}
