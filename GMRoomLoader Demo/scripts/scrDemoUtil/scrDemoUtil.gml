/// @feather ignore all

#macro EVENT_CONSTRUCTOR event_user(13)
#macro EVENT_METHOD event_user(14)
#macro FPS game_get_speed(gamespeed_fps)
#macro CONTROL objDemoControl

#macro DEMO_PAYLOAD global.__demoPayload
DEMO_PAYLOAD = undefined;

#macro BENCH_START global.__benchmarkTime = get_timer();
#macro BENCH_END ((get_timer() - global.__benchmarkTime) / 1000)

function Noop() {}
function SineBetween(_time, _duration, _from, _to) {
	static _2pi = (pi * 2);
    var _midpoint = mean(_from, _to);
    var _amplitude = _to - _midpoint;
    return ((sin(_time * _2pi / _duration) * _amplitude) + _midpoint);
}
function LerpAngle(_a, _b, _amount) {
    return (_a + (angle_difference(_b, _a) * _amount));
}
function Mod2(_dividend, _divisor) {
    return (_dividend - floor(_dividend / _divisor) * _divisor);
}
function DrawSpriteOrigin(_sprite, _subimg, _x, _y, _xOrigin, _yOrigin, _xScale = 1, _yScale = 1, _angle = 0, _color = c_white, _alpha = 1) {
	_xOrigin -= sprite_get_xoffset(_sprite);
	_yOrigin -= sprite_get_yoffset(_sprite);
	_x -= ((lengthdir_x(_xOrigin, _angle)) + (lengthdir_x(_yOrigin, _angle - 90)));
	_y -= ((lengthdir_y(_xOrigin, _angle)) + (lengthdir_y(_yOrigin, _angle - 90)));
	draw_sprite_ext(_sprite, _subimg, floor(_x), floor(_y), _xScale, _yScale, _angle, _color, _alpha);
}

function DemoDbgTransform(_label) {
	dbg_text_separator(_label, 1);
	dbg_slider(ref_create(self, "xScale"), -2, 2, "X Scale", 0.1);
	dbg_same_line();
	dbg_button("Mirror", function() {
		xScale *= -1;
	}, 68, 19);
	dbg_slider(ref_create(self, "yScale"), -2, 2, "Y Scale", 0.1);
	dbg_same_line();
	dbg_button("Flip", function() {
		yScale *= -1;
	}, 68, 19);
	dbg_slider_int(ref_create(self, "angle"), -180, 180, "Angle", 10);
	dbg_same_line();
	dbg_button("-90", function() {
		angle -= 90;
		if (angle < -180) {
			angle = 180;
		}
	}, 30, 19);
	dbg_same_line();
	dbg_button("+90", function() {
		angle += 90;
		if (angle > 180) {
			angle = -180;
		}
	}, 30, 19);
}
function DemoDrawFrame(_room, _px, _py, _origin, _scale = 1, _transposed = false) {
	var _wBase = RoomLoader.DataGetWidth(_room);
	var _hBase = RoomLoader.DataGetHeight(_room);
	var _w = (_transposed ? _hBase : _wBase) * _scale;
	var _h = (_transposed ? _wBase : _hBase) * _scale;
	var _x = floor(_px - (_w * _origin.x));
	var _y = floor(_py - (_h * _origin.y));
	draw_sprite_stretched(sprDemoFrame, 0, _x, _y, _w, _h);
	draw_sprite(sprDemoCross, 0, _px, _py);
}
