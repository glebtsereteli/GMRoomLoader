/// @feather ignore all

function __RoomLoaderDataLayerParent(_layerData) constructor {
	__owner = other;
	__layerData = _layerData;
	
	static __Init = function() {
		__OnInit();
	};
	static __Load = function(_xOffset, _yOffset, _flags) {
		if (not __RoomLoaderCheckFlag(_flags)) return;
		if (__HasFailedFilters()) return;
		
		var _layer = __RoomLoaderGetLayer(__layerData);
		
		if (ROOMLOADER_DELIVER_PAYLOAD) {
			RoomLoader.__payload.__layers.__Add(_layer, __layerData.name);
		}
		
		__OnLoad(_layer, _xOffset, _yOffset, _flags);
	};
	static __Draw = function(_flags) {
		if (not __layerData.visible) return;
		if (not __RoomLoaderCheckFlag(_flags)) return;
		if (__HasFailedFilters()) return;
		__OnDraw();
	};
	
	static __HasFailedFilters = function() {
		return RoomLoader.__LayerFailedFilters(__layerData.name);
	};
	
	static __OnInit = __RoomLoaderNoop;
	static __OnLoad = __RoomLoaderNoop;
	static __OnDraw = __RoomLoaderNoop;
}
