/// @feather ignore all

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
					__Load(_layer, _x, _y);
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
	
	roomId = _data.name;
	x = _data.x;
	y = _data.y;
	sprite = _data.sprite_index;
	frame = _data.image_index;
	xScale = _data.image_xscale;
	yScale = _data.image_yscale;
	angle = _data.image_angle;
	spd = _data.image_speed
	blend = _data.image_blend;
	alpha = _data.image_alpha;
	
	static __Load = function(_layer, _x1, _y1) {
		var _x = _x1 + x;
		var _y = _y1 + y;
		var _sprite = layer_sprite_create(_layer, _x, _y, sprite);
		layer_sprite_index(_sprite, frame);
		layer_sprite_xscale(_sprite, xScale);
		layer_sprite_yscale(_sprite, yScale);
		layer_sprite_angle(_sprite, angle);
		layer_sprite_speed(_sprite, spd);
		layer_sprite_blend(_sprite, blend);
		layer_sprite_alpha(_sprite, alpha);
			
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__sprites.__Add(_sprite, roomId);
		}
	};
	static __Draw = function() {
		draw_sprite_ext(sprite, frame, x, y, xScale, yScale, angle, blend, alpha);
	};
}
function __RoomLoaderDataLayerAssetSequence(_data) constructor {
	static __flag = ROOMLOADER_FLAG.SEQUENCES;
	
	x = _data.x;
	y = _data.y;
	id = _data.seq_id;
	roomId = _data.name;
	headPos = _data.head_position;
	xScale = _data.image_xscale;
	yScale = _data.image_yscale;
	angle = _data.image_angle;
	speedScale = _data.image_speed;
	
	static __Load = function(_layer, _x1, _y1) {
		var _x = _x1 + x;
		var _y = _y1 + y;
		var _sequence = layer_sequence_create(_layer, _x, _y, id);
		layer_sequence_headpos(_sequence, headPos);
		layer_sequence_xscale(_sequence, xScale);
		layer_sequence_yscale(_sequence, yScale);
		layer_sequence_angle(_sequence, angle);
		layer_sequence_speedscale(_sequence, speedScale);
		
		if (ROOMLOADER_SEQUENCES_PAUSE) {
			layer_sequence_pause(_sequence);
		}
		
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__sequences.__Add(_sequence, roomId);
		}
	}
	static __Draw = __RoomLoaderNoop;
}
function __RoomLoaderDataLayerAssetText(_data) constructor {
	static __flag = ROOMLOADER_FLAG.TEXTS;
	
	x = _data.x;
	y = _data.y;
	roomId = _data.name;
	text = _data.text;
	font = _data.font_index;
	xScale = _data.xscale;
	yScale = _data.yscale;
	angle = _data.angle;
	hAlign = _data.h_align;
	vAlign = _data.v_align;
	charSpacing = _data.char_spacing;
	lineSpacing = _data.line_spacing;
	frameWidth = _data.frame_width;
	frameHeight = _data.frame_height;
	wrap = _data.wrap;
	xOrigin = _data.xorigin;
	yOrigin = _data.yorigin;
	blend = _data.blend;
	alpha = _data.alpha;
	
	static __Load = function(_layer, _x1, _y1) {
		var _x = _x1 + x;
		var _y = _y1 + y;
		var _text = layer_text_create(_layer, _x, _y, font, text);
		layer_text_xscale(_text, xScale);
		layer_text_yscale(_text, yScale);
		layer_text_angle(_text, angle);
		layer_text_halign(_text, hAlign);
		layer_text_valign(_text, vAlign);
		layer_text_charspacing(_text, charSpacing);
		layer_text_linespacing(_text, lineSpacing);
		layer_text_framew(_text, frameWidth);
		layer_text_frameh(_text, frameHeight);
		layer_text_wrap(_text, wrap);
		layer_text_xorigin(_text, xOrigin);
		layer_text_yorigin(_text, yOrigin);
		layer_text_blend(_text, blend);
		layer_text_alpha(_text, alpha);
			
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__texts.__Add(_text, roomId);
		}
	}
	static __Draw = function() {
		var _font = draw_get_font();
		var _halign = draw_get_halign();
		var _valign = draw_get_valign();
		var _color = draw_get_color();
		var _alpha = draw_get_alpha();
			
		draw_set_font(font);
		draw_set_halign(hAlign);
		draw_set_valign(vAlign);
		draw_set_color(blend);
		draw_set_alpha(alpha);
			
		draw_text_transformed(x, y, text, xScale, yScale, angle);
			
		draw_set_font(_font);
		draw_set_color(_color);
		draw_set_alpha(_alpha);
		draw_set_halign(_halign);
		draw_set_halign(_valign);
	};
}
