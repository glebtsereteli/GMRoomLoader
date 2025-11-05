// feather ignore all

function __RoomLoaderDataLayerParent(_layerData) constructor {
	static __flag = undefined;
	static __tile = false;
	
	__owner = other;
	__layerData = _layerData;
	__fx = undefined;
	
	static __Init = function() {
		#region process effect
		
		static _textureNames = {
			_filter_blocks: "_filter_blocks_texture",
			_filter_boxes: "_filter_boxes_palette",
			_filter_clouds: "_filter_clouds_texture",
			_filter_distort: "_filter_distort_texture",
			_filter_dots: "_filter_dots_palette",
			_filter_fractal_noise: "_filter_fractal_noise_texture",
			_filter_heathaze: "_filter_heathaze_noise_sprite",
			_filter_large_blur: "_filter_large_blur_noise",
			_filter_linear_blur: "_filter_linear_blur_noise",
			_filter_lut_colour: "_filter_lut_colour_texture",
			_filter_mask: "_filter_mask_sprite",
			_filter_old_film: "_filter_old_film_texture",
			_filter_panorama: "_filter_panorama_texture",
			_filter_parallax: "_filter_parallax_texture",
			_filter_rgbnoise: "_filter_rgbnoise_noise",
			_filter_screenshake: "_filter_screenshake_noise",
			_filter_stripes: "_filter_stripes_palette",
			_filter_twist_blur: "_filter_twist_blur_texture",
			_filter_underwater: "_filter_underwater_noise_sprite",
			_filter_vignette: "_filter_vignette_texture",
			_filter_whitenoise: "_filter_whitenoise_noise",
			_filter_zoom_blur: "_filter_zoom_blur_noise",
		};
		
		with (__layerData[$ "effectInfo"]) {
			var _fx = fx_create(name);
			fx_set_single_layer(_fx, singleLayerOnly);
			
			var _nParams = array_length(effectParams);
			if (struct_exists(_textureNames, name)) {
				var _lastParam = array_last(effectParams);
				var _myTextureName = _lastParam.values[0];
				if (_myTextureName != _textureNames[$ name]) {
					fx_set_parameter(_fx, _lastParam.name, asset_get_index(_myTextureName));
				}
				_nParams--;
			}
			var _i = 0; repeat (_nParams) {
				var _param = effectParams[_i];
				var _single = (array_length(_param.values) == 1);
				fx_set_parameter(_fx, _param.name, _single ? _param.values[0] : _param.values);
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
