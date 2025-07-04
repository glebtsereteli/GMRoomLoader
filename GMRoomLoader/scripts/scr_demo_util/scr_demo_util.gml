
#macro EVENT_CONSTRUCTOR event_user(13)
#macro EVENT_METHOD event_user(14)
#macro FPS game_get_speed(gamespeed_fps)
#macro CONTROL obj_demo_control

#macro DEMO_ROOM_DATA global.__demo_room_data
DEMO_ROOM_DATA = undefined;

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
