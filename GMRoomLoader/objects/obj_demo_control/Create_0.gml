
room_goto(rm_demo_base);

var _pad = 8;
var _x = _pad;
var _y = _pad + 19;
var _w = 400;
var _h = window_get_height() - _y - _pad;
dbg_view($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} Demo", true, _x, _y, _w, _h);
