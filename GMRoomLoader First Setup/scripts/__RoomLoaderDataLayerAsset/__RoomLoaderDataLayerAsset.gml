/// feather ignore all

function __RoomLoaderDataLayerAsset(_layerData, _data) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.SPRITES | ROOMLOADER_FLAG.SEQUENCES | ROOMLOADER_FLAG.TEXTS;
	
	static __Draw = function(_flags) {
		if (not __layerData.visible) return;
		if (__HasFailedFilters()) return;
		
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__ROOMLOADER_HAS_FLAG) {
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
	static __OnLoad = function(_layer, _x, _y, _flags) {
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__ROOMLOADER_HAS_FLAG) {
					__Load(_layer, _x + __x, _y + __y);
				}
			}
			_i++;
		}
	};
	static __OnLoadTransformed = function(_layer, _x1, _y1, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin, _flags) {
		var _i = 0; repeat (array_length(__data)) {
			with (__data[_i]) {
				if (__ROOMLOADER_HAS_FLAG) {
					var _xScaled = __x * _xScale;
					var _yScaled = __y * _yScale;
					var _x = _x1 + (_xScaled * _cos) + (_yScaled * _sin);
					var _y = _y1 + (-_xScaled * _sin) + (_yScaled * _cos);
					__LoadTransformed(_layer, _x, _y, _xScale, _yScale, _angle);
				}
			}
			_i++;
		}
	};
	
	// custom
	__data = _data;
}
function __RoomLoaderDataLayerAssetSprite(_data) constructor {
	static __flag = ROOMLOADER_FLAG.SPRITES;
	
	__roomId = _data.name;
	__x = _data.x;
	__y = _data.y;
	__sprite = _data.sprite_index;
	__frame = _data.image_index;
	__xScale = _data.image_xscale;
	__yScale = _data.image_yscale;
	__angle = _data.image_angle;
	__spd = _data.image_speed
	__blend = _data.image_blend;
	__alpha = _data.image_alpha;
	
	static __Load = function(_layer, _x, _y) {
		__ROOMLOADER_SPRITE_LOAD;
		layer_sprite_xscale(_sprite, __xScale);
		layer_sprite_yscale(_sprite, __yScale);
		layer_sprite_angle(_sprite, __angle);
	};
	static __LoadTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle) {
		__ROOMLOADER_SPRITE_LOAD;
		layer_sprite_xscale(_sprite, __xScale * _xScale);
		layer_sprite_yscale(_sprite, __yScale * _yScale);
		layer_sprite_angle(_sprite, __angle + _angle);
	};
	static __Draw = function() {
		draw_sprite_ext(__sprite, __frame, __x, __y, __xScale, __yScale, __angle, __blend, __alpha);
	};
}
function __RoomLoaderDataLayerAssetSequence(_data) constructor {
	static __flag = ROOMLOADER_FLAG.SEQUENCES;
	
	__x = _data.x;
	__y = _data.y;
	__id = _data.seq_id;
	__roomId = _data.name;
	__headPos = _data.head_position;
	__xScale = _data.image_xscale;
	__yScale = _data.image_yscale;
	__angle = _data.image_angle;
	__speedScale = _data.image_speed;
	
	static __Load = function(_layer, _x, _y) {
		__ROOMLOADER_SEQUENCE_LOAD;
		layer_sequence_xscale(_sequence, __xScale);
		layer_sequence_yscale(_sequence, __yScale);
		layer_sequence_angle(_sequence, __angle);
	}
	static __LoadTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle) {
		__ROOMLOADER_SEQUENCE_LOAD;
		layer_sequence_xscale(_sequence, __xScale * _xScale);
		layer_sequence_yscale(_sequence, __yScale * _yScale);
		layer_sequence_angle(_sequence, __angle + _angle);
	}
	static __Draw = __RoomLoaderNoop;
}
function __RoomLoaderDataLayerAssetText(_data) constructor {
	static __flag = ROOMLOADER_FLAG.TEXTS;
	
	__x = _data.x;
	__y = _data.y;
	__roomId = _data.name;
	__text = _data.text;
	__font = _data.font_index;
	__xScale = _data.xscale;
	__yScale = _data.yscale;
	__angle = _data.angle;
	__hAlign = _data.h_align;
	__vAlign = _data.v_align;
	__charSpacing = _data.char_spacing;
	__lineSpacing = _data.line_spacing;
	__frameWidth = _data.frame_width;
	__frameHeight = _data.frame_height;
	__wrap = _data.wrap;
	__xOrigin = _data.xorigin;
	__yOrigin = _data.yorigin;
	__blend = _data.blend;
	__alpha = _data.alpha;
	
	static __Load = function(_layer, _x, _y) {
		__ROOMLOADER_TEXT_LOAD;
		layer_text_xscale(_text, __xScale);
		layer_text_yscale(_text, __yScale);
		layer_text_angle(_text, __angle);
	}
	static __LoadTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle) {
		__ROOMLOADER_TEXT_LOAD;
		layer_text_xscale(_text, __xScale * _xScale);
		layer_text_yscale(_text, __yScale * _yScale);
		layer_text_angle(_text, __angle + _angle);
	}
	static __Draw = function() {
		var _font = draw_get_font();
		var _halign = draw_get_halign();
		var _valign = draw_get_valign();
		var _color = draw_get_color();
		var _alpha = draw_get_alpha();
			
		draw_set_font(__font);
		draw_set_halign(__hAlign);
		draw_set_valign(__vAlign);
		draw_set_color(__blend);
		draw_set_alpha(__alpha);
			
		draw_text_transformed(__x, __y, __text, __xScale, __yScale, __angle);
			
		draw_set_font(_font);
		draw_set_color(_color);
		draw_set_alpha(_alpha);
		draw_set_halign(_halign);
		draw_set_halign(_valign);
	};
}
