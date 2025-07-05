event_inherited();

duration = (FPS * irandom_range(2, 3));
t = irandom(duration);

update = function() {
	image_angle = sine_between(t++ mod duration, duration, vd_angle_from, vd_angle_to);
};

update();
