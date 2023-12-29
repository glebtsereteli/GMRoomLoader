
#macro EVENT_METHOD event_user(14)

function round_to(_value, _increment) {
	return (round(_value / _increment) * _increment);
}
function remap(value, left1, right1, left2, right2) {
	return left2 + (value - left1) * (right2 - left2) / (right1 - left1);
}