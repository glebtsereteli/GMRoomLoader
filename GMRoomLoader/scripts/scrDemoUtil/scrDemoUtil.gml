
#macro EVENT_CONSTRUCTOR event_user(13)
#macro EVENT_METHOD event_user(14)
#macro FPS game_get_speed(gamespeed_fps)
#macro CONTROL obj_demo_control

#macro DEMO_ROOM_DATA global.__demo_room_data
DEMO_ROOM_DATA = undefined;

#macro BENCH_START global.__benchmark_t = get_timer();
#macro BENCH_END ((get_timer() - global.__benchmark_t) / 1000)

function noop() {}
function sine_between(_time, _duration, _from, _to) {
	static _2pi = (pi * 2);
    var _midpoint = mean(_from, _to);
    var _amplitude = _to - _midpoint;
    return ((sin(_time * _2pi / _duration) * _amplitude) + _midpoint);
}
function lerp_angle(_a, _b, _amount) {
    return (_a + (angle_difference(_b, _a) * _amount));
}
function mod2(_dividend, _divisor) {
    return (_dividend - floor(_dividend / _divisor) * _divisor);
}
function draw_sprite_origin(_sprite, _subimg, _x, _y, _xOrigin, _yOrigin, _xScale = 1, _yScale = 1, _angle = 0, _color = c_white, _alpha = 1) {
	_xOrigin -= sprite_get_xoffset(_sprite);
	_yOrigin -= sprite_get_yoffset(_sprite);
	_x -= ((lengthdir_x(_xOrigin, _angle)) + (lengthdir_x(_yOrigin, _angle - 90)));
	_y -= ((lengthdir_y(_xOrigin, _angle)) + (lengthdir_y(_yOrigin, _angle - 90)));
	draw_sprite_ext(_sprite, _subimg, floor(_x), floor(_y), _xScale, _yScale, _angle, _color, _alpha);
}

function demo_draw_frame(_room, _px, _py, _origin, _scale = 1) {
	var _w = RoomLoader.DataGetWidth(_room) * _scale;
	var _h = RoomLoader.DataGetHeight(_room) * _scale;
	var _x = floor(_px - (_w * _origin.x));
	var _y = floor(_py - (_h * _origin.y));
	draw_sprite_stretched(sprDemoFrame, 0, _x, _y, _w, _h);
	draw_sprite(sprDemoCross, 0, _px, _py);
}
