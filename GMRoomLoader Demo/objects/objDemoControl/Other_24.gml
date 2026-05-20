/// @desc Methods

RefreshInterface = function() {
	static _view = undefined;
	
	var _pad = 8;
	var _x = _pad;
	var _y = _pad + 19;
	var _w = 530;
	var _h = window_get_height() - _y - _pad;
	
	x1 = _x + _w + _pad;
	y1 = _y;
	x2 = room_width - _pad;
	y2 = room_height - _pad;
	centerX = mean(x1, x2);
	centerY = mean(y1, y2);
	w = x2 - x1;
	h = y2 - y1;
	
	if (_view != undefined) {
		dbg_view_delete(_view);
	}
	
	_view = dbg_view($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} Demo", true, _x, _y, _w, _h);
	
	dbg_section("Meta");
	static _indices = array_create_ext(n, function(_i) {
		pool[_i].Setup(_i);
		return _i;
	});
	static _names = array_map(pool, function(_demo) {
		return _demo.iname;
	});
	dbg_drop_down(ref_create(self, "prevIndex"), _indices, _names, "Demo (cycle with Left/Right)");
	
	var _size = 19;
	dbg_same_line();
	dbg_button("-", function() { Change(index - 1); }, _size, _size);
	dbg_same_line();
	dbg_button("+", function() { Change(index + 1); }, _size, _size);
	
	var _w = 109;
	dbg_button("GitHub", function() { url_open("https://github.com/glebtsereteli/GMRoomLoader"); }, _w, _size);
	dbg_same_line();
	dbg_button("Last Release", function() { url_open($"https://github.com/glebtsereteli/GMRoomLoader/releases/tag/{__ROOMLOADER_VERSION}"); }, _w, 20);
	dbg_same_line();
	dbg_button("Docs", function() { url_open("https://GlebTsereteli.github.io/GMRoomLoader"); }, _w, _size);
	dbg_same_line();
	dbg_button("Itch", function() { url_open("https://glebtsereteli.itch.io/gmroomloader"); }, _w, _size);
};
Change = function(_index) {
	_index = Mod2(_index, n);
	reloader.Clear();
	GetCurrent().Cleanup();
	index = _index;
	prevIndex = index;
	
	RefreshInterface();
	GetCurrent().Init();
	
	window_set_caption($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo: {GetCurrent().iname}");
};
GetCurrent = function() {
	return pool[index];
};
