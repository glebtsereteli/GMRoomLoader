/// @feather ignore all

function __RoomLoaderDataLayerTile(_layerData, _elementsData) : __RoomLoaderDataLayerParent(_layerData) constructor {
	// shared
	static __flag = ROOMLOADER_FLAG.TILEMAPS;
	
	static __OnInit = function() {
		__tileset = __tilemapData.tileset_index;
		__width = __tilemapData.width;
		__height = __tilemapData.height;
		
		var _tilesData = __tilemapData.tiles;
		var _n = array_length(_tilesData);
		
		__tilesData = array_create(_n * __ROOMLOADER_TILE_STEP);
		var _count = 0;
		
		var _i = 0; repeat (_n) {
		    var _data = _tilesData[_i];
		    if (_data > 0) {
			    __tilesData[_count++] = _data;
			    __tilesData[_count++] = _i mod __width;
			    __tilesData[_count++] = _i div __width;
		    }
			_i++;
		}
		
		array_resize(__tilesData, _count);
		__n = _count / __ROOMLOADER_TILE_STEP;
		
		__owner.__tilemapsLut[$ __layerData.name] = self;
	};
	static __OnLoad = function(_layer, _xOffset, _yOffset) {
		var _tilemap = __CreateTilemap(_layer, _xOffset, _yOffset);
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__tilemaps.__Add(_tilemap, __tilemapData.name);
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
	__tilesData = [];
	__n = undefined;
	__tileset = undefined;
	__width = undefined;
	__height = undefined;
	
	static __CreateTilemap = function(_layer, _x, _y) {
	    var _tilemap = layer_tilemap_create(_layer, _x, _y, __tileset, __width, __height);
		
	    var _data = __tilesData;
		var _i = 0; repeat (__n) {
			tilemap_set(_tilemap, _data[_i], _data[_i + 1], _data[_i + 2]);
			_i += __ROOMLOADER_TILE_STEP;
		}
		
	    return _tilemap;
	};
	static __CreateTilemapExt = function(_layer, _x, _y) {
	    var _tilemap = layer_tilemap_create(_layer, _x, _y, __tileset, __width, __height);
		
	    var _data = __tilesData;
		var _i = 0; repeat (__n) {
			tilemap_set(_tilemap, _data[_i], _data[_i + 1], _data[_i + 2]);
			_i += __ROOMLOADER_TILE_STEP;
		}
		
	    return _tilemap;
	};
}
