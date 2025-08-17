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
		
		__tilesData = array_create(_n);
		var _count = 0;
		
		var _i = 0; repeat (_n) {
		    var _data = _tilesData[_i];
		    if (_data > 0) {
		        __tilesData[_count] = {
		            data: _data,
		            x: _i mod __width,
		            y: _i div __width,
		        };
		        _count++;
		    }
			_i++;
		}
		
		array_resize(__tilesData, _count);
	};
	static __OnLoad = function(_layer, _xOffset, _yOffset) {
		var _tilemap = __CreateTilemap(_layer, _xOffset, _yOffset);
		if (ROOMLOADER_USE_RETURN_DATA) {
			RoomLoader.__returnData.__tilemaps.__Add(_tilemap, __tilemapData.name);
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
	__tileset = undefined;
	__width = undefined;
	__height = undefined;
	
	static __CreateTilemap = function(_layer, _x, _y) {
		var _tilemap = layer_tilemap_create(_layer, _x, _y, __tileset, __width, __height);
		var _i = 0; repeat (array_length(__tilesData)) {
			with (__tilesData[_i]) {
				tilemap_set(_tilemap, data, x, y);
			}
			_i++;
		}
		return _tilemap;
	};
}
