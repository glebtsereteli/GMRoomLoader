/// @feather ignore all

function __RoomLoaderDataLayerTile(_layerData, _elementsData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.TILEMAPS;
	static __tile = true;
	
	static __OnInit = function() {
		__tileset = __tilemapData.tileset_index;
		__width = __tilemapData.width;
		__height = __tilemapData.height;
		
		var _tilesData = __tilemapData.tiles;
		var _n = array_length(_tilesData);
		
		__tiles = array_create(_n * __ROOMLOADER_TILE_STEP);
		var _count = 0;
		
		var _i = 0; repeat (_n) {
		    var _data = _tilesData[_i];
		    if (_data > 0) {
			    __tiles[_count++] = _i mod __width;
			    __tiles[_count++] = _i div __width;
				__tiles[_count++] = _data;
			}
			_i++;
		}
		
		array_resize(__tiles, _count);
		__n = _count / __ROOMLOADER_TILE_STEP;
		
		__owner.__tilemapsLut[$ __layerData.name] = self;
	};
	static __OnLoad = function(_layer, _xOffset, _yOffset) {
		var _tilemap = __CreateTilemap(_layer, _xOffset, _yOffset);
		__AddToPayload(_tilemap);
	};
	static __OnLoadTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin, _flags) {
		if ((_xScale == 0) or (_yScale == 0)) return;
		
		var _tilemap = __CreateTilemapTransformed(_layer, _x, _y, _xScale, _yScale, _angle, _xOrigin, _yOrigin);
		if (_tilemap != undefined) {
			__AddToPayload(_tilemap);
		}
	};
	static __OnDraw = function() { 
		var _layer = layer_create(0);
		var _tilemap = __CreateTilemap(_layer, 0, 0);
		draw_tilemap(_tilemap, 0, 0);
		layer_tilemap_destroy(_tilemap);
		layer_destroy(_layer);
	};
	
	// custom
	__tilemapData = _elementsData[0];
	__tiles = [];
	__n = undefined;
	__tileset = undefined;
	__width = undefined;
	__height = undefined;
	
	static __CreateTilemap = function(_layer, _x, _y, _tileset = __tileset) {
	    var _tilemap = layer_tilemap_create(_layer, _x, _y, _tileset, __width, __height);
		
	    var _data = __tiles;
		var _i = 0; repeat (__n) {
			tilemap_set(_tilemap, _data[_i + 2], _data[_i], _data[_i + 1]);
			_i += __ROOMLOADER_TILE_STEP;
		}
		
	    return _tilemap;
	};
	static __CreateTilemapTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle, _xOrigin, _yOrigin, _tileset = __tileset) {
		static _tilesetsInfo = ds_map_create();
		
		_angle = _angle - (floor(_angle / 360) * 360);
		
		if ((_angle mod 90) != 0) return undefined;
		
		var _transposed = (_angle mod 180) == 90;
	    var _w = (_transposed ? __height : __width);
	    var _h = (_transposed ? __width : __height);
			
		_xScale = sign(_xScale);
		var _mirror = (_xScale == -1);
		var _mirrorOffset = (_mirror ? __width  - 1 : 0);
		
		_yScale = sign(_yScale);
		var _flip = (_yScale == -1);
		var _flipOffset = (_flip ? __height - 1 : 0);
		
		var _info = _tilesetsInfo[? _tileset];
		if (_info == undefined) {
			_info = tileset_get_info(_tileset);
			_tilesetsInfo[? _tileset] = _info;
		}
		
		var _wPx = _w * _info.tile_width;
		var _hPx = _h * _info.tile_height;
		
		var _mat00 = 1, _mat01 = 0, _rotXOffset = 0;
		var _mat10 = 0, _mat11 = 1, _rotYOffset = 0;
		var _rotFlag = 0;
		
		switch (_angle) {
			case 00: {
				_x -= _wPx * (_xOrigin + (1 - 2 * _xOrigin) * _mirror);
				_y -= _hPx * (_yOrigin + (1 - 2 * _yOrigin) * _flip);
				
			    break;
			}
			case 90:  {
				_y -= _hPx * ((1 - _xOrigin) + (2 * _xOrigin - 1) * _mirror);
				_x -= _wPx * (_yOrigin + (1 - 2 * _yOrigin) * _flip);
				
				_mat00 = 0; _mat01 = 1; _rotXOffset = 0;
		        _mat10 = -1; _mat11 = 0; _rotYOffset = __width - 1;
				_rotFlag = tile_mirror | tile_flip | tile_rotate;
				
				break;
			}
			case 180: {
				_x -= _wPx * ((1 - _xOrigin) + (2 * _xOrigin - 1) * _mirror);
				_y -= _hPx * ((1 - _yOrigin) + (2 * _yOrigin - 1) * _flip);
				
				_mat00 = -1; _mat01 = 0; _rotXOffset = __width - 1;
		        _mat10 = 0; _mat11 = -1; _rotYOffset = __height - 1;
				_rotFlag = tile_mirror | tile_flip;
				
				break;
			}
			case 270: {
				_y -= _hPx * (_xOrigin + (1 - 2 * _xOrigin) * _mirror);
			    _x -= _wPx * ((1 - _yOrigin) + (2 * _yOrigin - 1) * _flip);
				
			    _mat00 = 0; _mat01 = -1; _rotXOffset = __height - 1;
			    _mat10 = 1; _mat11 = 0; _rotYOffset = 0;
			    _rotFlag = tile_rotate;
				
			    break;
			}
		}
		
		var _tilemap = layer_tilemap_create(_layer, _x, _y, _tileset, _w, _h);
		
	    var _i = 0; repeat (__n) {
	        var _t = __tiles[_i + 2];
			
			var _xStart = (__tiles[_i] * _xScale) + _mirrorOffset;
		    _t ^= _mirror * tile_mirror;
			
			var _yStart = (__tiles[_i + 1] * _yScale) + _flipOffset;
		    _t ^= _flip * tile_flip;
			
			var _rx = (_mat00 * _xStart) + (_mat01 * _yStart) + _rotXOffset;
		    var _ry = (_mat10 * _xStart) + (_mat11 * _yStart) + _rotYOffset;
			_t ^= _rotFlag;
			
	        tilemap_set(_tilemap, _t, _rx, _ry);
			
	        _i += __ROOMLOADER_TILE_STEP;
	    }
		
	    return _tilemap;
	};
	static __AddToPayload = function(_tilemap) {
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__tilemaps.__Add(_tilemap, __tilemapData.name);
		}
	};
}
