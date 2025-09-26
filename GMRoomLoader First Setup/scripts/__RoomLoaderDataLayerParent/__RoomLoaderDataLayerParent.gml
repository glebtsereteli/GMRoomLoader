/// feather ignore all

function __RoomLoaderDataLayerParent(_layerData) constructor {
	static __flag = undefined;
	static __tile = false;
	
	__owner = other;
	__layerData = _layerData;
	
	static __Init = function() {
		__OnInit();
	};
	static __Load = function(_x, _y, _flags) {
		__ROOMLOADER_LOAD_LAYER_START;
		__OnLoad(_layer, _x, _y, _flags);
	};
	static __LoadTransformed = function(_x, _y, _flags, _xScale, _yScale, _angle, _sin, _cos, _xOrigin, _yOrigin) {
		__ROOMLOADER_LOAD_LAYER_START;
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
