// feather ignore all

function DemoModulePos() constructor {
	static reloaderNames = ["x", "y"];
	
	x = undefined;
	y = undefined;
	
	static InitDbg = function() {
		x = objDemoControl.centerX;
		y = objDemoControl.centerY;
		
		dbg_text_separator("Position");
		dbg_slider_int(ref_create(self, "x"), 0, room_width, "X", 10);
		dbg_slider_int(ref_create(self, "y"), 0, room_height, "Y", 10);
	};
}
