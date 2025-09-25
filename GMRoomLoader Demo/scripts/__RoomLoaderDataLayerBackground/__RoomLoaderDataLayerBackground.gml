/// feather ignore all

function __RoomLoaderDataLayerBackground(_layerData, _bgData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.BACKGROUNDS;
	
	static __OnLoad = function(_layer, _x, _y) {
		with (__bgData) {
			__ROOMLOADER_BG_LOAD;
			layer_background_xscale(_bg, xscale);
			layer_background_yscale(_bg, yscale);
		}
	};
	static __OnLoadTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle) {
		if (_angle != 0) return;
		
		with (__bgData) {
			__ROOMLOADER_BG_LOAD;
			layer_background_xscale(_bg, xscale * _xScale);
			layer_background_yscale(_bg, yscale * _yScale);
		}
	};
	static __OnDraw = function() {
		static _fill = function(_width, _height) {
			var _prev_color = draw_get_color();
			var _prev_alpha = draw_get_alpha();
			draw_set_color(blendColour);
			draw_set_alpha(blendAlpha);
			draw_rectangle(0, 0, _width, _height, false);
			draw_set_color(_prev_color);
			draw_set_alpha(_prev_alpha);
		};
		static _vtiled = function(_sprite, _x1, _y1, _width, _height, _n) {
			for (var _i = 0; _i < _n; _i++) {
				var _y = _y1 + (_i * _height);
				draw_sprite_stretched_ext(_sprite, image_index, _x1, _y, _width, _height, blendColour, blendAlpha);
			}
		};
		
		var _roomWidth = __owner.__width;
		var _roomHeight = __owner.__height;
		var _xOffset = __layerData.xoffset;
		var _yOffset = __layerData.yoffset;
		
		with (__bgData) {
			var _sprite = sprite_index;
			if (_sprite == -1) return _fill(_roomWidth, _roomHeight);
			
			var _width = (stretch ? _roomWidth : sprite_get_width(_sprite));
			var _height = (stretch ? _roomHeight : sprite_get_height(_sprite));
			var _y1 = (vtiled ? (-_height + ((abs(_yOffset) mod _height) * sign(_yOffset))) : _yOffset);
			var _ny = (_roomHeight div _height) + 2;
			
			if (htiled) {
				var _x1 = -_width + ((abs(_xOffset) mod _width) * sign(_xOffset));
				var _nx = (_roomWidth div _width) + 2;
				for (var _i = 0; _i < _nx; _i++) {
					var _x = _x1 + (_i * _width);
					draw_sprite_stretched_ext(_sprite, image_index, _x, _y1, _width, _height, blendColour, blendAlpha);
					if (vtiled) {
						_vtiled(_sprite, _x, _y1 + _height, _width, _height, _ny - 1);
					}
				}
			}
			else if (vtiled) {
				_vtiled(_sprite, _xOffset, _y1, _width, _height, _ny);
			}
			else {
				draw_sprite_stretched_ext(_sprite, image_index, _xOffset, _yOffset, _width, _height, blendColour, blendAlpha);	
			}
		}
	};

	// custom
	__bgData = _bgData[0];
}
