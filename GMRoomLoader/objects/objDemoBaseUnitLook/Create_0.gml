event_inherited();

duration = (FPS * irandom_range(2, 3));
t = irandom(duration);

Update = function() {
	image_angle = sine_between(t++ mod duration, duration, vdAngleFrom, vdAngleTo);
};

Update();
