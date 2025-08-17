/// @feather ignore all

function __RoomLoaderDataLayerAsset(_layerData, _data) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __Load = function(_xOffset, _yOffset, _flags) {
		if (RoomLoader.__LayerFailedFilters(__layerData.name)) return;
		
		var _layer = __RoomLoaderGetLayer(__layerData);
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__RoomLoaderCheckFlag(_flags)) {
					__Load(_layer, _xOffset, _yOffset);
				}
			}
			_i++;
		}
		
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__layers.__Add(_layer, __layerData.name);
		}
	};
	static __Draw = function(_flags) {
		if (not __layerData.visible) return;
		if (__HasFailedFilters()) return;
		
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__RoomLoaderCheckFlag(_flags)) {
					__Draw();
				}
			}
			_i++;
		}
	};

	static __OnInit = function() {
		var _i = 0; repeat (array_length(__data)) {
			var _data = __data[_i];
			var _constructor = undefined;
			switch (_data.type) {
				case layerelementtype_sprite: _constructor = __RoomLoaderDataLayerAssetSprite; break;
				case layerelementtype_sequence: _constructor = __RoomLoaderDataLayerAssetSequence; break;
				case layerelementtype_text: _constructor = __RoomLoaderDataLayerAssetText; break;
			}
			if (_constructor != undefined) {
				__data[_i] = new _constructor(_data);
			}
			else {
				array_delete(__data, _i--, 1);
			}
			_i++;
		}
	};
	
	// custom
	__data = _data;
}
function __RoomLoaderDataLayerAssetSprite(_data) constructor {
	static __flag = ROOMLOADER_FLAG.SPRITES;
	
	__data = _data;
	
	static __Load = function(_layer, _xOffset, _yOffset) {
		with (__data) {
			var _x = x + _xOffset;
			var _y = y + _yOffset;
			var _sprite = layer_sprite_create(_layer, _x, _y, sprite_index);
			layer_sprite_index(_sprite, image_index);
			layer_sprite_xscale(_sprite, image_xscale);
			layer_sprite_yscale(_sprite, image_yscale);
			layer_sprite_angle(_sprite, image_angle);
			layer_sprite_speed(_sprite, image_speed);
			layer_sprite_blend(_sprite, image_blend);
			layer_sprite_alpha(_sprite, image_alpha);
			
			if (ROOMLOADER_USE_RETURN_DATA) {
				RoomLoader.__returnData.__sprites.__Add(_sprite, name);
			}
		}
	};
	static __Draw = function() {
		with (__data) {
			draw_sprite_ext(
				sprite_index, image_index,
				x, y,
				image_xscale, 1, image_angle,
				image_blend, image_alpha
			);
		}
	};
}
function __RoomLoaderDataLayerAssetSequence(_data) constructor {
	static __flag = ROOMLOADER_FLAG.SEQUENCES;
	
	__data = _data;
		
	static __Load = function(_layer, _xOffset, _yOffset) {
		var _x = __data.x + _xOffset;
		var _y = __data.y + _yOffset;
		var _sequence = layer_sequence_create(_layer, _x, _y, __data.seq_id);
		layer_sequence_headpos(_sequence, __data.head_position);
		layer_sequence_xscale(_sequence, __data.image_xscale);
		layer_sequence_yscale(_sequence, __data.image_yscale);
		layer_sequence_angle(_sequence, __data.image_angle);
		layer_sequence_speedscale(_sequence, __data.image_speed);
		
		if (ROOMLOADER_SEQUENCES_PAUSE) {
			layer_sequence_pause(_sequence);
		}
		
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__sequences.__Add(_sequence, __data.name);
		}
	}
	static __Draw = __RoomLoaderNoop;
}
function __RoomLoaderDataLayerAssetText(_data) constructor {
	static __flag = ROOMLOADER_FLAG.TEXTS;
	
	__data = _data;
	
	static __Load = function(_layer, _xOffset, _yOffset) {
		with (__data) {
			var _x = x + _xOffset;
			var _y = y + _yOffset;
			var _text = layer_text_create(_layer, _x, _y, font_index, text);
			layer_text_xscale(_text, xscale);
			layer_text_yscale(_text, yscale);
			layer_text_angle(_text, angle);
			layer_text_halign(_text, h_align);
			layer_text_valign(_text, v_align);
			layer_text_charspacing(_text, char_spacing);
			layer_text_linespacing(_text, line_spacing);
			layer_text_framew(_text, frame_width);
			layer_text_frameh(_text, frame_height);
			layer_text_wrap(_text, wrap);
			layer_text_xorigin(_text, xorigin);
			layer_text_yorigin(_text, yorigin);
			layer_text_blend(_text, blend);
			layer_text_alpha(_text, alpha);
			
			if (ROOMLOADER_USE_RETURN_DATA) {
				RoomLoader.__returnData.__texts.__Add(_text, name);
			}
		}
	}
	static __Draw = function() {
		with (__data) {
			var _font = draw_get_font();
			var _halign = draw_get_halign();
			var _valign = draw_get_valign();
			var _color = draw_get_color();
			var _alpha = draw_get_alpha();
			
			draw_set_font(font_index);
			draw_set_halign(h_align);
			draw_set_valign(v_align);
			draw_set_color(blend);
			draw_set_alpha(alpha);
			
			draw_text_transformed(x, y, text, xscale, yscale, angle);
			
			draw_set_font(_font);
			draw_set_color(_color);
			draw_set_alpha(_alpha);
			draw_set_halign(_halign);
			draw_set_halign(_valign);
		}
	};
}
