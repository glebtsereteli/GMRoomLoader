// feather ignore all

function DemoModuleOrigin(_x = 0.5, _y = 0.5) constructor {
	static reloaderNames = ["x", "y"];
	
	x = _x;
	y = _y;
	
	static InitDbg = function() {
		dbg_text_separator("Origin");
		dbg_slider(ref_create(self, "x"), 0, 1, "X", 0.05);
		dbg_slider(ref_create(self, "y"), 0, 1, "Y", 0.05);
	};
}
