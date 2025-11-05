// feather ignore all

function __RoomLoaderDataLayerTile(_layerData, _elementsData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.TILEMAPS;
	static __tile = true;
	
	static __OnInit = function() {
		tileset = __tilemapData.tileset_index;
		width = __tilemapData.width;
		height = __tilemapData.height;
		
		var _tilesData = __tilemapData.tiles;
		var _n = array_length(_tilesData);
		
		tiles = array_create(_n * __ROOMLOADER_TILE_STEP);
		var _count = 0;
		
		var _i = 0; repeat (_n) {
		    var _data = _tilesData[_i];
		    if (_data > 0) {
			    tiles[_count++] = _i mod width;
			    tiles[_count++] = _i div width;
				tiles[_count++] = _data;
			}
			_i++;
		}
		
		array_resize(tiles, _count);
		__n = _count / __ROOMLOADER_TILE_STEP;
		
		__owner.__tilemapsLut[$ __layerData.name] = self;
	};
	static __OnLoad = function(_layer, _xOffset, _yOffset) {
		var _tilemap = __CreateTilemap(_layer, _xOffset, _yOffset);
		__ROOMLOADER_TILEMAP_ADD_TO_PAYLOAD;
	};
	static __OnLoadTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin, _flags) {
		if ((abs(_xScale) != 1) or (abs(_yScale) != 1)) return;
		
		var _tilemap = __CreateTilemapTransformed(_layer, _x, _y, _xScale, _yScale, _angle, _xOrigin, _yOrigin);
		__ROOMLOADER_TILEMAP_ADD_TO_PAYLOAD;
	};
	static __OnDraw = function() { 
		var _x = 0;
		var _y = 0;
		var _layer = layer_create(0);
		var _tileset = tileset;
		__ROOMLOADER_TILEMAP_CREATE_RAW;
		draw_tilemap(_tilemap, 0, 0);
		layer_tilemap_destroy(_tilemap);
		layer_destroy(_layer);
	};
	
	// custom
	__tilemapData = _elementsData[0];
	
	tileset = undefined;
	width = undefined;
	height = undefined;
	tiles = [];
	__n = undefined;
	
	static __CreateTilemap = function(_layer, _x, _y, _tileset = tileset) {
		if (not ROOMLOADER_MERGE_TILEMAPS) {
			__ROOMLOADER_TILEMAP_CREATE_RAW;
			return _tilemap;
		}
		
		var _hostTilemap = layer_tilemap_get_id(_layer);
		if ((_hostTilemap == -1) || (tilemap_get_tileset(_hostTilemap) != _tileset)) {
			//show_message("can't merge, create new");
			__ROOMLOADER_TILEMAP_CREATE_RAW;
			return _tilemap;
		}
		
		//show_message("merge");
		var _w = width;
		var _h = height;
		
		__ROOMLOADER_TILEMAP_PROCESS_MERGE;
		
		var _data = tiles;
		var _i = 0; repeat (__n) {
			tilemap_set(_hostTilemap, _data[_i + 2], _data[_i] + _newShiftI, _data[_i + 1] + _newShiftJ);
			_i += __ROOMLOADER_TILE_STEP;
		}
		
		return _hostTilemap;
	};
	static __CreateTilemapTransformed = function(_layer, _x, _y, _xScale, _yScale, _angle, _xOrigin, _yOrigin, _tileset = tileset) {
		static _tilesetsInfo = {};
		
		_angle = _angle - (floor(_angle / 360) * 360);
		
		if ((_angle mod 90) != 0) return undefined;
		
		var _transposed = (_angle mod 180) == 90;
	    var _w = (_transposed ? height : width);
	    var _h = (_transposed ? width : height);
			
		_xScale = sign(_xScale);
		var _mirror = (_xScale == -1);
		var _mirrorOffset = (_mirror ? width  - 1 : 0);
		
		_yScale = sign(_yScale);
		var _flip = (_yScale == -1);
		var _flipOffset = (_flip ? height - 1 : 0);
		
		var _info = _tilesetsInfo[$ _tileset];
		if (_info == undefined) {
			_info = tileset_get_info(_tileset);
			_tilesetsInfo[$ _tileset] = _info;
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
		        _mat10 = -1; _mat11 = 0; _rotYOffset = width - 1;
				_rotFlag = tile_mirror | tile_flip | tile_rotate;
				
				break;
			}
			case 180: {
				_x -= _wPx * ((1 - _xOrigin) + (2 * _xOrigin - 1) * _mirror);
				_y -= _hPx * ((1 - _yOrigin) + (2 * _yOrigin - 1) * _flip);
				
				_mat00 = -1; _mat01 = 0; _rotXOffset = width - 1;
		        _mat10 = 0; _mat11 = -1; _rotYOffset = height - 1;
				_rotFlag = tile_mirror | tile_flip;
				
				break;
			}
			case 270: {
				_y -= _hPx * (_xOrigin + (1 - 2 * _xOrigin) * _mirror);
			    _x -= _wPx * ((1 - _yOrigin) + (2 * _yOrigin - 1) * _flip);
				
			    _mat00 = 0; _mat01 = -1; _rotXOffset = height - 1;
			    _mat10 = 1; _mat11 = 0; _rotYOffset = 0;
			    _rotFlag = tile_rotate;
				
			    break;
			}
		}
		
		if (not ROOMLOADER_MERGE_TILEMAPS) {
			__ROOMLOADER_TILEMAP_CREATE_TRANSFORMED_RAW;
			return _tilemap;
		}
		
		var _hostTilemap = layer_tilemap_get_id(_layer);
		if ((_hostTilemap == -1) or (tilemap_get_tileset(_hostTilemap) != _tileset)) {
			//show_message("can't merge, create new");
			__ROOMLOADER_TILEMAP_CREATE_TRANSFORMED_RAW;
			return _tilemap;
		}
		
		//show_message("merge");
		__ROOMLOADER_TILEMAP_PROCESS_MERGE;
		
	    var _i = 0; repeat (__n) {
	        var _t = tiles[_i + 2];
			
			var _xStart = (tiles[_i] * _xScale) + _mirrorOffset;
		    _t ^= _mirror * tile_mirror;
			
			var _yStart = (tiles[_i + 1] * _yScale) + _flipOffset;
		    _t ^= _flip * tile_flip;
			
			var _rx = (_mat00 * _xStart) + (_mat01 * _yStart) + _rotXOffset;
		    var _ry = (_mat10 * _xStart) + (_mat11 * _yStart) + _rotYOffset;
			_t ^= _rotFlag;
			
	        tilemap_set(_hostTilemap, _t, _rx + _newShiftI, _ry + _newShiftJ);
			
	        _i += __ROOMLOADER_TILE_STEP;
	    }
		
	    return _hostTilemap;
	};

	static __GetData = function() {
		return {tileset, width, height, tiles};
	};
}
