
tick = random(180);

Update = function() {
	x = xstart + Sine(tick, 180, 64);
	y = ystart + Sine(tick, 90, 16);
	
	var _dir = x - xprevious;
	if (_dir != 0) {
		image_xscale = sign(_dir);
	}
};

Update();
