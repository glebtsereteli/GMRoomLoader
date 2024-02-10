/// @desc Methods
event_inherited();

init = function() {
	update();	
};
update = function() {
	image_angle = sine_between(t++ mod duration, duration, vd_angle_from, vd_angle_to);
};
