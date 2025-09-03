
function DemoInstances() : DemoPar("Instances") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInit(rm);
		
		// Interface:
		dbg_section("Info");
		dbg_text("This is an example of using \"RoomLoader.LoadInstances()\" to load\nroom instances with optional scale and rotation.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to Load the room.");
		dbg_text("- [PRESS 2] to clean up the room.");
		
		dbg_section("Controls");
		dbg_button("Load", function() {
			Load();
		});
		dbg_same_line();
		dbg_button("Clean Up", function() {
			Unload();
		});
		
		pos.InitDbg();
		origin.InitDbg();
		DemoDbgTransform("Room Transform");
		
		dbg_text_separator("Instance Transform", 1)
		dbg_checkbox(ref_create(self, "scaleMultiplicative"), "Multiplicative Scale");
		dbg_text(" - When enabled, individual instance \"image_x/yScale\" is multiplied by\n the overall load xScale/yScale. Change the X/Y Scale parameters above\n and toggle this on/off to see it in action.");
		dbg_text("");
		dbg_checkbox(ref_create(self, "angleAdditive"), "Additive Angle");
		dbg_text(" - When enabled, individual instance \"image_angle\" is combined with\n the overall angle. Change the Angle parameter above and toggle this\n on/off to see it in action.");
	
		// Reloader:
		owner.reloader
		.AddVariables(self, ["xScale", "yScale", "angle", "scaleMultiplicative", "angleAdditive"])
		.AddModules([pos, origin])
		.OnTrigger(function() {
			Load();
		});
	};
	static Draw = function() {
		var _frame = sprDemoFrame;
		var _w = RoomLoader.DataGetWidth(rm) * xScale;
		var _h = RoomLoader.DataGetHeight(rm) * yScale;
		var _xOrigin = _w * origin.x;
		var _yOrigin = _h * origin.y;
		var _xScale = _w / sprite_get_width(_frame);
		var _yScale = _h / sprite_get_height(_frame);
		DrawSpriteOrigin(_frame, 0, pos.x, pos.y, _xOrigin, _yOrigin, _xScale, _yScale, angle);
		
		draw_sprite(sprDemoCross, 0, pos.x, pos.y);
	};
	
	static OnUpdate = function() {
		if (keyboard_check_pressed(ord("1"))) Load();
		if (keyboard_check_pressed(ord("2"))) Unload();
	};
	static OnCleanup = function() {
		RoomLoader.DataRemove(rm);
		Unload();
	};
	
	// Custom:
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
	xScale = 1;
	yScale = 1;
	angle = 0;
	scaleMultiplicative = true;
	angleAdditive = true;
	
	rm = rmDemoInstances01;
	instances = undefined;
	
	static Load = function() {
		Unload();
		instances = RoomLoader
		.Origin(origin.x, origin.y)
		.LoadInstances(rm, pos.x, pos.y, 0,,, xScale, yScale, angle, scaleMultiplicative, angleAdditive);
	};
	static Unload = function() {
		if (instances == undefined) return;
		
		array_foreach(instances, function(_inst) {
			instance_destroy(_inst);
		});
		delete instances;
	};
}
